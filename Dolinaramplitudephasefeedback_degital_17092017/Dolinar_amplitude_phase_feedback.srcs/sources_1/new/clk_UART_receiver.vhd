library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clk_UART_receiver is
    Port ( clk_i : in  STD_LOGIC;
           clk_o : out  STD_LOGIC);
end clk_UART_receiver;

architecture Behavioral of clk_UART_receiver is
 signal cnt : std_logic_vector(20 downto 0):= (others => '0');
 constant BAUD : integer := 19200;
 constant eachserialbit: integer := 16;
 constant clkrate : integer := 100000000;

begin
 process (clk_i) begin
    if (clk_i'event and clk_i = '1') then
      if (cnt = 326-1) then
        clk_o <= '1';
        cnt <=(others => '0'); 
      else
        clk_o <= '0';
        cnt <=cnt +1 ;  
      end if;
    end if;
  end process;
end Behavioral;