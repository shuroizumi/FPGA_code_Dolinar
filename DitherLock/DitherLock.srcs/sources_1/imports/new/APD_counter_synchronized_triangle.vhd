library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


--pulse length = clock(100MHz) * Maximum I
entity APD_counnter_synchronized_triangle is
  Port (sw : in std_logic;
       clk : in std_logic;
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


COMPONENT div_gen_7
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END COMPONENT;
--component integer_ASCII is 
-- port (ascii  : out std_logic_vector (7 downto 0);
--        int : in std_logic_vector (3 downto 0)
--       );
--end component;


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


signal s_axis_divisor_tvalid : std_logic :='0';
signal s_axis_divisor_tdata :  std_logic_vector  (23 DOWNTO 0):= (others => '0');
signal s_axis_dividend_tvalid : std_logic :='0';
signal s_axis_dividend_tdata:  std_logic_vector (39 DOWNTO 0):= (others => '0');
signal m_axis_dout_tvalid: std_logic :='0';
signal m_axis_dout_tdata :  std_logic_vector (63 DOWNTO 0):= (others => '0');

signal Vquotient :  std_logic_vector (32 DOWNTO 0):= (others => '0');
signal Vreminder :  std_logic_vector (23 DOWNTO 0):= (others => '0');
signal parityt  : integer;

signal APDcnt_reg : std_logic_vector (32 downto 0):= (others => '0');
begin


--iinteger_ASCII0: integer_ASCII port map(ascii=>ascii0 ,int=>countDIS10000000); 
--iinteger_ASCII1: integer_ASCII port map(ascii=>ascii1 ,int=>countDIS1000000);
--iinteger_ASCII2: integer_ASCII port map(ascii=>ascii2 ,int=>countDIS100000);  
--iinteger_ASCII3: integer_ASCII port map(ascii=>ascii3 ,int=>countDIS10000);  
--iinteger_ASCII4: integer_ASCII port map(ascii=>ascii4 ,int=>countDIS1000);  
--iinteger_ASCII5: integer_ASCII port map(ascii=>ascii5 ,int=>countDIS100);  
--iinteger_ASCII6: integer_ASCII port map(ascii=>ascii6 ,int=>countDIS10);  
--iinteger_ASCII7: integer_ASCII port map(ascii=>ascii7 ,int=>countDIS1);  

idiv_gen_7: div_gen_7
  PORT MAP (
    aclk => clk,
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => s_axis_divisor_tdata,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => s_axis_dividend_tdata,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tdata => m_axis_dout_tdata
  );

process (sw,clk,Run,update) begin    
    if (sw='1') then
        cnt<= (others => '0');
        cntdone<='0';
        startconv<='0';
        stageAPD<=(others => '0');
        rest<='0';
    else
         if (clk'event and clk = '1') then         
            case stageAPD is
            when "000" =>
                cntdone<='0';
                if (update='1' and Run='1') then
                    stageAPD<="001";
                    phiAPDreg<=phiAPDin;
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
                   APDcnt_reg<=cnt;
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
                     APDcnt_reg<=cnt2;
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




----To show count on the 7-segment display
--process (clk_out,startconv) begin
--if (clk_out'event and clk_out = '1') then
--case p is
--    when  "0000" =>
--        if (startconv='1') then   
--            p<="0001";
--        else
--            p<="0000";
--        end if;
--    when  "0001" =>
--        if (q=10) then
--            cntmod10000000<=countnum mod 10000000;
--            q<=q+1;
--            p<="0001";
--        elsif (q=11) then
--            count10000000 <= countnum - cntmod10000000;
--            q<=q+1;
--            p<="0001";
--        elsif (q=12) then
--            vlue10000000 <= count10000000/10000000;
--            q<=q+1;
--            p<="0001"; 
--        elsif (q=13) then
--            countDIS10000000<=conv_STD_LOGIC_VECTOR(vlue10000000,4);
--            q<=0;
--            p<="0010";
--        else
--            q<=q+1;
--            p<="0001"; 
--        end if;  
--   when "0010" =>
--        if (q=10) then
--            cntmod1000000<=countnum mod 1000000;
--            q<=q+1;
--            p<="0010";
--        elsif (q=11) then
--            count1000000 <= countnum- count10000000- cntmod1000000;
--            q<=q+1;
--            p<="0010";
--        elsif (q=12) then
--            vlue1000000 <= count1000000/1000000;
--            q<=q+1;
--            p<="0010";
--        elsif (q=13) then
--            countDIS1000000<=conv_STD_LOGIC_VECTOR(vlue1000000,4);
--            q<=0;
--            p<="0011";
--        else 
--            p<="0010";
--            q<=q+1; 
--        end if;  
--    when "0011" =>
--        if (q=0) then
--            countDIS<='0';
--            cntmod100000<=countnum mod 100000;
--            q<=q+1;
--            p<="0011";
--        elsif (q=1) then
--            count100000 <= countnum-count10000000-count1000000 - cntmod100000;
--            q<=q+1;
--            p<="0011";
--        elsif (q=2) then
--            vlue100000 <= count100000/100000;
--            q<=q+1;
--            p<="0011";
--        elsif (q=3) then
----            led(15 downto 12) <=conv_STD_LOGIC_VECTOR(vlue100000,4);
--            countDIS100000<=conv_STD_LOGIC_VECTOR(vlue100000,4);
--            q<=0;
--            p<="0100";
--        else
--            p<="0011";
--        end if;
--     when "0100" => 
--        if (q=0) then
--            cntmod10000<=countnum mod 10000;
--            q<=q+1;
--             p<="0100";
--        elsif (q=1) then
--            count10000 <= countnum-count10000000-count1000000-count100000 - cntmod10000;
--            q<=q+1;
--             p<="0100";
--        elsif (q=2) then
--            vlue10000 <= count10000/10000;
--            q<=q+1;
--            p<="0100";
--        elsif (q=3) then
--            countDIS10000<=conv_STD_LOGIC_VECTOR(vlue10000,4);
--            q<=0;
--            p<="0101";
--        else
--            p<="0100";
--        end if;  
--    when  "0101" => 
--        if (q=0) then
--            cntmod1000<=countnum mod 1000;
--            q<=q+1;
--            p<="0101";
--        elsif (q=1) then
--            count1000 <= countnum-count10000000-count1000000 -count100000 -count10000- cntmod1000;
--            q<=q+1;
--            p<="0101";
--        elsif (q=2) then
--            vlue1000 <= count1000/1000;
--            q<=q+1;
--            p<="0101";
--        elsif (q=3) then
----            led(7 downto 4) <=conv_STD_LOGIC_VECTOR(vlue1000,4);
--             countDIS1000<=conv_STD_LOGIC_VECTOR(vlue1000,4);
--            q<=0;
--            p<="0110";
--        else 
--            p<="0101";
--        end if;
--    when "0110"=>
--        if (q=0) then
--            cntmod100<=countnum mod 100;
--            q<=q+1;
--            p<="0110";
--        elsif (q=1) then
--            count100 <= countnum-count10000000-count1000000-count100000 -count10000 -count1000- cntmod100;
--            q<=q+1;
--            p<="0110";
--        elsif (q=2) then
--            vlue100 <= count100/100;
--            q<=q+1;
--            p<="0110";
--        elsif (q=3) then
----            led(3 downto 0) <=conv_STD_LOGIC_VECTOR(vlue100,4);
--            countDIS100<=conv_STD_LOGIC_VECTOR(vlue100,4);
--            q<=0;
--            p<="0111";
--        else 
--            p<="0110";
--        end if; 
--    when    "0111"=>
--        if (q=0) then
--            cntmod10<=countnum mod 10;
--            q<=q+1;
--            p<="0111";
--        elsif (q=1) then
--            count10 <= countnum-count10000000-count1000000-count100000 -count10000 -count1000 -count100- cntmod10;
--            q<=q+1;
--            p<="0111";
--        elsif (q=2) then
--            vlue10 <= count10/10;
--            q<=q+1;
--            p<="0111";
--        elsif (q=3) then
--            countDIS10<=conv_STD_LOGIC_VECTOR(vlue10,4);
--            q<=0;
--            p<="1000";
--        else 
--            p<="0111";
--        end if;
--    when "1000"=>
--        if (q=0) then
--            cntmod1<=countnum mod 1;
--            q<=q+1;
--            p<="1000";
--        elsif (q=1) then
--            count1 <= countnum-count10000000-count1000000-count100000 -count10000 -count1000 -count100- count10;
--            q<=q+1;
--            p<="1000";
--        elsif (q=2) then
--            vlue1 <= count1;
--            q<=q+1;
--            p<="1000";
--         elsif (q=3) then
--            countDIS1<=conv_STD_LOGIC_VECTOR(vlue1,4);
--            countDIS<='1';
--            countDIS_reg<='1';
--            q<=q+1;
--            p<="1000";
--        elsif (q=4) then
--            q<=0;
--            p<=(others => '0');
--            countDIS<='0';
--            countDIS_reg<='0';    
--         else
--            q<=q+1;
--        end if;
--    when others => p<="0000";
--    end case;
-- end if;
--end process;





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
        case parityt is 
        when 0 =>  s_axis_divisor_tdata<="100110001001011010000000";  
                   s_axis_dividend_tdata<="0000000"&APDcnt_reg;   
        when 1 =>  s_axis_divisor_tdata<="000011110100001001000000";  
                   s_axis_dividend_tdata<="0000000000000000"&Vreminder;   
        when 2 =>  s_axis_divisor_tdata<="000000011000011010100000";  
                   s_axis_dividend_tdata<="0000000000000000"&Vreminder;   
        when 3 =>  s_axis_divisor_tdata<="000000000010011100010000";  
                   s_axis_dividend_tdata<="0000000000000000"&Vreminder;   
        when 4 =>  s_axis_divisor_tdata<="000000000000001111101000";  
                   s_axis_dividend_tdata<="0000000000000000"&Vreminder;   
        when 5 =>  s_axis_divisor_tdata<="000000000000000001100100";  
                   s_axis_dividend_tdata<="0000000000000000"&Vreminder; 
        when 6 =>  s_axis_divisor_tdata<="000000000000000000001010";  
                   s_axis_dividend_tdata<="0000000000000000"&Vreminder;
        when 7 =>  s_axis_divisor_tdata<="000000000000000000000001";  
                   s_axis_dividend_tdata<="0000000000000000"&Vreminder; 
        when others => s_axis_divisor_tdata <="000000000000000000000001";
        end case;   
        p<=p+1;
    when  "0010" =>
        s_axis_divisor_tvalid<='1';
        s_axis_dividend_tvalid<='1';
        p<=p+1;
  when  "0011" =>  
        if (m_axis_dout_tvalid='1') then
             s_axis_divisor_tvalid<='0';
             s_axis_dividend_tvalid<='0';
             p<=p+1;
        end if;    
   when "0100" => 
         if (m_axis_dout_tvalid='0') then
             Vquotient <=m_axis_dout_tdata(56 downto 24);
             Vreminder <=m_axis_dout_tdata(23 downto 0);
             p<=p+1;
         end if; 
   when "0101" => 
        case parityt is 
        when 0 => countDIS10000000<= Vquotient (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 1 => countDIS1000000<= Vquotient (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 2 => countDIS100000<= Vquotient (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 3 => countDIS10000<= Vquotient (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 4 => countDIS1000<= Vquotient (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 5 => countDIS100<= Vquotient (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 6 => countDIS10<= Vquotient (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 7 => countDIS1<= Vquotient (3 downto 0);
                  parityt<=0;
                  p<=p+1;
        when others =>   parityt<=0;  
                         p<="0000"; 
        end case;                          
    when "0110" =>
       case countDIS10000000 is 
            when "0000" => ascii0 <="00110000";
            when  "0001"=> ascii0 <="00110001";
            when  "0010"=> ascii0 <="00110010";
            when  "0011"=> ascii0 <="00110011";
            when  "0100"=> ascii0 <="00110100";
            when  "0101"=> ascii0 <="00110101";
            when  "0110"=> ascii0 <="00110110";
            when  "0111"=> ascii0 <="00110111";
            when  "1000"=> ascii0 <="00111000";
            when  "1001"=> ascii0 <="00111001";
            when others => ascii0 <="00110000";
       end case;

       case countDIS1000000 is 
           when "0000" => ascii1 <="00110000";
           when  "0001"=> ascii1 <="00110001";
           when  "0010"=> ascii1 <="00110010";
           when  "0011"=> ascii1 <="00110011";
           when  "0100"=> ascii1 <="00110100";
           when  "0101"=> ascii1 <="00110101";
           when  "0110"=> ascii1 <="00110110";
           when  "0111"=> ascii1 <="00110111";
           when  "1000"=> ascii1 <="00111000";
           when  "1001"=> ascii1 <="00111001";
           when others => ascii1 <="00110000";
       end case;


       case countDIS100000 is 
           when "0000" => ascii2 <="00110000";
           when  "0001"=> ascii2 <="00110001";
           when  "0010"=> ascii2 <="00110010";
           when  "0011"=> ascii2 <="00110011";
           when  "0100"=> ascii2 <="00110100";
           when  "0101"=> ascii2 <="00110101";
           when  "0110"=> ascii2 <="00110110";
           when  "0111"=> ascii2 <="00110111";
           when  "1000"=> ascii2 <="00111000";
           when  "1001"=> ascii2 <="00111001";
           when others => ascii2 <="00110000";
       end case;


       case countDIS10000 is 
           when "0000" => ascii3 <="00110000";
           when  "0001"=> ascii3 <="00110001";
           when  "0010"=> ascii3 <="00110010";
           when  "0011"=> ascii3 <="00110011";
           when  "0100"=> ascii3 <="00110100";
           when  "0101"=> ascii3 <="00110101";
           when  "0110"=> ascii3 <="00110110";
           when  "0111"=> ascii3 <="00110111";
           when  "1000"=> ascii3 <="00111000";
           when  "1001"=> ascii3 <="00111001";
           when others => ascii3 <="00110000";
       end case;




       case countDIS1000 is 
       when "0000" => ascii4 <="00110000";
       when  "0001"=> ascii4 <="00110001";
       when  "0010"=> ascii4 <="00110010";
       when  "0011"=> ascii4 <="00110011";
       when  "0100"=> ascii4 <="00110100";
       when  "0101"=> ascii4 <="00110101";
       when  "0110"=> ascii4 <="00110110";
       when  "0111"=> ascii4 <="00110111";
       when  "1000"=> ascii4 <="00111000";
       when  "1001"=> ascii4 <="00111001";
       when others => ascii4 <="00110000";
       end case;
   
   
       case countDIS100 is 
       when "0000" => ascii5 <="00110000";
       when  "0001"=> ascii5 <="00110001";
       when  "0010"=> ascii5 <="00110010";
       when  "0011"=> ascii5 <="00110011";
       when  "0100"=> ascii5 <="00110100";
       when  "0101"=> ascii5 <="00110101";
       when  "0110"=> ascii5 <="00110110";
       when  "0111"=> ascii5 <="00110111";
       when  "1000"=> ascii5 <="00111000";
       when  "1001"=> ascii5 <="00111001";
       when others => ascii5 <="00110000";
       end case;
       
       case countDIS10 is 
       when "0000" => ascii6 <="00110000";
       when  "0001"=> ascii6 <="00110001";
       when  "0010"=> ascii6 <="00110010";
       when  "0011"=> ascii6 <="00110011";
       when  "0100"=> ascii6 <="00110100";
       when  "0101"=> ascii6 <="00110101";
       when  "0110"=> ascii6 <="00110110";
       when  "0111"=> ascii6 <="00110111";
       when  "1000"=> ascii6 <="00111000";
       when  "1001"=> ascii6 <="00111001";
       when others => ascii6<="00110000";
       end case;
       
       case countDIS1 is 
       when "0000" => ascii7 <="00110000";
       when  "0001"=> ascii7 <="00110001";
       when  "0010"=> ascii7 <="00110010";
       when  "0011"=> ascii7 <="00110011";
       when  "0100"=> ascii7 <="00110100";
       when  "0101"=> ascii7 <="00110101";
       when  "0110"=> ascii7 <="00110110";
       when  "0111"=> ascii7 <="00110111";
       when  "1000"=> ascii7 <="00111000";
       when  "1001"=> ascii7 <="00111001";
       when others => ascii7<="00110000";
       end case;
       p<=p+1;
    when "0111" =>
       countDIS<='1';
       countDIS_reg<='1';
       p<=p+1;
    when "1000" =>
       p<=p+1;
    when "1001" => 
      countDIS<='0';
      countDIS_reg<='0';
      p<=p+1;
    when "1010" =>
        p<="0000";
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