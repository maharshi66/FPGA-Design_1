----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/07/2018 02:12:55 PM
-- Design Name: 
-- Module Name: stop_watch_top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stop_watch_top is
    Port( da,db,dc,dd: inout std_logic_vector(3 downto 0);           
          clk: in std_logic;
          reset: in std_logic;
          pause: in std_logic;
          sseg: out std_logic_vector(7 downto 0);
          an: out std_logic_vector(3 downto 0) );
end stop_watch_top;

architecture Behavioral of stop_watch_top is
   signal a, b , c, d: std_logic_vector (3 downto 0);
begin        
      a <= da;
      b <= db;
      c <= dc;
      d <= dd;
 disp_unit: entity work.disp_hex_mux(Behavioral)
                port map(   clk => clk ,
                            reset => reset,
                            hex3 => d,
                            hex2 => c,
                            hex1 => b,
                            hex0 => a,
                            dp_in => "1011",
                            an => an ,
                            sseg => sseg);                   
 watch_unit: entity work.stopwatch(cascade_arch)
 port map(   clk => clk,
             go => pause,
             clr => reset,
            d0 => a,
            d1 => b, 
            d2 => c , 
            d3 => d
            );      
end Behavioral;
