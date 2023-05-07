--------------------------------------------------------------------------------
-- display.vhd: Module for displaying a digit 0 - F on a single hex display.
--
--              Inputs:
--                  - digit   : The digit 0x0 - 0xF (0 - 15) to display.
--              Output:
--                  - hex[6:0]: The display to assign the digit 0 - F.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display is
    port(digit: in natural range 0 to 15;
         hex  : out std_logic_vector(6 downto 0));
end entity;

architecture behaviour of display is

--------------------------------------------------------------------------------
-- Binary codes for displaying digits 0x0 - 0xF on hex-displays.
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
begin

    --------------------------------------------------------------------------------
    -- OUTPUT_PROCESS: Assigning a new binary code every time the digit changes.
    --------------------------------------------------------------------------------
    OUTPUT_PROCESS: process (digit) is
    begin
        case (digit) is
            when 0      => hex <= DISPLAY_0;
            when 1      => hex <= DISPLAY_1;
            when 2      => hex <= DISPLAY_2;
            when 3      => hex <= DISPLAY_3;
            when 4      => hex <= DISPLAY_4;
            when 5      => hex <= DISPLAY_5;
            when 6      => hex <= DISPLAY_6;
            when 7      => hex <= DISPLAY_7;
            when 8      => hex <= DISPLAY_8;
            when 9      => hex <= DISPLAY_9;
            when 10     => hex <= DISPLAY_A;
            when 11     => hex <= DISPLAY_B;
            when 12     => hex <= DISPLAY_C;
            when 13     => hex <= DISPLAY_D;
            when 14     => hex <= DISPLAY_E;
            when 15     => hex <= DISPLAY_F;
            when others => hex <= DISPLAY_OFF;
        end case;
    end process;
    
end architecture;