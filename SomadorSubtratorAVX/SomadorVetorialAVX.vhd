--------------------------------------------------------------------------------
-- Project :
-- File    :
-- Autor   :
-- Date    :
--
--------------------------------------------------------------------------------
-- Description :
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SomadorVetorialAVX IS
  PORT (
  ------------------------------------------------------------------------------
  --Insert input ports below
    A_i        : IN  std_logic_vector(31 DOWNTO 0); -- input vector 1
    B_i        : IN  std_logic_vector(31 DOWNTO 0); -- input vector 2
    mode_i     : IN  std_logic;                     -- Mode: Add or Sub
    vecSize_i  : IN  std_logic_vector(1 DOWNTO 0);  -- Size: 00 = 4 bits, 01 = 8, 10 = 16, 11 = 32
  ------------------------------------------------------------------------------
  --Insert output ports below
    S_o        : OUT std_logic_vector(31 DOWNTO 0) -- Result vector
    );
END SomadorVetorialAVX;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF SomadorVetorialAVX IS
	COMPONENT ALU4bits IS
		PORT(X, Y:          IN  STD_LOGIC_VECTOR (3 downto 0);
  			seletor, Cin:    IN  STD_LOGIC;
  			Juntar:          IN  STD_LOGIC;
         resultado:       OUT STD_LOGIC_VECTOR (3 downto 0);
	      Cout:            OUT STD_LOGIC
		);
	END COMPONENT;
	signal juntar, resultado: STD_LOGIC_VECTOR (7 downto 0); 
	signal cin_i:  STD_LOGIC_VECTOR (8 downto 0); 

	
BEGIN
	cin_i(0) <= '0'; -- Just to initialize, doesn't matter
	juntar(0) <= '0';

	-- When vecSize_i == 01
	juntar(1) <= vecSize_i(1) OR vecSize_i(0);
	juntar(3) <= juntar(1);
	juntar(5) <= juntar(3);
	juntar(7) <= juntar(5); 

	-- When vecSize_i == 10
	juntar(2) <= vecSize_i(1);
	juntar(6) <= juntar(2);

	-- When vecSize_i == 11
	juntar(4) <= vecSize_i(1) AND vecSize_i(0);



	G1: for i in 0 to 7 GENERATE
		func_i: ALU4bits PORT MAP(
					A_i(i*4+3 downto i*4),
					B_i(i*4+3 downto i*4),
					mode_i,
					cin_i(i),
					juntar(i),
					S_o(i*4+3 downto i*4),
					cin_i(i+1)
					);
	End GENERATE G1;

END structural;

--------------------------------------------------------------------------------
-- Project :
-- File    :
-- Autor   :
-- Date    :
--
--------------------------------------------------------------------------------
-- Description :
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ALU4bits IS
  PORT (
  --Inputs
    X, Y:          IN STD_LOGIC_VECTOR (3 downto 0); 
    seletor, Cin:  IN STD_LOGIC; -- Cin = Cout-1 (se primeiro, n importa, l�gica desse c�digo ignorar�)
    Juntar: 	    IN STD_LOGIC; -- Se junta com a ALU anterior para formar tamanho maior de bits.
  ------------------------------------------------------------------------------
  --Outputs
    resultado:     OUT STD_LOGIC_VECTOR (3 downto 0); 
    Cout:          OUT STD_LOGIC
    );
END ALU4bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF ALU4bits IS

	COMPONENT Somador4Bit IS
		PORT(X, Y: in STD_LOGIC_VECTOR (3 downto 0);
  			Cin:  in STD_LOGIC;
               S:    out STD_LOGIC_VECTOR (3 downto 0);
	          Cout: out STD_LOGIC
		);
	END COMPONENT;
	COMPONENT MUX21_4Bits IS
		PORT(X, Y:          IN STD_LOGIC_VECTOR (3 downto 0);
			seletor:   IN STD_LOGIC;
  			saida:     OUT STD_LOGIC_VECTOR (3 downto 0)
		);
	END COMPONENT;
	signal operando_2:  STD_LOGIC_VECTOR (3 downto 0);
	signal cin_somador: STD_LOGIC;
	signal not_Y:       STD_LOGIC_VECTOR (3 downto 0);
	
begin
	--NOT Y
	not_Y <= NOT Y;

	-- Coloca como operando o Y invertido se for escolhido a subtra��o
	MUX_21: MUX21_4Bits PORT MAP(Y, not_Y, seletor, operando_2);

	
	-- L�gica para determinar o cin considerando o Juntar e a sele��o Add/Sub
	cin_somador <= (NOT (Juntar) AND seletor) OR (Juntar AND Cin);


	ALU_4BIT: Somador4Bit PORT MAP (X, operando_2, cin_somador, resultado, Cout); 
	
END structural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Somador4Bit IS
  PORT (
  --Inputs
  	X, Y: in STD_LOGIC_VECTOR (3 downto 0);
  	Cin: in STD_LOGIC;
  ------------------------------------------------------------------------------	
	S: out STD_LOGIC_VECTOR (3 downto 0);
	Cout: out STD_LOGIC
    );
END Somador4Bit;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF Somador4Bit IS

	COMPONENT FullAdder1bit IS
		PORT(A, B, Cin: in STD_LOGIC;
			  S, Cout: out	STD_LOGIC);
	END COMPONENT;
	signal c1, c2, c3: STD_LOGIC := '0';
	
begin
	FA1: FullAdder1bit PORT MAP (X(0), Y(0), Cin, S(0), c1);
	FA2: FullAdder1bit PORT MAP (X(1), Y(1), c1, S(1), c2);
	FA3: FullAdder1bit PORT MAP (X(2), Y(2), c2, S(2), c3);
	FA4: FullAdder1bit PORT MAP (X(3), Y(3), c3, S(3), Cout);

end structural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MUX21_4Bits IS
  PORT (
  ------------------------------------------------------------------------------
  --Insert input ports below
    X, Y:     in STD_LOGIC_VECTOR (3 downto 0);                 
    seletor:  IN STD_LOGIC;
  ------------------------------------------------------------------------------
  --Insert output ports below
    saida:    out STD_LOGIC_VECTOR (3 downto 0)
    );
END MUX21_4Bits;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE structural OF MUX21_4Bits IS

BEGIN
	saida(0) <= (NOT(seletor) AND X(0)) OR (seletor AND Y(0));
	saida(1) <= (NOT(seletor) AND X(1)) OR (seletor AND Y(1));
	saida(2) <= (NOT(seletor) AND X(2)) OR (seletor AND Y(2));
	saida(3) <= (NOT(seletor) AND X(3)) OR (seletor AND Y(3));
	--with seletor select
    	--	saida <= X when '0',
     --     	    Y when others;
	
END structural;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY FullAdder1bit IS
  PORT (
  --Inputs
    A, B, Cin: in STD_LOGIC;
  ------------------------------------------------------------------------------
  --Outputs
    S, Cout: out STD_LOGIC
   );
END FullAdder1bit;

--------------------------------------------------------------------------------
--Complete your VHDL description below
--------------------------------------------------------------------------------

ARCHITECTURE dataflow OF FullAdder1bit IS

BEGIN

	S <= Cin XOR (A XOR B);
	Cout <= (A AND Cin) OR (B AND Cin) OR (A AND B);

END dataflow;
