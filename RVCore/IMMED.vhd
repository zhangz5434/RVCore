Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity IMMED is
	Port (
		INSTRUCTION : IN std_logic_vector(31 downto 0);
		IMMEDATE : OUT std_logic_vector(31 downto 0)
	);
End Entity IMMED;

Architecture Behavioral of IMMED is
	Signal TMP : std_logic_vector(11 downto 0);
	Signal TMP2 : std_logic_vector(19 downto 0);
	Signal TMP3 : std_logic_vector(12 downto 0);
Begin
	Process (INSTRUCTION) is
	Begin
		case INSTRUCTION(6 downto 0) is
			when "0110111" => --U TYPE
				IMMEDATE <= INSTRUCTION(31 downto 12) & "000000000000";
			when "0010111" => --U TYPE	
				IMMEDATE <= INSTRUCTION(31 downto 12) & "000000000000";
			when "1101111" => --J TYPE
				TMP2 <= INSTRUCTION(31) & INSTRUCTION(19 downto 12) & INSTRUCTION(20) & INSTRUCTION(30 downto 21);
				IMMEDATE <= std_logic_vector(resize(signed(TMP2),32));
			when "1100111" => --I TYPE
				TMP <= INSTRUCTION(31 downto 20);
				IMMEDATE <= std_logic_vector(resize(signed(TMP),32));
			when "1100011" => --B Type
				TMP3 <= INSTRUCTION(31) & INSTRUCTION(7) & INSTRUCTION(30 downto 25) & INSTRUCTION (11 downto 8) & '0';
				IMMEDATE <= std_logic_vector(resize(signed(TMP3),32));
			when "0000011" => --I TYPE
				TMP <= INSTRUCTION(31 downto 20);
				IMMEDATE <= std_logic_vector(resize(signed(TMP),32));
			when "0100011" => --S TYPE
				TMP <= INSTRUCTION(31 downto 25) & INSTRUCTION(11 downto 7);
				IMMEDATE <= std_logic_vector(resize(signed(TMP),32));
			when "0010011" => --I TYPE
				case INSTRUCTION(14 downto 12) is
					when "001" =>
						IMMEDATE <= "000000000000000000000000000" & INSTRUCTION(24 downto 20);
					when "101" =>
						IMMEDATE <= "000000000000000000000000000" & INSTRUCTION(24 downto 20);
					when others =>
						TMP <= INSTRUCTION(31 downto 20);
						IMMEDATE <= std_logic_vector(resize(signed(TMP),32));
				end case;
			when others =>
				IMMEDATE <= "00000000000000000000000000000000";
		end case;
	End Process;
End Architecture Behavioral;