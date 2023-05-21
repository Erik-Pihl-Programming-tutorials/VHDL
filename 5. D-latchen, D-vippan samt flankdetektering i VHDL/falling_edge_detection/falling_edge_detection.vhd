--------------------------------------------------------------------------------
-- falling_edge_detection.vhd: Toggling a LED at pressdown (falling edge) of
--                             an inverting push button.
--
--                             Inputs:
--                                 - clock   : 50 MHz system clock.
--                                 - reset_n : Invertering asynchronous reset.
--                                 - button_n: Inverting button for toggling
--                                             the LED.
--                             Outputs:
--                                 - led     : LED toggled at pressdown of
--                                             the button.
--
--                             Function:
--                                 - reset_n = 0 (system reset) => led = 0
--                                 - reset_n = 1 (normal execution) && 
--                                   button_pressed = 1 => led = !led.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity falling_edge_detection is
    port(clock, reset_n, button_n: in std_logic;
         led                     : out std_logic);
end entity;

architecture behaviour of falling_edge_detection is
signal button_n_previous    : std_logic := '1';
signal button_pressed, led_s: std_logic := '0';
begin

    --------------------------------------------------------------------------------
    -- EDGE_DETECTION_PROCESS: Detects falling edge (pressdown) of button_n, i.e. 
    --                         current value = 0, previous value = 1.
    --                         Then the signal button_pressed is set.
    --------------------------------------------------------------------------------
    EDGE_DETECTION_PROCESS: process(clock, reset_n) is
    begin
        if (reset_n = '0') then
            button_pressed <= '0';
            button_n_previous <= '1';
        elsif (rising_edge(clock)) then
            if (button_n = '0' and button_n_previous = '1') then
                button_pressed <= '1';
            else
                button_pressed <= '0';
            end if;
            button_n_previous <= button_n;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- OUTPUT_PROCESS: Sets the output of the LED. If the button is pressed, the
    --                 LED is toggled. At system reset, the LED is disabled.
    --------------------------------------------------------------------------------
    OUTPUT_PROCESS: process(clock, reset_n) is
    begin
        if (reset_n = '0') then
           led_s <= '0';
        elsif (rising_edge(clock)) then
            if (button_pressed = '1') then
                led_s <= not led_s;
            end if;
        end if;
    end process;
    
    led <= led_s;

end architecture;