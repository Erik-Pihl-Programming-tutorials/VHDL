--------------------------------------------------------------------------------
-- xor_gate.vhd: Implementation of a 3-input XOR gate, where the inputs are
--               connected to slide switches and the output is connected to
--               a LED.
--
--               Inputs:
--                  - switch[2:0]: Inputs connected to slide switches.
--               Outputs:
--                  - led        : Output connected to a LED.
--
--               Hardware implemented for FPGA card Terasic DE0.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity xor_gate is
   port(switch: in std_logic_vector(2 downto 0);
        led   : out std_logic);
end entity;

architecture behaviour of xor_gate is
begin
   led <= switch(2) xor switch(1) xor switch(0);
end architecture;