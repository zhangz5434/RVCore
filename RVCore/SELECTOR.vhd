Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity SELECTOR is
	Port(
		ALUI : IN std_logic_vector(31 downto 0);
		MEMI : IN std_logic_vector(31 downto 0);
		RETN : IN std_logic_vector(31 downto 0);
		PICK : IN std_logic_vector(1 downto 0);
		RESULT : OUT std_logic_vector(31 downto 0)
	);
End Entity SELECTOR;

Architecture Behavioral of SELECTOR is
Begin
	Process(ALUI,MEMI,RETN,PICK) is
	Begin
		if PICK = "00" then
			RESULT <= ALUI;
		elsif PICK = "01" then
			RESULT <= MEMI;
		elsif PICK = "10" then
			RESULT <= RETN;
		else
			RESULT <= "00000000000000000000000000000000";
		end if;
	End Process;
End Architecture Behavioral;