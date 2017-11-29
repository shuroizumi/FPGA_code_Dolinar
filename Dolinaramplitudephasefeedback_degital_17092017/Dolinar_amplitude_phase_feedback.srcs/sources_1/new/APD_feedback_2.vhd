library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.numeric_std.ALL;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
entity APD_feedback_2 is
  Port (sw : in std_logic;
       clk : in std_logic;
       clk_out : in std_logic;
       JB: in  std_logic;
       JD: out  std_logic_vector (7 downto 4);
       RsRx : in  std_logic;
       Run : in  std_logic;
--       led : out std_logic_vector (15 downto 0):= (others => '0');
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
end APD_feedback_2;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
architecture Behavioral of APD_feedback_2 is

component UART_feed is 
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
       maxchange : out  std_logic :='0'
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

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
signal I : std_logic_vector(32 downto 0):= (others => '0');
signal j : std_logic_vector(20 downto 0):= (others => '0');

signal cnt : std_logic_vector(32 downto 0):= (others => '0');
signal cnt2 : std_logic_vector(32 downto 0):= (others => '0');

signal cnt00 :integer;
signal cnt10 : integer;
signal cnt01 :integer;
signal cnt11 : integer;

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


signal int1zero  :  integer;
signal int10zero  :  integer;
signal int100zero :  integer;
signal int1000zero  :  integer;
signal int10000zero  :  integer;

signal int1pi  :  integer;
signal int10pi  :  integer;
signal int100pi  :  integer;
signal int1000pi  :  integer;
signal int10000pi :  integer;

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
signal Wpi :  integer;
signal W2  :  integer;
signal W2pi :  integer;

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

signal p  : std_logic_vector (3 downto 0):= (others => '0');
signal q  : natural;
signal startconv: std_logic :='0';
signal count10DIS001000: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS00100: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS0010: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS001: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS011000: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS01100: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS0110: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS011: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS101000: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS10100: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS1010: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS101: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS111000: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS11100: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS1110: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS111: std_logic_vector (3 downto 0):= (others => '0');


signal  count00 : integer;
signal  count01 : integer;
signal  count10 : integer;
signal  count11 : integer;
signal cntten00: integer;
signal cntten01: integer;
signal cntten10: integer;
signal cntten11: integer;
signal cnthund00: integer;
signal cnthund01: integer;
signal cnthund10: integer;
signal cnthund11: integer;
signal cntthou00: integer;
signal cntthou01: integer;
signal cntthou10: integer;
signal cntthou11: integer;

signal vlue00 : integer;
signal vlue01 : integer;
signal vlue10 : integer;
signal vlue11 : integer;

signal count10DIS00: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS01: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS10: std_logic_vector (3 downto 0):= (others => '0');
signal count10DIS11: std_logic_vector (3 downto 0):= (others => '0');
signal count1DIS00: std_logic_vector (3 downto 0):= (others => '0');
signal count1DIS01: std_logic_vector (3 downto 0):= (others => '0');
signal count1DIS10: std_logic_vector (3 downto 0):= (others => '0');
signal count1DIS11: std_logic_vector (3 downto 0):= (others => '0');

signal v : integer;


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
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
begin
iclk_UART: clk_UART_receiver port map(clk_i=>clk, clk_o=>clk_U);
iUART: UART_feed port map(clkoriginal=> clk, clk_UART=>clk_U, RsRx=>RsRx,dataoutm1=>DOUTm1,dataout0=>DOUT0,dataout1=>DOUT1,dataout2=>DOUT2,dataout3=>DOUT3,dataout4=>DOUT4,dataout5=>DOUT5,dataout6=>DOUT6,dataout7=>DOUT7,dataoutm1d=>DOUTm1D,dataout0d=>DOUT0D,dataout1d=>DOUT1D,dataout2d=>DOUT2D,dataout3d=>DOUT3D,dataout4d=>DOUT4D,dataout5d=>DOUT5D,dataout6d=>DOUT6D,dataout7d=>DOUT7D, setout=>SO, dolinarsetout=>DO, phasemodzero=>phasemodzero, phasemodpi=>phasemodpi, minchange=>minchange, maxchange=>maxchange);
your_instance_name : div_gen_5
  PORT MAP (
    aclk => clk,
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => s_axis_divisor_tdata,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => s_axis_dividend_tdata,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tdata => m_axis_dout_tdata
  );
  
iDA_Pmod_feed: DA_Pmod_feed port map(
     clkPmod=>clkPmod,
     clk_out=>clk_out,
     JDPmod=>JD,
     analogbit=>analogbit,
     updateana=>changeamp_reg,
     finconv=>finconv);
---------------------------------------------------------------------------
-----------------------
process (sw,clk_out,Run,ampdisdef) begin    
    if (sw='1') then
        j<= (others => '0');
        cnt<= (others => '0');
        cnt2<= (others => '0');
        cnt00<=0;
        cnt01<= 0;
        cnt10<= 0;
        cnt11<= 0;
        I<= (others => '0'); 
        rest<='0';
        analogbit<=(others => '0');
        ampdis<=ampdisdef;
        changeamp_reg<='0';
        okrun<= (others => '0');
        startconv<='0';
    elsif ( clk_out'event and clk_out = '1' and sw='0') then
        if (Run='1') then
            if (I <=  WA-1) then
                changeamp_reg<='0';
                if (j=4) then
                    j<= (others => '0');
                    cnt<=cnt+JB;
                    I<=I+1;
                else
                    j<=j+1;
                    cnt<=cnt+JB;
                end if;
            elsif (I =  WA) then
               if (okrun<minokrun) then
                   changeamp_reg<='1';
                   if (cnt = 0) then
                        analogbit<= Voutzero;
                        ampdis<=ampdisoff;
                   else
                        analogbit<= Voutpi;
                        ampdis<=ampdison;
                   end if;
               else
                  analogbit<= Voutzero;
               end if;
               if (j=4) then
                   j<= (others => '0');
                   cnt2<=cnt2+JB;
                   I<=I+1;
               else
                   j<=j+1;
                   cnt2<=cnt2+JB;
                end if;
            elsif (I > WA and I <=  W-2) then
                    changeamp_reg<='0';
                    if (j=4) then
                        j<= (others => '0');
                        cnt2<=cnt2+JB;
                        I<=I+1;
                    else
                        j<=j+1;
                        cnt2<=cnt2+JB;
                    end if;
            elsif ( I =  W-1) then
                if (j=5) then
                  if (okrun<minokrun) then
                   if (cnt=0 and cnt2=0) then
                     cnt00<=cnt00+1;
                   elsif (cnt>=1 and cnt2=0) then                   
                     cnt01<=cnt01+1;
                   elsif (cnt=0 and cnt2>=1) then                   
                     cnt10<=cnt10+1;
                   elsif (cnt>=1 and cnt2>=1) then                   
                     cnt11<=cnt11+1;
                   end if; 
                  end if;
                  j<=j+1; 
                  ampdis<=ampdisdef;
                  changeamp_reg<='1';
                elsif (j=6) then
                  cnt<= (others => '0'); 
                  cnt2<= (others => '0'); 
                  startconv<='0'; 
                  analogbit<= Voutzero; 
                  if (finconvAMPMOD='1') then
                      j<=j+1;
    --                      I<= (others => '0');
    --                      j<= (others => '0');     
                     changeamp_reg<='0'; 
                  end if;
                elsif (j=7) then
                  if (okrun<minokrun) then 
                    if (cnt00=10) then
                        cnt00<=0;
                        cntten00<=cntten00+1;
                    end if;
                    
                    if (cnt01=10) then
                        cnt01<=0;
                        cntten01<=cntten01+1;
                    end if;
                    
                    if (cnt10=10) then
                        cnt10<=0;
                        cntten10<=cntten10+1;
                    end if;
                    
                    if (cnt11=10) then
                        cnt11<=0;
                        cntten11<=cntten11+1;
                    end if;
                  end if;
                     j<=j+1;
               elsif (j=8) then
                if (okrun<minokrun) then
                   if (cntten00=10) then
                       cntten00<=0;
                       cnthund00<=cnthund00+1;
                   end if;
                   
                   if (cntten01=10) then
                       cntten01<=0;
                       cnthund01<=cnthund01+1;
                   end if;
                   
                   if (cntten10=10) then
                       cntten10<=0;
                       cnthund10<=cnthund10+1;
                   end if;
                   
                   if (cntten11=10) then
                       cntten11<=0;
                       cnthund11<=cnthund11+1;
                   end if;
                   
               end if;
                    j<=j+1;        
            
                elsif (j=9) then
                    if (okrun<minokrun) then
                     if (cnthund00=10) then
                         cnthund00<=0;
                         cntthou00<=cntthou00+1;
                     end if;
                    
                     if (cnthund01=10) then
                         cnthund01<=0;
                         cntthou01<=cntthou01+1;
                     end if;
                    
                     if (cnthund10=10) then
                         cnthund10<=0;
                         cntthou10<=cntthou10+1;
                     end if;
                    
                     if (cnthund11=10) then
                         cnthund11<=0;
                         cntthou11<=cntthou11+1;
                     end if;
                    end if;
                     j<=j+1;        
                elsif (j=10) then           
                     if (okrun<maxokrun) then
                        startconv<='0';  
                     elsif(okrun=maxokrun) then
                      startconv<='1';  
                     else
                      startconv<='0';
                     end if;   
                     j<=j+1;
                elsif (j=11) then
                     okrun<=okrun+1;
                     j<=j+1;
                elsif (j>11 and j<50) then
                     j<=j+1;
                elsif (j=50) then
                     I<= (others => '0');
                     j<= (others => '0');  
                elsif (j<=4) then
                     j<=j+1;
                     cnt2<=cnt2+JB;
                else
                    j<=j+1;
                end if;
            end if;    
        else
            j<= (others => '0');
            cnt<= (others => '0');
            cnt2<= (others => '0');
            cnt00<= 0;
            cnt01<= 0;
            cnt10<= 0;
            cnt11<= 0;
            cntten00<=0;
            cntten01<=0;
            cntten10<=0;
            cntten11<=0;
            cnthund00<=0;
            cnthund01<=0;
            cnthund10<=0;
            cnthund11<=0;
            cntthou00<=0;
            cntthou01<=0;
            cntthou10<=0;
            cntthou11<=0;
            changeamp_reg<='0';
            startconv<='0'; 
            I<= (others => '0'); 
            analogbit<= Voutzero;
            ampdis<=ampdisdef;
            okrun<= (others => '0');
        end if;
     end if;
end process;

changeamp<=changeamp_reg;
----To show count on the 7-segment display
--process (clk_out,startconv) begin
--if (clk_out'event and clk_out = '1') then
--case p is
--    when  "0000" =>
--        if (startconv='1') then   
--            p<="0001";
--        else
--            p<="0000";
--        end if;
--    when  "0001" =>
--        if (q=0) then
--            cnt00mod10<=cnt00 mod 10;
--            cnt01mod10<=cnt01 mod 10;
--            cnt10mod10<=cnt10 mod 10;
--            cnt11mod10<=cnt11 mod 10;
--            q<=q+1;
--            p<="0001";
--        elsif (q=1) then
--            count00 <= cnt00 -cnt00mod10;
--            count01 <= cnt01 -cnt01mod10;
--            count10 <= cnt10 -cnt10mod10;
--            count11 <= cnt11 -cnt11mod10;
--            q<=q+1;
--            p<="0001";
--        elsif (q=2) then
--            vlue00 <= count00/10;
--            vlue01 <= count01/10;
--            vlue10 <= count10/10;
--            vlue11 <= count11/10;
--            q<=q+1;
--            p<="0001"; 
--        elsif (q=3) then
--            count10DIS00<=conv_STD_LOGIC_VECTOR(vlue00,4);
--            count10DIS01<=conv_STD_LOGIC_VECTOR(vlue01,4);
--            count10DIS10<=conv_STD_LOGIC_VECTOR(vlue10,4);
--            count10DIS11<=conv_STD_LOGIC_VECTOR(vlue11,4);
            
--            count1DIS00<=conv_STD_LOGIC_VECTOR(cnt00mod10,4);
--            count1DIS01<=conv_STD_LOGIC_VECTOR(cnt01mod10,4);
--            count1DIS10<=conv_STD_LOGIC_VECTOR(cnt10mod10,4);
--            count1DIS11<=conv_STD_LOGIC_VECTOR(cnt11mod10,4);
--            q<=0;
--            p<="0010";
--        else
--            p<="0001"; 
--        end if;  
--   when "0010" => 
--       case count10DIS00 is 
--       when "0000" => ascii0 <="00110000";
--       when  "0001"=> ascii0 <="00110001";
--       when  "0010"=> ascii0 <="00110010";
--       when  "0011"=> ascii0 <="00110011";
--       when  "0100"=> ascii0 <="00110100";
--       when  "0101"=> ascii0 <="00110101";
--       when  "0110"=> ascii0 <="00110110";
--       when  "0111"=> ascii0 <="00110111";
--       when  "1000"=> ascii0 <="00111000";
--       when  "1001"=> ascii0 <="00111001";
--       when others => ascii0 <= "00110000";
--       end case;
       
--       case count1DIS00 is 
--       when "0000" => ascii1 <="00110000";
--       when  "0001"=> ascii1 <="00110001";
--       when  "0010"=> ascii1 <="00110010";
--       when  "0011"=> ascii1 <="00110011";
--       when  "0100"=> ascii1 <="00110100";
--       when  "0101"=> ascii1 <="00110101";
--       when  "0110"=> ascii1 <="00110110";
--       when  "0111"=> ascii1 <="00110111";
--       when  "1000"=> ascii1 <="00111000";
--       when  "1001"=> ascii1 <="00111001";
--       when others => ascii1 <= "00110000";
--       end case;
       
--       case count10DIS01 is 
--       when "0000" => ascii2 <="00110000";
--       when  "0001"=> ascii2 <="00110001";
--       when  "0010"=> ascii2 <="00110010";
--       when  "0011"=> ascii2 <="00110011";
--       when  "0100"=> ascii2 <="00110100";
--       when  "0101"=> ascii2 <="00110101";
--       when  "0110"=> ascii2 <="00110110";
--       when  "0111"=> ascii2 <="00110111";
--       when  "1000"=> ascii2 <="00111000";
--       when  "1001"=> ascii2 <="00111001";
--       when others => ascii2<= "00110000";
--       end case;
       
--       case count1DIS01 is 
--       when "0000" => ascii3 <="00110000";
--       when  "0001"=> ascii3 <="00110001";
--       when  "0010"=> ascii3 <="00110010";
--       when  "0011"=> ascii3 <="00110011";
--       when  "0100"=> ascii3 <="00110100";
--       when  "0101"=> ascii3 <="00110101";
--       when  "0110"=> ascii3 <="00110110";
--       when  "0111"=> ascii3 <="00110111";
--       when  "1000"=> ascii3 <="00111000";
--       when  "1001"=> ascii3 <="00111001";
--       when others => ascii3<= "00110000";
--       end case;
 
--       case count10DIS10 is 
--       when "0000" => ascii4 <="00110000";
--       when  "0001"=> ascii4 <="00110001";
--       when  "0010"=> ascii4 <="00110010";
--       when  "0011"=> ascii4 <="00110011";
--       when  "0100"=> ascii4 <="00110100";
--       when  "0101"=> ascii4 <="00110101";
--       when  "0110"=> ascii4 <="00110110";
--       when  "0111"=> ascii4 <="00110111";
--       when  "1000"=> ascii4 <="00111000";
--       when  "1001"=> ascii4<="00111001";
--       when others => ascii4<= "00110000";
--       end case;
       
--       case count1DIS10 is 
--       when "0000" => ascii5 <="00110000";
--       when  "0001"=> ascii5 <="00110001";
--       when  "0010"=> ascii5 <="00110010";
--       when  "0011"=> ascii5 <="00110011";
--       when  "0100"=> ascii5 <="00110100";
--       when  "0101"=> ascii5 <="00110101";
--       when  "0110"=> ascii5 <="00110110";
--       when  "0111"=> ascii5 <="00110111";
--       when  "1000"=> ascii5 <="00111000";
--       when  "1001"=> ascii5 <="00111001";
--       when others => ascii5<= "00110000";
--       end case;
       
--        case count10DIS11 is 
--       when "0000" => ascii6 <="00110000";
--       when  "0001"=> ascii6 <="00110001";
--       when  "0010"=> ascii6 <="00110010";
--       when  "0011"=> ascii6 <="00110011";
--       when  "0100"=> ascii6 <="00110100";
--       when  "0101"=> ascii6 <="00110101";
--       when  "0110"=> ascii6 <="00110110";
--       when  "0111"=> ascii6 <="00110111";
--       when  "1000"=> ascii6 <="00111000";
--       when  "1001"=> ascii6 <="00111001";
--       when others => ascii6<= "00110000";
--       end case;
       
--       case count1DIS11 is 
--       when "0000" => ascii7 <="00110000";
--       when  "0001"=> ascii7 <="00110001";
--       when  "0010"=> ascii7 <="00110010";
--       when  "0011"=> ascii7 <="00110011";
--       when  "0100"=> ascii7 <="00110100";
--       when  "0101"=> ascii7 <="00110101";
--       when  "0110"=> ascii7 <="00110110";
--       when  "0111"=> ascii7 <="00110111";
--       when  "1000"=> ascii7 <="00111000";
--       when  "1001"=> ascii7 <="00111001";
--       when others => ascii7<= "00110000";
--       end case;
--       p<=p+1;
--    when "0011" =>
--       countDISbin<='1';
--       p<=p+1;
--    when "0100" =>
--       countDISbin<='1';
--       p<=p+1;
--    when "0101" =>
--       countDISbin<='0';
--        p<="0000"; 
--    when others => p<="0000";
--    end case;
-- end if;
--end process;

--To show count on the 7-segment display
process (clk_out,startconv,datasent) begin
if (clk_out'event and clk_out = '1') then
case p is
    when  "0000" =>
        if (startconv='1') then   
            p<="0001";
        else
            p<="0000";
        end if;
    when  "0001" =>
        count10DIS001000<=conv_STD_LOGIC_VECTOR( cntthou00,4);
        count10DIS011000<=conv_STD_LOGIC_VECTOR( cntthou01,4);
        count10DIS101000<=conv_STD_LOGIC_VECTOR( cntthou10,4);
        count10DIS111000<=conv_STD_LOGIC_VECTOR( cntthou11,4);
        count10DIS00100<=conv_STD_LOGIC_VECTOR( cnthund00,4);
        count10DIS01100<=conv_STD_LOGIC_VECTOR( cnthund01,4);
        count10DIS10100<=conv_STD_LOGIC_VECTOR( cnthund10,4);
        count10DIS11100<=conv_STD_LOGIC_VECTOR( cnthund11,4);
        p<=p+1;
    when  "0010" =>
        count10DIS0010<=conv_STD_LOGIC_VECTOR( cntten00,4);
        count10DIS0110<=conv_STD_LOGIC_VECTOR(cntten01,4);
        count10DIS1010<=conv_STD_LOGIC_VECTOR(cntten10,4);
        count10DIS1110<=conv_STD_LOGIC_VECTOR(cntten11,4);
        p<=p+1;
  when  "0011" =>  
        count10DIS001<=conv_STD_LOGIC_VECTOR( cnt00,4);
        count10DIS011<=conv_STD_LOGIC_VECTOR(cnt01,4);
        count10DIS101<=conv_STD_LOGIC_VECTOR(cnt10,4);
        count10DIS111<=conv_STD_LOGIC_VECTOR(cnt11,4);
        p<=p+1;
   when "0100" => 
       case count10DIS001000 is 
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
       
       case count10DIS00100 is 
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
       
       case count10DIS0010 is 
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
       
       case count10DIS001 is 
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
 
       case count10DIS011000 is 
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
       
       case count10DIS01100 is 
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
       
        case count10DIS0110 is 
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
       
       case count10DIS011 is 
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
       p<=p+1;
    when "0101" =>
       countDISbin<='1';
       p<=p+1;
    when "0110" =>
     countDISbin<='0';   
      p<=p+1;
    when "0111" => 
     if(datasent='1') then 
       p<=p+1;
     end if;
    when "1000" =>
       case count10DIS101000 is 
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
        
        case count10DIS10100 is 
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
        
        case count10DIS1010 is 
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
        
        case count10DIS101 is 
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
    
        case count10DIS111000 is 
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
        
        case count10DIS11100 is 
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
        
         case count10DIS1110 is 
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
        
        case count10DIS111 is 
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
        p<=p+1;      
       countDISbin<='1';
    when "1001" =>       
       countDISbin<='0';
        p<=p+1; 
    when "1010" =>
       if(datasent='1') then          
         p<=p+1;
       end if;
    when "1011" =>       
        p<="0000"; 
    when others => p<="0000";
    end case;
 end if;
end process;



--set total counting time ms
process (SO,DOUTm1,DOUT0,DOUT1,DOUT2,DOUT3,DOUT4,DOUT5,DOUT6,DOUT7,int100000000,int10000000,int1000000,int100000,int10000,int1000,int100,int10,int1) begin
    if (SO='1') then
     --100000000‚ÌˆÊ -1S
    int100000000 <="00101111101011110000100000000"* DOUTm1;
     --10000000‚ÌˆÊ -100mS
    int10000000 <="00000100110001001011010000000"* DOUT0;
     --1000000‚ÌˆÊ -10mS
    int1000000 <="00000000011110100001001000000"* DOUT1;
     --100000‚ÌˆÊ -1mS
    int100000 <="00000000000011000011010100000"* DOUT2;
     --10000‚ÌˆÊ 100ƒÊS
    int10000 <="00000000000000010011100010000"* DOUT3;
    --1000‚ÌˆÊ 10ƒÊS
    int1000 <="00000000000000000001111101000"* DOUT4 ;
    --100‚ÌˆÊ  1ƒÊS
    int100 <= "00000000000000000000001100100"* DOUT5;
    --10‚ÌˆÊ 100nS * 1
    int10 <= "00000000000000000000000001010" * DOUT6;    
    int1<= "00000000000000000000000000001" * DOUT7;
    W<=int1+int10+int100+int1000+int10000+int100000+int1000000+int10000000+int100000000;
    end if;
end process;

process (DO,DOUTm1D,DOUT0D,DOUT1D,DOUT2D,DOUT3D,DOUT4D,DOUT5D,DOUT6D,DOUT7D,int100000000D,int10000000D,int1000000D,int100000D,int10000D,int1000D,int100D,int10D,int1D) begin
    if (DO='1') then
     --100000000‚ÌˆÊ -10S
    int100000000D <="00101111101011110000100000000"* DOUTm1D;
     --10000000‚ÌˆÊ -1S
    int10000000D <="00000100110001001011010000000"* DOUT0D;
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
    WA<=int1D+int10D+int100D+int1000D+int10000D+int100000D+int1000000D+int10000000D+int100000000D;
    end if;
end process;


--process (phasemodzero,DOUT4D,DOUT5D,DOUT6D,DOUT7D,int10000zero,int1000zero,int100zero,int10zero,int1zero) begin
--    if (phasemodzero='1') then
--    --1000‚ÌˆÊ 1mS
--    int10000zero <=CONV_INTEGER(unsigned(DOUT3D)) *10000;
--    --1000‚ÌˆÊ 100ƒÊS
--    int1000zero <=CONV_INTEGER(unsigned(DOUT4D)) *1000;
--    --100‚ÌˆÊ  10ƒÊS
--    int100zero <= CONV_INTEGER(unsigned(DOUT5D)) *100;
--    --10‚ÌˆÊ 1ƒÊS
--    int10zero <= CONV_INTEGER(unsigned(DOUT6D)) *10;      
--    --1‚ÌˆÊ 100nS * 1
--    int1zero<= CONV_INTEGER(unsigned(DOUT7D)) *1;
--    Wzero<=int1zero+int10zero+int100zero+int1000zero+int10000zero;
--    end if;
--end process;




process (clk) begin
if (clk'event and clk= '1') then
case stage is
when "000"=>
    if (phasemodzero='1') then
     int10000zero <=CONV_INTEGER(unsigned(DOUT3D)) *10000;
     --1000‚ÌˆÊ 100ƒÊS
     int1000zero <=CONV_INTEGER(unsigned(DOUT4D)) *1000;
     --100‚ÌˆÊ  10ƒÊS
     int100zero <= CONV_INTEGER(unsigned(DOUT5D)) *100;
     --10‚ÌˆÊ 1ƒÊS
     int10zero <= CONV_INTEGER(unsigned(DOUT6D)) *10;      
     --1‚ÌˆÊ 100nS * 1
     int1zero<= CONV_INTEGER(unsigned(DOUT7D)) *1;
     stage<=stage+1;
     phasemodzero_reg<='1';
    elsif (phasemodpi='1') then
        int10000zero <=CONV_INTEGER(unsigned(DOUT3D)) *10000;
        --1000‚ÌˆÊ 100ƒÊS
        int1000zero <=CONV_INTEGER(unsigned(DOUT4D)) *1000;
        --100‚ÌˆÊ  10ƒÊS
        int100zero <= CONV_INTEGER(unsigned(DOUT5D)) *100;
        --10‚ÌˆÊ 1ƒÊS
        int10zero <= CONV_INTEGER(unsigned(DOUT6D)) *10;      
        --1‚ÌˆÊ 100nS * 1
        int1zero<= CONV_INTEGER(unsigned(DOUT7D)) *1;
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



--process (clk) begin
--if (clk'event and clk= '1') then
--case stagepi is
--when "000"=>
--    if (phasemodpi='1') then
--     int10000pi <=CONV_INTEGER(unsigned(DOUT3D)) *10000;
--     --1000‚ÌˆÊ 100ƒÊS
--     int1000pi <=CONV_INTEGER(unsigned(DOUT4D)) *1000;
--     --100‚ÌˆÊ  10ƒÊS
--     int100pi <= CONV_INTEGER(unsigned(DOUT5D)) *100;
--     --10‚ÌˆÊ 1ƒÊS
--     int10pi <= CONV_INTEGER(unsigned(DOUT6D)) *10;      
--     --1‚ÌˆÊ 100nS * 1
--     int1pi<= CONV_INTEGER(unsigned(DOUT7D)) *1;
--     stagepi<=stagepi+1;
--    end if;
--when "001"=>
--    Wpi<=int1pi+int10pi+int100pi+int1000pi+int10000pi;
--    stagepi<=stagepi+1;
--when "010"=>
--    W2pi<=Wpi*65536;
--    stagepi<=stagepi+1;
--when "011"=>
--    Wstdpi<=conv_std_logic_vector(W2pi,32);
--    stagepi<=stagepi+1;
--when "100"=>
--   case statuspi is
--   when "00000" =>
--       s_axis_divisor_tdata<="0110000110101000"; 
--       s_axis_dividend_tdata<=Wstdpi;    
--       statuspi<="00001";
--   when "00001" =>
--       s_axis_divisor_tvalid<='1';
--       s_axis_dividend_tvalid<='1';
--       statuspi<="00010";
--   when "00010" =>
--       if (m_axis_dout_tvalid='1') then
--          s_axis_divisor_tvalid<='0';
--          s_axis_dividend_tvalid<='0';
--          statuspi<="00011";
--       end if;            
--   when "00011" =>
--        if (m_axis_dout_tvalid='0') then
----                47-16 =>quotient 14-0 => reminder
--          Vquotientpi <=m_axis_dout_tdata(47 downto 16);
----          Vreminder <=m_axis_dout_tdata(14 downto 0);
--          statuspi<="00000";
--          statuspi<=statuspi+1;
----          led<=Vquotientpi(15 downto 0);
--        end if; 
--   when others =>  statuspi<="00000";
--   end case; 
--when  "101"=>
--    stagepi<=(others=>'0');
--when others =>  stagepi<=(others=>'0');     
--end case;
--end if;
--end process;
--Voutpi<= Vquotientpi(15 downto 0);


process (minchange,DOUTm1D,DOUT0D,DOUT1D,DOUT2D,DOUT3D,DOUT4D,DOUT5D,DOUT6D,DOUT7D,int100000000min,int10000000min,int1000000min,int100000min,int10000min,int1000min,int100min,int10min,int1min) begin
    if (minchange='1') then
     --100000000‚ÌˆÊ -10S
    int100000000min <="00101111101011110000100000000"* DOUTm1D;
     --10000000‚ÌˆÊ -1S
    int10000000min <="00000100110001001011010000000"* DOUT0D;
     --1000000‚ÌˆÊ -100mS
    int1000000min <="00000000011110100001001000000"* DOUT1D;
     --100000‚ÌˆÊ -10mS
    int100000min <="00000000000011000011010100000"* DOUT2D;
    --1000‚ÌˆÊ 1mS
    int10000min <="00000000000000010011100010000"* DOUT3D;
    --1000‚ÌˆÊ 100ƒÊS
    int1000min <="00000000000000000001111101000"* DOUT4D ;
    --100‚ÌˆÊ  10ƒÊS
    int100min <= "00000000000000000000001100100"* DOUT5D;
    --10‚ÌˆÊ 1ƒÊS
    int10min <= "00000000000000000000000001010" * DOUT6D;    
    --1‚ÌˆÊ 100nS * 1
    int1min<= "00000000000000000000000000001" * DOUT7D;
    minokrun<=int1min+int10min+int100min+int1000min+int10000min+int100000min+int1000000min+int10000000min+int100000000min;
    end if;
end process;



process (maxchange,DOUTm1D,DOUT0D,DOUT1D,DOUT2D,DOUT3D,DOUT4D,DOUT5D,DOUT6D,DOUT7D,int100000000max,int10000000max,int1000000max,int100000max,int10000max,int1000max,int100max,int10max,int1max) begin
    if (maxchange='1') then
     --100000000‚ÌˆÊ -10S
    int100000000max <="00101111101011110000100000000"* DOUTm1D;
     --10000000‚ÌˆÊ -1S
    int10000000max <="00000100110001001011010000000"* DOUT0D;
     --1000000‚ÌˆÊ -100mS
    int1000000max <="00000000011110100001001000000"* DOUT1D;
     --100000‚ÌˆÊ -10mS
    int100000max <="00000000000011000011010100000"* DOUT2D;
    --1000‚ÌˆÊ 1mS
    int10000max <="00000000000000010011100010000"* DOUT3D;
    --1000‚ÌˆÊ 100ƒÊS
    int1000max <="00000000000000000001111101000"* DOUT4D ;
    --100‚ÌˆÊ  10ƒÊS
    int100max <= "00000000000000000000001100100"* DOUT5D;
    --10‚ÌˆÊ 1ƒÊS
    int10max <= "00000000000000000000000001010" * DOUT6D;    
    --1‚ÌˆÊ 100nS * 1
    int1max<= "00000000000000000000000000001" * DOUT7D;
    maxokrun<=int1max+int10max+int100max+int1000max+int10000max+int100000max+int1000000max+int10000000max+int100000000max;
    end if;
end process;

process (SO,DO, phasemodzero, phasemodpi,minchange,maxchange )
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
elsif ( minchange='1' or maxchange='1') then
    SGIN0<=DOUT0D;
    SGIN1<=DOUT1D;
    SGIN2<=DOUT2D;
    SGIN3<=DOUT3D;
    SGIN4<=DOUT4D;
    SGIN5<=DOUT5D;
    SGIN6<=DOUT6D;
    SGIN7<=DOUT7D;
elsif (phasemodzero='1' or phasemodpi='1') then
    SGIN0<="0000";
    SGIN1<="0000";
    SGIN2<="0000";
    SGIN3<=DOUT3D;
    SGIN4<=DOUT4D;
    SGIN5<=DOUT5D;
    SGIN6<=DOUT6D;
    SGIN7<=DOUT7D;
end if;
end process;
change<=SO or DO or minchange or maxchange or phasemodzero or phasemodpi;
end Behavioral;
