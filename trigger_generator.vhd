library ieee;
use ieee.std_logic_1164.all;

entity trigger_generator is
        port( clk: in std_logic;
        trigg : out std_logic);
end entity;
architecture behaviour of trigger_generator is

    component counter is
    generic(n : positive :=10);
    port(   clk: in std_logic;
            enable : in std_logic;
            reset2 : in std_logic; -- active low
            counter_output: out std_logic_vector(n-1 downto 0));
    end component;
    
signal resetCounter:std_logic;
signal outputCounter: std_logic_vector(23 downto 0);

begin
trigger_gen:counter generic map(24) port map(clk,'1',resetCounter,outputCounter);

process(clk)

constant ms100:std_logic_vector(23 downto 0):="010011000100101101000000";--20ns/100ms
-- constant ms100And20us: std_logic_vector(23 downto 0):="010011000100111100100110";
constant ms100And20us: std_logic_vector(23 downto 0):="010011000100110100110011";--20ns/(100ms+20us)
begin
        if(outputCounter > ms100 and outputCounter < ms100And20us) then
        trigg <= '1';
        else
        trigg <='0';
        end if;
        if(outputCounter = ms100and20us or outputCounter="XXXXXXXXXXXXXXXXXXXXXXXX") then
        resetCounter <= '0';
        else
        resetCounter <= '1';
        end if;
        
end process;
end architecture;