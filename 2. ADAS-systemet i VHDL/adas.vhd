--------------------------------------------------------------------------------
-- adas.vhd: Implementation of ADAS (Advanced Driver Assistance System) for
--           vehicle break assistance.
--
--           Inputs:
--               - driver_break: Break pedal, controlled by driver.
--               - camera      : Indicates object in front of the vehicle.
--               - radar       : Indicates object approaching vehicle.
--               - adas_ok     : Indicates that the ADAS system is working
--                               correctly.
--           Outputs:
--               - engine_break: Breaks the engine for reduction of speed.
--
--            Engine break is enabled if the driver presses the break pedal
--            or the camera senses and object in front of the car while
--            the radar senses that the object is approaching and the ADAS
--            system is working correctly. If the ADAS system isn't working
--            correctly, the camera and radar signals are ignored.
--
--            Hardware implemented for FPGA-card Terasic DE0.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity adas is
    port(driver_break, camera, radar, adas_ok: in std_logic;
         engine_break                        : out std_logic);
end entity;

architecture behaviour of adas is
signal adas_break: std_logic;
begin
    adas_break   <= camera and radar and adas_ok;
    engine_break <= driver_break or adas_break;
end architecture;