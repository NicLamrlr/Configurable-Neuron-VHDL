----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2022 16:45:07
-- Design Name: 
-- Module Name: Booth_Low_Area - Behavioral
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

entity pp_gen_inner is
  Port (a : in std_logic_vector(wordsize_inner - 1 downto 0);  -- Multiplicand
        b : in std_logic_vector(2 downto 0);             -- Multiplier 
        err : out std_logic_vector(1 downto 0);          -- Error corection vector 
        pp : out std_logic_vector(wordsize_inner  downto 0)    -- Multiplier
         );
end pp_gen_inner;

architecture Behavioral of pp_gen_inner is

component M1_inner is
  Port (a1 : in std_logic;
        a2 : in std_logic;
        b1 : in std_logic;
        b2 : in std_logic;
        b3 : in std_logic;
        pp : out std_logic);
end component;


component M2_inner is
  Port (a : in std_logic;
        b1 : in std_logic;
        b2 : in std_logic;
        b3 : in std_logic;
        pp : out std_logic);
end component;


component M3_inner is
  Port (a : in std_logic;
        b1 : in std_logic;
        b2 : in std_logic;
        b3 : in std_logic;
        pp : out std_logic);
end component;


begin



dut:for i in 0 to wordsize_inner  generate

    g3: if i = 0 and precision_inner = 3 generate
        g: M1_inner port map (     a1 => '0',
                             a2 => a(i),
                             b1 => b(0),
                             b2 => b(1),
                             b3 => b(2),
                             pp => pp(i)
        );
    end generate g3;
    gn3: if i>0 and i < wordsize_inner and precision_inner = 3 generate
        g: M1_inner port map (  a1 => a(i - 1),
                             a2 => a(i),
                             b1 => b(0),
                             b2 => b(1),
                             b3 => b(2),
                             pp => pp(i)
    );
    end generate gn3; 
    
    g3l: if i =  wordsize_inner and precision_inner = 3 generate
        g: M1_inner port map (  a1 => a(i - 1),
                             a2 => a(i - 1),
                             b1 => b(0),
                             b2 => b(1),
                             b3 => b(2),
                             pp => pp(i)
    );
    end generate g3l; 
    
    gn2: if i < wordsize_inner and precision_inner = 2 generate
        g: M2_inner port map( a => a(i),
                        b1 => b(0),
                        b2 => b(1),
                        b3 => b(2),
                        pp => pp(i)
        );
    end generate gn2;
    
    g2l: if i = wordsize_inner and precision_inner = 2 generate
        g: M2_inner port map( a => a(i - 1),
                        b1 => b(0),
                        b2 => b(1),
                        b3 => b(2),
                        pp => pp(i)
            );
     end generate g2l; 
     
     gn1: if i < wordsize_inner and precision_inner = 1 generate
         g: M3_inner port map( a => a(i),
                         b1 => b(0),
                         b2 => b(1),
                         b3 => b(2),
                         pp => pp(i)
         );
     end generate gn1;
     
     g1l: if i = wordsize_inner and precision_inner = 1 generate
         g: M3_inner port map( a => a(i - 1),
                         b1 => b(0),
                         b2 => b(1),
                         b3 => b(2),
                         pp => pp(i)
             );
      end generate g1l;    
end generate dut;

err <= '0' & ((b(2) and not(b(1))) or (b(2) and not (b(0))));

end Behavioral;
