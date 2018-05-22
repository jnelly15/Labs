--------------------------------------------------------------------------------
--
-- Test Bench for LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

ENTITY tMemory_vhd IS
END tMemory_vhd;

ARCHITECTURE behavior OF tMemory_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT RAM
    	    Port(Reset:	  in std_logic;
 		 Clock:	  in std_logic;
		 OE:      in std_logic;
	 	 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	END COMPONENT;

	COMPONENT Registers is
	    Port(ReadReg1:  in std_logic_vector(4 downto 0); 
	         ReadReg2:  in std_logic_vector(4 downto 0); 
	         WriteReg:  in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd:  in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	END COMPONENT;

	--Test signals
	SIGNAL clock :  std_logic := '0';
	SIGNAL reset :  std_logic := '0';
	SIGNAL oe :     std_logic := '1';
	SIGNAL we :     std_logic := '0';
	
	SIGNAL readReg1 : std_logic_vector(4 downto 0);
	SIGNAL readReg2 : std_logic_vector(4 downto 0);
	SIGNAL writeReg : std_logic_vector(4 downto 0);
	SIGNAL writeCmd : std_logic := '0';
 
	SIGNAL address : std_logic_vector(31 downto 0);
	SIGNAL dataIn  : std_logic_vector(31 downto 0);
	SIGNAL dataOut : std_logic_vector(31 downto 0);
	SIGNAL dataOut1 : std_logic_vector(31 downto 0);
	SIGNAL dataOut2 : std_logic_vector(31 downto 0);


BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut1: RAM PORT MAP(
		reset,
		clock,
		oe,
		we,
		address(31 downto 2),
		dataIn,
		dataOut
		);

	uut2: Registers PORT MAP(
		readReg1,
		readReg2,
		writeReg,
		dataIn,
		writeCmd,
		dataOut1,
		dataOut2
		);
	
	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Test RAM by filling in some values
		reset <= '1';	-- Reset RAM module
		wait for 5 ns;
		reset <= '0';
		wait for 5 ns;

		oe  <= '0';

		address <= X"00000000";
		dataIn  <= X"11111111";
		we      <= '1';
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;
		
		address <= X"00000004";
		dataIn  <= X"22222222";
		we      <= '1';
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;
		
		address <= X"00000008";
		dataIn  <= X"33333333";
		we      <= '1';
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;
		
		address <= X"0000000C";
		dataIn  <= X"44444444";
		we      <= '1';
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;
		
		address <= X"00000010";
		dataIn  <= X"55555555";
		we      <= '1';
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;

		address <= X"00000200";
		dataIn  <= X"BAADBEEF";
		we      <= '1';
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;

		-- Read back content
		oe      <= '0';
		we      <= '0';

		address <= X"00000000";
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;

		address <= X"00000001";
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;

		address <= X"00000004";
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;

		address <= X"00000008";
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;

		address <= X"0000000C";
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;

		address <= X"00000010";
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;

		address <= X"00000014";
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;

		address <= X"00000200";
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;

		-- Register Bank tests
		dataIn   <= X"11111111";
		writeReg <= "01010";
		writeCmd <= '1';
		wait for 5 ns;	
		writeCmd <= '0';
		wait for 5 ns;	

		dataIn   <= X"22222222";
		writeReg <= "01011";
		writeCmd <= '1';
		wait for 5 ns;	
		writeCmd <= '0';
		wait for 5 ns;	

		dataIn   <= X"33333333";
		writeReg <= "01100";
		writeCmd <= '1';
		wait for 5 ns;	
		writeCmd <= '0';
		wait for 5 ns;	

		dataIn   <= X"44444444";
		writeReg <= "01101";
		writeCmd <= '1';
		wait for 5 ns;	
		writeCmd <= '0';
		wait for 5 ns;	

		dataIn   <= X"55555555";
		writeReg <= "01110";
		writeCmd <= '1';
		wait for 5 ns;	
		writeCmd <= '0';
		wait for 5 ns;	

		dataIn   <= X"66666666";
		writeReg <= "01111";
		writeCmd <= '1';
		wait for 5 ns;	
		writeCmd <= '0';
		wait for 5 ns;	

		dataIn   <= X"77777777";
		writeReg <= "10000";
		writeCmd <= '1';
		wait for 5 ns;	
		writeCmd <= '0';
		wait for 5 ns;	

		dataIn   <= X"88888888";
		writeReg <= "10001";
		writeCmd <= '1';
		wait for 5 ns;	
		writeCmd <= '0';
		wait for 5 ns;	

		readReg1 <= "00000";
		readReg2 <= "01010";
		wait for 10 ns;	

		readReg1 <= "01011";
		readReg2 <= "01100";
		wait for 10 ns;	

		readReg1 <= "01101";
		readReg2 <= "01110";
		wait for 10 ns;	

		readReg1 <= "01111";
		readReg2 <= "10000";
		wait for 10 ns;	

		readReg1 <= "10001";
		readReg2 <= "00000";
		wait for 10 ns;	

		wait; -- will wait forever
	END PROCESS;

END;
