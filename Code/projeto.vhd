-- Iago Agrella Fancio			155746
-- F�bio Morook    167072
-- Hugo Secreto    169709
-- Lucas Lima      172831
-- Pedro Gabriel   175718

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity projeto is	
    Port ( CLOCK_50 : in STD_LOGIC;							-- Entrada: Clock 50: clock 50 MHz
           SW : in STD_LOGIC_VECTOR (4 downto 0);					-- Entrada: Chaves que controlam qual casa sera jogada
			  key: in std_LOGIC_Vector(1 downto 0);				-- Entrada: Key(1) -> Reset | Key(0)-> Clock de jogada 
			  VGA_R : out STD_LOGIC_Vector (7 downto 0);			-- Saida: 	VGA 
			  VGA_G : out STD_LOGIC_Vector (7 downto 0);				
			  VGA_B : out STD_LOGIC_Vector (7 downto 0);				
			  VGA_CLK : out STD_LOGIC;											
			  VGA_BLANK_N : out STD_LOGIC;								
			  VGA_HS : out STD_LOGIC;
			  VGA_vS : out STD_LOGIC;
			  VGA_SYNC_N : out STD_LOGIC
			);
end projeto;

architecture Behavioral of projeto is

   COMPONENT sync_mod
          PORT( clk : IN std_logic;
                reset : IN std_logic;
                start : IN std_logic; 
                y_control : OUT std_logic_vector(9 downto 0);
                x_control : OUT std_logic_vector(9 downto 0);
                h_s : OUT std_logic;
                v_s : OUT std_logic;
					 video_on : out STD_LOGIC );
   END COMPONENT;
	
	COMPONENT TABULEIRO 
		Port ( 	jogador:	in std_logic_vector(1 downto 0);
			coluna: 	in std_logic_vector(4 downto 0);
			clockj,resetn,stop: 	in std_logic;
			j_val: 		out std_logic := '0';
			tab_1,tab_2:	out std_logic_vector(19 downto 0));
	END COMPONENT;
	
	COMPONENT Resultado 
			port(
				tab_1,tab_2: in std_logic_vector(19 downto 0);			-- Entrada: tabela virtual das jogadas dos jogadores separadas para cada jogador
				signalWin1,signalWin2: buffer std_logic;			-- Buffer: sinal que avisa quando algum jogador ganhou
				signalDraw: out std_logic					-- Saida: sinal que avisa quando houver empate
			);
	END COMPONENT;
		
	signal rgb, cor_borda, cor_jog0, cor_jog1: std_logic_vector(2 downto 0);	-- Sinais: rgb -> cores que serao mandadas para o vga; cor_borda -> cores da borda do tabuleiro; cor_jog0 -> cor do jogador 1; cor_jog1 -> cor do jogaodr 2
	signal video,clk : std_logic;							-- Sinais: video -> sinal de controle da tela; clk -> clock da tela
	signal x_control, y_control : std_logic_vector(9 downto 0);			-- Sinais: x_control -> controle da posicao x na tela; y_control -> controle da posicao y na tela
	signal tab_1, tab_2: std_LOGIC_Vector(19 downto 0);				-- Sinais: tab_jogadas -> tabuleiro virtual das jogadas realizadas; tab_jogadores -> tabulaiero virtual das jogadas dos jogadores
	signal Win1, Win2, draw, reset, clock_play: std_LOGIC;				-- Sinais: vitoria -> indica se houve vitoria; empate -> indica se houve empate; vencedor -> indica quem ganhou; reset -> sinal de reset; clock_play -> clock das jogadas
	signal comando: std_LOGIC_VECTOR(4 downto 0);					-- Sinais: comando -> indica em qual casa sera realizada a jogada
	signal jogador: std_logic_vector( 1 downto 0);
	signal valor, stop: std_logic;
	
	begin
		
	process(clock_play, valor) 						-- Process para mudan�a de turno de jogador, s� pode mudar turno ao realizar uma jogada v�lida.
	    variable joga: std_logic_vector(1 downto 0)  :="10";
	    begin
	      if(rising_edge(clock_play)) then
	         if( valor = '1') then
			joga := not(joga);
		 else 
			joga := joga;
		 end if;
	      end if;
	      jogador <= joga;
	end process;
		
		tab01: tabuleiro port map(jogador,comando,clock_play,reset,stop,valor,tab_1,tab_2); --Faz a jogada do jogador
  
		process(CLOCK_50)																								-- ajuste do clock 50 para clock 25 MHz
			variable temp : std_logic := '0';
			begin
				
				if(rising_edge(CLOCK_50)) then
					temp := not temp;
				end if;
			
				clk <= temp;
		end process;
	
	
		comando <= sw(4 downto 0);				-- comando recebe as chaves de entrada para saber a casa jogada
		clock_play <= not key(0);				-- clock_play recebe key(0) para controle das jogadas
		reset <= key(1);					-- reset recebe key(1) para reiniciar o jogo
		cor_jog0 <= "100";					-- cor do jogador 1 eh vermelho
		cor_jog1 <= "001";					-- cor do jogador 2 eh azul
		
		C2: sync_mod PORT MAP( clk, '0', '1', y_control, x_control, VGA_HS, VGA_VS, video );	-- sincronizador da tela
		
		rgb <=  "000" when video = '0' else
				  cor_borda when x_control > "0001111000" and x_control < "0010000010" else 	-- pinta as bordas, as colunas e as linhas  de cor_borda
				  cor_borda when x_control > "0011111010" and x_control < "0100000100" else 							
				  cor_borda when x_control > "0101111100" and x_control < "0110000110" else 							
				  cor_borda when x_control > "0111111110" and x_control < "1000001000" else 							
				  cor_borda when y_control > "0001101001" and y_control < "0001111101" else 							
				  cor_borda when y_control > "0011100110" and y_control < "0011111010" else
				  cor_borda when y_control > "0101100011" and y_control < "0101110111" else
					
				  cor_jog0 when ((tab_1(19) = '1') and (x_control >= "0000000000" and x_control < "0001111000") and (y_control > "0000000000" and y_control < "0001101001")) else
				  cor_jog1 when ((tab_2(19) = '1') and (x_control >= "0000000000" and x_control < "0001111000") and (y_control > "0000000000" and y_control < "0001101001")) else

				  cor_jog0 when ((tab_1(18) = '1') and (x_control >= "0010000010" and x_control < "0011111010") and (y_control > "0000000000" and y_control < "0001101001")) else
				  cor_jog1 when ((tab_2(18) = '1') and (x_control >= "0010000010" and x_control < "0011111010") and (y_control > "0000000000" and y_control < "0001101001")) else

				  cor_jog0 when ((tab_1(17) = '1') and (x_control >= "0100000100" and x_control < "0101111100") and (y_control > "0000000000" and y_control < "0001101001")) else
				  cor_jog1 when ((tab_2(17) = '1') and (x_control >= "0100000100" and x_control < "0101111100") and (y_control > "0000000000" and y_control < "0001101001")) else

				  cor_jog0 when ((tab_1(16) = '1') and (x_control >= "0110000110" and x_control < "0111111110") and (y_control > "0000000000" and y_control < "0001101001")) else
				  cor_jog1 when ((tab_2(16) = '1') and (x_control >= "0110000110" and x_control < "0111111110") and (y_control > "0000000000" and y_control < "0001101001")) else

				  cor_jog0 when ((tab_1(15) = '1') and (x_control >= "1000001000" and x_control < "1010000000") and (y_control > "0000000000" and y_control < "0001101001")) else
				  cor_jog1 when ((tab_2(15) = '1') and (x_control >= "1000001000" and x_control < "1010000000") and (y_control > "0000000000" and y_control < "0001101001")) else

				  cor_jog0 when ((tab_1(14) = '1') and (x_control >= "0000000000" and x_control < "0001111000") and (y_control > "0010000111" and y_control < "0011100110")) else
				  cor_jog1 when ((tab_2(14) = '1') and (x_control >= "0000000000" and x_control < "0001111000") and (y_control > "0010000111" and y_control < "0011100110")) else
                                                   
				  cor_jog0 when ((tab_1(13) = '1') and (x_control >= "0010000010" and x_control < "0011111010") and (y_control > "0010000111" and y_control < "0011100110")) else
				  cor_jog1 when ((tab_2(13) = '1') and (x_control >= "0010000010" and x_control < "0011111010") and (y_control > "0010000111" and y_control < "0011100110")) else
                                                   
				  cor_jog0 when ((tab_1(12) = '1') and (x_control >= "0100000100" and x_control < "0101111100") and (y_control > "0010000111" and y_control < "0011100110")) else
				  cor_jog1 when ((tab_2(12) = '1') and (x_control >= "0100000100" and x_control < "0101111100") and (y_control > "0010000111" and y_control < "0011100110")) else
                                                   
				  cor_jog0 when ((tab_1(11) = '1') and (x_control >= "0110000110" and x_control < "0111111110") and (y_control > "0010000111" and y_control < "0011100110")) else
				  cor_jog1 when ((tab_2(11) = '1') and (x_control >= "0110000110" and x_control < "0111111110") and (y_control > "0010000111" and y_control < "0011100110")) else
                                                        
				  cor_jog0 when ((tab_1(10) = '1') and (x_control >= "1000001000" and x_control < "1010000000") and (y_control > "0010000111" and y_control < "0011100110")) else
				  cor_jog1 when ((tab_2(10) = '1') and (x_control >= "1000001000" and x_control < "1010000000") and (y_control > "0010000111" and y_control < "0011100110")) else

				  cor_jog0 when ((tab_1(9) = '1') and (x_control >= "0000000000" and x_control < "0001111000") and (y_control > "0011111010" and y_control < "0101100011")) else
				  cor_jog1 when ((tab_2(9) = '1') and (x_control >= "0000000000" and x_control < "0001111000") and (y_control > "0011111010" and y_control < "0101100011")) else
                                                  
				  cor_jog0 when ((tab_1(8) = '1') and (x_control >= "0010000010" and x_control < "0011111010") and (y_control > "0011111010" and y_control < "0101100011")) else
				  cor_jog1 when ((tab_2(8) = '1') and (x_control >= "0010000010" and x_control < "0011111010") and (y_control > "0011111010" and y_control < "0101100011")) else
                                                  
				  cor_jog0 when ((tab_1(7) = '1') and (x_control >= "0100000100" and x_control < "0101111100") and (y_control > "0011111010" and y_control < "0101100011")) else
				  cor_jog1 when ((tab_2(7) = '1') and (x_control >= "0100000100" and x_control < "0101111100") and (y_control > "0011111010" and y_control < "0101100011")) else
                                                  
				  cor_jog0 when ((tab_1(6) = '1') and (x_control >= "0110000110" and x_control < "0111111110") and (y_control > "0011111010" and y_control < "0101100011")) else
				  cor_jog1 when ((tab_2(6) = '1') and (x_control >= "0110000110" and x_control < "0111111110") and (y_control > "0011111010" and y_control < "0101100011")) else
                                                  
				  cor_jog0 when ((tab_1(5) = '1') and (x_control >= "1000001000" and x_control < "1010000000") and (y_control > "0011111010" and y_control < "0101100011")) else
				  cor_jog1 when ((tab_2(5) = '1') and (x_control >= "1000001000" and x_control < "1010000000") and (y_control > "0011111010" and y_control < "0101100011")) else
				  
				  cor_jog0 when ((tab_1(4) = '1') and (x_control >= "0000000000" and x_control < "0001111000") and (y_control > "0101110111" and y_control < "0111100000")) else
				  cor_jog1 when ((tab_2(4) = '1') and (x_control >= "0000000000" and x_control < "0001111000") and (y_control > "0101110111" and y_control < "0111100000")) else
                                                  
				  cor_jog0 when ((tab_1(3) = '1') and (x_control >= "0010000010" and x_control < "0011111010") and (y_control > "0101110111" and y_control < "0111100000")) else
				  cor_jog1 when ((tab_2(3) = '1') and (x_control >= "0010000010" and x_control < "0011111010") and (y_control > "0101110111" and y_control < "0111100000")) else
                                                  
				  cor_jog0 when ((tab_1(2) = '1') and (x_control >= "0100000100" and x_control < "0101111100") and (y_control > "0101110111" and y_control < "0111100000")) else
				  cor_jog1 when ((tab_2(2) = '1') and (x_control >= "0100000100" and x_control < "0101111100") and (y_control > "0101110111" and y_control < "0111100000")) else
                                                  
				  cor_jog0 when ((tab_1(1) = '1') and (x_control >= "0110000110" and x_control < "0111111110") and (y_control > "0101110111" and y_control < "0111100000")) else
				  cor_jog1 when ((tab_2(1) = '1') and (x_control >= "0110000110" and x_control < "0111111110") and (y_control > "0101110111" and y_control < "0111100000")) else
                                                  
				  cor_jog0 when ((tab_1(0) = '1') and (x_control >= "1000001000" and x_control < "1010000000") and (y_control > "0101110111" and y_control < "0111100000")) else
				  cor_jog1 when ((tab_2(0) = '1') and (x_control >= "1000001000" and x_control < "1010000000") and (y_control > "0101110111" and y_control < "0111100000")) else
				  
				  "111";
				  
		R1: resultado port map (tab_1,tab_2,Win1, Win2, draw);		  
		
		cor_borda <=	"100" when Win1 = '1' else 			-- cor que a borda assume sendo preto quando nao houve ganhador ou empate; branco em caso de empate; azul em caso da vitoria do jogador 2; vermelho em caso de vitoria do jogador 1
							"001" when Win2 = '1' else
							"111" when draw = '1' else
							"000";
							
		stop <= Win1 or Win2;					
		
	   VGA_R <= (OTHERS => rgb(2));				-- coresw do VGA
		VGA_G <= (OTHERS => rgb(1));
		VGA_B <= (OTHERS => rgb(0));
		
		VGA_CLK <= clk;
		VGA_BLANK_N<='1';
		VGA_SYNC_N<='0';
		
		

end Behavioral;