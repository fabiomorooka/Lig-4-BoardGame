library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Resultado is
	port(
		tab_1,tab_2: in std_logic_vector(19 downto 0);			-- Entrada: tabela virtual das jogadas dos jogadores separadas para cada jogador
		signalWin1,signalWin2: buffer std_logic;			-- Buffer: sinal que avisa quando algum jogador ganhou
		signalDraw: out std_logic					-- Saida: sinal que avisa quando houver empate
	);
end Resultado;

architecture behaviour of Resultado is

	signal tab_3: std_logic_vector(19 downto 0);	

	begin
		
	tab_3 <= tab_2 xor tab_1;	
	signalDraw <= '1' when (tab_3 = "11111111111111111111") else '0';
	
	signalWin1 <= '1' when ((tab_1(19) = '1' and tab_1(18) = '1' and tab_1(17) = '1' and tab_1(16) = '1') or
									(tab_1(15) = '1' and tab_1(18) = '1' and tab_1(17) = '1' and tab_1(16) = '1') or
									(tab_1(14) = '1' and tab_1(13) = '1' and tab_1(12) = '1' and tab_1(11) = '1') or
									(tab_1(10) = '1' and tab_1(13) = '1' and tab_1(12) = '1' and tab_1(11) = '1') or	
									(tab_1(9) = '1' and tab_1(8) = '1' and tab_1(7) = '1' and tab_1(6) = '1') or	
									(tab_1(5) = '1' and tab_1(8) = '1' and tab_1(7) = '1' and tab_1(6) = '1') or	
									(tab_1(4) = '1' and tab_1(3) = '1' and tab_1(2) = '1' and tab_1(1) = '1') or	
									(tab_1(0) = '1' and tab_1(3) = '1' and tab_1(2) = '1' and tab_1(1) = '1') or	
									(tab_1(19) = '1' and tab_1(14) = '1' and tab_1(9) = '1' and tab_1(4) = '1') or	
									(tab_1(18) = '1' and tab_1(13) = '1' and tab_1(8) = '1' and tab_1(3) = '1') or	
									(tab_1(17) = '1' and tab_1(12) = '1' and tab_1(7) = '1' and tab_1(2) = '1') or	
									(tab_1(16) = '1' and tab_1(11) = '1' and tab_1(6) = '1' and tab_1(1) = '1') or	
									(tab_1(15) = '1' and tab_1(10) = '1' and tab_1(5) = '1' and tab_1(0) = '1') or	
									(tab_1(19) = '1' and tab_1(13) = '1' and tab_1(7) = '1' and tab_1(1) = '1') or	
									(tab_1(18) = '1' and tab_1(12) = '1' and tab_1(6) = '1' and tab_1(0) = '1') or	
									(tab_1(15) = '1' and tab_1(11) = '1' and tab_1(7) = '1' and tab_1(3) = '1') or	
									(tab_1(16) = '1' and tab_1(12) = '1' and tab_1(8) = '1' and tab_1(4) = '1')) else '0';
	
	signalWin2 <= '1' when ((tab_2(19) = '1' and tab_2(18) = '1' and tab_2(17) = '1' and tab_2(16) = '1') or
									(tab_2(15) = '1' and tab_2(18) = '1' and tab_2(17) = '1' and tab_2(16) = '1') or
									(tab_2(14) = '1' and tab_2(13) = '1' and tab_2(12) = '1' and tab_2(11) = '1') or
									(tab_2(10) = '1' and tab_2(13) = '1' and tab_2(12) = '1' and tab_2(11) = '1') or	
									(tab_2(9) = '1'  and tab_2(8) = '1'  and tab_2(7) = '1'  and tab_2(6) = '1') or	
									(tab_2(5) = '1'  and tab_2(8) = '1'  and tab_2(7) = '1'  and tab_2(6) = '1') or	
									(tab_2(4) = '1'  and tab_2(3) = '1'  and tab_2(2) = '1'  and tab_2(1) = '1') or	
									(tab_2(0) = '1'  and tab_2(3) = '1'  and tab_2(2) = '1'  and tab_2(1) = '1') or	
									(tab_2(19) = '1' and tab_2(14) = '1' and tab_2(9) = '1'  and tab_2(4) = '1') or	
									(tab_2(18) = '1' and tab_2(13) = '1' and tab_2(8) = '1'  and tab_2(3) = '1') or	
									(tab_2(17) = '1' and tab_2(12) = '1' and tab_2(7) = '1'  and tab_2(2) = '1') or	
									(tab_2(16) = '1' and tab_2(11) = '1' and tab_2(6) = '1'  and tab_2(1) = '1') or	
									(tab_2(15) = '1' and tab_2(10) = '1' and tab_2(5) = '1'  and tab_2(0) = '1') or	
									(tab_2(19) = '1' and tab_2(13) = '1' and tab_2(7) = '1'  and tab_2(1) = '1') or	
									(tab_2(18) = '1' and tab_2(12) = '1' and tab_2(6) = '1'  and tab_2(0) = '1') or	
									(tab_2(15) = '1' and tab_2(11) = '1' and tab_2(7) = '1'  and tab_2(3) = '1') or	
									(tab_2(16) = '1' and tab_2(12) = '1' and tab_2(8) = '1'  and tab_2(4) = '1')) else '0';
	

end behaviour;