--------------------------------------------------------------------------------
-- d_flip_flop.vhd: Implementation of a D flip flop.
--
--                  Inputs:
--                      - clock  : 50 MHz system clock.
--                      - reset_n: Invertering asynchronous reset signal.
--                      - d      : D latch input bit.
--                      - enable : Latch lock signal (1 = open, 0 = locked).
--                  Outputs:
--                      - q      : D latch output bit.
--                      - q_n    : Inverse of D latch output bit.
--
--                  Function:
--                      - reset_n = 0 (system reset) => q = 0, q_n = 1
--                      - reset_n = 1 and enable = 1 (flip flop open) '
--                          => q = d, q_n = ~d at rising edge of clock.
--                      - reset_n = 1 and enable = 0 (flip flop locked) 
--                          => q = q, q_n = q_n
--
--                  Note: For synchronous processes, the sensitivity list should 
--                        only contain the system clock and a reset signal.
--                        The code shall be written so that execution only
--                        occurs at reset or rising edge of the system clock i.e.
--
--                        process(<clock>, <reset>) is
--                        begin
--                            if (reset) then
--                                - Code for reset, i.e. set starting values.
--                            elsif (rising_edge(clock)) then
--                                - Code for normal execution.
--                            end if;
--                        end process;
--
--                        - Don't add anything here, then we accidently add
--                          additional hardware that's not a flip flop, such
--                          as latches.
--      
--                  Hardware implemented for FPGA card Terasic DE0.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity d_flip_flop is
    port(clock, reset_n, d, enable: in std_logic;
         q, q_n                   : out std_logic);
end entity;

architecture behaviour of d_flip_flop is
signal q_s: std_logic := '0'; 
begin
    
    --------------------------------------------------------------------------------
    -- FLIP_FLOP_PROCESS: Process for assigning the output signal of the D flip
    --                    flop via internal signal q_s, which occurs at system
    --                    reset or rising edge of the system clock.
    --------------------------------------------------------------------------------
    FLIP_FLOP_PROCESS: process(clock, reset_n) is
    begin
        if (reset_n = '0') then
            q_s <= '0';
        elsif (rising_edge(clock)) then
            if (enable = '1') then
                q_s <= d;
            end if;
        end if;
    end process;
    
    q   <= q_s;
    q_n <= not q_s;
end architecture;