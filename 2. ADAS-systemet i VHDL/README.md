# ADAS-systemet i VHDL.
Implementering av bromsassistans för fordon via ADAS (Advanced Driver Assistance System) i VHDL.

Ifall föraren bromsar eller om ADAS-systemets kamera indikerar att ett objekt är framför bilen
samtidigt som ADAS-systemets sensor indikerar att objektet närmar sig bromsar bilen.
Vid fel på ADAS-systemet ignoreras signalerna från kameran och sensorn.

Insignaler:
    - camera      : Indikerar ifall ett objekt är framför bilen.
    - radar       : Indikerar ifall objektet närmar sig bilen.
    - adas_ok     : Indikerar ifall ADAS-systemet fungerar som det ska, annars ignoreras kamera- och radarsignalerna.
    - driver_break: Bromspedal, kontrolleras av föraren.
Utsignal:
    - engine_break: Bromar bilen.

ADAS-systemets utsignal engine_break ska vara hög om:
    - Insignal driver_break är hög (föraren bromsar) eller
    - Insignaler camera, radar och adas_ok alla är höga (något är framför bilen och närmar sig samt ADAS-systemet fungerar som det ska)

ADAS-systemet kan därmed realiseras via följande ekvation:
    
                                                        engine_break = driver_break + camera * radar * adas_ok,

        där 
            - camera * radar * adas_ok utgör en AND-grind med camera, radar och adas_ok som insignaler.
            - driver_break + camera * radar * adas_ok utgör en OR-grind med driver_break och (camera * radar * adas_ok) som insignaler

Sanningstabellen för ADAS-systemet visas nedan (X = don't care, dvs. signalens värde spelar ingen roll):

driver_break camera radar adas_ok engine_break
      0         0     0      0         0
      0         0     0      1         0
      0         0     1      0         0
      0         0     1      1         0
      0         1     0      0         0
      0         1     0      1         0
      0         1     1      0         0
      0         1     1      1         1
      1         x     x      x         1


Filen "adas_net.png" demonstrerar grindnätet realiserat via CircuitVerse.

Filen "adas.vhd" utgör syntesbar kod för ADAS-systemet. Hårdvara implementerad för FPGA-kort Terasic DE0.

Filen "adas_tb.vhd" utgör testbänk för ADAS-systemet. Simulering genomförd i ModelSim.

Filen "adas.qar" utgör en arkivfil som kan öppnas för att direkt köra projektet med samtliga pinnar samt testbänken konfigurerad.

Se video tutorial här:
https://youtu.be/gtaaarLyeXQ