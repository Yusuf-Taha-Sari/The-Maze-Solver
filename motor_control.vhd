library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity motor_control is
 Port ( clk, sw0, sw15, sw14, pulse_F, pulse_R, pulse_L  : in STD_LOGIC;
 pwm1, pwm2, pwm3, pwm4 : out STD_LOGIC;
 trigger_F, trigger_R, trigger_L : inout STD_LOGIC); 
 
end motor_control;


architecture Behavioral of motor_control is
signal count: integer range 0 to 50000;
signal speed_1: integer := 0;
signal obstacle_F: std_logic;
signal obstacle_R: std_logic;
signal obstacle_L: std_logic;
signal sonuc_F : std_logic;
signal sonuc_R : std_logic;
signal sonuc_L : std_logic;

component ultrasonic is
        port(
        clk: in std_logic;
        pulsee: in std_logic; -- echo
        trigOut:inout std_logic; -- trigger out
        obs:inout std_logic;
        sonucc:out std_logic);
end component;

begin

a: ultrasonic 
    port map (clk=>clk,
              pulsee => pulse_F,
              trigOut => trigger_F,
              obs => obstacle_F,
              sonucc => sonuc_F);
 b: ultrasonic 
    port map (clk=>clk,
              pulsee => pulse_R,
              trigOut => trigger_R,
              obs => obstacle_R,
              sonucc => sonuc_R);  
              
c:ultrasonic 
    port map (clk=>clk,
              pulsee => pulse_L,
              trigOut => trigger_L,
              obs => obstacle_L,
              sonucc => sonuc_L);           
             
process(clk, sw0, obstacle_F, obstacle_R, obstacle_L, speed_1)
 begin
 if (sw0='1') then
    speed_1 <= 12000;
 else
    speed_1 <= 0;
 end if;



if(rising_edge(clk)) then
    count <= count+1;
    if(count = 49999) then
    count <= 0;
    end if;
end if;   
    if(count < speed_1 ) then
--pwm1 = sol tekerlek kýrmýz
--pwm2 = sol tekerlek siyah 
--pwm4 = sað tekerlek kýrmýz
--pwm3 = sað tekerlek siyah
        if(sonuc_F = '0' and sonuc_R = '0'and sonuc_L ='0') then
              pwm1 <= '1';
              pwm2 <= '0';
              pwm3 <= '1';
              pwm4 <= '0';
        elsif(sonuc_F = '0' and sonuc_R = '0'and sonuc_L ='1') then
              pwm1 <= '1';
              pwm2 <= '0';
              pwm3 <= '1';
              pwm4 <= '0';
              
        elsif(sonuc_F = '0' and sonuc_R = '1'and sonuc_L ='0') then
              pwm1 <= '0';
              pwm2 <= '1';
              pwm3 <= '0';
              pwm4 <= '1';
        elsif(sonuc_F = '0' and sonuc_R = '1'and sonuc_L ='1') then
              pwm1 <= '0';
              pwm2 <= '1';
              pwm3 <= '0';
              pwm4 <= '1';
        elsif(sonuc_F = '1' and sonuc_R = '0'and sonuc_L ='0') then
              pwm1 <= '0';
              pwm2 <= '1';
              pwm3 <= '1';
              pwm4 <= '0';
        elsif(sonuc_F = '1' and sonuc_R = '0'and sonuc_L ='1') then
              pwm1 <= '1';
              pwm2 <= '0';
              pwm3 <= '1';
              pwm4 <= '0';
        elsif(sonuc_F = '1' and sonuc_R = '1'and sonuc_L ='0') then
              pwm1 <= '0';
              pwm2 <= '1';
              pwm3 <= '0';
              pwm4 <= '1';    
              
        else
              pwm1 <= '0';    
              pwm2 <= '1';
              pwm3 <= '1';
              pwm4 <= '0';
        end if;
        

else 
    pwm1 <= '0';
    pwm2 <= '0';
    pwm3 <= '0';
    pwm4 <= '0';    
    end if;
end process;
end Behavioral;
