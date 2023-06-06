--------------------------------------------------------------------------------
-- @brief Module for synchronization of the input signals via the double flop
--        technique to prevent metastability. The reset signal is synchronized,
--        while 1 - 3 push buttons are synchronized and event detection is
--        performed to detect pressdown. 
--
-- @param NUM_BUTTONS
--        The number of push buttons (default = 1).
-- @param clock
--        50 MHz system clock.
-- @param reset_n
--        Inverting asynchronous reset signal.
-- @param button_n
--        Inverting push buttons.
-- @param reset_s2_n
--        Synchronized reset signal used in the rest of the design.
-- @param button_pressed_s2
--        Synchronized event flags indicating pressdown of each button.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity meta_prev is
    generic(NUM_BUTTONS   : natural range 1 to 3 := 1);
    port(clock, reset_n   : in std_logic;
         button_n         : in std_logic_vector(NUM_BUTTONS - 1 downto 0);
         reset_s2_n       : out std_logic;
         button_pressed_s2: out std_logic_vector(NUM_BUTTONS - 1 downto 0));
end entity;

architecture behaviour of meta_prev is

--------------------------------------------------------------------------------
-- @brief Signals used for creating flip flops.
--------------------------------------------------------------------------------
signal reset_s1_n_s, reset_s2_n_s           : std_logic;
signal button_s1_n, button_s2_n, button_s3_n: std_logic_vector(NUM_BUTTONS - 1 downto 0);
begin

    --------------------------------------------------------------------------------
    -- @brief Synchronizes the reset signals. If a system reset occurs, all reset
    --        signals are immediately cleared. Else at rising of the system clock,
    --        the output of each reset flip flop is updated.
    --------------------------------------------------------------------------------
    RESET_PROCESS: process(clock, reset_n) is
    begin
        if (reset_n = '0') then
            reset_s1_n_s <= '0';
            reset_s2_n_s <= '0';
        elsif (rising_edge(clock)) then
            reset_s1_n_s <= '1';
            reset_s2_n_s <= reset_s1_n_s;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Synchronizes the button signals. If a system reset occurs, all button
    --        signals are immediately set. Else at rising of the system clock,
    --        the output of each button flip flop is updated.
    --------------------------------------------------------------------------------
    BUTTON_PROCESS: process(clock, reset_s2_n_s) is
    begin
        if (reset_s2_n_s = '0') then
            button_s1_n <= (others => '1');
            button_s2_n <= (others => '1');
            button_s3_n <= (others => '1');
        elsif (rising_edge(clock)) then
            button_s1_n <= button_n;
            button_s2_n <= button_s1_n;
            button_s3_n <= button_s2_n;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Perform event detection on the push buttons. For a specific button i,
    --        if the "current" value button_s2_n(i) is low, while the "previous"
    --        value button_s3_n(i) is high, the button is pressed and then the
    --        button_pressed_s2(i) signal is set, else it's cleared.
    --------------------------------------------------------------------------------
    BUTTON_PRESSED_PROCESS: process(button_s2_n, button_s3_n) is
    begin
        for i in 0 to NUM_BUTTONS - 1 loop
            if (button_s2_n(i) = '0' and button_s3_n(i) = '1') then
                button_pressed_s2(i) <= '1';
            else
                button_pressed_s2(i) <= '0';
            end if;
        end loop;
    end process;
    
    reset_s2_n <= reset_s2_n_s;
    
end architecture;