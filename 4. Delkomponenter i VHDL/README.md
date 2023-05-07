# Delkomponenter i VHDL
Demonstration av hur en större konstruktion kan delas in i multipla mindre moduler, även kallat delkomponenter, i VHDL.
En delkomponent kan därefter instansieras en eller flera gånger för att implementera motsvarande hårdvara. 

I denna konstruktion har delkomponenter implementerats för att skriva ut ett tal på både hexadecimal form (0x00 - 0xFF) samt decimal form (00 - 99), där respektive tal skrivs ut på två 7-segmentsdisplayer, alltså totalt fyra 7-segmentsdisplayer. Talet som skrivs ut matas in binärt via åtta slide-switchar. 

I delkomponenten dual_display skrivs inmatat tal ut på två displayer. Det inmatade talet kontrolleras, där alla tal större än vad som kan skrivas ut på två displayer (talbasen ^ 2 - 1) ignoreras. Använd talbas kan väljas valfritt via parametern RADIX, där default är talbas 16. Tiotalet och entalet ur aktuellt tal x beräknas utefter aktuell talbas; efter att ha tagit redo på tiotalet beräknas entalet via formeln x - talbas * tiotal. Två instanser av delkomponenten display används för att skriva ut motsvarande siffror på respektive 7-segmentsdisplay.

Till skillnad mot i föregående exempel användes varken egenskapade package, funktioner eller procedurer. I stället skedde implementering enbart via multipla moduler.
Vid större konstruktioner kan dessa två metoder lämpligen kombineras.

Konstanter för binärkoder till hexadecimala tal 0x0 - 0xF har implementerats för gemensam anod enligt nedanstående tabell:

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

Binärkoderna implementerades via följande konstanter deklarerade lokalt i modulen display:

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

Filen "multi_hex_radix.vhd" utgör konstruktionens toppmodul, där de två display-paren tilldelas var sitt tal (0x00 - 0xFF respektive 00 - 99) utefter inmatat tal.

Filen "dual_display.vhd" innehåller komponenten dual_display, där ett 2-siffrigt tal med valbar talbas 2 - 16 skrivs ut via två 7-segmentsdisplayer.

Filen "display.vhd" innehåller delkomponenten display, som används för att skriva ut ett tal 0x0 - 0xF på en 7-segmentsdisplay.

Filen "multi_hex_radix.qar" utgör en arkiverad version av konstruktionen med all kod implementerad och hårdvara konfigurerad för FPGA-kortet Terasic DE0. 

Filen "Terasic DE0 User Manual.pdf" utgör databladet för FPGA-kortet Terasic DE0.

Se video tutorial här:
https://youtu.be/2_FT-p-BdwE
