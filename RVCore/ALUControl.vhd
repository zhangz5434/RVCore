Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity ALUControl is
	Port(
		ALUOp : IN std_logic_vector(3 downto 0);
		INST30 : IN std_logic;
		FUNC : IN std_logic_vector(2 downto 0)
		
	);
End Entity ALUControl;

Architecture Behavioral of ALUControl is
Begin
	Process(INST30,ALUOp,FUNC) is
	Begin
		
	End Process;
End Architecture Behavioral;