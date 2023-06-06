--------------------------------------------------------------------------------
-- @brief Module for creating a timer circuit with selectable frequency.
--
-- @param FREQUENCY
--        The timer frequency as a natural integer (default = 1 Hz).
-- @param clock
--        50 MHz system clock.
-- @param reset_s2_n
--        Inverting asynchronous reset signal.
-- @param enabled
--        Indicates if the timer is enabled.
-- @param elapsed
--        Indicates if the timer has elapsed.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.misc.all;

entity timer is
    generic(FREQUENCY: natural := FREQUENCY_1HZ);
    port(clock, reset_s2_n, enabled: in std_logic;
         elapsed                : out std_logic);
end entity;

architecture behaviour of timer is
constant MAX_VAL: natural := FREQUENCY;
signal counter  : natural range 0 to MAX_VAL;
begin

    --------------------------------------------------------------------------------
    -- @brief Increments the counter at rising edge of the clock if the enable
    --        signal is set. When the counter is equal to MAX_VAL, the timer has
    --        elapsed and the counter is cleared. If a system reset occurs, the
    --        counter is immediately cleared.
    --------------------------------------------------------------------------------
    COUNTER_PROCESS: process(clock, reset_s2_n) is
    begin
        if (reset_s2_n = '0') then
            counter <= 0;
            elapsed <= '0';
        elsif (rising_edge(clock)) then
            if (enabled = '1') then
                if (counter < MAX_VAL) then
                    counter <= counter + 1;
                    elapsed <= '0';
                else
                    counter <= 0;
                    elapsed <= '1';
                end if;
            else
                elapsed <= '0';
            end if;
        end if;
    end process;

end architecture;