--------------------------------------------------------------------------------
-- @brief Contains miscellaneous constans used for the design via package misc.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package misc is

--------------------------------------------------------------------------------
-- @brief Constants used for frequency selection of the timer circuits, based 
--        on a 50 MHz system clock.
--------------------------------------------------------------------------------
constant FREQUENCY_100HZ: natural := 500000;
constant FREQUENCY_50HZ : natural := FREQUENCY_100HZ * 2;
constant FREQUENCY_20HZ : natural := FREQUENCY_100HZ * 5;
constant FREQUENCY_10HZ : natural := FREQUENCY_100HZ * 10;
constant FREQUENCY_5HZ  : natural := FREQUENCY_10HZ * 2;
constant FREQUENCY_2HZ  : natural := FREQUENCY_10HZ * 5;
constant FREQUENCY_1HZ  : natural := FREQUENCY_10HZ * 10;
end package;