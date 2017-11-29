library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


--pulse length = clock(100MHz) * Maximum I
entity APD_counnter_synchronized_triangle is
  Port (sw : in std_logic;
       clk_out : in std_logic;
       JB: in  std_logic;
       APDcnt : out std_logic_vector (32 downto 0):= (others => '0');
       cntdone: out  std_logic;
       update: in  std_logic;
       phiAPDin : in  std_logic_vector (7 downto 0);
       phiAPDout : out  std_logic_vector (7 downto 0);
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
       countDIS: out std_logic
               );
end APD_counnter_synchronized_triangle;

architecture Behavioral of APD_counnter_synchronized_triangle is


component integer_ASCII is 
 port (ascii  : out std_logic_vector (7 downto 0);
        int : in std_logic_vector (3 downto 0)
       );
end component;


signal cnt : std_logic_vector(32 downto 0):= (others => '0');
signal cnt2 : std_logic_vector(32 downto 0):= (others => '0');
signal stageAPD: std_logic_vector (2 downto 0):= (others => '0');
signal phiAPDreg: std_logic_vector (7 downto 0);
signal phiAPDreg2: std_logic_vector (7 downto 0);



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
signal countnum : integer;

signal countDIS_reg: std_logic :='0'; 

signal rest: std_logic :='0';


begin


iinteger_ASCII0: integer_ASCII port map(ascii=>ascii0 ,int=>countDIS10000000); 
iinteger_ASCII1: integer_ASCII port map(ascii=>ascii1 ,int=>countDIS1000000);
iinteger_ASCII2: integer_ASCII port map(ascii=>ascii2 ,int=>countDIS100000);  
iinteger_ASCII3: integer_ASCII port map(ascii=>ascii3 ,int=>countDIS10000);  
iinteger_ASCII4: integer_ASCII port map(ascii=>ascii4 ,int=>countDIS1000);  
iinteger_ASCII5: integer_ASCII port map(ascii=>ascii5 ,int=>countDIS100);  
iinteger_ASCII6: integer_ASCII port map(ascii=>ascii6 ,int=>countDIS10);  
iinteger_ASCII7: integer_ASCII port map(ascii=>ascii7 ,int=>countDIS1);  


--process (sw,clk_out,Run,update) begin    
--    if (sw='1') then
--        cnt<= (others => '0');
--        cntdone<='0';
--        startconv<='0';
--        stageAPD<=(others => '0');
--    else
--         if (clk_out'event and clk_out = '1') then         
--            case stageAPD is
--            when "000" =>
--                cntdone<='0';
--                if (update='1' and Run='1') then
--                    stageAPD<="001";
--                    phiAPDreg<=phiAPDin;
--                    cntdone<='0';
--                    startconv<='0';
--                    cnt<=cnt+JB;
--                else
--                    stageAPD<="000";
--                end if;
--            when "001" =>
--                if (update='0') then
--                   cntdone<='0';
--                   startconv<='0';
--                   cnt<=cnt+JB;
--                else
--                   APDcnt<=cnt;
--                   countnum<=CONV_INTEGER(unsigned(cnt)); 
--                   cnt<= (others => '0');
--                   cnt2<=cnt2+JB;
--                   cntdone<='1';
--                   startconv<='1';
--                   phiAPDout<=phiAPDreg;
--                   phiAPDreg2<=phiAPDin;
--                   stageAPD<="010";
--                end if;
--            when "010" =>
--                 if (update='0') then
--                     cntdone<='0';
--                     startconv<='0';
--                     cnt2<=cnt2+JB;
--                  else
--                     APDcnt<=cnt2;
--                     countnum<=CONV_INTEGER(unsigned(cnt2)); 
--                     cnt2<= (others => '0');
--                     cnt<=cnt+JB;
--                     cntdone<='1';
--                     startconv<='1';
--                     phiAPDout<=phiAPDreg2;
--                     phiAPDreg<=phiAPDin;
--                     stageAPD<="001";
--                  end if;
--            when others => stageAPD<=(others => '0');
--            end case; 
--         end if; 
--        end if;
--end process;


process (sw,clk_out,Run,update) begin    
    if (sw='1') then
        cnt<= (others => '0');
        cntdone<='0';
        startconv<='0';
        stageAPD<=(others => '0');
        rest<='0';
    else
         if (clk_out'event and clk_out = '1') then         
            case stageAPD is
            when "000" =>
                cntdone<='0';
                if (update='1' and Run='1') then
                    stageAPD<="001";
                    phiAPDreg<=phiAPDin;
                    cntdone<='0';
                    startconv<='0';
                    if (rest='0') then
                        if (JB='1') then
                            rest<='1';
                        else
                            rest<='0';
                        end if;
                        cnt<=cnt+JB;
                   else
                       rest<='0';
                   end if;
                else
                    stageAPD<="000";
                end if;
            when "001" =>
                if (update='0') then
                   cntdone<='0';
                   startconv<='0';
                    if (rest='0') then
                        if (JB='1') then
                            rest<='1';
                        else
                            rest<='0';
                        end if;
                        cnt<=cnt+JB;
                   else
                       rest<='0';
                   end if;
                else
                   APDcnt<=cnt;
                   countnum<=CONV_INTEGER(unsigned(cnt)); 
                   cnt<= (others => '0');
                   if (rest='0') then
                       if (JB='1') then
                           rest<='1';
                       else
                           rest<='0';
                       end if;
                       cnt2<=cnt2+JB;
                  else
                      rest<='0';
                  end if;
                   cntdone<='1';
                   startconv<='1';
                   phiAPDout<=phiAPDreg;
                   phiAPDreg2<=phiAPDin;
                   stageAPD<="010";
                end if;
            when "010" =>
                 if (update='0') then
                     cntdone<='0';
                     startconv<='0';
                   if (rest='0') then
                         if (JB='1') then
                             rest<='1';
                         else
                             rest<='0';
                         end if;
                         cnt2<=cnt2+JB;
                    else
                        rest<='0';
                    end if;
                  else
                     APDcnt<=cnt2;
                     countnum<=CONV_INTEGER(unsigned(cnt2)); 
                     cnt2<= (others => '0');
                   if (rest='0') then
                         if (JB='1') then
                             rest<='1';
                         else
                             rest<='0';
                         end if;
                         cnt<=cnt+JB;
                    else
                        rest<='0';
                    end if;
                     cntdone<='1';
                     startconv<='1';
                     phiAPDout<=phiAPDreg2;
                     phiAPDreg<=phiAPDin;
                     stageAPD<="001";
                  end if;
            when others => stageAPD<=(others => '0');
            end case; 
         end if; 
        end if;
end process;




--To show count on the 7-segment display
process (clk_out,startconv) begin
if (clk_out'event and clk_out = '1') then
case p is
    when  "0000" =>
        if (startconv='1') then   
            p<="0001";
        else
            p<="0000";
        end if;
    when  "0001" =>
        if (q=10) then
            cntmod10000000<=countnum mod 10000000;
            q<=q+1;
            p<="0001";
        elsif (q=11) then
            count10000000 <= countnum - cntmod10000000;
            q<=q+1;
            p<="0001";
        elsif (q=12) then
            vlue10000000 <= count10000000/10000000;
            q<=q+1;
            p<="0001"; 
        elsif (q=13) then
            countDIS10000000<=conv_STD_LOGIC_VECTOR(vlue10000000,4);
            q<=0;
            p<="0010";
        else
            q<=q+1;
            p<="0001"; 
        end if;  
   when "0010" =>
        if (q=10) then
            cntmod1000000<=countnum mod 1000000;
            q<=q+1;
            p<="0010";
        elsif (q=11) then
            count1000000 <= countnum- count10000000- cntmod1000000;
            q<=q+1;
            p<="0010";
        elsif (q=12) then
            vlue1000000 <= count1000000/1000000;
            q<=q+1;
            p<="0010";
        elsif (q=13) then
            countDIS1000000<=conv_STD_LOGIC_VECTOR(vlue1000000,4);
            q<=0;
            p<="0011";
        else 
            p<="0010";
            q<=q+1; 
        end if;  
    when "0011" =>
        if (q=0) then
            countDIS<='0';
            cntmod100000<=countnum mod 100000;
            q<=q+1;
            p<="0011";
        elsif (q=1) then
            count100000 <= countnum-count10000000-count1000000 - cntmod100000;
            q<=q+1;
            p<="0011";
        elsif (q=2) then
            vlue100000 <= count100000/100000;
            q<=q+1;
            p<="0011";
        elsif (q=3) then
--            led(15 downto 12) <=conv_STD_LOGIC_VECTOR(vlue100000,4);
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
             p<="0100";
        elsif (q=1) then
            count10000 <= countnum-count10000000-count1000000-count100000 - cntmod10000;
            q<=q+1;
             p<="0100";
        elsif (q=2) then
            vlue10000 <= count10000/10000;
            q<=q+1;
            p<="0100";
        elsif (q=3) then
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
            p<="0101";
        elsif (q=1) then
            count1000 <= countnum-count10000000-count1000000 -count100000 -count10000- cntmod1000;
            q<=q+1;
            p<="0101";
        elsif (q=2) then
            vlue1000 <= count1000/1000;
            q<=q+1;
            p<="0101";
        elsif (q=3) then
--            led(7 downto 4) <=conv_STD_LOGIC_VECTOR(vlue1000,4);
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
--            led(3 downto 0) <=conv_STD_LOGIC_VECTOR(vlue100,4);
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
            q<=0;
            p<=(others => '0');
            countDIS<='0';
            countDIS_reg<='0';    
         else
            q<=q+1;
        end if;
    when others => p<="0000";
    end case;
 end if;
end process;


process (countDIS_reg,countDIS10000000,countDIS1000000,countDIS100000,countDIS10000,countDIS1000,countDIS100,countDIS10,countDIS1) begin
if (countDIS_reg'event and countDIS_reg = '1') then
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









end Behavioral;