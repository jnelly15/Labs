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


--------------------------------------------------------------------------------
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
	inst : for i in 7 downto 0 generate
	A: bitstorage port map(datain(i), enout, writein, dataout(i));
	end generate;

end architecture memmy;

--------------------------------------------------------------------------------
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
	-- hint: you'll want to put register8 as a component here 
	-- so you can use it below
	component register8
		port(datain: in std_logic_vector(7 downto 0);
		     enout: in std_logic;
		     writein: in std_logic;
		     dataout: out std_logic_vector(7 downto 0));
end component;
	Signal write8, write16, enable8, enable16 : std_logic := '0';
begin
	-- insert code here.
	U1 : register8 port map (datain(7 downto 0), enable8, write8, dataout(7 downto 0));
	U2 : register8 port map (datain(15 downto 8), enable16, write16, dataout(15 downto 8));
	U3 : register8 port map (datain(23 downto 16), enout32, writein32, dataout(23 downto 16));
	U4 : register8 port map (datain(31 downto 24), enout32, writein32, dataout(31 downto 24));

	write8 <= writein32 OR writein16 OR writein8;
	write16 <= writein32 OR writein16;

	enable8 <= enout32 AND enout16 AND enout8;
	enable16 <= enout32 AND enout16;


	end architecture biggermem;

--------------------------------------------------------------------------------
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
end architecture calc;

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



