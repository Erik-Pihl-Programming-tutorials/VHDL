--------------------------------------------------------------------------------
-- @brief Module for synchronizing the input signals to prevent metastability.
--        Event detection to detect pressdown of the push button is also
--        performed.
--
-- @param clock
--        50 MHz system clock.
-- @param reset_n
--        Inverting reset signal connected to a push button.
-- @param button_n
--        Inverting push button for toggling the LED.
-- @param reset_s2_n
--        Inverting synchronized reset signal.
-- @param button_pressed_s2
--        Synchronized event flag, indicates pressdown of button_n.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity meta_prev is
    port(clock, reset_n, button_n     : in std_logic;
         reset_s2_n, button_pressed_s2: out std_logic);
end entity;

architecture behaviour of meta_prev is

--------------------------------------------------------------------------------
-- @brief Signals for synchronization of the input signals.
--------------------------------------------------------------------------------
signal reset_s1_n_s, reset_s2_n_s           : std_logic; 
signal button_s1_n, button_s2_n, button_s3_n: std_logic;
begin

    --------------------------------------------------------------------------------
    -- @brief Synchronizes the reset signals. At system reset (reset_n = 0), the
    --        signals are immediately cleared. Else at rising edge of the clock,
    --        reset_s1_n_s is set, while reset_s2_n_s is assigned the output of
    --        reset_s1_n_s (i.e. the old value).
    --------------------------------------------------------------------------------
    RESET_PROCESS: process (clock, reset_n) is
    begin
        if (reset_n = '0') then
            reset_s1_n_s <= '0';
            reset_s2_n_s <= '0';
        elsif (rising_edge(clock)) then
            reset_s1_n_s <= '1';
            reset_s2_n_s <= reset_s1_n_s;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Synchronizes the button signals. At system reset (reset_s2_n_s = 0),
    --        the signals are immediately set. Else at rising edge of the clock,
    --        button_s1_n is assigned button_n, button_s2_n is assigned button_s1_n
    --        and button_s3_n is assigned button_s2_n.
    --------------------------------------------------------------------------------
    BUTTON_PROCESS: process (clock, reset_s2_n_s) is
    begin
        if (reset_s2_n_s = '0')  then
            button_s1_n <= '1';
            button_s2_n <= '1';
            button_s3_n <= '1';
        elsif (rising_edge(clock)) then
            button_s1_n <= button_n;
            button_s2_n <= button_s1_n;
            button_s3_n <= button_s2_n;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Reset signal reset_s2_n is continuously assigned the value of
    --        corresponding internal signal reset_s2_n_s.
    --------------------------------------------------------------------------------
    reset_s2_n <= reset_s2_n_s;
    
    --------------------------------------------------------------------------------
    -- @brief If "current" input button_s2_n = 0 and "previous" input button_s3_n
    --        = 1, the button is pressed (falling edge) and the corresponding
    --        output button_pressed_s2 is set, else it's cleared.
    --------------------------------------------------------------------------------
    button_pressed_s2 <= '1' when button_s2_n = '0' and button_s3_n = '1' else '0';

end architecture;