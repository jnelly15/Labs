--------------------------------------------------------------------------------
-- Tim Nguyen and Jack Nelson
-- LAB #5 - Memory and Register Bank
-- 06/01/2018
--------------------------------------------------------------------------------
-- single bit storage
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
-- 8-bit register
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	c0: bitstorage port map(datain(0),enout,writein,dataout(0));
	c1: bitstorage port map(datain(1),enout,writein,dataout(1));
	c2: bitstorage port map(datain(2),enout,writein,dataout(2));
	c3: bitstorage port map(datain(3),enout,writein,dataout(3));
	c4: bitstorage port map(datain(4),enout,writein,dataout(4));
	c5: bitstorage port map(datain(5),enout,writein,dataout(5));
	c6: bitstorage port map(datain(6),enout,writein,dataout(6));
	c7: bitstorage port map(datain(7),enout,writein,dataout(7));
end architecture memmy;

--------------------------------------------------------------------------------
-- 32-bit register
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	component register8
		port(datain: in std_logic_vector(7 downto 0);
	     		enout:  in std_logic;
	     		writein: in std_logic;
	     		dataout: out std_logic_vector(7 downto 0));
	end component;

	signal en_out16: std_logic;
	signal en_out8: std_logic;
	signal write_in16: std_logic;
	signal write_in8: std_logic;
begin
	en_out16 <= enout32 and enout16;
	en_out8 <= enout32 and enout16 and enout8;

	write_in16 <= writein32 or writein16;
	write_in8 <= writein32 or writein16 or writein8;

	b3: register8 PORT MAP(datain(31 downto 24), enout32, writein32, dataout(31 downto 24));
	b2: register8 PORT MAP(datain(23 downto 16), enout32, writein32, dataout(23 downto 16));
	b1: register8 PORT MAP(datain(15 downto 8), en_out16, write_in16, dataout(15 downto 8));
	b0: register8 PORT MAP(datain(7 downto 0), en_out8, write_in8, dataout(7 downto 0));
	
end architecture biggermem;

--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   	type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   	signal i_ram : ram_type;
	signal address_In: integer;
	signal address_Out: integer;
begin
	RamProc: process(Clock, Reset, OE, WE, Address) is
  	begin
	address_In <= to_integer(unsigned(Address));	--Position in ram
	address_Out <= address_In;
	
	--RESET RAM--
	if Reset = '1' then
		i_ram(0 to 127) <= (others => X"00000000");
    	end if;
	
	--WRITE TO RAM--
    	if falling_edge(Clock) then
		if ((address_In >= 0) and (address_In <= 127)) then
			if WE = '1' then
				i_ram(address_In) <= DataIn;
			end if;
		else
			DataOut <= (others => 'Z');
		end if;
   	end if;
	--READ FROM RAM--
	if OE = '0' then
		if ((address_Out >= 0) and (address_Out <= 127)) then
			DataOut <= i_ram(address_Out);
		else
			DataOut <= (others => 'Z');
		end if;
	end if;
  end process RamProc;

end staticRAM;	


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
--INPUT AND OUTPUT FOR ZERO REGISTER--
	signal zeri: STD_LOGIC_VECTOR(31 downto 0);
        signal zerou: STD_LOGIC_VECTOR(31 downto 0);
	signal zer: STD_LOGIC_VECTOR(31 downto 0):=X"00000000";

	--------INPUT FOR A0 - A7--------
	signal a0o: STD_LOGIC_VECTOR(31 downto 0);
	signal a1o: STD_LOGIC_VECTOR(31 downto 0);
	signal a2o: STD_LOGIC_VECTOR(31 downto 0);
	signal a3o: STD_LOGIC_VECTOR(31 downto 0);
	signal a4o: STD_LOGIC_VECTOR(31 downto 0);
	signal a5o: STD_LOGIC_VECTOR(31 downto 0);
	signal a6o: STD_LOGIC_VECTOR(31 downto 0);
	signal a7o: STD_LOGIC_VECTOR(31 downto 0);
	
	--------OUTPUT FOR A0 - A7 -------
	signal a0i: STD_LOGIC_VECTOR(31 downto 0);
	signal a1i: STD_LOGIC_VECTOR(31 downto 0);
	signal a2i: STD_LOGIC_VECTOR(31 downto 0);
	signal a3i: STD_LOGIC_VECTOR(31 downto 0);
	signal a4i: STD_LOGIC_VECTOR(31 downto 0);
	signal a5i: STD_LOGIC_VECTOR(31 downto 0);
	signal a6i: STD_LOGIC_VECTOR(31 downto 0);
	signal a7i: STD_LOGIC_VECTOR(31 downto 0);
	signal highz: STD_LOGIC_VECTOR(31 DOWNTO 0):= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
	
	begin
	
	---DEMUX FOR CHOOSING REGISTER TO WRITE---
	zeri <= zer;      --when WriteCmd&writereg="100000";
	a0i <= writeData when WriteCmd&writereg="100001";
	a1i <= writeData when WriteCmd&writereg="100010";
	a2i <= writeData when WriteCmd&writereg="100011";
	a3i <= writeData when WriteCmd&writereg="100100";
	a4i <= writeData when WriteCmd&writereg="100101";
	a5i <= writeData when WriteCmd&writereg="100110";
	a6i <= writeData when WriteCmd&writereg="100111";
	a7i <= writeData when WriteCmd&writereg="101000";
	
	
	
	---MUX FOR CHOOSING OUTPUT REGISTER 1---
	with ReadReg1 select
		            ReadData1 <= zerou when "00000",
				           a0o when "00001",
					   a1o when "00010",
					   a2o when "00011",
					   a3o when "00100",
					   a4o when "00101",
					   a5o when "00110",
					   a6o when "00111",
					   a7o when "01000",
	                                 highz when others;
	
	
	
	
	---MuX FOR CHOOSING OUTPUT REGISTER 2---
		with ReadReg2 select
		            ReadData2 <= zerou when "00000",
				           a0o when "00001",
					   a1o when "00010",
					   a2o when "00011",
					   a3o when "00100",
					   a4o when "00101",
					   a5o when "00110",
					   a6o when "00111",
					   a7o when "01000",
	                                 highz when others;
	
	
	
--out: active low
--in: active high
------------------------        datin oe32 oe16 oe8      we32    we16  we8   datout
       x0: register32  PORT MAP(zeri, '0', '1', '1', WriteCmd, '0',  '0', zerou);
	a0: register32  PORT MAP(a0i, '0', '1', '1', WriteCmd, '0',  '0', a0o);
	a1: register32  PORT MAP(a1i, '0', '1', '1', WriteCmd, '0',  '0', a1o);
	a2: register32  PORT MAP(a2i, '0', '1', '1', WriteCmd, '0',  '0', a2o);
	a3: register32  PORT MAP(a3i, '0', '1', '1', WriteCmd, '0',  '0', a3o);
	a4: register32  PORT MAP(a4i, '0', '1', '1', WriteCmd, '0',  '0', a4o);
	a5: register32  PORT MAP(a5i, '0', '1', '1', WriteCmd, '0',  '0', a5o);
	a6: register32  PORT MAP(a6i, '0', '1', '1', WriteCmd, '0',  '0', a6o);
	a7: register32  PORT MAP(a7i, '0', '1', '1', WriteCmd, '0',  '0', a7o);
	

	
begin
    -- Add your code here for the Register Bank implementation

end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
