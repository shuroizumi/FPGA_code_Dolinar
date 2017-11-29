library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity  PCsent_integer_to_ASCII is
  Port (std: in  std_logic_vector (7 downto 0);
        ASCII:out std_logic_vector (15 downto 0):="0000000000000000"
   );
end  PCsent_integer_to_ASCII;

architecture Behavioral of  PCsent_integer_to_ASCII is

begin
process(std) begin
case std is
when "00000000"=>ASCII<="0011000000110000";
when "00000001"=>ASCII<="0011000000110001";
when "00000010"=>ASCII<="0011000000110010";
when "00000011"=>ASCII<="0011000000110011";
when "00000100"=>ASCII<="0011000000110100";
when "00000101"=>ASCII<="0011000000110101";
when "00000110"=>ASCII<="0011000000110110";
when "00000111"=>ASCII<="0011000000110111";
when "00001000"=>ASCII<="0011000000111000";
when "00001001"=>ASCII<="0011000000111001";
when "00001010"=>ASCII<="0011000100110000";
when "00001011"=>ASCII<="0011000100110001";
when "00001100"=>ASCII<="0011000100110010";
when "00001101"=>ASCII<="0011000100110011";
when "00001110"=>ASCII<="0011000100110100";
when "00001111"=>ASCII<="0011000100110101";
when "00010000"=>ASCII<="0011000100110110";
when "00010001"=>ASCII<="0011000100110111";
when "00010010"=>ASCII<="0011000100111000";
when "00010011"=>ASCII<="0011000100111001";
when "00010100"=>ASCII<="0011001000110000";
when "00010101"=>ASCII<="0011001000110001";
when "00010110"=>ASCII<="0011001000110010";
when "00010111"=>ASCII<="0011001000110011";
when "00011000"=>ASCII<="0011001000110100";
when "00011001"=>ASCII<="0011001000110101";
when "00011010"=>ASCII<="0011001000110110";
when "00011011"=>ASCII<="0011001000110111";
when "00011100"=>ASCII<="0011001000111000";
when "00011101"=>ASCII<="0011001000111001";
when "00011110"=>ASCII<="0011001100110000";
when "00011111"=>ASCII<="0011001100110001";
when "00100000"=>ASCII<="0011001100110010";
when "00100001"=>ASCII<="0011001100110011";
when "00100010"=>ASCII<="0011001100110100";
when "00100011"=>ASCII<="0011001100110101";
when "00100100"=>ASCII<="0011001100110110";
when "00100101"=>ASCII<="0011001100110111";
when "00100110"=>ASCII<="0011001100111000";
when "00100111"=>ASCII<="0011001100111001";
when "00101000"=>ASCII<="0011010000110000";
when "00101001"=>ASCII<="0011010000110001";
when "00101010"=>ASCII<="0011010000110010";
when "00101011"=>ASCII<="0011010000110011";
when "00101100"=>ASCII<="0011010000110100";
when "00101101"=>ASCII<="0011010000110101";
when "00101110"=>ASCII<="0011010000110110";
when "00101111"=>ASCII<="0011010000110111";
when "00110000"=>ASCII<="0011010000111000";
when "00110001"=>ASCII<="0011010000111001";
when "00110010"=>ASCII<="0011010100110000";
when others =>ASCII<= "0011000000110000";
end case;
end process;
end Behavioral;
