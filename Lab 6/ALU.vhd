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
  sum   <= (a xor b) xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;


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
	signal c: std_logic_vector (32 downto 0);
	signal temp: std_logic_vector (31 downto 0);
begin
	with add_sub select
		temp <= not(datain_b) when '1',
			   datain_b when others;
	c(0) <= add_sub;
	co <= c(32);
	FullAdder32: For i in 0 to 31 generate
		FAi: fulladder PORT MAP (datain_a(i), temp(i), c(i), dataout(i), c(i+1));
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

begin

  with dir & shamt select
	
	dataout <=	datain(30 downto 0) & '0' 	when "000001",
			datain(29 downto 0) & "00" 	when "000010",
			datain(28 downto 0) & "000" 	when "000011",
			
			'0' & datain(31 downto 1)	when "100001",
			"00" & datain(31 downto 2)	when "100010",
			"000" & datain(31 downto 3)	when "100011",

			datain(31 downto 0)		when others;

end architecture shifter;



--------------------------------------------------------------------------------

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

	SIGNAL as,co_out: std_logic;
	SIGNAL a_out, s_out, res: std_logic_vector (31 downto 0);
begin
	as <= ALUCtrl(0);
	add: adder_subtracter port map(DataIn1,DataIn2,as,a_out,co_out);
	shift: shift_register port map(DataIn1,ALUCtrl(4),DataIn2(4 downto 0),s_out);
	with ALUCtrl(3 DOWNTO 0) select res <=
		a_out when "0000" | "0001" | "0010",
		DataIn1 and DataIn2 when "0011" | "0100",
		DataIn1 or DataIn2  when "0101" | "0111",
		s_out when "0110",				--0 left, 1 right
		datain2 when others;
		
		
	with res select zero <= 
		'1' when "00000000000000000000000000000000",
		'0' when others;
	ALUResult <= res;
end architecture ALU_Arch;