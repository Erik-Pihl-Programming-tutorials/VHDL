--------------------------------------------------------------------------------
-- adas_tb.vhd: Testbench for ADAS (Advanced Driver Assistance System) used
--              for vehicle break assistance.
--
--              Signals:
--                  - driver_break: Break pedal, controlled by driver.
--                  - camera      : Indicates object in front of the vehicle.
--                  - radar       : Indicates object approaching vehicle.
--                  - adas_ok     : Indicates that the ADAS system is working
--                                  correctly.
--                  - engine_break: Breaks the engine for reduction of speed.
--
--               Engine break is enabled if the driver presses the break pedal
--               or the camera senses and object in front of the car while
--               the radar senses that the object is approaching and the ADAS
--               system is working correctly. If the ADAS system isn't working
--               correctly, the camera and radar signals are ignored.
--
--               All combinations 0000 - 1111 of the input signals are tested
--               one by one during 10 ns each. Therefore the total simulation
--               time is 160 ns.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adas_tb is
end entity;

architecture behaviour of adas_tb is
signal driver_break, camera, radar, adas_ok, engine_break: std_logic := '0';
begin

    --------------------------------------------------------------------------------
    -- adas_sim: Creates an object of the module adas and connects it's ports
    --           to signals with corresponding names in this testbench for 
    --           simulation.
    --------------------------------------------------------------------------------
    adas_sim: entity work.adas
    port map(driver_break, camera, radar, adas_ok, engine_break);

    --------------------------------------------------------------------------------
    -- SIM_PROCESS: Tests all combination 0000 - 1111 of the input signals during
    --              10 ns each. After simulation is finished, the process is halted.
    --              Iteration is generated via a for loop. The value of iterator i
    --              in converted to 4-bit unsigned form, the to bits (std_logic)
    --              and assigned to the input variable.
    --------------------------------------------------------------------------------
    SIM_PROCESS: process is
    variable input: std_logic_vector(3 downto 0);
    begin
        for i in 0 to 15 loop
            input := std_logic_vector(to_unsigned(i, 4));
            driver_break <= input(3);
            camera       <= input(2);
            radar        <= input(1);
            adas_ok      <= input(0);
            wait for 10 ns;
        end loop;
        wait;
    end process;
    
end architecture;