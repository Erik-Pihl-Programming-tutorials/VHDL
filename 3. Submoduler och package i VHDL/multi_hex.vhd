--------------------------------------------------------------------------------
-- multi_hex.vhd: Implementation of a system where two hexadecimal numbers
--                0x0 - 0xF are entered via eight slide switches (four each).
--                The two digits are displays via two hex displays along with
--                sum and difference of the digits.
--
--                Inputs:
--                    - switch[7:0]: Slide switches for entering the two digits.
--                Outputs:
--                    - display3: Displays the difference between the digits.
--                    - display2: Displays the sum of the digits.
--                    - display1: Displays digit1 entered via switch[7:4].
--                    - display0: Displays digit0 entered via switch[3:0].
--
--                Hardware configured for FPGA-card Terasic DE0.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.misc.all;

entity multi_hex is
    port(switch                                : in std_logic_vector(7 downto 0);
         display3, display2, display1, display0: out std_logic_vector(6 downto 0));
end entity;

architecture behaviour of multi_hex is
signal digit1, digit0, sum, difference: std_logic_vector(3 downto 0);
begin
    digit1     <= switch(7 downto 4);
    digit0     <= switch(3 downto 0);
    sum        <= add(digit1, digit0, 4);
    difference <= subtract(digit1, digit0, 4);
    
    display3 <= display_get_binary_code(difference);
    display2 <= display_get_binary_code(sum);
    display1 <= display_get_binary_code(digit1);
    display0 <= display_get_binary_code(digit0);
     
end architecture;