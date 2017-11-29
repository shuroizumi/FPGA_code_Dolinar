library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divja is
    Port ( clkja_i : in  STD_LOGIC;
           clkja_o : out  STD_LOGIC);
end divja;

architecture Behavioral of divja is
  signal cnt : std_logic_vector(1 downto 0):= (others => '0');
begin
  process (clkja_i) begin
    if (clkja_i'event and clkja_i = '1') then
      if (cnt = 0) then
        clkja_o <= '1';
        cnt<=cnt+1;
      elsif (cnt = 1) then
        clkja_o <= '0';
        cnt <=(others => '0');  
      end if;
    end if;
  end process;
end Behavioral;