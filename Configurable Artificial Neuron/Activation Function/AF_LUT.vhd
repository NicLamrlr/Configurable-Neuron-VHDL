----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.06.2022 12:41:56
-- Design Name: 
-- Module Name: AF_LUT - Behavioral
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

entity AF_LUT is
generic (initFile : string := ""); --Add route data LUT
  Port (clk : in std_logic;
       reset : in std_logic;
       en : in std_logic;
       data_in : in std_logic_vector(wl - 1 downto 0);
       data_out : out unsigned(wl - 1 downto 0)
    );
end AF_LUT;

architecture Behavioral of AF_LUT is

type romType is array(0 to ((2**wl)/2 - 1)) of std_logic_vector(wl - 2 downto 0);

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


begin

process(clk,reset)
begin
    if(reset = '1') then
    
    elsif(rising_edge(clk) and en = '1') then
         if(data_in(data_in'LEFT) = '0') then
            data_out <= unsigned('0' & ROM(to_integer(unsigned(data_in))));
         else
            data_out <= unsigned(one_out) -  unsigned('0' & ROM(to_integer(unsigned(not(data_in)))));
         end if;
    end if;
end process;

end Behavioral;
