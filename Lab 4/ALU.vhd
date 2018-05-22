--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	signal output : std_logic_vector(31 downto 0);

begin
with dir & shamt select
		dataout <= 
					 "0" & datain(31 downto 1) when "100001",
					 "00" & datain(31 downto 2) when "100010",
				         "000" & datain(31 downto 3) when "100011",
					 datain(30 downto 0) & "0" when "000001",
					 datain(29 downto 0) & "00" when "000010",
					 datain(28 downto 0) & "000" when "000011",
					 datain when others;
			 
end architecture shifter;
--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;
-------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is

component fulladder
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end component;
Signal Carry: std_logic_vector(32 downto 0);
Signal B : std_logic_vector(31 downto 0);
begin
co <= Carry(32);
Carry(0) <= add_sub;
	-- insert code here
with add_sub select
	B <= datain_b when '0',
	     NOT(datain_b) when '1',
	     "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;

	Adder : for i in 31 downto 0 generate
		Add: fulladder port map(datain_a(i), B(i), Carry(i), dataout(i), Carry(i + 1));
	end generate;
end calc;
---------------------------------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

Signal addResult, shiftData, shiftResult, andResult, orResult, resultCopy: std_logic_vector(31 downto 0);
Signal carryOut, dataSelect : std_logic;
Signal shiftAmount : std_logic_vector(4 downto 0);
begin
shiftAmount <= "000" & ALUCtrl(1 downto 0);
dataSelect <= ALUCtrl(4);
with dataSelect select
shiftData <= DataIn1 when '0',
DataIn2 when others;

with ALUCtrl select
	ALUResult <= 	addResult when "00000",
			addResult when "00001",
			andResult when "00010",
			orResult  when "00011",
		        shiftResult when "01000", -- shift 0 bits
			shiftResult when "01001", -- 1 bit left
			shiftResult when "01010", -- 2 bits left
			shiftResult when "01011", -- 3 bits left
			shiftResult when "01100", -- 0 bits right
			shiftResult when "01101", -- 1 bit right
			shiftResult when "01110", -- 2 bits right
			shiftResult when "01111", -- 3 bits right
			shiftResult when "11000", -- shift 0 bits
			shiftResult when "11001", -- 1 bit left
			shiftResult when "11010", -- 2 bits left
			shiftResult when "11011", -- 3 bits left
			shiftResult when "11100", -- 0 bits right
			shiftResult when "11101", -- 1 bit right
			shiftResult when "11110", -- 2 bits right
			shiftResult when "11111", -- 3 bits right
			DataIn2 when"10000",
			"00000000000000000000000000000000" when others;

with ALUCtrl select
	resultCopy <= 	addResult when "00000",
			addResult when "00001",
			andResult when "00010",
			orResult  when "00011",
		        shiftResult when "01000",
			shiftResult when "01001",
			shiftResult when "01010",
			shiftResult when "01011",
			shiftResult when "01100",
			shiftResult when "01101",
			shiftResult when "01110",
			shiftResult when "01111",
			DataIn2 when"10000",
			"00000000000000000000000000000000" when others;

with resultCopy select
Zero <= '1' when "00000000000000000000000000000000",
	'0' when others;


Adder : adder_subtracter port map (DataIn1, DataIn2, ALUCtrl(0), addResult, carryOut);
Shift : shift_register port map (shiftData, ALUCtrl(2), shiftAmount, shiftResult);
andResult <= DataIn1 AND DataIn2;
orResult <= DataIn1 OR DataIn2;
	-- Add ALU VHDL implementation here

end architecture ALU_Arch;


