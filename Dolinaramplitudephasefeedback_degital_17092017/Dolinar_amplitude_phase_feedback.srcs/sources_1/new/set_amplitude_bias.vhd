library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity set_amplitude_bias is
  Port (clk : in std_logic;
     clk_UART : in std_logic;
     RsRx : in  std_logic;
     ampdisdef: out STD_LOGIC_VECTOR(15 DOWNTO 0);
     ampdisoff: out STD_LOGIC_VECTOR(15 DOWNTO 0);
     ampdison: out STD_LOGIC_VECTOR(15 DOWNTO 0);
     setout : out  std_logic :='0';
     SGIN0: out std_logic_vector  (3 downto 0):= (others => '0');
     SGIN1: out std_logic_vector  (3 downto 0):= (others => '0');
     SGIN2: out std_logic_vector  (3 downto 0):= (others => '0');
     SGIN3: out std_logic_vector  (3 downto 0):= (others => '0');
     SGIN4: out std_logic_vector  (3 downto 0):= (others => '0');
     SGIN5: out std_logic_vector  (3 downto 0):= (others => '0');
     SGIN6: out std_logic_vector  (3 downto 0):= (others => '0');
     SGIN7: out std_logic_vector  (3 downto 0):= (others => '0');
     finish : out  std_logic :='0'
      );
end set_amplitude_bias;

architecture Behavioral of set_amplitude_bias is

component ASCII_integer is 
 port (ascii  : in std_logic_vector (7 downto 0);
        int : out std_logic_vector (3 downto 0)
       );
end component;
------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
--COMPONENT div_gen_3
--  PORT (
--    aclk : IN STD_LOGIC;
--    s_axis_divisor_tvalid : IN STD_LOGIC;
--    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
--    s_axis_dividend_tvalid : IN STD_LOGIC;
--    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    m_axis_dout_tvalid : OUT STD_LOGIC;
--    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
--  );
--END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------
------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT div_gen_2
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

signal state_reg: std_logic_vector (2 downto 0):= (others => '0');
signal s_reg :  std_logic_vector(3 downto 0):= (others => '0');
signal n_reg :  std_logic_vector(2 downto 0):= (others => '0');
--assume that 5-byte is sent from PC change measure time "B=01000010" + 3*8 finish byte"#=00100011" bit required for buffer including 
--signal D : std_logic_vector (47 downto 0):= (others => '0');
signal d_reg : std_logic_vector (7 downto 0):= (others => '0');
signal J : std_logic:='0';


signal setout_reg : std_logic:='0';
signal dataout0_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout1_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout2_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout3_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal intout0 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout1 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout2 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout3 :  std_logic_vector (3 downto 0):= (others => '0');
signal int1000 :  integer;
signal int100 :  integer;
signal int10 :  integer;
signal int1:  integer;
signal W:  integer;
signal W2:  integer;
signal Wstd:  std_logic_vector (31 downto 0);
signal stage : std_logic_vector(2 downto 0):= (others => '0');
signal status: std_logic_vector  (4 downto 0):= (others => '0');
--signal s_axis_divisor_tvalid : std_logic :='0';
--signal s_axis_divisor_tdata :  std_logic_vector  (15 downto 0):= (others => '0');
--signal s_axis_dividend_tvalid : std_logic :='0';
--signal s_axis_dividend_tdata:  std_logic_vector  (31 downto 0):= (others => '0');
--signal m_axis_dout_tvalid: std_logic :='0';
--signal m_axis_dout_tdata :  std_logic_vector  (47 downto 0):= (others => '0');
signal Vquotient : std_logic_vector (31 downto 0);
signal Vreminder : std_logic_vector (7 downto 0);


signal D : std_logic_vector (39 downto 0):= (others => '0');
signal s_axis_divisor_tvalid : std_logic :='0';
signal s_axis_divisor_tdata :  std_logic_vector  (7 downto 0):= (others => '0');
signal s_axis_dividend_tvalid : std_logic :='0';
signal s_axis_dividend_tdata:  std_logic_vector  (31 downto 0):= (others => '0');
signal m_axis_dout_tvalid: std_logic :='0';
signal m_axis_dout_tdata :  std_logic_vector  (39 downto 0):= (others => '0');


signal setampdef: std_logic :='0';
signal setampon: std_logic :='0';
signal setampoff: std_logic :='0';
signal setampdef_reg: std_logic :='0';
signal setampon_reg: std_logic :='0';
signal setampoff_reg: std_logic :='0';

begin

idiv_gen: div_gen_2
  PORT MAP (
    aclk => clk,
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => s_axis_divisor_tdata,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => s_axis_dividend_tdata,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tdata => m_axis_dout_tdata
  );
  
setout<=setout_reg;

process (clk_UART) 
begin
if (clk_UART'event and clk_UART = '1') then
    case state_reg is       
        when "000"=>
            d_reg<=(others=>'0');
            s_reg<= (others => '0');
            n_reg<= (others => '0');
            if (RsRx='0') then
               state_reg<="001";
            else 
               state_reg<="000";
            end if; 
       when "001"=>
            if (s_reg=7) then
                state_reg<="010";
                s_reg<=(others=>'0');
            else
                state_reg<="001";
                s_reg<=s_reg+1;
            end if;
       when "010"=>
           if (s_reg=15) then        
               d_reg<=RsRx & d_reg(7 downto 1);
               D<=RsRx & D(39 downto 1);
               s_reg<=(others=>'0');
               if (n_reg = 7) then
                   state_reg<="011";
                   n_reg<=(others=>'0');
               else 
                   n_reg<=n_reg+1;
                   state_reg<="010";
               end if;          
           else
               s_reg<=s_reg+1;
               state_reg<="010";
           end if;
       when "011"=>
                if (s_reg=15) then               
                    s_reg<=(others=>'0');
                    if (d_reg="00100011") then
                        state_reg<="100";
                    elsif (d_reg="01100100") then
                        state_reg<="000";
                        setampdef_reg<='1';
                        J<='1';     
                    elsif (d_reg="01101110") then
                        state_reg<="000";
                        setampon_reg<='1'; 
                        J<='1';    
                    elsif (d_reg="01100110") then
                        state_reg<="000";
                        setampoff_reg<='1';     
                        J<='1';                 
                    else 
                        state_reg<="000";
                    end if;
                else
                    s_reg<=s_reg+1;
                    state_reg<="011";
                end if;
       when "100" => 
               if (J='1') then
                   dataout0_reg<=D (15 downto 8);
                   dataout1_reg<=D (23 downto 16);
                   dataout2_reg<=D (31 downto 24);
                   setout_reg<='1';
                   state_reg<="101";
               else
                   state_reg<="101";
                   setout_reg<='0';
               end if;
       when "101" =>
               D<=(others=>'0');
               state_reg<="000";
               J<='0';
               setout_reg<='0';
               setampdef_reg<='0';
               setampoff_reg<='0';
               setampon_reg<='0';
       when others => state_reg<="000";
       end case; 
  end if;
end process;         


iASCII_integer0 : ASCII_integer port map(ascii=> dataout0_reg , int=>intout0); 
iASCII_integer1 : ASCII_integer port map(ascii=> dataout1_reg , int=>intout1);
iASCII_integer2 : ASCII_integer port map(ascii=> dataout2_reg , int=>intout2);

--set total counting time ms
process (setout_reg,clk,setampdef_reg,setampon_reg,setampoff_reg) begin
if (clk'event and clk = '1') then
case stage is
when "000"=>
    if (setout_reg='1') then
        finish<='0';
        --1000‚ÌˆÊ 
        int100 <=  CONV_INTEGER(unsigned(intout0)) *100;
        --100‚ÌˆÊ 
        int10 <=  CONV_INTEGER(unsigned(intout1)) *10;
        --10‚ÌˆÊ 
        int1 <= CONV_INTEGER(unsigned(intout2)) *1;
        SGIN0 <= "0000";
        SGIN1 <= "0000";
        SGIN2 <= "0000";
        SGIN3 <= "0000";
        SGIN4 <= "0000";
        SGIN5<=intout0;
        SGIN6<=intout1;
        SGIN7<=intout2;
         stage<=stage+1;
        if (setampdef_reg='1') then
            setampdef<='1';
            setampon<='0';
            setampoff<='0';
        elsif (setampon_reg='1') then
            setampdef<='0';
            setampon<='1';    
            setampoff<='0';
        elsif (setampoff_reg='1') then
            setampdef<='0';
            setampon<='0';
            setampoff<='1';    
        end if;                
    end if;
when "001"=>
    W<=int1+int10+int100;
    stage<=stage+1;
when "010"=>
    W2<=W*65536;
    stage<=stage+1;
when "011"=>
    Wstd<=conv_std_logic_vector(W2,32);
    stage<=stage+1;
when "100"=>
   case status is
   when "00000" =>
       s_axis_divisor_tdata<="11111010"; 
       s_axis_dividend_tdata<=Wstd;    
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
          stage<=stage+1;
          finish<='0';
        end if; 
   when others =>  status<="00000";
   end case; 
when  "101"=>
    if (setampdef='1') then
        ampdisdef<= Vquotient(15 downto 0);
    elsif (setampon='1') then
        ampdison<= Vquotient(15 downto 0);
    elsif (setampoff='1') then
        ampdisoff<= Vquotient(15 downto 0);
    end if;
    finish<='1';
    stage<=(others=>'0');
when others =>  stage<=(others=>'0');     
end case;
end if;
end process;

        
end Behavioral;
