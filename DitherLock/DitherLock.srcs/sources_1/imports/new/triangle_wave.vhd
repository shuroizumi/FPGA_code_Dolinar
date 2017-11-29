library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity triangle_wave is
Port (clktriangle : in std_logic;
      clk_out: in std_logic;
      led : out std_logic_vector(15 downto 0):= (others => '0');
      trianglebit : out std_logic_vector (15 downto 0):="0000000000000000";
      updatetri : out std_logic :='0';
      phi : out  std_logic_vector (7 downto 0);
      DOUTm1: in std_logic_vector (3 downto 0);
      DOUT0 : in std_logic_vector (3 downto 0);
      DOUT1 : in std_logic_vector (3 downto 0);
      DOUT2 : in std_logic_vector (3 downto 0);
      DOUT3 : in std_logic_vector (3 downto 0);
      DOUT4 : in std_logic_vector (3 downto 0);
      DOUT5 : in std_logic_vector (3 downto 0);
      DOUT6 : in std_logic_vector (3 downto 0);
      DOUT7 : in std_logic_vector (3 downto 0);
      M  : in std_logic :='0';
      G  : in std_logic :='0';
      vstepout : out integer range 0 to 50:=1;
      waveamp : in  std_logic :='0'
      );
end triangle_wave;

architecture Behavioral of triangle_wave is


signal vstep :integer range 0 to 50:=1;
signal updown : std_logic :='0';
signal cnt : std_logic_vector (9 downto 0);
signal tim: std_logic_vector (31 downto 0);
--constant tennano :std_logic_vector (3 downto 0) :=  "1010";
--constant tennano :std_logic_vector (4 downto 0) :=  "11001";
constant tennano :std_logic_vector (4 downto 0) :=  "10100";

signal timeset: std_logic_vector (32 downto 0);
signal  int100000000 : std_logic_vector (32 downto 0);
signal  int10000000 : std_logic_vector (32 downto 0);
signal  int1000000 : std_logic_vector (32 downto 0);
signal  int100000 : std_logic_vector (32 downto 0);
signal  int10000 : std_logic_vector (32 downto 0);
signal  int1000 : std_logic_vector (32 downto 0);
signal  int100 : std_logic_vector (32 downto 0);
signal  int10 : std_logic_vector (32 downto 0);
signal  int1 : std_logic_vector (32 downto 0);

----0.05V step upto 2.5V
type Voltagethresh2 is array (0 to 49) of std_logic_vector (15 downto 0);
--constant Voltagethresh : Voltagethresh2:=(
----0
--"0000000000000000", 
----"0000010100011111",
----0.1
--"0000101000111101", 
----0.15
--"0000111101011100", "0001010001111011", "0001100110011010", 
--"0001111010111000", "0010001111010111", "0010100011110110", 
--"0010111000010100", "0011001100110011", "0011100001010010", 
--"0011110101110001", "0100001010001111", "0100011110101110", 
--"0100110011001101", "0101000111101100", "0101011100001010", 
--"0101110000101001", "0110000101001000", "0110011001100110", 
--"0110101110000101", "0111000010100100", "0111010111000011", 
--"0111101011100001", "1000000000000000", "1000010100011111", 
--"1000101000111101", "1000111101011100", "1001010001111011", 
--"1001100110011010", "1001111010111000", "1010001111010111", 
--"1010100011110110", "1010111000010100", "1011001100110011", 
--"1011100001010010", "1011110101110001", "1100001010001111", 
--"1100011110101110", "1100110011001101", "1101000111101100", 
--"1101011100001010", "1101110000101001", "1110000101001000", 
--"1110011001100110", "1110101110000101", "1111000010100100", 
--"1111010111000011", "1111101011100001", "1111111111111111");

signal Voltagethreshvar : Voltagethresh2:=(
--0
"0000000000000000",
----0.08
"0000100000110001", 
"0000110001001010", "0001000001100010", "0001010001111011", 
"0001100010010011", "0001110010101100", "0010000011000101", 
"0010010011011101", "0010100011110110", "0010110100001110", 
"0011000100100111", "0011010100111111", "0011100101011000", 
"0011110101110001", "0100000110001001", "0100010110100010", 
"0100100110111010", "0100110111010011", "0101000111101100", 
"0101011000000100", "0101101000011101", "0101111000110101", 
"0110001001001110", "0110011001100110", "0110101001111111", 
"0110111010011000", "0111001010110000", "0111011011001001", 
"0111101011100001", "0111111011111010", "1000001100010010", 
"1000011100101011", "1000101101000100", "1000111101011100", 
"1001001101110101", "1001011110001101", "1001101110100110", 
"1001111110111110", "1010001111010111", "1010011111110000", 
"1010110000001000", "1011000000100001", "1011010000111001", 
"1011100001010010", "1011110001101010", "1100000010000011", 
"1100010010011100", "1100100010110100", "1100110011001101");


------0.025V step upto 1.25V
--type Voltagethresh2 is array (0 to 49) of std_logic_vector (15 downto 0);
--constant Voltagethresh : Voltagethresh2:=(
--"0000000000000000", "0000001010001111", "0000010100011111", 
--"0000011110101110", "0000101000111101", "0000110011001101",
--"0000111101011100", "0001000111101100", "0001010001111011",
--"0001011100001010", "0001100110011010", "0001110000101001",
--"0001111010111000", "0010000101001000", "0010001111010111",
--"0010011001100110", "0010100011110110", "0010101110000101",
--"0010111000010100", "0011000010100100", "0011001100110011",
--"0011010111000011", "0011100001010010", "0011101011100001",
--"0011110101110001", "0100000000000000", "0100001010001111",
--"0100010100011111", "0100011110101110", "0100101000111101",
--"0100110011001101", "0100111101011100", "0101000111101100",
--"0101010001111011", "0101011100001010", "0101100110011010",
--"0101110000101001", "0101111010111000", "0110000101001000",
--"0110001111010111", "0110011001100110", "0110100011110110",
--"0110101110000101", "0110111000010100", "0111000010100100",
--"0111001100110011", "0111010111000011", "0111100001010010",
--"0111101011100001", "0111110101110001");



signal j : integer;
signal Vinc :integer :=0;
signal k : integer;
signal Vmax : integer :=200;
signal Vincstd : std_logic_vector (15 downto 0);
signal state_reg : std_logic_vector(3 downto 0):= (others => '0');
signal timesetwaveamp: std_logic_vector (32 downto 0);
signal  int100waveamp : std_logic_vector (32 downto 0);
signal  int10waveamp : std_logic_vector (32 downto 0);
signal  int1waveamp : std_logic_vector (32 downto 0);
signal  Vvar :integer :=0;



begin

Vinc<=Vmax * 524 /100;
Vincstd<=conv_STD_LOGIC_VECTOR(Vinc,16);
led<=Voltagethreshvar(48);
--led<=Vincstd;
process (clktriangle) begin
if (clktriangle'event and clktriangle = '1') then
case state_reg is
   when "0000" =>    
     if(waveamp='1') then
       state_reg<=state_reg+1;
     end if;  
   when "0001" =>    
       state_reg<=state_reg+1;
   when "0010" =>    
       state_reg<=state_reg+1;
   when "0011" =>    
       state_reg<=state_reg+1;
   when "0100" =>    
       state_reg<=state_reg+1;
   when "0101" =>    
       state_reg<=state_reg+1;
   when "0110" =>    
       state_reg<=state_reg+1;
   when "0111" =>    
       state_reg<=state_reg+1;
   when "1000" =>
    if (k=0) then
        Vvar<=0;
    else
        Vvar<=Vinc*(k+1);
    end if;
    state_reg<=state_reg+1;
   when "1001" =>    
    if (k<50) then
       Voltagethreshvar(k)<=conv_STD_LOGIC_VECTOR(Vvar,16);
       k<=k+1;
       state_reg<="1000";
    elsif (k=0) then
       Voltagethreshvar(0)<="0000000000000000";
       k<=k+1;
       state_reg<="1000";
    else
       state_reg<=state_reg+1;
       k<=0;
    end if;
   when "1010" =>    
    state_reg<="0000";
   when others =>  state_reg<="0000";
end case;
end if;
end process;



vstepout<=vstep;
process (clk_out,G) begin
if (clk_out'event and clk_out = '1') then
if (G='1') then
    if (updown ='0') then   
        if (tim>=timeset-tennano) then
           trianglebit<=Voltagethreshvar(vstep);
           updatetri<='1';
           tim<= (others => '0');
           phi<=conv_STD_LOGIC_VECTOR(vstep,8);
           if (vstep=49) then
            vstep<=vstep-1;
            updown <='1';
           else
            vstep<=vstep+1;
            updown <='0';
           end if; 
        else
           tim <=tim + tennano ;
            updatetri<='0';
        end if;
    elsif (updown ='1') then         
        if (tim>=timeset-tennano ) then
           updatetri<='1';
           trianglebit<=Voltagethreshvar(vstep);
           tim<= (others => '0');
           phi<=conv_STD_LOGIC_VECTOR(vstep,8);
           if (vstep=0) then
--            vstep<=vstep+1;
            vstep<= 0;
            updown <='0';
           else
            vstep<=vstep-1;
            updown <='1';
           end if; 
        else
           tim <=tim + tennano ;
           updatetri<='0';
        end if;
    end if;
else
    updown <='0';
    tim <=  (others => '0');
    vstep<= 0;
    updatetri<='0';
end if;
end if;
end process;



process (M,DOUTm1,DOUT0,DOUT1,DOUT2,DOUT3,DOUT4,DOUT5,DOUT6,DOUT7,int1,int10,int100,int1000,int10000,int100000,int1000000,int10000000,int100000000) begin
    if (M='1') then
    --100000000‚ÌˆÊ 
    int100000000 <=  DOUTm1 *"00101111101011110000100000000";
    --10000000‚ÌˆÊ 
    int10000000 <=  DOUT0 *"00000100110001001011010000000";
    --1000000‚ÌˆÊ 
    int1000000 <= DOUT1 * "00000000011110100001001000000" ;
    --100000‚ÌˆÊ 
    int100000 <=  DOUT2 * "00000000000011000011010100000";
    --10000‚ÌˆÊ 
    int10000 <=   DOUT3 * "00000000000000010011100010000";
    --1000‚ÌˆÊ 
    int1000 <=   DOUT4 * "00000000000000000001111101000";
    --100‚ÌˆÊ 
    int100 <=   DOUT5 * "00000000000000000000001100100";
    --10‚ÌˆÊ 
    int10 <=   DOUT6 * "00000000000000000000000001010";
    --1‚ÌˆÊ 
    int1 <=   DOUT7* "00000000000000000000000000001";
    timeset<=int1+int10+int100+int1000+int10000+int100000+int1000000+int10000000+int100000000;
    end if;
end process;


process (waveamp,int1waveamp,int10waveamp,int100waveamp) begin
    if (waveamp='1') then
    int100waveamp <=   DOUT5 * "00000000000000000000001100100";
    --10‚ÌˆÊ 
    int10waveamp <=   DOUT6 * "00000000000000000000000001010";
    --1‚ÌˆÊ 
    int1waveamp <=   DOUT7* "00000000000000000000000000001";
    timesetwaveamp<=int1waveamp+int10waveamp+int100waveamp;
    Vmax<=CONV_INTEGER(unsigned(timesetwaveamp));
    end if;
end process;

end Behavioral;
