LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY flipd IS								--Flip flop generico de n bits
	generic (
		n : natural := 8);				
	PORT (d                  : in STD_LOGIC_VECTOR(n-1 downto 0);
	      clk,reset,enable   : in STD_LOGIC;			--Possui reset e enable
	      Q		         : out STD_LOGIC_VECTOR(n-1 downto 0));
END flipd;

ARCHITECTURE behaviour OF flipd IS
begin

process(clk,reset,enable)
	variable d1: std_logic_vector(n-1 downto 0):=(OTHERS => '0');
	begin
	if (reset='0') then						--Se for resetado volta os bits todos para zero(ativo baixo)
		d1:=(OTHERS => '0');
	elsif (rising_edge(clk)) then
		if (enable = '1') then					--Somente altera com o enable ligado
			d1:=d;	
		end if;
	end if;
	Q<=d1;
end process;
END behaviour;