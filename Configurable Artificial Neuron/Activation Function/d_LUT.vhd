----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.06.2022 11:25:39
-- Design Name: 
-- Module Name: d_LUT - Behavioral
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

use ieee.std_logic_textio.all;
use std.textio.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity d_LUT is
generic (initFile : string := "";--Add route data LUT
         initFile2 : string := "");--Add route error LUT
  Port (clk : in std_logic;
        reset : in std_logic;
        en : in std_logic;
        data_in : in std_logic_vector(wl - 1 downto 0);
        data_out : out unsigned(wl - 1 downto 0)
      );
end d_LUT;

architecture Behavioral of d_LUT is



 type romType is array(0 to value_height - 1) of std_logic_vector(value_width - 1 downto 0);
 type romType2 is array(0 to index_height - 1) of std_logic_vector(index_width - 1 downto 0);
 
 
 --signal ROM : romType ;
 --signal ROM2 : romType2;

 impure function initRomFromFile return romType is --Sigmoid values LUT
  file data_file : text open read_mode is initFile;
  variable data_fileLine : line;
  variable ROM : romType;
 begin
  for I in romType'range loop
   readline(data_file, data_fileLine);
   read(data_fileLine, ROM(I));
  end loop;
  return ROM;
 end function;
 signal rom : romType := initRomFromFile;
 attribute rom_style : string;
 attribute rom_style of rom : signal is "block";
 
 
impure function initRomFromFile2 return romType2 is --Input ranges LUT
   file data_file2 : text open read_mode is initFile2;
   variable data_fileLine2 : line;
   variable ROM2 : romType2;
  begin
   for I in romType2'range loop
    readline(data_file2, data_fileLine2);
    read(data_fileLine2, ROM2(I));
   end loop;
   return ROM2;
  end function;
  signal rom2 : romType2 := initRomFromFile2;
  attribute rom_style2 : string;
  attribute rom_style2 of rom2 : signal is "block";
  


begin
process(clk,reset,en)
variable i : integer := 0;
begin
   if(reset = '1') then
    elsif(rising_edge(clk) and en = '1') then
        data_out <= unsigned('0' & ROM(to_integer(unsigned(div) & unsigned(data_in(wl - 1 downto bot)))))  - (((wl - index_width) => '0') & unsigned(ROM2(to_integer(unsigned(div) & unsigned(data_in(wl - 1 downto bot))))));
    end if;
end process;


end Behavioral;
