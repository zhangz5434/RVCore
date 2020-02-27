Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use work.all;
Entity MMU is
	Port(
		DATA : IN std_logic_vector(31 downto 0);
		ADDRESS : IN std_logic_vector(31 downto 0);
		LOAD : IN std_logic;
		OPTION : IN std_logic_vector(2 downto 0);
		CLOCK : IN std_logic;
		OUTPUT : OUT std_logic_vector(31 downto 0)
	);
End Entity MMU;

Architecture Behavioral of MMU is
	SIGNAL LOADED : std_logic_vector(3 downto 0);
	SIGNAL MEM_IN_0 : std_logic_vector(7 downto 0);
	SIGNAL MEM_IN_1 : std_logic_vector(7 downto 0);
	SIGNAL MEM_IN_2 : std_logic_vector(7 downto 0);
	SIGNAL MEM_IN_3 : std_logic_vector(7 downto 0);
	SIGNAL MEM_OUT_0 : std_logic_vector(7 downto 0);
	SIGNAL MEM_OUT_1 : std_logic_vector(7 downto 0);
	SIGNAL MEM_OUT_2 : std_logic_vector(7 downto 0);
	SIGNAL MEM_OUT_3 : std_logic_vector(7 downto 0);
	SIGNAL MEM_ADDR : std_logic_vector(31 downto 0);
	SIGNAL BYTEPOS : std_logic_vector(1 downto 0) := "00";
Begin
	ReadRAM : Process (DATA,ADDRESS,LOAD,BYTEPOS,OPTION,MEM_OUT_0,MEM_OUT_1,MEM_OUT_2,MEM_OUT_3)
	Begin
		BYTEPOS <= ADDRESS(1 downto 0);
		MEM_ADDR <= std_logic_vector(shift_right(unsigned(ADDRESS),2));
		if LOAD = '1' then --write to memory
			case OPTION is
				when "010" => --load word
					if BYTEPOS = "00" then --aligned
						LOADED <= "1111";
						MEM_IN_0 <= DATA(7 downto 0);
						MEM_IN_1 <= DATA(15 downto 8);
						MEM_IN_2 <= DATA(23 downto 16);
						MEM_IN_3 <= DATA(31 downto 24);
					else
						LOADED <= "0000";
						MEM_IN_0 <= "00000000";
						MEM_IN_1 <= "00000000";
						MEM_IN_2 <= "00000000";
						MEM_IN_3 <= "00000000";
					end if;
				when "001" => --half word
					if BYTEPOS = "00" then
						LOADED <= "0011";
						MEM_IN_0 <= DATA(7 downto 0);
						MEM_IN_1 <= DATA(15 downto 8);
						MEM_IN_2 <= "00000000";
						MEM_IN_3 <= "00000000";
					elsif BYTEPOS = "10" then
						LOADED <= "1100";
						MEM_IN_0 <= "00000000";
						MEM_IN_1 <= "00000000";
						MEM_IN_2 <= DATA(23 downto 16);
						MEM_IN_3 <= DATA(31 downto 24);
					else
						LOADED <= "0000";
						MEM_IN_0 <= "00000000";
						MEM_IN_1 <= "00000000";
						MEM_IN_2 <= "00000000";
						MEM_IN_3 <= "00000000";
					end if;
				when "000" => --byte
					if BYTEPOS = "00" then
						LOADED <= "0001";
						MEM_IN_0 <= DATA(7 downto 0);
						MEM_IN_1 <= "00000000";
						MEM_IN_2 <= "00000000";
						MEM_IN_3 <= "00000000";
					elsif BYTEPOS = "01" then
						LOADED <= "0010";
						MEM_IN_0 <= "00000000";
						MEM_IN_1 <= DATA(15 downto 8);
						MEM_IN_2 <= "00000000";
						MEM_IN_3 <= "00000000";
					elsif BYTEPOS = "10" then
						LOADED <= "0100";
						MEM_IN_0 <= "00000000";
						MEM_IN_1 <= "00000000";
						MEM_IN_2 <= DATA(23 downto 16);
						MEM_IN_3 <= "00000000";
					else
						LOADED <= "1000";
						MEM_IN_0 <= "00000000";
						MEM_IN_1 <= "00000000";
						MEM_IN_2 <= "00000000";
						MEM_IN_3 <= DATA(31 downto 24);
					end if;
				when others =>
					LOADED <= "0000";
					MEM_IN_0 <= "00000000";
					MEM_IN_1 <= "00000000";
					MEM_IN_2 <= "00000000";
					MEM_IN_3 <= "00000000";
			end case;
		else -- read from memory
			LOADED <= "0000";
			case OPTION is
				when "010" => --word
					if BYTEPOS = "00" then
						OUTPUT <= std_logic_vector(MEM_OUT_3 & MEM_OUT_2 & MEM_OUT_1 & MEM_OUT_0);
					else
						OUTPUT <= "00000000000000000000000000000000";
					end if;
				when "001" => --signed half word
					if BYTEPOS = "00" then
						OUTPUT <= std_logic_vector(shift_right(signed(std_logic_vector(MEM_OUT_1 & MEM_OUT_0 & "0000000000000000")), 16));
					elsif BYTEPOS = "10" then
						OUTPUT <= std_logic_vector(shift_right(signed(std_logic_vector(MEM_OUT_3 & MEM_OUT_2 & "0000000000000000")), 16));
					else
						OUTPUT <= "00000000000000000000000000000000";
					end if;
				when "101" => --unsigned half word
					if BYTEPOS = "00" then
						OUTPUT <= std_logic_vector("0000000000000000" & MEM_OUT_1 & MEM_OUT_0);
					elsif BYTEPOS = "10" then
						OUTPUT <= std_logic_vector("0000000000000000" & MEM_OUT_3 & MEM_OUT_2);
					else
						OUTPUT <= "00000000000000000000000000000000";
					end if;
				when "000" => --signed byte
					if (BYTEPOS = "00") then
						OUTPUT <= std_logic_vector(shift_right(signed(std_logic_vector(MEM_IN_0 & "000000000000000000000000")), 24));
					elsif (BYTEPOS = "01") then
						OUTPUT <= std_logic_vector(shift_right(signed(std_logic_vector(MEM_IN_1 & "000000000000000000000000")), 24));
					elsif (BYTEPOS = "10") then
						OUTPUT <= std_logic_vector(shift_right(signed(std_logic_vector(MEM_IN_2 & "000000000000000000000000")), 24));
					else
						OUTPUT <= std_logic_vector(shift_right(signed(std_logic_vector(MEM_IN_3 & "000000000000000000000000")), 24));
					end if;
				when "100" => --unsigned byte
					if (BYTEPOS = "00") then
						OUTPUT <= std_logic_vector("000000000000000000000000" & MEM_IN_0);
					elsif (BYTEPOS = "01") then
						OUTPUT <= std_logic_vector("000000000000000000000000" & MEM_IN_1);
					elsif (BYTEPOS = "10") then
						OUTPUT <= std_logic_vector("000000000000000000000000" & MEM_IN_2);
					else
						OUTPUT <= std_logic_vector("000000000000000000000000" & MEM_IN_3);
					end if;
				when others =>
					OUTPUT <= "00000000000000000000000000000000";
			end case;
		end if;
	End Process;
	RAMUnit0: RAMPart PORT MAP (MEM_ADDR(9 downto 0),clock,MEM_IN_0,LOADED(0),MEM_OUT_0);
	RAMUnit1: RAMPart PORT MAP (MEM_ADDR(9 downto 0),clock,MEM_IN_1,LOADED(1),MEM_OUT_1);
	RAMUnit2: RAMPart PORT MAP (MEM_ADDR(9 downto 0),clock,MEM_IN_2,LOADED(2),MEM_OUT_2);
	RAMUnit3: RAMPart PORT MAP (MEM_ADDR(9 downto 0),clock,MEM_IN_3,LOADED(3),MEM_OUT_3);
End Architecture Behavioral;