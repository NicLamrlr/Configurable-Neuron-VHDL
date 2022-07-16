----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.06.2022 23:32:51
-- Design Name: 
-- Module Name: Batch - Behavioral
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

entity Batch is
 generic  ( initFile : string := "";--Add route data LUT
            initFile2 : string := "");--Add route error LUT
  Port (clk : in std_logic;
      reset : in std_logic;
      en : in std_logic;
      data_in : in std_logic_vector(wl - 1 downto 0);
      data_out : out unsigned(wl - 1 downto 0)
       );
end Batch;




architecture Behavioral of Batch is

signal data_out_aux : unsigned(wl - 1 downto 0);
signal data_in_aux : std_logic_vector(wl - 1 downto 0);

component d_LUT
  generic (initFile : string := "";--Add route data LUT
           initFile2 : string := "");--Add route error LUT
    Port (clk : in std_logic;
          reset : in std_logic;
          en : in std_logic;
          data_in : in std_logic_vector(wl - 1 downto 0);
          data_out : out unsigned(wl - 1 downto 0)
        );
  end component;


begin
       g01: d_LUT   generic map ( initFile => initFile ,
                                  initFile2 => initFile2 )
           port map(
               clk => clk,
               reset => reset,
               en => en,
               data_in => data_in_aux,
               data_out => data_out_aux
               );


data_out <= data_out_aux when data_in(data_in'LEFT) = '0' else unsigned(one_out) - data_out_aux;
data_in_aux <= data_in when data_in(data_in'LEFT) = '0' else not(data_in);

end Behavioral;
