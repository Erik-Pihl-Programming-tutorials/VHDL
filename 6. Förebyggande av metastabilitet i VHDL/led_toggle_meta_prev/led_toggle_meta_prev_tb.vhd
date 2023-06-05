--------------------------------------------------------------------------------
-- @brief Testbench for a design where a LED is toggled at pressdown of a push
--        button. Metastability prevention is implemented via the double flop
--        technique, i.e. every input signal is synchronized via two flip flops.
--
-- @param CLOCK_PERIOD
--        The clock period used for the simulation (10 ns).
-- @param clock
--        50 MHz system clock.
-- @param reset_n
--        Inverting reset signal connected to a push button.
-- @param button_n
--        Inverting push button for toggling the LED.
-- @param led
--        LED toggled at pressdown of the push button.
-- @param sim_finished
--        Boolean variable indicating if the simulation is finished.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_toggle_meta_prev_tb is
end entity;

architecture behaviour of led_toggle_meta_prev_tb is
constant CLOCK_PERIOD   : time := 10 ns;
signal clock, led       : std_logic := '0';
signal reset_n, button_n: std_logic := '1';
signal sim_finished     : boolean := false;
begin

    --------------------------------------------------------------------------------
    -- @brief Creates an instance of the top module for simulation. The ports are
    --        connected to signals with the same name for testing.
    --------------------------------------------------------------------------------
    simulation: entity work.led_toggle_meta_prev
    port map(clock, reset_n, button_n, led);
    
    --------------------------------------------------------------------------------
    -- @brief Toggles the clock every half clock period until the simulation is
    --        finished (then the process is halted via the wait command).
    --------------------------------------------------------------------------------
    CLOCK_PROCESS: process is
    begin
        if (sim_finished = false) then
            clock <= not clock;
            wait for CLOCK_PERIOD / 2;
        else
            wait;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Test pressdown of the button five times every tenth clock period
    --        (toggle every five clock periods), both during normal execution
    --        and during system reset. After that, the process is halted via the
    --        wait command.
    --------------------------------------------------------------------------------
    SIM_PROCESS: process is
    begin
        for i in 0 to 1 loop
            for j in 0 to 9 loop
                wait for 5 * CLOCK_PERIOD;
                button_n <= not button_n;
            end loop;
        reset_n <= not reset_n;
        end loop;
        sim_finished <= true;
        wait;
    end process;

end architecture;