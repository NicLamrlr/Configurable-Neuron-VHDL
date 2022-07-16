----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.06.2022 18:11:35
-- Design Name: 
-- Module Name: package_full_Neuron - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package package_full_Neuron is


--Multiplier values
constant wordsize: integer := 8;
constant precision: integer := 3;
constant neg: integer := 0;
constant serpar: integer := 0;
-------------------------------------
--Inner Multiplier values
constant wordsize_inner: integer := 8;
constant precision_inner: integer := 3;
constant neg_inner: integer := 0;
constant serpar_inner: integer := 0;
-------------------------------------
--Neuron values
constant n: integer := 8;
type inputs is array (0 to n-1) of unsigned (wordsize - 1 downto 0);
-------------------------------------
--AF values
constant fun: integer := 3;
--Taylor values
constant wl: integer := 8;
constant fl: integer := 5;
constant il: integer := 3;
constant cwl: integer := 13;
constant cfl: integer := 12;
constant cil: integer := 1;
constant one_out : std_logic_vector(wl - 1 downto 0) := "10000000";
constant correction : std_logic_vector := "00000";
constant lowlimit : signed:= "11010000";
constant highlimit : signed:= "00110000";
--Taylor coefs midrange <1.12>
constant CT1M : signed(cwl - 1 downto 0):= "0100000000000";
constant CT2M : signed(cwl - 1 downto 0):= "0010000000000";
constant CT3M : signed(cwl - 1 downto 0):= "1111110101010";
constant CT4M : signed(cwl - 1 downto 0):= "0000000001001";
--Taylor coefs sides <1.12>
constant CT1S : signed(cwl - 1 downto 0):= "0011100000010";
constant CT2S : signed(cwl - 1 downto 0):= "0011001001000";
constant CT3S : signed(cwl - 1 downto 0):= "1111001000011";
constant CT4S : signed(cwl - 1 downto 0):= "0000000111010";
constant CT5S : signed(cwl - 1 downto 0):= "1111111111101";
-------------------------------------
--SONF values
constant one_in : std_logic_vector(wl - 1 downto 0) := "00100000";
-------------------------------------
--Batch values
constant div: std_logic_vector:= "00";
constant bot: integer := 2;
constant value_height: integer := 32;
constant index_height: integer := 32;
constant value_width: integer := 7;
constant index_width: integer := 2;







end package_full_Neuron;