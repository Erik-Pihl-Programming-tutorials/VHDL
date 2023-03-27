--------------------------------------------------------------------------------
-- xor_gate_tb.vhd: Testbench for a 3-input XOR gate, where the inputs are
--                  connected to slide switches and the output is connected to
--                  a LED.
--
--                  Signals:
--                     - switch[2:0]: Inputs connected to slide switches.
--                     - led        : Output connected to a LED.
--
--                  All combinations 000 - 111 of inputs switch[2:0] are
--                  simulated during 10 ns each. Therefore the total simulation
--                  time is 80 ns.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xor_gate_tb is
end entity;

architecture behaviour of xor_gate_tb is
signal switch: std_logic_vector(2 downto 0) := (others => '0');
signal led   : std_logic                    := '0';
begin

   xor_gate_sim: entity work.xor_gate
   port map(switch, led);
   
   --------------------------------------------------------------------------------
   -- SIMULATION_PROCESS: Tests all combinations 000 - 111 of input signals 
   --                     switch[2:0] one by one during 10 ns each. The process
   --                     is halted once the simulation is finished (after 80 ns).
   --------------------------------------------------------------------------------
   SIMULATION_PROCESS: process is
   begin
      for i in 0 to 7 loop
         switch <= std_logic_vector(to_unsigned(i, 3));
         wait for 10 ns;
      end loop;
      wait;
   end process;

end architecture;