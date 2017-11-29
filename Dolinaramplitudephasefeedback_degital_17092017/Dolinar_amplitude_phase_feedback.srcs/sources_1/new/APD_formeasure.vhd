library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.numeric_std.ALL;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--pulse length = clock(100MHz) * Maximum I
entity APD_formeasure is
  Port (sw : in std_logic;
       clk : in std_logic;
       RsRx : in  std_logic;
       Run : in  std_logic;
       JC: inout std_logic_vector (7 downto 0);
       VADC : out std_logic_vector (31 downto 0):= (others => '0');
       AMPascii0: out std_logic_vector (7 downto 0):= (others => '0');
       AMPascii1: out std_logic_vector (7 downto 0);
       AMPascii2: out std_logic_vector (7 downto 0);
       AMPascii3: out std_logic_vector (7 downto 0);
       AMPascii4: out std_logic_vector (7 downto 0);
       AMPascii5: out std_logic_vector (7 downto 0);
       AMPascii6: out std_logic_vector (7 downto 0);
       AMPascii7: out std_logic_vector (7 downto 0);
       AMPSGIN0: out std_logic_vector  (3 downto 0):= (others => '0');
       AMPSGIN1: out std_logic_vector  (3 downto 0):= (others => '0');
       AMPSGIN2: out std_logic_vector  (3 downto 0):= (others => '0');
       AMPSGIN3: out std_logic_vector  (3 downto 0):= (others => '0');
       AMPSGIN4: out std_logic_vector  (3 downto 0):= (others => '0');
       AMPSGIN5: out std_logic_vector  (3 downto 0):= (others => '0');
       AMPSGIN6: out std_logic_vector  (3 downto 0):= (others => '0');
       AMPSGIN7: out std_logic_vector  (3 downto 0):= (others => '0');
       AMPcountDIS: out  std_logic;
       change: out  std_logic
               );
end APD_formeasure;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
architecture Behavioral of APD_formeasure is

--component UART_receiver_formeasure is 
-- port (clkoriginal : in std_logic;
--       clk_UART : in std_logic;
--       RsRx : in  std_logic;
--       dataoutm1: out std_logic_vector (3 downto 0):= (others => '0');
--       dataout0 : out std_logic_vector (3 downto 0):= (others => '0');
--       dataout1 : out std_logic_vector (3 downto 0):= (others => '0');
--       dataout2 : out std_logic_vector (3 downto 0):= (others => '0');
--       dataout3 : out std_logic_vector (3 downto 0):= (others => '0');
--       dataout4 : out std_logic_vector (3 downto 0):= (others => '0');
--       dataout5 : out std_logic_vector (3 downto 0):= (others => '0');
--       dataout6 : out std_logic_vector (3 downto 0):= (others => '0');
--       dataout7 : out std_logic_vector (3 downto 0):= (others => '0');
--       setout : out  std_logic :='0';
--       AMPsetout : out  std_logic :='0'
--       );
--end component;

--component clk_UART_receiver is 
-- port (clk_i :in std_logic;
--       clk_o :out std_logic
--       );
--end component;

component integer_ASCII is 
 port (ascii  : out std_logic_vector (7 downto 0);
        int : in std_logic_vector (3 downto 0)
       );
end component;

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT div_gen_0
  PORT (
    aclk : IN STD_LOGIC;
  s_axis_divisor_tvalid : IN STD_LOGIC;
  s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
  s_axis_dividend_tvalid : IN STD_LOGIC;
  s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  m_axis_dout_tvalid : OUT STD_LOGIC;
  m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------
------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT div_gen_4
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(55 DOWNTO 0)
  );
END COMPONENT;

component Analog_digital_conv 
Port (
    startADC :in std_logic;
    stopADC: in std_logic;
    led : out std_logic_vector (15 downto 0):= (others => '0');
    clk : in std_logic;
    JC: inout  std_logic_vector (7 downto 0);
    update: out std_logic
       );
end component;



-- COMP_TAG_END ------ End COMPONENT Declaration ------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
signal I : std_logic_vector(32 downto 0):= (others => '0');
signal j : std_logic_vector(2 downto 0):= (others => '0');

signal countnum : integer;
signal cnt : std_logic_vector(32 downto 0):= (others => '0');

signal clk_U : std_logic;
signal DOUTm1  : std_logic_vector (3 downto 0);
signal DOUT0  : std_logic_vector (3 downto 0);
signal DOUT1  : std_logic_vector (3 downto 0);
signal DOUT2  : std_logic_vector (3 downto 0);
signal DOUT3  : std_logic_vector (3 downto 0);
signal DOUT4  : std_logic_vector (3 downto 0);
signal DOUT5  : std_logic_vector (3 downto 0);
signal DOUT6  : std_logic_vector (3 downto 0);
signal DOUT7  : std_logic_vector (3 downto 0);



signal W  : std_logic_vector (32 downto 0):= (others => '0');
signal SO  : std_logic :='0';


signal AMPI : std_logic_vector(32 downto 0):= (others => '0');
signal AMPj : std_logic_vector(2 downto 0):= (others => '0');

signal AMPcountnum : integer;
signal AMPcnt : std_logic_vector(32 downto 0):= (others => '0');

signal AMPint1  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPint10  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPint100  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPint1000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPint10000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPint100000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPint1000000  : std_logic_vector (32 downto 0):= (others => '0');



signal AMPcountDIS1000000: std_logic_vector (3 downto 0):= (others => '0');
signal AMPcountDIS100000: std_logic_vector (3 downto 0):= (others => '0');
signal AMPcountDIS10000: std_logic_vector (3 downto 0):= (others => '0');
signal AMPcountDIS1000: std_logic_vector (3 downto 0):= (others => '0');
signal AMPcountDIS100: std_logic_vector (3 downto 0):= (others => '0');
signal AMPcountDIS10: std_logic_vector (3 downto 0):= (others => '0');
signal AMPcountDIS1: std_logic_vector (3 downto 0):= (others => '0');

signal AMPp  : std_logic_vector (3 downto 0):= (others => '0');

signal AMPstartconv: std_logic :='0';
signal AMPcountDIS_reg: std_logic :='0';

signal AMPs_axis_divisor_tvalid : std_logic :='0';
signal AMPs_axis_divisor_tdata :  std_logic_vector  (23 downto 0):= (others => '0');
signal AMPs_axis_dividend_tvalid : std_logic :='0';
signal AMPs_axis_dividend_tdata:  std_logic_vector  (31 downto 0):= (others => '0');
signal AMPm_axis_dout_tvalid: std_logic :='0';
signal AMPm_axis_dout_tdata :  std_logic_vector  (55 downto 0):= (others => '0');
signal AMPVquotient : std_logic_vector (31 downto 0);
signal AMPVreminder : std_logic_vector (23 downto 0);
signal AMPt  : integer;

signal AMPrest: std_logic :='0';

signal AMPW  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPSO  : std_logic :='0';

signal stage  : std_logic_vector (3 downto 0):= (others => '0');
signal led_reg :  std_logic_vector(15 DOWNTO 0):= (others => '0');
signal update: std_logic :='0';
signal analogdata  : std_logic_vector (11 downto 0):= (others => '0');
constant Vref : std_logic_vector (15 downto 0):= "1000000011101000";
signal Vrefanalogdata_reg  : std_logic_vector (27 downto 0):= (others => '0');
signal Vrefanalogdata  : std_logic_vector (31 downto 0):= (others => '0');

signal s_axis_divisor_tvalid : std_logic :='0';
signal s_axis_divisor_tdata :  std_logic_vector(15 DOWNTO 0):= (others => '0');
signal s_axis_dividend_tvalid : std_logic :='0';
signal s_axis_dividend_tdata:  std_logic_vector(31 downto 0):= (others => '0');
signal m_axis_dout_tvalid: std_logic :='0';
signal m_axis_dout_tdata :  std_logic_vector  (47 downto 0):= (others => '0');
signal Vquotient : std_logic_vector (31 downto 0);
signal Vreminder : std_logic_vector (15 downto 0);

signal stopADC: std_logic :='0';
signal startADC: std_logic :='0';
signal cntADC : integer;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
begin
--iclk_UART: clk_UART_receiver port map(clk_i=>clk, clk_o=>clk_U);
--iUART: UART_receiver_formeasure port map(clkoriginal=> clk, clk_UART=>clk_U, RsRx=>RsRx,dataoutm1=>DOUTm1,dataout0=>DOUT0,dataout1=>DOUT1,dataout2=>DOUT2,dataout3=>DOUT3,dataout4=>DOUT4,dataout5=>DOUT5,dataout6=>DOUT6,dataout7=>DOUT7, setout=>SO, AMPsetout=>AMPSO);

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : div_gen_0
  PORT MAP (
    aclk => clk,
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => s_axis_divisor_tdata,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => s_axis_dividend_tdata,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tdata => m_axis_dout_tdata
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------


your_instance_name4 : div_gen_4
    PORT MAP (
      aclk => clk,
      s_axis_divisor_tvalid => AMPs_axis_divisor_tvalid,
      s_axis_divisor_tdata => AMPs_axis_divisor_tdata,
      s_axis_dividend_tvalid => AMPs_axis_dividend_tvalid,
      s_axis_dividend_tdata => AMPs_axis_dividend_tdata,
      m_axis_dout_tvalid => AMPm_axis_dout_tvalid,
      m_axis_dout_tdata => AMPm_axis_dout_tdata
    );


AMPiinteger_ASCII1: integer_ASCII port map(ascii=>AMPascii0 ,int=>AMPcountDIS1000000);
AMPiinteger_ASCII2: integer_ASCII port map(ascii=>AMPascii1 ,int=>AMPcountDIS100000);  
AMPiinteger_ASCII3: integer_ASCII port map(ascii=>AMPascii2 ,int=>AMPcountDIS10000);  
AMPiinteger_ASCII4: integer_ASCII port map(ascii=>AMPascii3 ,int=>AMPcountDIS1000);  
AMPiinteger_ASCII5: integer_ASCII port map(ascii=>AMPascii4 ,int=>AMPcountDIS100);  
AMPiinteger_ASCII6: integer_ASCII port map(ascii=>AMPascii5 ,int=>AMPcountDIS10);  
AMPiinteger_ASCII7: integer_ASCII port map(ascii=>AMPascii6 ,int=>AMPcountDIS1); 



iAnalog_digital_conv: Analog_digital_conv
Port map(
  startADC=>startADC,
  stopADC=>stopADC,
  led =>led_reg,
  clk =>clk,
  JC=>JC,
  update=>update
  ); 
process (clk) begin
if (clk'event and clk = '1') then
if (sw='1') then
    startADC <='1';
else
    startADC <='0';
end if;    
end if;
end process;     

change<=update;

process (clk) begin
if (clk'event and clk = '1') then
case stage is 
when "0000" =>
    AMPstartconv<='0';
    if (update='1') then
      stage <= stage+1;
      analogdata<=led_reg(11 downto 0);
    end if;
when "0001" =>
    Vrefanalogdata_reg <=Vref*analogdata;
    stage <= stage+1;
when "0010" =>
    Vrefanalogdata<="0000"&Vrefanalogdata_reg;
    stage <= stage+1;
when "0011" =>
    s_axis_divisor_tdata<="0001000000000000";
    s_axis_dividend_tdata<=Vrefanalogdata; 
    stage <= stage+1;
when "0100" =>    
    s_axis_divisor_tvalid<='1';
    s_axis_dividend_tvalid<='1';
    stage <= stage+1;
when "0101" =>    
    if (m_axis_dout_tvalid='1') then
        s_axis_divisor_tvalid<='0';
        s_axis_dividend_tvalid<='0';
        stage<=stage+1;
    end if;            
when "0110" =>    
         if (m_axis_dout_tvalid='0') then
        --                43-16 =>quotient 12-0 => reminder
          Vquotient <=m_axis_dout_tdata(47 downto 16);
        --                  Vsign<=m_axis_dout_tdata(39);
          Vreminder <=m_axis_dout_tdata(15 downto 0);
          stage<=stage+1;
          AMPstartconv<='1';
        end if; 
when "0111" =>    
     stage<="0000";
     VADC<=Vquotient;
when others => stage<="0000";
end case; 
end if;
end process;     
  

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------




----To show count on the 7-segment display
process (clk,AMPstartconv) begin
if (clk'event and clk = '1') then
case AMPp is
    when  "0000" =>
        AMPcountDIS<='0';
        AMPcountDIS_reg<='0';
        if (AMPstartconv='1') then   
            AMPp<=AMPp+1;
        else
            AMPp<="0000";
        end if;
    when  "0001" =>
        case AMPt is 
        when 0 =>  AMPs_axis_divisor_tdata<="000011110100001001000000";  
                   AMPs_axis_dividend_tdata<=Vquotient;   
        when 1 =>  AMPs_axis_divisor_tdata<="000000011000011010100000";  
                   AMPs_axis_dividend_tdata<="00000000"&AMPVreminder; 
        when 2 =>  AMPs_axis_divisor_tdata<="000000000010011100010000";  
                   AMPs_axis_dividend_tdata<="00000000"&AMPVreminder;        
        when 3 =>  AMPs_axis_divisor_tdata<="000000000000001111101000";  
                   AMPs_axis_dividend_tdata<="00000000"&AMPVreminder; 
        when 4 =>  AMPs_axis_divisor_tdata<="000000000000000001100100";  
                   AMPs_axis_dividend_tdata<="00000000"&AMPVreminder; 
        when 5 =>  AMPs_axis_divisor_tdata<="000000000000000000001010"; 
                   AMPs_axis_dividend_tdata<="00000000"&AMPVreminder; 
        when 6 =>  AMPs_axis_divisor_tdata<="000000000000000000000001"; 
                   AMPs_axis_dividend_tdata<="00000000"&AMPVreminder;     
        when others => AMPs_axis_divisor_tdata <="000000000000000000000001";
        end case;   
        AMPp<=AMPp+1;
    when "0010" =>
        AMPs_axis_divisor_tvalid<='1';
        AMPs_axis_dividend_tvalid<='1';
        AMPp<=AMPp+1;
    when "0011" =>
        if (AMPm_axis_dout_tvalid='1') then
           AMPs_axis_divisor_tvalid<='0';
           AMPs_axis_dividend_tvalid<='0';
           AMPp<=AMPp+1;
        end if;            
    when "0100" =>
         if (AMPm_axis_dout_tvalid='0') then
--                39-8 =>quotient 7-0 => reminder
           AMPVquotient <=AMPm_axis_dout_tdata(55 downto 24);
--                  Vsign<=m_axis_dout_tdata(39);
           AMPVreminder <=AMPm_axis_dout_tdata(23 downto 0);
           AMPp<=AMPp+1;
         end if; 
    when "0101" =>
        case AMPt is 
        when 0 => AMPcountDIS1000000<= AMPVquotient (3 downto 0);
                  AMPp<="0001";  
                  AMPt<=AMPt+1;
        when 1 => AMPcountDIS100000<= AMPVquotient (3 downto 0);
                  AMPp<="0001";
                  AMPt<=AMPt+1;
        when 2 => AMPcountDIS10000<= AMPVquotient (3 downto 0);
                  AMPp<="0001";  
                  AMPt<=AMPt+1;
        when 3 => AMPcountDIS1000<= AMPVquotient (3 downto 0);
                  AMPp<="0001";
                  AMPt<=AMPt+1;
        when 4 => AMPcountDIS100<= AMPVquotient (3 downto 0);
                  AMPp<="0001";
                  AMPt<=AMPt+1;
        when 5 => AMPcountDIS10<= AMPVquotient (3 downto 0);
                  AMPp<="0001";
                  AMPt<=AMPt+1;
        when 6 => AMPcountDIS1<= AMPVquotient (3 downto 0);
                  AMPp<="0001";
                  AMPt<=AMPt+1;  
                  AMPcountDIS_reg<='1';
        when 7 =>        
                 AMPcountDIS<='1';
                 AMPt<=0;
                 AMPp<="0000"; 
        when others =>   AMPt<=0;  
                         AMPp<="0000"; 
        end case;                          
    when others =>  AMPp<="0000";
    end case; 
end if;
end process;


process (AMPcountDIS_reg,AMPcountDIS1000000,AMPcountDIS100000,AMPcountDIS10000,AMPcountDIS1000,AMPcountDIS100,AMPcountDIS10,AMPcountDIS1) begin
if (AMPcountDIS_reg'event and AMPcountDIS_reg = '1') then
    AMPSGIN1<=AMPcountDIS1000000;
    AMPSGIN2<=AMPcountDIS100000;
    AMPSGIN3<=AMPcountDIS10000; 
    AMPSGIN4<=AMPcountDIS1000;
    AMPSGIN5<=AMPcountDIS100;
    AMPSGIN6<=AMPcountDIS10;
    AMPSGIN7<=AMPcountDIS1;   
end if;
end process;




end Behavioral;