library IEEE;
use IEEE.STD_logic_1164.all;
use IEEE.STD_logic_unsigned.all; 
use IEEE.numeric_std.all;			 

entity DFF1bit is
	port(D: in std_logic;
	CLK, RST: in std_logic;
	O: out std_logic);
end entity;

architecture DFF1bit_a of DFF1bit is

begin
	process(CLK, RST)
	begin
		if CLK = '1' and CLK'event then
			if RST = '1' then
				O <= '0';
			else
				O <= D;
			end if;
		end if;
				
	end process;
end architecture;

	
