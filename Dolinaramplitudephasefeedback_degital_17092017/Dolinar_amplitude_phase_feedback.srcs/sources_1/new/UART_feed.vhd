library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity UART_feed is
  Port (clkoriginal : in std_logic;
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
end UART_feed;

architecture Behavioral of UART_feed is
component ASCII_integer is 
 port (ascii  : in std_logic_vector (7 downto 0);
        int : out std_logic_vector (3 downto 0)
       );
end component;
signal state_reg: std_logic_vector (2 downto 0):= (others => '0');
signal s_reg :  std_logic_vector(3 downto 0):= (others => '0');
signal n_reg :  std_logic_vector(2 downto 0):= (others => '0');
--assume that 5-byte is sent from PC change measure time "S=01010011" + 4*8 finish byte"#=00100011" bit required for buffer including 
signal D : std_logic_vector (87 downto 0):= (others => '0');
signal d_reg : std_logic_vector (7 downto 0):= (others => '0');
signal i : natural;
signal J : std_logic:='0';
signal setout_reg : std_logic:='0';
signal dolinarsetout_reg: std_logic:='0';
signal phasemodzero_reg: std_logic:='0';
signal phasemodpi_reg: std_logic:='0';
signal minchange_reg: std_logic:='0';
signal maxchange_reg: std_logic:='0';
signal dataoutm1_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout0_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout1_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout2_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout3_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout4_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout5_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout6_reg :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout7_reg :  std_logic_vector (7 downto 0):= (others => '0');

signal dataoutm1_regd :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout0_regd :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout1_regd :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout2_regd :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout3_regd :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout4_regd :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout5_regd :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout6_regd :  std_logic_vector (7 downto 0):= (others => '0');
signal dataout7_regd :  std_logic_vector (7 downto 0):= (others => '0');


signal intoutm1 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout0 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout1 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout2 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout3 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout4 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout5 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout6 :  std_logic_vector (3 downto 0):= (others => '0');
signal intout7 :  std_logic_vector (3 downto 0):= (others => '0');

signal intoutm1d :  std_logic_vector (3 downto 0):= (others => '0');
signal intout0d:  std_logic_vector (3 downto 0):= (others => '0');
signal intout1d :  std_logic_vector (3 downto 0):= (others => '0');
signal intout2d :  std_logic_vector (3 downto 0):= (others => '0');
signal intout3d :  std_logic_vector (3 downto 0):= (others => '0');
signal intout4d :  std_logic_vector (3 downto 0):= (others => '0');
signal intout5d :  std_logic_vector (3 downto 0):= (others => '0');
signal intout6d :  std_logic_vector (3 downto 0):= (others => '0');
signal intout7d :  std_logic_vector (3 downto 0):= (others => '0');

begin

process (clk_UART) 
begin
if (clk_UART'event and clk_UART = '1') then
    case state_reg is       
        when "000"=>
            d_reg<=(others=>'0');
            s_reg<= (others => '0');
            n_reg<= (others => '0');
--            setout_reg<='0';
--            dolinarsetout_reg<='0';
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
                    s_reg<=(others=>'0');
                    if (d_reg="00100011") then
                        state_reg<="100";
                    elsif (d_reg="01000100") then
                        state_reg<="000";
                        dolinarsetout_reg<='1';
                        J<='1';
                    elsif (d_reg="01000110") then
                        state_reg<="000";
                        setout_reg<='1';
                        J<='1';
                    elsif (d_reg="01010101") then
                        state_reg<="000";
                        phasemodzero_reg<='1';
                        J<='1';
                    elsif (d_reg="01010110") then
                        state_reg<="000";
                        phasemodpi_reg<='1';
                        J<='1';
                    elsif (d_reg="01001100") then
                        state_reg<="000";
                        minchange_reg<='1';
                        J<='1';
                    elsif (d_reg="01000001") then
                        state_reg<="000";
                        maxchange_reg<='1';
                        J<='1';
                    else 
                        state_reg<="000";
                    end if;
                else
                    s_reg<=s_reg+1;
                    state_reg<="011";
                end if;
       when "100" => 
               if (setout_reg='1') then
                   dataoutm1_reg<=D (15 downto 8);
                   dataout0_reg<=D (23 downto 16);
                   dataout1_reg<=D (31 downto 24);
                   dataout2_reg<=D (39 downto 32);
                   dataout3_reg<=D (47 downto 40);
                   dataout4_reg<=D (55 downto 48);
                   dataout5_reg<=D (63 downto 56);
                   dataout6_reg<=D (71 downto 64);
                   dataout7_reg<=D (79 downto 72);
                   setout<='1';
                   state_reg<="101";
               elsif (dolinarsetout_reg='1') then   
                   dataoutm1_regd<=D (15 downto 8);
                   dataout0_regd<=D (23 downto 16);
                   dataout1_regd<=D (31 downto 24);
                   dataout2_regd<=D (39 downto 32);
                   dataout3_regd<=D (47 downto 40);
                   dataout4_regd<=D (55 downto 48);
                   dataout5_regd<=D (63 downto 56);
                   dataout6_regd<=D (71 downto 64);
                   dataout7_regd<=D (79 downto 72);
                   dolinarsetout<='1';
                   state_reg<="101";
               elsif (phasemodzero_reg='1') then   
                   dataoutm1_regd<=D (15 downto 8);
                   dataout0_regd<=D (23 downto 16);
                   dataout1_regd<=D (31 downto 24);
                   dataout2_regd<=D (39 downto 32);
                   dataout3_regd<=D (47 downto 40);
                   dataout4_regd<=D (55 downto 48);
                   dataout5_regd<=D (63 downto 56);
                   dataout6_regd<=D (71 downto 64);
                   dataout7_regd<=D (79 downto 72);
                   phasemodzero<='1';
                   state_reg<="101"; 
               elsif (phasemodpi_reg='1') then   
                   dataoutm1_regd<=D (15 downto 8);
                   dataout0_regd<=D (23 downto 16);
                   dataout1_regd<=D (31 downto 24);
                   dataout2_regd<=D (39 downto 32);
                   dataout3_regd<=D (47 downto 40);
                   dataout4_regd<=D (55 downto 48);
                   dataout5_regd<=D (63 downto 56);
                   dataout6_regd<=D (71 downto 64);
                   dataout7_regd<=D (79 downto 72);
                   phasemodpi<='1';
                   state_reg<="101"; 
               elsif (minchange_reg='1') then   
                   dataoutm1_regd<=D (15 downto 8);
                   dataout0_regd<=D (23 downto 16);
                   dataout1_regd<=D (31 downto 24);
                   dataout2_regd<=D (39 downto 32);
                   dataout3_regd<=D (47 downto 40);
                   dataout4_regd<=D (55 downto 48);
                   dataout5_regd<=D (63 downto 56);
                   dataout6_regd<=D (71 downto 64);
                   dataout7_regd<=D (79 downto 72);
                   minchange<='1';
                   state_reg<="101";
               elsif (maxchange_reg='1') then   
                   dataoutm1_regd<=D (15 downto 8);
                   dataout0_regd<=D (23 downto 16);
                   dataout1_regd<=D (31 downto 24);
                   dataout2_regd<=D (39 downto 32);
                   dataout3_regd<=D (47 downto 40);
                   dataout4_regd<=D (55 downto 48);
                   dataout5_regd<=D (63 downto 56);
                   dataout6_regd<=D (71 downto 64);
                   dataout7_regd<=D (79 downto 72);
                   maxchange<='1';
                   state_reg<="101";
               else
                   state_reg<="101";
               end if;
       when "101" =>
               D<=(others=>'0');
               state_reg<="000";
               J<='0';
               setout_reg<='0';
               setout<='0';
               dolinarsetout_reg<='0';
               dolinarsetout<='0';
               phasemodzero_reg<='0';
               phasemodzero<='0';
               phasemodpi_reg<='0';
               phasemodpi<='0';
               minchange_reg<='0';
               minchange<='0';
               maxchange_reg<='0';
               maxchange<='0';
       when others => state_reg<="000";
       end case; 
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

iASCII_integerm1d : ASCII_integer port map(ascii=> dataoutm1_regd , int=>intoutm1d); 
iASCII_integer0d : ASCII_integer port map(ascii=> dataout0_regd , int=>intout0d); 
iASCII_integer1d : ASCII_integer port map(ascii=> dataout1_regd , int=>intout1d);
iASCII_integer2d : ASCII_integer port map(ascii=> dataout2_regd , int=>intout2d);
iASCII_integer3d : ASCII_integer port map(ascii=> dataout3_regd , int=>intout3d);
iASCII_integer4d : ASCII_integer port map(ascii=> dataout4_regd , int=>intout4d);
iASCII_integer5d : ASCII_integer port map(ascii=> dataout5_regd , int=>intout5d);
iASCII_integer6d : ASCII_integer port map(ascii=> dataout6_regd , int=>intout6d);
iASCII_integer7d : ASCII_integer port map(ascii=> dataout7_regd , int=>intout7d);

dataoutm1<=intoutm1;
dataout0<=intout0;
dataout1<=intout1;
dataout2<=intout2;
dataout3<=intout3;
dataout4<=intout4;
dataout5<=intout5;
dataout6<=intout6;
dataout7<=intout7;

dataoutm1d<=intoutm1d;
dataout0d<=intout0d;
dataout1d<=intout1d;
dataout2d<=intout2d;
dataout3d<=intout3d;
dataout4d<=intout4d;
dataout5d<=intout5d;
dataout6d<=intout6d;
dataout7d<=intout7d;


end Behavioral;