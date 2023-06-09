library IEEE;
use IEEE.STD_logic_1164.all;
use IEEE.STD_logic_unsigned.all; 
use IEEE.numeric_std.all;			 

entity Counter1Sec is
	port(CLK_100: in std_logic;
	FLAG: out std_logic);
end entity;

architecture Counter1Sec_a of Counter1Sec is

begin
	process(CLK_100)
	variable counter_array: std_logic_vector(25 downto 0) := (others=>'0');
	begin
		if CLK_100'event and CLK_100='1' then
			counter_array := counter_array + "1";
		end if;
		FLAG <= counter_array(25);
	end process;
end architecture;

	
