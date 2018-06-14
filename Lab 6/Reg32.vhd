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
	register8: For i in 0 to 7 generate
		bi: bitstorage PORT MAP(datain(i), enout, writein, dataout(i));
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
	component register8
		port(datain: in std_logic_vector(7 downto 0);
		     enout:  in std_logic;
		     writein: in std_logic;
		     dataout: out std_logic_vector( 7 downto 0));
	end component;
	-- hint: you'll want to put register8 as a component here 
	-- so you can use it below
	Signal a_sig,b_sig,c_sig,d_sig, e_1, e_2, e_3, e_4 : STD_LOGIC;
	
begin
		a_sig <= writein32;
		b_sig <= writein32;
		c_sig <= writein16 or writein32;
		d_sig <= writein8 or writein16 or writein32;
		e_1   <= enout32;
		e_2   <= enout32;
		e_3   <= enout16 and enout32;
		e_4   <= enout8  and enout16 and enout32;
	r1: register8 PORT MAP(datain(7 downto 0), e_4, d_sig, dataout(7 downto 0));
	r2: register8 PORT MAP(datain(15 downto 8), e_3, c_sig, dataout(15 downto 8));
	r3: register8 PORT MAP(datain(23 downto 16), e_2, b_sig, dataout(23 downto 16));
	r4: register8 PORT MAP(datain(31 downto 24), e_1, a_sig, dataout(31 downto 24));
end architecture biggermem;
--------------------------------------------------------------------------------
