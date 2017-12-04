library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.numeric_std.ALL;

PACKAGE heap_arr_pkg IS
    type timesegment2 is array (0 to 10) of std_logic_vector (32 downto 0);
END; 

USE work.heap_arr_pkg.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--Count signal from photon counter and implement feedback operation depending on measurement results
--This module is used to acquire experimental data
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

entity Photon_counter_measurement is
  Port (sw : in std_logic_vector (3 downto 0);
       led: out  std_logic_vector (15 downto 0);
       clk : in std_logic;
       clk_out : in std_logic;
       JB: in  std_logic;
       JD: out  std_logic_vector (7 downto 4);
       RsRx : in  std_logic;
       Run : in  std_logic;
       ascii0: out std_logic_vector (7 downto 0);
       ascii1: out std_logic_vector (7 downto 0);
       ascii2: out std_logic_vector (7 downto 0);
       ascii3: out std_logic_vector (7 downto 0);
       ascii4: out std_logic_vector (7 downto 0);
       ascii5: out std_logic_vector (7 downto 0);
       ascii6: out std_logic_vector (7 downto 0);
       ascii7: out std_logic_vector (7 downto 0);
       datasent: in  std_logic;
       countDISbin: out  std_logic;
       ampdis : out std_logic_vector (15 downto 0);
       ampdisdef : in std_logic_vector (15 downto 0);
       ampdison : in std_logic_vector (15 downto 0);
       ampdisoff : in std_logic_vector (15 downto 0);
       changeamp: out  std_logic;
       finconvAMPMOD : in  std_logic;
       clkPmod : in std_logic;
       timesegment : in timesegment2;
       Voutzero : in std_logic_vector (15 downto 0);
       Voutpi : in std_logic_vector (15 downto 0);
       minokrun: in std_logic_vector (32 downto 0):= "000000000000000000000001111101000";
       maxokrun: in std_logic_vector (32 downto 0):= "000000000000000000000001111101000";
       maxindex_int : in integer
               );
end Photon_counter_measurement;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
architecture Behavioral of Photon_counter_measurement is




COMPONENT DA_Pmod_feed
  Port (
      clkPmod : in std_logic;
      clk_out : in std_logic;
      JDPmod : out std_logic_vector (7 downto 4);
      analogbit : in std_logic_vector (15 downto 0);
      updateana : in std_logic:='0';
      finconv : out std_logic:='0'
      );
END COMPONENT;


------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT div_gen_3
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT div_gen_6
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

------------------------------------------------------------------------------------------------
signal I : std_logic_vector(32 downto 0):= (others => '0');
signal binchange : std_logic_vector(32 downto 0):= (others => '0');
signal j : std_logic_vector(50 downto 0):= (others => '0');
signal cnt : std_logic_vector(32 downto 0):= (others => '0');
signal cnt2 : std_logic_vector(32 downto 0):= (others => '0');
signal okrun: std_logic_vector (32 downto 0):= "000000000000000000000001111101000";

signal p  : std_logic_vector (3 downto 0):= (others => '0');
signal q  : natural;
signal startconv: std_logic :='0';
signal psipluscountDIS1000: std_logic_vector (3 downto 0):= (others => '0');
signal psipluscountDIS100: std_logic_vector (3 downto 0):= (others => '0');
signal psipluscountDIS10: std_logic_vector (3 downto 0):= (others => '0');
signal psipluscountDIS1: std_logic_vector (3 downto 0):= (others => '0');
signal psiminuscountDIS1000: std_logic_vector (3 downto 0):= (others => '0');
signal psiminuscountDIS100: std_logic_vector (3 downto 0):= (others => '0');
signal psiminuscountDIS10: std_logic_vector (3 downto 0):= (others => '0');
signal psiminuscountDIS1: std_logic_vector (3 downto 0):= (others => '0');


signal analogbit : std_logic_vector (15 downto 0);
signal finconv : std_logic:='0';
signal changeamp_reg : std_logic;
signal change_phase : std_logic;
signal parity : std_logic;



signal index : integer range 0 to 15;
signal index2 : integer range 0 to 15;
signal maxindex : std_logic_vector (10 downto 0);
signal cntresult : std_logic_vector (10 downto 0):= (others => '0');


signal cnt00000000000:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000001:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000010:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000011:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000100:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000101:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000110:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000000111:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001000:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001001:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001010:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001011:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001100:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001101:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001110:std_logic_vector (15 downto 0):= (others => '0');
signal cnt00000001111:std_logic_vector (15 downto 0):= (others => '0');
signal cnt11111111111:std_logic_vector (15 downto 0):= (others => '0');

signal transdata0:std_logic_vector (15 downto 0):= (others => '0');
signal transdata1:std_logic_vector (15 downto 0):= (others => '0');

signal psiplus:std_logic_vector (15 downto 0):= (others => '0');
signal psiminus:std_logic_vector (15 downto 0):= (others => '0');
signal s_axis_divisor_tvalid_div3 : std_logic :='0';
signal s_axis_divisor_tdata_div3 :  std_logic_vector  (15 downto 0):= (others => '0');
signal s_axis_dividend_tvalid_div3 : std_logic :='0';
signal s_axis_dividend_tdata_div3:  std_logic_vector  (15 downto 0):= (others => '0');
signal m_axis_dout_tvalid_div3: std_logic :='0';
signal m_axis_dout_tdata_div3 :  std_logic_vector  (31 downto 0):= (others => '0');
signal Vquotient_div3 : std_logic_vector (13 downto 0);
signal Vreminder_div3 : std_logic_vector (9 downto 0);
signal parityt  : integer;
signal paritytt  : integer;
signal s_axis_divisor_tvalid_div3_2 : std_logic :='0';
signal s_axis_divisor_tdata_div3_2 :  std_logic_vector  (15 downto 0):= (others => '0');
signal s_axis_dividend_tvalid_div3_2 : std_logic :='0';
signal s_axis_dividend_tdata_div3_2:  std_logic_vector  (15 downto 0):= (others => '0');
signal m_axis_dout_tvalid_div3_2: std_logic :='0';
signal m_axis_dout_tdata_div3_2 :  std_logic_vector  (31 downto 0):= (others => '0');
signal Vquotient_div3_2 : std_logic_vector (13 downto 0);
signal Vreminder_div3_2 : std_logic_vector (9 downto 0);
signal pp  : std_logic_vector (3 downto 0):= (others => '0');

signal y :  std_logic:='0';
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
begin

  
--iDA_Pmod_feed: DA_Pmod_feed port map(
--     clkPmod=>clkPmod,
--     clk_out=>clk_out,
--     JDPmod=>JD,
--     analogbit=>analogbit,
--     updateana=>change_phase,
--     finconv=>finconv);
     
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
idiv_gen_3 : div_gen_3
PORT MAP (
 aclk => clk,
 s_axis_divisor_tvalid => s_axis_divisor_tvalid_div3,
 s_axis_divisor_tdata => s_axis_divisor_tdata_div3,
 s_axis_dividend_tvalid => s_axis_dividend_tvalid_div3,
 s_axis_dividend_tdata => s_axis_dividend_tdata_div3,
 m_axis_dout_tvalid => m_axis_dout_tvalid_div3,
 m_axis_dout_tdata => m_axis_dout_tdata_div3
);
-- INST_TAG_END ------ End INSTANTIATION Template ---------

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
idiv_gen_6 : div_gen_6
PORT MAP (
 aclk => clk,
 s_axis_divisor_tvalid => s_axis_divisor_tvalid_div3_2,
 s_axis_divisor_tdata => s_axis_divisor_tdata_div3_2,
 s_axis_dividend_tvalid => s_axis_dividend_tvalid_div3_2,
 s_axis_dividend_tdata => s_axis_dividend_tdata_div3_2,
 m_axis_dout_tvalid => m_axis_dout_tvalid_div3_2,
 m_axis_dout_tdata => m_axis_dout_tdata_div3_2
);
-- INST_TAG_END ------ End INSTANTIATION Template ---------

---------------------------------------------------------------------------
-----------------------



process (sw(0),clk_out,Run,ampdisdef) begin   
if ( clk_out'event and clk_out = '1') then
    if (sw(0)='1') then
        j<= (others => '0');
        cnt<= (others => '0');
        cnt2<= (others => '0');
        I<= (others => '0'); 
        analogbit<=(others => '0');
        ampdis<=ampdisdef;
        changeamp_reg<='0';
        okrun<= (others => '0');
        startconv<='0';
        parity <= '0';
        index<= 0;
        index2<= 0;
        cntresult<= (others => '0');  
        psiplus<=(others => '0'); 
        psiminus<=(others => '0'); 
        cnt00000000000<=(others => '0');
        cnt00000000001<=(others => '0');
        cnt00000000010<=(others => '0');
        cnt00000000011<=(others => '0');
        cnt00000000100<=(others => '0');
        cnt00000000101<=(others => '0');
        cnt00000000110<=(others => '0');
        cnt00000000111<=(others => '0');
        cnt00000001000<=(others => '0');
        cnt00000001001<=(others => '0');
        cnt00000001010<=(others => '0');
        cnt00000001011<=(others => '0');
        cnt00000001100<=(others => '0');
        cnt00000001101<=(others => '0');        
        cnt00000001110<=(others => '0');        
        cnt00000001111<=(others => '0');        
        cnt11111111111<=(others => '0');
        binchange<=timesegment(0);
        JD(7)<='0';
    else 
            if (Run='1') then
              if (index=maxindex_int) then
               if (j=0) then
                j<=j+1; 
                ampdis<=ampdisdef;
                changeamp_reg<='1';
                analogbit<= Voutzero; 
                JD(7)<='0';
                y<='0';
               elsif (j=1) then
                cnt<= (others => '0'); 
                cnt2<= (others => '0'); 
                startconv<='0'; 
--                if (finconvAMPMOD='1') then
                    if (maxokrun>=okrun and okrun>=minokrun) then
                    case  cntresult is 
                        when "00000000000"=>
                            cnt00000000000<=cnt00000000000+1;
                        when "00000000001"=>
                            cnt00000000001<=cnt00000000001+1;
                        when "00000000010"=>
                            cnt00000000010<=cnt00000000010+1;
                        when "00000000011"=>
                            cnt00000000011<=cnt00000000011+1;
                        when "00000000100"=>
                            cnt00000000100<=cnt00000000100+1;
                        when "00000000101"=>
                            cnt00000000101<=cnt00000000101+1;
                        when "00000000110"=>
                            cnt00000000110<=cnt00000000110+1;             
                        when "00000000111"=>
                            cnt00000000111<=cnt00000000111+1;
                        when "00000001000"=>
                            cnt00000001000<=cnt00000001000+1;                
                        when "00000001001"=>
                            cnt00000001001<=cnt00000001001+1;                
                        when "00000001010"=>
                            cnt00000001010<=cnt00000001010+1;
                        when "00000001011"=>
                            cnt00000001011<=cnt00000001011+1;
                        when "00000001100"=>
                            cnt00000001100<=cnt00000001100+1;
                        when "00000001101"=>
                            cnt00000001101<=cnt00000001101+1;    
                        when "00000001110"=>
                            cnt00000001110<=cnt00000001110+1;
                        when "00000001111"=>
                            cnt00000001111<=cnt00000001111+1;      
                        when others => 
                            cnt11111111111<=cnt11111111111+1;                 
                        end case;
                   end if;     
                    j<=j+1;
                    changeamp_reg<='0'; 
                    led(0)<='1';
--                end if;
              elsif (j=2) then
                  cntresult<= (others => '0');
                   j<=j+1;
                  if (okrun=2000) then
                      startconv<='1';
                      okrun<=okrun+1;  
                      led(0)<='1';

                  elsif (okrun>maxokrun and okrun<2000) then  
                      okrun<=okrun+1;  
                  elsif (minokrun>=okrun) then
                      okrun<=okrun+1;  
                  else
                      okrun<=okrun+1;
                      if (parity ='0') then
                         psiplus<=psiplus+1;
                       else    
                         psiminus<=psiminus+1;
                       end if;

--                      j<=j+1;
                  end if;   
             elsif (j=3) then
                   parity<='0';
                   startconv<='0'; 
                   binchange<=timesegment(0);
                  if (okrun=2001) then
                       j<=j;
                       led(0)<='0';
                  else     
                       j<=j+1;    
                  end if;          
               elsif (j=20000) then
                   I<= (others => '0');
                   index<=0;
                   index2<=0;
                   j<= (others => '0');                     
                else
                   j<=j+1;
               end if;
              else
                if (I <=  binchange-1) then
                    JD(7)<='1';
                    changeamp_reg<='0';
                  if (index=0) then  
                    if (j=4) then
                        j<= (others => '0');
                        cnt<=cnt+JB;
                        I<=I+1;
                    else
                        j<=j+1;
                        cnt<=cnt+JB;
                    end if;
                  else 
                        if (j=4) then
                          j<= (others => '0');
                          cnt<=cnt+JB;
                          I<=I+1;
                        else
                          j<=j+1;
                          cnt<=cnt+JB;
                          end if;
                  end if;   
                elsif (I = binchange) then
                   if (j=4) then
                       j<= (others => '0');
                       cnt2<=(others => '0'); 
                       I<= "000000000000000000000000000000001";
                       binchange<=timesegment(index2);
                       changeamp_reg<='0';
                       index<=index+1;
--                       cnt<=cnt2+JB;
                   elsif (j=3) then
--                        cnt2<=cnt2+JB;
                        j<=j+1;
                        index2<=index2+1;
                   elsif (j=0) then
--                       cnt2<=cnt2+JB;
                       j<=j+1;
                       if (maxokrun>=okrun and okrun>=minokrun) then
                           if (index<maxindex_int-1) then
                                changeamp_reg<='1';
                           end if;
                           if (cnt = 0) then
                                cntresult(index)<='0';
                                if (parity = '0') then
                                    analogbit<= Voutzero;
                                    ampdis<=ampdisoff;
--                                    if (index<maxindex_int-1) then
--                                        JD(7)<='0';
--                                    end if;                                    
                                else
                                     analogbit<= Voutpi;
                                     ampdis<=ampdison;
--                                    if (index<maxindex_int-1) then
--                                         JD(7)<='1';
--                                     end if;
                                end if;                         
                           else
                                cntresult(index)<='1';
                                parity <= not parity;
                                if (parity = '1') then
                                   analogbit<= Voutzero;
                                   ampdis<=ampdisoff;
--                                   if (index<maxindex_int-1) then
--                                       JD(7)<='0';
--                                   end if;
                                else
                                    analogbit<= Voutpi;
                                    ampdis<=ampdison;
--                                   if (index<maxindex_int-1) then
--                                       JD(7)<='1';
--                                    end if;
                                end if;                         
                           end if;

                     end if;      
                   else
                       j<=j+1;
--                       cnt2<=cnt2+JB;
                       cnt<= (others => '0'); 
                   end if;
                end if;
              end if;       
            else
                j<= (others => '0');
                cnt<= (others => '0');
                cnt2<= (others => '0');
                if (y='0') then
                    changeamp_reg<='1';
                    y<='1';  
                else
                    changeamp_reg<='0';
                end if;     
                startconv<='0'; 
                I<= (others => '0'); 
                analogbit<= Voutzero;
                ampdis<=ampdisdef;
                okrun<= (others => '0');
                parity <= '0';
                index<=0;         
                index2<=0;
                cntresult<= (others => '0');  
                psiplus<=(others => '0'); 
                psiminus<=(others => '0'); 
                cnt00000000000<=(others => '0');
                cnt00000000001<=(others => '0');
                cnt00000000010<=(others => '0');
                cnt00000000011<=(others => '0');
                cnt00000000100<=(others => '0');
                cnt00000000101<=(others => '0');
                cnt00000000110<=(others => '0');
                cnt00000000111<=(others => '0');
                cnt00000001000<=(others => '0');
                cnt00000001001<=(others => '0');
                cnt00000001010<=(others => '0');
                cnt00000001011<=(others => '0');
                cnt00000001100<=(others => '0');
                cnt00000001101<=(others => '0');        
                cnt00000001110<=(others => '0');        
                cnt00000001111<=(others => '0');        
                cnt11111111111<=(others => '0');
                binchange<=timesegment(0);
                JD(7)<='0';
            end if;
    end if;
end if;
end process;
change_phase<=changeamp_reg;
changeamp<=changeamp_reg;

--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
process (sw) begin
if (sw(1)='0' and sw(2)='0' and sw(3)='0') then
    transdata0<=psiplus;
    transdata1<=psiminus;
elsif (sw(1)='1' and sw(2)='0' and sw(3)='0') then    
    transdata0<=cnt00000000000;
    transdata1<=cnt00000000011;
elsif (sw(1)='0' and sw(2)='1' and sw(3)='0') then    
    transdata0<=cnt00000000000;
    transdata1<=cnt00000000010;
elsif (sw(1)='1' and sw(2)='1' and sw(3)='0') then    
    transdata0<=cnt00000000000;
    transdata1<=cnt00000000001;
elsif (sw(1)='0' and sw(2)='0' and sw(3)='1') then    
    transdata0<=cnt00000000001;
    transdata1<=cnt00000000011;
elsif (sw(1)='1' and sw(2)='0' and sw(3)='1') then    
    transdata0<=cnt00000000010;
    transdata1<=cnt00000000011;
elsif (sw(1)='0' and sw(2)='1' and sw(3)='1') then    
    transdata0<=cnt00000000001;
    transdata1<=cnt00000000010;
end if;
end process;
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------

----To show count on the 7-segment display
process (clk_out,startconv,datasent,transdata0) begin
if (clk_out'event and clk_out = '1') then
case p is
    when  "0000" =>
        if (startconv='1') then   
            p<="0001";
        else
            p<="0000";
        end if;
    when  "0001" =>
        case parityt is 
        when 0 =>  s_axis_divisor_tdata_div3<="0000001111101000";  
                   s_axis_dividend_tdata_div3<=transdata0;   
        when 1 =>  s_axis_divisor_tdata_div3<="0000000001100100";  
                   s_axis_dividend_tdata_div3<="000000"&Vreminder_div3; 
        when 2 =>  s_axis_divisor_tdata_div3<="0000000000001010";  
                   s_axis_dividend_tdata_div3<="000000"&Vreminder_div3;
        when 3 =>  s_axis_divisor_tdata_div3<="0000000000000001";  
                   s_axis_dividend_tdata_div3<="000000"&Vreminder_div3; 
        when others => s_axis_divisor_tdata_div3 <="0000000000000001";
        end case;   
        p<=p+1;
    when  "0010" =>
        s_axis_divisor_tvalid_div3<='1';
        s_axis_dividend_tvalid_div3<='1';
        p<=p+1;
  when  "0011" =>  
        if (m_axis_dout_tvalid_div3='1') then
             s_axis_divisor_tvalid_div3<='0';
             s_axis_dividend_tvalid_div3<='0';
             p<=p+1;
        end if;    
   when "0100" => 
         if (m_axis_dout_tvalid_div3='0') then
             Vquotient_div3 <=m_axis_dout_tdata_div3(29 downto 16);
             Vreminder_div3 <=m_axis_dout_tdata_div3(9 downto 0);
             p<=p+1;
         end if; 
   when "0101" => 
        case parityt is 
        when 0 => psipluscountDIS1000<= Vquotient_div3 (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 1 => psipluscountDIS100<= Vquotient_div3 (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 2 => psipluscountDIS10<= Vquotient_div3 (3 downto 0);
                  p<="0001";
                  parityt<=parityt+1;
        when 3 => psipluscountDIS1<= Vquotient_div3 (3 downto 0);
                  parityt<=0;
                  p<=p+1;
        when others =>   parityt<=0;  
                         p<="0000"; 
        end case;                          
    when "0110" =>
       case psipluscountDIS1000 is 
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
       when others => ascii0 <= "00110000";
       end case;
   
   
       case psipluscountDIS100 is 
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
       when others => ascii1 <= "00110000";
       end case;
       
       case psipluscountDIS10 is 
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
       when others => ascii2<= "00110000";
       end case;
       
       case psipluscountDIS1 is 
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
       when others => ascii3<= "00110000";
       end case;
       p<=p+1;
    when "0111" =>
       countDISbin<='1';
       p<=p+1;
    when "1000" =>
     countDISbin<='0';   
      p<=p+1;
    when "1001" => 
     if(datasent='1') then 
       p<=p+1;
     end if;
    when "1010" =>
        p<=p+1;
    when "1011" =>        
        p<="0000";
    when others => p<="0000";
    end case;
 end if;
end process;

--To show count on the 7-segment display
process (clk_out,startconv,datasent,transdata1) begin
if (clk_out'event and clk_out = '1') then
case pp is
    when  "0000" =>
        if (startconv='1') then   
            pp<="0001";
        else
            pp<="0000";
        end if;
    when  "0001" =>
        case paritytt is 
        when 0 =>  s_axis_divisor_tdata_div3_2<="0000001111101000";  
                   s_axis_dividend_tdata_div3_2<=transdata1;
        when 1 =>  s_axis_divisor_tdata_div3_2<="0000000001100100";  
                   s_axis_dividend_tdata_div3_2<="000000"&Vreminder_div3_2;                   
        when 2 =>  
                   s_axis_divisor_tdata_div3_2<="0000000000001010";  
                   s_axis_dividend_tdata_div3_2<="000000"&Vreminder_div3_2;                           
        when 3 => 
                   s_axis_divisor_tdata_div3_2<="0000000000000001";  
                   s_axis_dividend_tdata_div3_2<="000000"&Vreminder_div3_2;                    
        when others => 
                       s_axis_divisor_tdata_div3_2 <="0000000000000001";
        end case;   
        pp<=pp+1;
    when  "0010" =>
        s_axis_divisor_tvalid_div3_2<='1';
        s_axis_dividend_tvalid_div3_2<='1';        
        pp<=pp+1;
  when  "0011" =>  
        if (m_axis_dout_tvalid_div3_2='1') then
             s_axis_divisor_tvalid_div3_2<='0';
             s_axis_dividend_tvalid_div3_2<='0';
             pp<=pp+1;
        end if;    
   when "0100" => 
         if (m_axis_dout_tvalid_div3_2='0') then
             Vquotient_div3_2 <=m_axis_dout_tdata_div3_2(29 downto 16);
             Vreminder_div3_2 <=m_axis_dout_tdata_div3_2(9 downto 0);
             pp<=pp+1;
         end if; 
   when "0101" =>  
        case paritytt is 
        when 0 => psiminuscountDIS1000<= Vquotient_div3_2 (3 downto 0);
                  pp<="0001";
                  paritytt<=paritytt+1;
        when 1 => psiminuscountDIS100<= Vquotient_div3_2 (3 downto 0);
                  pp<="0001";
                  paritytt<=paritytt+1;
        when 2 => psiminuscountDIS10<= Vquotient_div3_2 (3 downto 0);
                  pp<="0001";
                  paritytt<=paritytt+1;
        when 3 => psiminuscountDIS1<= Vquotient_div3_2 (3 downto 0);
                  paritytt<=0;
                  pp<=pp+1;
        when others =>   paritytt<=0;  
                         pp<="0000"; 
        end case;                          
    when "0110" =>

       case psiminuscountDIS1000 is 
       when "0000" => ascii4 <="00110000";
       when  "0001"=> ascii4 <="00110001";
       when  "0010"=> ascii4 <="00110010";
       when  "0011"=> ascii4 <="00110011";
       when  "0100"=> ascii4 <="00110100";
       when  "0101"=> ascii4 <="00110101";
       when  "0110"=> ascii4 <="00110110";
       when  "0111"=> ascii4 <="00110111";
       when  "1000"=> ascii4 <="00111000";
       when  "1001"=> ascii4<="00111001";
       when others => ascii4<= "00110000";
       end case;
       
       case psiminuscountDIS100 is 
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
       when others => ascii5<= "00110000";
       end case;
       
        case psiminuscountDIS10 is 
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
       when others => ascii6<= "00110000";
       end case;
       
       case psiminuscountDIS1 is 
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
       when others => ascii7<= "00110000";
       end case;
       pp<=pp+1;
    when "0111" =>
     if(datasent='1') then 
       pp<=pp+1;
     end if;
    when "1000" =>
        pp<="0000"; 
    when others => pp<="0000";
    end case;
 end if;
end process;


end Behavioral;
