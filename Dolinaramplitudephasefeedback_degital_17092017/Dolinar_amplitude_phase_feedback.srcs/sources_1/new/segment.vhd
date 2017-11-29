library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity segment is
  Port (seg : out std_logic_vector (6 downto 0):= (others => '1');
       an: out std_logic_vector (7 downto 0):= (others => '1');
       clkseg: in std_logic;
       int_o0 : in std_logic_vector (3 downto 0):= (others => '0');
       int_o1 : in std_logic_vector (3 downto 0):= (others => '0');
       int_o2 : in std_logic_vector (3 downto 0):= (others => '0');
       int_o3 : in std_logic_vector (3 downto 0):= (others => '0');
       int_o4 : in std_logic_vector (3 downto 0):= (others => '0');
       int_o5 : in std_logic_vector (3 downto 0):= (others => '0');
       int_o6 : in std_logic_vector (3 downto 0):= (others => '0');
       int_o7 : in std_logic_vector (3 downto 0):= (others => '0')  
        );
end segment;

architecture Behavioral of segment is
signal outan: std_logic_vector (7 downto 0):=  (others => '1');
signal count: std_logic_vector (20 downto 0);

begin
--an<=outan;
process(clkseg) begin
    if (clkseg' event and clkseg='1') then
        if (count <= 2500) then
            an<= "11111110";
            count <= count+1;
            case int_o7 is
                        when "0000" => seg <= "1000000";
                        when "0001" => seg <= "1111001";
                        when "0010" => seg <= "0100100";
                        when "0011" => seg <= "0110000";
                        when "0100" => seg <= "0011001";
                        when "0101" => seg <= "0010010";
                        when "0110" => seg <= "0000010";
                        when "0111" => seg <= "1111000";
                        when "1000" => seg <= "0000000";
                        when "1001" => seg <= "0010000";
                        when "1010" => seg <= "1000000";
                        when "1011" => seg <= "1111001";
                        when "1100" => seg <= "0100100";
                        when "1101" => seg <= "0110000";
                        when "1110" => seg <= "0011001";
                        when "1111" => seg <= "0010010";
                        when others => seg <= "XXXXXXX";
            end case;
        elsif (count <= 5000 and count >2500) then
            an <= "11111101";
            count <= count+1;
            case int_o6 is
                        when "0000" => seg <= "1000000";
                        when "0001" => seg <= "1111001";
                        when "0010" => seg <= "0100100";
                        when "0011" => seg <= "0110000";
                        when "0100" => seg <= "0011001";
                        when "0101" => seg <= "0010010";
                        when "0110" => seg <= "0000010";
                        when "0111" => seg <= "1111000";
                        when "1000" => seg <= "0000000";
                        when "1001" => seg <= "0010000";
                        when "1010" => seg <= "1000000";
                        when "1011" => seg <= "1111001";
                        when "1100" => seg <= "0100100";
                        when "1101" => seg <= "0110000";
                        when "1110" => seg <= "0011001";
                        when "1111" => seg <= "0010010";
                        when others => seg <= "XXXXXXX";
            end case;
        elsif (count <= 7500 and count >5000) then 
            case int_o5 is
                        when "0000" => seg <= "1000000";
                        when "0001" => seg <= "1111001";
                        when "0010" => seg <= "0100100";
                        when "0011" => seg <= "0110000";
                        when "0100" => seg <= "0011001";
                        when "0101" => seg <= "0010010";
                        when "0110" => seg <= "0000010";
                        when "0111" => seg <= "1111000";
                        when "1000" => seg <= "0000000";
                        when "1001" => seg <= "0010000";
                        when "1010" => seg <= "1000000";
                        when "1011" => seg <= "1111001";
                        when "1100" => seg <= "0100100";
                        when "1101" => seg <= "0110000";
                        when "1110" => seg <= "0011001";
                        when "1111" => seg <= "0010010";
                        when others => seg <= "XXXXXXX";
            end case;
            an <=  "11111011";
            count <= count+1;
        elsif (count <= 10000 and count >7500) then 
            case int_o4 is
                        when "0000" => seg <= "1000000";
                        when "0001" => seg <= "1111001";
                        when "0010" => seg <= "0100100";
                        when "0011" => seg <= "0110000";
                        when "0100" => seg <= "0011001";
                        when "0101" => seg <= "0010010";
                        when "0110" => seg <= "0000010";
                        when "0111" => seg <= "1111000";
                        when "1000" => seg <= "0000000";
                        when "1001" => seg <= "0010000";
                        when "1010" => seg <= "1000000";
                        when "1011" => seg <= "1111001";
                        when "1100" => seg <= "0100100";
                        when "1101" => seg <= "0110000";
                        when "1110" => seg <= "0011001";
                        when "1111" => seg <= "0010010";
                        when others => seg <= "XXXXXXX";
            end case;     
            an <= "11110111";
            count <= count+1;
          elsif (count <= 12500 and count >10000) then 
           case int_o3 is
                       when "0000" => seg <= "1000000";
                       when "0001" => seg <= "1111001";
                       when "0010" => seg <= "0100100";
                       when "0011" => seg <= "0110000";
                       when "0100" => seg <= "0011001";
                       when "0101" => seg <= "0010010";
                       when "0110" => seg <= "0000010";
                       when "0111" => seg <= "1111000";
                       when "1000" => seg <= "0000000";
                       when "1001" => seg <= "0010000";
                       when "1010" => seg <= "1000000";
                       when "1011" => seg <= "1111001";
                       when "1100" => seg <= "0100100";
                       when "1101" => seg <= "0110000";
                       when "1110" => seg <= "0011001";
                       when "1111" => seg <= "0010010";
                       when others => seg <= "XXXXXXX";
           end case;     
           an <= "11101111";   
           count <= count+1;
           elsif (count <= 15000 and count >12500) then 
              case int_o2 is
                          when "0000" => seg <= "1000000";
                          when "0001" => seg <= "1111001";
                          when "0010" => seg <= "0100100";
                          when "0011" => seg <= "0110000";
                          when "0100" => seg <= "0011001";
                          when "0101" => seg <= "0010010";
                          when "0110" => seg <= "0000010";
                          when "0111" => seg <= "1111000";
                          when "1000" => seg <= "0000000";
                          when "1001" => seg <= "0010000";
                          when "1010" => seg <= "1000000";
                          when "1011" => seg <= "1111001";
                          when "1100" => seg <= "0100100";
                          when "1101" => seg <= "0110000";
                          when "1110" => seg <= "0011001";
                          when "1111" => seg <= "0010010";
                          when others => seg <= "XXXXXXX";
              end case;     
              an <= "11011111";   
              count <= count+1;
           elsif (count <= 17500 and count >15000) then 
               case int_o1 is
                           when "0000" => seg <= "1000000";
                           when "0001" => seg <= "1111001";
                           when "0010" => seg <= "0100100";
                           when "0011" => seg <= "0110000";
                           when "0100" => seg <= "0011001";
                           when "0101" => seg <= "0010010";
                           when "0110" => seg <= "0000010";
                           when "0111" => seg <= "1111000";
                           when "1000" => seg <= "0000000";
                           when "1001" => seg <= "0010000";
                           when "1010" => seg <= "1000000";
                           when "1011" => seg <= "1111001";
                           when "1100" => seg <= "0100100";
                           when "1101" => seg <= "0110000";
                           when "1110" => seg <= "0011001";
                           when "1111" => seg <= "0010010";
                           when others => seg <= "XXXXXXX";
               end case;     
               an <= "10111111";   
               count <= count+1;
            elsif (count <= 20000 and count >17500) then 
               case int_o0 is
                      when "0000" => seg <= "1000000";
                      when "0001" => seg <= "1111001";
                      when "0010" => seg <= "0100100";
                      when "0011" => seg <= "0110000";
                      when "0100" => seg <= "0011001";
                      when "0101" => seg <= "0010010";
                      when "0110" => seg <= "0000010";
                      when "0111" => seg <= "1111000";
                      when "1000" => seg <= "0000000";
                      when "1001" => seg <= "0010000";
                      when "1010" => seg <= "1000000";
                      when "1011" => seg <= "1111001";
                      when "1100" => seg <= "0100100";
                      when "1101" => seg <= "0110000";
                      when "1110" => seg <= "0011001";
                      when "1111" => seg <= "0010010";
                      when others => seg <= "XXXXXXX";
               end case;     
               an <= "01111111";   
               count <= count+1;
               if (count = 20000) then
                    count <= (others => '0');
               else                 
                    count <= count+1;
                end if;            
        end if;
   end if;
end process;

end Behavioral;
