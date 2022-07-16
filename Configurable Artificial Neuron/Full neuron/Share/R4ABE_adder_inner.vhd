----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.03.2022 11:17:23
-- Design Name: 
-- Module Name: R4ABE_adder - Behavioral
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
use work.package_full_Neuron.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity R4ABE_adder_inner is
  Port (a : in std_logic_vector(2 * wordsize_inner + 3 downto 0);  -- Accumulator
        b : in std_logic_vector(wordsize_inner + 3  downto 0);  -- Partial Product
        c : out std_logic_vector(2 * wordsize_inner  + 3  downto 0) -- result 
        );
end R4ABE_adder_inner;

architecture Behavioral of R4ABE_adder_inner is


begin

c <= std_logic_vector(resize(unsigned(a(2 * wordsize_inner + 3  downto wordsize_inner)) + unsigned(b),wordsize_inner + 6)) & a(wordsize_inner - 1 downto 2);

end Behavioral;