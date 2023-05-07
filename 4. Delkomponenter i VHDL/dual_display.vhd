--------------------------------------------------------------------------------
-- dual_display.vhd: Module for displaying a 2-digit number with an arbitrary
--                   radix between 2 to 16.
--
--                   Generics:
--                       - RADIX     : Parameter for selecting radix of the
--                                     number to display (default = 16).
--                   Inputs:
--                       - input[7:0]: Input for selecting number to display.
--                   Output:
--                      - hex1[6:0]: Displaying the most significant digit.
--                      - hex0[6:0]: Displaying the least significant digit.
--
--                   Note: The max value at a specific radix is
--                                  max_val = radix ^ 2 - 1
--              
--                   So for a radix of 10, the max value is 10 ^ 2 - 1 = 99
--                   and for a radix of 16, the max value is 16 ^ 2 - 1 = 255.
--                   In VHDL, 10 ^ 2 is implemented as 10**2.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_display is
    generic(RADIX  : natural range 2 to 16 := 16);
    port(input     : in std_logic_vector(7 downto 0);
         hex1, hex0: out std_logic_vector(6 downto 0));
end entity;

architecture behaviour of dual_display is
constant MAX_VAL         : natural := RADIX**2 - 1;
signal input_uint, number: natural range 0 to MAX_VAL;
signal digit1, digit0    : natural range 0 to 15;
begin

    input_uint <= to_integer(unsigned(input));
    number <= MAX_VAL when input_uint > MAX_VAL else input_uint;  

    --------------------------------------------------------------------------------
    -- EXTRACT_DIGITS_PROCESS: Extracts the two digits out of specified number.
    --                         When the most significant digit MSD is found, the
    --                         least significant digit LSD is calulated as follows:
    --                         LSD = number - MSD * radix.
    --                         So for example, for the number 23 with a radix of 10,
    --                         MSD = 2 and LSD = 23 - 2 * 10 = 23 - 20 = 3.
    --------------------------------------------------------------------------------
    EXTRACT_DIGITS_PROCESS: process (number) is
    begin
        for i in 0 to RADIX - 1 loop
            if (number >= RADIX * i and number < RADIX * (i + 1)) then 
                digit1 <= i;
                digit0 <= number - digit1 * RADIX; 
            end if;
        end loop;
    end process;  
   
    --------------------------------------------------------------------------------
    -- digit1_instance: Displays the most significant digit on hex1.
    --------------------------------------------------------------------------------
    digit1_instance: entity work.display
    port map(digit1, hex1);
    
    --------------------------------------------------------------------------------
    -- digit0_instance: Displays the least significant digit on hex0.
    --------------------------------------------------------------------------------
    digit0_instance: entity work.display
    port map(digit0, hex0);

end architecture;