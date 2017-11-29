library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clk_ADC is
  Port (
 clk : in std_logic;
 clk_out : out std_logic;
 clk_out2 : out std_logic
 );
end clk_ADC;

architecture Behavioral of clk_ADC is

signal cnt : std_logic_vector(20 downto 0):= (others => '0');

signal cnt2 : std_logic_vector(20 downto 0):= (others => '0');
signal stage : std_logic_vector(1 downto 0):= (others => '0');



begin

process (clk) begin
if (clk'event and clk= '1') then
  if (cnt <= 499) then
    clk_out <= '0';
    cnt <=cnt +1 ;  
  elsif (cnt > 499 and cnt < 999) then
    clk_out <=  '1';
    cnt <=cnt +1 ;  
  elsif (cnt = 999) then
    cnt <=(others => '0'); 
  end if;
end if;
end process;

process (clk) begin
if (clk'event and clk= '1') then
case stage is 
when "00"=>
  if (cnt2 = 749) then
    clk_out2 <= '0';
    cnt2 <=(others => '0'); 
    stage<=stage+1;
  else
    cnt2 <=cnt2 +1 ;  
  end if;
when "01"=>
   if (cnt2 <= 499) then
      clk_out2 <= '0';
      cnt2 <=cnt2 +1 ;  
    elsif (cnt2 > 499 and cnt2 < 999) then
      clk_out2 <=  '1';
      cnt2 <=cnt2 +1 ;  
    elsif (cnt2 = 999) then
      cnt2 <=(others => '0'); 
    end if;
when others =>  stage<=(others => '0');  
end case;
end if;
end process;



end Behavioral;
