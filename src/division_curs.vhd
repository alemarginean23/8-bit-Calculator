library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;

--A = acumulator pentru rezultate intermediare si pentru restul R (8 biti)
--B = registru pentru deimpartitul X si pentru rezultatul final Q (8 biti)
-- C = registru pentru impartitorul Y (8 biti)
-- F = indicator de sfarsit al impartirii (1 bit)
-- I = registru index (3 biti)	

entity divide is
	port(X: in std_logic_vector(7 downto 0);
	Y: in std_logic_vector(7 downto 0);
	clk: in std_logic;
	Q: out std_logic_vector(7 downto 0);
	R: out std_logic);
end entity;

architecture divide_a of divide is
signal A: std_logic_vector(7 downto 0);	  
signal B: std_logic_vector(7 downto 0);
signal C: std_logic_vector(7 downto 0);	 
signal I: std_logic_vector(2 downto 0);
signal F, E: std_logic;
begin
	
	process(X, Y)
	begin
		F <= '1';
		if(E = '0') then
			F <= '1';
		elsif (E ='1') then
			A <= "00000000";
			B <= X;
			C <= Y;
			F <= '0';
			I <= "000";
			
			end if;
	end process;
	
end architecture;

