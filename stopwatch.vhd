----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2018 02:50:45 PM
-- Design Name: 
-- Module Name: stopwatch - cascade_arch
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stopwatch is
 Port (    
            clk: in std_logic;
            go, clr: in std_logic;   
           --sw: in std_logic_vector(15 downto 0) 
            d0,d1,d2,d3: out std_logic_vector(3 downto 0)
                        );
end stopwatch;

architecture cascade_arch of stopwatch is
    constant DVSR: integer := 1000000;
    signal ms_reg, ms_next : std_logic_vector (23 downto 0);
    signal d3_reg : std_logic_vector(3 downto 0);
    signal d2_reg: std_logic_vector (3 downto 0);
    signal d1_reg: std_logic_vector (3 downto 0);
    signal d0_reg: std_logic_vector(3 downto 0);
    signal d3_next: std_logic_vector (3 downto 0);
    signal d2_next: std_logic_vector (3 downto 0);
    signal d1_next: std_logic_vector (3 downto 0);
    signal d0_next: std_logic_vector (3 downto 0);
    signal d3_en, d1_en, d2_en, d0_en, d_ms_en: std_logic;
    signal d_ms_reg, d_ms_next: std_logic_vector (3 downto 0);
    signal ms_tick, d2_tick, d1_tick, d0_tick, d_ms_tick: std_logic;
begin    
       
   process1: process(clk)   
    begin   
        if(clk'event and clk ='1')then
                   
        ms_reg <= ms_next;
        d3_reg <= d3_next;
        d2_reg <= d2_next;
        d1_reg <= d1_next;
        d0_reg <= d0_next;
        d_ms_reg <= d_ms_next;
        
       end if;
     end process;
--next state logic
--0.1 sec tick generator: mod - 10000000
     ms_next <=
     (others => '0') when clr ='1' or (ms_reg = DVSR and go = '0') else
     ms_reg - 1 when go = '0' else
     ms_reg;
     ms_tick <= '1' when ms_reg = DVSR else '0';
-- 0.1 sec counter
     d_ms_en <= '1' when ms_tick = '1' else '0';
     d_ms_next <= 
     "0000" when (clr = '1') or ( d_ms_en = '1' and d_ms_reg = 1) else
     "1001" when (d_ms_reg = 0 and d_ms_en = '1') else
     d_ms_reg - 1 when d_ms_en = '1'  else
     d_ms_reg;
     d_ms_tick <= '1' when d_ms_reg = 0 else '0';  
-- 1 sec counter
     d0_en <= '1' when ms_tick ='1' and d_ms_tick = '1' else '0';
     d0_next <= 
     "0000" when (clr = '1') or (d0_en = '1' and d0_reg = 1) else
     "1001" when (d0_reg = 0 and d0_en = '1') else
     d0_reg - 1 when (d0_en ='1')  else
     d0_reg;
     d0_tick <= '1' when d0_reg = 0 else '0';
 -- 1 sec counter
     d1_en <= '1' when ms_tick ='1' and d_ms_tick = '1'  and d0_tick ='1'  else '0';    
     d1_next <= 
     "0000" when (clr = '1') or (d1_en = '1' and d1_reg = 1) else
     "0101" when (d1_reg = 0 and d1_en = '1') else
     d1_reg - 1 when (d1_en ='1') else
     d1_reg;
     d1_tick <= '1' when d1_reg = 0 else '0';  
 -- 10 sec counter
     d2_en <= '1' when ms_tick ='1' and d_ms_tick = '1' and d0_tick ='1' and d1_tick ='1' else '0';
     d2_next <= 
     "0000" when (clr ='1') or (d2_en = '1' and d2_reg = 1) else
     "1001" when (d2_reg = 0 and d2_en = '1') else
     d2_reg - 1 when (d2_en ='1') else
     d2_reg;   
     d2_tick <= '1' when d2_reg = 0 else '0';
 -- 1 hour counter
     d3_en <= '1' when ms_tick ='1' and d_ms_tick = '1' and d0_tick ='1' and d1_tick ='1' and d2_tick = '1' else '0';  
     d3_next <=
     "0000" when (clr ='1') or  (d3_en = '1' and d3_reg = 1) else
     "0101" when (d3_reg = 0 and d3_en = '1') else 
     d3_reg - 1 when (d3_en = '1') else
     d3_reg;
--output logic   6
              d0 <= d0_reg;
              d1 <= d1_reg;
              d2 <= d2_reg;
              d3 <= d3_reg;         
       
---------------------

end cascade_arch;
