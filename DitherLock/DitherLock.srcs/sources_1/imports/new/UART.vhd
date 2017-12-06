library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity UART is
  Port (
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
--       set expected count 
       C : out  std_logic :='0';
--       sign expected count 
       Cminus : out  std_logic :='0';
--       set P-gain
       P : out  std_logic :='0';
--       set I-gain
       I : out  std_logic :='0';
--       set r
       r : out  std_logic :='0';
--       set freqency of wave
       M : out  std_logic :='0';
--       run wave generator
       G : out  std_logic :='0';
--       run APD count
       Run : out  std_logic :='0';
--       set locking time
       Lock : out  std_logic :='0';
--       set data aquisition time
       A : out  std_logic :='0'; 
--       run transfer data to PC
       T : out  std_logic :='0';
       polarity: out  integer range -1 to 1:=1;
       PAMPLOCK : out  std_logic :='0';
       IAMPLOCK : out  std_logic :='0';       
       rAMPLOCK : out  std_logic :='0';
       AMPLOCKpolarity: out  integer range -1 to 1:=1;
       CAMPLOCK : out  std_logic :='0';
       amplockon: out  std_logic :='0';
       setampdef: out STD_LOGIC;
       setampoff: out STD_LOGIC;
       setampon: out STD_LOGIC;
       B: out STD_LOGIC;
       BAMPLOCK: out STD_LOGIC;
       DO : out  std_logic :='0';
       phasemodzero: out std_logic:='0';
       phasemodpi: out std_logic:='0';
       minchange : out  std_logic :='0';
       maxchange : out  std_logic :='0';
       numberfeed : out  std_logic :='0';     
       APDtimeset : out  std_logic :='0'; 
       AMPsetout : out  std_logic :='0';       
--       set amplitude of wave       
       waveamp : out  std_logic :='0';
--       set Low pass filter 
       L : out  std_logic :='0';
       offphase : out  std_logic :='0';
       g1 : out  std_logic :='0';
       g2 : out  std_logic :='0';
       z : out  std_logic :='0'; 
       x : out  std_logic :='0'; 
       v : out  std_logic :='0'; 
       u : out  std_logic :='0';
       w : out  std_logic :='0'
        );
end UART;

architecture Behavioral of UART is
component ASCII_integer is 
 port (ascii  : in std_logic_vector (7 downto 0);
        int : out std_logic_vector (3 downto 0)
       );
end component;
signal state_reg: std_logic_vector (2 downto 0):= (others => '0');
signal s_reg :  std_logic_vector(3 downto 0):= (others => '0');
signal n_reg :  std_logic_vector(2 downto 0):= (others => '0');
--assume that 10-byte is sent from PC change measure time "C=01000011" + 8*8 finish byte"#=00100011" bit required for buffer including 
signal D : std_logic_vector (87 downto 0):= (others => '0');
signal d_reg : std_logic_vector (7 downto 0):= (others => '0');
signal J : std_logic:='0';


signal setout_reg : std_logic:='0';
signal dataoutm1_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout0_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout1_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout2_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout3_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout4_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout5_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout6_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout7_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal intoutm1 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout0 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout1 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout2 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout3 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout4 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout5 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout6 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout7 :  std_logic_vector (3 downto 0):= (others => '0');
signal turn : integer;

signal amplockon_reg : std_logic:='0';
signal C_reg : std_logic:='0';
signal g_reg : std_logic:='0';
signal g1_reg : std_logic:='0';
signal g2_reg : std_logic:='0';

begin
setout<=setout_reg;
g1<=g1_reg;
g2<=g2_reg;
process (clk_UART,sw) 
begin
if(sw='1') then
   d_reg<=(others=>'0');
   s_reg<= (others => '0');
   n_reg<= (others => '0');
   state_reg<= (others => '0');
   D<=(others=>'0');
   J<='0';
   C<='0';
   C_reg<='0';   
   Cminus<='0';
   P<='0';
   I<='0';
   r<='0';
   M<='0';
   Lock<='0'; 
   A<='0'; 
   G<='0';
   Run<='0';
   T<='0';
   polarity<=1;
   setout_reg<='0';
   PAMPLOCK<='0';
   IAMPLOCK<='0';
   rAMPLOCK<='0';
   AMPLOCKpolarity<=1;
   CAMPLOCK<='0';
   setampdef<='0';
   setampoff<='0';
   setampon<='0';
   B<='0';
   BAMPLOCK<='0';
   DO<='0';
   phasemodzero<='0';
   phasemodpi<='0';
   minchange<='0';
   maxchange<='0';
   numberfeed<='0';
   APDtimeset<='0';
   AMPsetout<='0';
   waveamp<='0';
   L<='0';
   offphase<='0'; 
   g1_reg<='0';
   g2_reg<='0';
   g_reg<='0';               
   z<='0';
   x<='0';
   v<='0'; 
   u<='0';
   w<='0';
else
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
               D<=RsRx & D(87 downto 1);
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
                    turn<=turn+1;               
                    s_reg<=(others=>'0');
                    if (d_reg="00100011") then
                        state_reg<="100";
                    elsif (d_reg="01000011" and turn=0) then
                        state_reg<="000";
                        C<='1';
                        J<='1';
                        C_reg<='1';
                        Cminus<='0';
                    elsif (d_reg="00101101" and C_reg='1') then
                        state_reg<="000";
                        Cminus<='1';
                    elsif (d_reg="01010000"and turn=0) then
                        state_reg<="000";
                        P<='1';
                        J<='1';
                   elsif (d_reg="01001001"and turn=0) then
                        state_reg<="000";
                        I<='1';
                        J<='1'; 
                   elsif (d_reg="01110010"and turn=0) then
                        state_reg<="000";
                        r<='1';
                        J<='1'; 
                   elsif (d_reg="01001111"and turn=0) then
                        state_reg<="000";
                        L<='1';
                        J<='1'; 
                   elsif (d_reg="01001101"and turn=0) then
                        state_reg<="000";
                        M<='1';
                        J<='1';
                   elsif (d_reg="01000111"and turn=0) then
                        state_reg<="000";
                        G<='1';
                        J<='1';
                   elsif (d_reg="01101101"and turn=0) then
                        state_reg<="000";
                        waveamp<='1';
                        J<='1';                             
                   elsif (d_reg="01001100" and turn=0) then
                         state_reg<="000";                        
                         Lock<='1';    
                         J<='1';               
                    elsif (d_reg="01000001" and turn=0) then
                          state_reg<="000";                        
                          A<='1';    
                          J<='1';               
                    elsif (d_reg="01100100" and turn=0) then
                          state_reg<="000";
                          setampdef<='1';
                          J<='1';     
                    elsif (d_reg="01101110" and turn=0) then
                          state_reg<="000";
                          setampon<='1'; 
                          J<='1';    
                    elsif (d_reg="01100110" and turn=0) then
                          state_reg<="000";
                          setampoff<='1';     
                          J<='1';                 
                    elsif (d_reg="01000010" and turn=0) then
                          state_reg<="000";
                          J<='1';        
                          B<='1';
                    elsif (d_reg="01100010" and turn=0) then
                          state_reg<="000";
                          J<='1';        
                          BAMPLOCK<='1';
                   elsif (d_reg="01010010" and turn=0) then
                        state_reg<="000";                        
                        Run<='1';    
                        J<='1';    
                   elsif (d_reg="01010100" ) then
                        state_reg<="000";                        
                        T<='1';    
                        J<='1';  
                    elsif (d_reg="00101011" and g_reg='0') then
                        state_reg<="000";                        
                        polarity<=1;    
                        J<='1';
                    elsif (d_reg="00101101" and C_reg='0'and g_reg='0') then
                        state_reg<="000";                        
                        polarity<=-1;    
                        J<='1';
                    elsif (d_reg="01101000" ) then
                        state_reg<="000";                        
                        offphase<='1';    
                        J<='1';
                   elsif (d_reg="01100111" and turn=0) then
                         state_reg<="000";                        
                         J<='1';
                         g_reg<='1';    
                   elsif (d_reg="00101011" and g_reg='1') then
                         state_reg<="000";                        
                         g1_reg<='1';    
                         J<='1';
                         g_reg<='0';    
                   elsif (d_reg="00101101" and g_reg='1') then
                         state_reg<="000";                        
                         g2_reg<='1';    
                         J<='1';
                         g_reg<='0';    
                    elsif (d_reg="01110000" and turn=0 ) then
                            state_reg<="000";                        
                            PAMPLOCK<='1';    
                            J<='1';
                    elsif (d_reg="01101001" and turn=0 ) then
                            state_reg<="000";                        
                            IAMPLOCK<='1';    
                            J<='1';
                    elsif (d_reg="01101100" and turn=0 ) then
                            state_reg<="000";                        
                            rAMPLOCK<='1';    
                            J<='1';                
                    elsif (d_reg="01100011" and turn=0 ) then
                            state_reg<="000";                        
                            CAMPLOCK<='1';    
                            J<='1';                                    
                    elsif (d_reg="00101010" ) then
                            state_reg<="000";                        
                            AMPLOCKpolarity<=1;    
                            J<='1';
                    elsif (d_reg="00101111" ) then
                            state_reg<="000";                        
                            AMPLOCKpolarity<=-1;    
                            J<='1';
                    elsif (d_reg="01111001" ) then
                            state_reg<="000";                        
                            amplockon<=not amplockon_reg;    
                            amplockon_reg<=not amplockon_reg;      
                    elsif (d_reg="01000100" and turn=0) then
                            state_reg<="000";
                            DO<='1';
                            J<='1';
                    elsif (d_reg="01000110" and turn=0) then
                            state_reg<="000";
                            setout_reg<='1';
                            J<='1';
                    elsif (d_reg="01010101" and turn=0) then
                            state_reg<="000";
                            phasemodzero<='1';
                            J<='1';
                    elsif (d_reg="01010110" and turn=0) then
                            state_reg<="000";
                            phasemodpi<='1';
                            J<='1';
                    elsif (d_reg="01001100" and turn=0) then
                            state_reg<="000";
                            minchange<='1';
                            J<='1';
                    elsif (d_reg="01000001" and turn=0) then
                            state_reg<="000";
                            maxchange<='1';
                            J<='1';
                    elsif (d_reg="01001110" and turn=0) then
                            state_reg<="000";
                            numberfeed<='1';
                            J<='1';                
                    elsif (d_reg="01010011") then
                            state_reg<="000";
                            APDtimeset<='1';
                            J<='1';
                    elsif (d_reg="01000110" and turn=0) then
                            state_reg<="000";
                            AMPsetout<='1';
                            J<='1';                                                   
                     elsif (d_reg="01111010" and turn=0) then
                        state_reg<="000";                        
                        z<='1';    
                        x<='0';  
                        v<='0';
                        u<='0';
                        w<='0'; 
                        J<='1';               
                   elsif (d_reg="01111000" and turn=0) then
                        state_reg<="000";                        
                        z<='0';  
                        x<='1';  
                        v<='0';
                        u<='0';
                        w<='0';
                        J<='1';               
                   elsif (d_reg="01110110" and turn=0) then
                         state_reg<="000";                        
                         z<='0';
                         x<='0';
                         v<='1';
                         u<='0';
                         w<='0';
                         J<='1';               
                   elsif (d_reg="01110101" and turn=0) then
                         state_reg<="000";                        
                         z<='0';
                         x<='0';
                         v<='0';
                         u<='1';
                         w<='0'; 
                         J<='1';                
                   elsif (d_reg="01110111" and turn=0) then
                           state_reg<="000";                        
                           z<='0';
                           x<='0';
                           v<='0';
                           u<='0'; 
                           w<='1';
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
                if (C_reg='0') then
                   dataoutm1_reg<=D (15 downto 8);
                   dataout0_reg<=D (23 downto 16);
                   dataout1_reg<=D (31 downto 24);
                   dataout2_reg<=D (39 downto 32);
                   dataout3_reg<=D (47 downto 40);
                   dataout4_reg<=D (55 downto 48);
                   dataout5_reg<=D (63 downto 56);
                   dataout6_reg<=D (71 downto 64);
                   dataout7_reg<=D (79 downto 72);
                   setout_reg<='1';
                   state_reg<="101";
                 else
                   dataoutm1_reg<=(others=>'0');
                   dataout0_reg<=D (23 downto 16);
                   dataout1_reg<=D (31 downto 24);
                   dataout2_reg<=D (39 downto 32);
                   dataout3_reg<=D (47 downto 40);
                   dataout4_reg<=D (55 downto 48);
                   dataout5_reg<=D (63 downto 56);
                   dataout6_reg<=D (71 downto 64);
                   dataout7_reg<=D (79 downto 72);                 
                   setout_reg<='1';
                   state_reg<="101";
                 end if;  
               else
                   state_reg<="101";
                   setout_reg<='0';
               end if;
       when "101" =>
               turn<=0;
               D<=(others=>'0');
               state_reg<="000";
               J<='0';
               C<='0';
               C_reg<='0';
--               Cminus<='0';
               P<='0';
               I<='0';
               r<='0';
               M<='0';
               Lock<='0'; 
               A<='0'; 
               setout_reg<='0';
               PAMPLOCK<='0';
               IAMPLOCK<='0';
               rAMPLOCK<='0';
               CAMPLOCK<='0';          
               setampdef<='0';
               setampoff<='0';
               setampon<='0';
               B<='0';
               BAMPLOCK<='0';
               DO<='0';
               phasemodzero<='0';
               phasemodpi<='0';
               minchange<='0';
               maxchange<='0';
               numberfeed<='0';
               APDtimeset<='0';
               AMPsetout<='0';
               waveamp<='0';
               L<='0'; 
               offphase<='0'; 
               g1_reg<='0';
               g2_reg<='0';
               g_reg<='0';               
                     
       when others => state_reg<="000";
       end case; 
  end if;
end if;
end process;         

iASCII_integerm1 : ASCII_integer port map(ascii=> dataoutm1_reg , int=>intoutm1); 
iASCII_integer0 : ASCII_integer port map(ascii=> dataout0_reg , int=>intout0); 
iASCII_integer1 : ASCII_integer port map(ascii=> dataout1_reg , int=>intout1);
iASCII_integer2 : ASCII_integer port map(ascii=> dataout2_reg , int=>intout2);
iASCII_integer3 : ASCII_integer port map(ascii=> dataout3_reg , int=>intout3);
iASCII_integer4 : ASCII_integer port map(ascii=> dataout4_reg , int=>intout4);
iASCII_integer5 : ASCII_integer port map(ascii=> dataout5_reg , int=>intout5);
iASCII_integer6 : ASCII_integer port map(ascii=> dataout6_reg , int=>intout6);
iASCII_integer7 : ASCII_integer port map(ascii=> dataout7_reg , int=>intout7);
dataoutm1<=intoutm1;
dataout0<=intout0;
dataout1<=intout1;
dataout2<=intout2;
dataout3<=intout3;
dataout4<=intout4;
dataout5<=intout5;
dataout6<=intout6;
dataout7<=intout7;



end Behavioral;
