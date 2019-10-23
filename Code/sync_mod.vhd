library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sync_mod is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           y_control : out STD_LOGIC_VECTOR (9 downto 0);
           x_control : out STD_LOGIC_VECTOR (9 downto 0);
           h_s : out STD_LOGIC;
           v_s : out STD_LOGIC;
           video_on : out STD_LOGIC);
end sync_mod;

architecture Behavioral of sync_mod is

    -- Video Parameters
    constant HR:integer:=640;--Horizontal Resolution
    constant HFP:integer:=16;--Horizontal Front Porch 
    constant HBP:integer:=48;--Horizontal Back Porch
    constant HRet:integer:=96;--Horizontal retrace
    constant VR:integer:=480;--Vertical Resolution
    constant VFP:integer:=10;--Vertical Front Porch 
    constant VBP:integer:=33;--Vertical Back Porch
    constant VRet:integer:=2;--Vertical Retrace
	 
	 
    --sync counter
    signal counter_h,counter_h_next: integer range 0 to 799;
    signal counter_v,counter_v_next: integer range 0 to 524;
	 
    --State signals
    signal h_end, v_end:std_logic:='0';
	 
    --Output Signals(buffer)
    signal hs_buffer,hs_buffer_next:std_logic:='0';
    signal vs_buffer,vs_buffer_next:std_logic:='0';
	 
    --pixel counter
    signal x_counter, x_counter_next:integer range 0 to 900;
    signal y_counter, y_counter_next:integer range 0 to 900;
	 
    --video_on_off
    signal video:std_logic;
	 
begin
    --clk register
    process(clk,reset,start)
    begin
        if reset ='1' then
           counter_h<=0;
           counter_v<=0;
           hs_buffer<='0';
           vs_buffer<='0';		  
        elsif rising_edge(clk) then 
           if start='1' then
                counter_h<=counter_h_next;
                counter_v<=counter_v_next;
                x_counter<=x_counter_next;
                y_counter<=y_counter_next;
                hs_buffer<=hs_buffer_next;
                vs_buffer<=vs_buffer_next;
            end if;
       end if;
    end process;
	 
    --video on/off
    video <= '1' when (counter_v >= VBP) and (counter_v < VBP + VR) and (counter_h >=HBP) and (counter_h < HBP + HR) else 
             '0';
	 
    --end of Horizontal scanning 
    h_end<= '1' when counter_h = 799 else 
            '0'; 
				
    -- end of Vertical scanning
    v_end<= '1' when counter_v = 524 else 
            '0';
			
	 -- horizontal counting
	 counter_h_next <= counter_h + 1 when h_end = '0' else
							 0;
							 
	 -- vertical counting						 
	 counter_v_next <= counter_v when h_end = '0' else
							 counter_v + 1 when h_end = '1' and v_end = '0' else
							 0;
	
	 --pixel x counter	
	 x_counter_next <= x_counter + 1 when video = '1' and x_counter < 639 else
						    0;

	 --pixel y counter
	 y_counter_next <= y_counter when h_end = '0' else
							 y_counter + 1 when h_end = '1' and counter_v > 32 and counter_v < 512 else
							 0;

    --buffer
    hs_buffer_next <= '1' when counter_h < 704 else -- (HBP+HR+HFP) 
                      '0';
							
    vs_buffer_next <= '1' when counter_v < 523 else -- (VBP+VR+VFP) 
                      '0';

    --outputs
    y_control <= conv_std_logic_vector(y_counter,10); 
    x_control <= conv_std_logic_vector(x_counter,10); 
    h_s <= hs_buffer;
    v_s <= vs_buffer;
    video_on <= video;

end Behavioral;