----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2022 12:36:21
-- Design Name: 
-- Module Name: sign_extension_trick - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sign_extension_trick is
  Port (pp_in : in std_logic_vector(wordsize  downto 0); 
        first : in std_logic;
        pp_out : out std_logic_vector(wordsize + 3 downto 0)
  );
end sign_extension_trick;

architecture Behavioral of sign_extension_trick is

begin

pp_out <=   not(pp_in(wordsize)) & pp_in(wordsize) & pp_in(wordsize) & pp_in when first = '1' else '0'  & '1' & not(pp_in(wordsize)) & pp_in; 

end Behavioral;
