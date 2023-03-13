library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity comparator_8bit is
    Port ( A, B : in std_logic_vector(0 to 7);
           GE: out std_logic);
end comparator_8bit;			  

architecture comparator_8bit_a of comparator_8bit is
begin
	process(A, B)
	begin
		if A>=B then
			GE <= '0';
		else
			GE <= '1';
		end if;
	end process;

end architecture;