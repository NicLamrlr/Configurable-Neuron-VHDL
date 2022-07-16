    ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2022 10:15:44
-- Design Name: 
-- Module Name: R4BE - Behavioral
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

entity R4BE_inner is
  Port (a : in std_logic_vector(wordsize_inner - 1 downto 0);        -- Multiplicand
        b : in std_logic_vector(wordsize_inner - 1 downto 0);        -- Multiplier 
        res : out std_logic_vector(2 * wordsize_inner - 1  downto 0) -- Multiplier
       );
end R4BE_inner;

architecture Behavioral of R4BE_inner is

type s1 is array (0 to wordsize_inner/2 - 1) of std_logic_vector (wordsize_inner  downto 0);
signal pp_array : s1;

type s2 is array (0 to wordsize_inner/2 - 1) of std_logic_vector (wordsize_inner + 3  downto 0);
signal pp_array2 : s2;


type s3 is array (0 to wordsize_inner/2 - 1) of std_logic_vector (2 * wordsize_inner + 3  downto 0);
signal pp_array3 : s3;


signal b_aux : std_logic_vector(wordsize_inner downto 0);
signal res_aux : std_logic_vector( 2 * wordsize_inner  + 1 downto 0);

signal err : std_logic_vector(wordsize_inner - 1 downto 0) := (others => '0');

component pp_gen_inner is
  Port (a : in std_logic_vector(wordsize_inner - 1 downto 0);  -- Multiplicand
        b : in std_logic_vector(2 downto 0);             -- Multiplier 
        err : out std_logic_vector(1 downto 0);          -- Error corection vector 
        pp : out std_logic_vector(wordsize_inner  downto 0)    -- Multiplier
         );
end component;



component sign_extension_trick_inner is
  Port (pp_in : in std_logic_vector(wordsize_inner  downto 0); 
        first : in std_logic;
        pp_out : out std_logic_vector(wordsize_inner + 3 downto 0)
  );
end component;

component R4ABE_adder_inner is
  Port (a : in std_logic_vector(2 * wordsize_inner + 3 downto 0);  -- Accumulator
      b : in std_logic_vector(wordsize_inner + 3  downto 0);  -- Partial Product
      c : out std_logic_vector(2 * wordsize_inner  + 3  downto 0) -- result 
      );
end component;


begin
b_aux <= b & '0';
res_aux <=  pp_array2(wordsize_inner/2 - 1) & err(wordsize_inner - 3 downto 0) ;
dut:for i in 1 to wordsize_inner/2  generate
        g: pp_gen_inner port map ( a => a,
                             b => b_aux(2*i downto 2*i - 2),
                             err => err(2*i - 1 downto 2*i - 2),
                             pp => pp_array(i - 1)
    );    
    s0: if i = 1 generate    
            s: sign_extension_trick_inner port map( pp_in => pp_array(i - 1),
               first => '1',
               pp_out => pp_array2(i - 1)
        ); 
     end generate s0;
    s1: if i > 1 generate    
        s: sign_extension_trick_inner port map( pp_in => pp_array(i - 1),
           first => '0',
           pp_out => pp_array2(i - 1)
    ); 
    end generate s1;  
    
    s2: if i = 1 generate
        s : R4ABE_adder_inner port map ( a => (others => '0'),
                                   b => pp_array2(i - 1),
                                   c => pp_array3(i - 1)
        );    
     end generate s2; 
    s3: if i > 1 and i < wordsize_inner/2 generate
             s : R4ABE_adder_inner port map ( a => pp_array3(i - 2),
                                        b => pp_array2(i - 1),
                                        c => pp_array3(i - 1)
             );    
      end generate s3;
      
    s4: if i = wordsize_inner/2 and neg_inner = 1 generate
                   s : R4ABE_adder_inner port map ( a => pp_array3(i - 2),
                                              b => pp_array2(i - 1),
                                              c => pp_array3(i - 1)
                   );    
    end generate s4;
end generate dut;
res <= std_logic_vector(unsigned(pp_array3(wordsize_inner/2 - 1)(2 * wordsize_inner - 1 downto 0)) + unsigned(err)) when neg_inner = 1 
else std_logic_vector(resize(unsigned(pp_array3(wordsize_inner/2 - 2)(2 * wordsize_inner + 3 downto 2)) + unsigned(res_aux),2 * wordsize_inner));

end Behavioral;
