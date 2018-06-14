--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
		In0, In1: in std_logic_vector(31 downto 0);
		Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
	with selector select
		Result <= In0 when '0',
			  In1 when others;
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode  : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch  : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc  : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ImmGen  : out STD_LOGIC_VECTOR(1 downto 0));
end Control;

architecture Boss of Control is
signal control: std_logic_vector(10 downto 0);
begin
-- Add your code here
	with funct3 & opcode select branch <=
		"01" when "0001100011",  --BEQ
		"10" when "0011100011",  --BNE
		"00" when others;

	with funct3 & opcode select MemtoReg <=
		'1' when "0100000011",  --LW
		'0' when others;

	with funct3 & opcode select MemWrite <=
		'1' when "0100100011",  --SW
		'0' when others;
	
--	
--	with opcode&funct3 select RegWrite <=
--		'0' when "0100011010",
--		'0' when "1100011000", 
--		'0' when "1100011001",
--		(not clk) when others;

	RegWrite <= '0' when funct3 = "010" AND opcode = "0100011" else  --SW
		    '0' when funct3 = "000" AND opcode = "1100011" else  --BEQ
		    '0' when funct3 = "001" AND opcode = "1100011" else  --BNE
		    (not clk);

	ALUSrc <= '1' when funct3="000" AND opcode = "0010011" else  --ADDI
		  '1' when funct3="111" AND opcode = "0010011" else  --ANDI
		  '1' when funct3="110" AND opcode = "0010011" else  --ORI
	          '1' when funct3="010" AND opcode = "0100011" else  --SW
		  '1' when funct3="001" AND opcode = "0010011" else -- SLLI
		  '1' when funct3="101" AND opcode = "0010011" else -- SRLI
		  '1' when opcode="0110111" else  --LUI
		  '0';

	ImmGen <= "00" when funct3="000" AND opcode = "0010011" else  --ADDI
		  "00" when funct3="111" AND opcode = "0010011" else  --ANDI
		  "00" when funct3="110" AND opcode = "0010011" else  --ORI
		  "00" when funct3="010" AND opcode = "0000011" else  --LW
		  "01" when funct3="010" AND opcode = "0100011" else  --SW
		  "10" when funct3="000" AND opcode = "1100011" else  --BEQ
		  "10" when funct3="001" AND opcode = "1100011" else  --BNE
		  "11" when opcode = "0110111" 	                else  --LUI
		  "00" when funct7="0000000" AND funct3="001" AND opcode="0010011" else  --SLLI
		  "00" when funct7="0000000" AND funct3="101" AND opcode="0010011" else  --SRLI
		  "00";
--
	ALUCtrl <= "00000" when funct7= "0000000" AND funct3= "000" AND opcode = "0110011" else  --Add
		   "00001" when funct7= "0100000" AND funct3= "000" AND opcode = "0110011" else  --Sub
		   "00011" when funct7= "0000000" AND funct3= "111" AND opcode = "0110011" else  --And
	 	   "00101" when funct7= "0000000" AND funct3= "110" AND opcode = "0110011" else  --Or
		   "00110" when funct7= "0000000" AND funct3= "001" AND opcode = "0110011" else  --SLL
		   "10110" when funct7= "0000000" AND funct3= "101" AND opcode = "0110011" else  --SRL
		   "00110" when funct7= "0000000" AND funct3= "001" AND opcode = "0010011" else  --SLLI
		   "10110" when Funct7= "0000000" AND funct3= "101" AND opcode = "0010011" else  --SRLI
		   "00010" when funct3= "000" AND opcode = "0010011" else  --ADDI
		   "00100" when funct3= "111" AND opcode = "0010011" else  --ANDI
		   "00111" when funct3= "110" AND opcode = "0010011" else  --ORI
		   "00000" when funct3= "010" AND opcode = "0000011" else  --LW
	           "00000" when funct3= "010" AND opcode = "0100011" else  --SW
	           "00001" when funct3= "000" AND opcode = "1100011" else  --BEQ
		   "00001" when funct3= "001" AND opcode = "1100011" else  --BNE
		   "01111" when opcode		         = "0110111" else  --LUI
		   "ZZZZZ";		
		
	
end Boss;
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity imm_gen is
    Port(input:  in  std_logic_vector(31 downto 0);
	 immbits: in  std_logic_vector(1  downto 0);
	 output: out std_logic_vector(31 downto 0));
end entity imm_gen;

architecture arch of imm_gen is
begin

--	with immbits & input(31) select output <=
--		"11111111111111111111" & input(31 downto 20) when "001",
--		"00000000000000000000" & input(31 downto 20) when "000",
--		"11111111111111111111" & input(31 downto 25)&input(11 downto 7) when "011",
--		"00000000000000000000" & input(31 downto 25)&input(11 downto 7)	when "010",
--		"1111111111111111111" & input(31)&input(7)&input(30 downto 25)&input(11 downto 8)&'0' when "101",
--		"0000000000000000000" & input(31)&input(7)&input(30 downto 25)&input(11 downto 8)&'0' when "100",
--		"111111111111"	       & input(31 downto 12) when 	"111",
--		"000000000000"	       & input(31 downto 12) when       "110",
--		"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;


	output <= X"00000"&input(31 downto 20) when (immbits = "00" and input(31) = '0') else  --I-types
		  X"FFFFF"&input(31 downto 20) when (immbits = "00" and input(31) = '1') else

		  X"00000"&input(31 downto 25)&input(11 downto 7) when (immbits = "01" and input(31) = '0') else  --S
		  X"FFFFF"&input(31 downto 25)&input(11 downto 7) when (immbits = "01" and input(31) = '1') else 

		  X"0000" &"000"&input(31)&input(7)&input(30 downto 25)&input(11 downto 8)&'0' when (immbits = "10" and input(31) = '0') else  --B
		  X"FFFF" &"111"&input(31)&input(7)&input(30 downto 25)&input(11 downto 8)&'0' when (immbits = "10" and input(31) = '1') else

		  '0' & input(30 downto 12) & X"000" when (immbits = "11" and input(31) = '0')  else  --U
		  '1' & input(30 downto 12) & X"000" when (immbits = "11" and input(31) = '1')  else
		  
		  (others => 'Z');
end arch;
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is
signal new_address: std_logic_vector(31 downto 0);
begin
-- Add your code here
process(Clock, Reset, new_address)
	begin
	if (Reset = '1') then
		new_address <= X"00400000";
	end if;
	if (falling_edge(Clock)) then
		new_address <= PCin;
	end if;
	if (rising_edge(Clock)) then
		PCOut <= new_address;
	end if;
end process;
end executive;
--------------------------------------------------------------------------------