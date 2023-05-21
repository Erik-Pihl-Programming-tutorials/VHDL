--------------------------------------------------------------------------------
-- d_flip_flop_tb.vhd: Testbench for a D flip flop.
--
--                     Signals:
--                         - clock  : 50 MHz system clock.
--                         - reset_n: Invertering asynchronous reset signal.
--                         - d      : D latch input bit.
--                         - enable : Latch lock signal (1 = open, 0 = locked).
--                         - q      : D latch output bit.
--                         - q_n    : Inverse of D latch output bit.
--
--                     Function:
--                         - reset_n = 0 (system reset) => q = 0, q_n = 1
--                         - reset_n = 1 && enable = 1 (flip flop open) '
--                             => q = d, q_n = ~d at rising edge of clock.
--                         - reset_n = 1 && enable = 0 (flip flop locked) 
--                             => q = q, q_n = q_n
--
--                     A clock period of 1 ns is used for simulation.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_flip_flop_tb is
end entity;

architecture behaviour of d_flip_flop_tb is
constant CLOCK_PERIOD     : time := 1 ns;
signal clock, d, enable, q: std_logic := '0';
signal reset_n, q_n       : std_logic := '1';
signal simulation_finished: boolean := false;
begin

    --------------------------------------------------------------------------------
    -- simulation: Creates an instance of the top module and connects the ports
    --             to signals of the same name in this testbench for simulation.
    --------------------------------------------------------------------------------
    simulation: entity work.d_flip_flop
    port map(clock, reset_n, d, enable, q, q_n);

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
    -- SIM_PROCESS: Tests differens combinations of input D and the enable signal, 
    --              both during normal execution and system reset.
    --------------------------------------------------------------------------------
    SIM_PROCESS: process is
    begin
        for i in 0 to 1 loop
            for j in 0 to 1 loop
                for k in 0 to 3 loop
                    (enable, d) <= std_logic_vector(to_unsigned(k, 2));
                    wait for CLOCK_PERIOD * 5;
                end loop;
            end loop;
            reset_n <= not reset_n;
        end loop;
        simulation_finished <= true;
        wait;
    end process;

end architecture;