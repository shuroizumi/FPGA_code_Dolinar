library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main_Lock is
  Port (
       sw : in std_logic;
       sw1 : in std_logic;       
       sw2 : in std_logic;
       sw3 : in std_logic;       
--       start: in std_logic;
--       switch : in std_logic_vector (3 downto 0);
       led : out std_logic_vector (15 downto 0):= (others => '0');
       clk : in std_logic;
       JA: out std_logic_vector (7 downto 4);
--       JAtop: out std_logic_vector (1 downto 0);
--       JCbottom: out  std_logic_vector (7 downto 4);
       JBbottom: out  std_logic_vector (7 downto 4);
--       JC: in  std_logic;       
       JE: in  std_logic;
--       JD: inout  std_logic_vector (7 downto 4);
       RsRx : in  std_logic;
       RsTx : out  std_logic;
       RsRts: in  std_logic;
       seg: out std_logic_vector (6 downto 0):= (others => '1');
       an: out std_logic_vector (7 downto 0):= (others => '1')
       );
end main_Lock;

architecture Behavioral of main_Lock is

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
component APD_counnter_synchronized_triangle is 
Port (sw : in std_logic;
       clk : in std_logic;
       clk_out : in std_logic;
       JB: in  std_logic;
       APDcnt : out std_logic_vector (32 downto 0):= (others => '0');
       cntdone: out  std_logic;
       update: in  std_logic;
       phiAPDin : in  std_logic_vector (7 downto 0);
       phiAPDout : out  std_logic_vector (7 downto 0);
       Run : in  std_logic;
       ascii0: out std_logic_vector (7 downto 0);
       ascii1: out std_logic_vector (7 downto 0);
       ascii2: out std_logic_vector (7 downto 0);
       ascii3: out std_logic_vector (7 downto 0);
       ascii4: out std_logic_vector (7 downto 0);
       ascii5: out std_logic_vector (7 downto 0);
       ascii6: out std_logic_vector (7 downto 0);
       ascii7: out std_logic_vector (7 downto 0);
       SGIN0: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN1: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN2: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN3: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN4: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN5: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN6: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN7: out std_logic_vector  (3 downto 0):= (others => '0');
       countDIS: out std_logic
               );
end component;


component APD_counter_revise2 is 
 port (sw : in std_logic;
       clk : in std_logic;
       clk_out : in std_logic;
       JB: in  std_logic;
       RsRx : in  std_logic;
       APDcnt : out std_logic_vector (32 downto 0):= (others => '0');
       Run : in  std_logic;
       ascii0: out std_logic_vector (7 downto 0);
       ascii1: out std_logic_vector (7 downto 0);
       ascii2: out std_logic_vector (7 downto 0);
       ascii3: out std_logic_vector (7 downto 0);
       ascii4: out std_logic_vector (7 downto 0);
       ascii5: out std_logic_vector (7 downto 0);
       ascii6: out std_logic_vector (7 downto 0);
       ascii7: out std_logic_vector (7 downto 0);
       SGIN0: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN1: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN2: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN3: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN4: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN5: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN6: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN7: out std_logic_vector  (3 downto 0):= (others => '0');
       startconversion: out  std_logic;
       startconversionSO: out  std_logic;
       cntdone: out  std_logic;
       countDIS: out  std_logic;
       finconv: in  std_logic;
       lockmode: in  std_logic
       );
end component;


component FPGA_PC_read is 
Port (clk : in std_logic;
      sw :  in std_logic;
      RsTx : out  std_logic;
      countDis : in  std_logic;
      ascii0: in std_logic_vector (7 downto 0);
      ascii1: in std_logic_vector (7 downto 0);
      ascii2: in std_logic_vector (7 downto 0);
      ascii3: in std_logic_vector (7 downto 0);
      ascii4: in std_logic_vector (7 downto 0);
      ascii5: in std_logic_vector (7 downto 0);
      ascii6: in std_logic_vector (7 downto 0);
      ascii7: in std_logic_vector (7 downto 0);
      T: in  std_logic;
      phi:in std_logic_vector (7 downto 0);
      finread: out  std_logic;
      resetPCread: in  std_logic;
      binarymode: in  std_logic;
      datasent: out  std_logic
      );
end component;

component segment is 
 port (seg : out std_logic_vector (6 downto 0):= (others => '1');
       an: out std_logic_vector (7 downto 0):= (others => '1');
       clkseg: in std_logic;
       int_o0 : in std_logic_vector (3 downto 0);
       int_o1 : in std_logic_vector (3 downto 0);
       int_o2 : in std_logic_vector (3 downto 0);
       int_o3 : in std_logic_vector (3 downto 0);
       int_o4 : in std_logic_vector (3 downto 0);
       int_o5 : in std_logic_vector (3 downto 0);
       int_o6 : in std_logic_vector (3 downto 0);
       int_o7 : in std_logic_vector (3 downto 0)  
       );
end component;

component Pmod3 is
  Port (clkori: in std_logic;
       clkPmod : in std_logic;
       clk_out : in std_logic;
       JAPmod : out std_logic_vector (7 downto 4);
       analogbit : in std_logic_vector (15 downto 0);
       updateana : in std_logic :='0';
       finconv : out std_logic:='0';
       phiin: in std_logic_vector (7 downto 0);
       phiout: out std_logic_vector (7 downto 0)
     );
end component;


COMPONENT triangle_wave
Port (clktriangle : in std_logic;
      clk_out  : in std_logic;
      led : out std_logic_vector(15 downto 0):= (others => '0');
      trianglebit : out std_logic_vector (15 downto 0);
      updatetri: out std_logic;
      phi : out  std_logic_vector (7 downto 0);
      DOUTm1: in std_logic_vector (3 downto 0);
      DOUT0 : in std_logic_vector (3 downto 0);
      DOUT1 : in std_logic_vector (3 downto 0);
      DOUT2 : in std_logic_vector (3 downto 0);
      DOUT3 : in std_logic_vector (3 downto 0);
      DOUT4 : in std_logic_vector (3 downto 0);
      DOUT5 : in std_logic_vector (3 downto 0);
      DOUT6 : in std_logic_vector (3 downto 0);
      DOUT7 : in std_logic_vector (3 downto 0);
      M  : in std_logic :='0';
      G  : in std_logic :='0';
      vstepout : out integer range 0 to 50:=1;
      waveamp : in  std_logic :='0'
      );
END COMPONENT;


COMPONENT sine_wave
Port (clktriangle : in std_logic;
      clk_out  : in std_logic;
      led : out std_logic_vector(15 downto 0):= (others => '0');
      trianglebit : out std_logic_vector (15 downto 0);
      updatetri: out std_logic;
      phi : out  std_logic_vector (7 downto 0);
      DOUTm1: in std_logic_vector (3 downto 0);
      DOUT0 : in std_logic_vector (3 downto 0);
      DOUT1 : in std_logic_vector (3 downto 0);
      DOUT2 : in std_logic_vector (3 downto 0);
      DOUT3 : in std_logic_vector (3 downto 0);
      DOUT4 : in std_logic_vector (3 downto 0);
      DOUT5 : in std_logic_vector (3 downto 0);
      DOUT6 : in std_logic_vector (3 downto 0);
      DOUT7 : in std_logic_vector (3 downto 0);
      M  : in std_logic :='0';
      G  : in std_logic :='0';
      vstepout : out integer range 0 to 50:=1;
      waveamp : in  std_logic :='0'
      );
END COMPONENT;

--50 MHz
component divja is
    Port ( clkja_i : in  STD_LOGIC;
           clkja_o : out  STD_LOGIC);
end component;


component clk_wiz_0
port
 (-- Clock in ports
  clk_in1           : in     std_logic;
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic
 );
end component;

component UART
  Port (clkoriginal : in std_logic;
       clk_UART : in std_logic;
       sw : in std_logic;
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
       setout : out  std_logic :='0';
       C : out  std_logic :='0';
       Cminus : out  std_logic :='0';
       P : out  std_logic :='0';
       I : out  std_logic :='0';
       r : out  std_logic :='0';
       L : out  std_logic :='0';
       M : out  std_logic :='0';
       G : out  std_logic :='0';
       waveamp : out  std_logic :='0';
       Run : out  std_logic :='0';
       T : out  std_logic :='0';
       polarity: out  integer range -1 to 1:=1;
       offphase : out  std_logic :='0';
       g1 : out  std_logic :='0';
       g2 : out  std_logic :='0';
       PAMPLOCK : out  std_logic :='0';
       IAMPLOCK : out  std_logic :='0';       
       rAMPLOCK : out  std_logic :='0';
       AMPLOCKpolarity: out  integer range -1 to 1:=1;
       CAMPLOCK : out  std_logic :='0';
       amplockon: out  std_logic :='0';
       z : out  std_logic :='0'; 
       x : out  std_logic :='0'; 
       v : out  std_logic :='0'; 
       u : out  std_logic :='0';
       w : out  std_logic :='0'
        );
end component;

component clk_UART_receiver is 
 port (clk_i :in std_logic;
       clk_o :out std_logic
       );
end component;

component DitherLock is
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
  WI : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  Wr : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  WL  : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  polarity : in integer range -1 to 1 := 1;
  vstepinstd : in  std_logic_vector (7 downto 0);
  offsetphase : in integer range 0 to 50:=1;
  sw1: in std_logic;
  sw2: in std_logic;
  sw3: in std_logic
   );
end component;


component Arbitrary_lock is
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
  WI : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  Wr : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  WL  : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  Wg1 : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  Wg2  : in STD_LOGIC_VECTOR(31 DOWNTO 0);  
  polarity : in integer range -1 to 1 := 1;
  vstepinstd : in  std_logic_vector (7 downto 0);
  offsetphase : in integer range 0 to 50:=1;
  sw1: in std_logic;
  sw2: in std_logic;
  sw3: in std_logic
   );
end component;


component control_PID is 
  Port (
      clk : in std_logic;
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
      L : in std_logic :='0';
      offphase : in  std_logic :='0';
      g1 : in  std_logic :='0';
      g2 : in  std_logic :='0';      
      WP  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
      WI  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
      Wr : out STD_LOGIC_VECTOR(31 DOWNTO 0);
      WL  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
      PAMPLOCK : in std_logic :='0';
      IAMPLOCK : in std_logic :='0';
      rAMPLOCK : in std_logic :='0';
      WPAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
      WIAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
      WrAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
      offsetphase : out integer range 0 to 50:=1;
      Wg1  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
      Wg2  : out STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
end component;

component setexpectedcount is 
 Port (
       clk : in std_logic;
       setexpectedcnt: out std_logic_vector (31 downto 0):= (others => '0');
       expectedVADC: out std_logic_vector (31 downto 0):= (others => '0');       
       C: in  std_logic;
       Cminus : in  std_logic :='0';
       CAMPLOCK: in  std_logic;
       DOUT0 : in std_logic_vector (3 downto 0);
       DOUT1 : in std_logic_vector (3 downto 0);
       DOUT2 : in std_logic_vector (3 downto 0);
       DOUT3 : in std_logic_vector (3 downto 0);
       DOUT4 : in std_logic_vector (3 downto 0);
       DOUT5 : in std_logic_vector (3 downto 0);
       DOUT6 : in std_logic_vector (3 downto 0);
       DOUT7 : in std_logic_vector (3 downto 0)
       );
end component;


component Vbias is
  Port (clk : in std_logic;
       RsRx : in  std_logic;
       VB : out std_logic_vector (15 downto 0):= (others => '0');
       VBAMPLOCK : out std_logic_vector (15 downto 0):= (others => '0');
       SGIN0: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN1: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN2: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN3: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN4: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN5: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN6: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN7: out std_logic_vector  (3 downto 0):= (others => '0');
       finish: out std_logic
   );
end component;



component std_vector_to_floating is
  Port (
  clk : in std_logic;
  std_vector  : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  floating  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
  convert : in std_logic
   );
end component;

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
signal APDcntsych : std_logic_vector(32 downto 0):= (others => '0');
signal cntdoneAPDsych: std_logic;
signal finconvana :  std_logic:='0';
signal phiout  : std_logic_vector (7 downto 0);
signal phiindex : std_logic_vector (7 downto 0);
signal phioutreg : std_logic_vector (7 downto 0);
signal asciiAPDsych0:  std_logic_vector (7 downto 0);
signal asciiAPDsych1:  std_logic_vector (7 downto 0);
signal asciiAPDsych2:  std_logic_vector (7 downto 0);
signal asciiAPDsych3:  std_logic_vector (7 downto 0);
signal asciiAPDsych4:  std_logic_vector (7 downto 0);
signal asciiAPDsych5:  std_logic_vector (7 downto 0);
signal asciiAPDsych6:  std_logic_vector (7 downto 0);
signal asciiAPDsych7:  std_logic_vector (7 downto 0);
signal countDISAPDsych:  std_logic;
signal SGOUTAPD0synch:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD1synch:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD2synch:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD3synch:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD4synch:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD5synch:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD6synch:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD7synch:std_logic_vector  (3 downto 0):= (others => '0');

------------------------------------------------------------------------------------------------------------
signal asciiAPD0:  std_logic_vector (7 downto 0);
signal asciiAPD1:  std_logic_vector (7 downto 0);
signal asciiAPD2:  std_logic_vector (7 downto 0);
signal asciiAPD3:  std_logic_vector (7 downto 0);
signal asciiAPD4:  std_logic_vector (7 downto 0);
signal asciiAPD5:  std_logic_vector (7 downto 0);
signal asciiAPD6:  std_logic_vector (7 downto 0);
signal asciiAPD7:  std_logic_vector (7 downto 0);
signal SGOUTAPD0:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD1:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD2:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD3:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD4:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD5:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD6:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTAPD7:std_logic_vector  (3 downto 0):= (others => '0');
signal startconversionAPD: std_logic;
signal startconversionSO: std_logic;
signal cntdoneAPD: std_logic;
signal countDISAPD:  std_logic;
signal lockmode_APD: std_logic :='0';
signal finconvana_APD: std_logic :='0';



------------------------------------------------------------------------------------------------------------
signal countDIS:  std_logic;
signal ascii0:  std_logic_vector (7 downto 0);
signal ascii1:  std_logic_vector (7 downto 0);
signal ascii2:  std_logic_vector (7 downto 0);
signal ascii3:  std_logic_vector (7 downto 0);
signal ascii4:  std_logic_vector (7 downto 0);
signal ascii5:  std_logic_vector (7 downto 0);
signal ascii6:  std_logic_vector (7 downto 0);
signal ascii7:  std_logic_vector (7 downto 0);
signal T : std_logic :='0';
signal finread:std_logic;
signal resetPCread:std_logic;
signal binarymode:std_logic;
signal datasent: std_logic;

------------------------------------------------------------------------------------------------------------
signal SGSEG0: std_logic_vector  (3 downto 0):= (others => '0');
signal SGSEG1: std_logic_vector  (3 downto 0):= (others => '0');
signal SGSEG2: std_logic_vector  (3 downto 0):= (others => '0');
signal SGSEG3: std_logic_vector  (3 downto 0):= (others => '0');
signal SGSEG4: std_logic_vector  (3 downto 0):= (others => '0');
signal SGSEG5: std_logic_vector  (3 downto 0):= (others => '0');
signal SGSEG6: std_logic_vector  (3 downto 0):= (others => '0');
signal SGSEG7: std_logic_vector  (3 downto 0):= (others => '0');

------------------------------------------------------------------------------------------------------------
signal sclk : std_logic;
signal clk_out  : std_logic;
signal anlbit : std_logic_vector (15 downto 0);
signal updatewave  : std_logic;


------------------------------------------------------------------------------------------------------------
signal noport0 :  std_logic:='0';
signal noport1  : std_logic_vector (7 downto 0);
signal noport2 : std_logic_vector (7 downto 0);


------------------------------------------------------------------------------------------------------------
signal trianglebit: std_logic_vector (15 downto 0);
signal updatetri: std_logic;
signal DOUTm1  : std_logic_vector (3 downto 0);
signal DOUT0  : std_logic_vector (3 downto 0);
signal DOUT1  : std_logic_vector (3 downto 0);
signal DOUT2  : std_logic_vector (3 downto 0);
signal DOUT3  : std_logic_vector (3 downto 0);
signal DOUT4  : std_logic_vector (3 downto 0);
signal DOUT5  : std_logic_vector (3 downto 0);
signal DOUT6  : std_logic_vector (3 downto 0);
signal DOUT7  : std_logic_vector (3 downto 0);
signal MO  : std_logic :='0';
signal GO  : std_logic :='0';
signal waveamp  : std_logic :='0';

------------------------------------------------------------------------------------------------------------
signal reset  : std_logic :='0';
signal locked  : std_logic :='0';

------------------------------------------------------------------------------------------------------------
signal clk_U : std_logic;

------------------------------------------------------------------------------------------------------------
signal SO  : std_logic :='0';
signal CO  : std_logic :='0';
signal Cminus  : std_logic :='0';
signal PO  : std_logic :='0';
signal IO  : std_logic :='0';
signal rO  : std_logic :='0';
signal RunO : std_logic :='0';
signal offphase : std_logic :='0';
signal g1 : std_logic :='0';
signal g2 : std_logic :='0';

signal L: std_logic :='0';
signal PAMPLOCK : std_logic :='0';
signal IAMPLOCK : std_logic :='0';       
signal rAMPLOCK : std_logic :='0';
signal CAMPLOCK : std_logic :='0';
signal AMPLOCKpolarity : integer range -1 to 1 := 1;
signal WPAMPLOCK  : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WIAMPLOCK  : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WrAMPLOCK  : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal mode0:std_logic;
signal mode1:std_logic;
signal mode2:std_logic;
signal mode3:std_logic;
signal mode4:std_logic;
signal amplockon:std_logic;

------------------------------------------------------------------------------------------------------------
signal gainp :  std_logic_vector (31 downto 0):= (others => '0');
signal gaini :  std_logic_vector (31 downto 0):= (others => '0');
signal r :  std_logic_vector (31 downto 0):= (others => '0');

------------------------------------------------------------------------------------------------------------
signal expectedcount : std_logic_vector(31 downto 0):= (others => '0');
signal APDcount : std_logic_vector(32 downto 0):= (others => '0');
signal lockmode: std_logic :='0';
signal updatewavelock  : std_logic;
signal Vout : std_logic_vector (15 downto 0):= (others => '0');
signal Vbiasset : std_logic_vector (15 downto 0);
signal WP  :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WI  :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Wr  :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WL  :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal polarity : integer range -1 to 1 := 1;
signal vstepout  :integer; 
signal offsetphase  :integer; 
signal Wg1  :STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Wg2  :STD_LOGIC_VECTOR(31 DOWNTO 0);


------------------------------------------------------------------------------------------------------------
signal expectedVADC : std_logic_vector(31 downto 0):= (others => '0');

------------------------------------------------------------------------------------------------------------
signal VBAMPLOCK : std_logic_vector (15 downto 0);
signal SGOUTVbias0:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTVbias1:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTVbias2:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTVbias3:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTVbias4:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTVbias5:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTVbias6:std_logic_vector  (3 downto 0):= (others => '0');
signal SGOUTVbias7:std_logic_vector  (3 downto 0):= (others => '0');
signal finishVB : std_logic :='0';


------------------------------------------------------------------------------------------------------------
signal std_vector  : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal floating : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal convert : std_logic;






begin

iAPDsynchtriangle: APD_counnter_synchronized_triangle port map(
sw =>sw,
clk=>clk,
clk_out=>clk_out, 
JB=>JE, 
APDcnt=>APDcntsych, 
cntdone=>cntdoneAPDsych, 
update=>finconvana, 
phiAPDin=>phioutreg, 
phiAPDout=>phiout, 
Run=>RunO,
ascii0=>asciiAPDsych0,
ascii1=>asciiAPDsych1,
ascii2=>asciiAPDsych2,
ascii3=>asciiAPDsych3,
ascii4=>asciiAPDsych4,
ascii5=>asciiAPDsych5,
ascii6=>asciiAPDsych6,
ascii7=>asciiAPDsych7,
SGIN0=>SGOUTAPD0synch,
SGIN1=>SGOUTAPD1synch,
SGIN2=>SGOUTAPD2synch,
SGIN3=>SGOUTAPD3synch,
SGIN4=>SGOUTAPD4synch,
SGIN5=>SGOUTAPD5synch,
SGIN6=>SGOUTAPD6synch,
SGIN7=>SGOUTAPD7synch,
countDIS=>countDISAPDsych);

--iAPD: APD_counter_revise2 port map(
--sw =>sw, 
--clk=>clk,
--clk_out=>clk_out, 
--JB=>JE,
--RsRx=>RsRx,
--APDcnt=>APDcount, 
--Run=>RunO,
--ascii0=>asciiAPD0,
--ascii1=>asciiAPD1,
--ascii2=>asciiAPD2,
--ascii3=>asciiAPD3,
--ascii4=>asciiAPD4,
--ascii5=>asciiAPD5,
--ascii6=>asciiAPD6,
--ascii7=>asciiAPD7,
--SGIN0=>SGOUTAPD0,
--SGIN1=>SGOUTAPD1,
--SGIN2=>SGOUTAPD2,
--SGIN3=>SGOUTAPD3,
--SGIN4=>SGOUTAPD4,
--SGIN5=>SGOUTAPD5,
--SGIN6=>SGOUTAPD6,
--SGIN7=>SGOUTAPD7,
--startconversion=>startconversionAPD,
--startconversionSO=>startconversionSO,
--cntdone=>cntdoneAPD,
--countDIS=>countDISAPD,
--finconv=>finconvana_APD,
--lockmode=>lockmode);


iFPGA_PC_read: FPGA_PC_read port map(
clk =>clk,
sw=>sw,
RsTx=>RsTx,
countDis=>countDIS,
ascii0=>ascii0,
ascii1=>ascii1,
ascii2=>ascii2,
ascii3=>ascii3,
ascii4=>ascii4,
ascii5=>ascii5,
ascii6=>ascii6,
ascii7=>ascii7,
T=>T,
phi=>phiout,
finread=>finread,
resetPCread=>resetPCread, 
binarymode=> binarymode,
datasent=>datasent);
 
isegment: segment port map (
seg=>seg,
an=>an,
clkseg=>clk,
int_o0=>SGSEG0,
int_o1=>SGSEG1,
int_o2=>SGSEG2,
int_o3=>SGSEG3,
int_o4=>SGSEG4,
int_o5=>SGSEG5,
int_o6=>SGSEG6,
int_o7=>SGSEG7);

iPmod3: Pmod3 port map(
clkori=>clk, clkPmod=>sclk, clk_out=>clk_out, JAPmod=>JA, analogbit=>anlbit,updateana=>updatewave,finconv=>noport0,phiin=>noport1, phiout=>noport2);

isignalmodulation: 
Pmod3 port map(
clkori=>clk, clkPmod=>sclk, clk_out=>clk_out, JAPmod=>JBbottom, analogbit=>trianglebit,updateana=>updatetri,finconv=>finconvana,phiin=>phiindex, phiout=>phioutreg);

--itriangle_wave: triangle_wave
--Port map (clktriangle =>clk,
--      clk_out =>clk_out,
----      led=>led,
--      trianglebit=>trianglebit,
--      updatetri =>updatetri,
--      phi=>phiindex,
--      DOUTm1=>DOUTm1,
--      DOUT0=>DOUT0,
--      DOUT1=>DOUT1,
--      DOUT2=>DOUT2,
--      DOUT3=>DOUT3,
--      DOUT4=>DOUT4,
--      DOUT5=>DOUT5,
--      DOUT6=>DOUT6,
--      DOUT7=>DOUT7,
--      M =>MO,
--      G =>GO,
--      vstepout=>vstepout,
--      waveamp=>waveamp      
--      );


isine_wave: sine_wave
Port map (clktriangle =>clk,
      clk_out =>clk_out,
--      led=>led,
      trianglebit=>trianglebit,
      updatetri =>updatetri,
      phi=>phiindex,
      DOUTm1=>DOUTm1,
      DOUT0=>DOUT0,
      DOUT1=>DOUT1,
      DOUT2=>DOUT2,
      DOUT3=>DOUT3,
      DOUT4=>DOUT4,
      DOUT5=>DOUT5,
      DOUT6=>DOUT6,
      DOUT7=>DOUT7,
      M =>MO,
      G =>GO,
      vstepout=>vstepout,
      waveamp=>waveamp      
      );


idivja: divja port map( clkja_i=>clk, clkja_o=>sclk);

your_instance_name: clk_wiz_0
       port map ( clk_in1 => clk ,clk_out1 => clk_out,reset => reset,locked => locked );

iclk_UART: clk_UART_receiver port map(clk_i=>clk, clk_o=>clk_U);  
iUART: UART port map(clkoriginal=>clk,clk_UART=>clk_U,sw=>sw,RsRx =>RsRx,dataoutm1=>DOUTm1,dataout0=>DOUT0,dataout1=>DOUT1,dataout2=>DOUT2,dataout3=>DOUT3,dataout4=>DOUT4,dataout5=>DOUT5,dataout6=>DOUT6,dataout7=>DOUT7,
setout=>SO,C=>CO,Cminus=>Cminus,P=>PO,I=>IO,r=>ro,L=>L,M=>MO,G=>GO,waveamp=>waveamp,Run=>RunO,T=>T,polarity=>polarity,offphase=>offphase,g1=>g1,g2=>g2,PAMPLOCK=>PAMPLOCK,IAMPLOCK=>IAMPLOCK,rAMPLOCK=>rAMPLOCK,AMPLOCKpolarity=>AMPLOCKpolarity,CAMPLOCK=>CAMPLOCK,amplockon=>amplockon,
z=>mode0,x=>mode1,v=>mode2,u=>mode3,w=>mode4);  

icontrol_PID: control_PID port map(
clk=>clk,DOUT0=>DOUT0,DOUT1=>DOUT1,DOUT2=>DOUT2,DOUT3=>DOUT3,DOUT4=>DOUT4,DOUT5=>DOUT5,DOUT6=>DOUT6,DOUT7=>DOUT7,
P=>PO,I=>IO,r=>ro,L=>L,offphase=>offphase,g1=>g1,g2=>g2,WP=>WP,WI=>WI,Wr=>Wr,WL=>WL,PAMPLOCK=>PAMPLOCK,IAMPLOCK=>IAMPLOCK,rAMPLOCK=>rAMPLOCK,WPAMPLOCK =>WPAMPLOCK ,WIAMPLOCK =>WIAMPLOCK,WrAMPLOCK =>WrAMPLOCK,offsetphase=>offsetphase,Wg1=>Wg1,Wg2=>Wg2);

--iDitherlock: DitherLock
--  Port map(
--  clk=>clk,
--  sw=>sw,
--  led=>led,
--  expectedcount=>expectedcount,
--  APDcount =>APDcntsych,
--  lockmode=>lockmode,
--  updatewavelock=>updatewavelock,
--  Vout=>Vout,
--  Vbiasset =>Vbiasset,
--  cntdoneAPD=>cntdoneAPDsych,
--  mode1=>mode1,
--  WP =>WP,
--  WI=>WI,
--  Wr=>Wr,
--  WL=>WL,
--  polarity=>polarity,
--  vstepinstd=>phiout,
--  offsetphase=>offsetphase,
--  sw1=>sw1,
--  sw2=>sw2,
--  sw3=>sw3  
--   );

iArbitrary_lock: Arbitrary_lock
  Port map(
  clk=>clk,
  sw=>sw,
  led=>led,
  expectedcount=>expectedcount,
  APDcount =>APDcntsych,
  lockmode=>lockmode,
  updatewavelock=>updatewavelock,
  Vout=>Vout,
  Vbiasset =>Vbiasset,
  cntdoneAPD=>cntdoneAPDsych,
  mode1=>mode1,
  WP =>WP,
  WI=>WI,
  Wr=>Wr,
  WL=>WL,
  Wg1=>Wg1,
  Wg2=>Wg2,
  polarity=>polarity,
  vstepinstd=>phiout,
  offsetphase=>offsetphase, 
  sw1=>sw1,
  sw2=>sw2,
  sw3=>sw3  
   );

isetexpectedcount: setexpectedcount 
port map(
clk=>clk,
setexpectedcnt=>expectedcount,
expectedVADC=>expectedVADC,
C=>CO,
Cminus=>Cminus,
CAMPLOCK=>CAMPLOCK,
DOUT0=>DOUT0,
DOUT1=>DOUT1,
DOUT2=>DOUT2,
DOUT3=>DOUT3,
DOUT4=>DOUT4,
DOUT5=>DOUT5,
DOUT6=>DOUT6,
DOUT7=>DOUT7);

--iVbias: Vbias port map(
--clk=>clk, 
--RsRx=>RsRx, 
--VB=>Vbiasset,
--VBAMPLOCK=>VBAMPLOCK,
--SGIN0=>SGOUTVbias0,
--SGIN1=>SGOUTVbias1,
--SGIN2=>SGOUTVbias2,
--SGIN3=>SGOUTVbias3,
--SGIN4=>SGOUTVbias4,
--SGIN5=>SGOUTVbias5,
--SGIN6=>SGOUTVbias6,
--SGIN7=>SGOUTVbias7,
--finish=>finishVB);



--process (sw1) begin
--if (sw1='0') then
--    led<=floating(31 DOWNTO 16);
--else
--    led<=floating(15 DOWNTO 0);
--end if;
--end process;


process (clk,updatewavelock,RunO,asciiAPDsych0,asciiAPDsych1,asciiAPDsych2,asciiAPDsych3,asciiAPDsych4,asciiAPDsych5,asciiAPDsych6,asciiAPDsych7,
mode0,mode1,mode2,mode3,mode4) begin
--scanning mode
if (clk'event and clk = '1' ) then
if (mode0='1' and mode1='0'and mode2='0'and mode3='0'and mode4='0') then
    anlbit<=Vbiasset;
    updatewave<=updatetri;
    countDIS<=countDISAPDsych;
    ascii0<=asciiAPDsych0;
    ascii1<=asciiAPDsych1;
    ascii2<=asciiAPDsych2;
    ascii3<=asciiAPDsych3;
    ascii4<=asciiAPDsych4;
    ascii5<=asciiAPDsych5;
    ascii6<=asciiAPDsych6;
    ascii7<=asciiAPDsych7;
    binarymode<='0';
    lockmode<='0';
--lock mode
elsif (mode0='0' and mode1='1'and mode2='0'and mode3='0'and mode4='0') then
    anlbit<=Vout;
--    updatewave<=updatewavelock;
    updatewave<=updatewavelock;
    countDIS<=countDISAPDsych;
    ascii0<=asciiAPDsych0;
    ascii1<=asciiAPDsych1;
    ascii2<=asciiAPDsych2;
    ascii3<=asciiAPDsych3;
    ascii4<=asciiAPDsych4;
    ascii5<=asciiAPDsych5;
    ascii6<=asciiAPDsych6;
    ascii7<=asciiAPDsych7;

--    ascii0<=asciiAPD0;
--    ascii1<=asciiAPD1;
--    ascii2<=asciiAPD2;
--    ascii3<=asciiAPD3;
--    ascii4<=asciiAPD4;
--    ascii5<=asciiAPD5;
--    ascii6<=asciiAPD6;
--    ascii7<=asciiAPD7;
    binarymode<='0';
    lockmode<='1';  
    finconvana_APD<='1';
elsif (mode0='0' and mode1='0'and mode2='0'and mode3='0'and mode4='1') then
    anlbit<=Vout;
    updatewave<='0';
    countDIS<=countDISAPD;
    ascii0<=asciiAPD0;
    ascii1<=asciiAPD1;
    ascii2<=asciiAPD2;
    ascii3<=asciiAPD3;
    ascii4<=asciiAPD4;
    ascii5<=asciiAPD5;
    ascii6<=asciiAPD6;
    ascii7<=asciiAPD7;
    binarymode<='0';
    lockmode<='1';  
    finconvana_APD<='1';
else 
    anlbit<=Vbiasset;
    updatewave<=finishVB;
    lockmode<='0';
    finconvana_APD<='0';
end if;
end if;
end process;


------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
process (SO,
--startconversionSO,feedsetting,setoutbias,countDIS,AMPcountDISAPDformeasure,startconversionSOAMP,
finishVB,clk,countDISAPDsych,
mode0,mode1,mode2,mode3,mode4) begin
 if (clk'event and clk = '1') then
    if (SO = '1') then
        SGSEG0<=DOUT0;
        SGSEG1<=DOUT1;
        SGSEG2<=DOUT2;
        SGSEG3<=DOUT3;
        SGSEG4<=DOUT4;
        SGSEG5<=DOUT5;
        SGSEG6<=DOUT6;
        SGSEG7<=DOUT7;
--    elsif (startconversionSO= '1') then
--        SGSEG0<=SGOUTAPD0;
--        SGSEG1<=SGOUTAPD1;
--        SGSEG2<=SGOUTAPD2;
--        SGSEG3<=SGOUTAPD3;
--        SGSEG4<=SGOUTAPD4;
--        SGSEG5<=SGOUTAPD5;
--        SGSEG6<=SGOUTAPD6;
--        SGSEG7<=SGOUTAPD7; 
--    elsif (feedsetting= '1') then
--        SGSEG0<=SGOUTfeed0;
--        SGSEG1<=SGOUTfeed1;
--        SGSEG2<=SGOUTfeed2;
--        SGSEG3<=SGOUTfeed3;
--        SGSEG4<=SGOUTfeed4;
--        SGSEG5<=SGOUTfeed5;
--        SGSEG6<=SGOUTfeed6;
--        SGSEG7<=SGOUTfeed7;     
--    elsif (setoutbias= '1') then
--        SGSEG0<=SGOUTsetamp0;
--        SGSEG1<=SGOUTsetamp1;
--        SGSEG2<=SGOUTsetamp2;
--        SGSEG3<=SGOUTsetamp3;
--        SGSEG4<=SGOUTsetamp4;
--        SGSEG5<=SGOUTsetamp5;
--        SGSEG6<=SGOUTsetamp6;
--        SGSEG7<=SGOUTsetamp7;     
    elsif (finishVB= '1') then
        SGSEG0<=SGOUTVbias0;
        SGSEG1<=SGOUTVbias1;
        SGSEG2<=SGOUTVbias2;
        SGSEG3<=SGOUTVbias3;
        SGSEG4<=SGOUTVbias4;
        SGSEG5<=SGOUTVbias5;
        SGSEG6<=SGOUTVbias6;
        SGSEG7<=SGOUTVbias7;     
--    elsif (startconversionSOAMP='1') then  
--        SGSEG0<=AMPSGOUTAPD0formeasure;
--        SGSEG1<=AMPSGOUTAPD1formeasure;
--        SGSEG2<=AMPSGOUTAPD2formeasure;
--        SGSEG3<=AMPSGOUTAPD3formeasure;
--        SGSEG4<=AMPSGOUTAPD4formeasure;
--        SGSEG5<=AMPSGOUTAPD5formeasure;
--        SGSEG6<=AMPSGOUTAPD6formeasure;
--        SGSEG7<=AMPSGOUTAPD7formeasure;            
    elsif (SO = '0'and countDISAPDsych='1' and mode0='1' and mode1='0'and mode2='0'and mode3='0'and mode4='0') then 
        SGSEG0<=SGOUTAPD0synch;
        SGSEG1<=SGOUTAPD1synch;
        SGSEG2<=SGOUTAPD2synch;
        SGSEG3<=SGOUTAPD3synch;
        SGSEG4<=SGOUTAPD4synch;
        SGSEG5<=SGOUTAPD5synch;
        SGSEG6<=SGOUTAPD6synch;
        SGSEG7<=SGOUTAPD7synch;         
    elsif (SO = '0'and cntdoneAPDsych='1' and mode0='0' and mode1='1'and mode2='0'and mode3='0'and mode4='0') then  
        SGSEG0<=SGOUTAPD0synch;
        SGSEG1<=SGOUTAPD1synch;
        SGSEG2<=SGOUTAPD2synch;
        SGSEG3<=SGOUTAPD3synch;
        SGSEG4<=SGOUTAPD4synch;
        SGSEG5<=SGOUTAPD5synch;
        SGSEG6<=SGOUTAPD6synch;
        SGSEG7<=SGOUTAPD7synch;         
--    elsif (SO = '0'and AMPcountDISAPDformeasure='1'and mode0='0' and mode1='0'and mode2='1'and mode3='0'and mode4='0') then  
--        SGSEG0<=AMPSGOUTAPD0formeasure;
--        SGSEG1<=AMPSGOUTAPD1formeasure;
--        SGSEG2<=AMPSGOUTAPD2formeasure;
--        SGSEG3<=AMPSGOUTAPD3formeasure;
--        SGSEG4<=AMPSGOUTAPD4formeasure;
--        SGSEG5<=AMPSGOUTAPD5formeasure;
--        SGSEG6<=AMPSGOUTAPD6formeasure;
--        SGSEG7<=AMPSGOUTAPD7formeasure;         
    elsif (SO = '0'and startconversionAPD='1' and mode0='0' and mode1='0'and mode2='0'and mode3='0'and mode4='1') then  
        SGSEG0<=SGOUTAPD0;
        SGSEG1<=SGOUTAPD1;
        SGSEG2<=SGOUTAPD2;
        SGSEG3<=SGOUTAPD3;
        SGSEG4<=SGOUTAPD4;
        SGSEG5<=SGOUTAPD5;
        SGSEG6<=SGOUTAPD6;
        SGSEG7<=SGOUTAPD7; 
    else  
        SGSEG0<=SGSEG0;
        SGSEG1<=SGSEG1;
        SGSEG2<=SGSEG2;
        SGSEG3<=SGSEG3;
        SGSEG4<=SGSEG4;
        SGSEG5<=SGSEG5;
        SGSEG6<=SGSEG6;
        SGSEG7<=SGSEG7; 
    end if;
end if;
end process;
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------




end Behavioral;