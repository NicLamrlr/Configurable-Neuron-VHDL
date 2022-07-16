----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2022 09:25:29
-- Design Name: 
-- Module Name: datapath_Sigmoid - Behavioral
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
use work.package_Activation_Function.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath_Sigmoid is
  Port (  clk : in std_logic;
          reset : in std_logic;
          mid : in std_logic;
          sample_in : in signed (wl - 1 downto 0);
          sample_out_ready : in STD_LOGIC;
          control : in STD_LOGIC_VECTOR (2 downto 0);
          y : out signed (wl - 1 downto 0)
 );
end datapath_Sigmoid;

architecture Behavioral of datapath_Sigmoid is

component MUX is
 Port ( in0 : in signed(2*wl - 1 downto 0);
        in1 : in signed(2*wl - 1 downto 0);
        in2 : in signed(2*wl - 1 downto 0);
        in3 : in signed(2*wl - 1 downto 0);
        ctrl : in std_logic_vector(2 downto 0);
        output : out signed(2*wl - 1 downto 0)
 );
end component;


signal mx1,mx2,mx3,mx4, min10,min11,min12,min13, min20,min21,min22,min23, min30,min31,min32,min33, min40,min41,min42,min43 : signed(11 downto 0) := (others => '0');
signal sample_in_aux : signed(11 downto 0) := (others => '0');
signal R1,R1_next : signed (23 downto 0) := (others => '0');
signal R2, R2_next : signed (11 downto 0) := (others => '0');
signal R3 : signed (2*wl - 1 downto 0) := (others => '0');

begin

process(mid, sample_in_aux, sample_in,R1, R1_next, R3,R2, control)
begin
if(mid = '1') then -- value in midrange
--MUX1 ins
    min10 <= sample_in_aux;
    min11 <= R1(4*wl - 4 downto 13);
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
    min41 <= R1_next(4*wl - 4 downto 13);
    min42 <= R1_next(4*wl - 4 downto 13);
    min43 <= R1_next(4*wl - 4 downto 13);            
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
    min40 <= R1_next(4*wl - 4 downto 13);
    min41 <= R1_next(4*wl - 4 downto 13);
    min42 <= R1_next(4*wl - 4 downto 13);
    min43 <= R1_next(4*wl - 4 downto 13);
end if;

end process;



M1 : MUX port map(
    in0 => min10,
    in1 => min11,
    in2 => min12,
    in3 => min13,
    ctrl => control,
    output => mx1
);

M2 : MUX port map(
    in0 => min20,
    in1 => min21,
    in2 => min22,
    in3 => min23,
    ctrl => control,
    output => mx2
);

M3 : MUX port map(
    in0 => min30,
    in1 => min31,
    in2 => min32,
    in3 => min33,
    ctrl => control,
    output => mx3
);
M4 : MUX port map(
    in0 => min40,
    in1 => min41,
    in2 => min42,
    in3 => min43,
    ctrl => control,
    output => mx4
);




process(clk,reset)
begin
    if(reset = '1') then
        R1 <= (others => '0');
        R2 <= (others => '0');
    elsif(rising_edge(clk)) then
        if control = "101" then
            R1 <= (others => '0');
            R2 <= (others => '0');
        else
            R1 <= R1_next;
            R2 <= R2_next;
        end if;
        
    end if;
end process;

R1_next <= (mx1 * mx2);
R2_next <= mx3 + mx4;
R3 <= R1_next (4*wl - 4 downto 13) when control = "000" and mid = '1' else "0010000000000000" - R2 when control = "100" and mid = '0' else (others => '0');

y <= R2(2*wl - 1 downto wl) when sample_out_ready = '1' and (mid = '1' or sample_in(wl - 1) = '0') else R3(2*wl - 1 downto wl) when sample_out_ready = '1';
sample_in_aux <= sample_in & "00000000" when mid = '1' or sample_in(wl - 1) = '0' else not(sample_in) & "00000000" ;

end Behavioral;
