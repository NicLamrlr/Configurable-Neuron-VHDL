----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.03.2022 18:26:30
-- Design Name: 
-- Module Name: R4BE_Serial - Behavioral
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

entity R4BE_Serial is
Port (clk : in std_logic;
      a : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplicand
      b : in std_logic_vector(wordsize - 1 downto 0);        -- Multiplier 
      en : in std_logic;                                     -- New data
      res : out std_logic_vector(2 * wordsize - 1  downto 0) -- Multiplier
);
end R4BE_Serial;

architecture Behavioral of R4BE_Serial is
signal triplet : std_logic_vector(2 downto 0):= (others => '0');
signal b_reg, b_next : std_logic_vector(wordsize  downto 0) := (others => '0');
signal pp_aux : std_logic_vector(wordsize downto 0):= (others => '0');
signal pp_out_aux : std_logic_vector(wordsize + 3 downto 0):= (others => '0');
signal first_aux : std_logic:= '0';

    
signal tmp_reg,tmp_next : std_logic_vector(2 * wordsize + 3  downto 0) := (others => '0');
        alias tmpu_reg : std_logic_vector(wordsize + 3  downto 0) is tmp_reg(2 * wordsize + 3  downto wordsize);
        alias tmpl_reg : std_logic_vector(wordsize - 1  downto 0) is tmp_reg(wordsize - 1  downto 0);



type state_type is (idle, S0);
signal current_state, next_state : state_type := idle;

signal count_reg,count_next : unsigned(wordsize  downto 0) := (others => '0');



signal err_aux : std_logic_vector(1 downto 0):= (others => '0');
signal err_reg, err_next : std_logic_vector(wordsize - 1 downto 0) := (others => '0');
signal suma, sumb, sumres : unsigned(2*wordsize+3 downto 0) := (others => '0');

component pp_gen is
  Port (a : in std_logic_vector(wordsize - 1 downto 0);  -- Multiplicand
        b : in std_logic_vector(2 downto 0);             -- Multiplier 
        err : out std_logic_vector(1 downto 0);          -- Error corection vector 
        pp : out std_logic_vector(wordsize  downto 0)    -- Multiplier
         );
end component;


component sign_extension_trick is
  Port (pp_in : in std_logic_vector(wordsize  downto 0); 
        first : in std_logic;
        pp_out : out std_logic_vector(wordsize + 3 downto 0)
  );
end component;



begin
dut:pp_gen port map ( a => a,
                  b => triplet,
                  err => err_aux,
                  pp => pp_aux
    );
    
dut2:sign_extension_trick port map ( pp_in => pp_aux,
                                     first => first_aux,
                                     pp_out => pp_out_aux
        ); 
          



process(clk)
begin
    if(rising_edge(clk)) then
        b_reg <= b_next;
        err_reg <= err_next;
        current_state <= next_state;
        count_reg <= count_next;
        tmp_reg <= tmp_next;
    end if;
end process;

process(b_reg, err_reg, en, err_aux, current_state, count_reg, tmp_reg, pp_out_aux, suma, sumb,sumres)
begin
next_state <= current_state;
b_next <= b_reg;
count_next <= count_reg;
suma <= (others =>'0');
sumb <= (others =>'0');
res <= (others =>'0');


case(current_state) is
    when idle =>
        if(en = '1') then
            b_next <= b & '0';
            err_next <= (others => '0');
            tmp_next <= (others => '0');
            next_state <= S0;
        else
            next_state <= idle;
        end if;
        when S0 =>
            count_next <= count_reg + 1;
            b_next <= "00" & b_reg(wordsize  downto 2);
            triplet <= b_reg(2 downto 0);
            err_next <= err_aux & err_reg(wordsize - 1 downto 2);
            
            if(count_reg = 0) then
                first_aux <= '1';
            else
                first_aux <= '0';
            end if;
            
            if(count_reg = wordsize/2) then                    
                b_next <= b & '0';
                err_next <= (others => '0');
                tmp_next <= (others => '0');
                count_next <= (others => '0');
                suma <= unsigned(tmp_reg);
                sumb(wordsize - 1 downto 0)  <= unsigned(err_reg);
                res <= std_logic_vector(sumres(2 * wordsize - 1 downto 0));
            else
                suma  <= unsigned(tmp_reg);
                sumb(2*wordsize+3 downto wordsize)  <= unsigned(pp_out_aux);                         
                tmp_next <= '0' & '0' & std_logic_vector(sumres(2*wordsize+3 downto 2)) ;
            end if;
            if (en = '1') then 
                next_state <= S0;
            else
                next_state <= idle;
            end if;
    end case;
    
end process;

sumres <= suma + sumb;

end Behavioral;
