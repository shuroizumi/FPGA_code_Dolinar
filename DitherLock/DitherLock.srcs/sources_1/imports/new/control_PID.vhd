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
       L: in std_logic :='0';
       offphase : in  std_logic :='0';
       g1 : in  std_logic :='0';
       g2 : in  std_logic :='0';      
       WP  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       WI  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       Wr : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       WL  : out STD_LOGIC_VECTOR(31 DOWNTO 0); -----floating point
       PAMPLOCK : in std_logic :='0';
       IAMPLOCK : in std_logic :='0';
       rAMPLOCK : in std_logic :='0';
       WPAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       WIAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       WrAMPLOCK  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       offsetphase : out integer range 0 to 50:=1;
       Wg1  : out STD_LOGIC_VECTOR(31 DOWNTO 0);
       Wg2  : out STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
end control_PID;

architecture Behavioral of control_PID is


signal int1P  : integer;
signal int10P  : integer;
signal int100P  : integer;
signal int1I  : integer;
signal int10I  : integer;
signal int100I  : integer;
signal int1r  : integer;
signal int10r  : integer;
signal int100r  : integer;
signal int1000r  : integer;
signal int10000r  : integer;
signal int100000r  : integer;
signal int1000000r  : integer;
signal int10000000r  : integer;


signal int1L  : integer;
signal int10L  : integer;
signal int100L  : integer;
signal int1000L  : integer;

signal int1OP  : integer;
signal int10OP  : integer;

signal int1g1  : integer;
signal int10g1  : integer;
signal int100g1  : integer;
signal int1000g1  : integer;
signal int10000g1  : integer;

signal int1g2  : integer;
signal int10g2  : integer;
signal int100g2  : integer;
signal int1000g2  : integer;
signal int10000g2  : integer;


signal WPint  : integer;
signal WP_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WIint : integer;
signal WI_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Wrint : integer;
signal WLint : integer;
signal Wr_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal WL_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal offsetphaseint : integer;
signal Wg1int : integer;
signal Wg1_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Wg2int : integer;
signal Wg2_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);


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

begin

process (P,DOUT5,DOUT6,DOUT7,int100P,int10P,int1P,WPint) begin
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

process (I,DOUT5,DOUT6,DOUT7,int100I,int10I,int1I,WIint) begin
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

process (r,DOUT0,DOUT1,DOUT2,DOUT3,DOUT4,DOUT5,DOUT6,DOUT7,int10000000r,int1000000r,int100000r,int10000r,int1000r,int100r,int10r,int1r,Wrint,Wr_reg) begin
    if (r='1') then
        --10000000‚ÌˆÊ 
    int10000000r <= CONV_INTEGER(unsigned(DOUT0)) * 10000000;    
    --1000000‚ÌˆÊ 
    int1000000r <= CONV_INTEGER(unsigned(DOUT1)) * 1000000;    
    --100000‚ÌˆÊ 
    int100000r <= CONV_INTEGER(unsigned(DOUT2)) * 100000;    
    --10000‚ÌˆÊ 
    int10000r <= CONV_INTEGER(unsigned(DOUT3)) * 10000;    
    --1000‚ÌˆÊ 
    int1000r <= CONV_INTEGER(unsigned(DOUT4)) * 1000;    
    --100‚ÌˆÊ 
    int100r <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10r <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1r <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    Wrint<=int1r+int10r+int100r+int1000r+int10000r+int100000r+int1000000r+int10000000r;
    Wr_reg<=conv_STD_LOGIC_VECTOR(Wrint,32);
    end if;
end process;
Wr<=Wr_reg;


process (L,DOUT5,DOUT6,DOUT7,int100L,int10L,int1L,WLint,WL_reg) begin
    if (L='1') then
    --1000‚ÌˆÊ 
    int1000L <= CONV_INTEGER(unsigned(DOUT4)) * 1000;
    --100‚ÌˆÊ 
    int100L <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10L <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1L <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    WLint<=int1L+int10L+int100L+int1000L;
    WL_reg<=conv_STD_LOGIC_VECTOR(WLint,32);
    end if;
end process;
WL<=WL_reg;


process (offphase,DOUT6,DOUT7,int10OP,int1OP,offsetphaseint) begin
    if (offphase='1') then
    --10‚ÌˆÊ 
    int10OP <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1OP <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    offsetphaseint<=int1OP+int10OP;
    end if;
end process;
offsetphase<=offsetphaseint;

process (g1,DOUT5,DOUT6,DOUT7,int10000g1,int1000g1,int100g1,int10g1,int1g1,Wg1int,Wg1_reg) begin
    if (g1='1') then
    --1000‚ÌˆÊ 
    int10000g1 <= CONV_INTEGER(unsigned(DOUT3)) * 10000;
    --1000‚ÌˆÊ 
    int1000g1 <= CONV_INTEGER(unsigned(DOUT4)) * 1000;
    --100‚ÌˆÊ 
    int100g1 <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10g1 <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1g1 <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    Wg1int<=int1g1+int10g1+int100g1+int1000g1+int10000g1;
    Wg1_reg<=conv_STD_LOGIC_VECTOR(Wg1int,32);
    end if;
end process;
Wg1<=Wg1_reg;

process (g2,DOUT5,DOUT6,DOUT7,int10000g2,int1000g2,int100g2,int10g2,int1g2,Wg2int,Wg2_reg) begin
    if (g2='1') then
    --1000‚ÌˆÊ 
    int10000g2 <= CONV_INTEGER(unsigned(DOUT3)) * 10000;
    --1000‚ÌˆÊ 
    int1000g2 <= CONV_INTEGER(unsigned(DOUT4)) * 1000;
    --100‚ÌˆÊ 
    int100g2 <= CONV_INTEGER(unsigned(DOUT5)) * 100;
    --10‚ÌˆÊ 
    int10g2 <= CONV_INTEGER(unsigned(DOUT6)) * 10;
    --1‚ÌˆÊ 
    int1g2 <= CONV_INTEGER(unsigned(DOUT7)) * 1;
    Wg2int<=int1g2+int10g2+int100g2+int1000g2+int10000g2;
    Wg2_reg<=conv_STD_LOGIC_VECTOR(Wg2int,32);
    end if;
end process;
Wg2<=Wg2_reg;


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


end Behavioral;
