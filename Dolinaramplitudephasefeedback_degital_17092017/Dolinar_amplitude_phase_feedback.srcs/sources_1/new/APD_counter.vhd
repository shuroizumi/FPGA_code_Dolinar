library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.numeric_std.ALL;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--pulse length = clock(100MHz) * Maximum I
entity APD_counter is
  Port (sw : in std_logic;
       clk : in std_logic;
       clk_out : in std_logic;
       JB: in  std_logic;
       RsRx : in  std_logic;
       APDcnt : out std_logic_vector (32 downto 0):= (others => '0');
       Run : in  std_logic;
       ascii0: out std_logic_vector (7 downto 0);
       ascii1: out std_logic_vector (7 downto 0);
       ascii2: out std_logic_vector (7 downto 0);
       ascii3: out std_logic_vector (7 downto 0);
       ascii4: out std_logic_vector (7 downto 0);
       ascii5: out std_logic_vector (7 downto 0);
       ascii6: out std_logic_vector (7 downto 0);
       ascii7: out std_logic_vector (7 downto 0);
       SGIN0: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN1: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN2: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN3: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN4: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN5: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN6: out std_logic_vector  (3 downto 0):= (others => '0');
       SGIN7: out std_logic_vector  (3 downto 0):= (others => '0');
       startconversion: out  std_logic;
       startconversionSO: out  std_logic;
       cntdone: out  std_logic;
       countDIS: out  std_logic;
       finconv: in  std_logic;
       lockmode: in  std_logic
               );
end APD_counter;
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
architecture Behavioral of APD_counter is

component UARAT_receiver is 
 port (clkoriginal : in std_logic;
       clk_UART : in std_logic;
       RsRx : in  std_logic;
       dataout0 : out std_logic_vector (3 downto 0);
       dataout1 : out std_logic_vector (3 downto 0);
       dataout2 : out std_logic_vector (3 downto 0);
       dataout3 : out std_logic_vector (3 downto 0);
       setout : out  std_logic :='0'
       );
end component;

component clk_UART_receiver is 
 port (clk_i :in std_logic;
       clk_o :out std_logic
       );
end component;

component integer_ASCII is 
 port (ascii  : out std_logic_vector (7 downto 0);
        int : in std_logic_vector (3 downto 0)
       );
end component;
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
signal I : std_logic_vector(32 downto 0):= (others => '0');
signal j : std_logic_vector(6 downto 0):= (others => '0');

signal countnum : integer;
signal cnt : std_logic_vector(32 downto 0):= (others => '0');

signal clk_U : std_logic;
signal DOUT0  : std_logic_vector (3 downto 0);
signal DOUT1  : std_logic_vector (3 downto 0);
signal DOUT2  : std_logic_vector (3 downto 0);
signal DOUT3  : std_logic_vector (3 downto 0);
signal int1  : std_logic_vector (32 downto 0):= (others => '0');
signal int10  : std_logic_vector (32 downto 0):= (others => '0');
signal int100  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000  : std_logic_vector (32 downto 0):= (others => '0');

signal W  : std_logic_vector (32 downto 0):= (others => '0');
signal SO  : std_logic :='0';

signal count10000000: integer;
signal count1000000: integer;
signal count100000: integer;
signal count10000: integer;
signal count1000: integer;
signal count100: integer;
signal count10: integer;
signal count1: integer;

signal cntmod10000000: integer;
signal cntmod1000000: integer;
signal cntmod100000: integer;
signal cntmod10000: integer;
signal cntmod1000: integer;
signal cntmod100: integer;
signal cntmod10: integer;
signal cntmod1: integer;

signal vlue10000000 : integer;
signal vlue1000000 : integer;
signal vlue100000 : integer;
signal vlue10000 : integer;
signal vlue1000 : integer;
signal vlue100 : integer;
signal vlue10 : integer;
signal vlue1 : integer;

signal countDIS10000000: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS1000000: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS100000: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS10000: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS1000: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS100: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS10: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS1: std_logic_vector (3 downto 0):= (others => '0');

signal p  : std_logic_vector (3 downto 0):= (others => '0');
signal q  : natural;

signal startconv: std_logic :='0';
signal countDIS_reg: std_logic :='0';
signal stage: std_logic_vector (3 downto 0):= (others => '0');

signal rest: std_logic :='0';
signal step: std_logic :='0';
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
begin
iclk_UART: clk_UART_receiver port map(clk_i=>clk, clk_o=>clk_U);
iUART: UARAT_receiver port map(clkoriginal=> clk, clk_UART=>clk_U, RsRx=>RsRx, dataout0 =>DOUT0,dataout1 =>DOUT1,dataout2 =>DOUT2,dataout3 =>DOUT3, setout=>SO);
iinteger_ASCII0: integer_ASCII port map(ascii=>ascii0 ,int=>countDIS10000000); 
iinteger_ASCII1: integer_ASCII port map(ascii=>ascii1 ,int=>countDIS1000000);
iinteger_ASCII2: integer_ASCII port map(ascii=>ascii2 ,int=>countDIS100000);  
iinteger_ASCII3: integer_ASCII port map(ascii=>ascii3 ,int=>countDIS10000);  
iinteger_ASCII4: integer_ASCII port map(ascii=>ascii4 ,int=>countDIS1000);  
iinteger_ASCII5: integer_ASCII port map(ascii=>ascii5 ,int=>countDIS100);  
iinteger_ASCII6: integer_ASCII port map(ascii=>ascii6 ,int=>countDIS10);  
iinteger_ASCII7: integer_ASCII port map(ascii=>ascii7 ,int=>countDIS1); 
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
startconversion<=countDIS_reg;
startconversionSO<=SO;



process (sw,clk,finconv,lockmode) begin    
if (sw='1') then
    j<= (others => '0');
    cnt<= (others => '0');
    I<= (others => '0'); 
    rest<='0';
    step<='0';
else
    if ( clk'event and clk = '1' ) then
      if (lockmode='0') then
            j<= (others => '0');
            cnt<= (others => '0');
            I<= (others => '0'); 
            rest<='0';
            step<='0';
            cntdone<='0';         
            startconv<='0';
       else      
            if (Run='1') then
                    if (I <=  W-2) then
                          if (step='0') then
                            step<='1';
                            startconv<='0';
                            cntdone<='0';
                            if (j=9) then
                                 j<= (others => '0');
                                 if (JB='1') then
                                     rest<='1';
                                 else
                                     rest<='0';
                                 end if;
                                 cnt<=cnt+JB;
                                 I<=I+1;
                             else
                                 j<=j+1;
                                 if (JB='1') then
                                     rest<='1';
                                 else
                                     rest<='0';
                                 end if;
                                 cnt<=cnt+JB;
                             end if;
                        
                         else 
                               if (rest='0') then
                                  rest<='0';
                                  step<='0';
                               else
                                  rest<='1';
                                  step<='1';
                                  rest<='0';
                               end if;   
                               if (j=9) then
                                  I<=I+1;
                                  j<= (others => '0');
                               else
                                  j<=j+1;
                               end if;
                         end if;    
                    
                    
                elsif (I = W-1) then
                    if (j=10) then
                       countnum<=CONV_INTEGER(unsigned(cnt)); 
                       APDcnt<=cnt;
                       cnt<= (others => '0');                     
                       cntdone<='1';         
                       startconv<='1';  
                       j<=j+1; 
                       rest<='0';
                       step<='0';
                    elsif (j=11) then  
                       j<=j+1;
                    elsif (j=12) then  
                        j<=j+1;
                    elsif (j=13) then
                       cntdone<='0';         
                       startconv<='0';
                       if (finconv='1') then     
                          I<= (others => '0');
                          j<= (others => '0');      
                       end if;        
                    elsif (j=9) then
                        j<=j+1;
                        cnt<=cnt+JB;
                    else
                        j<=j+1;
                        cnt<=cnt+JB;
                    end if;
                end if;              
            end if;
        end if;
    end if;
end if;
end process;


--process (sw,clk_out,finconv,lockmode) begin    
--if (sw='1') then
--    j<= (others => '0');
--    cnt<= (others => '0');
--    I<= (others => '0'); 
--    rest<='0';
--else
--    if ( clk_out'event and clk_out = '1' ) then
--      if (lockmode='0') then
--            j<= (others => '0');
--            cnt<= (others => '0');
--            I<= (others => '0'); 
--            rest<='0';
--            cntdone<='0';         
--            startconv<='0';
--       else      
--            if (Run='1') then
--                if (I <=  W-2) then
--                    startconv<='0';
--                    cntdone<='0';
--                    if (j=4) then
--                        j<= (others => '0');
--                        if (rest='0') then
--                            if (JB='1') then
----                                rest<='1';
--                                rest<='0';
--                            else
--                                rest<='0';
--                            end if;
--                            cnt<=cnt+JB;
--                       else
--                           rest<='0';
--                       end if;
--                        I<=I+1;
--                    else
--                        j<=j+1;
--                        if (rest='0') then
--                            if (JB='1') then
----                                rest<='1';
--                                rest<='0';
--                            else
--                                rest<='0';
--                            end if;
--                            cnt<=cnt+JB;
--                       else
--                           rest<='0';
--                       end if;
--                    end if;
--                elsif (I = W-1) then
--                    if (j=5) then
--                       countnum<=CONV_INTEGER(unsigned(cnt)); 
--                       APDcnt<=cnt;
--                       cnt<= (others => '0');                     
--                       cntdone<='1';         
--                       startconv<='1';  
--                       j<=j+1; 
--                       rest<='0';
--                    elsif (j=6) then
--                       cntdone<='0';         
--                       startconv<='0';
--                       if (finconv='1') then     
--                          I<= (others => '0');
--                          j<= (others => '0');      
--                       end if;        
--                    elsif (j=4) then
--                        j<=j+1;
--                        if (rest='0') then
--                            if (JB='1') then
----                                rest<='1';
--                                rest<='0';
--                            else
--                                rest<='0';
--                            end if;
--                            cnt<=cnt+JB;
--                       else
--                           rest<='0';
--                       end if;
--                    else
--                        j<=j+1;
--                        if (rest='0') then
--                            if (JB='1') then
----                                rest<='1';
--                                rest<='0';
--                            else
--                                rest<='0';
--                            end if;
--                            cnt<=cnt+JB;
--                       else
--                           rest<='0';
--                       end if;
--                    end if;
--                end if;              
--            end if;
--        end if;
--    end if;
--end if;
--end process;


--To show count on the 7-segment display
process (clk,startconv) begin
if (clk'event and clk = '1') then
case p is
    when  "0000" =>
        if (startconv='1') then   
            p<="0001";
        else
            p<="0000";
        end if;
    when  "0001" =>
        if (q=0) then
            cntmod10000000<=countnum mod 10000000;
            q<=q+1;
        elsif (q=1) then
            q<=q+1;
        elsif (q=2) then
            q<=q+1;
        elsif (q=3) then
            q<=q+1;
        elsif (q=4) then
            count10000000 <= countnum - cntmod10000000;
            q<=q+1;
        elsif (q=5) then
            vlue10000000 <= count10000000/10000000;
            q<=q+1;
        elsif (q=6) then
            q<=q+1;
        elsif (q=7) then
            q<=q+1;
        elsif (q=8) then
            q<=q+1;
        elsif (q=9) then
            q<=q+1;
        elsif (q=10) then
            countDIS10000000<=conv_STD_LOGIC_VECTOR(vlue10000000,4);
            q<=0;
            p<="0010";
        else
            p<="0001"; 
        end if;  
   when "0010" =>
        if (q=0) then
            cntmod1000000<=countnum mod 1000000;
            q<=q+1;
        elsif (q=1) then
            count1000000 <= countnum- count10000000- cntmod1000000;
            q<=q+1;
        elsif (q=2) then
            vlue1000000 <= count1000000/1000000;
            q<=q+1;
        elsif (q=3) then
            q<=q+1;
        elsif (q=4) then
            q<=q+1;
        elsif (q=5) then
            q<=q+1;
        elsif (q=6) then
            q<=q+1; 
        elsif (q=7) then
            countDIS1000000<=conv_STD_LOGIC_VECTOR(vlue1000000,4);
            q<=0;
            p<="0011";
        else 
            p<="0010";
        end if;  
    when "0011" =>
        if (q=0) then
            countDIS<='0';
            countDIS_reg<='0';
            cntmod100000<=countnum mod 100000;
            q<=q+1;
        elsif (q=1) then
            count100000 <= countnum-count10000000-count1000000 - cntmod100000;
            q<=q+1;
        elsif (q=2) then
            vlue100000 <= count100000/100000;
            q<=q+1;
       elsif (q=3) then
            q<=q+1;
        elsif (q=4) then
            q<=q+1;
        elsif (q=5) then
            q<=q+1;
        elsif (q=6) then
            q<=q+1; 

        elsif (q=7) then
            countDIS100000<=conv_STD_LOGIC_VECTOR(vlue100000,4);
            q<=0;
            p<="0100";
        else
            p<="0011";
        end if;
     when "0100" => 
        if (q=0) then
            cntmod10000<=countnum mod 10000;
            q<=q+1;
        elsif (q=1) then
            count10000 <= countnum-count10000000-count1000000-count100000 - cntmod10000;
            q<=q+1;
        elsif (q=2) then
            vlue10000 <= count10000/10000;
            q<=q+1;
         elsif (q=3) then
            q<=q+1;
        elsif (q=4) then
            q<=q+1;
        elsif (q=5) then
            q<=q+1;
        elsif (q=6) then
            q<=q+1;
        elsif (q=7) then
            countDIS10000<=conv_STD_LOGIC_VECTOR(vlue10000,4);
            q<=0;
            p<="0101";
        else
            p<="0100";
        end if;  
    when  "0101" => 
        if (q=0) then
            cntmod1000<=countnum mod 1000;
            q<=q+1;
        elsif (q=1) then
            count1000 <= countnum-count10000000-count1000000 -count100000 -count10000- cntmod1000;
            q<=q+1;
        elsif (q=2) then
            vlue1000 <= count1000/1000;
            q<=q+1;
        elsif (q=3) then
            q<=q+1;
        elsif (q=4) then
            q<=q+1;
        elsif (q=5) then
            q<=q+1;
        elsif (q=6) then
            q<=q+1; 
        elsif (q=7) then
             countDIS1000<=conv_STD_LOGIC_VECTOR(vlue1000,4);
            q<=0;
            p<="0110";
        else 
            p<="0101";
        end if;
    when "0110"=>
        if (q=0) then
            cntmod100<=countnum mod 100;
            q<=q+1;
            p<="0110";
        elsif (q=1) then
            count100 <= countnum-count10000000-count1000000-count100000 -count10000 -count1000- cntmod100;
            q<=q+1;
            p<="0110";
        elsif (q=2) then
            vlue100 <= count100/100;
            q<=q+1;
            p<="0110";
        elsif (q=3) then
            countDIS100<=conv_STD_LOGIC_VECTOR(vlue100,4);
            q<=0;
            p<="0111";
        else 
            p<="0110";
        end if; 
    when    "0111"=>
        if (q=0) then
            cntmod10<=countnum mod 10;
            q<=q+1;
            p<="0111";
        elsif (q=1) then
            count10 <= countnum-count10000000-count1000000-count100000 -count10000 -count1000 -count100- cntmod10;
            q<=q+1;
            p<="0111";
        elsif (q=2) then
            vlue10 <= count10/10;
            q<=q+1;
            p<="0111";
        elsif (q=3) then
            countDIS10<=conv_STD_LOGIC_VECTOR(vlue10,4);
            q<=0;
            p<="1000";
        else 
            p<="0111";
        end if;
    when "1000"=>
        if (q=0) then
            cntmod1<=countnum mod 1;
            q<=q+1;
            p<="1000";
        elsif (q=1) then
            count1 <= countnum-count10000000-count1000000-count100000 -count10000 -count1000 -count100- count10;
            q<=q+1;
            p<="1000";
        elsif (q=2) then
            vlue1 <= count1;
            q<=q+1;
            p<="1000";
         elsif (q=3) then
            countDIS1<=conv_STD_LOGIC_VECTOR(vlue1,4);
            countDIS<='1';
            countDIS_reg<='1';
            q<=q+1;
            p<="1000";
        elsif (q=4) then
            q<=q+1;
--            p<=(others => '0');
            countDIS<='1';
            countDIS_reg<='1';
        elsif (q=5) then
            q<=0;
            p<=(others => '0');
            countDIS<='0';
            countDIS_reg<='0';
        end if;
    when others => p<="0000";
    end case;
 end if;

end process;

process (SO,DOUT0,DOUT1,DOUT2,DOUT3,countDIS_reg,countDIS10000000,countDIS1000000,countDIS100000,countDIS10000,countDIS1000,countDIS100,countDIS10,countDIS1) begin
if (SO='1') then
    SGIN0<="0000";
    SGIN1<="0000";
    SGIN2<="0000";
    SGIN3<="0000";
    SGIN4<=DOUT0;
    SGIN5<=DOUT1;
    SGIN6<=DOUT2;
    SGIN7<=DOUT3;
elsif (countDIS_reg'event and countDIS_reg = '1') then
    SGIN0<=countDIS10000000;
    SGIN1<=countDIS1000000;
    SGIN2<=countDIS100000;
    SGIN3<=countDIS10000; 
    SGIN4<=countDIS1000;
    SGIN5<=countDIS100;
    SGIN6<=countDIS10;
    SGIN7<=countDIS1;   
end if;
end process;


--set total counting time ms
process (SO,DOUT0,DOUT0,DOUT1,DOUT2,DOUT3,int1,int10,int100,int1000) begin
    if (SO='1') then
     --1000‚ÌˆÊ 
    int1000 <=  DOUT0 *"00000100110001001011010000000";
    --100‚ÌˆÊ 
    int100 <= DOUT1 * "00000000011110100001001000000" ;
    --10‚ÌˆÊ 
    int10 <=  DOUT2 * "00000000000011000011010100000";
    --1‚ÌˆÊ milisecond
    int1 <= "00000000000000010011100010000" * DOUT3;
    W<=int1+int10+int100+int1000;
    end if;
end process;


end Behavioral;