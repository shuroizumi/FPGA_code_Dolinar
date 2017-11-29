library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Vbias is
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
end Vbias;

architecture Behavioral of Vbias is


signal clk_U : std_logic;
signal SO  : std_logic :='0';


component UART_Vbias is 
 port (clkoriginal : in std_logic;
       clk_UART : in std_logic;
       RsRx : in  std_logic;
       Vout : out std_logic_vector (15 downto 0):= (others => '0');
       VBAMPLOCK: out STD_LOGIC_VECTOR(15 DOWNTO 0);
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
end component;

component clk_UART_receiver is 
 port (clk_i :in std_logic;
       clk_o :out std_logic
       );
end component;
begin

iclk_UART : clk_UART_receiver port map(clk_i=>clk, clk_o=>clk_U);
iUART_Vbias : UART_Vbias port map(clkoriginal=> clk, clk_UART=>clk_U, RsRx=>RsRx,Vout =>VB,VBAMPLOCK =>VBAMPLOCK, setout=>SO,
SGIN0=>SGIN0,SGIN1=>SGIN1,SGIN2=>SGIN2,SGIN3=>SGIN3,SGIN4=>SGIN4,SGIN5=>SGIN5,SGIN6=>SGIN6,SGIN7=>SGIN7,finish=>finish);



end Behavioral;
