----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.05.2022 18:20:30
-- Design Name: 
-- Module Name: MUX_4x1 - Behavioral
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

use IEEE.NUMERIC_STD.ALL;
use work.package_full_Neuron.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX_4x1 is
 Port ( in0 : in signed(cwl - 1 downto 0);
        in1 : in signed(cwl - 1 downto 0);
        in2 : in signed(cwl - 1 downto 0);
        in3 : in signed(cwl - 1 downto 0);
        ctrl : in std_logic_vector(2 downto 0);
        output : out signed(cwl - 1 downto 0)
);
end MUX_4x1;

architecture Behavioral of MUX_4x1 is

begin

with (ctrl) select output <=
     in0 when  "000",
     in1 when  "001",
     in2 when  "010",
     in3 when  "011",
     (others => '0') when others;
end Behavioral;