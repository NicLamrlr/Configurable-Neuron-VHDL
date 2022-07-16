----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.06.2022 18:46:16
-- Design Name: 
-- Module Name: mult_adder - Behavioral
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

entity mult_adder is
  Port (a : in std_logic_vector(2*wordsize - 1 downto 0); -- Accumulator
        b : in std_logic_vector(2*wordsize - 1  downto 0);      -- Multiplication result
        c : out std_logic_vector(2*wordsize - 1 downto 0) -- Result 
      );
end mult_adder;

architecture Behavioral of mult_adder is

begin
c <= std_logic_vector(signed(a)+signed(b));

end Behavioral;
