# Förebyggande av mestastabilitet i VHDL
Förebyggande av metastabilitet via 'double flop'-metoden, dvs. samtliga insignaler synkroniseras via två vippor.  

* Metastabilitet är ett tillstånd där utsignalen ur en vippa varken är 0 eller 1, vilket kan uppstå när en insignal ändrar värde för nära en klockpuls. Då hinner signalen inte stabilisera sig på 0 eller 1 och vippans utsignal kan då sväva någonstans mellan 0 - 1 en viss tid. 
* Oftast stabiliserar sig sedan vippans utsignal till 0 eller 1, annars kan systemfel uppstå, då vissa efterföljande grindar kan tolka vippans utsignal som 0, andra som 1, vilket kan få märkliga effekter.

## Beskrivning av konstruerad krets
En av kretsarna som konstruerades föregående tutorial, [`falling_edge_detection`](./../5.%20D-latchen,%20D-vippan%20samt%20flankdetektering%20i%20VHDL/falling_edge_detection/), har utökats med metastabilitetsskydd.
Implementeringen genomförs med D-vippor, både för hand i CircuitVerse samt i VHDL:

* Reset-signalen `reset_n` synkroniseras via två D-vippor. Motsvarande synkroniserad reset-signal `reset_s2_n` används sedan i resten av kretsen. Postfix `s2` innebär att signalen i fråga har synkroniserats med två vippor i enlighet med 'double flop'-metoden.
* Tryckknappen `button_n` synkroniseras via två D-vippor och ytterligare en vippa används för flankdetektering, där `button_s2_n` utgör "nuvarande" insignal och `button_s3_n` utgör "föregående" insignal. Vid nedtryckning (fallande flank) gäller att `button_s2_n` = 0 och `button_s3_n` = 1. Då ettställs signalen `button_pressed_s2` för att indikera knapptryckning. 
* Vid nedtryckning av tryckknappen `button_n` togglas en lysdiod (på fallande flank).

#### Material
* [`led_toggle_meta_prev`](./led_toggle_meta_prev/) innehåller kretsschema samt hårdvarubeskrivande kod (syntesbar kod samt testbänk) för konstruktionen. Filen [`led_toggle_meta_prev_rtl.cv`](./led_toggle_meta_prev/led_toggle_meta_prev_rtl.cv) kan öppnas i CircuitVerse för att testa kretsen.
* Se video tutorial [här](https://youtu.be/KrssJRgF13I).
