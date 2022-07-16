----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2022 09:50:54
-- Design Name: 
-- Module Name: control_Datapath - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_Datapath is
 Port (clk : in std_logic;
       reset : in std_logic;
       sample_in_enable : in STD_LOGIC;
       control : out STD_LOGIC_VECTOR (2 downto 0);
       sample_out_ready : out STD_LOGIC
  );
end control_Datapath;

architecture Behavioral of control_Datapath is

type state_type is (S0, S1, S2, S3, S4, idle);
signal current_state, next_state : state_type := idle;

begin


process(clk,reset)
begin
    if(reset ='1') then
        current_state <= idle;
    elsif(rising_edge(clk)) then
        current_state <= next_state;
    end if;
end process;



process(current_state, sample_in_enable)
begin
sample_out_ready <= '0';
next_state <= current_state;
    case current_state is
        when idle => 
            control <= "101";
            if (sample_in_enable = '1') then
                next_state <= S0;
            else
                next_state <= idle;
            end if;
        when S0 =>
            control <= "000";
            next_state <= S1;
        when S1 =>
            control <= "001";
            next_state <= S2;
        when S2 =>
            control <= "010";
            next_state <= S3;
        when S3 =>
            control <= "011";
            next_state <= idle;
            sample_out_ready <= '1';
    end case;
end process;


end Behavioral;
