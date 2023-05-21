# D-latchen, D-vippan samt flankdetektering i VHDL
Konstruktion samt uppbyggnad av D-latchen samt D-vippan, både med grindar i CircuitVerse samt syntes och simulering i VHDL.
Implementering av flankdetektering via D-vippor för en tryckknapp, där en lysdiod togglas via nedtryckning (fallande flank) av en tryckknapp.

Katalogen "d_latch" innehåller kretsschema samt VHDL-kod (syntesbar kod samt testbänk) för D-latchen.

Katalogen "d_flip_flop" innehåller kretsschema samt VHDL-kod (syntesbar kod samt testbänk) för D-vippan.

Katalogen "falling_edge_detection" innehåller kretsschema samt VHDL-kod (syntesbar kod samt testbänk) för ett digitalt system, där en tryckknapp 
detekteras på fallande flank (nedtryckning) via D-vippor. Vid nedtryckning (föregående insignal är hög, nuvarande insignal är låg) togglas en lysdiod.

Kortfattad beskrivning av latchar och vippor:
Latchar (låskretsar) och vippor är enkla minneskretsar som kan lagra en bit. För båda kretsar kan utsignalen låsas via en enable-signal.
Skillnaden dem emellan är att vippor är synkrona, vilket innebär att utsignalen enbart uppdateras vid en klockpuls ifall vippan är öppen, 
medan latchar är asynkrona, vilket innebär att utsignalen uppdateras direkt ifall latchen är öppen. Vippor kräver mer hårdvara och är långsammare,
men medför kraftigt förbättrad kontroll av timing (då uppdatering enbart sker vid klockpuls), vilket är särskilt viktigt i större digitala system.

Att vipporna är synkroniserade kan liknas vid att medlemmar i en storbandsorkester spelar i samma takt, där systemklockan utgör trumslagaren. 
Detta ökar strukturen på låtarna, där alla spelar samma del av en låt samtidigt. Dock krävs mer resurser på grund av en trumslagare.
Latchar kan liknas vid att medlemmarna spelar i olika takt, vilket minskar mängden resurser, men samtidigt kan strukturen på låtarna
bli lidande. Därmed föredras normalt vippor framför latchar.

Se video tutorial här:
https://youtu.be/utDHdTgZUz0