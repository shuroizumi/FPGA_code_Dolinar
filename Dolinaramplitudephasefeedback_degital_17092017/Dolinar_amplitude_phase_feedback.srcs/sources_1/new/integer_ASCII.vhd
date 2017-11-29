library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.STD_LOGIC_ARITH.ALL;
 use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
 
 entity  integer_ASCII is
   Port (ascii  : out std_logic_vector (7 downto 0):= (others => '0');
         int : in std_logic_vector (3 downto 0):= (others => '0')
          );
 end  integer_ASCII;
 
 architecture Behavioral of integer_ASCII is
 
 begin
 process (int)
 begin
     case int is 
 --    0
     when "0000" => ascii <="00110000";
     when  "0001"=> ascii <="00110001";
     when  "0010"=> ascii <="00110010";
     when  "0011"=> ascii <="00110011";
     when  "0100"=> ascii <="00110100";
     when  "0101"=> ascii <="00110101";
     when  "0110"=> ascii <="00110110";
     when  "0111"=> ascii <="00110111";
     when  "1000"=> ascii <="00111000";
     when  "1001"=> ascii <="00111001";
     when others => ascii <= "00110000";
     end case;
  end process;
 end Behavioral;
