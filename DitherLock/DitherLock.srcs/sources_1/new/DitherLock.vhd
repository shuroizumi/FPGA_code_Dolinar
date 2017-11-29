library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity DitherLock is
  Port (
  clk: in std_logic;
  sw: in std_logic;
  led : out std_logic_vector(15 downto 0):= (others => '0');
  expectedcount : std_logic_vector(31 downto 0):= (others => '0');
  APDcount : std_logic_vector(32 downto 0):= (others => '0');
  lockmode: in std_logic;
  updatewavelock: out std_logic;
  Vout : out std_logic_vector (15 downto 0):= (others => '0');
  Vbiasset : in std_logic_vector (15 downto 0);
  cntdoneAPD: in std_logic;
  mode1: in std_logic;
  WP : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  WI : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
  Wr : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  WL  : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  polarity : in integer range -1 to 1 := 1;
  vstepinstd  : in  std_logic_vector (7 downto 0);
  offsetphase : in integer range 0 to 50:=1;
  sw1: in std_logic;  
  sw2: in std_logic;
  sw3: in std_logic
 );
end DitherLock;

architecture Behavioral of DitherLock is


--------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT div_gen_1
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------


component std_vector_to_floating is
  Port (
  clk : in std_logic;
  std_vector  : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  floating  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
  convert : in std_logic;
  finish_convert : out std_logic
   );
end component;


------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT floating_point_0
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tready : OUT STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT floating_point_1
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tready : OUT STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT floating_point_2
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tready : OUT STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------


------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT floating_point_3
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tready : OUT STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

COMPONENT floating_point_4
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tready : OUT STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT floating_point_5
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tready : OUT STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT floating_point_6
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tready : OUT STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------



signal state_reg : std_logic_vector(4 downto 0):= (others => '0');
signal status: std_logic_vector  (4 downto 0):= (others => '0');
signal saturated :  std_logic;



signal WPfloating : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WIfloating : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WLfloating :  std_logic_vector  (31 downto 0):= (others => '0');
signal Wrfloating :  std_logic_vector  (31 downto 0):= (others => '0');
signal interrorsig : std_logic_vector  (31 downto 0):= (others => '0');

signal gperrorsig :  STD_LOGIC_VECTOR(31 DOWNTO 0);
signal giinterrorsig :  STD_LOGIC_VECTOR(31 DOWNTO 0);


signal expectedcountfloat : std_logic_vector (31 downto 0);
signal APDcountfloat : std_logic_vector (31 downto 0);
signal errorsig : std_logic_vector (31 downto 0):= "00000000000000000000000000000000";
signal sumgpgi : std_logic_vector  (31 downto 0):= (others => '0');
signal Voutp : integer:=0;

signal s_axis_divisor_tdata :  std_logic_vector  (31 downto 0):= (others => '0');
signal s_axis_dividend_tdata:  std_logic_vector  (31 downto 0):= (others => '0');
signal s_axis_divisor_tvalid : std_logic :='0';
signal s_axis_dividend_tvalid : std_logic :='0';
signal m_axis_dout_tvalid: std_logic :='0';
signal m_axis_dout_tdata :  std_logic_vector  (63 downto 0):= (others => '0');

signal Vquotient : std_logic_vector (31 downto 0);
signal Vbiasset_reg : std_logic_vector (15 downto 0):="0110011001100110";
signal Voutint :  std_logic_vector (30 downto 0):= (others => '0');
signal setpointbias:  std_logic;

type Voltagethresh2 is array (0 to 49) of integer;
constant Voltagethresh : Voltagethresh2:=(
-1000, -998, -992, -982, -967, -949, -927, -901, -871, -838, -801, 
-761, -718, -672, -623, -572, -518, -463, -405, -345, -285, -223, 
-160, -96, -32, 32, 96, 160, 223, 285, 345, 405, 463, 518, 572, 623, 
672, 718, 761, 801, 838, 871, 901, 927, 949, 967, 982, 992, 998, 1000);

type Voltagethreshfloat2 is array (0 to 49) of  std_logic_vector (31 downto 0);
--constant Voltagethreshfloat : Voltagethreshfloat2:=(
--"11000100011110100000000000000000", "11000100011110011000000000000000", "11000100011110000000000000000000", "11000100011101011000000000000000",
--"11000100011100011100000000000000", "11000100011011010100000000000000", "11000100011001111100000000000000", "11000100011000010100000000000000",
--"11000100010110011100000000000000", "11000100010100011000000000000000", "11000100010010000100000000000000", "11000100001111100100000000000000",
--"11000100001100111000000000000000", "11000100001010000000000000000000", "11000100000110111100000000000000", "11000100000011110000000000000000",
--"11000100000000011000000000000000", "11000011111001111000000000000000", "11000011110010101000000000000000", "11000011101011001000000000000000",
--"11000011100011101000000000000000", "11000011010111110000000000000000", "11000011001000000000000000000000", "11000010110000000000000000000000",
--"11000010000000000000000000000000",
--"01000010000000000000000000000000",
--"01000010110000000000000000000000", "01000011001000000000000000000000", "01000011010111110000000000000000", "01000011100011101000000000000000",
--"01000011101011001000000000000000", "01000011110010101000000000000000", "01000011111001111000000000000000", "01000100000000011000000000000000",
--"01000100000011110000000000000000", "01000100000110111100000000000000", "01000100001010000000000000000000", "01000100001100111000000000000000",
--"01000100001111100100000000000000", "01000100010010000100000000000000", "01000100010100011000000000000000", "01000100010110011100000000000000",
--"01000100011000010100000000000000", "01000100011001111100000000000000", "01000100011011010100000000000000", "01000100011100011100000000000000",
--"01000100011101011000000000000000", "01000100011110000000000000000000", "01000100011110011000000000000000", "01000100011110100000000000000000");

constant Voltagethreshfloat : Voltagethreshfloat2:=(
"10111111100000000000000000000000", "10111111011111110111110011101110", "10111111011111011111001110110110", "10111111011110110110010001011010",
"10111111011101111000110101010000", "10111111011100101111000110101010", "10111111011011010100111111011111", "10111111011001101010011111110000",
"10111111010111101111100111011011", "10111111010101101000011100101011", "10111111010011010000111001010110", "10111111010000101101000011100101",
"10111111001101111100111011011001", "10111111001011000000100000110001", "10111111000111110111110011101110", "10111111000100100110111010011000",
"10111111000001001001101110100110", "10111110111011010000111001010110", "10111110110011110101110000101001", "10111110101100001010001111010111",
"10111110100100011110101110000101", "10111110011001000101101000011101", "10111110001000111101011100001010", "10111111011101011100001010001111",
"10111110101000111101011100001010",
"00111110101000111101011100001010",
"00111111011101011100001010001111", "00111110001000111101011100001010", "00111110011001000101101000011101", "00111110100100011110101110000101",
"00111110101100001010001111010111", "00111110110011110101110000101001", "00111110111011010000111001010110", "00111111000001001001101110100110",
"00111111000100100110111010011000", "00111111000111110111110011101110", "00111111001011000000100000110001", "00111111001101111100111011011001",
"00111111010000101101000011100101", "00111111010011010000111001010110", "00111111010101101000011100101011", "00111111010111101111100111011011",
"00111111011001101010011111110000", "00111111011011010100111111011111", "00111111011100101111000110101010", "00111111011101111000110101010000",
"00111111011110110110010001011010", "00111111011111011111001110110110", "00111111011111110111110011101110", "00111111100000000000000000000000");


constant APDcntsim : Voltagethreshfloat2:=(
"01000100100000011000101110000000", "01000100100000011000100001100000", "01000100100000010111111011110000", "01000100100000010110111101010000", 
"01000100100000010101011111010000", "01000100100000010011101110110000", "01000100100000010001100101000000", "01000100100000001111000010010000",
"01000100100000001100000110010000", "01000100100000001000110111110000", "01000100100000000101010000000000", "01000100100000000001010101110000", 
"01000100011111111010010001000000", "01000100011111110001010001000000", "01000100011111100111101011100000", "01000100011111011101101101000000", 
"01000100011111010011001001000000", "01000100011111001000011000010000", "01000100011110111101000010010000", "01000100011110110001010011000000", 
"01000100011110100101100011110000", "01000100011110011001011011100000", "01000100011110001101000110100000", "01000100011110000000100101010000", 
"01000100011101110100000100000000", "01000100011101100111100010110000", "01000100011101011011000001010000", "01000100011101001110100000000000", 
"01000100011101000010001011010000", "01000100011100110110000011000000", "01000100011100101010010011110000", "01000100011100011110100100100000", 
"01000100011100010011001110010000", "01000100011100001000011101110000", "01000100011011111101111001100000", "01000100011011110011111011000000", 
"01000100011011101010010101100000", "01000100011011100001010101100000", "01000100011011011000111011010000", "01000100011011010001000110100000", 
"01000100011011001001110111010000", "01000100011011000011011010000000", "01000100011010111101100010010000", "01000100011010111000011100110000", 
"01000100011010110100001001100000", "01000100011010110000101000000000", "01000100011010101101101100010000", "01000100011010101011101111000000", 
"01000100011010101010100011110000", "01000100011010101010001010110000");


signal demod : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal demodLfloat : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal errorsigLfloat : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal vstepin_reg : integer:=0;



signal s_axis_a_tvalid : STD_LOGIC;
signal s_axis_a_tready : STD_LOGIC;
signal s_axis_a_tdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axis_b_tvalid : STD_LOGIC;
signal s_axis_b_tready : STD_LOGIC;
signal s_axis_b_tdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid : STD_LOGIC;
signal m_axis_result_tready : STD_LOGIC;
signal m_axis_result_tdata : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal s_axis_a_tvalid4 : STD_LOGIC;
signal s_axis_a_tready4 : STD_LOGIC;
signal s_axis_a_tdata4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axis_b_tvalid4 : STD_LOGIC;
signal s_axis_b_tready4 : STD_LOGIC;
signal s_axis_b_tdata4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid4 : STD_LOGIC;
signal m_axis_result_tready4 : STD_LOGIC;
signal m_axis_result_tdata4 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal s_axis_a_tvalid1 : STD_LOGIC;
signal s_axis_a_tready1 : STD_LOGIC;
signal s_axis_a_tdata1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axis_b_tvalid1 : STD_LOGIC;
signal s_axis_b_tready1 : STD_LOGIC;
signal s_axis_b_tdata1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid1 : STD_LOGIC;
signal m_axis_result_tready1 : STD_LOGIC;
signal m_axis_result_tdata1 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal s_axis_a_tvalid2 : STD_LOGIC;
signal s_axis_a_tready2 : STD_LOGIC;
signal s_axis_a_tdata2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axis_b_tvalid2 : STD_LOGIC;
signal s_axis_b_tready2 : STD_LOGIC;
signal s_axis_b_tdata2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid2 : STD_LOGIC;
signal m_axis_result_tready2 : STD_LOGIC;
signal m_axis_result_tdata2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal s_axis_a_tvalid3 : STD_LOGIC;
signal s_axis_a_tready3 : STD_LOGIC;
signal s_axis_a_tdata3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axis_b_tvalid3 : STD_LOGIC;
signal s_axis_b_tready3 : STD_LOGIC;
signal s_axis_b_tdata3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid3 : STD_LOGIC;
signal m_axis_result_tready3 : STD_LOGIC;
signal m_axis_result_tdata3 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal s_axis_a_tvalid5 : STD_LOGIC;
signal s_axis_a_tready5 : STD_LOGIC;
signal s_axis_a_tdata5 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axis_b_tvalid5 : STD_LOGIC;
signal s_axis_b_tready5 : STD_LOGIC;
signal s_axis_b_tdata5 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid5 : STD_LOGIC;
signal m_axis_result_tready5 : STD_LOGIC;
signal m_axis_result_tdata5 : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal s_axis_a_tvalid6 : STD_LOGIC;
signal s_axis_a_tready6 : STD_LOGIC;
signal s_axis_a_tdata6 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axis_b_tvalid6 : STD_LOGIC;
signal s_axis_b_tready6 : STD_LOGIC;
signal s_axis_b_tdata6 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid6 : STD_LOGIC;
signal m_axis_result_tready6 : STD_LOGIC;
signal m_axis_result_tdata6 : STD_LOGIC_VECTOR(31 DOWNTO 0);


signal convertstage : std_logic_vector(4 downto 0):= (others => '0');
signal WLfloating_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal onemWLfloating_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal stage_demodLfloat : std_logic_vector(3 downto 0):= (others => '0');
signal stage_errorsig : std_logic_vector(3 downto 0):= (others => '0');
signal stage_errorsigLfloat : std_logic_vector(3 downto 0):= (others => '0');

signal Vquotientfloat : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal significant : std_logic_vector (22 downto 0);
signal exponent : std_logic_vector (7 downto 0);
signal significant_reg : std_logic_vector (30 downto 0):="0000000000000000000000000000001";

signal l : integer:=0;
signal r : integer range 0 to 22:=22;

signal start : STD_LOGIC:= '0';
signal finish_convertAPD : STD_LOGIC:= '0';
signal timecnt : STD_LOGIC_VECTOR(31 DOWNTO 0);

signal vstepin : integer:=0;
signal vstepintest : integer:=0; 

signal cycleup : STD_LOGIC:= '0';

signal errorsig_reg : std_logic_vector (31 downto 0):= "00000000000000000000000000000000";
signal errorsig_reg2 : std_logic_vector (31 downto 0):= "00000000000000000000000000000000";



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

istd_vector_to_floating1: std_vector_to_floating port map(
clk=>clk, 
std_vector=>WL,
floating=>WLfloating,
convert=>'1'
);
  
istd_vector_to_floatingWr: std_vector_to_floating port map(
clk=>clk, 
std_vector=>Wr,
floating=>Wrfloating,
convert=>'1'
);
  
istd_vector_to_floatingWI: std_vector_to_floating port map(
clk=>clk, 
std_vector=>WI,
floating=>WIfloating,
convert=>'1'
);

istd_vector_to_floatingWP: std_vector_to_floating port map(
clk=>clk, 
std_vector=>WP,
floating=>WPfloating,
convert=>'1'
);
  
istd_vector_to_floatingAPDcount: std_vector_to_floating port map(
clk=>clk, 
std_vector=>APDcount(31 downto 0),
floating=>APDcountfloat,
convert=>cntdoneAPD,
finish_convert=>finish_convertAPD
);
  

istd_vector_to_floatingexpectedcnt: std_vector_to_floating port map(
clk=>clk, 
std_vector=>expectedcount(31 downto 0),
floating=>expectedcountfloat,
convert=>'1'
);  
  

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
------devide
ifloating_point_0: floating_point_0
  PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => s_axis_a_tvalid,
    s_axis_a_tready => s_axis_a_tready,
    s_axis_a_tdata => s_axis_a_tdata,
    s_axis_b_tvalid => s_axis_b_tvalid,
    s_axis_b_tready => s_axis_b_tready,
    s_axis_b_tdata => s_axis_b_tdata,
    m_axis_result_tvalid => m_axis_result_tvalid,
    m_axis_result_tready => m_axis_result_tready,
    m_axis_result_tdata => m_axis_result_tdata
  );
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
ifloating_point_4: floating_point_4
    PORT MAP (
      aclk => clk,
      s_axis_a_tvalid => s_axis_a_tvalid4,
      s_axis_a_tready => s_axis_a_tready4,
      s_axis_a_tdata => s_axis_a_tdata4,
      s_axis_b_tvalid => s_axis_b_tvalid4,
      s_axis_b_tready => s_axis_b_tready4,
      s_axis_b_tdata => s_axis_b_tdata4,
      m_axis_result_tvalid => m_axis_result_tvalid4,
      m_axis_result_tready => m_axis_result_tready4,
      m_axis_result_tdata => m_axis_result_tdata4
    );
-- INST_TAG_END ------ End INSTANTIATION Template ---------


------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
------multiply
ifloating_point_1: floating_point_1
  PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => s_axis_a_tvalid1,
    s_axis_a_tready => s_axis_a_tready1,
    s_axis_a_tdata => s_axis_a_tdata1,
    s_axis_b_tvalid => s_axis_b_tvalid1,
    s_axis_b_tready => s_axis_b_tready1,
    s_axis_b_tdata => s_axis_b_tdata1,
    m_axis_result_tvalid => m_axis_result_tvalid1,
    m_axis_result_tready => m_axis_result_tready1,
    m_axis_result_tdata => m_axis_result_tdata1
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------
------multiply
ifloating_point_6: floating_point_6
  PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => s_axis_a_tvalid6,
    s_axis_a_tready => s_axis_a_tready6,
    s_axis_a_tdata => s_axis_a_tdata6,
    s_axis_b_tvalid => s_axis_b_tvalid6,
    s_axis_b_tready => s_axis_b_tready6,
    s_axis_b_tdata => s_axis_b_tdata6,
    m_axis_result_tvalid => m_axis_result_tvalid6,
    m_axis_result_tready => m_axis_result_tready6,
    m_axis_result_tdata => m_axis_result_tdata6
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------


------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
------sum
ifloating_point_2: floating_point_2
  PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => s_axis_a_tvalid2,
    s_axis_a_tready => s_axis_a_tready2,
    s_axis_a_tdata => s_axis_a_tdata2,
    s_axis_b_tvalid => s_axis_b_tvalid2,
    s_axis_b_tready => s_axis_b_tready2,
    s_axis_b_tdata => s_axis_b_tdata2,
    m_axis_result_tvalid => m_axis_result_tvalid2,
    m_axis_result_tready => m_axis_result_tready2,
    m_axis_result_tdata => m_axis_result_tdata2
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
ifloating_point_3: floating_point_3
  PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => s_axis_a_tvalid3,
    s_axis_a_tready => s_axis_a_tready3,
    s_axis_a_tdata => s_axis_a_tdata3,
    s_axis_b_tvalid => s_axis_b_tvalid3,
    s_axis_b_tready => s_axis_b_tready3,
    s_axis_b_tdata => s_axis_b_tdata3,
    m_axis_result_tvalid => m_axis_result_tvalid3,
    m_axis_result_tready => m_axis_result_tready3,
    m_axis_result_tdata => m_axis_result_tdata3
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------



------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
------------subtract
ifloating_point_5: floating_point_5
  PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => s_axis_a_tvalid5,
    s_axis_a_tready => s_axis_a_tready5,
    s_axis_a_tdata => s_axis_a_tdata5,
    s_axis_b_tvalid => s_axis_b_tvalid5,
    s_axis_b_tready => s_axis_b_tready5,
    s_axis_b_tdata => s_axis_b_tdata5,
    m_axis_result_tvalid => m_axis_result_tvalid5,
    m_axis_result_tready => m_axis_result_tready5,
    m_axis_result_tdata => m_axis_result_tdata5
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

 
process (clk) begin
if (clk'event and clk = '1') then
case convertstage is
when "00000" =>
    s_axis_a_tdata<=WLfloating; 
    s_axis_b_tdata<="01000100011110100000000000000000";    
    convertstage<=convertstage+1;
when "00001" =>
    s_axis_a_tvalid<='1';
    s_axis_b_tvalid<='1';
    convertstage<=convertstage+1;
when "00010" =>
    if (m_axis_result_tvalid='1') then
       m_axis_result_tready<='1';
       s_axis_a_tvalid<='0';
       s_axis_b_tvalid<='0';
       convertstage<=convertstage+1;
    end if;            
when "00011" =>
     if (m_axis_result_tvalid='0') then
       WLfloating_reg <=m_axis_result_tdata;
       m_axis_result_tready<='0';
       convertstage<=convertstage+1;
     end if; 
when "00100" =>
    s_axis_a_tdata3<="00111111100000000000000000000000"; 
    s_axis_b_tdata3<=WLfloating_reg;    
    convertstage<=convertstage+1;
when "00101" =>
    s_axis_a_tvalid3<='1';
    s_axis_b_tvalid3<='1';
    convertstage<=convertstage+1;
when "00110" =>
    if (m_axis_result_tvalid3='1') then
       m_axis_result_tready3<='1';
       s_axis_a_tvalid3<='0';
       s_axis_b_tvalid3<='0';
       convertstage<=convertstage+1;
    end if;            
when "00111" =>
     if (m_axis_result_tvalid='0') then
       onemWLfloating_reg <=m_axis_result_tdata3;
       m_axis_result_tready3<='0';
       convertstage<="00000";
     end if; 
when others =>  convertstage<="00000";
end case; 
end if;
end process;



  
vstepin<=CONV_INTEGER(unsigned(vstepinstd));

--led(15 DOWNTO 0)<= conv_STD_LOGIC_VECTOR(offsetphase,16);
-----------------------one cycle 3.1 micro s
process ( cntdoneAPD,clk,sw,Vbiasset,mode1,finish_convertAPD) begin
if (clk'event and clk = '1') then
if (sw='1') then
    state_reg<=(others => '0');
    status<=(others => '0');
    stage_errorsigLfloat<=(others => '0');
    stage_errorsig<=(others => '0');
    stage_demodLfloat<=(others => '0');
    r<=22;
    updatewavelock<='0';
    interrorsig<=(others => '0');
    Vout<=Vbiasset;
    saturated<='0';
    cycleup<='0';
    significant_reg<="0000000000000000000000000000001";
    errorsig_reg<=(others => '0');
    errorsig_reg2<=(others => '0');
else    
if (lockmode='0') then
    state_reg<=(others => '0');
    status<=(others => '0');
    stage_errorsigLfloat<=(others => '0');
    stage_errorsig<=(others => '0');
    updatewavelock<='0';
    saturated<='0';
    r<=22;
    cycleup<='0';
    errorsig_reg<=(others => '0');
    errorsig_reg2<=(others => '0');
    significant_reg<="0000000000000000000000000000001";
    stage_demodLfloat<=(others => '0');
else    
    case state_reg is
        when "00000" =>
          if (vstepin=0) then
            start<= '1';
          end if;

          if (cntdoneAPD='1' and mode1='1'  and start='1') then
             state_reg<="00001";
          else
             state_reg<="00000";
          end if;
        when "00001" =>
           timecnt<=timecnt+1;
           updatewavelock<='0';
           if (finish_convertAPD='1') then
               state_reg<=state_reg+1;
               vstepin_reg<=vstepin+offsetphase;
               vstepintest<=vstepin;
           end if;   
        when "00010" =>
           timecnt<=timecnt+1;

           case stage_errorsigLfloat is
           when "0000" =>
                s_axis_a_tdata1<=APDcountfloat; 
                s_axis_b_tdata1<=Voltagethreshfloat(vstepin_reg);    
                stage_errorsigLfloat<=stage_errorsigLfloat+1;
           when "0001" =>
                s_axis_a_tvalid1<='1';
                s_axis_b_tvalid1<='1';
                stage_errorsigLfloat<=stage_errorsigLfloat+1;
           when "0010" =>
                if (m_axis_result_tvalid1='1') then
                    m_axis_result_tready1<='1';
                    s_axis_a_tvalid1<='0';
                    s_axis_b_tvalid1<='0';
                    stage_errorsigLfloat<=stage_errorsigLfloat+1;
                end if;            
           when "0011" =>
                 if (m_axis_result_tvalid1='0') then
                    if (APDcountfloat="00000000000000000000000000000000") then
                         demod <="00000000000000000000000000000000";
                    else     
                         demod <=m_axis_result_tdata1;
                    end if;     
                    m_axis_result_tready1<='0';
                    stage_errorsigLfloat<="0000"; 
                    state_reg<=state_reg+1;
                 end if; 
            when others =>  stage_errorsigLfloat<="0000";
            end case; 
        when "00011" =>
           timecnt<=timecnt+1;

           case stage_errorsigLfloat is
           when "0000" =>
               s_axis_a_tdata1<=errorsig_reg; 
               s_axis_b_tdata1<=onemWLfloating_reg;    
               s_axis_a_tdata6<=demod; 
               s_axis_b_tdata6<=WLfloating_reg;    
               stage_errorsigLfloat<=stage_errorsigLfloat+1;
           when "0001" =>
               s_axis_a_tvalid1<='1';
               s_axis_b_tvalid1<='1';
               s_axis_a_tvalid6<='1';
               s_axis_b_tvalid6<='1';
               stage_errorsigLfloat<=stage_errorsigLfloat+1;
           when "0010" =>
               if (m_axis_result_tvalid1='1' and m_axis_result_tvalid6='1') then
                   m_axis_result_tready1<='1';
                   s_axis_a_tvalid1<='0';
                   s_axis_b_tvalid1<='0';
                   m_axis_result_tready6<='1';
                   s_axis_a_tvalid6<='0';
                   s_axis_b_tvalid6<='0';
                   stage_errorsigLfloat<=stage_errorsigLfloat+1;
               end if;            
           when "0011" =>
                if (m_axis_result_tvalid1='0' and m_axis_result_tvalid6='0') then
                   if (errorsig_reg="00000000000000000000000000000000") then
                        errorsigLfloat <="00000000000000000000000000000000";
                   else     
                        errorsigLfloat <=m_axis_result_tdata1;
                   end if;     
                   m_axis_result_tready1<='0';
                   m_axis_result_tready6<='0';
                   demodLfloat <=m_axis_result_tdata6;

                   stage_errorsigLfloat<="0000"; 
                   state_reg<=state_reg+1;
                end if; 
           when others =>  stage_errorsigLfloat<="0000";
           end case; 
        when "00100" => 
           timecnt<=timecnt+1;
           case stage_errorsig is
           when "0000" =>
               s_axis_a_tdata2<=demodLfloat; 
               s_axis_b_tdata2<=errorsigLfloat;    
               stage_errorsig<=stage_errorsig+1;
           when "0001" =>
               s_axis_a_tvalid2<='1';
               s_axis_b_tvalid2<='1';
               stage_errorsig<=stage_errorsig+1;
           when "0010" =>
               if (m_axis_result_tvalid2='1') then
                   m_axis_result_tready2<='1';
                   s_axis_a_tvalid2<='0';
                   s_axis_b_tvalid2<='0';
                   stage_errorsig<=stage_errorsig+1;
               end if;            
           when "0011" =>
                if (m_axis_result_tvalid2='0') then
                   errorsig_reg <=m_axis_result_tdata2;
                   m_axis_result_tready2<='0';
                   stage_errorsig<="0000"; 
                   state_reg<=state_reg+1;
                end if; 
           when others =>  stage_errorsig<="0000";
           end case; 
        when "00101" =>
            if (vstepintest=49) then
                cycleup<='1';
                state_reg<=(others => '0');    
            elsif (vstepintest=0 and cycleup='1') then
                cycleup<='0';
                state_reg<=state_reg+1;
                errorsig<=errorsig_reg;
                errorsig_reg2<=errorsig_reg;
                errorsig_reg<=(others => '0');
            else
                state_reg<=(others => '0');    
            end if;

        when "00110" =>
           timecnt<=timecnt+1;
           case stage_errorsig is
           when "0000" =>
               s_axis_a_tdata5<=errorsig; 
               s_axis_b_tdata5<=expectedcountfloat;    
               stage_errorsig<=stage_errorsig+1;
           when "0001" =>
               s_axis_a_tvalid5<='1';
               s_axis_b_tvalid5<='1';
               stage_errorsig<=stage_errorsig+1;
           when "0010" =>
               if (m_axis_result_tvalid5='1') then
                   m_axis_result_tready5<='1';
                   s_axis_a_tvalid5<='0';
                   s_axis_b_tvalid5<='0';
                   stage_errorsig<=stage_errorsig+1;
               end if;            
           when "0011" =>
                if (m_axis_result_tvalid5='0') then
                   errorsig <=m_axis_result_tdata5;
                   m_axis_result_tready5<='0';
                   stage_errorsig<="0000"; 
                   state_reg<=state_reg+1;
                end if; 
           when others =>  stage_errorsig<="0000";
           end case; 
        when "00111" =>    
           timecnt<=timecnt+1;
            case stage_errorsig is
            when "0000" =>
                s_axis_a_tdata2<=errorsig; 
                s_axis_b_tdata2<=interrorsig;  
                stage_errorsig<=stage_errorsig+1;
            when "0001" =>
                s_axis_a_tvalid2<='1';
                s_axis_b_tvalid2<='1';
                stage_errorsig<=stage_errorsig+1;
            when "0010" =>
                if (m_axis_result_tvalid2='1') then
                    m_axis_result_tready2<='1';
                    s_axis_a_tvalid2<='0';
                    s_axis_b_tvalid2<='0';
                    stage_errorsig<=stage_errorsig+1;
                end if;            
            when "0011" =>
                 if (m_axis_result_tvalid2='0') then
                    interrorsig <=m_axis_result_tdata2;
                    m_axis_result_tready2<='0';
                    stage_errorsig<="0000"; 
                    state_reg<=state_reg+1;
                 end if; 
            when others =>  stage_errorsig<="0000";
            end case; 
        when "01000" =>             
           timecnt<=timecnt+1;
           case stage_demodLfloat is
           when "0000" =>
               s_axis_a_tdata1<=errorsig; 
               s_axis_b_tdata1<=WPfloating;    
               s_axis_a_tdata6<=interrorsig; 
               s_axis_b_tdata6<=WIfloating;                   
               stage_demodLfloat<=stage_demodLfloat+1;
           when "0001" =>
               s_axis_a_tvalid1<='1';
               s_axis_b_tvalid1<='1';
               s_axis_a_tvalid6<='1';
               s_axis_b_tvalid6<='1';
               stage_demodLfloat<=stage_demodLfloat+1;
           when "0010" =>
               if (m_axis_result_tvalid1='1' and m_axis_result_tvalid6='1') then
                   m_axis_result_tready1<='1';
                   s_axis_a_tvalid1<='0';
                   s_axis_b_tvalid1<='0';
                   m_axis_result_tready6<='1';
                   s_axis_a_tvalid6<='0';
                   s_axis_b_tvalid6<='0';
                   stage_demodLfloat<=stage_demodLfloat+1;
               end if;            
           when "0011" =>
                if (m_axis_result_tvalid1='0' and m_axis_result_tvalid6='0') then
                   gperrorsig <=m_axis_result_tdata1;
                   giinterrorsig<=m_axis_result_tdata6;
                   m_axis_result_tready1<='0';
                   m_axis_result_tready6<='0';
                   stage_demodLfloat<="0000"; 
                   state_reg<=state_reg+1; 
                end if; 
           when others =>  stage_demodLfloat<="0000";
           end case; 
        when "01001" =>             
           timecnt<=timecnt+1;
           case stage_errorsig is
           when "0000" =>
               s_axis_a_tdata2<=gperrorsig; 
               s_axis_b_tdata2<=giinterrorsig;    
               stage_errorsig<=stage_errorsig+1;
           when "0001" =>
               s_axis_a_tvalid2<='1';
               s_axis_b_tvalid2<='1';
               stage_errorsig<=stage_errorsig+1;
           when "0010" =>
               if (m_axis_result_tvalid2='1') then
                   m_axis_result_tready2<='1';
                   s_axis_a_tvalid2<='0';
                   s_axis_b_tvalid2<='0';
                   stage_errorsig<=stage_errorsig+1;
               end if;            
           when "0011" =>
                if (m_axis_result_tvalid2='0') then
                   sumgpgi <=m_axis_result_tdata2;
                   m_axis_result_tready2<='0';
                   stage_errorsig<="0000"; 
                   state_reg<=state_reg+1;
                end if; 
           when others =>  stage_errorsig<="0000";
           end case; 
        when "01010" => 
           timecnt<=timecnt+1;
           case status is
           when "00000" =>
               s_axis_a_tdata4<=sumgpgi; 
               s_axis_b_tdata4<=Wrfloating;    
               status<="00001";
           when "00001" =>
               s_axis_a_tvalid4<='1';
               s_axis_b_tvalid4<='1';
               status<="00010";
           when "00010" =>
               if (m_axis_result_tvalid4='1') then
                   m_axis_result_tready4<='1';
                   s_axis_a_tvalid4<='0';
                   s_axis_b_tvalid4<='0';
                   status<="00011";
               end if;            
           when "00011" =>
                if (m_axis_result_tvalid4='0') then
                  Vquotientfloat<=m_axis_result_tdata4;
                  status<="00000";
                  state_reg<=state_reg+1;
                end if; 
           when others =>  status<="00000";
           end case; 
        when "01011" =>
           timecnt<=timecnt+1;
           if (polarity=1) then
               Vquotientfloat(31)<=Vquotientfloat(31);
           elsif (polarity=-1) then
               Vquotientfloat(31)<=not Vquotientfloat(31);
           end if;
           state_reg<=state_reg+1;
        when "01100" =>       
           
           Vquotient(31)<=Vquotientfloat(31);
           exponent <=Vquotientfloat(30 downto 23);
           significant <=Vquotientfloat(22 downto 0);
           state_reg<=state_reg+1;

        when "01101" =>       
           timecnt<=timecnt+1;
           r<=22;
           if (exponent>="01111111") then
              exponent <=Vquotientfloat(30 downto 23)-"01111111";  
           end if;
           state_reg<=state_reg+1;
           significant_reg<="0000000000000000000000000000001";
        when "01110" =>       
           timecnt<=timecnt+1;

           if (exponent=0) then
               state_reg<=state_reg+1;            
               Vquotient(30 downto 0)<=significant_reg;
           else
               significant_reg<=significant_reg(29 downto 0) & significant(r);
               exponent<=exponent-1;
               r<=r-1;
           end if;
        when "01111" =>
           timecnt<=timecnt+1;
            if (Vquotient(31)='0') then
                Voutint<=  Vbiasset_reg+Vquotient(30 downto 0);
            else
                Voutint<=  Vbiasset_reg-Vquotient(30 downto 0);
            end if;    
            state_reg<=state_reg+1;
        when "10000" =>
           timecnt<=timecnt+1;

            if (Voutint <=65535 and Voutint >=0) then
              state_reg<=state_reg+1;
              Vout<=Voutint(15 downto 0);
            else
              if (setpointbias='0') then
                Vbiasset_reg<="1100110011001101";
                setpointbias<='1';
              else
                Vbiasset_reg<="0110011001100110";
                setpointbias<='0';
              end if;
              interrorsig<=(others => '0'); 
              state_reg<=(others => '0');
            end if;             
        when "10001" =>                  
           
            Vquotient(31)<=Vquotientfloat(31);
--            if (l=1) then
                if (sw1='0' and sw2='0') then
                    led(15 DOWNTO 0)<=errorsig(15 DOWNTO 0);
                elsif (sw1='1' and sw2='0') then
                    led<=errorsig(31 DOWNTO 16);
                elsif (sw1='0' and sw2='1') then
                    led<=errorsig_reg2(15 DOWNTO 0);
                elsif (sw1='1' and sw2='1') then
                    led<=errorsig_reg2(31 DOWNTO 16);
                end if;
                
                if (sw3='0') then
                    state_reg<="00000";   
                    updatewavelock<='1';
                else
                    updatewavelock<='0';   
                end if;
                
--            else
--                l<=l+1;    
--            end if;
        when others =>  state_reg<="00000";
        end case;
    end if;
end if;    
end if;
end process;







end Behavioral;
