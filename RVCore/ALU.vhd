Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
--RV32I ALU CORE VHDL By zhangz
--2020/02/21
Entity ALU is
	Port (
		INPUT_A : IN std_logic_vector(31 downto 0);
		INPUT_B : IN std_logic_vector(31 downto 0);
		OPERATION : IN std_logic_vector(3 downto 0);
		BRANCH_OPTION : IN std_logic_vector(2 downto 0);
		BRANCH : IN std_logic;
		BRANCH_RESULT : OUT std_logic;
		CALC_RESULT : OUT std_logic_vector(31 downto 0)
	);
End Entity ALU;

Architecture Behavioral of ALU is
	Signal TMP : std_logic_vector(32 downto 0);
Begin
	Process(INPUT_A,INPUT_B,OPERATION,TMP,BRANCH,BRANCH_OPTION) is
	Begin
		TMP <= "000000000000000000000000000000000";
		if BRANCH = '1' then
			case BRANCH_OPTION is
				when "000" => --Branch if Equal
					TMP <= std_logic_vector('0' &(INPUT_A xor INPUT_B));
					if TMP = "000000000000000000000000000000000" then
						BRANCH_RESULT <= '1';
					else
						BRANCH_RESULT <= '0';
					end if;
				when "001" => --Branch if not Equal
					TMP <= std_logic_vector('0' &(INPUT_A xor INPUT_B));
					if TMP = "000000000000000000000000000000000" then
						BRANCH_RESULT <= '0';
					else
						BRANCH_RESULT <= '1';
					end if;
				when "100" => --Branch less than
					TMP <= std_logic_vector(signed(INPUT_A(31) & INPUT_A) - signed(INPUT_B(31) & INPUT_B));
					if (TMP(32) = '1') then
						BRANCH_RESULT <= '1';
					else
						BRANCH_RESULT <= '0';
					end if;
				when "101" => --Branch greater than equal
					TMP <= std_logic_vector(signed(INPUT_A(31) & INPUT_A) - signed(INPUT_B(31) & INPUT_B));
					if (TMP(32) = '0') then
						BRANCH_RESULT <= '1';
					else
						BRANCH_RESULT <= '0';
					end if;

				when "110" => --Branch less than unsigned
					TMP <= std_logic_vector(unsigned('0' & INPUT_A) - unsigned('0' & INPUT_B));
					if (TMP(32) = '1') then
						BRANCH_RESULT <= '1';
					else
						BRANCH_RESULT <= '0';
					end if;

				when "111" => --Branch greater than equal unsigned
					TMP <= std_logic_vector(unsigned('0' & INPUT_A) - unsigned('0' & INPUT_B));
					if (TMP(32) = '0') then
						BRANCH_RESULT <= '1';
					else
						BRANCH_RESULT <= '0';
					end if;
				when others =>
					BRANCH_RESULT <= '0';
			end case;
		else
			BRANCH_RESULT <= '0';
			case OPERATION is
				when "0000" => --ADD
					TMP <= std_logic_vector(signed(INPUT_A(31) & INPUT_A) + signed(INPUT_B(31) & INPUT_B));
					CALC_RESULT <= TMP(31 downto 0);
				when "1000" => --SUB
					TMP <= std_logic_vector(signed(INPUT_A(31) & INPUT_A) - signed(INPUT_B(31) & INPUT_B));
					CALC_RESULT <= TMP(31 downto 0);
				when "0001" => --Shift Left
					CALC_RESULT <= std_logic_vector(shift_left(unsigned(INPUT_A), to_integer(unsigned(INPUT_B))));
				when "0010" => --Set less than
					TMP <= std_logic_vector(signed(INPUT_A(31) & INPUT_A) - signed(INPUT_B(31) & INPUT_B));
					if (TMP(32) = '1') then
						CALC_RESULT <= "00000000000000000000000000000001";
					else
						CALC_RESULT <= "00000000000000000000000000000000";
					end if;
				when "0011" => --Set less than unsigned
					TMP <= std_logic_vector(unsigned('0' & INPUT_A) - unsigned('0' & INPUT_B));
					if (TMP(32) = '1') then
						CALC_RESULT <= "00000000000000000000000000000001";
					else
						CALC_RESULT <= "00000000000000000000000000000000";
					end if;
				when "0100" => --xor
					CALC_RESULT <= INPUT_A XOR INPUT_B;
				when "0101" => -- shift right logical
					CALC_RESULT <= std_logic_vector(shift_right(unsigned(INPUT_A), to_integer(unsigned(INPUT_B))));
				when "1101" => --shift right arithmetic
					CALC_RESULT <= std_logic_vector(shift_right(signed(INPUT_A), to_integer(unsigned(INPUT_B))));
				when "0110" => -- or
					CALC_RESULT <= INPUT_A OR INPUT_B;
				when "0111" => --and
					CALC_RESULT <= INPUT_A AND INPUT_B;
				when others =>
					CALC_RESULT <= "00000000000000000000000000000000";
			end case;
		end if;
	End Process;
End Architecture Behavioral;