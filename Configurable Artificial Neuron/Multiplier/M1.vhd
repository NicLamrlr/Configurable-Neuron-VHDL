----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2022 16:38:47
-- Design Name: 
-- Module Name: Low_Area_Booth - Behavioral
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

entity M1 is
  Port (a1 : in std_logic;
        a2 : in std_logic;
        b1 : in std_logic;
        b2 : in std_logic;
        b3 : in std_logic;
        pp : out std_logic);
end M1;

architecture Behavioral of M1 is

begin

pp <= ((b2 xor b1) and (b3 xor a2)) or ((b2 xnor b1) and (b3 xor b2) and (b3 xor  a1));


end Behavioral;
