library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.numeric_std.ALL;

PACKAGE heap_arr_pkg IS
    type timesegment2 is array (0 to 10) of std_logic_vector (32 downto 0);
END; 

USE work.heap_arr_pkg.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--Convert digit from PC to parameters used for operations such as pi parameters, measurement time.....
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------



entity control_PID is
  Port (
       clk : in std_logic;
       DOUTm1 : in std_logic_vector (3 downto 0);       
       DOUT0 : in std_logic_vector (3 downto 0);
       DOUT1 : in std_logic_vector (3 downto 0);
       DOUT2 : in std_logic_vector (3 downto 0);
       DOUT3 : in std_logic_vector (3 downto 0);
       DOUT4 : in std_logic_vector (3 downto 0);
       DOUT5 : in std_logic_vector (3 downto 0);
       DOUT6 : in std_logic_vector (3 downto 0);
       DOUT7 : in std_logic_vector (3 downto 0);
       P : in std_logic :='0';
       I : in std_logic :='0';
       r : in std_logic :='0';
       gp : out std_logic_vector  (31 downto 0);
       gi : out std_logic_vector  (31 downto 0);
       gr : out std_logic_vector  (31 downto 0);
       
       WP  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       WI  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       Wr  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       PAMPLOCK : in std_logic :='0';
       IAMPLOCK : in std_logic :='0';
       rAMPLOCK : in std_logic :='0';
       WPAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       WIAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       WrAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       setampdef: in STD_LOGIC;
       setampoff: in STD_LOGIC;
       setampon: in STD_LOGIC;
       ampdisdef: out STD_LOGIC_VECTOR(15 DOWNTO 0);
       ampdisoff: out STD_LOGIC_VECTOR(15 DOWNTO 0);
       ampdison: out STD_LOGIC_VECTOR(15 DOWNTO 0);
       C: in  std_logic;
       CAMPLOCK: in  std_logic;
       setexpectedcnt: out std_logic_vector (31 downto 0):= (others => '0');
       expectedVADC: out std_logic_vector (31 downto 0):= (others => '0');
       B: in STD_LOGIC;
       BAMPLOCK: in STD_LOGIC;
       VoutB : out std_logic_vector (15 downto 0):= (others => '0');
       VBAMPLOCK: out STD_LOGIC_VECTOR(15 DOWNTO 0);
       DO : in  std_logic :='0';
       phasemodzero: in std_logic:='0';
       phasemodpi: in std_logic:='0';
       minchange : in  std_logic :='0';
       maxchange : in  std_logic :='0';
       numberfeed : in  std_logic :='0';       
       timesegment : out timesegment2;
       Voutzero : out std_logic_vector (15 downto 0);
       Voutpi : out std_logic_vector (15 downto 0);
       minokrun: out std_logic_vector (32 downto 0):= "000000000000000000000001111101000";
       maxokrun: out std_logic_vector (32 downto 0):= "000000000000000000000001111101000";
       maxindex_int : out integer;
       APDtimeset : in  std_logic :='0'; 
       WAPDtimeset: out std_logic_vector (32 downto 0):= (others => '0');
       AMPsetout : in  std_logic :='0';
       WAMPsetout: out std_logic_vector (32 downto 0):= (others => '0')   
       );
end control_PID;

 architecture Behavioral of control_PID is



------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT floating_point_1
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

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

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT floating_point_7
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


COMPONENT div_gen_5
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



signal int1P  : integer;
signal int10P  : integer;
signal int100P  : integer;
signal int1I  : integer;
signal int10I  : integer;
signal int100I  : integer;
signal int1r  : integer;
signal int10r  : integer;
signal int100r  : integer;

signal WPint  : integer;
signal WIint : integer;
signal Wrint : integer;
signal WP_reg  : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WI_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Wr_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);



signal int1PAMPLOCK  : integer;
signal int10PAMPLOCK  : integer;
signal int100PAMPLOCK  : integer;
signal int1IAMPLOCK  : integer;
signal int10IAMPLOCK  : integer;
signal int100IAMPLOCK  : integer;
signal int1rAMPLOCK  : integer;
signal int10rAMPLOCK  : integer;
signal int100rAMPLOCK  : integer;

signal WPAMPLOCKint  : integer;
signal WIAMPLOCKint : integer;
signal WrAMPLOCKint : integer;
signal WPAMPLOCK_reg  : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WIAMPLOCK_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WrAMPLOCK_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);



signal s_axis_a_tvalid_in1: std_logic :='0';
signal s_axis_a_tready_out1: std_logic :='0';
signal s_axis_a_tdata_in1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid_out1: std_logic :='0';
signal m_axis_result_tready_in1: std_logic :='0';
signal m_axis_result_tdata_out1: STD_LOGIC_VECTOR(31 DOWNTO 0);



signal reg: STD_LOGIC_VECTOR(4 DOWNTO 0);
signal alpha_reg: STD_LOGIC_VECTOR(31 DOWNTO 0);

signal int100 :  integer;
signal int10 :  integer;
signal int1:  integer;
signal W:  integer;
signal W2:  integer;
signal Wstd:  std_logic_vector (31 downto 0);
signal stage : std_logic_vector(2 downto 0):= (others => '0');
signal status: std_logic_vector  (4 downto 0):= (others => '0');
signal Vquotient : std_logic_vector (31 downto 0);
signal Vreminder : std_logic_vector (7 downto 0);
signal setampdef_reg: std_logic :='0';
signal setampon_reg: std_logic :='0';
signal setampoff_reg: std_logic :='0';

signal s_axis_divisor_tvalid : std_logic :='0';
signal s_axis_divisor_tdata :  std_logic_vector  (7 downto 0):= (others => '0');
signal s_axis_dividend_tvalid : std_logic :='0';
signal s_axis_dividend_tdata:  std_logic_vector  (31 downto 0):= (others => '0');
signal m_axis_dout_tvalid: std_logic :='0';
signal m_axis_dout_tdata :  std_logic_vector  (39 downto 0):= (others => '0');


signal int1expcnt  : std_logic_vector (32 downto 0):= (others => '0');
signal int10expcnt  : std_logic_vector (32 downto 0):= (others => '0');
signal int100expcnt  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000expcnt  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000expcnt  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000expcnt  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000000expcnt  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000000expcnt  : std_logic_vector (32 downto 0):= (others => '0');
signal Wexpcnt  : std_logic_vector (32 downto 0):= (others => '0');


signal AMPLOCKint1  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint10  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint100  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint1000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint10000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint100000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint1000000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint10000000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKW  : std_logic_vector (32 downto 0):= (others => '0');




signal int100B :  integer;
signal int10B :  integer;
signal int1B:  integer;
signal WB:  integer;
signal W2B:  integer;
signal WstdB:  std_logic_vector (31 downto 0);
signal stageB : std_logic_vector(2 downto 0):= (others => '0');
signal statusB: std_logic_vector  (4 downto 0):= (others => '0');
signal VquotientB : std_logic_vector (31 downto 0);
signal VreminderB : std_logic_vector (7 downto 0);
signal s_axis_divisor_tvalidB : std_logic :='0';
signal s_axis_divisor_tdataB :  std_logic_vector  (7 downto 0):= (others => '0');
signal s_axis_dividend_tvalidB : std_logic :='0';
signal s_axis_dividend_tdataB:  std_logic_vector  (31 downto 0):= (others => '0');
signal m_axis_dout_tvalidB: std_logic :='0';
signal m_axis_dout_tdataB :  std_logic_vector  (39 downto 0):= (others => '0');
signal B_reg: std_logic :='0';
signal BAMPLOCK_reg: std_logic :='0';


signal stagezero : std_logic_vector(2 downto 0):= (others => '0');
signal phasemodzero_reg: std_logic:='0';
signal phasemodpi_reg: std_logic:='0';
signal statuszero: std_logic_vector  (4 downto 0):= (others => '0');
signal Wzero  :  integer;
signal W2zero  :  integer;
signal Wstdzero:  std_logic_vector (31 downto 0);
signal s_axis_divisor_tvalidzero : std_logic :='0';
signal s_axis_divisor_tdatazero :  std_logic_vector  (15 downto 0):= (others => '0');
signal s_axis_dividend_tvalidzero : std_logic :='0';
signal s_axis_dividend_tdatazero:  std_logic_vector  (31 downto 0):= (others => '0');
signal m_axis_dout_tvalidzero: std_logic :='0';
signal m_axis_dout_tdatazero :  std_logic_vector  (47 downto 0):= (others => '0');
signal Vquotientzero : std_logic_vector (31 downto 0);
signal Vreminderzero : std_logic_vector (14 downto 0);
--type timesegment2 is array (0 to 10) of std_logic_vector (32 downto 0);
--signal timesegment :timesegment2;
signal index : integer range 0 to 15;
signal maxindex : std_logic_vector (10 downto 0);
signal int1numberfeed  : std_logic_vector (10 downto 0):= (others => '0');
signal int10numberfeed  : std_logic_vector (10 downto 0):= (others => '0');
signal int100numberfeed  : std_logic_vector (10 downto 0):= (others => '0');

signal stageDO : std_logic_vector (2 downto 0);
signal timesegindex10 : std_logic_vector (7 downto 0):= (others => '0');
signal timesegindex1 : std_logic_vector (7 downto 0):= (others => '0');
signal timesegindex : std_logic_vector (7 downto 0):= (others => '0');
signal timesegindex_int : integer range 0 to 10;
signal WAD  : std_logic_vector (32 downto 0):= "000000000000000000000000111110100";

signal int1D  : std_logic_vector (32 downto 0):= (others => '0');
signal int10D  : std_logic_vector (32 downto 0):= (others => '0');
signal int100D  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000D  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000D  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000D  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000000D  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000000D  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000000D  : std_logic_vector (32 downto 0):= (others => '0');

signal int1zero  :  integer;
signal int10zero  :  integer;
signal int100zero :  integer;
signal int1000zero  :  integer;
signal int10000zero  :  integer;


signal int1min  : std_logic_vector (32 downto 0):= (others => '0');
signal int10min  : std_logic_vector (32 downto 0):= (others => '0');
signal int100min  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000min  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000min  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000min  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000000min  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000000min  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000000min  : std_logic_vector (32 downto 0):= (others => '0');

signal int1max  : std_logic_vector (32 downto 0):= (others => '0');
signal int10max  : std_logic_vector (32 downto 0):= (others => '0');
signal int100max  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000max  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000max  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000max  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000000max  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000000max  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000000max  : std_logic_vector (32 downto 0):= (others => '0');




signal int1AMPsetout  : std_logic_vector (32 downto 0):= (others => '0');
signal int10AMPsetout  : std_logic_vector (32 downto 0):= (others => '0');
signal int100AMPsetout  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000AMPsetout  : std_logic_vector (32 downto 0):= (others => '0');


signal int1APDtimeset  : std_logic_vector (32 downto 0):= (others => '0');
signal int10APDtimeset  : std_logic_vector (32 downto 0):= (others => '0');
signal int100APDtimeset  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000APDtimeset  : std_logic_vector (32 downto 0):= (others => '0');






begin
iconvertuintfloat: floating_point_1
      PORT MAP (
        aclk => clk,
        s_axis_a_tvalid => s_axis_a_tvalid_in1,
        s_axis_a_tready => s_axis_a_tready_out1,
        s_axis_a_tdata => s_axis_a_tdata_in1,
        m_axis_result_tvalid => m_axis_result_tvalid_out1,
        m_axis_result_tready => m_axis_result_tready_in1,
        m_axis_result_tdata => m_axis_result_tdata_out1
      );  
      

                    
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
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
-- INST_TAG_END ------ End INSTANTIATION Template ---------   

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
idiv_genB: div_gen_2
  PORT MAP (
    aclk => clk,
    s_axis_divisor_tvalid => s_axis_divisor_tvalidB,
    s_axis_divisor_tdata => s_axis_divisor_tdataB,
    s_axis_dividend_tvalid => s_axis_dividend_tvalidB,
    s_axis_dividend_tdata => s_axis_dividend_tdataB,
    m_axis_dout_tvalid => m_axis_dout_tvalidB,
    m_axis_dout_tdata => m_axis_dout_tdataB
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------   

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
idiv_genzero: div_gen_5
  PORT MAP (
    aclk => clk,
    s_axis_divisor_tvalid => s_axis_divisor_tvalidzero,
    s_axis_divisor_tdata => s_axis_divisor_tdatazero,
    s_axis_dividend_tvalid => s_axis_dividend_tvalidzero,
    s_axis_dividend_tdata => s_axis_dividend_tdatazero,
    m_axis_dout_tvalid => m_axis_dout_tvalidzero,
    m_axis_dout_tdata => m_axis_dout_tdatazero
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------   


            
process (P,DOUT5,DOUT6,DOUT7,int100P,int10P,int1P,WPint,WP_reg) begin
    if (P='1') then
    --100‚ÌˆÊ 
    int100P <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10P <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1P <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WPint<=int1P+int10P+int100P;
    WP_reg<=conv_STD_LOGIC_VECTOR(WPint,32);
    end if;
end process;
WP<=WP_reg;

process (I,DOUT5,DOUT6,DOUT7,int100I,int10I,int1I,WIint,WI_reg) begin
    if (I='1') then
    --100‚ÌˆÊ 
    int100I <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10I <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1I <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WIint<=int1I+int10I+int100I;
    WI_reg<=conv_STD_LOGIC_VECTOR(WIint,32);
    end if;
end process;
WI<=WI_reg;

process (r,DOUT5,DOUT6,DOUT7,int100r,int10r,int1r,Wrint,Wr_reg) begin
    if (r='1') then
    --100‚ÌˆÊ 
    int100r <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10r <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1r <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    Wrint<=int1r+int10r+int100r;
    Wr_reg<=conv_STD_LOGIC_VECTOR(Wrint,32);
    end if;
end process;
Wr<=Wr_reg;



process (PAMPLOCK,DOUT5,DOUT6,DOUT7,int100P,int10P,int1P,WPAMPLOCKint,WPAMPLOCK_reg) begin
    if (PAMPLOCK='1') then
    --100‚ÌˆÊ 
    int100PAMPLOCK <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10PAMPLOCK <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1PAMPLOCK <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WPAMPLOCKint<=int1PAMPLOCK+int10PAMPLOCK+int100PAMPLOCK;
    WPAMPLOCK_reg<=conv_STD_LOGIC_VECTOR(WPAMPLOCKint,32);
    end if;
end process;
WPAMPLOCK<=WPAMPLOCK_reg;

process (IAMPLOCK,DOUT5,DOUT6,DOUT7,int100I,int10I,int1I,WIAMPLOCKint,WIAMPLOCK_reg) begin
    if (IAMPLOCK='1') then
    --100‚ÌˆÊ 
    int100IAMPLOCK <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10IAMPLOCK <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1IAMPLOCK <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WIAMPLOCKint<=int1IAMPLOCK+int10IAMPLOCK+int100IAMPLOCK;
    WIAMPLOCK_reg<=conv_STD_LOGIC_VECTOR(WIAMPLOCKint,32);
    end if;
end process;
WIAMPLOCK<=WIAMPLOCK_reg;

process (r,DOUT5,DOUT6,DOUT7,int100r,int10r,int1r,WrAMPLOCKint,WrAMPLOCK_reg) begin
    if (rAMPLOCK='1') then
    --100‚ÌˆÊ 
    int100rAMPLOCK <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10rAMPLOCK <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1rAMPLOCK <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WrAMPLOCKint<=int1rAMPLOCK+int10rAMPLOCK+int100rAMPLOCK;
    WrAMPLOCK_reg<=conv_STD_LOGIC_VECTOR(WrAMPLOCKint,32);
    end if;
end process;
WrAMPLOCK<=WrAMPLOCK_reg;



process (clk) begin
 if (clk'event and clk = '1') then
    case reg is
    when "00000" =>
        s_axis_a_tdata_in1<=WP_reg;
        reg<= "00001";
    when "00001" => 
        s_axis_a_tvalid_in1<='1'; 
        reg<= "00010";  
    when "00010" =>    
        if (m_axis_result_tvalid_out1='1') then
            m_axis_result_tready_in1<='1';
            s_axis_a_tvalid_in1<='0';
            reg<="00011";
        end if;
    when "00011" =>    
        if (m_axis_result_tvalid_out1='0') then
             m_axis_result_tready_in1<='0';
             reg<="00100";
        end if;
    when "00100" =>  
        gp <=m_axis_result_tdata_out1; 
        reg<="00101";
    when "00101" =>  
        s_axis_a_tdata_in1<=WI_reg;
        reg<= "00110";
    when "00110" => 
        s_axis_a_tvalid_in1<='1'; 
        reg<= "00111";  
    when "00111" =>    
        if (m_axis_result_tvalid_out1='1') then
            m_axis_result_tready_in1<='1';
            s_axis_a_tvalid_in1<='0';
            reg<="01000";
        end if;
    when "01000" =>    
        if (m_axis_result_tvalid_out1='0') then
             m_axis_result_tready_in1<='0';
             reg<="01001";
        end if;
    when "01001" =>  
        gi <=m_axis_result_tdata_out1; 
        reg<="01010";
    when "01010" =>  
        s_axis_a_tdata_in1<=Wr_reg;
        reg<= "01011";
    when "01011" =>
        s_axis_a_tvalid_in1<='1'; 
        reg<= "01100";
    when "01100" => 
        if (m_axis_result_tvalid_out1='1') then
            m_axis_result_tready_in1<='1';
            s_axis_a_tvalid_in1<='0';
            reg<="01101";
        end if;       
    when "01101" =>
        if (m_axis_result_tvalid_out1='0') then
             m_axis_result_tready_in1<='0';
             reg<="01110";
        end if;
    when "01110" =>      
        gr <=m_axis_result_tdata_out1; 
         reg<="00000";
    when others =>  reg<="00000";
    end case;    
 end if;   
end process;








--set total counting time ms
process (setampdef,setampon,setampoff) begin
if (clk'event and clk = '1') then
case stage is
when "000"=>
    if (setampdef='1' or setampon='1' or setampoff='1') then
        --1000‚ÌˆÊ 
        int100 <=  CONV_INTEGER(unsigned(DOUT5)) *100;
        --100‚ÌˆÊ 
        int10 <=  CONV_INTEGER(unsigned(DOUT6)) *10;
        --10‚ÌˆÊ 
        int1 <= CONV_INTEGER(unsigned(DOUT7)) *1;
         stage<=stage+1;
        if (setampdef='1') then
            setampdef_reg<='1';
            setampon_reg<='0';
            setampoff_reg<='0';
        elsif (setampon='1') then
            setampdef_reg<='0';
            setampon_reg<='1';    
            setampoff_reg<='0';
        elsif (setampoff='1') then
            setampdef_reg<='0';
            setampon_reg<='0';
            setampoff_reg<='1';    
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
        end if; 
   when others =>  status<="00000";
   end case; 
when  "101"=>
    if (setampdef_reg='1') then
        ampdisdef<= Vquotient(15 downto 0);
    elsif (setampon_reg='1') then
        ampdison<= Vquotient(15 downto 0);
    elsif (setampoff_reg='1') then
        ampdisoff<= Vquotient(15 downto 0);
    end if;
    stage<=(others=>'0');
when others =>  stage<=(others=>'0');     
end case;
end if;
end process;








process (C,DOUT0,DOUT1,DOUT2,DOUT3,DOUT4,DOUT5,DOUT6,DOUT7,int1expcnt,int10expcnt,int100expcnt,int1000expcnt,int10000expcnt,int100000expcnt,int1000000expcnt,int10000000expcnt) begin
    if (C='1') then
    --10000000‚ÌˆÊ 
    int10000000expcnt <=  DOUT0 *"00000100110001001011010000000";
    --1000000‚ÌˆÊ 
    int1000000expcnt <= DOUT1 * "00000000011110100001001000000" ;
    --100000‚ÌˆÊ 
    int100000expcnt <=  DOUT2 * "00000000000011000011010100000";
    --10000‚ÌˆÊ 
    int10000expcnt <=   DOUT3 * "00000000000000010011100010000";
    --1000‚ÌˆÊ 
    int1000expcnt <=   DOUT4 * "00000000000000000001111101000";
    --100‚ÌˆÊ 
    int100expcnt <=   DOUT5 * "00000000000000000000001100100";
    --10‚ÌˆÊ 
    int10expcnt <=   DOUT6 * "00000000000000000000000001010";
    --1‚ÌˆÊ 
    int1expcnt <=   DOUT7* "00000000000000000000000000001";
    Wexpcnt<=int1expcnt+int10expcnt+int100expcnt+int1000expcnt+int10000expcnt+int100000expcnt+int1000000expcnt+int10000000expcnt;
    end if;
end process;

setexpectedcnt <=Wexpcnt(31 downto 0);



process (CAMPLOCK,DOUT0,DOUT1,DOUT2,DOUT3,DOUT4,DOUT5,DOUT6,DOUT7,AMPLOCKint1,AMPLOCKint10,AMPLOCKint100,AMPLOCKint1000,AMPLOCKint10000,AMPLOCKint100000,AMPLOCKint1000000,AMPLOCKint10000000) begin
    if (CAMPLOCK='1') then
    --10000000‚ÌˆÊ 
    AMPLOCKint10000000 <=  DOUT0 *"00000100110001001011010000000";
    --1000000‚ÌˆÊ 
    AMPLOCKint1000000 <= DOUT1 * "00000000011110100001001000000" ;
    --100000‚ÌˆÊ 
    AMPLOCKint100000 <=  DOUT2 * "00000000000011000011010100000";
    --10000‚ÌˆÊ 
    AMPLOCKint10000 <=   DOUT3 * "00000000000000010011100010000";
    --1000‚ÌˆÊ 
    AMPLOCKint1000 <=   DOUT4 * "00000000000000000001111101000";
    --100‚ÌˆÊ 
    AMPLOCKint100 <=   DOUT5 * "00000000000000000000001100100";
    --10‚ÌˆÊ 
    AMPLOCKint10 <=   DOUT6 * "00000000000000000000000001010";
    --1‚ÌˆÊ 
    AMPLOCKint1 <=   DOUT7* "00000000000000000000000000001";
    AMPLOCKW<=AMPLOCKint1+AMPLOCKint10+AMPLOCKint100+AMPLOCKint1000+AMPLOCKint10000+AMPLOCKint100000+AMPLOCKint1000000+AMPLOCKint10000000;
    end if;
end process;
expectedVADC <=AMPLOCKW(31 downto 0);



process (clk) begin
if (clk'event and clk= '1') then
case stageB is
when "000"=>
    if (B='1') then
        int100B <=  CONV_INTEGER(unsigned(DOUT5)) *100;
        --100‚ÌˆÊ 
        int10B <= CONV_INTEGER(unsigned(DOUT6)) *10;
        --10‚ÌˆÊ 
        int1B <=  CONV_INTEGER(unsigned(DOUT7)) *1;
        --1‚ÌˆÊ milisecond
        stageB<=stageB+1;
        B_reg<='1';
        BAMPLOCK_reg<='0';
    elsif (BAMPLOCK='1') then        
         int100B <=  CONV_INTEGER(unsigned(DOUT5)) *100;
        --100‚ÌˆÊ 
        int10B <= CONV_INTEGER(unsigned(DOUT6)) *10;
        --10‚ÌˆÊ 
        int1B <=  CONV_INTEGER(unsigned(DOUT7)) *1;
        --1‚ÌˆÊ milisecond
        stageB<=stageB+1;
        B_reg<='0';
        BAMPLOCK_reg<='1';
    end if;
when "001"=>
    WB<=int1B+int10B+int100B;
    stageB<=stageB+1;
when "010"=>
    W2B<=WB*65536;
    stageB<=stageB+1;
when "011"=>
    WstdB<=conv_std_logic_vector(W2B,32);
    stageB<=stageB+1;
when "100"=>
   case statusB is
   when "00000" =>
       s_axis_divisor_tdataB<="11111010"; 
       s_axis_dividend_tdataB<=WstdB;    
       statusB<="00001";
   when "00001" =>
       s_axis_divisor_tvalidB<='1';
       s_axis_dividend_tvalidB<='1';
       statusB<="00010";
   when "00010" =>
       if (m_axis_dout_tvalidB='1') then
          s_axis_divisor_tvalidB<='0';
          s_axis_dividend_tvalidB<='0';
          statusB<="00011";
       end if;            
   when "00011" =>
        if (m_axis_dout_tvalidB='0') then
--                39-8 =>quotient 7-0 => reminder
          VquotientB <=m_axis_dout_tdataB(39 downto 8);
          VreminderB <=m_axis_dout_tdataB(7 downto 0);
          statusB<="00000";
          stageB<=stageB+1;
        end if; 
   when others =>  statusB<="00000";
   end case; 
when  "101"=>
    if (B_reg='1') then
        VoutB<= VquotientB(15 downto 0);
        B_reg<='0';
    elsif  (BAMPLOCK_reg='1') then
        VBAMPLOCK<= VquotientB(15 downto 0);
        BAMPLOCK_reg<='0';
    end if;    
    stageB<=(others=>'0');
when others =>  stageB<=(others=>'0');     
end case;
end if;
end process;







process (clk,DO,DOUTm1,DOUT0,DOUT1,DOUT2,DOUT3,DOUT4,DOUT5,DOUT6,DOUT7,int100000000D,int10000000D,int1000000D,int100000D,int10000D,int1000D,int100D,int10D,int1D) begin
if (clk'event and clk = '1') then
    case stageDO is 
    when "000" =>
        if (DO='1') then
            stageDO<=stageDO+1;
        end if;
    when "001" =>            
        timesegindex10 <= "1010" * DOUTm1;
        timesegindex1<= "0001" * DOUT0;
     --1000000‚ÌˆÊ -100mS
        int1000000D <="00000000011110100001001000000"* DOUT1;
         --100000‚ÌˆÊ -10mS
        int100000D <="00000000000011000011010100000"* DOUT2;
        --1000‚ÌˆÊ 1mS
        int10000D <="00000000000000010011100010000"* DOUT3;
        --1000‚ÌˆÊ 100ƒÊS
        int1000D <="00000000000000000001111101000"* DOUT4;
        --100‚ÌˆÊ  10ƒÊS
        int100D <= "00000000000000000000001100100"* DOUT5;
        --10‚ÌˆÊ 1ƒÊS
        int10D <= "00000000000000000000000001010" * DOUT6;    
        --1‚ÌˆÊ 100nS * 1
        int1D<= "00000000000000000000000000001" * DOUT7;
        stageDO<=stageDO+1;
    when "010" =>
        timesegindex<=timesegindex10+timesegindex1;
        WAD<=int1D+int10D+int100D+int1000D;
        stageDO<=stageDO+1;
    when "011" => 
        timesegindex_int<=CONV_INTEGER(unsigned(timesegindex));
        WAD<=WAD+int10000D+int100000D+int1000000D;
        stageDO<=stageDO+1;
    when "100" => 
        timesegment(timesegindex_int)<=WAD;
        stageDO<=(others=>'0');       
    when others => stageDO<=(others=>'0');
    end case;
end if;
end process;



process (clk) begin
if (clk'event and clk= '1') then
case stagezero is
when "000"=>
    if (phasemodzero='1') then
     int10000zero <=CONV_INTEGER(unsigned(DOUT3)) *10000;
     --1000‚ÌˆÊ 100ƒÊS
     int1000zero <=CONV_INTEGER(unsigned(DOUT4)) *1000;
     --100‚ÌˆÊ  10ƒÊS
     int100zero <= CONV_INTEGER(unsigned(DOUT5)) *100;
     --10‚ÌˆÊ 1ƒÊS
     int10zero <= CONV_INTEGER(unsigned(DOUT6)) *10;      
     --1‚ÌˆÊ 100nS * 1
     int1zero<= CONV_INTEGER(unsigned(DOUT7)) *1;
     stagezero<=stagezero+1;
     phasemodzero_reg<='1';
    elsif (phasemodpi='1') then
        int10000zero <=CONV_INTEGER(unsigned(DOUT3)) *10000;
        --1000‚ÌˆÊ 100ƒÊS
        int1000zero <=CONV_INTEGER(unsigned(DOUT4)) *1000;
        --100‚ÌˆÊ  10ƒÊS
        int100zero <= CONV_INTEGER(unsigned(DOUT5)) *100;
        --10‚ÌˆÊ 1ƒÊS
        int10zero <= CONV_INTEGER(unsigned(DOUT6)) *10;      
        --1‚ÌˆÊ 100nS * 1
        int1zero<= CONV_INTEGER(unsigned(DOUT7)) *1;
        stagezero<=stagezero+1;
        phasemodpi_reg<='1';  
    end if;
when "001"=>
    Wzero<=int1zero+int10zero+int100zero+int1000zero+int10000zero;
    stagezero<=stagezero+1;
when "010"=>
    W2zero<=Wzero*65536;
    stagezero<=stagezero+1;
when "011"=>
    Wstdzero<=conv_std_logic_vector(W2zero,32);
    stagezero<=stagezero+1;
when "100"=>
   case statuszero is
   when "00000" =>
       s_axis_divisor_tdatazero<="0110000110101000"; 
       s_axis_dividend_tdatazero<=Wstdzero;    
       statuszero<="00001";
   when "00001" =>
       s_axis_divisor_tvalidzero<='1';
       s_axis_dividend_tvalidzero<='1';
       statuszero<="00010";
   when "00010" =>
       if (m_axis_dout_tvalidzero='1') then
          s_axis_divisor_tvalidzero<='0';
          s_axis_dividend_tvalidzero<='0';
          statuszero<="00011";
       end if;            
   when "00011" =>
        if (m_axis_dout_tvalidzero='0') then
--                47-16 =>quotient 14-0 => reminder
          Vquotientzero <=m_axis_dout_tdatazero(47 downto 16);
          Vreminderzero <=m_axis_dout_tdatazero(14 downto 0);
          statuszero<="00100";
        end if; 
   when "00100" =>
    if (phasemodzero_reg='1') then
        Voutzero<= Vquotientzero(15 downto 0);
        phasemodzero_reg<='0';
    elsif (phasemodpi_reg='1') then
        Voutpi<= Vquotient(15 downto 0);
        phasemodpi_reg<='0'; 
    end if;
    statuszero<="00000";
    stagezero<=stagezero+1;
   when others =>  statuszero<="00000";
   end case; 
when  "101"=>
    stagezero<=(others=>'0');
when others =>  stagezero<=(others=>'0');     
end case;
end if;
end process;




process (minchange,DOUTm1,DOUT0,DOUT1,DOUT2,DOUT3,DOUT4,DOUT5,DOUT6,DOUT7,int100000000min,int10000000min,int1000000min,int100000min,int10000min,int1000min,int100min,int10min,int1min) begin
    if (minchange='1') then
     --100000000‚ÌˆÊ -10S
    int100000000min <="00101111101011110000100000000"* DOUTm1;
     --10000000‚ÌˆÊ -1S
    int10000000min <="00000100110001001011010000000"* DOUT0;
     --1000000‚ÌˆÊ -100mS
    int1000000min <="00000000011110100001001000000"* DOUT1;
     --100000‚ÌˆÊ -10mS
    int100000min <="00000000000011000011010100000"* DOUT2;
    --1000‚ÌˆÊ 1mS
    int10000min <="00000000000000010011100010000"* DOUT3;
    --1000‚ÌˆÊ 100ƒÊS
    int1000min <="00000000000000000001111101000"* DOUT4;
    --100‚ÌˆÊ  10ƒÊS
    int100min <= "00000000000000000000001100100"* DOUT5;
    --10‚ÌˆÊ 1ƒÊS
    int10min <= "00000000000000000000000001010" * DOUT6;    
    --1‚ÌˆÊ 100nS * 1
    int1min<= "00000000000000000000000000001" * DOUT7;
    minokrun<=int1min+int10min+int100min+int1000min+int10000min+int100000min+int1000000min+int10000000min+int100000000min;
    end if;
end process;



process (maxchange,DOUTm1,DOUT0,DOUT1,DOUT2,DOUT3,DOUT4,DOUT5,DOUT6,DOUT7,int100000000max,int10000000max,int1000000max,int100000max,int10000max,int1000max,int100max,int10max,int1max) begin
    if (maxchange='1') then
     --100000000‚ÌˆÊ -10S
    int100000000max <="00101111101011110000100000000"* DOUTm1;
     --10000000‚ÌˆÊ -1S
    int10000000max <="00000100110001001011010000000"* DOUT0;
     --1000000‚ÌˆÊ -100mS
    int1000000max <="00000000011110100001001000000"* DOUT1;
     --100000‚ÌˆÊ -10mS
    int100000max <="00000000000011000011010100000"* DOUT2;
    --1000‚ÌˆÊ 1mS
    int10000max <="00000000000000010011100010000"* DOUT3;
    --1000‚ÌˆÊ 100ƒÊS
    int1000max <="00000000000000000001111101000"* DOUT4;
    --100‚ÌˆÊ  10ƒÊS
    int100max <= "00000000000000000000001100100"* DOUT5;
    --10‚ÌˆÊ 1ƒÊS
    int10max <= "00000000000000000000000001010" * DOUT6;    
    --1‚ÌˆÊ 100nS * 1
    int1max<= "00000000000000000000000000001" * DOUT7;
    maxokrun<=int1max+int10max+int100max+int1000max+int10000max+int100000max+int1000000max+int10000000max+int100000000max;
    end if;
end process;



process (numberfeed,DOUT5,DOUT6,DOUT7,int100numberfeed,int10numberfeed,int1numberfeed) begin
    if (numberfeed='1') then
    --100‚ÌˆÊ  10ƒÊS
    int100numberfeed <= "1100100"* DOUT5;
    --10‚ÌˆÊ 1ƒÊS
    int10numberfeed <= "0001010" * DOUT6;    
    --1‚ÌˆÊ 100nS * 1
    int1numberfeed<= "0000001" * DOUT7;
    maxindex<=int1numberfeed+int10numberfeed+int100numberfeed;
    maxindex_int<=CONV_INTEGER(unsigned(maxindex));
    end if;
end process;


--set total counting time ms
process (AMPsetout,DOUT4,DOUT5,DOUT6,DOUT7,int1AMPsetout,int10AMPsetout,int100AMPsetout,int1000AMPsetout) begin
    if (AMPsetout='1') then
     --1000‚ÌˆÊ 
    int1000AMPsetout <=  DOUT4 *"00000100110001001011010000000";
    --100‚ÌˆÊ 
    int100AMPsetout <= DOUT5 * "00000000011110100001001000000" ;
    --10‚ÌˆÊ 
    int10AMPsetout <=  DOUT6 * "00000000000011000011010100000";
    --1‚ÌˆÊ milisecond
    int1AMPsetout <= "00000000000000010011100010000" * DOUT7;
    WAMPsetout<=int1AMPsetout+int10AMPsetout+int100AMPsetout+int1000AMPsetout;
    end if;
end process;


--set total counting time ms
process (APDtimeset,DOUT0,DOUT0,DOUT1,DOUT2,DOUT3,int1APDtimeset,int10APDtimeset,int100APDtimeset,int1000APDtimeset) begin
    if (APDtimeset='1') then
     --1000‚ÌˆÊ 
    int1000APDtimeset <=  DOUT4 *"00000100110001001011010000000";
    --100‚ÌˆÊ 
    int100APDtimeset <= DOUT5 * "00000000011110100001001000000" ;
    --10‚ÌˆÊ 
    int10APDtimeset <=  DOUT6 * "00000000000011000011010100000";
    --1‚ÌˆÊ milisecond
    int1APDtimeset <= "00000000000000010011100010000" * DOUT7;
    WAPDtimeset<=int1APDtimeset+int10APDtimeset+int100APDtimeset+int1000APDtimeset;
    end if;
end process;



end Behavioral;
