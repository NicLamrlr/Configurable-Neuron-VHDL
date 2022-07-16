----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.06.2022 13:41:57
-- Design Name: 
-- Module Name: wrapper - Behavioral
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

entity wrapper is
  Port (  clk : in std_logic;
        reset : in std_logic;
        sample_in_enable : in std_logic;
        en : in std_logic;
        d_in : in inputs;
        sample_out_ready : out std_logic;
        d_out : out unsigned(wordsize - 1 downto 0)
    );
end wrapper;

architecture Behavioral of wrapper is


component neuron is     
    generic ( weight_file :  string := "C:\Users\Nicolas\Desktop\TFG\MATLAB\Neuron_test\weights_data_neuron.txt");-- Weight file
  Port (  clk : in std_logic;
          reset : in std_logic;
          sample_in_enable : in std_logic;
          en : in std_logic;
          d_in : in inputs;
          sample_out_ready : out std_logic;
          d_out : out unsigned(wordsize - 1 downto 0)
      );
end component;


  signal reset_reg: std_logic;
  signal en_reg: std_logic;
  signal sample_in_enable_reg: std_logic;
  signal d_in_reg: inputs;
  signal sample_out_ready_next: std_logic;
  signal d_out_next: unsigned(wordsize - 1 downto 0) ;

begin


 uut: neuron generic map ( weight_file      => "C:\Users\Nicolas\Desktop\TFG\MATLAB\Neuron_test\weights_data_neuron.txt" )
                 port map ( clk              => clk,
                            reset            => reset_reg,
                            en               => en_reg,
                            sample_in_enable => sample_in_enable_reg ,
                            d_in             => d_in_reg,
                            sample_out_ready => sample_out_ready_next,
                            d_out            => d_out_next );
                            
                            
                           
 process(clk)
begin
    if(rising_edge(clk)) then
        reset_reg <= reset;
        en_reg <= en;
        sample_in_enable_reg <= sample_in_enable;
        d_in_reg <= d_in;
        sample_out_ready <= sample_out_ready_next;
        d_out <= d_out_next;
    end if;
end process;


end Behavioral;
