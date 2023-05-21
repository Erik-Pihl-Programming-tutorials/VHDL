--------------------------------------------------------------------------------
-- d_latch_tb.vhd: Testbench for a D latch.
--
--                  Signals:
--                      - d     : D latch input bit.
--                      - enable: Latch lock signal (1 = open, 0 = locked).
--                      - q     : D latch output bit.
--                      - q_n   : Inverse of D latch output bit.
--
--                  Function:
--                      - enable = 1 (latch open)   => q = d, q_n = ~d
--                      - enable = 0 (latch locked) => q = q, q_n = q_n
--
--                  Each combination of the inputs are simulated during 10 ns
--                  each via ModelSim.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_latch_tb is
end entity;

architecture behaviour of d_latch_tb is
signal d, enable, q, q_n: std_logic := '0';
begin

    simulation: entity work.d_latch
    port map(d, enable, q, q_n);
    
    SIM_PROCESS: process is
    begin
        for i in 0 to 1 loop
            for j in 0 to 3 loop
                (enable, d) <= std_logic_vector(to_unsigned(j, 2));
                wait for 10 ns;
            end loop;
        end loop;
        wait;
    end process;

end architecture;