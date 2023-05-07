--------------------------------------------------------------------------------
-- multi_hex_radix.vhd: Design containing multiple hex displays. A number is
--                      entered via eight slide-switches and is displayed via
--                      four hex displays, both in hexadecimal form 0x00 - 0xFF
--                      and decimal form 00 - 99.
--
--                      Inputs:
--                          - switch[7:0]: Slide-switches for entering numbers.
--                      Outputs:
--                          - hex3[6:0]  : Displays the most significant 
--                                         hexadecimal digit of entered number.
--                          - hex2[6:0]  : Displays the least significant 
--                                         hexadecimal digit of entered number.
--                          - hex1[6:0]  : Displays the most significant 
--                                         decimal digit of entered number.
--                          - hex0[6:0]  : Displays the least significant 
--                                         decimal digit of entered number.
--
--                      Hardware implemented for FPGA card Terasic DE0.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multi_hex_radix is
    port(switch                : in std_logic_vector(7 downto 0);
         hex3, hex2, hex1, hex0: out std_logic_vector(6 downto 0));
end entity;

architecture behaviour of multi_hex_radix is
begin

    --------------------------------------------------------------------------------
    -- dual_display_32: Displays entered number 0x00 - 0xFF via hex3 and hex2.
    --------------------------------------------------------------------------------
    dual_display_32: entity work.dual_display
    port map(switch, hex3, hex2);
    
    --------------------------------------------------------------------------------
    -- dual_display_10: Displays entered number 00 - 99 via hex1 and hex0.
    --------------------------------------------------------------------------------
    dual_display_10: entity work.dual_display
    generic map(RADIX => 10)
    port map(switch, hex1, hex0);
    
end architecture;