library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--Tabuleiro gerencia o prenchimento das posicoes 
--Retorna um vetor de posicoes prenchidas para cada jogador

entity TABULEIRO is
    Port ( 	jogador:	in std_logic_vector(1 downto 0);	--10 para jogador 1 e 01 para jogador 2
		coluna: 	in std_logic_vector(4 downto 0);	--bit alto representa qual coluna esta sendo acionada
		clockj,resetn,stop: 	in std_logic;				--reset ativo baixo
		j_val: 		out std_logic;				--Alto quando a jogada a se realizar e valida
		tab_1,tab_2:	out std_logic_vector(19 downto 0));	--tab_1 para jogador 1 e tab_2 para jogador 2
end TABULEIRO;


architecture Behaviour of TABULEIRO is	
	
	COMPONENT flipd IS
		generic (
			n : natural := 8);				
		PORT (d                  : in STD_LOGIC_VECTOR(n-1 downto 0);
		      clk,reset,enable   : in STD_LOGIC;			--Possui reset e enable
		      Q		         : out STD_LOGIC_VECTOR(n-1 downto 0));
		END COMPONENT;
	
	-- COMPONENTE DE VERIFICACAO DE VITORIA OU EMPATE

	SIGNAL en1,en2,en3,en4,en5: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL s11,s21,s31,s41,s12,s22,s32,s42,s13,s23,s33,s43,s14,s24,s34,s44,s15,s25,s35,s45: std_logic_vector(1 downto 0) := "00";

	begin

	--Cada flip flop representa uma posicao do tabuleiro, onde o valor so se altera quando o jogador ativa o clockj onde indica jogada realizada
	--Na nomenclatura fxy onde x e linha, y e coluna 
	--A codificacao da saida e:
	--00 => nao preechida
	--10 => jogador 1 naquela posicao
	--01 => jogador 2 naquela posicao
  		
		f11: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en1(3),s11);
		f21: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en1(2),s21);
		f31: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en1(1),s31);
		f41: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en1(0),s41);
		
		f12: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en2(3),s12);
		f22: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en2(2),s22);
		f32: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en2(1),s32);
		f42: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en2(0),s42);
		
		f13: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en3(3),s13);
		f23: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en3(2),s23);
		f33: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en3(1),s33);
		f43: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en3(0),s43);
		
		f14: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en4(3),s14);
		f24: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en4(2),s24);
		f34: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en4(1),s34);
		f44: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en4(0),s44);
		
		f15: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en5(3),s15);
		f25: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en5(2),s25);
		f35: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en5(1),s35);
		f45: flipd generic map(2) PORT MAP(jogador,clockj,resetn,en5(0),s45);

		

		--A logica de preenchimento e feita por meio dos enables, onde para ativar uma determinada coluna ela deve ser indicada pelas chaves
		--Depois e verificada a existencia de posicoes livres, ligando o enable da primeira posicao livre
		--Caso nao exista uma posicao livre na coluna nao e ligado nenhum enable
		--Stop para de registrar jogada quando o jogo acaba, quando alguem ganha ou empata

		en1<= "1000" when (coluna="00001" and s11="00" and stop = '0') else	--Liga primeira posicao da coluna 1
		      "0100" when (coluna="00001" and s21="00" and stop = '0')  else	--Liga segunda posicao da coluna 1
		      "0010" when (coluna="00001" and s31="00" and stop = '0')  else	--Liga terceira posicao da coluna 1
	   	   "0001" when (coluna="00001" and s41="00" and stop = '0')  else	--Liga quarta posicao da coluna 1
		      "0000";						--Caso todas as anteriore = '0's estejam cheias nao liga nada 
		 
		en2<= "1000" when (coluna="00010" and s12="00" and stop = '0') else
		      "0100" when (coluna="00010" and s22="00" and stop = '0') else
		      "0010" when (coluna="00010" and s32="00" and stop = '0') else
	   	   "0001" when (coluna="00010" and s42="00" and stop = '0') else
		      "0000"; 

		en3<= "1000" when (coluna="00100" and s13="00" and stop = '0') else
		      "0100" when (coluna="00100" and s23="00" and stop = '0') else
		      "0010" when (coluna="00100" and s33="00" and stop = '0') else
	   	   "0001" when (coluna="00100" and s43="00" and stop = '0') else
		      "0000"; 
		 
		en4<= "1000" when (coluna="01000" and s14="00" and stop = '0') else
		      "0100" when (coluna="01000" and s24="00" and stop = '0') else
		      "0010" when (coluna="01000" and s34="00" and stop = '0') else
	   	   "0001" when (coluna="01000" and s44="00" and stop = '0') else
		      "0000"; 
 
		en5<= "1000" when (coluna="10000" and s15="00" and stop = '0') else
		      "0100" when (coluna="10000" and s25="00" and stop = '0') else
		      "0010" when (coluna="10000" and s35="00" and stop = '0') else
	   	   "0001" when (coluna="10000" and s45="00" and stop = '0') else
		      "0000";
		 

		--Caso algum enable tenha sido ligado, mas nao de duas coluna diferentes ao mesmo tempo, a jogada foi valida

		j_val<= (en1(0) or en1(1) or en1(2) or en1(3)) xor (en2(0) or en2(1) or en2(2) or en2(3)) xor (en3(0) or en3(1) or en3(2) or en3(3)) xor (en4(0) or en4(1) or en4(2) or en4(3)) xor (en5(0) or en5(1) or en5(2) or en5(3));
		

		--Utiliza os valores dos flip-flops para prencher os vetores de verificacao
		--tab_1 usa o bit mais significativo do flip, pois indica jogador 1, ja taab_2 usa o menos
		--O vetor e preenchido  por linha(de cima para baixo) da coluna da esquerda para a direita
		
		tab_1(19 downto 15) <= s45(1) & s44(1) & s43(1) & s42(1) & s41(1);
		tab_1(14 downto 10) <= s35(1) & s34(1) & s33(1) & s32(1) & s31(1); 
		tab_1(9 downto 5)   <= s25(1) & s24(1) & s23(1) & s22(1) & s21(1); 
		tab_1(4 downto 0)   <= s15(1) & s14(1) & s13(1) & s12(1) & s11(1); 

		tab_2(19 downto 15) <= s45(0) & s44(0) & s43(0) & s42(0) & s41(0);
		tab_2(14 downto 10) <= s35(0) & s34(0) & s33(0) & s32(0) & s31(0); 
		tab_2(9 downto 5)   <= s25(0) & s24(0) & s23(0) & s22(0) & s21(0); 
		tab_2(4 downto 0)   <= s15(0) & s14(0) & s13(0) & s12(0) & s11(0); 

	end Behaviour;
