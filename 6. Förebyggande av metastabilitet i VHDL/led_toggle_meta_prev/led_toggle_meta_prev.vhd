--------------------------------------------------------------------------------
-- @brief Digital design where a LED is toggled at pressdown (falling edge)
--        of a push button. Metastability prevention is implemented via the
--        double flop technique, i.e. every input signal is synchronized via
--        two flip flops.
--
-- @param clock
--        50 MHz system clock.
-- @param reset_n
--        Inverting reset signal connected to a push button.
-- @param button_n
--        Inverting push button for toggling the LED.
-- @param led
--        LED toggled at pressdown of the push button.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity led_toggle_meta_prev is
    port(clock, reset_n, button_n: in std_logic;
         led                     : out std_logic);
end entity;

architecture behaviour of led_toggle_meta_prev is

--------------------------------------------------------------------------------
-- @brief Internal signals in the top module.
--
-- @param reset_s2_n
--        Synchronized reset signal.
-- @param button_pressed_s2
--         Synchronized event flag indicating pressdown of button_n.
-- @param led_s
--        Stores the value of LED.
--------------------------------------------------------------------------------
signal reset_s2_n       : std_logic := '1'; 
signal button_pressed_s2: std_logic := '0'; 
signal led_s            : std_logic := '0'; 
begin

    --------------------------------------------------------------------------------
    -- @brief Creates synchronized input signals and performs event detection for
    --        detecting pressdown of the push button.
    --------------------------------------------------------------------------------
    meta_prev1: entity work.meta_prev
    port map(clock, reset_n, button_n, reset_s2_n, button_pressed_s2);
    
    --------------------------------------------------------------------------------
    -- @brief Toggles the LED at pressdown of the push button. If a system reset
    --        occurs, the LED is immediately disabled.
    --------------------------------------------------------------------------------
    LED_PROCESS: process (clock, reset_s2_n) is
    begin
        if (reset_s2_n = '0') then
            led_s <= '0';
        elsif (rising_edge(clock)) then
            if (button_pressed_s2 = '1') then
                led_s <= not led_s;
            end if;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief The LED is assigned contiuously the value of corresponding internal
    --        signal led_s.
    --------------------------------------------------------------------------------
    led <= led_s;

end architecture;