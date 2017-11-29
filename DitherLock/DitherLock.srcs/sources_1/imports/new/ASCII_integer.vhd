library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ASCII_integer is
  Port (ascii  : in std_logic_vector (7 downto 0):= (others => '0');
        int : out std_logic_vector (3 downto 0):= (others => '0')
         );
end ASCII_integer;

architecture Behavioral of ASCII_integer is

begin
process (ascii)
begin
    case ascii is 
--    0
    when "00110000" => int <="0000";
    when "00110001" => int <="0001";
    when "00110010" => int <="0010";
    when "00110011" => int <="0011";
    when "00110100" => int <="0100";
    when "00110101" => int <="0101";
    when "00110110" => int <="0110";
    when "00110111" => int <="0111";
    when "00111000" => int <="1000";
    when "00111001" => int <="1001";
    when others => int <= "0000";
    end case;
 end process;
end Behavioral;
