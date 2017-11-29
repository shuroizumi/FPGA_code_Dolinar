library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sine_wave is
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
end sine_wave;

architecture Behavioral of sine_wave is

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component clk_wiz_1
port
 (-- Clock in ports
  clk_in1           : in     std_logic;
  -- Clock out ports
  clk_out1          : out    std_logic );
end component;

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

signal Voltagethreshvar : Voltagethresh2:=(
--0
"0000000000000000",
"0000000001100111",
"0000000011101000", "0000000110011100", "0000001010000010", 
"0000001110011000", "0000010011011111", "0000011001010101", 
"0000011111111000", "0000100111000111", "0000101111000000", 
"0000110111100000", "0001000000100111", "0001001010010000", 
"0001010100011011", "0001011111000100", "0001101010001001", 
"0001110101100110", "0010000001011010", "0010001101100001", 
"0010011001111000", "0010100110011011", "0010110011001000", 
"0010111111111100", "0011001100110011", "0011011001101010", 
"0011100110011110", "0011110011001011", "0011111111101111", 
"0100001100000110", "0100011000001100", "0100100100000000", 
"0100101111011110", "0100111010100010", "0101000101001011", 
"0101001111010110", "0101011001000000", "0101100010000110", 
"0101101010100110", "0101110010011111", "0101111001101110", 
"0110000000010001", "0110000110000111", "0110001011001110", 
"0110001111100101", "0110010011001011", "0110010101111110", 
"0110010111111111", "0110011001001101", "0110011001100110"
);

type Voltagethreshint2 is array (0 to 49) of integer;
signal Voltagethreshint : Voltagethreshint2:=(
0, 103, 232, 412, 642, 920, 1247, 1621, 2040, 2503, 3008, 3552,
4135, 4752, 5403, 6084, 6793, 7526, 8282, 9057, 9848, 10651, 11464,
12284, 13107, 13930, 14750, 15563, 16367, 17158, 17932, 18688, 19422,
20130, 20811, 21462, 22080, 22662, 23206, 23711, 24174, 24593, 24967,
25294, 25573, 25803, 25982, 26111, 26189, 26214
);

constant Voltagethreshintconst : Voltagethreshint2:=(
0, 103, 232, 412, 642, 920, 1247, 1621, 2040, 2503, 3008, 3552,
4135, 4752, 5403, 6084, 6793, 7526, 8282, 9057, 9848, 10651, 11464,
12284, 13107, 13930, 14750, 15563, 16367, 17158, 17932, 18688, 19422,
20130, 20811, 21462, 22080, 22662, 23206, 23711, 24174, 24593, 24967,
25294, 25573, 25803, 25982, 26111, 26189, 26214
);


signal j : integer;
signal k : integer;
signal Vmax : integer :=200;
signal state_reg : std_logic_vector(3 downto 0):= (others => '0');
signal timesetwaveamp: std_logic_vector (32 downto 0);
signal  int100waveamp : std_logic_vector (32 downto 0);
signal  int10waveamp : std_logic_vector (32 downto 0);
signal  int1waveamp : std_logic_vector (32 downto 0);

signal  t :integer :=0;
signal Vint : integer;
signal Vvar : integer;
signal Vvarstd: std_logic_vector (15 downto 0);

signal stage_reg : std_logic_vector(3 downto 0):= (others => '0');

signal waveamp_reg :std_logic;
signal clk_10M :std_logic;

begin

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
iclk_10M: clk_wiz_1
   port map ( 
   -- Clock in ports
   clk_in1 => clktriangle,
  -- Clock out ports  
   clk_out1 => clk_10M     
 );
-- INST_TAG_END ------ End INSTANTIATION Template ------------



process (clk_10M) begin
if (clk_10M'event and clk_10M = '1') then
case stage_reg is
   when "0000" =>    
     waveamp_reg<='0';
--     if(waveamp='1') then
      stage_reg<=stage_reg+1;
--     end if;  
   when "0001" =>    
    Vint<=Voltagethreshintconst(t);
    stage_reg<=stage_reg+1;
   when "0010" =>    
    Vint<=Vint*Vmax;
    stage_reg<=stage_reg+1;
   when "0011" =>    
    Vint<=Vint/100;
    stage_reg<=stage_reg+1;
   when "0100" =>    
    Voltagethreshint(t)<=Vint;
    stage_reg<=stage_reg+1;
   when "0101" =>    
    if (t=49) then
       t<=0;
       stage_reg<=stage_reg+1;
   else
       t<=t+1;      
       stage_reg<="0001";
   end if;
   when "0110" =>    
       stage_reg<="0000";   
       waveamp_reg<='1';
   when others =>  stage_reg<="0000";
end case;
end if;
end process;

led<=Voltagethreshvar(48);
process (clktriangle,waveamp_reg) begin
if (clktriangle'event and clktriangle = '1') then
case state_reg is
   when "0000" =>    
--     if(waveamp_reg='1') then
       state_reg<=state_reg+1;
--     end if;  
   when "0001" =>    
       state_reg<=state_reg+1;
       Vvar<=Voltagethreshint(k);
   when "0010" =>    
       state_reg<=state_reg+1;
   when "0011" =>    
       state_reg<=state_reg+1;
       Vvarstd<=conv_STD_LOGIC_VECTOR(Vvar,16);
   when "0100" =>    
       state_reg<=state_reg+1;
   when "0101" =>    
       state_reg<=state_reg+1;
   when "0110" =>    
       state_reg<=state_reg+1;
   when "0111" =>    
       state_reg<=state_reg+1;
   when "1000" =>
    if (k<49) then
       Voltagethreshvar(k)<=Vvarstd;
       k<=k+1;
       state_reg<="0001";
    elsif (k=0) then
       Voltagethreshvar(0)<="0000000000000000";
       k<=k+1;
       state_reg<="0001";
    elsif (k=49) then
       Voltagethreshvar(49)<=Vvarstd;
       state_reg<=state_reg+1;
       k<=0;
    end if;
   when "1001" =>    
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
