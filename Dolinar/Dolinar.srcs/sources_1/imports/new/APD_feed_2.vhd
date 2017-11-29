library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.numeric_std.ALL;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
entity APD_feed_2 is
  Port (sw : in std_logic_vector (3 downto 0);
       led: out  std_logic_vector (15 downto 0);
       clk : in std_logic;
--       clk_photon_cnt : in std_logic;
       clk_out : in std_logic;
       JB: in  std_logic;
       JD: out  std_logic_vector (7 downto 4);
       RsRx : in  std_logic;
       Run : in  std_logic;
       ascii0: out std_logic_vector (7 downto 0);
       ascii1: out std_logic_vector (7 downto 0);
       ascii2: out std_logic_vector (7 downto 0);
       ascii3: out std_logic_vector (7 downto 0);
       ascii4: out std_logic_vector (7 downto 0);
       ascii5: out std_logic_vector (7 downto 0);
       ascii6: out std_logic_vector (7 downto 0);
       ascii7: out std_logic_vector (7 downto 0);
       datasent: in  std_logic;
       countDISbin: out  std_logic;
       ampdis : out std_logic_vector (15 downto 0);
       ampdisdef : in std_logic_vector (15 downto 0);
       ampdison : in std_logic_vector (15 downto 0);
       ampdisoff : in std_logic_vector (15 downto 0);
       changeamp: out  std_logic;
       SGIN0: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN1: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN2: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN3: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN4: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN5: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN6: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN7: out std_logic_vector  (3 downto 0):= (others => '0');
       change: out  std_logic;
       finconvAMPMOD : in  std_logic;
       clkPmod : in std_logic
               );
end APD_feed_2;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
architecture Behavioral of APD_feed_2 is

component UART_feed_N is 
 port (clkoriginal : in std_logic;
       clk_UART : in std_logic;
       RsRx : in  std_logic;
       dataoutm1: out std_logic_vector (3 downto 0):= (others => '0');
       dataout0 : out std_logic_vector (3 downto 0):= (others => '0');
       dataout1 : out std_logic_vector (3 downto 0):= (others => '0');
       dataout2 : out std_logic_vector (3 downto 0):= (others => '0');
       dataout3 : out std_logic_vector (3 downto 0):= (others => '0');
       dataout4 : out std_logic_vector (3 downto 0):= (others => '0');
       dataout5 : out std_logic_vector (3 downto 0):= (others => '0');
       dataout6 : out std_logic_vector (3 downto 0):= (others => '0');
       dataout7 : out std_logic_vector (3 downto 0):= (others => '0');
       dataoutm1d: out std_logic_vector (3 downto 0):= (others => '0');
       dataout0d : out std_logic_vector (3 downto 0):= (others => '0');
       dataout1d : out std_logic_vector (3 downto 0):= (others => '0');
       dataout2d : out std_logic_vector (3 downto 0):= (others => '0');
       dataout3d : out std_logic_vector (3 downto 0):= (others => '0');
       dataout4d : out std_logic_vector (3 downto 0):= (others => '0');
       dataout5d : out std_logic_vector (3 downto 0):= (others => '0');
       dataout6d : out std_logic_vector (3 downto 0):= (others => '0');
       dataout7d : out std_logic_vector (3 downto 0):= (others => '0');
       setout : out  std_logic :='0';
       dolinarsetout : out  std_logic :='0';
       phasemodzero: out std_logic:='0';
       phasemodpi: out std_logic:='0';
       minchange : out  std_logic :='0';
       maxchange : out  std_logic :='0';
       numberfeed : out  std_logic :='0'
       );
end component;

component clk_UART_receiver is 
 port (clk_i :in std_logic;
       clk_o :out std_logic
       );
end component;


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

COMPONENT DA_Pmod_feed
  Port (
      clkPmod : in std_logic;
      clk_out : in std_logic;
      JDPmod : out std_logic_vector (7 downto 4);
      analogbit : in std_logic_vector (15 downto 0);
      updateana : in std_logic:='0';
      finconv : out std_logic:='0'
      );
END COMPONENT;


------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT div_gen_3
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT div_gen_6
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

--component clk_wiz_1
--port
-- (-- Clock in ports
--  clk_in1           : in     std_logic;
--  -- Clock out ports
--  clk_out1          : out    std_logic
-- );
--end component;

------------------------------------------------------------------------------------------------
signal I : std_logic_vector(32 downto 0):= (others => '0');
signal binchange : std_logic_vector(32 downto 0):= (others => '0');

signal j : std_logic_vector(50 downto 0):= (others => '0');

signal cnt : std_logic_vector(32 downto 0):= (others => '0');
signal cnt2 : std_logic_vector(32 downto 0):= (others => '0');

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
signal DOUTm1D  : std_logic_vector (3 downto 0);
signal DOUT0D  : std_logic_vector (3 downto 0);
signal DOUT1D  : std_logic_vector (3 downto 0);
signal DOUT2D  : std_logic_vector (3 downto 0);
signal DOUT3D  : std_logic_vector (3 downto 0);
signal DOUT4D  : std_logic_vector (3 downto 0);
signal DOUT5D  : std_logic_vector (3 downto 0);
signal DOUT6D  : std_logic_vector (3 downto 0);
signal DOUT7D  : std_logic_vector (3 downto 0);
signal int1  : std_logic_vector (32 downto 0):= (others => '0');
signal int10  : std_logic_vector (32 downto 0):= (others => '0');
signal int100  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000000  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000000  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000000  : std_logic_vector (32 downto 0):= (others => '0');

signal int1D  : std_logic_vector (32 downto 0):= (others => '0');
signal int10D  : std_logic_vector (32 downto 0):= (others => '0');
signal int100D  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000D  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000D  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000D  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000000D  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000000D  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000000D  : std_logic_vector (32 downto 0):= (others => '0');

signal timesegindex10 : std_logic_vector (7 downto 0):= (others => '0');
signal timesegindex1 : std_logic_vector (7 downto 0):= (others => '0');
signal timesegindex : std_logic_vector (7 downto 0):= (others => '0');
signal timesegindex_int : integer range 0 to 10;

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

signal W  : std_logic_vector (32 downto 0):= "000000000000000000000001111101000";
signal WA  : std_logic_vector (32 downto 0):= "000000000000000000000000111110100";
signal Wzero  :  integer;
--signal Wpi :  integer;
signal W2  :  integer;
--signal W2pi :  integer;

signal SO  : std_logic :='0';
signal DO  : std_logic :='0';
signal phasemodzero: std_logic:='0';
signal phasemodzero_reg: std_logic:='0';
signal phasemodpi: std_logic:='0';
signal phasemodpi_reg: std_logic:='0';
signal rest: std_logic :='0';
signal okrun: std_logic_vector (32 downto 0):= "000000000000000000000001111101000";
signal minokrun: std_logic_vector (32 downto 0):= "000000000000000000000001111101000";
signal maxokrun: std_logic_vector (32 downto 0):= "000000000000000000000001111101000";
signal minchange : std_logic :='0';
signal maxchange : std_logic :='0';
signal numberfeed : std_logic :='0';


signal p  : std_logic_vector (3 downto 0):= (others => '0');
signal q  : natural;
signal startconv: std_logic :='0';
signal psipluscountDIS1000: std_logic_vector (3 downto 0):= (others => '0');
signal psipluscountDIS100: std_logic_vector (3 downto 0):= (others => '0');
signal psipluscountDIS10: std_logic_vector (3 downto 0):= (others => '0');
signal psipluscountDIS1: std_logic_vector (3 downto 0):= (others => '0');
signal psiminuscountDIS1000: std_logic_vector (3 downto 0):= (others => '0');
signal psiminuscountDIS100: std_logic_vector (3 downto 0):= (others => '0');
signal psiminuscountDIS10: std_logic_vector (3 downto 0):= (others => '0');
signal psiminuscountDIS1: std_logic_vector (3 downto 0):= (others => '0');




signal Wstd:  std_logic_vector (31 downto 0);
signal Wstdpi:  std_logic_vector (31 downto 0);
signal stage : std_logic_vector(2 downto 0):= (others => '0');
signal status: std_logic_vector  (4 downto 0):= (others => '0');
signal stagepi : std_logic_vector(2 downto 0):= (others => '0');
signal statuspi: std_logic_vector  (4 downto 0):= (others => '0');
signal s_axis_divisor_tvalid : std_logic :='0';
signal s_axis_divisor_tdata :  std_logic_vector  (15 downto 0):= (others => '0');
signal s_axis_dividend_tvalid : std_logic :='0';
signal s_axis_dividend_tdata:  std_logic_vector  (31 downto 0):= (others => '0');
signal m_axis_dout_tvalid: std_logic :='0';
signal m_axis_dout_tdata :  std_logic_vector  (47 downto 0):= (others => '0');
signal Vquotient : std_logic_vector (31 downto 0);
signal Vreminder : std_logic_vector (14 downto 0);
signal finish : std_logic :='0';
signal Vquotientpi : std_logic_vector (31 downto 0);
signal Voutzero : std_logic_vector (15 downto 0);
signal Voutpi : std_logic_vector (15 downto 0);


signal analogbit : std_logic_vector (15 downto 0);
signal finconv : std_logic:='0';
signal changeamp_reg : std_logic;
signal change_phase : std_logic;
signal parity : std_logic;



type timesegment2 is array (0 to 10) of std_logic_vector (32 downto 0);
signal timesegment :timesegment2;
signal stageDO : std_logic_vector (2 downto 0);
signal index : integer range 0 to 15;
signal index2 : integer range 0 to 15;
signal maxindex : std_logic_vector (10 downto 0);
signal maxindex_int : integer;
signal int1numberfeed  : std_logic_vector (10 downto 0):= (others => '0');
signal int10numberfeed  : std_logic_vector (10 downto 0):= (others => '0');
signal int100numberfeed  : std_logic_vector (10 downto 0):= (others => '0');
signal cntresult : std_logic_vector (10 downto 0):= (others => '0');


signal cnt00000000000:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000001:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000010:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000011:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000100:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000101:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000110:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000111:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001000:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001001:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001010:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001011:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001100:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001101:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001110:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001111:std_logic_vector (15 downto 0):= (others => '0');
signal cnt11111111111:std_logic_vector (15 downto 0):= (others => '0');

signal transdata0:std_logic_vector (15 downto 0):= (others => '0');
signal transdata1:std_logic_vector (15 downto 0):= (others => '0');

signal psiplus:std_logic_vector (15 downto 0):= (others => '0');
signal psiminus:std_logic_vector (15 downto 0):= (others => '0');
signal s_axis_divisor_tvalid_div3 : std_logic :='0';
signal s_axis_divisor_tdata_div3 :  std_logic_vector  (15 downto 0):= (others => '0');
signal s_axis_dividend_tvalid_div3 : std_logic :='0';
signal s_axis_dividend_tdata_div3:  std_logic_vector  (15 downto 0):= (others => '0');
signal m_axis_dout_tvalid_div3: std_logic :='0';
signal m_axis_dout_tdata_div3 :  std_logic_vector  (31 downto 0):= (others => '0');
signal Vquotient_div3 : std_logic_vector (13 downto 0);
signal Vreminder_div3 : std_logic_vector (9 downto 0);
signal parityt  : integer;
signal paritytt  : integer;
signal s_axis_divisor_tvalid_div3_2 : std_logic :='0';
signal s_axis_divisor_tdata_div3_2 :  std_logic_vector  (15 downto 0):= (others => '0');
signal s_axis_dividend_tvalid_div3_2 : std_logic :='0';
signal s_axis_dividend_tdata_div3_2:  std_logic_vector  (15 downto 0):= (others => '0');
signal m_axis_dout_tvalid_div3_2: std_logic :='0';
signal m_axis_dout_tdata_div3_2 :  std_logic_vector  (31 downto 0):= (others => '0');
signal Vquotient_div3_2 : std_logic_vector (13 downto 0);
signal Vreminder_div3_2 : std_logic_vector (9 downto 0);
signal pp  : std_logic_vector (3 downto 0):= (others => '0');

signal clk_photon_cnt :  std_logic:='0';
signal y :  std_logic:='0';
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
begin
iclk_UART: clk_UART_receiver port map(clk_i=>clk, clk_o=>clk_U);
iUART: UART_feed_N port map(clkoriginal=> clk, clk_UART=>clk_U, RsRx=>RsRx,
dataoutm1=>DOUTm1,dataout0=>DOUT0,dataout1=>DOUT1,dataout2=>DOUT2,dataout3=>DOUT3,dataout4=>DOUT4,dataout5=>DOUT5,dataout6=>DOUT6,dataout7=>DOUT7,
dataoutm1d=>DOUTm1D,dataout0d=>DOUT0D,dataout1d=>DOUT1D,dataout2d=>DOUT2D,dataout3d=>DOUT3D,dataout4d=>DOUT4D,dataout5d=>DOUT5D,dataout6d=>DOUT6D,dataout7d=>DOUT7D, 
setout=>SO, dolinarsetout=>DO, phasemodzero=>phasemodzero, phasemodpi=>phasemodpi, minchange=>minchange, maxchange=>maxchange,numberfeed=>numberfeed);
idiv_gen_5 : div_gen_5
  PORT MAP (
    aclk => clk,
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => s_axis_divisor_tdata,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => s_axis_dividend_tdata,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tdata => m_axis_dout_tdata
  );
  
--iDA_Pmod_feed: DA_Pmod_feed port map(
--     clkPmod=>clkPmod,
--     clk_out=>clk_out,
--     JDPmod=>JD,
--     analogbit=>analogbit,
--     updateana=>change_phase,
--     finconv=>finconv);
     
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
idiv_gen_3 : div_gen_3
PORT MAP (
 aclk => clk,
 s_axis_divisor_tvalid => s_axis_divisor_tvalid_div3,
 s_axis_divisor_tdata => s_axis_divisor_tdata_div3,
 s_axis_dividend_tvalid => s_axis_dividend_tvalid_div3,
 s_axis_dividend_tdata => s_axis_dividend_tdata_div3,
 m_axis_dout_tvalid => m_axis_dout_tvalid_div3,
 m_axis_dout_tdata => m_axis_dout_tdata_div3
);
-- INST_TAG_END ------ End INSTANTIATION Template ---------

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
idiv_gen_6 : div_gen_6
PORT MAP (
 aclk => clk,
 s_axis_divisor_tvalid => s_axis_divisor_tvalid_div3_2,
 s_axis_divisor_tdata => s_axis_divisor_tdata_div3_2,
 s_axis_dividend_tvalid => s_axis_dividend_tvalid_div3_2,
 s_axis_dividend_tdata => s_axis_dividend_tdata_div3_2,
 m_axis_dout_tvalid => m_axis_dout_tvalid_div3_2,
 m_axis_dout_tdata => m_axis_dout_tdata_div3_2
);
-- INST_TAG_END ------ End INSTANTIATION Template ---------

--clkphotoncnt : clk_wiz_1
--   port map ( 
--   -- Clock in ports
--   clk_in1 => clk,
--  -- Clock out ports  
--   clk_out1 => clk_photon_cnt              
-- );


---------------------------------------------------------------------------
-----------------------



process (sw(0),clk_out,Run,ampdisdef) begin   
if ( clk_out'event and clk_out = '1') then
    if (sw(0)='1') then
        j<= (others => '0');
        cnt<= (others => '0');
        cnt2<= (others => '0');
        I<= (others => '0'); 
        rest<='0';
        analogbit<=(others => '0');
        ampdis<=ampdisdef;
        changeamp_reg<='0';
        okrun<= (others => '0');
        startconv<='0';
        parity <= '0';
        index<= 0;
        index2<= 0;
        cntresult<= (others => '0');  
        psiplus<=(others => '0'); 
        psiminus<=(others => '0'); 
        cnt00000000000<=(others => '0');
        cnt00000000001<=(others => '0');
        cnt00000000010<=(others => '0');
        cnt00000000011<=(others => '0');
        cnt00000000100<=(others => '0');
        cnt00000000101<=(others => '0');
        cnt00000000110<=(others => '0');
        cnt00000000111<=(others => '0');
        cnt00000001000<=(others => '0');
        cnt00000001001<=(others => '0');
        cnt00000001010<=(others => '0');
        cnt00000001011<=(others => '0');
        cnt00000001100<=(others => '0');
        cnt00000001101<=(others => '0');        
        cnt00000001110<=(others => '0');        
        cnt00000001111<=(others => '0');        
        cnt11111111111<=(others => '0');
        binchange<=timesegment(0);
        JD(7)<='0';
    else 
            if (Run='1') then
              if (index=maxindex_int) then
               if (j=0) then
                j<=j+1; 
                ampdis<=ampdisdef;
                changeamp_reg<='1';
                analogbit<= Voutzero; 
                JD(7)<='0';
                y<='0';
               elsif (j=1) then
                cnt<= (others => '0'); 
                cnt2<= (others => '0'); 
                startconv<='0'; 
--                if (finconvAMPMOD='1') then
                    if (maxokrun>=okrun and okrun>=minokrun) then
                    case  cntresult is 
                        when "00000000000"=>
                            cnt00000000000<=cnt00000000000+1;
                        when "00000000001"=>
                            cnt00000000001<=cnt00000000001+1;
                        when "00000000010"=>
                            cnt00000000010<=cnt00000000010+1;
                        when "00000000011"=>
                            cnt00000000011<=cnt00000000011+1;
                        when "00000000100"=>
                            cnt00000000100<=cnt00000000100+1;
                        when "00000000101"=>
                            cnt00000000101<=cnt00000000101+1;
                        when "00000000110"=>
                            cnt00000000110<=cnt00000000110+1;             
                        when "00000000111"=>
                            cnt00000000111<=cnt00000000111+1;
                        when "00000001000"=>
                            cnt00000001000<=cnt00000001000+1;                
                        when "00000001001"=>
                            cnt00000001001<=cnt00000001001+1;                
                        when "00000001010"=>
                            cnt00000001010<=cnt00000001010+1;
                        when "00000001011"=>
                            cnt00000001011<=cnt00000001011+1;
                        when "00000001100"=>
                            cnt00000001100<=cnt00000001100+1;
                        when "00000001101"=>
                            cnt00000001101<=cnt00000001101+1;    
                        when "00000001110"=>
                            cnt00000001110<=cnt00000001110+1;
                        when "00000001111"=>
                            cnt00000001111<=cnt00000001111+1;      
                        when others => 
                            cnt11111111111<=cnt11111111111+1;                 
                        end case;
                   end if;     
                    j<=j+1;
                    changeamp_reg<='0'; 
                    led(0)<='1';
--                end if;
              elsif (j=2) then
                  cntresult<= (others => '0');
                   j<=j+1;
                  if (okrun=2000) then
                      startconv<='1';
                      okrun<=okrun+1;  
                      led(0)<='1';

                  elsif (okrun>maxokrun and okrun<2000) then  
                      okrun<=okrun+1;  
                  elsif (minokrun>=okrun) then
                      okrun<=okrun+1;  
                  else
                      okrun<=okrun+1;
                      if (parity ='0') then
                         psiplus<=psiplus+1;
                       else    
                         psiminus<=psiminus+1;
                       end if;

--                      j<=j+1;
                  end if;   
             elsif (j=3) then
                   parity<='0';
                   startconv<='0'; 
                   binchange<=timesegment(0);
                  if (okrun=2001) then
                       j<=j;
                       led(0)<='0';
                  else     
                       j<=j+1;    
                  end if;          
               elsif (j=20000) then
                   I<= (others => '0');
                   index<=0;
                   index2<=0;
                   j<= (others => '0');                     
                else
                   j<=j+1;
               end if;
              else
                if (I <=  binchange-1) then
                    JD(7)<='1';
                    changeamp_reg<='0';
                  if (index=0) then  
                    if (j=4) then
                        j<= (others => '0');
                        cnt<=cnt+JB;
                        I<=I+1;
                    else
                        j<=j+1;
                        cnt<=cnt+JB;
                    end if;
                  else 
                        if (j=4) then
                          j<= (others => '0');
                          cnt<=cnt+JB;
                          I<=I+1;
                        else
                          j<=j+1;
                          cnt<=cnt+JB;
                          end if;
                  end if;   
                elsif (I = binchange) then
                   if (j=4) then
                       j<= (others => '0');
                       cnt2<=(others => '0'); 
                       I<= "000000000000000000000000000000001";
                       binchange<=timesegment(index2);
                       changeamp_reg<='0';
                       index<=index+1;
--                       cnt<=cnt2+JB;
                   elsif (j=3) then
--                        cnt2<=cnt2+JB;
                        j<=j+1;
                        index2<=index2+1;
                   elsif (j=0) then
--                       cnt2<=cnt2+JB;
                       j<=j+1;
                       if (maxokrun>=okrun and okrun>=minokrun) then
                           if (index<maxindex_int-1) then
                                changeamp_reg<='1';
                           end if;
                           if (cnt = 0) then
                                cntresult(index)<='0';
                                if (parity = '0') then
                                    analogbit<= Voutzero;
                                    ampdis<=ampdisoff;
--                                    if (index<maxindex_int-1) then
--                                        JD(7)<='0';
--                                    end if;                                    
                                else
                                     analogbit<= Voutpi;
                                     ampdis<=ampdison;
--                                    if (index<maxindex_int-1) then
--                                         JD(7)<='1';
--                                     end if;
                                end if;                         
                           else
                                cntresult(index)<='1';
                                parity <= not parity;
                                if (parity = '1') then
                                   analogbit<= Voutzero;
                                   ampdis<=ampdisoff;
--                                   if (index<maxindex_int-1) then
--                                       JD(7)<='0';
--                                   end if;
                                else
                                    analogbit<= Voutpi;
                                    ampdis<=ampdison;
--                                   if (index<maxindex_int-1) then
--                                       JD(7)<='1';
--                                    end if;
                                end if;                         
                           end if;

                     end if;      
                   else
                       j<=j+1;
--                       cnt2<=cnt2+JB;
                       cnt<= (others => '0'); 
                   end if;
                end if;
              end if;       
            else
                j<= (others => '0');
                cnt<= (others => '0');
                cnt2<= (others => '0');
                if (y='0') then
                    changeamp_reg<='1';
                    y<='1';  
                else
                    changeamp_reg<='0';
                end if;     
                startconv<='0'; 
                I<= (others => '0'); 
                analogbit<= Voutzero;
                ampdis<=ampdisdef;
                okrun<= (others => '0');
                parity <= '0';
                index<=0;         
                index2<=0;
                cntresult<= (others => '0');  
                psiplus<=(others => '0'); 
                psiminus<=(others => '0'); 
                cnt00000000000<=(others => '0');
                cnt00000000001<=(others => '0');
                cnt00000000010<=(others => '0');
                cnt00000000011<=(others => '0');
                cnt00000000100<=(others => '0');
                cnt00000000101<=(others => '0');
                cnt00000000110<=(others => '0');
                cnt00000000111<=(others => '0');
                cnt00000001000<=(others => '0');
                cnt00000001001<=(others => '0');
                cnt00000001010<=(others => '0');
                cnt00000001011<=(others => '0');
                cnt00000001100<=(others => '0');
                cnt00000001101<=(others => '0');        
                cnt00000001110<=(others => '0');        
                cnt00000001111<=(others => '0');        
                cnt11111111111<=(others => '0');
                binchange<=timesegment(0);
                JD(7)<='0';
            end if;
    end if;
end if;
end process;
change_phase<=changeamp_reg or phasemodzero;
changeamp<=changeamp_reg;

--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
process (sw) begin
if (sw(1)='0' and sw(2)='0' and sw(3)='0') then
    transdata0<=psiplus;
    transdata1<=psiminus;
elsif (sw(1)='1' and sw(2)='0' and sw(3)='0') then    
    transdata0<=cnt00000000000;
    transdata1<=cnt00000000011;
elsif (sw(1)='0' and sw(2)='1' and sw(3)='0') then    
    transdata0<=cnt00000000000;
    transdata1<=cnt00000000010;
elsif (sw(1)='1' and sw(2)='1' and sw(3)='0') then    
    transdata0<=cnt00000000000;
    transdata1<=cnt00000000001;
elsif (sw(1)='0' and sw(2)='0' and sw(3)='1') then    
    transdata0<=cnt00000000001;
    transdata1<=cnt00000000011;
elsif (sw(1)='1' and sw(2)='0' and sw(3)='1') then    
    transdata0<=cnt00000000010;
    transdata1<=cnt00000000011;
elsif (sw(1)='0' and sw(2)='1' and sw(3)='1') then    
    transdata0<=cnt00000000001;
    transdata1<=cnt00000000010;
end if;
end process;
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------

----To show count on the 7-segment display
process (clk_out,startconv,datasent,transdata0) begin
if (clk_out'event and clk_out = '1') then
case p is
    when  "0000" =>
        if (startconv='1') then   
            p<="0001";
        else
            p<="0000";
        end if;
    when  "0001" =>
        case parityt is 
        when 0 =>  s_axis_divisor_tdata_div3<="0000001111101000";  
                   s_axis_dividend_tdata_div3<=transdata0;   
        when 1 =>  s_axis_divisor_tdata_div3<="0000000001100100";  
                   s_axis_dividend_tdata_div3<="000000"&Vreminder_div3; 
        when 2 =>  s_axis_divisor_tdata_div3<="0000000000001010";  
                   s_axis_dividend_tdata_div3<="000000"&Vreminder_div3;
        when 3 =>  s_axis_divisor_tdata_div3<="0000000000000001";  
                   s_axis_dividend_tdata_div3<="000000"&Vreminder_div3; 
        when others => s_axis_divisor_tdata_div3 <="0000000000000001";
        end case;   
        p<=p+1;
    when  "0010" =>
        s_axis_divisor_tvalid_div3<='1';
        s_axis_dividend_tvalid_div3<='1';
        p<=p+1;
  when  "0011" =>  
        if (m_axis_dout_tvalid_div3='1') then
             s_axis_divisor_tvalid_div3<='0';
             s_axis_dividend_tvalid_div3<='0';
             p<=p+1;
        end if;    
   when "0100" => 
         if (m_axis_dout_tvalid_div3='0') then
             Vquotient_div3 <=m_axis_dout_tdata_div3(29 downto 16);
             Vreminder_div3 <=m_axis_dout_tdata_div3(9 downto 0);
             p<=p+1;
         end if; 
   when "0101" => 
        case parityt is 
        when 0 => psipluscountDIS1000<= Vquotient_div3 (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 1 => psipluscountDIS100<= Vquotient_div3 (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 2 => psipluscountDIS10<= Vquotient_div3 (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 3 => psipluscountDIS1<= Vquotient_div3 (3 downto 0);
                  parityt<=0;
                  p<=p+1;
        when others =>   parityt<=0;  
                         p<="0000"; 
        end case;                          
    when "0110" =>
       case psipluscountDIS1000 is 
       when "0000" => ascii0 <="00110000";
       when  "0001"=> ascii0 <="00110001";
       when  "0010"=> ascii0 <="00110010";
       when  "0011"=> ascii0 <="00110011";
       when  "0100"=> ascii0 <="00110100";
       when  "0101"=> ascii0 <="00110101";
       when  "0110"=> ascii0 <="00110110";
       when  "0111"=> ascii0 <="00110111";
       when  "1000"=> ascii0 <="00111000";
       when  "1001"=> ascii0 <="00111001";
       when others => ascii0 <= "00110000";
       end case;
   
   
       case psipluscountDIS100 is 
       when "0000" => ascii1 <="00110000";
       when  "0001"=> ascii1 <="00110001";
       when  "0010"=> ascii1 <="00110010";
       when  "0011"=> ascii1 <="00110011";
       when  "0100"=> ascii1 <="00110100";
       when  "0101"=> ascii1 <="00110101";
       when  "0110"=> ascii1 <="00110110";
       when  "0111"=> ascii1 <="00110111";
       when  "1000"=> ascii1 <="00111000";
       when  "1001"=> ascii1 <="00111001";
       when others => ascii1 <= "00110000";
       end case;
       
       case psipluscountDIS10 is 
       when "0000" => ascii2 <="00110000";
       when  "0001"=> ascii2 <="00110001";
       when  "0010"=> ascii2 <="00110010";
       when  "0011"=> ascii2 <="00110011";
       when  "0100"=> ascii2 <="00110100";
       when  "0101"=> ascii2 <="00110101";
       when  "0110"=> ascii2 <="00110110";
       when  "0111"=> ascii2 <="00110111";
       when  "1000"=> ascii2 <="00111000";
       when  "1001"=> ascii2 <="00111001";
       when others => ascii2<= "00110000";
       end case;
       
       case psipluscountDIS1 is 
       when "0000" => ascii3 <="00110000";
       when  "0001"=> ascii3 <="00110001";
       when  "0010"=> ascii3 <="00110010";
       when  "0011"=> ascii3 <="00110011";
       when  "0100"=> ascii3 <="00110100";
       when  "0101"=> ascii3 <="00110101";
       when  "0110"=> ascii3 <="00110110";
       when  "0111"=> ascii3 <="00110111";
       when  "1000"=> ascii3 <="00111000";
       when  "1001"=> ascii3 <="00111001";
       when others => ascii3<= "00110000";
       end case;
       p<=p+1;
    when "0111" =>
       countDISbin<='1';
       p<=p+1;
    when "1000" =>
     countDISbin<='0';   
      p<=p+1;
    when "1001" => 
     if(datasent='1') then 
       p<=p+1;
     end if;
    when "1010" =>
        p<=p+1;
    when "1011" =>        
        p<="0000";
    when others => p<="0000";
    end case;
 end if;
end process;

--To show count on the 7-segment display
process (clk_out,startconv,datasent,transdata1) begin
if (clk_out'event and clk_out = '1') then
case pp is
    when  "0000" =>
        if (startconv='1') then   
            pp<="0001";
        else
            pp<="0000";
        end if;
    when  "0001" =>
        case paritytt is 
        when 0 =>  s_axis_divisor_tdata_div3_2<="0000001111101000";  
                   s_axis_dividend_tdata_div3_2<=transdata1;
        when 1 =>  s_axis_divisor_tdata_div3_2<="0000000001100100";  
                   s_axis_dividend_tdata_div3_2<="000000"&Vreminder_div3_2;                   
        when 2 =>  
                   s_axis_divisor_tdata_div3_2<="0000000000001010";  
                   s_axis_dividend_tdata_div3_2<="000000"&Vreminder_div3_2;                           
        when 3 => 
                   s_axis_divisor_tdata_div3_2<="0000000000000001";  
                   s_axis_dividend_tdata_div3_2<="000000"&Vreminder_div3_2;                    
        when others => 
                       s_axis_divisor_tdata_div3_2 <="0000000000000001";
        end case;   
        pp<=pp+1;
    when  "0010" =>
        s_axis_divisor_tvalid_div3_2<='1';
        s_axis_dividend_tvalid_div3_2<='1';        
        pp<=pp+1;
  when  "0011" =>  
        if (m_axis_dout_tvalid_div3_2='1') then
             s_axis_divisor_tvalid_div3_2<='0';
             s_axis_dividend_tvalid_div3_2<='0';
             pp<=pp+1;
        end if;    
   when "0100" => 
         if (m_axis_dout_tvalid_div3_2='0') then
             Vquotient_div3_2 <=m_axis_dout_tdata_div3_2(29 downto 16);
             Vreminder_div3_2 <=m_axis_dout_tdata_div3_2(9 downto 0);
             pp<=pp+1;
         end if; 
   when "0101" =>  
        case paritytt is 
        when 0 => psiminuscountDIS1000<= Vquotient_div3_2 (3 downto 0);
                  pp<="0001";
                  paritytt<=paritytt+1;
        when 1 => psiminuscountDIS100<= Vquotient_div3_2 (3 downto 0);
                  pp<="0001";
                  paritytt<=paritytt+1;
        when 2 => psiminuscountDIS10<= Vquotient_div3_2 (3 downto 0);
                  pp<="0001";
                  paritytt<=paritytt+1;
        when 3 => psiminuscountDIS1<= Vquotient_div3_2 (3 downto 0);
                  paritytt<=0;
                  pp<=pp+1;
        when others =>   paritytt<=0;  
                         pp<="0000"; 
        end case;                          
    when "0110" =>

       case psiminuscountDIS1000 is 
       when "0000" => ascii4 <="00110000";
       when  "0001"=> ascii4 <="00110001";
       when  "0010"=> ascii4 <="00110010";
       when  "0011"=> ascii4 <="00110011";
       when  "0100"=> ascii4 <="00110100";
       when  "0101"=> ascii4 <="00110101";
       when  "0110"=> ascii4 <="00110110";
       when  "0111"=> ascii4 <="00110111";
       when  "1000"=> ascii4 <="00111000";
       when  "1001"=> ascii4<="00111001";
       when others => ascii4<= "00110000";
       end case;
       
       case psiminuscountDIS100 is 
       when "0000" => ascii5 <="00110000";
       when  "0001"=> ascii5 <="00110001";
       when  "0010"=> ascii5 <="00110010";
       when  "0011"=> ascii5 <="00110011";
       when  "0100"=> ascii5 <="00110100";
       when  "0101"=> ascii5 <="00110101";
       when  "0110"=> ascii5 <="00110110";
       when  "0111"=> ascii5 <="00110111";
       when  "1000"=> ascii5 <="00111000";
       when  "1001"=> ascii5 <="00111001";
       when others => ascii5<= "00110000";
       end case;
       
        case psiminuscountDIS10 is 
       when "0000" => ascii6 <="00110000";
       when  "0001"=> ascii6 <="00110001";
       when  "0010"=> ascii6 <="00110010";
       when  "0011"=> ascii6 <="00110011";
       when  "0100"=> ascii6 <="00110100";
       when  "0101"=> ascii6 <="00110101";
       when  "0110"=> ascii6 <="00110110";
       when  "0111"=> ascii6 <="00110111";
       when  "1000"=> ascii6 <="00111000";
       when  "1001"=> ascii6 <="00111001";
       when others => ascii6<= "00110000";
       end case;
       
       case psiminuscountDIS1 is 
       when "0000" => ascii7 <="00110000";
       when  "0001"=> ascii7 <="00110001";
       when  "0010"=> ascii7 <="00110010";
       when  "0011"=> ascii7 <="00110011";
       when  "0100"=> ascii7 <="00110100";
       when  "0101"=> ascii7 <="00110101";
       when  "0110"=> ascii7 <="00110110";
       when  "0111"=> ascii7 <="00110111";
       when  "1000"=> ascii7 <="00111000";
       when  "1001"=> ascii7 <="00111001";
       when others => ascii7<= "00110000";
       end case;
       pp<=pp+1;
    when "0111" =>
     if(datasent='1') then 
       pp<=pp+1;
     end if;
    when "1000" =>
        pp<="0000"; 
    when others => pp<="0000";
    end case;
 end if;
end process;




----set total counting time ms
--process (SO,DOUTm1,DOUT0,DOUT1,DOUT2,DOUT3,DOUT4,DOUT5,DOUT6,DOUT7,int100000000,int10000000,int1000000,int100000,int10000,int1000,int100,int10,int1) begin
--    if (SO='1') then
--     --100000000‚ÌˆÊ -1S
--    int100000000 <="00101111101011110000100000000"* DOUTm1;
--     --10000000‚ÌˆÊ -100mS
--    int10000000 <="00000100110001001011010000000"* DOUT0;
--     --1000000‚ÌˆÊ -10mS
--    int1000000 <="00000000011110100001001000000"* DOUT1;
--     --100000‚ÌˆÊ -1mS
--    int100000 <="00000000000011000011010100000"* DOUT2;
--     --10000‚ÌˆÊ 100ƒÊS
--    int10000 <="00000000000000010011100010000"* DOUT3;
--    --1000‚ÌˆÊ 10ƒÊS
--    int1000 <="00000000000000000001111101000"* DOUT4 ;
--    --100‚ÌˆÊ  1ƒÊS
--    int100 <= "00000000000000000000001100100"* DOUT5;
--    --10‚ÌˆÊ 100nS * 1
--    int10 <= "00000000000000000000000001010" * DOUT6;    
--    int1<= "00000000000000000000000000001" * DOUT7;
--    W<=int1+int10+int100+int1000+int10000+int100000+int1000000+int10000000+int100000000;
--    end if;
--end process;

process (clk,DO,DOUTm1D,DOUT0D,DOUT1D,DOUT2D,DOUT3D,DOUT4D,DOUT5D,DOUT6D,DOUT7D,int100000000D,int10000000D,int1000000D,int100000D,int10000D,int1000D,int100D,int10D,int1D) begin
if (clk'event and clk = '1') then
    case stageDO is 
    when "000" =>
        if (DO='1') then
            stageDO<=stageDO+1;
        end if;
    when "001" =>            
        timesegindex10 <= "1010" * DOUTm1D;
        timesegindex1<= "0001" * DOUT0D;
     --1000000‚ÌˆÊ -100mS
        int1000000D <="00000000011110100001001000000"* DOUT1D;
         --100000‚ÌˆÊ -10mS
        int100000D <="00000000000011000011010100000"* DOUT2D;
        --1000‚ÌˆÊ 1mS
        int10000D <="00000000000000010011100010000"* DOUT3D;
        --1000‚ÌˆÊ 100ƒÊS
        int1000D <="00000000000000000001111101000"* DOUT4D ;
        --100‚ÌˆÊ  10ƒÊS
        int100D <= "00000000000000000000001100100"* DOUT5D;
        --10‚ÌˆÊ 1ƒÊS
        int10D <= "00000000000000000000000001010" * DOUT6D;    
        --1‚ÌˆÊ 100nS * 1
        int1D<= "00000000000000000000000000001" * DOUT7D;
        stageDO<=stageDO+1;
    when "010" =>
        timesegindex<=timesegindex10+timesegindex1;
        WA<=int1D+int10D+int100D+int1000D;
        stageDO<=stageDO+1;
    when "011" => 
        timesegindex_int<=CONV_INTEGER(unsigned(timesegindex));
        WA<=WA+int10000D+int100000D+int1000000D;
        stageDO<=stageDO+1;
    when "100" => 
        timesegment(timesegindex_int)<=WA;
        stageDO<=(others=>'0');       
    when others => stageDO<=(others=>'0');
    end case;
end if;
end process;




process (clk) begin
if (clk'event and clk= '1') then
case stage is
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
     stage<=stage+1;
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
        stage<=stage+1;
        phasemodpi_reg<='1';  
    end if;
when "001"=>
    Wzero<=int1zero+int10zero+int100zero+int1000zero+int10000zero;
    stage<=stage+1;
when "010"=>
    W2<=Wzero*65536;
    stage<=stage+1;
when "011"=>
    Wstd<=conv_std_logic_vector(W2,32);
    stage<=stage+1;
when "100"=>
   case status is
   when "00000" =>
       s_axis_divisor_tdata<="0110000110101000"; 
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
--                47-16 =>quotient 14-0 => reminder
          Vquotient <=m_axis_dout_tdata(47 downto 16);
          Vreminder <=m_axis_dout_tdata(14 downto 0);
          status<="00100";
          finish<='1';
--          led<=Vquotient(15 downto 0);
        end if; 
   when "00100" =>
    if (phasemodzero_reg='1') then
        Voutzero<= Vquotient(15 downto 0);
        phasemodzero_reg<='0';
    elsif (phasemodpi_reg='1') then
        Voutpi<= Vquotient(15 downto 0);
        phasemodpi_reg<='0'; 
    end if;
    status<="00000";
    stage<=stage+1;
   when others =>  status<="00000";
   end case; 
when  "101"=>
    finish<='1';
    stage<=(others=>'0');
when others =>  stage<=(others=>'0');     
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


process (SO,DO, phasemodzero, phasemodpi,minchange,maxchange,numberfeed)
begin
if (SO='1') then
    SGIN0<=DOUTm1;
    SGIN1<=DOUT0;
    SGIN2<=DOUT1;
    SGIN3<=DOUT2;
    SGIN4<=DOUT3;
    SGIN5<=DOUT4;
    SGIN6<=DOUT5;
    SGIN7<=DOUT6;
elsif (DO='1') then
    SGIN0<=DOUTm1D;
    SGIN1<=DOUT0D;
    SGIN2<=DOUT1D;
    SGIN3<=DOUT2D;
    SGIN4<=DOUT3D;
    SGIN5<=DOUT4D;
    SGIN6<=DOUT5D;
    SGIN7<=DOUT6D;
elsif ( minchange='1' or maxchange='1' ) then
    SGIN0<=DOUT0;
    SGIN1<=DOUT1;
    SGIN2<=DOUT2;
    SGIN3<=DOUT3;
    SGIN4<=DOUT4;
    SGIN5<=DOUT5;
    SGIN6<=DOUT6;
    SGIN7<=DOUT7;
elsif (phasemodzero='1' or phasemodpi='1'or numberfeed='1') then
    SGIN0<="0000";
    SGIN1<="0000";
    SGIN2<="0000";
    SGIN3<=DOUT3;
    SGIN4<=DOUT4;
    SGIN5<=DOUT5;
    SGIN6<=DOUT6;
    SGIN7<=DOUT7;
end if;
end process;
change<=SO or DO or minchange or maxchange or phasemodzero or phasemodpi or numberfeed;
end Behavioral;
