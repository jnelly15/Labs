--------------------------------------------------------------------------------
--
-- LAB #3
--
--------------------------------------------------------------------------------

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


-------------------------------------Part1-------------------------------------------
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
	LSB: bitstorage PORT MAP(datain(0),enout,writein,dataout(0));
	BIT1: bitstorage PORT MAP(datain(1),enout,writein,dataout(1));
	BIT2: bitstorage PORT MAP(datain(2),enout,writein,dataout(2));
	BIT3: bitstorage PORT MAP(datain(3),enout,writein,dataout(3));
	BIT4: bitstorage PORT MAP(datain(4),enout,writein,dataout(4));
	BIT5: bitstorage PORT MAP(datain(5),enout,writein,dataout(5));
	BIT6: bitstorage PORT MAP(datain(6),enout,writein,dataout(6));
	MSB: bitstorage PORT MAP(datain(7),enout,writein,dataout(7));

end architecture memmy;

-------------------------------------Part2-------------------------------------------
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
	--USING register8 AS COMPONENT
	component register8 
		port(datain: in std_logic_vector(7 downto 0);
	     		enout:  in std_logic;
	     		writein: in std_logic;
	     		dataout: out std_logic_vector(7 downto 0));
	end component;

	--enable8 & enable16 writes data when "predecessor" is '0', "active low"--
	signal enable8: std_logic;  
	signal enable16: std_logic;

	--write8 & write16 writes data whenever "predecessor" is '1'. "active high"--
	signal write8: std_logic;
	signal write16: std_logic;

begin
	--enable8 will act as active low(give output) as soon as any enable is active low.
	enable8 <= enout32 and enout16 and enout8;
	
	--enable16 will act as active low(give output) as soon as either enout32 aor enout16 is active low.
	enable16 <= enout32 and enout16;
	
	--write8 will output data whenever any of the following are active high
	write8 <= writein32 or writein16 or writein8;

	--write16 will output data whenever writein32 or writein16 is active high.
	write16 <= writein32 or writein16;

	c0: register8 PORT MAP(datain(31 downto 24),enout32,writein32,dataout(31 downto 24));
	c1: register8 PORT MAP(datain(23 downto 16),enout32,writein32,dataout(23 downto 16));
	c2: register8 PORT MAP(datain(15 downto 8),enable16,write16,dataout(15 downto 8));
	c3: register8 PORT MAP(datain(7 downto 0),enable8,write8,dataout(7 downto 0));

end architecture biggermem;

------------------------------------Part3--------------------------------------------
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
begin
	process (dir)
	begin
		--SHIFT RIGHT---
		if dir = '1' then
			if shamt = "00001" then
				dataout(30 downto 0) <= datain(31 downto 1);
				dataout(31) <= '0';
			elsif shamt = "00010" then
				dataout(29 downto 0) <= datain(31 downto 2);
				dataout(31 downto 30) <= "00";
			elsif shamt = "00011" then
				dataout(28 downto 0) <= datain(31 downto 3);
				dataout(31 downto 29) <= "000";
			else
				dataout <= datain;
			end if;
		else
		--SHIFT LEFT--
			if shamt = "00001" then
				dataout(31 downto 1) <= datain(30 downto 0);
				dataout(0) <= '0';
			elsif shamt = "00010" then
				dataout(31 downto 2) <= datain(29 downto 0);
				dataout(1 downto 0) <= "00";
			elsif shamt = "00011" then
				dataout(31 downto 3) <= datain(28 downto 0);
				dataout(2 downto 0) <= "000";
			else
				dataout <= datain;
			end if;
		end if;
	end process;
end architecture shifter;

-------------------------------------Part4-------------------------------------------
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
	component fulladder is
    		port (a : in std_logic;
         		b : in std_logic;
          		cin : in std_logic;
          		sum : out std_logic;
          		carry : out std_logic);
	end component;	
	signal C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10: std_logic;
	signal C11,C12,C13,C14,C15,C16,C17,C18,C19,C20,C21: std_logic;
	signal C22,C23,C24,C25,C26,C27,C28,C29,C30,C31: std_logic;
	signal TEMP: std_logic_vector(31 downto 0);
begin
	TEMP(0)<= add_sub xor datain_b(0);
	TEMP(1)<= add_sub xor datain_b(1);
	TEMP(2)<= add_sub xor datain_b(2);
	TEMP(3)<= add_sub xor datain_b(3);
	TEMP(4)<= add_sub xor datain_b(4);
	TEMP(5)<= add_sub xor datain_b(5);
	TEMP(6)<= add_sub xor datain_b(6);
	TEMP(7)<= add_sub xor datain_b(7);
	TEMP(8)<= add_sub xor datain_b(8);
	TEMP(9)<= add_sub xor datain_b(9);
	TEMP(10)<= add_sub xor datain_b(10);
	TEMP(11)<= add_sub xor datain_b(11);
	TEMP(12)<= add_sub xor datain_b(12);
	TEMP(13)<= add_sub xor datain_b(13);
	TEMP(14)<= add_sub xor datain_b(14);
	TEMP(15)<= add_sub xor datain_b(15);
	TEMP(16)<= add_sub xor datain_b(16);
	TEMP(17)<= add_sub xor datain_b(17);
	TEMP(18)<= add_sub xor datain_b(18);
	TEMP(19)<= add_sub xor datain_b(19);
	TEMP(20)<= add_sub xor datain_b(20);
	TEMP(21)<= add_sub xor datain_b(21);
	TEMP(22)<= add_sub xor datain_b(22);
	TEMP(23)<= add_sub xor datain_b(23);
	TEMP(24)<= add_sub xor datain_b(24);
	TEMP(25)<= add_sub xor datain_b(25);
	TEMP(26)<= add_sub xor datain_b(26);
	TEMP(27)<= add_sub xor datain_b(27);
	TEMP(28)<= add_sub xor datain_b(28);
	TEMP(29)<= add_sub xor datain_b(29);
	TEMP(30)<= add_sub xor datain_b(30);
	TEMP(31)<= add_sub xor datain_b(31);

	ad0: fulladder port map(datain_a(0),TEMP(0),add_sub,dataout(0),C0); 
	ad1: fulladder port map(datain_a(1),TEMP(1),C0,dataout(1),C1); 
	ad2: fulladder port map(datain_a(2),TEMP(2),C1,dataout(2),C2); 	
	ad3: fulladder port map(datain_a(3),TEMP(3),C2,dataout(3),C3);
	ad4: fulladder port map(datain_a(4),TEMP(4),C3,dataout(4),C4);
	ad5: fulladder port map(datain_a(5),TEMP(5),C4,dataout(5),C5);
	ad6: fulladder port map(datain_a(6),TEMP(6),C5,dataout(6),C6);
	ad7: fulladder port map(datain_a(7),TEMP(7),C6,dataout(7),C7);
	ad8: fulladder port map(datain_a(8),TEMP(8),C7,dataout(8),C8);
	ad9: fulladder port map(datain_a(9),TEMP(9),C8,dataout(9),C9);
	ad10: fulladder port map(datain_a(10),TEMP(10),C9,dataout(10),C10);
	ad11: fulladder port map(datain_a(11),TEMP(11),C10,dataout(11),C11);
	ad12: fulladder port map(datain_a(12),TEMP(12),C11,dataout(12),C12);
	ad13: fulladder port map(datain_a(13),TEMP(13),C12,dataout(13),C13);
	ad14: fulladder port map(datain_a(14),TEMP(14),C13,dataout(14),C14);
	ad15: fulladder port map(datain_a(15),TEMP(15),C14,dataout(15),C15);
	ad16: fulladder port map(datain_a(16),TEMP(16),C15,dataout(16),C16);
	ad17: fulladder port map(datain_a(17),TEMP(17),C16,dataout(17),C17);
	ad18: fulladder port map(datain_a(18),TEMP(18),C17,dataout(18),C18);
	ad19: fulladder port map(datain_a(19),TEMP(19),C18,dataout(19),C19); 
	ad20: fulladder port map(datain_a(20),TEMP(20),C19,dataout(20),C20); 
	ad21: fulladder port map(datain_a(21),TEMP(21),C20,dataout(21),C21); 
	ad22: fulladder port map(datain_a(22),TEMP(22),C21,dataout(22),C22); 
	ad23: fulladder port map(datain_a(23),TEMP(23),C22,dataout(23),C23); 
	ad24: fulladder port map(datain_a(24),TEMP(24),C23,dataout(24),C24); 
	ad25: fulladder port map(datain_a(25),TEMP(25),C24,dataout(25),C25);
	ad26: fulladder port map(datain_a(26),TEMP(26),C25,dataout(26),C26); 
	ad27: fulladder port map(datain_a(27),TEMP(27),C26,dataout(27),C27); 
	ad28: fulladder port map(datain_a(28),TEMP(28),C27,dataout(28),C28);
	ad29: fulladder port map(datain_a(29),TEMP(29),C28,dataout(29),C29); 
	ad30: fulladder port map(datain_a(30),TEMP(30),C29,dataout(30),C30); 
	ad31: fulladder port map(datain_a(31),TEMP(31),C30,dataout(31),C31); 
	co <= C31;
end architecture calc;

