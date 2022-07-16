----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.04.2022 13:27:42
-- Design Name: 
-- Module Name: SONF - Behavioral
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

entity SONF is
  Port (clk : in std_logic;
        reset : in std_logic;
        en : in std_logic;
        sample_in : in std_logic_vector(wl-1 downto 0);
        sample_out : out unsigned (wl-1 downto 0)
       );
end SONF;

 architecture Behavioral of SONF is
 
 
 
 
component Configurable_Multiplier_inner is
   Port (clk : in std_logic;
         en : in std_logic; 
         a : in std_logic_vector(wordsize_inner - 1 downto 0);        -- Multiplicand
         b : in std_logic_vector(wordsize_inner - 1 downto 0);        -- Multiplier 
         res : out std_logic_vector(2 * wordsize_inner - 1  downto 0) -- Multiplier
         ); 
 end component;



 
signal R1 : std_logic_vector(2*wl - 1 downto 0):=(others => '0');
signal x : signed(wl - 1 downto 0):=(others => '0');
signal sample_out_aux : signed(wl - 1 downto 0):=(others => '0');

begin


dut: Configurable_Multiplier_inner port map (
        clk => clk,
        en => en,
        a => std_logic_vector(x),
        b => std_logic_vector(x),
        res => R1
); 

process(clk,reset)
begin
    if(reset = '1')then
    elsif(rising_edge(clk) and en = '1') then
        x <= (signed(one_in) - ("00" & abs(signed(sample_in(wl-1 downto 2)))));
        if(sample_in(sample_in'LEFT) = '0') then
            sample_out <= unsigned(signed(one_out)- signed("0" & (R1(2*wl - 2*il downto 2*fl - (wl - 2)))));
        else
            sample_out <= unsigned("0" & R1(2*wl - 2*il downto 2*fl - (wl - 2)));
        end if;
    end if;
end process;


 
end Behavioral;
