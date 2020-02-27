Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity ControlUnit is
	Port(
		INST : IN std_logic_vector(31 downto 0);
		REGA : OUT std_logic_vector(4 downto 0);
		REGB : OUT std_logic_vector(4 downto 0);
		REGW : OUT std_logic_vector(4 downto 0);
		ALUOP : OUT std_logic_vector(3 downto 0);
		BRANCHOP : OUT std_logic_vector(2 downto 0);
		BRANCH : OUT std_logic;
		JUMP : OUT std_logic;
		REGWRITE : OUT std_logic;
		MEMWRITE : OUT std_logic;
		WBFROM : OUT std_logic_vector(1 downto 0);--00 - alu 01 - mem 10 - return address
		INAISREGA : OUT std_logic; -- 1-rega 0-pc
		INBISREGB : OUT std_logic; -- 1-regb 0-imm
		JUMPBASEISPC : OUT std_logic;
		DATAFORMAT : OUT std_logic_vector(2 downto 0);
		HALT : OUT std_logic
	);
End Entity ControlUnit;

Architecture Behavioral of ControlUnit is
Begin
	Process(INST) is
	Begin
		case INST(6 downto 0) is
			when "0110111" => --LUI
				REGA <= "00000";
				REGB <= "00000";
				REGW <= INST(11 downto 7);
				ALUOP <= "0000";
				BRANCHOP <= "000";
				BRANCH <= '0';
				JUMP <= '0';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				WBFROM <= "00";
				INAISREGA <= '1';
				INBISREGB <= '0';
				JUMPBASEISPC <='0';
				DATAFORMAT <= "000";
				HALT <= '0';
			when "0010111" => --AUIPC
				REGA <= "00000";
				REGB <= "00000";
				REGW <= INST(11 downto 7);
				ALUOP <= "0000";
				BRANCHOP <= "000";
				BRANCH <= '0';
				JUMP <= '0';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				WBFROM <= "00";
				INAISREGA <= '0';
				INBISREGB <= '1';
				JUMPBASEISPC <='0';
				DATAFORMAT <= "000";
				HALT <= '0';
			when "1101111" => --JAL
				REGA <= "00000";
				REGB <= "00000";
				REGW <= INST(11 downto 7);
				ALUOP <= "0000";
				BRANCHOP <= "000";
				BRANCH <= '0';
				JUMP <= '1';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				WBFROM <= "10";
				INAISREGA <= '1';
				INBISREGB <= '1';
				JUMPBASEISPC <='1';
				DATAFORMAT <= "000";
				HALT <= '0';
			when "1100111" => --JALR
				REGA <= INST(19 downto 15);
				REGB <= "00000";
				REGW <= INST(11 downto 7);
				ALUOP <= "0000";
				BRANCHOP <= "000";
				BRANCH <= '0';
				JUMP <= '1';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				WBFROM <= "10";
				INAISREGA <= '1';
				INBISREGB <= '1';
				JUMPBASEISPC <='0';
				DATAFORMAT <= "000";
				HALT <= '0';
			when "1100011" => --BRENCH
				REGA <= INST(19 downto 15);
				REGB <= INST(24 downto 20);
				REGW <= "00000";
				ALUOP <= "0000";
				BRANCHOP <= INST(14 downto 12);
				BRANCH <= '1';
				JUMP <= '0';
				REGWRITE <= '0';
				MEMWRITE <= '0';
				WBFROM <= "00";
				INAISREGA <= '1';
				INBISREGB <= '1';
				JUMPBASEISPC <='1';
				DATAFORMAT <= "000";
				HALT <= '0';
			when "0000011" => --LOAD
				REGA <= INST(19 downto 15);
				REGB <= "00000";
				REGW <= INST(11 downto 7);
				ALUOP <= "0000";
				BRANCHOP <= "000";
				BRANCH <= '0';
				JUMP <= '0';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				WBFROM <= "01";
				INAISREGA <= '1';
				INBISREGB <= '0';
				JUMPBASEISPC <= '0';
				DATAFORMAT <= INST(14 downto 12);
				HALT <= '0';
			when "0100011" => --STORE
				REGA <= INST(19 downto 15);
				REGB <= INST(24 downto 20);
				REGW <= "00000";
				ALUOP <= "0000";
				BRANCHOP <= "000";
				BRANCH <= '0';
				JUMP <= '0';
				REGWRITE <= '0'; 
				MEMWRITE <= '1';
				WBFROM <= "00";
				INAISREGA <= '1';
				INBISREGB <= '0';
				JUMPBASEISPC <= '0';
				DATAFORMAT <= INST(14 downto 12);
				HALT <= '0';
			when "0010011" => --CALCULATE IMMEDATE
				REGA <= INST(19 downto 15);
				REGB <= "00000";
				REGW <= INST(11 downto 7);
				case INST(14 downto 12) is
					when "001" =>	
						ALUOP <= INST(30) & INST(14 downto 12);
					when "101" => 
						ALUOP <= INST(30) & INST(14 downto 12);
					when others =>
						ALUOP <= '0' & INST(14 downto 12);
				end case;
				BRANCHOP <= "000";
				BRANCH <= '0';
				JUMP <= '0';
				REGWRITE <= '1';
				MEMWRITE <= '0'; 
				WBFROM <= "00";
				INAISREGA <= '1';
				INBISREGB <= '0';
				JUMPBASEISPC <= '0';
				DATAFORMAT <= "000";
				HALT <= '0';
			when "0110011" => --CALCULATE
				REGA <= INST(19 downto 15);
				REGB <= INST(24 downto 20);
				REGW <= INST(11 downto 7);
				ALUOP <= INST(30) & INST(14 downto 12);
				BRANCHOP <= "000";
				BRANCH <= '0';
				JUMP <= '0';
				REGWRITE <= '1';
				MEMWRITE <= '0'; 
				WBFROM <= "00";
				INAISREGA <= '1';
				INBISREGB <= '1';
				JUMPBASEISPC <= '0';
				DATAFORMAT <= "000";
				HALT <= '0';
			when "1110011" => --ECALL & EBREAK, HALT
				ALUOP <= "0000";
				BRANCHOP <= "000";
				BRANCH <= '0';
				JUMP <= '0';
				REGWRITE <= '0';
				MEMWRITE <= '0';
				WBFROM <= "00";
				INAISREGA <= '1';
				INBISREGB <= '1';
				JUMPBASEISPC <= '0';
				DATAFORMAT <= "000";
				REGA <= "00000";
				REGB <= "00000";
				REGW <= "00000";
				HALT <= '1';
			when others => --INVALID
				ALUOP <= "0000";
				BRANCHOP <= "000";
				BRANCH <= '0';
				JUMP <= '0';
				REGWRITE <= '0';
				MEMWRITE <= '0';
				WBFROM <= "00";
				INAISREGA <= '1';
				INBISREGB <= '1';
				JUMPBASEISPC <= '0';
				DATAFORMAT <= "000";
				REGA <= "00000";
				REGB <= "00000";
				REGW <= "00000";
				HALT <= '0';
		end case;
	End Process;
End Architecture Behavioral;