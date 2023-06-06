--------------------------------------------------------------------------------
-- @brief Digital design where three LEDs are toggled with different frequencies
--        via three separate timer circuits. Activation of te timer circuits 
--        are toggled via three push buttons. When an arbitrary timer is 
--        disabled the corresponding LED is disabled, else it's toggled
--        when the timer elapses.
--
-- @param clock
--        50 MHz system clock.
-- @param reset_n
--        Inverting asynchronous reset signal.
-- @param button_n
--        Inverting push buttons for toggling the timer circuits.
-- @param led
--        LEDs toggled via three separate timer circuits.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.misc.all;

entity led_toggle_timer is
    port(clock, reset_n: in std_logic;
         button_n      : in std_logic_vector(2 downto 0);
         led           : out std_logic_vector(2 downto 0));
end entity;

architecture behaviour of led_toggle_timer is

--------------------------------------------------------------------------------
-- @brief Signals used in the top module.
-- 
-- @param reset_s2_n
--        Synchronized reset signal used in the design.
-- @param button_pressed_s2
--        Synchronized event flags indicating pressdown of each push button.
-- @param led_s
--        Contains the value of each LED.
-- @param timer_enabled
--        Enable signals for each timer.
-- @param timer_elapsed
--        Event flags indicating when each timer elapses.
--------------------------------------------------------------------------------
signal reset_s2_n                  : std_logic := '1';
signal button_pressed_s2, led_s    : std_logic_vector(2 downto 0) := (others => '0');
signal timer_enabled, timer_elapsed: std_logic_vector(2 downto 0) := (others => '0');

begin

    --------------------------------------------------------------------------------
    -- @brief Synchronizes the input signals and perform event detection of the
    --        push buttons.
    --------------------------------------------------------------------------------
    meta_prev1: entity work.meta_prev
    generic map(NUM_BUTTONS => 3)
    port map(clock, reset_n, button_n, reset_s2_n, button_pressed_s2);
    
    --------------------------------------------------------------------------------
    -- @brief Creates a timer that elapses every 100 ms (10 Hz) when enabled.
    --------------------------------------------------------------------------------
    timer0: entity work.timer
    generic map(FREQUENCY => FREQUENCY_10HZ)
    port map(clock, reset_s2_n, timer_enabled(0), timer_elapsed(0));
    
    --------------------------------------------------------------------------------
    -- @brief Creates a timer that elapses every 200 ms (5 Hz) when enabled.
    --------------------------------------------------------------------------------
    timer1: entity work.timer
    generic map(FREQUENCY => FREQUENCY_5HZ)
    port map(clock, reset_s2_n, timer_enabled(1), timer_elapsed(1));
    
    --------------------------------------------------------------------------------
    -- @brief Creates a timer that elapses every 1000 ms (1 Hz) when enabled.
    --------------------------------------------------------------------------------
    timer2: entity work.timer
    port map(clock, reset_s2_n, timer_enabled(2), timer_elapsed(2));
    
    --------------------------------------------------------------------------------
    -- @brief Toggles each timer at pressdown of corresponding push button.
    --        At system reset, all timers are immediately disabled.
    --------------------------------------------------------------------------------
    TIMER_PROCESS: process(clock, reset_s2_n) is
    begin
        if (reset_s2_n = '0') then
            timer_enabled <= (others => '0');
        elsif (rising_edge(clock)) then
            for i in 0 to 2 loop
                if (button_pressed_s2(i) = '1') then
                    timer_enabled(i) <= not timer_enabled(i);
                end if;
            end loop;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Toggles each LED when corresponding timer has elapsed.
    --        If the timer is disabled, the LED is disabled. If a system reset
    --        occurs, all LEDs are immediately disabled.
    --------------------------------------------------------------------------------
    LED_PROCESS: process(clock, reset_s2_n) is
    begin
        if (reset_s2_n = '0') then
            led_s <= (others => '0');
        elsif (rising_edge(clock)) then
            for i in 0 to 2 loop
                if (timer_enabled(i) = '1') then
                    if (timer_elapsed(i) = '1') then
                        led_s(i) <= not led_s(i);
                    end if;
                else
                    led_s(i) <= '0';
                end if;
            end loop;
        end if;
    end process;
    
    led <= led_s;

end architecture;