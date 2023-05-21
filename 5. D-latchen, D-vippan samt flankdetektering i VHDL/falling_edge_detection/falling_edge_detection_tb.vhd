--------------------------------------------------------------------------------
-- falling_edge_detection_tb.vhd: Toggling a LED at pressdown (falling edge) 
--                                of an inverting push button.
--
--                                Signals:
--                                 - clock   : 50 MHz system clock.
--                                 - reset_n : Invertering asynchronous reset.
--                                 - button_n: Inverting button for toggling
--                                             the LED.
--                                 - led     : LED toggled at pressdown of
--                                             the button.
--
--                                Function:
--                                    - reset_n = 0 (system reset) => led = 0
--                                    - reset_n = 1 (normal execution) && 
--                                      button_pressed = 1 => led = !led.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity falling_edge_detection_tb is
end entity;

architecture behaviour of falling_edge_detection_tb is
constant CLOCK_PERIOD     : time := 1 ns;
signal clock, led         : std_logic := '0';
signal reset_n, button_n  : std_logic := '1';
signal simulation_finished: boolean := false;
begin

    --------------------------------------------------------------------------------
    -- simulation: Creates an instance of the top module and connects the ports
    --             to signals of the same name in this testbench for simulation.
    --------------------------------------------------------------------------------
    simulation: entity work.falling_edge_detection
    port map(clock, reset_n, button_n, led);
    
    --------------------------------------------------------------------------------
    -- CLOCK_PROCESS: Toggling the system clock every half clock period until the
    --                simulation is finished.
    --------------------------------------------------------------------------------
    CLOCK_PROCESS: process is
    begin
        if (simulation_finished = false) then
            clock <= not clock;
            wait for CLOCK_PERIOD / 2;
        else
            wait;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- RESET_PROCESS: Runs normal execution during 30 clock cycles, followed by
    --                system reset during 30 clock cycles.
    --------------------------------------------------------------------------------
    RESET_PROCESS: process is
    begin
        wait for CLOCK_PERIOD * 30;
        reset_n <= '0';
        wait for CLOCK_PERIOD * 30;
        wait;
    end process;
    
    --------------------------------------------------------------------------------
    -- BUTTON_PROCESS: Simulates pressing the button up and down 15 times every
    --                 fifth clock cycle.
    --------------------------------------------------------------------------------
    BUTTON_PROCESS: process is
    begin
        for i in 0 to 14 loop
            wait for CLOCK_PERIOD * 5;
            button_n <= not button_n;
        end loop;
        simulation_finished <= true;
        wait;
    end process;

end architecture;