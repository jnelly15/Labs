--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is

    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	Signal a0,a1,a2,a3,a4,a5,a6,a7,x0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	Signal w: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
begin
    	x0 <= (OTHERS => '0');

	reg0: register32 PORT MAP(WriteData,'0','1','1',w(0),'0','0',a0);
	reg1: register32 PORT MAP(WriteData,'0','1','1',w(1),'0','0',a1);
	reg2: register32 PORT MAP(WriteData,'0','1','1',w(2),'0','0',a2);
	reg3: register32 PORT MAP(WriteData,'0','1','1',w(3),'0','0',a3);
	reg4: register32 PORT MAP(WriteData,'0','1','1',w(4),'0','0',a4);
	reg5: register32 PORT MAP(WriteData,'0','1','1',w(5),'0','0',a5);
	reg6: register32 PORT MAP(WriteData,'0','1','1',w(6),'0','0',a6);
	reg7: register32 PORT MAP(WriteData,'0','1','1',w(7),'0','0',a7);
	
	WITH ReadReg1 SELECT ReadData1 <=
		a0 WHEN "01010",
		a1 WHEN "01011",
		a2 WHEN "01100",
		a3 WHEN "01101",
		a4 WHEN "01110",
		a5 WHEN "01111",
		a6 WHEN "10000",
		a7 WHEN "10001",
		x0 WHEN OTHERS;

	WITH ReadReg2 SELECT ReadData2 <=
		a0 WHEN "01010",
		a1 WHEN "01011",
		a2 WHEN "01100",
		a3 WHEN "01101",
		a4 WHEN "01110",
		a5 WHEN "01111",
		a6 WHEN "10000",
		a7 WHEN "10001",
		x0 WHEN OTHERS;

	WITH WriteCmd & WriteReg SELECT w <=
		"00000001" WHEN "101010",
		"00000010" WHEN "101011",
		"00000100" WHEN "101100",
		"00001000" WHEN "101101",
		"00010000" WHEN "101110",
		"00100000" WHEN "101111",
		"01000000" WHEN "110000",
		"10000000" WHEN "110001",
		"00000000" WHEN OTHERS;
	
end remember;