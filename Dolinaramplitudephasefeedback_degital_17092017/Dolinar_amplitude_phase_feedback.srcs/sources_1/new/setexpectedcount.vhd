library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity setexpectedcount is
  Port (
       clk : in std_logic;
       setexpectedcnt: out std_logic_vector (31 downto 0):= (others => '0');
       expectedVADC: out std_logic_vector (31 downto 0):= (others => '0');       
       C: in  std_logic;
       CAMPLOCK: in  std_logic;
       DOUT0 : in std_logic_vector (3 downto 0);
       DOUT1 : in std_logic_vector (3 downto 0);
       DOUT2 : in std_logic_vector (3 downto 0);
       DOUT3 : in std_logic_vector (3 downto 0);
       DOUT4 : in std_logic_vector (3 downto 0);
       DOUT5 : in std_logic_vector (3 downto 0);
       DOUT6 : in std_logic_vector (3 downto 0);
       DOUT7 : in std_logic_vector (3 downto 0)
       );
end setexpectedcount;

architecture Behavioral of setexpectedcount is


--------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
--COMPONENT floating_point_1
--  PORT (
--    aclk : IN STD_LOGIC;
--    s_axis_a_tvalid : IN STD_LOGIC;
--    s_axis_a_tready : OUT STD_LOGIC;
--    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--    m_axis_result_tvalid : OUT STD_LOGIC;
--    m_axis_result_tready : IN STD_LOGIC;
--    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
--  );
--END COMPONENT;


signal int1  : std_logic_vector (32 downto 0):= (others => '0');
signal int10  : std_logic_vector (32 downto 0):= (others => '0');
signal int100  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000  : std_logic_vector (32 downto 0):= (others => '0');
signal int100000  : std_logic_vector (32 downto 0):= (others => '0');
signal int1000000  : std_logic_vector (32 downto 0):= (others => '0');
signal int10000000  : std_logic_vector (32 downto 0):= (others => '0');
signal W  : std_logic_vector (32 downto 0):= (others => '0');
signal Wint  : integer;


signal AMPLOCKint1  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint10  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint100  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint1000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint10000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint100000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint1000000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKint10000000  : std_logic_vector (32 downto 0):= (others => '0');
signal AMPLOCKW  : std_logic_vector (32 downto 0):= (others => '0');


signal s_axis_a_tvalid_in1: std_logic :='0';
signal s_axis_a_tready_out1: std_logic :='0';
signal s_axis_a_tdata_in1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal m_axis_result_tvalid_out1: std_logic :='0';
signal m_axis_result_tready_in1: std_logic :='0';
signal m_axis_result_tdata_out1: STD_LOGIC_VECTOR(31 DOWNTO 0);


signal reg: STD_LOGIC_VECTOR(3 DOWNTO 0);
begin
--iconvertuintfloat: floating_point_1
--      PORT MAP (
--        aclk => clk,
--        s_axis_a_tvalid => s_axis_a_tvalid_in1,
--        s_axis_a_tready => s_axis_a_tready_out1,
--        s_axis_a_tdata => s_axis_a_tdata_in1,
--        m_axis_result_tvalid => m_axis_result_tvalid_out1,
--        m_axis_result_tready => m_axis_result_tready_in1,
--        m_axis_result_tdata => m_axis_result_tdata_out1
--      );


process (C,DOUT0,DOUT1,DOUT2,DOUT3,DOUT4,DOUT5,DOUT6,DOUT7,int1,int10,int100,int1000,int10000,int100000,int1000000,int10000000) begin
    if (C='1') then
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
    W<=int1+int10+int100+int1000+int10000+int100000+int1000000+int10000000;
    end if;
end process;

setexpectedcnt <=W(31 downto 0);



process (CAMPLOCK,DOUT0,DOUT1,DOUT2,DOUT3,DOUT4,DOUT5,DOUT6,DOUT7,AMPLOCKint1,AMPLOCKint10,AMPLOCKint100,AMPLOCKint1000,AMPLOCKint10000,AMPLOCKint100000,AMPLOCKint1000000,AMPLOCKint10000000) begin
    if (CAMPLOCK='1') then
    --10000000‚ÌˆÊ 
    AMPLOCKint10000000 <=  DOUT0 *"00000100110001001011010000000";
    --1000000‚ÌˆÊ 
    AMPLOCKint1000000 <= DOUT1 * "00000000011110100001001000000" ;
    --100000‚ÌˆÊ 
    AMPLOCKint100000 <=  DOUT2 * "00000000000011000011010100000";
    --10000‚ÌˆÊ 
    AMPLOCKint10000 <=   DOUT3 * "00000000000000010011100010000";
    --1000‚ÌˆÊ 
    AMPLOCKint1000 <=   DOUT4 * "00000000000000000001111101000";
    --100‚ÌˆÊ 
    AMPLOCKint100 <=   DOUT5 * "00000000000000000000001100100";
    --10‚ÌˆÊ 
    AMPLOCKint10 <=   DOUT6 * "00000000000000000000000001010";
    --1‚ÌˆÊ 
    AMPLOCKint1 <=   DOUT7* "00000000000000000000000000001";
    AMPLOCKW<=AMPLOCKint1+AMPLOCKint10+AMPLOCKint100+AMPLOCKint1000+AMPLOCKint10000+AMPLOCKint100000+AMPLOCKint1000000+AMPLOCKint10000000;
    end if;
end process;
expectedVADC <=AMPLOCKW(31 downto 0);



--process (clk) begin
-- if (clk'event and clk = '1') then
--    case reg is
--    when "0000" =>  
--        s_axis_a_tdata_in1<=W(31 downto 0);
--        reg<= "0001"; 
--    when "0001" => 
--        s_axis_a_tvalid_in1<='1'; 
--        reg<="0010";
--    when "0010" =>    
--        if (m_axis_result_tvalid_out1='1') then
--            m_axis_result_tready_in1<='1';
--            s_axis_a_tvalid_in1<='0';
--            reg<="0011";
--        end if;
--    when "0011" =>    
--        if (m_axis_result_tvalid_out1='0') then
--             m_axis_result_tready_in1<='0';
--             reg<="0100";
--        end if;
--    when "0100" =>  
--        setexpectedcnt <=m_axis_result_tdata_out1; 
--        reg<="0000";
--    when others =>  reg<="0000";
--    end case;    
-- end if;   
--end process;
end Behavioral;
