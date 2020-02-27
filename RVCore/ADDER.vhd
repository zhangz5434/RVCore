Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity ADDER is
	Port (
		INPUT_A : IN std_logic_vector(31 downto 0);
		INPUT_B : IN std_logic_vector(31 downto 0);
		OUTPUT : OUT std_logic_vector(31 downto 0)
	);
End ADDER;

Architecture Behavioral of ADDER is
	Signal TMP : std_logic_vector (32 downto 0) := "000000000000000000000000000000000";
Begin
	Process (INPUT_A, INPUT_B, TMP) is
	Begin
		TMP <= std_logic_vector(signed(INPUT_A(31) & INPUT_A) + signed(INPUT_B(31) & INPUT_B));
	End Process;
	OUTPUT <= TMP(31 downto 0);
End Architecture Behavioral;