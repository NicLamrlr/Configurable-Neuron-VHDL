----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.06.2022 12:34:41
-- Design Name: 
-- Module Name: Configurable_Activation_Function - Behavioral
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

entity Configurable_Activation_Function is
generic (initFile1 : string := ""; --Add route data LUT
         initFile2 : string := "");--Add route error LUT
  Port (clk : in std_logic;
        en : in std_logic;
        reset : in std_logic;
        sample_in_enable : in std_logic;
        data_in : in std_logic_vector(wl - 1 downto 0);
        sample_out_ready : out std_logic;
        data_out : out unsigned(wl - 1 downto 0)
    );
end Configurable_Activation_Function;

architecture Behavioral of Configurable_Activation_Function is










component AF_LUT is
generic (initFile : string);
  Port (clk : in std_logic;
       reset : in std_logic;
       en : in std_logic;
       data_in : in std_logic_vector(wl - 1 downto 0);
       data_out : out unsigned(wl - 1 downto 0)
    );
end component;


component Taylor is
  Port (clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        sample_in : in std_logic_vector (wl-1 downto 0);
        sample_in_enable : in STD_LOGIC;
        sample_out : out unsigned (wl-1 downto 0);
        sample_out_ready : out STD_LOGIC);
end component;


component Batch is
 generic  ( initFile : string ;
            initFile2 : string );
  Port (clk : in std_logic;
      reset : in std_logic;
      en : in std_logic;
      data_in : in std_logic_vector(wl - 1 downto 0);
      data_out : out unsigned(wl - 1 downto 0)
       );
end component;



component SONF is
  Port (clk : in std_logic;
        reset : in std_logic;
        en : in std_logic;
        sample_in : in std_logic_vector(wl-1 downto 0);
        sample_out : out unsigned (wl-1 downto 0)
       );
end component;



begin


    g1: if fun = 0 generate
        g01:AF_LUT generic map ( initFile => initFile1 )
            port map(
                clk => clk,
                reset => reset,
                en => en,
                data_in => data_in,
                data_out => data_out
                );
      elsif fun = 1 generate
        g02: Taylor port map(
                    clk => clk,
                    reset => reset,
                    sample_in => data_in,
                    sample_in_enable => sample_in_enable,
                    sample_out => data_out,
                    sample_out_ready => sample_out_ready
                    );
      elsif fun = 2 generate
        g03: SONF port map(
                    clk => clk,
                    reset => reset,
                    en   => en,
                    sample_in => data_in,
                    sample_out => data_out
                    );
      elsif fun = 3 generate
        g03: Batch generic map ( initFile => initFile1 ,
                                 initFile2 => initFile2 ) 
                    port map(
                    clk => clk,
                    reset => reset,
                    en   => en,
                    data_in => data_in,
                    data_out => data_out
                    );
      end generate g1;





end Behavioral;
