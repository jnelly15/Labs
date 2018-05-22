--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);
	

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Start testing the ALU
		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"11223344";
		control  <= "00000";		-- Control in binary (ADD and ADDI test)
		wait for 50 ns;				-- result = 0x124578AB  and zeroOut = 0 			
		control <= "00001";             -- Test ADD and ADDI for negative numbers.
		wait for 50 ns;				-- result = 0xF0011223
		control <= "00010";		-- Test AND result = 0x01220144
		wait for 50 ns;				
		control <= "00011";		-- Test OR result = 0x11237767
		wait for 50 ns;				
		datain_a <= X"00004004";  -- Test the shift register
		control <= "01001"; -- by 1 bits should be 0x00008008
		wait for 50 ns; 
		control <= "01010";  -- by 2 bits should be 0x00010010
		wait for 50 ns; 
		control <= "01011"; -- by 3 bits should be 0x00020020
		wait for 50 ns; 
		control <= "01101"; -- by 1 bits should be 0x00002002
		wait for 50 ns; 
		control <= "10000"; -- Test Pass: Result = 0x11223344
		wait for 50 ns;
		control <= "11001";

		wait; -- will wait forever
	END PROCESS;

END;