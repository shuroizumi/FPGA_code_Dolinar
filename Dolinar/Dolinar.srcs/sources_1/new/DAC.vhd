library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DAC is
  Port (
        clkPmod : in std_logic;
        clk_out : in std_logic;
        JAPmod : out std_logic_vector (7 downto 4);
        analogbit : in std_logic_vector (15 downto 0);
        updateana : in std_logic:='0';
        finconv : out std_logic:='0';
        phiin: in std_logic_vector (7 downto 0);
        phiout: out std_logic_vector (7 downto 0)
        );
end DAC;

architecture Behavioral of DAC is

signal state_reg: std_logic:= '0';
constant W0: integer := 17;
signal I : natural;

signal update_reg: std_logic:= '0';
signal finconv_reg: std_logic:= '0';
signal j : integer;
signal phi_reg: std_logic_vector (7 downto 0);

begin
JAPmod(7)<=clkPmod;

process (clkPmod,state_reg,updateana,phiin) begin
    case state_reg is 
    when '0'=> 
--      finconv_reg<='0';  
      if (updateana='1') then
        state_reg<='1';
        phi_reg<=phiin;
      end if;
   when '1'=>
       if (clkPmod'event and clkPmod = '0') then 
            if (I <= 15) then
                JAPmod(5)<= analogbit(15-I);
                I<=I+1;
                JAPmod(4)<='0';
                JAPmod(6)<='1';
            elsif (I =16) then
                I<=I+1;
                JAPmod(4)<='1';
--                finconv<='1';
                finconv_reg<='1';
            elsif (I = 17) then
                I<= 0;   
                JAPmod(6)<='0';
--                finconv<='0';
                finconv_reg<='0';
                state_reg<='0';
                phiout<=phi_reg;
            end if;
       end if;
   end case;
end process;

process (finconv_reg,update_reg,clk_out) begin
case update_reg is 
 when '0'=>
     finconv<='0';
     if (finconv_reg='1') then
         update_reg<='1';
     end if;
 when '1'=>
    if (clk_out 'event and clk_out  = '1') then
         if (j=1) then
             finconv<='0';
             j<=0;
             update_reg<='0';
         else
             j<=j+1;
             finconv<='1';
         end if;
     end if;
 when others => update_reg<='0';    
 end case;

end process;


end Behavioral;
