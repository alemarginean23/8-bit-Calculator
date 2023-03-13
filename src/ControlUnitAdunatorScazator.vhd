library IEEE;
use IEEE.STD_LOGIC_1164.all; 

entity ControlUnitAdunatorScazator is
	port(OP, SignA, SignB, AcmpB: in std_logic;
	OPout1, OPout2, SIGNO: out std_logic);
end entity;	

architecture ControlUnitAdunatorScazator_a of ControlUnitAdunatorScazator is
begin
	OPout1 <= (SignA and AcmpB and (not SignB) and (not OP) ) or ( (not SignA) and AcmpB and SignB and (not OP) )  or (SignA and AcmpB and SignB and OP ) or ( (not SignA) and AcmpB and (not SignB) and  OP);
	OPout2 <= ( (not SignA ) and (not AcmpB) and SignB and (not OP) ) or (SignA and (not AcmpB) and (not SignB) and (not OP) ) or (SignA and (not AcmpB) and  SignB and OP ) or ( (not SignA) and (not AcmpB) and (not SignB) and OP );
	SIGNO <= (SignA and (not AcmpB) and (not SignB)) or (OP and AcmpB and (not SignB)) or ((not OP) and AcmpB and  SignB) or (SignA and (not AcmpB) and SignB);
end architecture;