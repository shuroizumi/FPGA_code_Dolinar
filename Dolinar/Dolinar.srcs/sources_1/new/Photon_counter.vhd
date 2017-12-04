library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.numeric_std.ALL;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--Count signal from photon counter
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--pulse length = clock(100MHz) * Maximum I
entity Photon_counter is
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
       cntdone: out  std_logic;
       countDIS: out  std_logic;
       finconv: in  std_logic;
       lockmode: in  std_logic;
       APDtimeset : in  std_logic :='0'; 
       WAPDtimeset: in std_logic_vector (32 downto 0):= (others => '0')
               );
end Photon_counter;
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
architecture Behavioral of Photon_counter is


component integer_ASCII is 
 port (ascii  : out std_logic_vector (7 downto 0);
        int : in std_logic_vector (3 downto 0)
       );
end component;


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

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
signal I : std_logic_vector(32 downto 0):= (others => '0');
signal j : std_logic_vector(6 downto 0):= (others => '0');

signal countnum : integer;
signal cnt : std_logic_vector(32 downto 0):= (others => '0');




signal countDIS10000000: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS1000000: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS100000: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS10000: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS1000: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS100: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS10: std_logic_vector (3 downto 0):= (others => '0');
signal countDIS1: std_logic_vector (3 downto 0):= (others => '0');

signal p  : std_logic_vector (3 downto 0):= (others => '0');

signal startconv: std_logic :='0';
signal countDIS_reg: std_logic :='0';
signal stage: std_logic_vector (3 downto 0):= (others => '0');

signal rest: std_logic :='0';
signal step: std_logic :='0';


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
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
begin

idiv_gen_7 : div_gen_7
  PORT MAP (
    aclk => clk,
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tdata => s_axis_divisor_tdata,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tdata => s_axis_dividend_tdata,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tdata => m_axis_dout_tdata
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
startconversion<=countDIS_reg;



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
                    if (I <=  WAPDtimeset-2) then
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
                    
                    
                elsif (I = WAPDtimeset-1) then
                    if (j=10) then
                       countnum<=CONV_INTEGER(unsigned(cnt)); 
                       APDcnt_reg<=cnt;
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
                               
                       startconv<='0';
                       if (finconv='1') then     
                          I<= (others => '0');
                          j<= (others => '0');  
                          cntdone<='0';     
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