library IEEE;
use IEEE.STD_logic_1164.all;
use IEEE.STD_logic_unsigned.all; 
use IEEE.numeric_std.all;			 

entity ChooseOperationAndReturnResult is
	port(A, B: in std_logic_vector(7 downto 0);
	OPS1, OPS2, STATE2, STATE1, SIGNA, SIGNB: in std_logic;
	CLK, RST: in std_logic;
	result, rezaO, rezsO, rezmO, rezdO, result_localO: out std_logic_vector(7 downto 0);
	SIGNO: out std_logic);
end entity;

architecture ChooseOperationAndReturnResult_a of ChooseOperationAndReturnResult is

component mux41_8BIT is
	port(S1, S2: in std_logic;
	I1, I2, I3, I4: in std_logic_vector(7 downto 0);
	O1: out std_logic_vector(7 downto 0));
end component;

component bit_adder_8 is
	port( A: in std_logic_vector (7 downto 0);
	B: in std_logic_vector (7 downto 0);
	rez: out std_logic_vector(7 downto 0);
	carry_O: out std_logic);
end component;

component bit_subtractor_8 is
	port( A: in std_logic_vector (7 downto 0);
	B: in std_logic_vector (7 downto 0);
	rez: out std_logic_vector(7 downto 0);
	borrow_O: out std_logic);
end component;

component multiplication is
	port( X: in std_logic_vector (7 downto 0);
		Y: in std_logic_vector (7 downto 0);
		CLK, RST: in std_logic;
		rez: out std_logic_vector(7 downto 0);
		carryM: out std_logic);
end component;

component division is
	port( X: in std_logic_vector (7 downto 0);
		Y: in std_logic_vector (7 downto 0);
		CLK, RST: in std_logic;
		rez: out std_logic_vector(7 downto 0));
end component;

component mux41_1BIT is
	port(S1, S2: in std_logic;
	I1, I2, I3, I4: in std_logic;
	O1: out std_logic);
end component;

component D_FLIP_FLOP_8bit is
	port(D: in std_logic_vector(7 downto 0);
	CLK, RST: in std_logic;
	O: out std_logic_vector(7 downto 0));
end component;	   

component comparator_8bit is
    Port ( A, B : in std_logic_vector(0 to 7);
           GE: out std_logic);
end component;	

component Mux218bit is
	port(S1: in std_logic;
	I1, I2: in std_logic_vector(7 downto 0);
	O1: out std_logic_vector(7 downto 0));
end component; 

component Mux211bit is
	port(S1: in std_logic;
	I1, I2: in std_logic;
	O1: out std_logic);
end component;

component ControlUnitAdunatorScazator is
	port(OP, SignA, SignB, AcmpB: in std_logic;
	OPout1, OPout2, SIGNO: out std_logic);
end component;	

signal reza, rezsaminusb, rezsbminusa, rezm, rezd, result_local, rezultatAdunareScadere, rezultatInmultireImpartire: std_logic_vector(7 downto 0);	
signal carry, borrow, carryM, overflow, reset_local, total_reset, AmaiMareEgalB, OPout1, OPout2, SIGNOfromAdunatorScazator, AUX: std_logic;

begin
	total_reset <= reset_local or RST;					
	AUX <= 	   (SIGNA xor SIGNB)					;
	mux41_1BIT_C: mux41_1BIT port map(STATE2, STATE1, '0', '0', '1', '0', reset_local);			
	comparator_8bit_C: comparator_8bit port map(A, B, AmaiMareEgalB);  
	ControlUnitAdunatorScazator_C: ControlUnitAdunatorScazator port map(OPS2, SIGNA, SIGNB, AmaiMareEgalB, OPout1, OPout2, SIGNOfromAdunatorScazator);
	mux41_8BIT_C2: mux41_8BIT port map(OPout1, OPout2, reza, rezsaminusb, rezsbminusa, x"00", rezultatAdunareScadere);
	mux21_8bit_C: Mux218bit port map(OPS2, rezm, rezd, rezultatInmultireImpartire );
	mux21_8bit_C2: Mux218bit port map(OPS1, rezultatAdunareScadere, rezultatInmultireImpartire, result ); 
	mux21_1bit_C3: Mux211bit port map(OPS1, SIGNOfromAdunatorScazator,AUX , SIGNO );
	
	rezaO <= reza;
	rezmO <= rezm;
	rezdO <= rezd;
	result_localO <= result_local;
	--D_FLIP_FLOP_8bit_C: D_FLIP_FLOP_8bit port map(result_local, CLK, total_reset, result);
	bit_adder_8_C: bit_adder_8 port map(A, B, reza, carry);
	bit_subtractor_8_C: bit_subtractor_8 port map(A, B, rezsaminusb, borrow);	  
	bit_subtractor_8_C2: bit_subtractor_8 port map(B, A, rezsbminusa, borrow);
	multiplication_C: multiplication port map(A, B, CLK, total_reset, rezm, carryM);
	division_C : division port map(A, B, CLK, total_reset, rezd);

end architecture;

	
