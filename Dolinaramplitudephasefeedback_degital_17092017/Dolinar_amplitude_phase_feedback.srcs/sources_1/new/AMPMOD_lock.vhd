library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity AMPMOD_lock is
  Port (
  clk: in std_logic;
  sw: in std_logic;
  expectedcount : std_logic_vector(31 downto 0):= (others => '0');
  APDcount : std_logic_vector(31 downto 0):= (others => '0');
  lockmode: in std_logic:= '0';
  updatewavelock: out std_logic;
  Vout : out std_logic_vector (15 downto 0):= (others => '0');
  Vbiasset : in std_logic_vector (15 downto 0);
  cntdoneAPD: in std_logic;
  WP : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  WI : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  Wr : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  polarity : in integer range -1 to 1 := 1
   );
end AMPMOD_lock;

architecture Behavioral of AMPMOD_lock is


--------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT div_gen_1
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(39 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

signal state_reg : std_logic_vector(3 downto 0):= (others => '0');
signal status: std_logic_vector  (4 downto 0):= (others => '0');
signal saturated :  std_logic;



signal gainpint : integer range 0 to 100;
signal gainiint : integer range 0 to 100;
signal rint : integer range 0 to 100;
signal interrorsig : integer:=0;

signal gperrorsig : integer:=0;
signal giinterrorsig : integer:=0;


signal expectedcountint : integer;
signal APDcountint : integer;
signal errorsig : integer:=0;
signal sumgpgi : integer:=0;
signal Voutp : integer:=0;
signal Voutpstd : std_logic_vector (31 downto 0):= (others => '0');

signal s_axis_divisor_tdata :  std_logic_vector  (7 downto 0):= (others => '0');
signal s_axis_dividend_tdata:  std_logic_vector  (31 downto 0):= (others => '0');
signal s_axis_divisor_tvalid : std_logic :='0';
signal s_axis_dividend_tvalid : std_logic :='0';
signal m_axis_dout_tvalid: std_logic :='0';
signal m_axis_dout_tdata :  std_logic_vector  (39 downto 0):= (others => '0');

signal Vquotient : std_logic_vector (31 downto 0);
signal Vreminder : std_logic_vector (7 downto 0);
signal Vbiasset_reg : std_logic_vector (15 downto 0):="0110011001100110";
signal Voutint :  std_logic_vector (31 downto 0):= (others => '0');
signal setpointbias:  std_logic;

signal holdstage: integer;


begin


idiv_gen: div_gen_1
  PORT MAP (
    aclk => clk,
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => s_axis_divisor_tdata,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => s_axis_dividend_tdata,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tdata => m_axis_dout_tdata
  );
  
gainpint<=CONV_INTEGER(unsigned(WP));
gainiint<=CONV_INTEGER(unsigned(WI));
rint<=CONV_INTEGER(unsigned(Wr));
process ( cntdoneAPD,clk,sw,Vbiasset) begin
if (sw='1') then
    state_reg<="0000";
    status<="00000";
    updatewavelock<='0';
    interrorsig<=0;
    Vout<=Vbiasset;
    saturated<='0';
else    
if (clk'event and clk = '1') then
if (lockmode='0') then
    state_reg<="0000";
    status<="00000";
    updatewavelock<='0';
--    interrorsig<=0;
    saturated<='0';
else    
    case state_reg is
        when "0000" =>
          if ( cntdoneAPD='1' ) then
             updatewavelock<='0';
             state_reg<="0001";
          else
             state_reg<="0000";
          end if;
        when "0001" =>
           updatewavelock<='0';
           expectedcountint<=CONV_INTEGER(unsigned(expectedcount));
           APDcountint<=CONV_INTEGER(unsigned(APDcount));
           state_reg<="0010";
        when "0010" =>   
           errorsig<=APDcountint- expectedcountint;
           state_reg<="0011";
        when "0011" => 
           interrorsig<=errorsig+interrorsig;  
           state_reg<="0100";
        when "0100" =>   
           gperrorsig<=errorsig * gainpint;
           giinterrorsig<=interrorsig * gainiint;
           state_reg<="0101"; 
        when "0101" =>    
           sumgpgi<=gperrorsig+giinterrorsig;
           state_reg<="0110";
        when "0110" =>             
           Voutp<=polarity * sumgpgi;
           state_reg<="0111";
        when "0111" =>  
           Voutpstd<=conv_std_logic_vector( Voutp,32);
           state_reg<="1000";
        when "1000" => 
           case status is
           when "00000" =>
               s_axis_divisor_tdata<=Wr(7 downto 0); 
               s_axis_dividend_tdata<=Voutpstd;    
               status<="00001";
           when "00001" =>
               s_axis_divisor_tvalid<='1';
               s_axis_dividend_tvalid<='1';
               status<="00010";
           when "00010" =>
               if (m_axis_dout_tvalid='1') then
                  s_axis_divisor_tvalid<='0';
                  s_axis_dividend_tvalid<='0';
                  status<="00011";
               end if;            
           when "00011" =>
                if (m_axis_dout_tvalid='0') then
--                39-8 =>quotient 7-0 => reminder
                  Vquotient <=m_axis_dout_tdata(39 downto 8);
                  Vreminder <=m_axis_dout_tdata(7 downto 0);
                  status<="00000";
                  state_reg<="1001";
                end if; 
           when others =>  status<="00000";
           end case; 
        when "1001" =>
            Voutint<=  Vquotient+Vbiasset_reg;
            state_reg<="1010";
        when "1010" =>       
            if (Voutint <=65535 and Voutint >=0) then
              state_reg<="1011";
              Vout<=Voutint(15 downto 0);
            else
              if (setpointbias='0') then
                Vbiasset_reg<="0110011001100110";
                setpointbias<='1';
              else
                Vbiasset_reg<="0000000000000110";
                setpointbias<='0';
              end if;
              interrorsig<=0; 
              state_reg<="0001";
            end if;             
        when "1011" =>   
--            if (holdstage=1000) then               
                updatewavelock<='1';
                state_reg<=state_reg+1;
--                holdstage<=0;
--            else 
--                updatewavelock<='0';
--                holdstage<=holdstage+1;
--            end if;      
        when "1100" =>
            state_reg<="0000";            
        when others =>  state_reg<="0000";
        end case;
    end if;
end if;    
end if;
end process;

end Behavioral;
