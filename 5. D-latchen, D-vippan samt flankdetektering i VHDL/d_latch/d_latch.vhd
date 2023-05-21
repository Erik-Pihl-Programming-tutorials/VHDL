--------------------------------------------------------------------------------
-- d_latch.vhd: Implementation of a D latch.
--
--              Inputs:
--                  - d     : D latch input bit.
--                  - enable: Latch lock signal (1 = open, 0 = locked).
--              Outputs:
--                  - q     : D latch output bit.
--                  - q_n   : Inverse of D latch output bit.
--
--              Function:
--                  - enable = 1 (latch open)   => q = d, q_n = ~d
--                  - enable = 0 (latch locked) => q = q, q_n = q_n
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity d_latch is
    port(d, enable: in std_logic;
         q, q_n   : out std_logic);
end entity;

architecture behaviour of d_latch is
signal q_s: std_logic := '0'; -- Start value for simulation only.
begin
    q_s <= d when enable = '1' else q_s;
    q   <= q_s;
    q_n <= not q_s;
end architecture;