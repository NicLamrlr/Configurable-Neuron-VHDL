----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.06.2022 13:26:10
-- Design Name: 
-- Module Name: Configurable_Multiplier - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Configurable_Multiplier is
  Port (clk : in std_logic;
        en : in std_logic; 
        a : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplicand
        b : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplier 
        res : out std_logic_vector(2 * wordsize - 1  downto 0) -- Multiplier
        ); 
end Configurable_Multiplier;

architecture Behavioral of Configurable_Multiplier is


component R4BE is
  Port (a : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplicand
        b : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplier 
        res : out std_logic_vector(2 * wordsize - 1  downto 0) -- Multiplier
       );
end component;


component R4BE_Serial is
Port (clk : in std_logic;
      a : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplicand
      b : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplier 
      en : in std_logic;                                     -- New data
      res : out std_logic_vector(2 * wordsize - 1  downto 0) -- Multiplier
);
end component;



component R4BE_Serial_Neg  is
Port (clk : in std_logic;
      a : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplicand
      b : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplier 
      en : in std_logic;                                     -- New data
      res : out std_logic_vector(2 * wordsize - 1  downto 0) -- Multiplier
);
end component;
begin
dut:for i in 1 to 1  generate
    g1: if serpar = 1 generate
        g01: if neg = 1 generate
            g11: R4BE_Serial port map(
            clk => clk,
            a => a,
            b => b,
            en => en,
            res => res
            );   
        end generate g01;
        g02: if neg = 0 generate
           g11: R4BE_Serial_Neg port map(
           clk => clk,
           a => a,
           b => b,
           en => en,
           res => res
           );   
        end generate g02;
    end generate g1;
    g2: if serpar = 0 generate
        g02: R4BE port map(
            a => a,
            b => b,
            res => res
            );
    end generate g2;
end generate dut;

end Behavioral;
