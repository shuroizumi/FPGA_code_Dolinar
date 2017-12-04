library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--Send ascii form data to PC
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
entity FPGA_PC_read is
Port (clk : in std_logic;
      sw :  in std_logic;
     RsTx : out  std_logic;
     countDis: in  std_logic:='0';
     ascii0: in std_logic_vector (7 downto 0);
     ascii1: in std_logic_vector (7 downto 0);
     ascii2: in std_logic_vector (7 downto 0);
     ascii3: in std_logic_vector (7 downto 0);
     ascii4: in std_logic_vector (7 downto 0);
     ascii5: in std_logic_vector (7 downto 0);
     ascii6: in std_logic_vector (7 downto 0);
     ascii7: in std_logic_vector (7 downto 0);
     T: in  std_logic;
     phi:in std_logic_vector (7 downto 0);
     finread: out  std_logic;
     resetPCread: in  std_logic;
     transmode: in  std_logic;
     datasent: out  std_logic
   );
end FPGA_PC_read;

architecture Behavioral of FPGA_PC_read is

component PCsent_integer_to_ASCII  is 
 port (std: in std_logic_vector (7 downto 0);
       ASCII:out std_logic_vector (15 downto 0):="0000000000000000"
       );
end component;


signal J : natural;
signal state_reg : std_logic_vector (2 downto 0):= (others => '0');
signal s_reg :  std_logic_vector(18 downto 0):= (others => '0');
signal n_reg :  std_logic_vector(2 downto 0):= (others => '0');
signal datbit : integer range 0 to 10:=0;
signal Datasend : std_logic_vector (7 downto 0):= (others => '0');
signal phistd : std_logic_vector (15 downto 0):= (others => '0');


signal ascii0_reg:  std_logic_vector (7 downto 0);
signal ascii1_reg:  std_logic_vector (7 downto 0);
signal ascii2_reg:  std_logic_vector (7 downto 0);
signal ascii3_reg:  std_logic_vector (7 downto 0);
signal ascii4_reg:  std_logic_vector (7 downto 0);
signal ascii5_reg:  std_logic_vector (7 downto 0);
signal ascii6_reg:  std_logic_vector (7 downto 0);
signal ascii7_reg:  std_logic_vector (7 downto 0);

begin
iinteger_ASCII: PCsent_integer_to_ASCII  port map(std=>phi ,ASCII=>phistd); 

process (clk,countDis,T,sw,resetPCread) begin
if (sw='1') then
    state_reg <=(others=>'0');
    s_reg<=(others=>'0');
    n_reg<=(others=>'0');
    J<=0;
    RsTx<='1';
    datbit<=0;
    finread<='0';
    datasent<='0';
elsif (resetPCread='1') then
    state_reg <=(others=>'0');
    s_reg<=(others=>'0');
    n_reg<=(others=>'0');
    J<=0;
    RsTx<='1';
    datbit<=0;
    finread<='0';
    datasent<='0';
else
    if (clk'event and clk = '1') then
     case state_reg is
        when "000" =>
            finread<='0';
            if (countDis='1' and T='1') then
                datasent<='0';
                ascii0_reg<=ascii0;
                ascii1_reg<=ascii1;
                ascii2_reg<=ascii2;
                ascii3_reg<=ascii3;
                ascii4_reg<=ascii4;
                ascii5_reg<=ascii5;
                ascii6_reg<=ascii6;
                ascii7_reg<=ascii7;
--                if (transmode='1') then
--                    datbit<=5;
--                else
                datbit<=0;
--                end if;
                state_reg<=state_reg+1;
            end if;
        when "001" =>
            if (transmode='0') then
                if (datbit=0) then
                   Datasend<=ascii2_reg;
                elsif (datbit=1) then
                   Datasend<=ascii3_reg;
                elsif (datbit=2) then
                   Datasend<=ascii4_reg;
                elsif (datbit=3) then
                   Datasend<=ascii5_reg;
                elsif (datbit=4) then
                   Datasend<=ascii6_reg;
                elsif (datbit=5) then
                   Datasend<=ascii7_reg;
                elsif (datbit=6) then
                    Datasend<="00101010";
                elsif (datbit=7) then
                    Datasend<=phistd(15 downto 8); 
                elsif (datbit=8) then
                   Datasend<=phistd(7 downto 0);
                elsif (datbit=9) then
                    Datasend<="00101010";
                end if; 
             else
                if (datbit=0) then
                    Datasend<=ascii0_reg;
                 elsif (datbit=1) then
                    Datasend<=ascii1_reg;
                 elsif (datbit=2) then
                    Datasend<=ascii2_reg;
                 elsif (datbit=3) then
                    Datasend<=ascii3_reg;
                 elsif (datbit=4) then
                    Datasend<=ascii4_reg;
                 elsif (datbit=5) then
                    Datasend<=ascii5_reg;
                 elsif (datbit=6) then
                    Datasend<=ascii6_reg;
                 elsif (datbit=7) then
                    Datasend<=ascii7_reg;
                 elsif (datbit=8) then
                    Datasend<="00101010";
                 end if; 
             end if;
            s_reg<=(others=>'0');
            n_reg<=(others=>'0');
            J<=0;
            RsTx<='1';
            state_reg<=state_reg+1;
        when "010" =>
            RsTx<='0';
            if (s_reg=109-1) then
                state_reg<=state_reg+1;
                s_reg<=(others=>'0');
            else
                state_reg<="010";
                s_reg<=s_reg+1;
            end if;            
        when "011" =>
               RsTx<=Datasend (J);
             if (s_reg=109-1) then        
                  s_reg<=(others=>'0');
                  J<=J+1;
                  if (n_reg = 7) then
                      state_reg<=state_reg+1;
                      n_reg<=(others=>'0');
                  else 
                      n_reg<=n_reg+1;
                      state_reg<="011";
                  end if;          
              else
                  s_reg<=s_reg+1;
                  state_reg<="011";
              end if;
        when "100" =>    
               RsTx<='1'; 
               if (s_reg=109-1) then
                   s_reg<=(others=>'0');
                  if (transmode='0') then 
                   if (datbit=6) then
                        state_reg<="000";
                        datbit<=0;
                        finread<='1';
                        datasent<='1';
                   else
                        state_reg<="001";
                        datbit<=datbit+1;
                   end if;
                 else
                   if (datbit=8) then
                      state_reg<="000";
                      datbit<=0;
                      finread<='1';
                      datasent<='1';
                   else
                      state_reg<="001";
                      datbit<=datbit+1;
                   end if;
                 end if;      
               else
                   state_reg<="100";
                   s_reg<=s_reg+1;
               end if;            
        when others => state_reg<="000";
        end case;  
    end if;
end if;
end process;

end Behavioral;
