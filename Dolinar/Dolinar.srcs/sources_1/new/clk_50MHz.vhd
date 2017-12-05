library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clk_50MHz is
    Port ( clk : in  STD_LOGIC;
           clk_50 : out  STD_LOGIC);
end clk_50MHz;

architecture Behavioral of clk_50MHz is
  signal cnt : std_logic_vector(1 downto 0):= (others => '0');
begin
  process (clk) begin
    if (clk'event and clk = '1') then
      if (cnt = 0) then
        clk_50 <= '1';
        cnt<=cnt+1;
      elsif (cnt = 1) then
        clk_50 <= '0';
        cnt <=(others => '0');  
      end if;
    end if;
  end process;
end Behavioral;
