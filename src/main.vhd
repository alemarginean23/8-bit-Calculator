library IEEE;
use IEEE.STD_logic_1164.all;
use IEEE.STD_logic_unsigned.all; 
use IEEE.numeric_std.all;


--HS - switch for hundreds
--DS - switch for decimals
--US - switch for units
--SIGN_S - switch for sign
--OPS1, switch for operations
--OPS2, swtich for operations (least significant bit)
--NEXT_B, next button to change the state
--00 -> ADDITION
--01 -> SUBTRACTION
--10 -> MULTIPLICATION
--11 -> DIVISION
--DArray display selection array
--DNumber what to siaply on currently selected display



entity computer is
	port(CLK_100, HS, DS, US, SIGN_S, OPS1, OPS2, NEXT_B, RST: in std_logic;
	DArray: out std_logic_vector(7 downto 0);
	DNumber: out std_logic_vector(0 to 6);
	rez_o: out std_logic_vector(7 downto 0);
	SIGN_O: out std_logic);
end entity;

architecture computer_a of computer is

component InputNumber is
	port(CLK_1_sec_signal, HS, DS, US, SIGN_S, NEXT_B: in std_logic;
	HD, DD, UD: out std_logic_vector(3 downto 0));
end component; 

component Counter1Sec is
	port(CLK_100: in std_logic;
	FLAG: out std_logic);
end component;

component Counter60HZ is
	port(CLK_100: in std_logic;
	O1, O2, O3: out std_logic);
end component;

component Mux818bit is
	port(S1, S2, S3: in std_logic;
	I1, I2, I3, I4, I5, I6, I7, I8: in std_logic_vector(7 downto 0);
	O1: out std_logic_vector(7 downto 0));
end component;

component Mux418bit is
	port(S1, S2: in std_logic;
	I1, I2, I3, I4: in std_logic_vector(7 downto 0);
	O1: out std_logic_vector(7 downto 0));
end component;

component Mux814bit is
	port(S1, S2, S3: in std_logic;
	I1, I2, I3, I4, I5, I6, I7, I8: in std_logic_vector(3 downto 0);
	O1: out std_logic_vector(3 downto 0));
end component;

component DisplayDecoder is
	port(nr: in std_logic_vector(3 downto 0);
	seven_segment: out std_logic_vector(0 to 6));
end component;

component DetermineSignValueInHex is
	port(SWITCH_POS: in std_logic;
	OUTPUT: out std_logic_vector(3 downto 0));
end component;

component DecimalToBinary is
	port(H, D, U: in std_logic_vector(3 downto 0);
	OUTPUT_NUMBER: out std_logic_vector(7 downto 0));
end component;

component Debouncer is
    Port ( BTN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DET : out STD_LOGIC);
end component;

component ChangeState is
	port(CNT, CLK, RST: in std_logic;
		S2, S1: out std_logic);
end component;

component BinaryToDecimal is
	port(inputNumber: in std_logic_vector(7 downto 0);
	H, D, U: out std_logic_vector(3 downto 0));
end component;

component DFF8bit is
	port(D: in std_logic_vector(7 downto 0);
	CLK, RST: in std_logic;
	O: out std_logic_vector(7 downto 0));
end component;

component DFF1bit is
	port(D: in std_logic;
	CLK, RST: in std_logic;
	O: out std_logic);
end component;

component mux41_1BIT is
	port(S1, S2: in std_logic;
	I1, I2, I3, I4: in std_logic;
	O1: out std_logic);
end component;

component ChooseOperationAndReturnResult is
	port(A, B: in std_logic_vector(7 downto 0);
	OPS1, OPS2, STATE2, STATE1, SIGNA, SIGNB: in std_logic;
	CLK, RST: in std_logic;
	result, rezaO, rezsO, rezmO, rezdO, result_localO: out std_logic_vector(7 downto 0);
	SIGNO: out std_logic);
end component;

type DisplaySelectorType is array (0 to 7) of std_logic_vector(7 downto 0);
signal DSelector:DisplaySelectorType := ("11111110", "11111101", "11111011", "11110111", "11101111", "11011111", "10111111", "01111111");
signal OutDigit, HD, DD, UD: std_logic_vector(3 downto 0);
signal Out_of_60HZ_1, Out_of_60HZ_2, Out_of_60HZ_3, FLAG_1_SEC, STATE1, STATE2, Last_NEXT_B_STATE, SIGNA, SIGNA_DELAYED, SIGNA_AUX, SIGNA_AUX2,  SIGNB, NEXTB_SIGN, SIGN_B_AUX, SIGN_B_AUX2, SIGN_REZ: std_logic;
signal A, A_AUX, A_AUX_2, A_DELAYED, B, B_AUX, B_AUX_2, REZ, THE_INPUT: std_logic_vector(7 downto 0);
signal A_DOUBLE_DABBLE, B_DOUBLE_DABBLE: std_logic_vector(11 downto 0);
signal signValue: std_logic_vector(3 downto 0) :="1010";
signal change_state_signal, not_clock: std_logic;

signal reza, rezs, rezm, rezd, result_local: std_logic_vector(7 downto 0);

begin
	not_clock <= not CLK_100;
	Counter60HZ_C: Counter60HZ port map(CLK_100, Out_of_60HZ_1, Out_of_60HZ_2, Out_of_60HZ_3);
	Counter1Sec_C: Counter1Sec port map(CLK_100, FLAG_1_SEC);
	
	Mux818bit_C: Mux818bit port map(Out_of_60HZ_1, Out_of_60HZ_2, Out_of_60HZ_3, DSelector(0), DSelector(1), DSelector(2), DSelector(3), DSelector(4), DSelector(5), DSelector(6), DSelector(7), DArray);
	Mux814bit_C: Mux814bit port map(Out_of_60HZ_1, Out_of_60HZ_2, Out_of_60HZ_3, A_DOUBLE_DABBLE(11 downto 8), A_DOUBLE_DABBLE(7 downto 4), A_DOUBLE_DABBLE(3 downto 0), signValue, "0000", "0000", "0000", "0000", OutDigit);
	DisplayDecoder_C: DisplayDecoder port map(OutDigit, DNumber);
	DetermineSignValueInHex_C: DetermineSignValueInHex port map(SIGNA, signValue);
	
	InputNumber_C: InputNumber port map(CLK_100, HS, DS, US, SIGN_S, NEXT_B, HD, DD, UD);
	
	BinaryToDecimal_C: BinaryToDecimal port map(A, A_DOUBLE_DABBLE(11 downto 8), A_DOUBLE_DABBLE(7 downto 4), A_DOUBLE_DABBLE(3 downto 0));
	-- A
	DFF8bit_C1: DFF8bit port map(A_AUX, not_clock, RST, A_AUX_2);
	DFF8bit_C2: DFF8bit port map(A, NEXT_B, RST, A_DELAYED);
	Mux418bit_C: Mux418bit port map(STATE2, STATE1, THE_INPUT, THE_INPUT, A_AUX_2, REZ,  A_AUX);
	A <= A_AUX;
	-- B
	DFF8bit_C3: DFF8bit port map(B_AUX, not_clock, RST, B_AUX_2);
	Mux418bit_C2: Mux418bit port map(STATE2, STATE1, "00000000", A_DELAYED, B_AUX_2, B_AUX_2, B_AUX);
	B <= B_AUX;
	
	--SEMN A 
	DFF1bit_C1: DFF1bit port map(SIGNA_AUX, not_clock, RST, SIGNA_AUX2);
	DFF1bit_C2: DFF1bit port map(SIGNA, NEXT_B, RST, SIGNA_DELAYED);
	Mux411bit_C: mux41_1BIT port map(STATE2, STATE1, SIGN_S, SIGN_S, SIGNA_AUX2, SIGN_REZ,  SIGNA_AUX);
	SIGNA <= SIGNA_AUX;
	
	
	--SEMN B
	DFF1bit_C3: DFF1bit port map(SIGN_B_AUX, not_clock, RST, SIGN_B_AUX2);
	Mux411bit_C2: Mux41_1bit port map(STATE2, STATE1, '0', SIGNA_DELAYED, SIGN_B_AUX2, SIGN_B_AUX2, SIGN_B_AUX);
	SIGNB <= SIGN_B_AUX;
	
	DecimalToBinary_C : DecimalToBinary port map(HD, DD, UD, THE_INPUT);
	
	--Debouncer_C: Debouncer port map(NEXT_B, CLK_100, change_state_signal);
	ChangeState_C: ChangeState port map(NEXT_B, CLK_100, RST, STATE2, STATE1);
	
	--Calculator
	ChooseOperationAndReturnResult_C: ChooseOperationAndReturnResult port map(B, A_DELAYED, OPS1, OPS2, STATE2, STATE1, SIGNB, SIGNA_DELAYED,  change_state_signal, RST, REZ, reza, rezs, rezm, rezd, result_local, SIGN_REZ);
	rez_o <= rez;	
	SIGN_O <= SIGN_REZ	 ;
end architecture;

library IEEE;
use IEEE.STD_logic_1164.all;
use IEEE.STD_logic_unsigned.all; 
use IEEE.numeric_std.all;

entity tb is
end entity;

architecture tb_a of tb is 

component computer is
	port(CLK_100, HS, DS, US, SIGN_S, OPS1, OPS2, NEXT_B, RST: in std_logic;
	DArray: out std_logic_vector(7 downto 0);
	DNumber: out std_logic_vector(0 to 6);
	rez_o: out std_logic_vector(7 downto 0);
	SIGN_O: out std_logic);
end component;

signal CLK, HD, DD, UD,  SIGN_S, RST, OPS1, OPS2, NEXT_B, res, SIGN_O: std_logic;
signal DArray, rez:std_logic_vector(7 downto 0);
signal DNumber: std_logic_vector(0 to 6);	

begin
	C1:   computer port map(CLK, HD, DD, UD, SIGN_S, OPS1, OPS2, NEXT_B, Res, DARray, Dnumber,rez, SIGN_O);
process
begin
	wait for 50ns;
	CLK <= '0';
	wait for 50ns;
	CLK <= '1';
end process;
process
begin
	HD <= '0';
	DD<= '0';
	UD<= '0';
	SIGN_S<= '0';
	RST<= '0';
	OPS1<= '0';
	OPS2<= '0';
	NEXT_B<= '0';
	res	<= '0';
   RST<= '1';
   wait for 100ns;
   RST<= '0';
   -- gata cu resetu
   
   wait for 200ns;
   DD<= '0';
   wait for 100ns;
   DD<= '0';
   wait for 200ns;
   UD<='1';
   wait for 300ns;
   UD<='0';
   wait for 200ns;
   NEXT_B<= '1';
   wait for 100ns;
   NEXT_B<= '0';
   wait for 200ns;
   
   -- gata primu numar
  SIGN_S<= '1'; 
   UD<= '1';
   wait for 700ns;
   UD<= '0';
   wait for 200ns;
   NEXT_B<= '1';
   wait for 100ns;
   NEXT_B<= '0';
   wait for 200ns;
   --gata al2lea numar 
   
   --setam operatia
   OPS1<= '1';
   OPS2<= '1';
   wait for 200ns; 
   --00 adunare
   --01 scadere
   --10 inmultire
   --11 impartire
   
   --next sa aflam rezultatul
  NEXT_B<= '1';
   wait for 100ns;
   NEXT_B<= '0';
   wait for 600ns;	
   
  -- SIGN_S<= '1'; 
   --UD<= '1';
   --wait for 700ns;
   --UD<= '0';
   --wait for 200ns;	 
   --NEXT_B<= '1';
   --wait for 100ns;
   --NEXT_B<= '0';
   --wait for 200ns;
    --OPS1<= '0';
   --OPS2<= '1';
   --wait for 200ns;
   	 --NEXT_B<= '1';
  --  wait for 100ns;
  -- NEXT_B<= '0';
  -- wait for 600ns; 
   
end process;
end architecture;