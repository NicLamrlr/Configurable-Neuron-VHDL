----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.05.2022 12:12:56
-- Design Name: 
-- Module Name: Taylor_datapath - Behavioral
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

entity Taylor_datapath is
  Port (  clk : in std_logic;
          reset : in std_logic;
          mid : in std_logic;
          sample_in : in std_logic_vector (wl - 1 downto 0);
          sample_out_ready : in STD_LOGIC;
          control : in STD_LOGIC_VECTOR (2 downto 0);
          y : out unsigned (wl - 1 downto 0)
);
end Taylor_datapath;

architecture Behavioral of Taylor_datapath is

component MUX_4x1 is
 Port ( in0 : in signed(cwl - 1 downto 0);
        in1 : in signed(cwl - 1 downto 0);
        in2 : in signed(cwl - 1 downto 0);
        in3 : in signed(cwl - 1 downto 0);
        ctrl : in std_logic_vector(2 downto 0);
        output : out signed(cwl - 1 downto 0)
);
end component;


component Configurable_Multiplier_inner is
  Port (clk : in std_logic;
        en : in std_logic; 
        a : in std_logic_vector(wordsize_inner - 1 downto 0);        -- Multiplicand
        b : in std_logic_vector(wordsize_inner - 1 downto 0);        -- Multiplier 
        res : out std_logic_vector(2 * wordsize_inner - 1  downto 0) -- Multiplier
        ); 
end component;




signal mx1,mx2,mx3,mx4, min10,min11,min12, min13, min20, min21, min22, min23, min30, min31, min32, min33, min40, min41 , min42, min43 : signed(cwl - 1 downto 0) := (others => '0');
signal R1,R1_next : std_logic_vector (2*cwl - 1 downto 0) := (others => '0');
signal R2, R2_next : signed (cwl - 1 downto 0) := (others => '0');
signal R3, R3_next: signed (cwl - 1 downto 0) := (others => '0');
signal sample_in_aux : signed(cwl - 1 downto 0) := (others => '0');


begin

M1 : MUX_4x1 port map(
    in0 => min10,
    in1 => min11,
    in2 => min12,
    in3 => min13,
    ctrl => control,
    output => mx1
);

M2 : MUX_4x1 port map(
    in0 => min20,
    in1 => min21,
    in2 => min22,
    in3 => min23,
    ctrl => control,
    output => mx2
);

M3 : MUX_4x1 port map(
    in0 => min30,
    in1 => min31,
    in2 => min32,
    in3 => min33,
    ctrl => control,
    output => mx3
);

M4 : MUX_4x1 port map(
    in0 => min40,
    in1 => min41,
    in2 => min42,
    in3 => min43,
    ctrl => control,
    output => mx4
);


dut: Configurable_Multiplier_inner port map (
        clk => clk,
        en => '1',
        a => std_logic_vector(mx1),
        b => std_logic_vector(mx2),
        res => R1_next
); 



process(mid, sample_in, sample_in_aux, R1, R1_next, R2, R3)
begin
if(mid = '1') then -- value in midrange
--MUX1 ins
    min10 <= sample_in_aux;
    min11 <= R3;
    min12 <= R3;
    min13 <= sample_in_aux;
--MUX2 ins
    min20 <= sample_in_aux;
    min21 <= CT4M;
    min22 <= R2;
    min23 <= R2;
--MUX3 ins
    min30 <= (others => '0');
    min31 <= CT3M;
    min32 <= CT2M;
    min33 <= CT1M;
--MUX4 ins
    min40 <= (others => '0');
    min41 <= signed(R1_next(R1_next'left)  &   R1_next(R1_next'left-il downto 2*fl + 1)); 
    min42 <= signed(R1_next(R1_next'left)  &   R1_next(R1_next'left-il downto 2*fl + 1));   
    min43 <= signed(R1_next(R1_next'left)  &   R1_next(R1_next'left-il downto 2*fl + 1));      
    
    --Using library multiplier  
--    min40 <= (others => '0');
--    min41 <= signed(R1_next(R1_next'left)  & R1_next(R1_next'left-il-1 downto 2*fl)); 
--    min42 <= signed(R1_next(R1_next'left)  & R1_next(R1_next'left-il-1 downto 2*fl));     
--    min43 <= signed(R1_next(R1_next'left)  & R1_next(R1_next'left-il-1 downto 2*fl)); 
    
else  -- value on the sides
--MUX1 ins
    min10 <= sample_in_aux;
    min11 <= sample_in_aux;
    min12 <= sample_in_aux;
    min13 <= sample_in_aux;
--MUX2 ins
    min20 <= CT5S;
    min21 <= R2;
    min22 <= R2;
    min23 <= R2;
--MUX3 ins
    min30 <= CT4S;
    min31 <= CT3S;
    min32 <= CT2S;
    min33 <= CT1S; 
    
--MUX4 ins 
    min40 <= signed(R1_next(R1_next'left)  &   R1_next(R1_next'left-il downto 2*fl + 1)); 
    min41 <= signed(R1_next(R1_next'left)  &   R1_next(R1_next'left-il downto 2*fl + 1)); 
    min42 <= signed(R1_next(R1_next'left)  &   R1_next(R1_next'left-il downto 2*fl + 1));  
    min43 <= signed(R1_next(R1_next'left)  &   R1_next(R1_next'left-il downto 2*fl + 1)); 
    
    --Using library multiplier  
--        min40 <= signed(R1_next(R1_next'left)  & R1_next(R1_next'left-il-1 downto 2*fl)); 
--        min41 <= signed(R1_next(R1_next'left)  & R1_next(R1_next'left-il-1 downto 2*fl)); 
--        min42 <= signed(R1_next(R1_next'left)  & R1_next(R1_next'left-il-1 downto 2*fl));     
--        min43 <= signed(R1_next(R1_next'left)  & R1_next(R1_next'left-il-1 downto 2*fl));
        
end if;

end process;



process(clk,reset)
begin
    if(reset = '1') then
        R1 <= (others => '0');
        R2 <= (others => '0');
        R3 <= (others => '0');
    elsif(rising_edge(clk)) then
        if control = "111" then
            R1 <= (others => '0');
            R2 <= (others => '0');
            R3 <= (others => '0');
        else
            R1 <= R1_next;
            R2 <= R2_next;
            R3 <= R3_next;
        end if;
        
    end if;
end process;

--Using library multiplier
--R1_next <= std_logic_vector(mx1 * mx2);

--Using library multiplier
--R3 <= signed(R1_next(R1_next'left- il downto 2*fl))  when control = "000";




R2_next <= mx3 + mx4;
R3_next <= signed(R1_next(R1_next'left- il + 1 downto 2*fl + 1))  when control = "000";
y <= unsigned(R2_next(R2_next'LEFT downto (cwl - wl))) when sample_out_ready = '1'  and (mid = '1' or sample_in(sample_in'left) = '0') else unsigned(signed(one_out) - signed(R2_next(R2_next'LEFT downto (cwl - wl)))) when sample_out_ready = '1' else (others => '0'); 


sample_in_aux <=  signed(sample_in & correction)  when (mid = '1' or sample_in(wl - 1) = '0') else signed(not(sample_in) & correction)  ;


end Behavioral;
