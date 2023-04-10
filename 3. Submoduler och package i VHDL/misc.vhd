--------------------------------------------------------------------------------
-- misc.vhd: Contains miscellaneous submodule declarations and definitions,
--           constants etc. via package misc.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package misc is

--------------------------------------------------------------------------------
-- Binary codes for hexadecimal digits 0x0 - 0xF:
--------------------------------------------------------------------------------
constant DISPLAY_0  : std_logic_vector(6 downto 0) := "1000000";
constant DISPLAY_1  : std_logic_vector(6 downto 0) := "1111001";
constant DISPLAY_2  : std_logic_vector(6 downto 0) := "0100100";
constant DISPLAY_3  : std_logic_vector(6 downto 0) := "0110000";
constant DISPLAY_4  : std_logic_vector(6 downto 0) := "0011001";
constant DISPLAY_5  : std_logic_vector(6 downto 0) := "0010010";
constant DISPLAY_6  : std_logic_vector(6 downto 0) := "0000010";
constant DISPLAY_7  : std_logic_vector(6 downto 0) := "1111000";
constant DISPLAY_8  : std_logic_vector(6 downto 0) := "0000000";
constant DISPLAY_9  : std_logic_vector(6 downto 0) := "0010000";
constant DISPLAY_A  : std_logic_vector(6 downto 0) := "0001000";
constant DISPLAY_B  : std_logic_vector(6 downto 0) := "0000011";
constant DISPLAY_C  : std_logic_vector(6 downto 0) := "1000110";
constant DISPLAY_D  : std_logic_vector(6 downto 0) := "0100001";
constant DISPLAY_E  : std_logic_vector(6 downto 0) := "0000110";
constant DISPLAY_F  : std_logic_vector(6 downto 0) := "0001110";
constant DISPLAY_OFF: std_logic_vector(6 downto 0) := "1111111";

--------------------------------------------------------------------------------
-- to_natural: Converts content of specified vector to a natural number.
--
--             - vector: Vector whose content is to be converted.
--
--             - return: Corrsponding natural number.
--------------------------------------------------------------------------------
function to_natural(constant vector: std_logic_vector)
return natural;

--------------------------------------------------------------------------------
-- to_std_logic_vector: Converts specified natural number to a vector of
--                      specified size. 
--
--                      - number     : Natural number to convert.
--                      - vector_size: The size of the returned vector in bits 
--                                     (default = 32).
--
--                      - return: Vector containing the converted number.
--------------------------------------------------------------------------------
function to_std_logic_vector(constant number     : natural;
                             constant vector_size: natural := 32)
return std_logic_vector;

--------------------------------------------------------------------------------
-- add: Returns the sum of specified numbers with specified number of bits.
--
--      - x       : The first number in bits.
--      - y       : The second number in bits.
--      - num_bits: The number of bits in the returned vector (default = 32).
--      
--      - return: The sum of number x and y in bits (std_logic_vector).
--------------------------------------------------------------------------------
function add(constant x, y    : std_logic_vector;
             constant num_bits: natural := 32)
return std_logic_vector;

--------------------------------------------------------------------------------
-- subtract: Returns the difference between specified numbers with specified 
--           number of bits.
--
--           - x       : The first number in bits.
--           - y       : The second number in bits.
--           - num_bits: The number of bits in the returned vector 
--                       (default = 32).
--      
--           - return: The difference between number x and y in bits.
--------------------------------------------------------------------------------
function subtract(constant x, y: std_logic_vector;
                  constant num_bits: natural := 32)
return std_logic_vector;

--------------------------------------------------------------------------------
-- display_get_binary_code: Returns the binary code of specified hexadecimal
--                          digit 0x0 - 0xF. 
--
--                          - digit: Specified 4-bit digit 0x0 - 0xF.
--
--                          - return: The corresponding 7-bit binary code.
--------------------------------------------------------------------------------
function display_get_binary_code(constant digit: std_logic_vector(3 downto 0))
return std_logic_vector;

--------------------------------------------------------------------------------
-- display_get_binary_code: Returns the binary code of specified hexadecimal
--                          digit 0x0 - 0xF. 
--
--                          - digit: Specified digit 0 - 15.
--
--                          - return: The corresponding 7-bit binary code.
--------------------------------------------------------------------------------
function display_get_binary_code(constant digit: natural range 0 to 15)
return std_logic_vector;

--------------------------------------------------------------------------------
-- display_get_binary_code: Writes the binary code of specified hexadecimal
--                          digit 0x0 - 0xF to referenced display.
--
--                          - digit  : Specified 4-bit digit 0x0 - 0xF.
--                          - display: Referenced display.
--------------------------------------------------------------------------------
procedure display_get_binary_code(constant digit: in std_logic_vector(3 downto 0);
                                  signal display: out std_logic_vector(6 downto 0));
                                  
--------------------------------------------------------------------------------
-- display_get_binary_code: Writes the binary code of specified hexadecimal
--                          digit 0x0 - 0xF to referenced display.
--
--                          - digit  : Specified digit 0 - 15.
--                          - display: Referenced display.
--------------------------------------------------------------------------------
procedure display_get_binary_code(constant digit: in natural range 0 to 15;
                                  signal display: out std_logic_vector(6 downto 0));

end package;

package body misc is

--------------------------------------------------------------------------------
-- to_natural: Converts content of specified vector to a natural number.
--
--             - vector: Vector whose content is to be converted.
--
--             - return: Corrsponding natural number.
--------------------------------------------------------------------------------
function to_natural(constant vector: std_logic_vector)
return natural is
begin
    return to_integer(unsigned(vector));
end function;

--------------------------------------------------------------------------------
-- to_std_logic_vector: Converts specified natural number to a vector of
--                      specified size. The corresponding vector is returned.
--
--                      - number     : Natural number to convert.
--                      - vector_size: The size of the returned vector in bits 
--                                     (default = 32).
--
--                      - return: Vector containing the converted number.
--------------------------------------------------------------------------------
function to_std_logic_vector(constant number     : natural;
                             constant vector_size: natural := 32) 
return std_logic_vector is
begin
    return std_logic_vector(to_unsigned(number, vector_size));
end function;

--------------------------------------------------------------------------------
-- add: Returns the sum of specified numbers with specified number of bits.
--
--      - x       : The first number in bits.
--      - y       : The second number in bits.
--      - num_bits: The number of bits in the returned vector (default = 32).
--      
--      - return: The sum of number x and y in bits (std_logic_vector).
--------------------------------------------------------------------------------
function add(constant x, y    : std_logic_vector;
             constant num_bits: natural := 32)
return std_logic_vector is
constant sum: natural := to_natural(x) + to_natural(y);
begin
    return to_std_logic_vector(sum, num_bits);
end function;

--------------------------------------------------------------------------------
-- subtract: Returns the difference between specified numbers with specified 
--           number of bits.
--
--           - x       : The first number in bits.
--           - y       : The second number in bits.
--           - num_bits: The number of bits in the returned vector 
--                       (default = 32).
--      
--           - return: The difference between number x and y in bits.
--------------------------------------------------------------------------------
function subtract(constant x, y: std_logic_vector;
                  constant num_bits: natural := 32)
return std_logic_vector is
constant difference: natural := to_natural(x) + 2 ** num_bits - to_natural(y);
begin
    return to_std_logic_vector(difference, num_bits);
end function;

--------------------------------------------------------------------------------
-- display_get_binary_code: Returns the binary code of specified hexadecimal
--                          digit 0x0 - 0xF. 
--
--                          - digit: Specified 4-bit digit 0x0 - 0xF.
--
--                          - return: The corresponding 7-bit binary code.
--------------------------------------------------------------------------------
function display_get_binary_code(constant digit: std_logic_vector(3 downto 0))
return std_logic_vector is
begin
    case (digit) is
        when "0000" => return DISPLAY_0;
        when "0001" => return DISPLAY_1;
        when "0010" => return DISPLAY_2;
        when "0011" => return DISPLAY_3;
        when "0100" => return DISPLAY_4;
        when "0101" => return DISPLAY_5;
        when "0110" => return DISPLAY_6;
        when "0111" => return DISPLAY_7;
        when "1000" => return DISPLAY_8;
        when "1001" => return DISPLAY_9;
        when "1010" => return DISPLAY_A;
        when "1011" => return DISPLAY_B;
        when "1100" => return DISPLAY_C;
        when "1101" => return DISPLAY_D;
        when "1110" => return DISPLAY_E;
        when "1111" => return DISPLAY_F;
        when others => return DISPLAY_OFF;
    end case;
end function;

--------------------------------------------------------------------------------
-- display_get_binary_code: Returns the binary code of specified hexadecimal
--                          digit 0x0 - 0xF. 
--
--                          - digit: Specified digit 0 - 15.
--
--                          - return: The corresponding 7-bit binary code.
--------------------------------------------------------------------------------
function display_get_binary_code(constant digit: natural range 0 to 15)
return std_logic_vector is
begin
    return display_get_binary_code(to_std_logic_vector(digit, 4));
end function;

--------------------------------------------------------------------------------
-- display_get_binary_code: Writes the binary code of specified hexadecimal
--                          digit 0x0 - 0xF to referenced display.
--
--                          - digit  : Specified 4-bit digit 0x0 - 0xF.
--                          - display: Referenced display.
--------------------------------------------------------------------------------
procedure display_get_binary_code(constant digit: in std_logic_vector(3 downto 0);
                                  signal display: out std_logic_vector(6 downto 0)) is
begin
    display <= display_get_binary_code(digit);
    return;
end procedure;

--------------------------------------------------------------------------------
-- display_get_binary_code: Writes the binary code of specified hexadecimal
--                          digit 0x0 - 0xF to referenced display.
--
--                          - digit  : Specified digit 0 - 15.
--                          - display: Referenced display.
--------------------------------------------------------------------------------
procedure display_get_binary_code(constant digit: in natural range 0 to 15;
                                  signal display: out std_logic_vector(6 downto 0)) is
begin
    display <= display_get_binary_code(digit);
    return;
end procedure;

end package body;