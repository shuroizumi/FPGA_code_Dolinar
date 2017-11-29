library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



------------------420ns for single run------------------------------
entity std_vector_to_floating is
  Port (
  clk : in std_logic;
  std_vector  : in STD_LOGIC_VECTOR(31 DOWNTO 0);
  floating  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
  convert : in std_logic;
  finish_convert : out std_logic
   );
end std_vector_to_floating;

architecture Behavioral of std_vector_to_floating is


signal state_reg : std_logic_vector(3 downto 0):= (others => '0');
signal std_vector_reg : std_logic_vector(30 DOWNTO 0):= (others => '0');
signal std_vector_reg2 : std_logic_vector(31 DOWNTO 0):= (others => '0');

signal significant : std_logic_vector (22 downto 0);
signal exponent : std_logic_vector (7 downto 0);
signal N : std_logic_vector (7 downto 0):= (others => '0');
signal Nint : integer range -33 to 33;




begin



process (clk) begin
if (clk'event and clk = '1') then
case state_reg is
   when "0000" =>
    std_vector_reg<=std_vector(30 downto 0);
    std_vector_reg2<=std_vector;    
    N<=(others => '0');
    Nint<=0;
    finish_convert<='0';
    if (convert='1') then
        state_reg<=state_reg+1;
    end if;   
   when "0001" =>   
    if (std_vector_reg="0000000000000000000000000000000") then
        if (Nint=0) then
         exponent<="00000000";
         state_reg<="0100";
        else
         N<=N-1;
         Nint<=Nint-2;
         state_reg<="0011";
        end if;            
    else
        state_reg<=state_reg+1;
    end if;
   when "0010" =>
    std_vector_reg<='0' & std_vector_reg(30 downto 1);
    if (Nint=31) then
     state_reg<=state_reg+1;
    else
     N<=N+1;
     Nint<=Nint+1;
     state_reg<= "0001";
    end if;
   when "0011" =>
    exponent<=N+"01111111";
    state_reg<=state_reg+1;
   when "0100" => 
    if (Nint<0) then
     significant<=(others => '0');
    elsif (Nint=0) then
     significant<=std_vector(0) & "0000000000000000000000";
    elsif (Nint=1) then
     significant<=std_vector(1 downto 0) & "000000000000000000000";
    elsif (Nint=2) then
     significant<=std_vector(2 downto 0) & "00000000000000000000";
    elsif (Nint=3) then
     significant<=std_vector(3 downto 0) & "0000000000000000000";
    elsif (Nint=4) then
     significant<=std_vector(4 downto 0) & "000000000000000000";
    elsif (Nint=5) then
     significant<=std_vector(5 downto 0) & "00000000000000000";
    elsif (Nint=6) then
     significant<=std_vector(6 downto 0) & "0000000000000000";
    elsif (Nint=7) then
     significant<=std_vector(7 downto 0) & "000000000000000";
    elsif (Nint=8) then
     significant<=std_vector(8 downto 0) & "00000000000000";
    elsif (Nint=9) then
     significant<=std_vector(9 downto 0) & "0000000000000";
    elsif (Nint=10) then
     significant<=std_vector(10 downto 0) & "000000000000";
    elsif (Nint=11) then
     significant<=std_vector(11 downto 0) & "00000000000";
    elsif (Nint=12) then
     significant<=std_vector(12 downto 0) & "0000000000";
    elsif (Nint=13) then
     significant<=std_vector(13 downto 0) & "000000000";
    elsif (Nint=14) then
     significant<=std_vector(14 downto 0) & "00000000";
    elsif (Nint=15) then
     significant<=std_vector(15 downto 0) & "0000000";
    elsif (Nint=16) then
     significant<=std_vector(16 downto 0) & "000000";
    elsif (Nint=17) then
     significant<=std_vector(17 downto 0) & "00000";
    elsif (Nint=18) then
     significant<=std_vector(18 downto 0) & "0000";
    elsif (Nint=19) then
     significant<=std_vector(19 downto 0) & "000";
    elsif (Nint=20) then
     significant<=std_vector(20 downto 0) & "00";
    elsif (Nint=21) then
     significant<=std_vector(21 downto 0) & '0';
    end if;
    state_reg<=state_reg+1;    
   when "0101" =>
    floating<=std_vector_reg2(31) & exponent & significant;
    finish_convert<='1';
    state_reg<=(others => '0');
   when others =>  state_reg<="0000";
end case;
end if;
end process;




end Behavioral;
