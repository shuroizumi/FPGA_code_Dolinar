library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity Analog_digital_conv is
  Port (
  startADC : in std_logic;
  stopADC: in std_logic;
  led : out std_logic_vector (15 downto 0):= (others => '0');
  clk : in std_logic;
  JC: inout  std_logic_vector (7 downto 0);
  update: out std_logic
   );
end Analog_digital_conv;

architecture Behavioral of Analog_digital_conv is


signal clk_out :  std_logic;
signal clk_out2 :  std_logic;
signal cnt : std_logic_vector(20 downto 0):= (others => '0');

signal mode : integer;

signal stage : std_logic_vector(4 downto 0):= (others => '0');
signal stage2 : std_logic_vector(4 downto 0):= (others => '0');
constant address : std_logic_vector(6 downto 0):= "0101000";
constant channel : std_logic_vector(7 downto 0):= "00010000";

signal i : integer range 0 to 6:=6;
signal j : integer range 0 to 7:=7;
signal k : integer range 0 to 15:=15;

signal ACKbyADC : std_logic:= '0';
signal ADCbit : std_logic_vector(15 downto 0):= (others => '0');
 
  
component clk_ADC is
  Port (
 clk : in std_logic;
 clk_out : out std_logic;
 clk_out2 : out std_logic
 );
end component;

begin

iclk_ADC: clk_ADC
  PORT MAP (
    clk => clk,
    clk_out => clk_out,
    clk_out2  => clk_out2
  );

process (clk,mode) begin
if (clk'event and clk= '1') then
if (mode=0) then
 JC(2)<=clk_out;
 JC(6)<=clk_out;
elsif (mode=1) then
 JC(2)<='1';
 JC(6)<='1';
elsif (mode=2) then
  JC(2)<='0';
  JC(6)<='0';
end if;
end if;
end process;

--write to ADC
process (clk) begin
if (clk'event and clk= '1') then
if ( startADC='0') then
    case stage is 
    when "00000"=>
     mode<=1;
     JC(3)<='1';
     stage2<=(others => '0');
      if (clk_out = '0') then
        stage<=stage+1;
      end if;
    when "00001"=>
      if (clk_out = '1') then
        mode<=0;
        if (cnt = 4) then
          stage<=stage+1;
          cnt <=(others => '0'); 
        else
          cnt <=cnt +1 ;  
        end if;
      end if;     
    when "00010"=>
         JC(3)<='0';
         stage<=stage+1;
    when "00011"=>
         if (clk_out = '0') then
             stage<=stage+1;
         end if;
    when "00100"=>
    if (i=0) then
       if (clk_out2 = '1') then
        stage<=stage+2;
        JC(3)<=address(0);
        i<=6;
       end if; 
    else
       if (clk_out2 = '1') then
          stage<=stage+1;
          JC(3)<=address(i);
          i<=i-1;
       end if;
    end if;    
    when "00101"=>
      if (clk_out2 = '0') then
         stage<=stage-1;
      end if;    
    when "00110"=>
       if (clk_out2 = '0') then
         stage<=stage+1;
        end if; 
    when "00111"=>
       if (clk_out2 = '1') then
          stage<=stage+1;
          JC(3)<='0';
       end if; 
    when "01000"=>
      if (clk_out2 = '0') then
         stage<=stage+1;
      end if; 
    when "01001"=>
      if (clk_out = '0') then
        stage<=stage+1;
        JC(3)<='Z';
      end if;         
    when "01010"=>
        stage<=stage+1;
    when "01011"=>
        if (clk_out = '1') then
           stage<=stage+1;
        end if; 
    when "01100"=>
        if (clk_out2 = '0') then
           stage<=stage+1;
        end if; 
    when "01101"=>
    if (j=0) then
        if (clk_out2 = '1') then
           JC(3)<=channel(0); 
           stage<=stage+2;
           j<=7;
        end if; 
    else
        if (clk_out2 = '1') then
           JC(3)<=channel(j); 
           stage<=stage+1;
           j<=j-1;
        end if; 
    end if;
    when "01110"=>
        if (clk_out2 = '0') then
           stage<=stage-1;
        end if; 
    when "01111"=>
       if (clk_out2 = '0') then
           stage<=stage+1;
       end if; 
    when "10000"=>
       if (clk_out2 = '1') then
           stage<=stage+1;
           ACKbyADC<=JC(7);
       end if; 
    when "10001"=>
       if (clk_out2 = '0') then
           stage<=stage+1;
       end if; 
    when "10010"=>
       if (clk_out2 = '1') then
           stage<=stage+1;
       end if; 
    when "10011"=>
      if (clk_out = '1') then
          stage<=stage+1;
          mode<=1;
      end if; 
    when "10100"=>
      if (clk_out2 = '0') then
        stage<=stage+1;
      end if; 
    when "10101"=>
        if (clk_out2 = '1') then
          JC(3)<='1'; 
        end if; 
    when others =>  stage<=(others => '0');  
    end case;
    
    
elsif (startADC='1') then
    case stage2 is 
    when "00000"=>
      stage<=(others => '0');
      mode<=1;
      JC(3)<='1';
      update<='0';
      if (clk_out = '0') then
        stage2<=stage2+1;
      end if;
    when "00001"=>
      if (clk_out = '1') then
          JC(3)<='1';
          mode<=0;
          if (cnt = 4) then
            stage2<=stage2+1;
            cnt <=(others => '0'); 
          else
            cnt <=cnt +1 ;  
          end if;
      end if;     
    when "00010"=>
         JC(3)<='0';
         stage2<=stage2+1;
    when "00011"=>
         JC(3)<='0';
         if (clk_out = '0') then
             stage2<=stage2+1;
         end if;
    when "00100"=>
    if (i=0) then
       if (clk_out2 = '1') then
        stage2<=stage2+2;
        JC(3)<=address(0);
        i<=6;
       end if; 
    else
       if (clk_out2 = '1') then
          stage2<=stage2+1;
          JC(3)<=address(i);
          i<=i-1;
       end if;
    end if;    
    when "00101"=>
      if (clk_out2 = '0') then
         stage2<=stage2-1;
      end if;    
    when "00110"=>
       if (clk_out2 = '0') then
         stage2<=stage2+1;
        end if; 
    when "00111"=>
       if (clk_out2 = '1') then
          stage2<=stage2+1;
          JC(3)<='1';
       end if; 
    when "01000"=>
      if (clk_out2 = '0') then
         stage2<=stage2+1;
      end if; 
    when "01001"=>
        if (clk_out2 = '1') then
           ACKbyADC<=JC(7);
           stage2<=stage2+1;
        end if; 
    when "01010"=>
        if (clk_out2 = '0') then
           stage2<=stage2+1;
        end if; 
    when "01011"=>
        if (clk_out2 = '1') then
            stage2<=stage2+1;
            update<='0';
        end if; 
    when "01100"=>
        if (k=7) then
            if (clk_out2 = '1') then
               stage2<=stage2+2;
               JC(3)<='0';
            end if; 
        else
            if (clk_out = '1') then
               ADCbit(k)<=JC(7); 
               stage2<=stage2+1;
               k<=k-1;
            end if; 
        end if;
    when "01101"=>
        if (clk_out = '0') then
           stage2<=stage2-1;
        end if; 
    when "01110"=>
       if (clk_out2 = '0') then
           stage2<=stage2+1;
       end if; 
    when "01111"=>
          if (clk_out2 = '1') then
              stage2<=stage2+1;
              JC(3)<='1';
          end if; 
    when "10000"=>
        if (k=0) then
            if (clk_out = '1') then
               ADCbit(0)<=JC(7); 
               stage2<=stage2+2;
               k<=15;
            end if; 
        else
            if (clk_out = '1') then
               ADCbit(k)<=JC(7); 
               stage2<=stage2+1;
               k<=k-1;
            end if; 
        end if;
    when "10001"=>
       if (clk_out = '0') then
           stage2<=stage2-1;
       end if; 
    when "10010"=>
       if (clk_out = '0') then
           stage2<=stage2+1;
       end if; 
    when "10011"=>
       if (clk_out2 = '1') then
            stage2<=stage2+1;
            JC(3)<='0';
       end if; 
    when "10100"=>
      if (clk_out2 = '0') then
           stage2<=stage2+1;
      end if; 
    when "10101"=>
        if (clk_out2 = '1') then
          if (stopADC= '0') then
             stage2<="01011";
             JC(3)<='1';
             led(15 downto 0)<=ADCbit(15 downto 0);
             update<='1';
          else
             stage2<=stage2+1;
             JC(3)<='0';
          end if;             
        end if; 
    when "10110"=>
        if (clk_out = '1') then
            stage2<=stage2+1;
            JC(3)<='0';
            mode<=1;
        end if; 
    when "10111"=>
        if (clk_out2 = '0') then
            stage2<=stage2+1;
        end if; 
    when "11000"=>
        if (clk_out2 = '1') then
            JC(3)<='1';              
        end if; 
    when others =>stage2<=(others => '0');  
    end case;
else
    stage<=(others => '0');
    stage2<=(others => '0');
    cnt <=(others => '0'); 
    mode<=2;
    JC(3)<='Z';
    JC(7)<='Z';
    ADCbit<=(others => '0');
    led<=(others => '0');
    update<='0';
end if; 
end if;
end process;



end Behavioral;
