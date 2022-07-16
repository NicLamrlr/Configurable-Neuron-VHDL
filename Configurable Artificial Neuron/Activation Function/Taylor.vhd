----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.05.2022 12:10:42
-- Design Name: 
-- Module Name: Taylor - Behavioral
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

entity Taylor is
  Port (clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        sample_in : in std_logic_vector (wl-1 downto 0);
        sample_in_enable : in STD_LOGIC;
        sample_out : out unsigned (wl-1 downto 0);
        sample_out_ready : out STD_LOGIC);
end Taylor;

architecture Behavioral of Taylor is

signal s_out_ready : std_logic;
signal mid : std_logic;
signal control : STD_LOGIC_VECTOR (2 downto 0);




component Taylor_control is
 Port (clk : in std_logic;
       reset : in std_logic;
       sample_in_enable : in STD_LOGIC;
       control : out STD_LOGIC_VECTOR (2 downto 0);
       sample_out_ready : out STD_LOGIC
  );
end component;


component Taylor_datapath is
  Port (  clk : in std_logic;
          reset : in std_logic;
          mid : in STD_LOGIC;
          sample_in : in std_logic_vector (wl - 1 downto 0);
          sample_out_ready : in STD_LOGIC;
          control : in STD_LOGIC_VECTOR (2 downto 0);
          y : out unsigned (wl - 1 downto 0)
 );
end component;

begin
ctrls : Taylor_control port map(
            clk => clk,
            reset => reset,
            sample_in_enable => sample_in_enable,
            control => control,
            sample_out_ready => s_out_ready 
); 


dpaths : Taylor_datapath port map(
            clk => clk,
            reset => reset,
            mid => mid,
            sample_in => sample_in,
            sample_out_ready => s_out_ready,
            control => control,
            y => sample_out
); 

sample_out_ready <= s_out_ready;
mid <= '1' when (signed(sample_in) > lowlimit and signed(sample_in) < highlimit) else '0';


end Behavioral;
