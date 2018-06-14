--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
               opcode : in  STD_LOGIC_VECTOR (6 downto 0);
               funct3 : in  STD_LOGIC_VECTOR (2 downto 0);
               funct7 : in  STD_LOGIC_VECTOR (6 downto 0);
               Branch : out  STD_LOGIC_VECTOR(1 downto 0);
               MemRead  : out  STD_LOGIC;
               MemtoReg : out  STD_LOGIC;
               ALUCtrl  : out  STD_LOGIC_VECTOR(4 downto 0);
               MemWrite : out  STD_LOGIC;
               ALUSrc   : out  STD_LOGIC;
               RegWrite : out  STD_LOGIC;
               ImmGen   : out STD_LOGIC_VECTOR(1 downto 0));
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset: in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0));
	end component;
	
	component ProgramCounter
	    	Port(Reset: in std_logic;
		     Clock: in std_logic;
		     PCin: in std_logic_vector(31 downto 0);
		     PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(datain_a: in std_logic_vector(31 downto 0);
		     datain_b: in std_logic_vector(31 downto 0);
		     add_sub: in std_logic;
		     dataout: out std_logic_vector(31 downto 0);
		     co: out std_logic);
	end component adder_subtracter;

	component imm_gen
	  	port(input:  in  std_logic_vector(31 downto 0);
	 	     immbits: in  std_logic_vector(1  downto 0);
	 	     output: out std_logic_vector(31 downto 0));
	end component;
	
	signal sPCin, sPCout, sPCplus, sPCjump, sInstruct, sImm, sWrite, sD1, sD2, muxtoALU, sALUout, sMemout: std_logic_vector(31 downto 0);
	signal sALUCtrl: std_logic_vector(4 downto 0);
	signal sBranch, sImmGen: std_logic_vector(1 downto 0);
	signal dummy, conJump, sMemRead, sMemtoReg, sMemWrite, sALUSrc, sRegWrite, sZero,dummy2: std_logic;
	signal random: std_logic_vector(29 downto 0);

begin
	-- Add your code here
	PC: ProgramCounter port map(reset, clock, sPCin, sPCout);
	
	IR: InstructionRAM port map(reset, clock, sPCout(31 downto 2), sInstruct);

	--Advances PC by 4
	A4: adder_subtracter port map(sPCout, X"00000004",'0', sPCplus, dummy);

	--Advances PC by Imm
	AX: adder_subtracter port map(sPCout, sImm,'0', sPCjump, dummy2);

	--Logic for PC advance
	with sZero&sBranch select conJump <=
		'0' when "000",
		'0' when "100",
		'1' when "101",
		'0' when "001",
		'1' when "010",
		'0' when "110",
		'0' when others;
	
	--PC Mux
	PM: BusMux2to1 port map(conjump, sPCplus, sPCjump, sPCin);

	--Control Module
	CM: Control port map(clock, sInstruct(6 downto 0), sInstruct(14 downto 12), sInstruct(31 downto 25), sBranch, sMemRead, sMemtoReg, sALUCtrl, sMemWrite, sALUSrc, sRegWrite, sImmGen);

	--Imediate generator
	IG: imm_gen port map(sInstruct, sImmGen, sImm);

	--Registers
	RG: Registers port map(sInstruct(19 downto 15), sInstruct(24 downto 20), sInstruct(11 downto 7), sWrite, sRegWrite, sD1, sD2);

	--Register Mux
	AL: BusMux2to1 port map(sALUSrc, sD2, sImm, muxtoALU);
	
	--Main ALU
	AS: ALU port map(sD1, muxtoALU,sALUctrl, sZero, sALUout);

	random <= "0000" & sALUout(27 downto 2);

	--Data Mem
	DM: Ram port map(reset, clock, sMemRead, sMemWrite, random, sD2, sMemout);

	--Last Mux
	LM: BusMux2to1 port map(sMemtoReg, sALUout, sMemout, sWrite);
	


end holistic;