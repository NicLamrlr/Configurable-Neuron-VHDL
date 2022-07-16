----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.06.2022 18:17:29
-- Design Name: 
-- Module Name: neuron - Behavioral
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

entity neuron is     
    generic ( weight_file :  string := "");-- Weight file
  Port (  clk : in std_logic;
          reset : in std_logic;
          sample_in_enable : in std_logic;
          en : in std_logic;
          d_in : in inputs;
          sample_out_ready : out std_logic;
          d_out : out unsigned(wordsize - 1 downto 0)
      );
end neuron;

architecture Behavioral of neuron is



type w is array (0 to n-1) of std_logic_vector (wordsize-1 downto 0);

 impure function initRomFromFile return w is --Sigmoid values LUT
  file data_file : text open read_mode is weight_file;
  variable data_fileLine : line;
  variable weights : w;
 begin
  for I in w'range loop
   readline(data_file, data_fileLine);
   read(data_fileLine, weights(I));
  end loop;
  return weights;
 end function;
 signal weights : w := initRomFromFile;
 attribute rom_style : string;
 attribute rom_style of weights : signal is "block";
 
 




component Configurable_Multiplier is
  Port (clk : in std_logic;
        en : in std_logic; 
        a : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplicand
        b : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplier 
        res : out std_logic_vector(2 * wordsize - 1  downto 0) -- Multiplier
        ); 
end component;


component Configurable_Activation_Function is
generic (initFile1 : string ;
         initFile2 : string );
  Port (clk : in std_logic;
        en : in std_logic;
        reset : in std_logic;
        sample_in_enable : in std_logic;
        data_in : in std_logic_vector(wl - 1 downto 0);
        sample_out_ready : out std_logic;
        data_out : out unsigned(wl - 1 downto 0)
    );
end component;



component mult_adder is
  Port (a : in std_logic_vector(2*wordsize - 1 downto 0); -- Accumulator
        b : in std_logic_vector(2*wordsize - 1  downto 0);      -- Multiplication result
        c : out std_logic_vector(2*wordsize - 1 downto 0) -- Result 
    );
end component;



component mult_adder_last is
  Port (a : in std_logic_vector(2*wordsize - 1 downto 0);   -- Accumulator
        b : in std_logic_vector(2*wordsize - 1  downto 0);  -- Multiplication result
        c : out std_logic_vector(wordsize - 1 downto 0)     -- Result 
    );
end component;


type type_mult_out is array (0 to n - 1) of std_logic_vector(2*wordsize - 1   downto 0);
signal mult_out : type_mult_out;

type type_add_out is array (0 to n - 1) of std_logic_vector(2*wordsize - 1    downto 0);
signal add_out : type_add_out;



signal in_af : std_logic_vector(wordsize - 1 downto 0);
signal out_reg : unsigned(wordsize - 1 downto 0);

begin
dut:for i in 0 to n - 1  generate
    g1: Configurable_Multiplier port map (
        clk => clk,
        en => en,
        a => std_logic_vector(d_in(i)),
        b => weights(i),
        res => mult_out(i)
        ); 
--    g2:if i = 0 generate
    
--        g02: mult_adder
--         port map (
--                a => (others => '0'),
--                b => mult_out(i),
--                c => add_out(i)
--                );
--    end generate g2;
    
--    g3:if i > 0  generate
--        g03: mult_adder
--        port map (
--                a => add_out(i - 1),
--                b => mult_out(i),
--                c => add_out(i)
--                );
--    end generate g3;
    
--    g4: if i = n-1 generate
--        g04: mult_adder_last
--                port map (
--                        a => add_out(i - 1),
--                        b => mult_out(i),
--                        c => in_af 
--                        );
--    end generate g4;


end generate dut;

 m1:mult_adder
    port map (
            a => mult_out(0),
            b => mult_out(1),
            c => add_out(1)
            );
 m2:mult_adder
   port map (
           a => mult_out(2),
           b => mult_out(3),
           c => add_out(2)
           );
  m3:mult_adder
 port map (
         a => mult_out(4),
         b => mult_out(5),
         c => add_out(3));
  m4:mult_adder
       port map (
               a => mult_out(6),
               b => mult_out(7),
               c => add_out(4)
               );
               
   m5:mult_adder
port map (
        a => add_out(1),
        b => add_out(2),
        c => add_out(5)
        );
  m6:mult_adder
    port map (
         a => mult_out(3),
         b => mult_out(4),
         c => add_out(6)
         );
         
   m7:mult_adder_last
   port map (
        a => add_out(5),
        b => add_out(6),
        c => in_af
        );

dut2: Configurable_Activation_Function 
generic map (initFile1 => "C:\Users\Nicolas\Desktop\TFG\MATLAB\Neuron_test\LUT1_neuron.txt",
             initFile2 => "C:\Users\Nicolas\Desktop\TFG\MATLAB\Neuron_test\LUT2_neuron.txt")
  Port map (
            clk => clk,
            en => en,
            reset => reset,
            sample_in_enable => sample_in_enable,
            data_in => in_af,
            sample_out_ready => sample_out_ready,
            data_out => out_reg
                 ); 
                 
                 
 process(clk,reset,en)
 begin
 if(reset = '1') then
 elsif(rising_edge(clk) and en = '1')then
    d_out <= out_reg;
 end if;
 end process;
end Behavioral;
