# Submoduler och package i VHDL
Demonstration av hur motsvarigheter till funktioner och headerfiler i C implementeras i VHDL för mer återanvändbar kod.

I VHDL finns två typer av submoduler, vilket är funktioner och procedurer. Dessa motsvarar i praktiken olika typer av funktioner i C.
I VHDL används package i stället för headerfiler. En fördel med package är att man enkelt kan välja vilka delar av ett package 
man vill inkludera, medan man i C enbart kan begränsa detta via makron, annars inkluderas allt.

Funktioner fungerar på samma sätt i C, med skillnaden att syntaxen är annorlunda samt att funktioner måste returnera ett värde.
En funktionsdeklaration har följande syntax:

function namn(variable/constant/signal arg1: datatyp;\
              variable/constant/signal arg2: datatyp)\
return returtyp;

Ingående argument kan väljas mellan att sättas till variabler, konstanter och signaler. 
Som default utgör samtliga argument variabler, men för att göra dem enbart läsbara kan nyckelordet constant användas,
vilket rekommenderas ifall värdet för ett givet ingående argument inte ska ändras, precis som i C.

Som exempel, en funktion döpt add som returnerar summan av två 8-bitars osignerade tal x och y kan deklareras enligt nedan:

function add(constant x, y: natural range 0 to 255)\
return natural;

Eftersom x och y har samma datatyp kan de deklareras direkt med ett kommatecken dem emellan.

Motsvarande funktionsdefinition visas nedan:

function add(constant x, y: natural range 0 to 255)\
return natural is\
begin\
    return x + y;\
end function;

I den deklarativa delen av funktionen (innan nyckelordet begin) kan eventuella lokala variabler och konstanter deklareras vid behov.

Motsvarande C-kod visas nedan:

uint16_t add(const uint8_t x,\
             const uint8_t y)\
{\
    return x + y;\
}

En procedur fungerar likt en modul i VHDL genom att denna kan inneha insignaler (in), utsignaler (out) samt kombinerade in- och utsignaler (inout).
Procedurer returnerar inget värde och kan därmed användas som voidfunktioner i C. Ska ett värde lagras på en adress i C krävs en pekare, medan i
VHDL kan motsvarande funktionalitet implementeras via en utsignal.

En procedurdeklaration har följande syntax:

procedure namn(variable/constant/signal arg1: in/out/inout datatyp;\
               variable/constant/signal arg2: in/out/inout datatyp);

Som exempel, en procedur döpt add som lagrar summan av två 8-bitars osignerade tal x och y via utsignalen sum kan deklareras enligt nedan:

procedure add(constant x, y: in natural range 0 to 255;\
              signal sum   : out natural);\

Motsvarande procedurdefinition visas nedan:

procedure add(constant x, y: in natural range 0 to 255;\
              signal sum   : out natural) is\
begin\
    sum <= x + y;\
    return;\      
end procedure;

I den deklarativa delen av proceduren (innan nyckelordet begin) kan eventuella lokala variabler och konstanter deklareras vid behov.
Nyckelordet return är valbart att skriva i en procedur.

Motsvarande C-kod visas nedan:

void add(const uint8_t x,\
         const uint8_t y,\
         uint16_t* sum)\
{\
    *sum = x + y;\
    return;\
}

Precis som C++ har VHDL stöd för function overloading. Därmed kan funktioner/procedurer ha samma namn så länge argumentlistan är olika. 
Kompilatorn kan då tolka utefter vad som passeras vilken funktion/procedur som ska anropas. 

Därmed kan både funktionen add och proceduren add implementeras i samma projekt. Funktionen add anropas enligt nedan, där returvärdet 
tilldelas till signalen sum:

    sum <= add(3, 5); -- sum tilldelas returvärdet 3 + 5 = 8.

För att anropa proceduren add måste signalen sum passeras som tredje ingående argument, såsom visas nedan:

    add(3, 5, sum); -- sum tilldelas 3 + 5 = 8 i proceduren.

Precis som C++ kan funktioner/procedurer ha defaultargument. Ingående argument kan då tilldelas ett default-värde, så passeras inte något värde
används detta. Som exempel, funktionen add kan göras om så att om inget andra argument y passeras sker inkrementering med värdet 1. 
Funktionen add definieras då enligt nedan:

function add(constant x: natural range 0 to 255;\
             constant y: natural range 0 to 255 := 1)\
return natural is\
begin\
    return x + y;\
end function;

Om funktionen add anropas med första ingående argument 3 utan att passera ett andra argument så kommer därmed 3 + 1 returneras:

    sum <= add(3); -- sum tilldelas returvärdet 3 + 1 = 4.

Defaultargument måste deklareras sist. Alla argument som är obligatoriska att skicka ska alltså deklareras först. Därmed hade det inte fungerat
att sätta y till defaultvärdet 1 i proceduren add, då ytterligare ett argument sum deklareras därefter. Alternativt hade sum placerats före, men
i enlighet med normal kutym för VHDL ska insignaler i en procedur deklareras först, utsignaler sist. Ska defaultargument användas är därmed
funktioner normalt lämpligare, då funktioner enbart har ingående argument.

Både funktioner och procedurer kan definieras direkt i den deklarativa delen av en arkitektur (innan nyckelordet begin) ifall denna ifråga enbart
ska användas lokalt. Detta motsvarar statiska funktioner i C och i detta fall behöver funktionen/proceduren inte deklareras. Vanligtvis implementeras
dock funktioner och procedurer i package så att de kan användas i multipla moduler, vilket motsvarar externa funktioner i C.

Package motsvarar headerfiler i C och implementeras normalt i separata .vhd-filer. 
I ett package deklareras konstanter, submoduler (funktioner och procedurer), komponenter, typer såsom enumerationer och record-typer (struktar) med mera.
I motsvarande package body (i samma .vhd-fil) definieras sedan motsvarande submoduler.

Längst upp i package-filen inkluderas nödvändiga package från VHDL:s standardbibliotek, exempelvis std_logic_1164 samt numeric_std 
från biblioteket ieee för att kunna implementera datatyper std_logic samt natural:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

I den deklarativa delen deklareras konstanter, typer, submoduler med mera. Som exempel visas ett package döpt misc nedan innehållande 
ovanstående submoduler döpa add varav funktionen add returnerar summan av två 8-bitars osignerade tal x och y, medan motsvarande 
procedur lagrar summan av insignaler x och y via utsignal sum. 

I den deklarativa delen av package deklareras submodulerna enligt nedan:

package misc is

function add(constant x, y: natural range 0 to 255)\
return natural;

procedure add(constant x, y: in natural range 0 to 255;\
              signal sum   : out natural);

end package;

I motsvarande package body definieras sedan submodulerna:

package body misc is

function add(constant x, y: natural range 0 to 255)\
return natural is\
begin\
    return x + y;\
end function;

procedure add(constant x, y: in natural range 0 to 255;\
              signal sum   : out natural) is\
begin\
    sum <= x + y;\
    return;\
end procedure;

end package body;

Ett paket inkluderas genom att biblioteket det tillhör inkluderas via nyckelordet library. Som exempel, vi har tidigare inkluderat biblioteket ieee
för att använda package std_logic_1164 samt numeric_std enligt nedan:

library ieee;

Därefter har de package som ska användas i biblioteket inkluderats via nyckelordet use. För att inkludera allt i givet package avslutas use-direktivet
med .all, annars måste allt som används föregås med namnet på package som prefix, vilket inte rekommenderas. Exempelvis kan allt innehåll i package
std_logic_1164 samt numeric_std inkluderas via nedanstående use-direktiv:

use ieee.std_logic_1164.all;\
use ieee.numeric_std.all;

Datatyper natural och std_logic kan då deklareras direkt:

signal x  : std_logic;\
signal num: natural;

Utan ändelsen all hade namnet på respektive package behövt användas som prefix, vilket visas nedan:

signal x  : std_logic_1164.std_logic;\
signal sum: numeric_std.natural;

Alla .vhd-filer i aktuellt projekt lagras i det lokala biblioteket work, som inkluderas som default. 
Därmed är det inte nödvändigt att inkludera biblioteket work via direktivet library, men det kan göras om man vill:

library work; -- Inte nödvändigt, då biblioteket work inkluderas som default.

För att inkludera allt innehåll i package misc måste dock följande use-direktiv användas:

use work.misc.all;

För att tillämpa submoduler och package har ett system implementerats där två hexadecimala tal 0x0 - 0xF kan matas in via fyra slide-switchar var och där de två talen samt summan och differensen av dem skrivs ut på var sin 7-segmentsdisplay. 
Hårdvara är implementerat för FPGA-kortet Terasic DE0.

Funktioner och procedurer har implementerats i ett package döpt misc för att

    - erhålla binärkoden för en siffra 0x0 - 0xF utefter angiven siffra 0000 - 1111 för respektive display
    - beräkna summan och differensen av osignerade tal med angivet antal bitar
    - enkelt omvandla mellan osignerade tal (natural) samt bitar (std_logic_vector).

Även konstanter för binärkoder till hexadecimala tal 0x0 - 0xF har implementerats fär gemensam anod enligt nedanstående tabell:

|   Siffra   |   Binärkod   |
| :--------: | :----------: | 
|      0     |    1000000   |
|      1     |    1111001   |
|      2     |    0100100   |     
|      3     |    0110000   |    
|      4     |    0011001   |   
|      5     |    0010010   |     
|      6     |    0000010   |      
|      7     |    1111000   |      
|      8     |    0000000   |     
|      9     |    0010000   |     
|      A     |    0001000   |     
|      B     |    0000011   |     
|      C     |    1000110   |     
|      D     |    0100001   |     
|      E     |    0000110   |  
|      F     |    0001110   |        
|      Av    |    1111111   |    

Binärkoderna implementerades via följande konstanter deklarerade i package misc:

constant DISPLAY_0  : std_logic_vector(6 downto 0) := "1000000";\
constant DISPLAY_1  : std_logic_vector(6 downto 0) := "1111001";\
constant DISPLAY_2  : std_logic_vector(6 downto 0) := "0100100";\
constant DISPLAY_3  : std_logic_vector(6 downto 0) := "0110000";\
constant DISPLAY_4  : std_logic_vector(6 downto 0) := "0011001";\
constant DISPLAY_5  : std_logic_vector(6 downto 0) := "0010010";\
constant DISPLAY_6  : std_logic_vector(6 downto 0) := "0000010";\
constant DISPLAY_7  : std_logic_vector(6 downto 0) := "1111000";\
constant DISPLAY_8  : std_logic_vector(6 downto 0) := "0000000";\
constant DISPLAY_9  : std_logic_vector(6 downto 0) := "0010000";\
constant DISPLAY_A  : std_logic_vector(6 downto 0) := "0001000";\
constant DISPLAY_B  : std_logic_vector(6 downto 0) := "0000011";\
constant DISPLAY_C  : std_logic_vector(6 downto 0) := "1000110";\
constant DISPLAY_D  : std_logic_vector(6 downto 0) := "0100001";\
constant DISPLAY_E  : std_logic_vector(6 downto 0) := "0000110";\
constant DISPLAY_F  : std_logic_vector(6 downto 0) := "0001110";\
constant DISPLAY_OFF: std_logic_vector(6 downto 0) := "1111111";

Filen "misc.vhd" innehåller deklaration samt definition av diverse funktioner- och procedurer samt konstanter.

Filen "multi_hex.vhd" utgör konstruktionens toppmodul, där de fyra displayerna tilldelas var sitt tal,
och summan samt differensen av inmatade siffror beräknas via funktionsanrop.

Filen "multi_hex.qar" utgör en arkiverad version av konstruktionen med all kod implementerad och
hårdvara konfigurerad för FPGA-kort Terasic DE0. 

Se video tutorial här:
https://youtu.be/hPkxAD5WkKk