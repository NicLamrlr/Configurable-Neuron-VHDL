----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2022 19:48:49
-- Design Name: 
-- Module Name: sigmoid_LUT - Behavioral
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
use ieee.std_logic_textio.all;
use std.textio.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sigmoid_LUT is
  Port (clk : in std_logic;
        en : in std_logic;
        reset : in std_logic;
        data_in : in std_logic_vector(wl - 1 downto 0);
        sample_out_ready : out STD_LOGIC;
        data_out : out std_logic_vector(wl - 1 downto 0)
        );
end sigmoid_LUT;

architecture Behavioral of sigmoid_LUT is


signal data_in_aux : std_logic_vector(wl - 1 downto 0) := (others => '0');
signal data_out_aux : std_logic_vector(wl - 1 downto 0) := (others => '0');
signal ready_lut : std_logic;
signal enaux : std_logic;

component RALUT is
generic (initFile : string := "C:\Users\Nicolas\Desktop\TFG\MATLAB\Sigmoid_LUT.txt";
         initFile2 : string := "C:\Users\Nicolas\Desktop\TFG\MATLAB\index_LUT.txt");
  Port (clk : in std_logic;
        en : in std_logic;
        reset : in std_logic;
        data_in : in std_logic_vector(wl - 1 downto 0);
        sample_out_ready : out STD_LOGIC;
        data_out : out std_logic_vector(wl - 1 downto 0)
      );
end component;

begin
dut:RALUT port map (clk => clk,
                    en => enaux,
                    reset => reset,
                    data_in => data_in_aux,
                    sample_out_ready =>ready_lut,
                    data_out => data_out_aux
    );

data_in_aux <= data_in when data_in(data_in'left) = '0' else not(data_in);
data_out <= data_out_aux when (ready_lut = '1' and data_in(data_in'left) = '0') else std_logic_vector("10000000" -  unsigned(data_out_aux)) when ready_lut = '1';
sample_out_ready <= ready_lut;
enaux <= '1';
end Behavioral;
