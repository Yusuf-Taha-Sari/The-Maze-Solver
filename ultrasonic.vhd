library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std;

entity ultrasonic is
        port(
        clk: in std_logic;
        pulsee: in std_logic; -- echo
        trigOut:inout std_logic; -- trigger out
        sonucc:out std_logic;
        obs : inout std_logic);
end entity;

architecture behaviour of ultrasonic is
component counter is

generic(n : positive :=10);
port( clk: in std_logic;
    enable : in std_logic;
    reset2 : in std_logic; -- active low
    counter_output: out std_logic_vector(n-1 downto 0));
end component;


component trigger_generator is
    port( clk: in std_logic;
    trigg : out std_logic);
end component;

--signal triggerOut: std_logic;
--signal distanceOut:std_logic(21 downto 0);
signal pulse_width: std_logic_vector(21 downto 0);
signal trigg:std_logic;
signal triggnot: std_logic;
signal obstacle_reg: STD_LOGIC_VECTOR( 69 downto 0):="0000000000000000000000000000000000000000000000000000000000000000000000";


begin
triggnot <= not(trigg);
counter_echo_pulse :
counter generic map(22) 
        port map(clk => clk,
                 enable =>pulsee,
                 reset2 => triggnot,
                 counter_output => pulse_width);

trigger_generation :
trigger_generator port map(clk,trigg);
obstacle_detection: process(pulse_width)
begin
if(pulse_width < 55000) then
obs <= '1';

--pwm_r <='1';
--pwm_b <='0';
else
obs <= '0';

--pwm_r <='0';
--pwm_b <='1';

end if;
end process;
   
process(clk)
begin
    if clk'event and clk ='1' then
        obstacle_reg<= obstacle_reg(68 downto 0) & obs ;
    end if;    
    
    
    if (obstacle_reg = "1111111111111111111111111111111111111111111111111111111111111111111111") then
    sonucc <='0';    
    else 
    sonucc <='1';
    end if;
end process;
trigOut <= trigg;

end architecture;
