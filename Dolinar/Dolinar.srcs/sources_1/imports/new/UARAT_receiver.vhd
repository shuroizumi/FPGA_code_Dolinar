library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity UARAT_receiver is
  Port (clkoriginal : in std_logic;
       clk_UART : in std_logic;
       RsRx : in  std_logic;
       dataout0 : out std_logic_vector (3 downto 0):= (others => '0');
       dataout1 : out std_logic_vector (3 downto 0):= (others => '0');
       dataout2 : out std_logic_vector (3 downto 0):= (others => '0');
       dataout3 : out std_logic_vector (3 downto 0):= (others => '0');
       setout : out  std_logic :='0'
        );
end UARAT_receiver;

architecture Behavioral of UARAT_receiver is
component ASCII_integer is 
 port (ascii  : in std_logic_vector (7 downto 0);
        int : out std_logic_vector (3 downto 0)
       );
end component;
signal state_reg: std_logic_vector (2 downto 0):= (others => '0');
signal s_reg :  std_logic_vector(3 downto 0):= (others => '0');
signal n_reg :  std_logic_vector(2 downto 0):= (others => '0');
--assume that 5-byte is sent from PC change measure time "S=01010011" + 4*8 finish byte"#=00100011" bit required for buffer including 
signal D : std_logic_vector (47 downto 0):= (others => '0');
signal d_reg : std_logic_vector (7 downto 0):= (others => '0');
signal i : natural;
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


begin
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
               D<=RsRx & D(47 downto 1);
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
                    elsif (d_reg="01010011") then
                        state_reg<="000";
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
                   dataout3_reg<=D (39 downto 32);
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
       when others => state_reg<="000";
       end case; 
  end if;
end process;         

iASCII_integer0 : ASCII_integer port map(ascii=> dataout0_reg , int=>intout0); 
iASCII_integer1 : ASCII_integer port map(ascii=> dataout1_reg , int=>intout1);
iASCII_integer2 : ASCII_integer port map(ascii=> dataout2_reg , int=>intout2);
iASCII_integer3 : ASCII_integer port map(ascii=> dataout3_reg , int=>intout3);
dataout0<=intout0;
dataout1<=intout1;
dataout2<=intout2;
dataout3<=intout3;



end Behavioral;
