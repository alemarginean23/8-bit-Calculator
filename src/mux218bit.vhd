library IEEE;
use IEEE.STD_logic_1164.all;
use IEEE.STD_logic_unsigned.all; 
use IEEE.numeric_std.all;			 

entity Mux218bit is
	port(S1: in std_logic;
	I1, I2: in std_logic_vector(7 downto 0);
	O1: out std_logic_vector(7 downto 0));
end entity;

architecture Mux218bit_a of Mux218bit is

begin
	process(S1, I1, I2)
	begin
		if S1 = '0' then
			O1 <= I1;
		else
			O1 <= I2;
		end if;
				
	end process;
end architecture;

	
