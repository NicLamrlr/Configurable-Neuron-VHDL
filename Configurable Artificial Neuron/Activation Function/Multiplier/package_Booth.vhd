----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2022 17:12:51
-- Design Name: 
-- Module Name: package_Booth - Behavioral
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
use work.package_Activation_Function.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package package_booth is

constant wordsize: integer := wl; --Size of inputs
constant precision: integer := 3; -- Precision of multiplication(3 Max, 2 Medium, 1 Low)
constant neg: integer :=1; -- Take last error correction bit in account, 1 - Yes 0 - No (Small error when Low)
constant serpar: integer := 0; -- Serial implementation 1, parallel implementation 0


end package_booth;

