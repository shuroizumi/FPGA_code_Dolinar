library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_PID is
  Port (
       clk : in std_logic;
       DOUT0 : in std_logic_vector (3 downto 0);
       DOUT1 : in std_logic_vector (3 downto 0);
       DOUT2 : in std_logic_vector (3 downto 0);
       DOUT3 : in std_logic_vector (3 downto 0);
       DOUT4 : in std_logic_vector (3 downto 0);
       DOUT5 : in std_logic_vector (3 downto 0);
       DOUT6 : in std_logic_vector (3 downto 0);
       DOUT7 : in std_logic_vector (3 downto 0);
       P : in std_logic :='0';
       I : in std_logic :='0';
       r : in std_logic :='0';
       Lowpass: in std_logic :='0';
       gp : out std_logic_vector  (31 downto 0);
       gi : out std_logic_vector  (31 downto 0);
       gr : out std_logic_vector  (31 downto 0);
       alpha : out std_logic_vector  (31 downto 0);
       onemalpha : out std_logic_vector  (31 downto 0);
       WP  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       WI  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       Wr  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       PAMPLOCK : in std_logic :='0';
       IAMPLOCK : in std_logic :='0';
       rAMPLOCK : in std_logic :='0';
       WPAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       WIAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       WrAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
end control_PID;

architecture Behavioral of control_PID is



------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT floating_point_1
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT floating_point_6
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tready : OUT STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT floating_point_7
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tready : OUT STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tready : OUT STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------



signal int1P  : integer;
signal int10P  : integer;
signal int100P  : integer;
signal int1I  : integer;
signal int10I  : integer;
signal int100I  : integer;
signal int1r  : integer;
signal int10r  : integer;
signal int100r  : integer;
signal int1L  : integer;
signal int10L  : integer;
signal int100L  : integer;

signal WPint  : integer;
signal WIint : integer;
signal Wrint : integer;
signal WLint : integer;
signal WP_reg  : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WI_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Wr_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WL_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);



signal int1PAMPLOCK  : integer;
signal int10PAMPLOCK  : integer;
signal int100PAMPLOCK  : integer;
signal int1IAMPLOCK  : integer;
signal int10IAMPLOCK  : integer;
signal int100IAMPLOCK  : integer;
signal int1rAMPLOCK  : integer;
signal int10rAMPLOCK  : integer;
signal int100rAMPLOCK  : integer;

signal WPAMPLOCKint  : integer;
signal WIAMPLOCKint : integer;
signal WrAMPLOCKint : integer;
signal WPAMPLOCK_reg  : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WIAMPLOCK_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WrAMPLOCK_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);



signal s_axis_a_tvalid_in1: std_logic :='0';
signal s_axis_a_tready_out1: std_logic :='0';
signal s_axis_a_tdata_in1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid_out1: std_logic :='0';
signal m_axis_result_tready_in1: std_logic :='0';
signal m_axis_result_tdata_out1: STD_LOGIC_VECTOR(31 DOWNTO 0);

signal s_axis_a_tvalid_in6: std_logic :='0';
signal s_axis_a_tready_out6: std_logic :='0';
signal s_axis_a_tdata_in6 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axis_b_tvalid_in6: std_logic :='0';
signal s_axis_b_tready_out6: std_logic :='0';
signal s_axis_b_tdata_in6 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid_out6: std_logic :='0';
signal m_axis_result_tready_in6: std_logic :='0';
signal m_axis_result_tdata_out6: STD_LOGIC_VECTOR(31 DOWNTO 0);

signal s_axis_a_tvalid_in7: std_logic :='0';
signal s_axis_a_tready_out7: std_logic :='0';
signal s_axis_a_tdata_in7 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal s_axis_b_tvalid_in7: std_logic :='0';
signal s_axis_b_tready_out7: std_logic :='0';
signal s_axis_b_tdata_in7 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid_out7: std_logic :='0';
signal m_axis_result_tready_in7: std_logic :='0';
signal m_axis_result_tdata_out7: STD_LOGIC_VECTOR(31 DOWNTO 0);


signal reg: STD_LOGIC_VECTOR(4 DOWNTO 0);
signal alpha_reg: STD_LOGIC_VECTOR(31 DOWNTO 0);
begin
iconvertuintfloat: floating_point_1
      PORT MAP (
        aclk => clk,
        s_axis_a_tvalid => s_axis_a_tvalid_in1,
        s_axis_a_tready => s_axis_a_tready_out1,
        s_axis_a_tdata => s_axis_a_tdata_in1,
        m_axis_result_tvalid => m_axis_result_tvalid_out1,
        m_axis_result_tready => m_axis_result_tready_in1,
        m_axis_result_tdata => m_axis_result_tdata_out1
      );  
      
idividefloat: floating_point_6
PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => s_axis_a_tvalid_in6,
    s_axis_a_tready => s_axis_a_tready_out6,
    s_axis_a_tdata => s_axis_a_tdata_in6,
    s_axis_b_tvalid => s_axis_b_tvalid_in6,
    s_axis_b_tready => s_axis_b_tready_out6,
    s_axis_b_tdata => s_axis_b_tdata_in6,
    m_axis_result_tvalid => m_axis_result_tvalid_out6,
    m_axis_result_tready => m_axis_result_tready_in6,
    m_axis_result_tdata => m_axis_result_tdata_out6
  );


------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
isubtractfloat: floating_point_7
  PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => s_axis_a_tvalid_in7,
    s_axis_a_tready => s_axis_a_tready_out7,
    s_axis_a_tdata => s_axis_a_tdata_in7,
    s_axis_b_tvalid => s_axis_b_tvalid_in7,
    s_axis_b_tready => s_axis_b_tready_out7,
    s_axis_b_tdata => s_axis_b_tdata_in7,
    m_axis_result_tvalid => m_axis_result_tvalid_out7,
    m_axis_result_tready => m_axis_result_tready_in7,
    m_axis_result_tdata => m_axis_result_tdata_out7
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------   
            
            
process (P,DOUT5,DOUT6,DOUT7,int100P,int10P,int1P,WPint,WP_reg) begin
    if (P='1') then
    --100‚ÌˆÊ 
    int100P <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10P <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1P <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WPint<=int1P+int10P+int100P;
    WP_reg<=conv_STD_LOGIC_VECTOR(WPint,32);
    end if;
end process;
WP<=WP_reg;

process (I,DOUT5,DOUT6,DOUT7,int100I,int10I,int1I,WIint,WI_reg) begin
    if (I='1') then
    --100‚ÌˆÊ 
    int100I <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10I <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1I <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WIint<=int1I+int10I+int100I;
    WI_reg<=conv_STD_LOGIC_VECTOR(WIint,32);
    end if;
end process;
WI<=WI_reg;

process (r,DOUT5,DOUT6,DOUT7,int100r,int10r,int1r,Wrint,Wr_reg) begin
    if (r='1') then
    --100‚ÌˆÊ 
    int100r <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10r <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1r <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    Wrint<=int1r+int10r+int100r;
    Wr_reg<=conv_STD_LOGIC_VECTOR(Wrint,32);
    end if;
end process;
Wr<=Wr_reg;



process (PAMPLOCK,DOUT5,DOUT6,DOUT7,int100P,int10P,int1P,WPAMPLOCKint,WPAMPLOCK_reg) begin
    if (PAMPLOCK='1') then
    --100‚ÌˆÊ 
    int100PAMPLOCK <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10PAMPLOCK <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1PAMPLOCK <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WPAMPLOCKint<=int1PAMPLOCK+int10PAMPLOCK+int100PAMPLOCK;
    WPAMPLOCK_reg<=conv_STD_LOGIC_VECTOR(WPAMPLOCKint,32);
    end if;
end process;
WPAMPLOCK<=WPAMPLOCK_reg;

process (IAMPLOCK,DOUT5,DOUT6,DOUT7,int100I,int10I,int1I,WIAMPLOCKint,WIAMPLOCK_reg) begin
    if (IAMPLOCK='1') then
    --100‚ÌˆÊ 
    int100IAMPLOCK <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10IAMPLOCK <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1IAMPLOCK <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WIAMPLOCKint<=int1IAMPLOCK+int10IAMPLOCK+int100IAMPLOCK;
    WIAMPLOCK_reg<=conv_STD_LOGIC_VECTOR(WIAMPLOCKint,32);
    end if;
end process;
WIAMPLOCK<=WIAMPLOCK_reg;

process (r,DOUT5,DOUT6,DOUT7,int100r,int10r,int1r,WrAMPLOCKint,WrAMPLOCK_reg) begin
    if (rAMPLOCK='1') then
    --100‚ÌˆÊ 
    int100rAMPLOCK <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10rAMPLOCK <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1rAMPLOCK <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WrAMPLOCKint<=int1rAMPLOCK+int10rAMPLOCK+int100rAMPLOCK;
    WrAMPLOCK_reg<=conv_STD_LOGIC_VECTOR(WrAMPLOCKint,32);
    end if;
end process;
WrAMPLOCK<=WrAMPLOCK_reg;

process (Lowpass,DOUT5,DOUT6,DOUT7,int100L,int10L,int1L,WLint,WL_reg) begin
    if (Lowpass='1') then
    --100‚ÌˆÊ 
    int100L <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10L <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1L <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WLint<=int1L+int10L+int100L;
    WL_reg<=conv_STD_LOGIC_VECTOR(WLint,32);
    end if;
end process;


process (clk) begin
 if (clk'event and clk = '1') then
    case reg is
    when "00000" =>
        s_axis_a_tdata_in1<=WP_reg;
        reg<= "00001";
    when "00001" => 
        s_axis_a_tvalid_in1<='1'; 
        reg<= "00010";  
    when "00010" =>    
        if (m_axis_result_tvalid_out1='1') then
            m_axis_result_tready_in1<='1';
            s_axis_a_tvalid_in1<='0';
            reg<="00011";
        end if;
    when "00011" =>    
        if (m_axis_result_tvalid_out1='0') then
             m_axis_result_tready_in1<='0';
             reg<="00100";
        end if;
    when "00100" =>  
        gp <=m_axis_result_tdata_out1; 
        reg<="00101";
    when "00101" =>  
        s_axis_a_tdata_in1<=WI_reg;
        reg<= "00110";
    when "00110" => 
        s_axis_a_tvalid_in1<='1'; 
        reg<= "00111";  
    when "00111" =>    
        if (m_axis_result_tvalid_out1='1') then
            m_axis_result_tready_in1<='1';
            s_axis_a_tvalid_in1<='0';
            reg<="01000";
        end if;
    when "01000" =>    
        if (m_axis_result_tvalid_out1='0') then
             m_axis_result_tready_in1<='0';
             reg<="01001";
        end if;
    when "01001" =>  
        gi <=m_axis_result_tdata_out1; 
        reg<="01010";
    when "01010" =>  
        s_axis_a_tdata_in1<=Wr_reg;
        reg<= "01011";
    when "01011" =>
        s_axis_a_tvalid_in1<='1'; 
        reg<= "01100";
    when "01100" => 
        if (m_axis_result_tvalid_out1='1') then
            m_axis_result_tready_in1<='1';
            s_axis_a_tvalid_in1<='0';
            reg<="01101";
        end if;       
    when "01101" =>
        if (m_axis_result_tvalid_out1='0') then
             m_axis_result_tready_in1<='0';
             reg<="01110";
        end if;
    when "01110" =>      
        gr <=m_axis_result_tdata_out1;
        reg<=reg+1;
    when "01111" =>  
        s_axis_a_tdata_in1<=WL_reg;
        reg<=reg+1;
    when "10000" =>
        s_axis_a_tvalid_in1<='1'; 
        reg<=reg+1;
    when "10001" => 
        if (m_axis_result_tvalid_out1='1') then
            m_axis_result_tready_in1<='1';
            s_axis_a_tvalid_in1<='0';
            reg<=reg+1;
        end if;       
    when "10010" =>
        if (m_axis_result_tvalid_out1='0') then
             m_axis_result_tready_in1<='0';
             reg<=reg+1;
        end if;
    when "10011" =>
        reg<=reg+1;      
        alpha_reg <=m_axis_result_tdata_out1;
    when "10100" =>    
        reg<=reg+1; 
        s_axis_a_tdata_in6<=alpha_reg;
        s_axis_b_tdata_in6<="01000010110010000000000000000000"; 
        reg<=reg+1;
    when "10101" => 
        s_axis_a_tvalid_in6<='1';
        s_axis_b_tvalid_in6<='1';
        reg<=reg+1;
    when "10110" =>        
        if (m_axis_result_tvalid_out6='1') then
            m_axis_result_tready_in6<='1';
            s_axis_a_tvalid_in6<='0';
            s_axis_b_tvalid_in6<='0';
            reg<=reg+1;
        end if;
    when "10111" =>     
        if (m_axis_result_tvalid_out6='0') then
             m_axis_result_tready_in6<='0';
             reg<=reg+1;
        end if;
    when "11000" =>
        alpha<=m_axis_result_tdata_out6;
        reg<=reg+1;
    when "11001" =>
        s_axis_a_tdata_in7<="00111111100000000000000000000000";
        s_axis_b_tdata_in7<=m_axis_result_tdata_out6;    
        reg<=reg+1;
    when "11010" =>     
        s_axis_a_tvalid_in7<='1';
        s_axis_b_tvalid_in7<='1';
        reg<=reg+1; 
    when "11011" =>        
        if (m_axis_result_tvalid_out7='1') then
            m_axis_result_tready_in7<='1';
            s_axis_a_tvalid_in7<='0';
            s_axis_b_tvalid_in7<='0';
            reg<=reg+1;
        end if;
    when "11100" => 
        if (m_axis_result_tvalid_out7='0') then
             m_axis_result_tready_in7<='0';
             reg<=reg+1;
        end if;            
    when "11101" => 
         onemalpha<=m_axis_result_tdata_out7; 
         reg<="00000";
    when others =>  reg<="00000";
    end case;    
 end if;   
end process;
end Behavioral;
