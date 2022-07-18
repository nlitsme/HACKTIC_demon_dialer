* > demon ***************************************************************
*                                                                       *
*              The makers of "The chip that says KUTTEKOP"              *
*                                                                       *
*                                 and                                   *
*                                                                       *
*                    "The Bit-Blasting Page-O-Matic"                    *
*                                                                       *
*                          now proudly present                          *
*                                                                       *
*                      "The Deafening Demon-Dialer"                     *
*                                                                       *
*************************************************************************

PORTA   EQU     $00
PORTB   EQU     $01
PORTC   EQU     $02
PORTD   EQU     $03     in,-,SS*,SCK;MOSI,MISO,TxD,RxD
DDRA    EQU     $04     Data direction, Port A
DDRB    EQU     $05     Data direction, Port B
DDRC    EQU     $06     Data direction, Port C
SPCR    EQU     $0A     SPIE,SPE,-,MSTR;CPOL,CPHA,SPR1,SPR0
SPSR    EQU     $0B     SPIF,WCOL,-,MODF;-,-,-,-
SPDR    EQU     $0C     SPI Data
BAUD    EQU     $0D     -,-,SCP1,SCP0;-,SCR2,SCR1,SCR0
SCCR1   EQU     $0E     R8,T8,-,M;WAKE,-,-,-
SCCR2   EQU     $0F     TIE,TCIE,RIE,ILIE;TE,RE,RWU,SBK
SCSR    EQU     $10     TDRE,TC,RDRF,IDLE;OR,NF,FE,-
SCDAT   EQU     $11     SCI Data
TCR     EQU     $12     ICIE,OCIE,TOIE,0; 0,0,IEGE,OLVL
TSR     EQU     $13     ICF,OCF,TOF,0; 0,0,0,0
ICAP    EQU     $14     Input Capture Reg (Hi-$14, Lo-$15)
OCMP    EQU     $16     Output Compare Reg (Hi-$16, Lo-$17)
TCNT    EQU     $18     Timer Count Reg (Hi-$18, Lo-$19)
ALTCNT  EQU     $1A     Alternate Count Reg (Hi-$1A, Lo-$1B)
PROG    EQU     $1C     Program register
COPR    EQU     $1D     COP Reset register (write $55, then $AA to reset)
COPC    EQU     $1E     -,-,-,COPF; CME,COPE,CM1,CM0

OPTION  EQU     $1FDF

*       Baud rate equates for BAUD register (at 4.0 MHz crystal)

B75     EQU     %00110111
B150    EQU     %00110110
B300    EQU     %00110101
B600    EQU     %00110100
B1200   EQU     %00110011
B2400   EQU     %00110010
B4800   EQU     %00110001
B9600   EQU     %00110000

CR      EQU     13
LF      EQU     10

MAXFREQ EQU     107     Maximum freq # in frequency table
MAXKEYS EQU     100     Maximum number of programmable key area bytes

ATF1_LO EQU     1950*8          Low frequency (1950 Hz) of ATF1
ATF1_HI EQU     2070*8          High frequency (2070 Hz) of ATF1
ATF1_TM EQU     65536-10*8      Bit time of ATF1 (10 ms)


        ORG     $0030

TONE1CT RMB     2       Tone 1 counter value
TONE1ST RMB     2       Tone 1 step value
TONE2CT RMB     2       Tone 2 counter value
TONE2ST RMB     2       Tone 2 step value
TONE3CT RMB     2       Tone 3 counter value
TONE3ST RMB     2       Tone 3 step value
TONEOUT RMB     1
TONE1   RMB     3       This RAM space is allocated to hold jump instructions
TONE2   RMB     3       into the routines that handle the tone producing bit
TONE3   RMB     3
TICKER  RMB     2       8.192 kHz ticker, which allows tone lengths to 8 secs
NEXTSTR RMB     1       Strobe to indicate next tone parms are to be loaded

TIMEOUT RMB     1       Time-out counter for auto power-off function
TIMOUTA RMB     1       Time-out counter for audio-off

KEYBUF  RMB     4       4-byte keyboard buffer
KEYS    RMB     1       # of keys in keyboard buffer
KEYCNT  RMB     1       Keyboard counter
KEYSTAT RMB     1       Keyboard status

SERSTAT RMB     1       Status of serial keyboard fake

TEMP1   RMB     1       Temporary storage for main program (not interrupt)
TEMP2   RMB     1       Secondary temp storage
TEMP3   RMB     1       Third temp storage
TEMP4   RMB     1       Guess
TEMP5   RMB     1       Boring
TEMP6   RMB     1

VALUE   RMB     2       2-byte value entered from keyboard

MODE    RMB     1

*************************************************************************
*                                                                       *
* MODE          : Current operating mode                                *
*                                                                       *
* The mode byte format is :                                             *
*                                                                       *
* piom mmmm                                                             *
*                                                                       *
* p             : password is entered correctly                         *                                            *
* i             : key is played in macro                                *
* o             : password protection off when set                      *
* mmmmm         : current mode                                          *
*                                                                       *
*************************************************************************

MACKEYS RMB     1       # keys total macro space (10-96)
MACCNT  RMB     1       Macro counter
MACNCNT RMB     2       Macro counters for nested macros (two maximum)
MACMCNT RMB     2       Macro counters for nested macros for marker (2 max)
MACNEST RMB     1       Macro level nesting count (Bits 1&0). Bit 7 indicates
*                       non-pauseable macro is being played.
*                       Bit 6 indicates pauseable mode 4 temp marker bit.
*                       Bit 5 means don't set timeout on AUDIOFF.
*                       Bit 4 means in-macro-mode scan.
*                       Bits 3&2 indicate marker's nesting level.
MARKER  RMB     1       Marker used in pauseable macros

MACAL   RMB     1       Macro alias two nibbles (0-9 or 11 when off)

MACSCAN RMB     1       In-Macro-Scanning: two nibbles: Macro/Count Macro
MACSCNT RMB     1       I-M-S Scan count increment/decrement amount

GUARD   RMB     3       Three guard frequencies, high bit of the first
*                       indicates guard tone on

TIMTMPL RMB     16      The time templates hold room for 8 timing values

GETBYTE RMB     4       These RAM locations hold instructions LDA ix2,X  RTS
LOC     EQU     GETBYTE+1

US2OFS  RMB     1       Offset into key area for start of user mode 2
MODKEYS RMB     1       Total # of keys in key area
KEYAREA RMB     MAXKEYS
        RMB     1       Dummy byte (used by programmer to check end of keyarea)

*************************************************************************
*                                                                       *
* KEYAREA       : This area holds the definitions for two user modes    *
*                                                                       *
* The format for the keys is exactly the same as those of the ROM modes *
*                                                                       *
* First byte of a key    : lnnt thhh                                    *
*                          l when set indicates last tone of key        *
*                          nn - # of tones (0,1,2)                      *
*                          tt - 0 means play fixed time hhh=high 3 bits *
*                               1 means play while pressed if not in    *
*                                 macro, else fixed time                *
*                               2 means play template time hhh=index    *
*                               3 means play while pressed if not in    *
*                                 macro, else template time hhh=index   *
*                                                                       *
* If fixed time then next byte is lower 8 bits of time in 1/1024 secs   *
* If tones <> 0 then    : aaaa bbbb                                     *
*                         aaaa - dB level tone a                        *
*                         bbbb - dB level tone b                        *
* Then for each tone a byte which is index into frequency table         *
*                                                                       *
*                                                                       *
* !! NB  The RAM key area is growing into the stack, but since we don't *
* use the entire stack this will work fine. (probably)                  *
*                                                                       *
*************************************************************************

        ORG     $0100

*************************************************************************
*                                                                       *
* MACROS        : The macro area                                        *
*                                                                       *
* This area holds up to 96 6-bit macro entries. The macro entry format  *
* is :                                                                  *
*                                                                       *
* 0skkkk        : key code skkkk where s means shift and kkkk 4-bit key *
*                 kkkk = 0-11 for non-shifted and 0-9 for shifted keys  *
*                                                                       *
* 001100        : start guard tone 0                                    *
* 001101        : start guard tone 1                                    *
* 001110        : start guard tone 2                                    *
* 001111        : stop guard tone                                       *
*                                                                       *
* The next 5 entries don't apply in non-pauseable macro mode            *
*                                                                       *
* 011100        : marker                                                *
* 011101        : wait for shift-press                                  *
* 011110        : if shift-pressed wait for release and another press   *
* 011111        : if shift-pressed wait for release, then if pressed    *
*                 within 125 ms continue else goto marker               *
* 111110        : marker AND wait for shift-press                       *                                        *
*                                                                       *
* 1mmmmm        : mode mmmmm, switches between modes                    *
*                 mmmmm = 0-19                                          *
*                                                                       *
* 1mmmmm        : macro mmmmm, allows up to two nested macros           *
*                 mmmmm = 20-29                                         *
*                                                                       *
* 111111        : end of macro                                          *
*                                                                       *
*************************************************************************


MACROS  RMB     72      72 bytes (96 entries) of macro room

*************************************************************************
*                                                                       *
* FREQTBL       : 100-entries frequency table                           *
*                                                                       *
* This table holds 12 programmable and 88 fixed frequencies. The lower  *
* part of the table is in RAM and the upper part is in ROM.             *
*                                                                       *
*************************************************************************

        ORG     $0148

FREQTBL RMB     24              Reserve room for 12 user definable frequecies

        FDB     5600            12 - 700 Hz     -
        FDB     7200            13 - 900 Hz      |
        FDB     8800            14 - 1100 Hz     |- MF
        FDB     10400           15 - 1300 Hz     |
        FDB     12000           16 - 1500 Hz     |
        FDB     13600           17 - 1700 Hz    -

        FDB     5558            18 - 694.8 Hz     -
        FDB     6161            19 - 770.1 Hz      |
        FDB     6819            20 - 852.4 Hz      |
        FDB     7520            21 - 940.0 Hz      |
        FDB     9648            22 - 1206.0 Hz     |- FDTMF
        FDB     10654           23 - 1331.7 Hz     |
        FDB     11892           24 - 1486.5 Hz     |
        FDB     13112           25 - 1639.0 Hz    -

        FDB     11040           26 - 1380 Hz    -
        FDB     12000           27 - 1500 Hz     |
        FDB     12960           28 - 1620 Hz     |
        FDB     13920           29 - 1740 Hz     |- R2 Forward
        FDB     14880           30 - 1860 Hz     |
        FDB     15840           31 - 1980 Hz    -

        FDB     9120            32 - 1140 Hz    -
        FDB     8160            33 - 1020 Hz     |
        FDB     7200            34 - 900 Hz      |
        FDB     6240            35 - 780 Hz      |- R2 Backward
        FDB     5280            36 - 660 Hz      |
        FDB     4320            37 - 540 Hz     -

        FDB     12000           38 - 1500 Hz    -
        FDB     13600           39 - 1700 Hz     |- Red
        FDB     17600           40 - 2200 Hz    -

        FDB     15600           41 - 1950 Hz    -
        FDB     16560           42 - 2070 Hz     }- ATF1

        FDB     4800            43 - 600 Hz     -
        FDB     6000            44 - 750 Hz      |
        FDB     9600            45 - 1200 Hz     |
        FDB     12800           46 - 1600 Hz     |
        FDB     13000           47 - 1625 Hz     |
        FDB     13600           48 - 1700 Hz     |
        FDB     15200           49 - 1900 Hz     |
        FDB     16320           50 - 2040 Hz     |
        FDB     16800           51 - 2100 Hz     |- Pliek
        FDB     18420           52 - 2280 Hz     |
        FDB     19200           53 - 2400 Hz     |
        FDB     20000           54 - 2500 Hz     |
        FDB     20800           55 - 2600 Hz     |
        FDB     24000           56 - 3000 Hz     |
        FDB     26800           57 - 3350 Hz     |
        FDB     30600           58 - 3825 Hz    -

        FDB     1176            59 - 147 Hz     _
        FDB     2800            60 - 350 Hz      |
        FDB     3200            61 - 400 Hz      |
        FDB     3520            62 - 440 Hz      |
        FDB     3600            63 - 450 Hz      |- Call Progress
        FDB     3840            64 - 480 Hz      |
        FDB     4000            65 - 500 Hz      |
        FDB     4960            66 - 620 Hz     -

        FDB     7600            67 - 950 Hz     -
        FDB     11200           68 - 1400 Hz     |- SIT
        FDB     14400           69 - 1800 Hz    -

        FDB     11200           70 - 1400 Hz    -
        FDB     14800           71 - 1850 Hz     |
        FDB     19600           72 - 2450 Hz     |- Call Progress HI
        FDB     20800           73 - 2600 Hz    -

        FDB     0               74 -    0 Hz    -
        FDB     16000           75 - 2000 Hz     |- Special
        FDB     21600           76 - 2700 Hz    -

        FDB     1200            77 - 150 Hz     - Call Progress
        FDB     4400            78 - 550 Hz     - Modem tone
        FDB     6824            79 - 853 Hz     - EBS
        FDB     7680            80 - 960 Hz     - EBS
        FDB     8560            81 - 1060 Hz    - Modem tone
        FDB     10160           82 - 1270 Hz    - Modem tone
        FDB     16200           83 - 2025 Hz    - Modem tone
        FDB     17800           84 - 2225 Hz    - Modem tone
        FDB     21704           85 - 2713 Hz    - Loopback
        FDB     22000           86 - 2750 Hz    - Guard
        FDB     22400           87 - 2800 Hz    - Guard
        FDB     22800           88 - 2850 Hz    - Guard
        FDB     23200           89 - 2900 Hz    - Guard
        FDB     23600           90 - 2950 Hz    - Guard

        FDB     9280            91 - 1160 Hz    - Tone slot
        FDB     12240           92 - 1530 Hz    - Tone slot
        FDB     13360           93 - 1670 Hz    - Tone slot
        FDB     14640           94 - 1830 Hz    - Tone slot


*       Start of code

RESET   RSP                     Cold boot, power on reset, total machine init
        LDA     #%11000000
        STA     OPTION          Turn all RAM on

        LDA     #%11011111      Port A pin 5 is switched to input (NILS !*&!*@!)
        STA     DDRA
        LDA     #%11111111      Switch ports B & C to outputs
        STA     DDRB
        STA     DDRC

        BSET    3,PORTB         Switch on power upper

        JSR     DEVINIT

INIT    RSP                     Warm boot, only init ports etc.

        CLR     PORTA
        LDA     #%00001111      Enable all keyboard columns and switch on
        STA     PORTB           power upper and set external bit to 0
        LDA     #%10000000      Switch off audio on init
        STA     PORTC

        LDA     #$CC            $cc = JMP instruction
        STA     TONE1           This is a very dirty trick we're using here
        STA     TONE2           The RAM locations TONE1, TONE2 and TONE3 are
        STA     TONE3           used to hold jump instructions

        LDA     JUMPTB1+30      Program the jump addresses at init, else
        STA     TONE1+1         the program will crash
        LDA     JUMPTB1+31      The init sound levels are -15 dB
        STA     TONE1+2

        LDA     JUMPTB2+30
        STA     TONE2+1
        LDA     JUMPTB2+31
        STA     TONE2+2

        LDA     JUMPTB3+30
        STA     TONE3+1
        LDA     JUMPTB3+31
        STA     TONE3+2

        CLR     TONE1CT         at 50% DC level (0 Hz init)
        CLR     TONE1CT+1
        CLR     TONE1ST
        CLR     TONE1ST+1
        CLR     TONE2CT
        CLR     TONE2CT+1
        CLR     TONE2ST
        CLR     TONE2ST+1
        CLR     TONE3CT
        CLR     TONE3CT+1
        CLR     TONE3ST
        CLR     TONE3ST+1

        CLR     TICKER
        CLR     TICKER+1

        CLR     KEYS            On init key buffer is empty
        CLR     KEYSTAT         No keys pressed right now

        CLR     TIMEOUT         Clear the power-off counter
        CLR     TIMOUTA         Clear the audio-off counter

        CLR     MODE            No password, no macro, protection on, DTMF

        CLR     VALUE           On init VALUE is used for password entering
        CLR     VALUE+1         as these bytes are not used without password

        LDA     #$D6            = LDA eeff,X
        STA     GETBYTE
        LDA     #$81
        STA     GETBYTE+3      = RTS

        BSET    7,NEXTSTR

INIT_0  LDA     TCNT            Wait for timer to wrap
        LDX     TCNT+1
        CMP     #255
        BNE     INIT_0

        LDA     TSR             To make sure these flags are cleared
        LDA     #0              To clear Output Compare Flag
        STA     OCMP
        STA     OCMP+1
        LDA     TCNT+1          To clear Timer Overflow Flag

        LDA     #%01100000      Enable output compare for sound and key-scan
        STA     TCR             and timer for auto shutoff

        LDA     #%00000011      Program SCI rate at 16384 bps
        STA     BAUD
        CLR     SCCR1
        LDA     #%00101100      Enable transmitter and receiver
        STA     SCCR2           and receiver interrupt

        CLI                     Enable system interrupts

INIT_1  BRCLR   4,COPC,INIT_2   Test to see if this init is due to a COP
        JSR     SITBEEP         If so, signal SIT

INIT_2  JSR     ONBEEP          Say hello to the outside world

        LDA     #%00000110      Set COP control with a 250 ms timeout period
        STA     COPC

        CLR     SERSTAT
        CLRX
INIT_3  LDA     MESSAGE,X
        BEQ     MAIN
        JSR     TX
        INCX
        BRA     INIT_3

*************************************************************************
*                                                                       *
* MAIN          : The main program loop                                 *
*                                                                       *
* The main loop performs the following functions :                      *
*                                                                       *
* Get keys from the keyboard buffer                                     *
* Play key sequences                                                    *
* Play macro sequences                                                  *
*                                                                       *
*************************************************************************


MAIN    JSR     INKEY           Check keyboard input
        CMP     #$FF
        BEQ     MAIN

        CMP     #%00011001      keys 0-9,*,# or ^0-^9
        BHI     MAIN_5          Else ^* or ^#
        BRSET   7,MODE,MAIN_4   If password is entered correctly, make tone

        INC     VALUE+1
        LDX     VALUE+1

        BRSET   7,VALUE,MAIN_2  Is normal password wasted ?

        CMP     PASSWRD-1,X     Is this a correct digit
        BEQ     MAIN_1          If so, check if password completed

        BSET    7,VALUE         If not, wrong password, set bit 7 of
        BRA     MAIN_2          VALUE to indicate so

MAIN_1  CPX     PASDIGS         Have we had all password digits ?
        BNE     MAIN_2
        BSET    7,MODE          If so, set MODE bit, for extra Demon features
        JSR     PASBEEP         And play password beep
        BRA     MAIN

MAIN_2  BRSET   6,VALUE,MAIN_4  Is mother password wasted ?
        CMP     MOTHER-1,X
        BEQ     MAIN_3

        BSET    6,VALUE
        BRA     MAIN_4

MAIN_3  CPX     #11             All 11 mother digits entered ?
        BNE     MAIN_4
        BSET    7,MODE          Extra Demon features
        JSR     PASBEEP
        JSR     PASBEEP
        JSR     PASBEEP
        BRA     MAIN

MAIN_4  CLR     TIMOUTA
        JSR     PLAYKEY
        JSR     AUDIOFF
        BRA     MAIN

MAIN_5  BRCLR    7,MODE,MAIN    If password not entered, no special features

        CMP     #%00011010      ^* pressed ?
        BNE     MACRO           If not, ^# pressed, macro mode
        JSR     STAR            Else star mode
        BRA     MAIN

MACRO   BSET    6,MODE          Macro mode
        LDA     MODE
        STA     TEMP6
        JSR     EMMBEEP         Play macro mode entry beep

MACRO_0 JSR     GETKEY          Get key from keyboard
        CMP     #9              Digit ?
        BHI     MACRO_1
MACR_00 CLR     MACNEST         This is the first macro
        LDX     #%11111111
        STX     MARKER
MACR_01 BSR     PLAYMAC         Then play macro
        JSR     AUDIOFF
        BRA     MACRO_0
MACRO_1 BIT     #16             Shifted key ?
        BEQ     MACRO_2
        JMP     RECMAC          If shifted digit, record macro (or ^*)
MACRO_2 CMP     #11             # pressed ?
        BEQ     MACRO_6         Then leave macro mode
        JSR     KEYBEEP         Else * pressed, macro aliasing or scan up/down
        JSR     GETKEY
        CMP     #9              Digit ?
        BLS     MACRO_4
        CMP     #11             # pressed ?
        BEQ     MACRO_3
        CMP     #10             * pressed ?
        BEQ     MACR_30
MACR_20 JSR     SITBEEP
        BRA     MACRO_0         shifted digit hit

MACR_30 CLRA                    **   scan down  Note * is down--not up
MACR_35 LDX     MACNEST         Unset scan?
        COMX
        BEQ     MACR_20
        BSET    4,MACNEST
        JSR     SCAN_5
        CLR     MACNEST
        AND     #%00001111
        CMP     #9
        BHI     MACR_20
        BRA     MACR_00
MACRO_3 LDA     #10             *#   scan up
        BRA     MACR_35

MACRO_4 STA     MACAL
        JSR     KEYBEEP
MACR_40 JSR     GETKEY          Else, we want another digit
        CMP     #9
        BLS     MACRO_5
        CMP     #11
        BEQ     MACRO_5
        JSR     SITBEEP         If the user enters a wrong digit, ask again
        BRA     MACR_40

MACRO_5 LSLA
        LSLA
        LSLA
        LSLA

        ORA     MACAL
        STA     MACAL
        JSR     CFBEEP
        BRA     MACRO_0

MACRO_6 JSR     XMMBEEP
        LDA     TEMP6           Restore original mode
        STA     MODE
        BCLR    6,MODE
        JMP     MAIN

PLAYMAC CLRX                    Play macro
        STA     TEMP3           First find start of this macro
        LDA     MACAL
        AND     #%00001111
        CMP     TEMP3
        BNE     PLM_00
        LDA     MACAL
        LSRA
        LSRA
        LSRA
        LSRA
        STA     TEMP3
PLM_0   CMP     #11             No macro (aliased to nothing) ?
        BEQ     PLM_31
PLM_00  DEC     TEMP3           This is the one ?
        BMI     PLM_2
PLM_1   JSR     READMAC         If not, read macro entry
        INCX                    Update counter for next read
        CMP     #%00111111      Last macro key
        BNE     PLM_1
        BRA     PLM_00

PLM_2   STX     MACCNT
PLM_3   SEI                     Disable keyboard buffer changes
        LDX     KEYS
        BEQ     PLM_32
        LDA     KEYBUF          Check last key in buffer
        CMP     #11             # pressed in macro play ?
        BNE     PLM_32
PLM_33  JSR     INKEY           Clear buffer if # pressed (INKEY CLI's)
        CMP     #$FF
        BNE     PLM_33
        BRA     PLM_30          Quit
PLM_32  CLI
        JSR     CLRTIME
        LDX     MACCNT          Get next macro read
        INC     MACCNT          Update counter
        JSR     READMAC         Read macro entry
        CMP     #%00111111      End of macro ?
        BNE     PLM_5
PLM_31  LDA     MACNEST
        AND     #%00000011
        BNE     PLM_4
PLM_30  RTS                     Then return

PLM_4   DEC     MACNEST         Nested macro, decrement nesting level
        LDA     MACNEST
        AND     #%00000011
        TAX
        LDA     MACNCNT,X       And get previous macro counter
        STA     MACCNT
        BRA     PLM_3

PLM_5   CMP     #%00100000
        BLO     PLM_8
        CMP     #%00111110      Pauseable mode 4 ?
        BEQ     PLM_8
        CMP     #%00110100      Mode set ?
        BHS     PLM_6
        SUB     #%00100000
        JSR     SETMODE
        BRA     PLM_3
PLM_6   SUB     #%00110100      Nested macro
        STA     TEMP1
        LDA     MACNEST
        AND     #%00000011
        TAX                     Test the macro level nesting
        CPX     #2
        BNE     PLM_7
        JSR     SITBEEP         Up to 2 nesting levels are allowed
        RTS

PLM_7   LDA     MACCNT          Store current macro counter
        STA     MACNCNT,X
        INC     MACNEST         One level deeper
        LDA     TEMP1           And jump to play this macro
        JMP     PLAYMAC

PLM_8   STA     TEMP1
        AND     #%00011100
        CMP     #%00001100      Is it a guard tone ?
        BEQ     PLM_9

        CMP     #%00011100      Is it a pause type ?
        BEQ     PLM_11

        LDA     TEMP1           If not, it is a key
        CLR     TIMOUTA         Make sure key is played without audio shut-off
        JSR     PLAYKEY
        BRA     PLM_3

PLM_9   LDA     TEMP1           Guard tone
        AND     #3
        CMP     #3              End of guard tone
        BNE     PLM_10          If not, start guard tone
        BCLR    7,GUARD         Switch off guard tone
        SEI
        CLR     TONE3ST
        CLR     TONE3ST+1
        CLR     TONE3CT
        CLR     TONE3CT+1
        CLI
        JMP     PLM_3

PLM_10  TAX                     Start guard tone
        SEI
        LDA     JUMPTB3+12      Set guard tone at -6 dB
        STA     TONE3+1
        LDA     JUMPTB3+13
        STA     TONE3+2
        LDX     GUARD,X         Get frequency index for this guard tone
        LSLX
        LDA     FREQTBL,X
        LDX     FREQTBL+1,X
        STA     TONE3ST
        STX     TONE3ST+1
        CLI
        BSET    7,GUARD
        JMP     PLM_3

PLM_11  BRCLR   7,MACNEST,PLM_12        Test to see if in non-pauseable mode
        JMP     PLM_3                   if not, just go on

PLM_12  BSET    5,MACNEST       Set AUDIOFF timeout prevention flag
        LDA     TEMP1
        CMP     #%00111110
        BEQ     PLM_1A
        AND     #3
        BNE     PLM_13          Marker setting
        LDA     MACCNT
        STA     MARKER
        JSR     SAVNES
        JMP     PLM_22

PLM_13  CMP     #2
        BLO     PLM_16
        BIH     PLM_22          Shift not pressed?
        BHI     PLM_18

        JSR     AUDIOFF
PLM_14  JSR     USHFDEB
        BEQ     PLM_14          Wait for it to be released
PLM_15  BSR     PLM_25          or * to goto marker
        BEQ     PLM_23          If * pressed
        BCS     PLM_22          If # pressed
        JSR     SHFDEB
        BEQ     PLM_15          And pressed again
        BRA     PLM_22

PLM_1A  BSET    6,MACNEST
PLM_16  JSR     AUDIOFF
PLM_1B  BIL     PLM_1B          Wait for shift to be released
PLM_17  BSR     PLM_25          Wait for a shift or * to cont. or goto marker
        BEQ     PLM_23          If * pressed
        BCS     PLM_22          If # pressed
        JSR     SHFDEB
        BEQ     PLM_17
        BRCLR   6,MACNEST,PLM_22        Branch if not pause mode 4
        LDA     MACCNT
        STA     MARKER
        JSR     SAVNES                  Save nesting level
        BRA     PLM_22

PLM_18  JSR     AUDIOFF
PLM_1C  BSR     USHFDEB
        BEQ     PLM_1C          Wait for shift to be released
        LDX     ALTCNT
PLM_19  CPX     ALTCNT
        BEQ     PLM_19
PLM_20  BSR     SHFDEB
        BNE     PLM_22          Check if shift is pressed and if so, just
        CPX     ALTCNT          continue
        BNE     PLM_20

PLM_21  BSR     PLM_25          Check on * or #
        BEQ     PLM_23          If * pressed
        BCS     PLM_22          If # pressed
        BSR     SHFDEB
        BEQ     PLM_21          Wait for shift to be pressed
PLM_23  LDA     MARKER          If we have a valid marker, jump back to that
        CMP     #%11111111
        BEQ     PLM_2A
        STA     MACCNT
        LDA     MACNEST         Restore nesting level
        AND     #%00001100
        LSRA
        LSRA
        BCLR    0,MACNEST
        BCLR    1,MACNEST
        ORA     MACNEST
        STA     MACNEST
        LDA     MACMCNT         Restore nesting markers
        STA     MACNCNT
        LDA     MACMCNT
        STA     MACNCNT
        BRA     PLM_22
PLM_2A  DEC     MACCNT          If there's nothing to * to, stay here
PLM_22  BCLR    5,MACNEST
        BCLR    6,MACNEST
        JMP     PLM_3

PLM_25  SEI                     Check for *
        TST     KEYS
        BEQ     PLM_26
        LDA     KEYBUF
        CMP     #10
        BLO     PLM_26
        CMP     #11             Test for aborting #
        BEQ     PLM_28
        JSR     INKEY           Get * from buffer
        CLRA
        BRA     PLM_27
PLM_26  CLRA
        COMA
PLM_27  CLC
        BRA     PLM_29
PLM_28  CLRA
        COMA                    Also sets carry
PLM_29  CLI
        RTS                     Returns Z flag set if * hit/C set if #

USHFDEB BIL     USHFD_1         Debounce for shift release checking
        LDA     #10
USHFD_0 BIL     USHFD_1
        DECA
        BNE     USHFD_0
        BRA     USHFD_2
USHFD_1 CLRA
        COMA
USHFD_2 COMA
        RTS                     Returns Z=1 for still shifted Z=0 for unshifted

SHFDEB  BIH     SHFD_1          Debounce for shift press checking
        LDA     #10
SHFD_0  BIH     SHFD_1
        DECA
        BNE     SHFD_0
        BRA     SHFD_2
SHFD_1  CLRA
        COMA
SHFD_2  COMA
        RTS                     Returns Z=1 for still unshifted Z=0 for shifted

SAVNES  LDA     MACNEST                 Save nesting level
        AND     #%00000011
        LSLA
        LSLA
        BCLR    3,MACNEST
        BCLR    2,MACNEST
        ORA     MACNEST
        STA     MACNEST
        LDA     MACNCNT                 Save nesting markers
        STA     MACMCNT
        LDA     MACNCNT+1
        STA     MACMCNT+1
        RTS

RECMAC  CMP     #%00011010      ^* or ^# pressed
        BLO     RECM_0
        BNE     RECM_00
        JSR     KEYBEEP         ^* pressed
        JSR     GETKEY
        CMP     #11             ^* # means play macro in non-pauseable mode
        BEQ     RECM_90
        JSR     STAR_0          goto star mode

        JMP     MACRO_0

RECM_90 JSR     KEYBEEP
        JSR     GETKEY          Get non-pausable macro number
        CMP     #9
        BHI     RECM_00
        CLR     MACNEST
        BSET    7,MACNEST
        JMP     MACR_01

RECM_00 JSR     SITBEEP         ^# or illegal macro no meaning
        JMP     MACRO_0

RECM_0  AND     #%00001111      Get macro #
        STA     TEMP3
        CLRX                    Find start of this macro
RECM_1  DEC     TEMP3           This is the one ?
        BMI     RECM_3
RECM_2  JSR     READMAC         If not, read macro
        INCX
        CMP     #%00111111      Last macro key ?
        BNE     RECM_2
        BRA     RECM_1

RECM_3  STX     MACCNT
        JSR     READMAC         Now check to see if this macro is empty
        CMP     #%00111111      End of macro ?
        BEQ     RECM_7          Then empty
        JSR     ALERT           Else, sound alert
        JSR     GETKEY          And get key # for confirmation
        CMP     #11
        BEQ     RECM_4
        JSR     DNTBEEP         Give beep to indicate a don't
        JMP     MACRO_0         If no confirmation, just return
RECM_4  JSR     CFBEEP          Give beep to indicate OK
        LDX     MACCNT          Else, we are going to empty this macro
        STX     TEMP3           by shifting all keys back
RECM_5  INCX
        JSR     READMAC         Find end of macro
        CMP     #%00111111
        BNE     RECM_5
        STX     TEMP4

RECM_6  JSR     READMAC         Now move buffer to empty current macro
        LDX     TEMP3
        JSR     WRITMAC
        INC     TEMP3
        INC     TEMP4
        LDX     TEMP4
        CPX     MACKEYS
        BLO     RECM_6

        LDA     TEMP3           Now the # of keys to be moved are TEMP4-TEMP3
        SUB     TEMP4           This has to be substracted from MACKEYS
        ADD     MACKEYS         (MACKEYS-TEMP4+TEMP3)
        STA     MACKEYS
        BRA     RECM_8

RECM_7  JSR     CFBEEP          Confirm programming
        LDA     MACKEYS         Macro area full ?
        CMP     #96
        BNE     RECM_8
        JSR     ALERT           Then alert and return to macro mode
        JMP     MACRO_0

RECM_8  JSR     GETKEY          Get macro key
        STA     TEMP4
        JSR     KEYBEEP
        LDA     TEMP4
        CMP     #%00011010      Normal digit, *, # or shifted digit
        BLO     RECM_14
        BEQ     RECM_12         ^*

        JSR     GETKEY          ^# pressed now 0-9 or #
        CMP     #11             #, then end of macro
        BNE     RECM_9
        JSR     CFBEEP          Indicate end of macro
        JMP     MACRO_0
RECM_9  CMP     #9              Not 0-9, then invalid
        BLS     RECM_11
RECM_10 JSR     SITBEEP
        BRA     RECM_8

RECM_11 ADD     #%00110100      Nested macro
        STA     TEMP4
        JSR     KEYBEEP
        BRA     RECM_14         Store macro key

RECM_12 JSR     GETKEY          ^* pressed, now 0-9 or ^0-^9 for mode
        CMP     #10             or * for guard toning
        BLO     RECM_13
        BEQ     RECM_16         * Pressed, guard modes
        CMP     #11
        BEQ     RECM_18         # Pressed, pauseable thingies
        CMP     #%00011001
        BHI     RECM_10         ^* and ^# no meaning
        SUB     #6              otherwise shifted digit
RECM_13 ADD     #%00100000
        STA     TEMP4
        JSR     KEYBEEP

RECM_14 LDX     MACKEYS         Now insert a key into macro
RECM_15 DECX                    Move buffer to make space for this entry
        JSR     READMAC
        INCX
        JSR     WRITMAC
        DECX
        CPX     MACCNT
        BNE     RECM_15
        LDA     TEMP4
        JSR     WRITMAC
        INC     MACCNT
        INC     MACKEYS
        LDA     MACKEYS
        CMP     #96             Macro area full ?
        BNE     RECM_8          If not, next key
        JSR     ALERT           If so, alert and stop
        JMP     MACRO_0

RECM_16 JSR     KEYBEEP         Star mode
        JSR     GETKEY
        CMP     #4
        BEQ     RECM_17
        CMP     #5              ^* * 5 ; end guard tone
        BNE     RECM_10
        JSR     KEYBEEP
        LDA     #%00001111
        STA     TEMP4
        BRA     RECM_14

RECM_17 JSR     KEYBEEP         ^* * 4 ; start guard tone
        JSR     GETKEY
        CMP     #2              guard tones 0-2 allowed
        BHI     RECM_10
        ADD     #%00001100
        STA     TEMP4
        JSR     KEYBEEP
        BRA     RECM_14

RECM_18 JSR     KEYBEEP         ^* # 0-4 are macro pause types
        JSR     GETKEY
        CMP     #3
        BLS     RECM_19
        CMP     #4
        BEQ     RECM_1A
        JMP     RECM_10

RECM_1A LDA     #%00100010      Pauseable mode 4 is %00111110

RECM_19 ADD     #%00011100
        STA     TEMP4
        JSR     KEYBEEP
        BRA     RECM_14

STAR    JSR     KEYBEEP         ^* pressed

        JSR     GETKEY
        CMP     #%00001011      ^* # pressed, program key definition
        BNE     STAR_0
        JMP     PROGKEY
STAR_0  CMP     #%00001010      ^* * pressed, star mode
        BEQ     STARMOD
        CMP     #%00011010
        BNE     STAR_3          ^* ^* pressed, power-down
        JSR     OFFBEEP
POW_OFF JSR     AUDIOFF
        SEI
        LDA     #%10000000      Switch off audio
        STA     PORTC
STAR_1  LDA     #$55            Reset COP timer
        STA     COPR
        LSLA
        STA     COPR
        BIL     STAR_1          Wait for shift to release
        BCLR    3,PORTB         Switch off power upper
        STOP

        BRCLR   5,MODE,STAR_2   If password protection is off, just return
        BSET    3,PORTB         after switching on power again
        CLI
        RTS

STAR_2  JMP     INIT            If password protection is on, init

STAR_3  BHI     STAR_5          ^# means toggle external bit
        BIT     #16             Else mode set
        BEQ     STAR_4          If shifted then substract 6 from keycode
        SUB     #6
STAR_4  JSR     SETMODE         0-9 or ^0-^9 sets mode
        JSR     CFBEEP          And say OK
        RTS

STAR_5  LDA     PORTB           Toggle external bit (hook switch)
        EOR     #%00010000
        STA     PORTB
        RTS

STARMOD JSR     KEYBEEP         The star mode allows the user to program
        JSR     GETKEY          various actions
        CMP     #0
        BNE     STM_0
        JMP     INITDEV         Init device

STM_0   CMP     #1
        BNE     STM_1
        JMP     ENTERFR         Enter a table frequency

STM_1   CMP     #2
        BNE     STM_2
        JMP     ENTERTM         Enter time template

STM_2   CMP     #3
        BNE     STM_3
        JMP     ENTERGD         Enter guard frequency #

STM_3   CMP     #4
        BNE     STM_4
        JMP     STARTGD         Start guard tone

STM_4   CMP     #5
        BNE     STM_5
        JMP     STOPGD          Stop guard tone

STM_5   CMP     #6
        BNE     STM_6
        JMP     FRSWP1          Frequency sweep 1

STM_6   CMP     #7
        BNE     STM_7
        JMP     FRSWP2          Frequency sweep 2

STM_7   CMP     #8
        BNE     STM_8
        JSR     CFBEEP
        BCLR    5,MODE          Password protection on
        JMP     POW_OFF

STM_8   CMP     #9
        BNE     STM_9
        JSR     CFBEEP
        BSET    5,MODE          Password protection off
        JSR     CLRTIME
        RTS

STM_9   CMP     #10
        BNE     STM_10
        JMP     SCAN            Number scanning feature

STM_10  JSR     SITBEEP
        RTS

KEYDEF  JSR     KEYBEEP
        RTS

INITDEV JSR     ALERT           Alert for destructive operation
        JSR     GETKEY          And press # to confirm
        CMP     #11
        BEQ     INITD_0

        JSR     DNTBEEP
        RTS

INITD_0 JSR     CFBEEP

DEVINIT LDA     #11             No aliasing
        STA     MACAL
        LDA     #%11111111      Init all macro entries to %111111 (EOM)
        CLRX
INITD_1 STA     MACROS,X
        INCX
        CPX     #72
        BNE     INITD_1
        LDA     #10             10 Empty macro's right now
        STA     MACKEYS
        LDA     #%10010000      Program 2 RAM modes to blanks
        CLRX
INITD_2 STA     KEYAREA,X
        INCX
        CPX     #44             2*22 keys
        BNE     INITD_2
        STX     MODKEYS         That's the total number of keys in area
        LSRX                    And half of it is offset to user mode 2 (19)
        STX     US2OFS

        LDA     #%11111111
        STA     MACSCAN         No initial scanning

        LDA     #95             Guard 2: 3250Hz
        STA     GUARD+2
        LDA     #92                   1: 3100
        STA     GUARD+1
        LDA     #52                   0: 2280
        STA     GUARD

        DECA                    Init time templates
        CLR     TIMTMPL         Init DTMF/C3/pulse dial mark to 50 ms
        STA     TIMTMPL+1
        CLR     TIMTMPL+2       Init DTMF/C3/pulse dial space to 50 ms
        STA     TIMTMPL+3
        CLR     TIMTMPL+4       Init C5/R2 mark to 50 ms
        STA     TIMTMPL+5
        CLR     TIMTMPL+6       Init C5/R2 space to 50 ms
        STA     TIMTMPL+7
        LDA     #102
        CLR     TIMTMPL+8       Init kp period to 100 ms
        STA     TIMTMPL+9
        LDA     #2
        STA     TIMTMPL+12      Init C3/pulse interdigit period to 500 ms
        CLR     TIMTMPL+13

        CLRA                    Init RAM frequencies
        STA     FREQTBL         Init C3 mark frequency to 2 Hz
        STA     FREQTBL+2       Init C3 space frequency to 1 Hz
        LDA     #16             
        STA     FREQTBL+1
        LSRA
        STA     FREQTBL+3

        RTS

ENTERFR JSR     KEYBEEP
        JSR     READVAL         Read frequency # to program
        TST     VALUE           Only frequency #'s 0-11 are RAM based
        BNE     ENTFR_0
        LDA     VALUE+1
        CMP     #12
        BHS     ENTFR_0
        STA     TEMP3
        JSR     READVAL         Get the frequency in Hz
        LSL     VALUE+1         Multiply by 8 to get internal 'frequency'
        ROL     VALUE
        LSL     VALUE+1
        ROL     VALUE
        LSL     VALUE+1
        ROL     VALUE
        LDX     TEMP3           And store into RAM frequency table
        LSLX
        LDA     VALUE
        STA     FREQTBL,X
        LDA     VALUE+1
        STA     FREQTBL+1,X

        LSRX                    Produce newly programmed frequency 500 ms
        LDA     #250
        JSR     BEEP
        JSR     AUDIOFF
        RTS

ENTFR_0 JSR     SITBEEP
        RTS

ENTERTM JSR     KEYBEEP         Program time template
        JSR     GETKEY          Get time template #
        CMP     #7              Only 0-7 allowed
        BHI     ENTFR_0
        STA     TEMP3
        JSR     KEYBEEP
        JSR     READVAL         Get time
        JSR     CFBEEP2
        LDX     TEMP3
        LSLX
        LDA     VALUE
        STA     TIMTMPL,X
        LDA     VALUE+1
        STA     TIMTMPL+1,X
        RTS

ENTERGD JSR     KEYBEEP         Program guard frequency
        JSR     GETKEY          Get guard #
        CMP     #2              Only 0,1,2 allowed
        BHI     ENTFR_0
        STA     TEMP3
        JSR     KEYBEEP
        JSR     READVAL         Get freq #
        TST     VALUE           0 - MAXFREQ allowed
        BNE     ENTFR_0
        LDA     VALUE+1
        CMP     #MAXFREQ
        BHI     ENTFR_0
        JSR     CFBEEP2
        LDA     VALUE+1         Fixed by willem (this wasn't here)
        LDX     TEMP3
        STA     GUARD,X         Store guard in table
        RTS

STARTGD JSR     KEYBEEP         Start guard tone
        JSR     GETKEY          Get guard #
        CMP     #2              Only 0,1,2 allowed
        BHI     ENTFR_0
        STA     TEMP3
        JSR     KEYBEEP
        LDX     TEMP3
        SEI
        CLR     TIMOUTA         Make sure guard tone sounds
        LDA     JUMPTB3+12      Set guard tone at -6 dB
        STA     TONE3+1
        LDA     JUMPTB3+13
        STA     TONE3+2
        LDX     GUARD,X
        LSLX
        LDA     FREQTBL,X
        LDX     FREQTBL+1,X
        STA     TONE3ST
        STX     TONE3ST+1
        CLI
        BSET    7,GUARD
        JSR     AUDIOFF
        RTS

STOPGD  JSR     KEYBEEP         Stop guard tone
        BCLR    7,GUARD
        SEI
        CLR     TONE3ST
        CLR     TONE3ST+1
        CLR     TONE3CT
        CLR     TONE3CT+1
        CLI
        JSR     AUDIOFF
        RTS

FRSWP1  JSR     KEYBEEP         Frequency sweep 1 (start #  end #  step #)
        JSR     READVAL         Read start frequency

        LDX     VALUE
        LDA     VALUE+1
        LSLA
        ROLX
        LSLA
        ROLX
        LSLA
        ROLX

        STX     TEMP3
        STA     TEMP4

        JSR     READVAL         Read step size

        LDX     VALUE
        LDA     VALUE+1
        LSLA
        ROLX
        LSLA
        ROLX
        LSLA
        ROLX
        STX     VALUE
        STA     VALUE+1

        SEI
        BRSET   7,GUARD,FRSW1_0 Test for guard tone
        LDA     JUMPTB1         Tone 1 at 0 dB
        STA     TONE1+1
        LDA     JUMPTB1+1
        STA     TONE1+2
        BRA     FRSW1_1

FRSW1_0 LDA     JUMPTB1+12      If guard tone, then level 1 at -6 dB
        STA     TONE1+1
        LDA     JUMPTB1+13
        STA     TONE1+2

FRSW1_1 CLI
        CLR     TIMOUTA
FRSW1_2 LDX     TEMP3
        LDA     TEMP4
        STA     TONE1ST+1
        STX     TONE1ST

FRSW1_3 JSR     CLRTIME         Make sure device doesn't turn off during sweep
        JSR     INKEY
        CMP     #$FF
        BEQ     FRSW1_3
        CMP     #11
        BEQ     FRSW1_5
        CMP     #10
        BEQ     FRSW1_4
        CMP     #0
        BNE     FRSW1_3

        LDA     TEMP4
        SUB     VALUE+1
        STA     TEMP4
        LDA     TEMP3
        SBC     VALUE
        STA     TEMP3
        BRA     FRSW1_2

FRSW1_4 LDA     TEMP4
        ADD     VALUE+1
        STA     TEMP4
        LDA     TEMP3
        ADC     VALUE
        STA     TEMP3
        BRA     FRSW1_2

FRSW1_5 JSR     AUDIOFF

FRSW1_6 JSR     INKEY
        CMP     #$FF
        BNE     FRSW1_6

        RTS

FRSWP2  SEI                     Frequency sweep # 2
        CLR     TIMOUTA         Make sure tone is played normally
        CLR     TONE1ST
        CLR     TONE1ST+1

        BRSET   7,GUARD,FRSW2_0 Test for guard tone
        LDA     JUMPTB1         Tone 1 at 0 dB
        STA     TONE1+1
        LDA     JUMPTB1+1
        STA     TONE1+2
        BRA     FRSW2_1

FRSW2_0 LDA     JUMPTB1+12      If guard tone, then level 1 at -6 dB
        STA     TONE1+1
        LDA     JUMPTB1+13
        STA     TONE1+2

FRSW2_1 CLI
FRSW2_2 JSR     CLRTIME         Make sure device doesn't turn off during
        INC     TONE1ST+1       a sweep
        BNE     FRSW2_3
        INC     TONE1ST
FRSW2_3 LDX     #20
FRSW2_4 DECX
        BNE     FRSW2_4
        JSR     CURKEY
        CMP     #11
        BEQ     FRSW2_5
        TST     KEYS
        BEQ     FRSW2_2         
        JSR     GETKEY          If key pressed, then empty keybuffer
        BRA     FRSW2_2

FRSW2_5 JSR     AUDIOFF

FRSW2_6 JSR     INKEY
        CMP     #$FF
        BNE     FRSW2_6
        RTS


SCAN    JSR     KEYBEEP         Number scanning
        JSR     GETKEY          Get macro to play
        CMP     #9              If not 0-9, wrong macro
        BLS     SCAN_1
SCAN_0  JSR     SITBEEP
        RTS
SCAN_1  LSLA
        LSLA
        LSLA
        LSLA
        STA     MACSCAN
        JSR     KEYBEEP
        JSR     GETKEY          Get macro to use for number
        CMP     #9
        BHI     SCAN_0
        ORA     MACSCAN
        STA     MACSCAN

        JSR     KEYBEEP

        JSR     READVAL         Get step size for number scan
        TST     VALUE           Step sizes can be 0-10
        BNE     SCAN_0
        LDA     VALUE+1
        CMP     #10
        BHI     SCAN_0
        STA     MACSCNT
        LDA     MODE            Preserve current mode
        STA     TEMP6
        BSET    6,MODE          Set macro bit

SCAN_2  LDA     TEMP4           This is the first macro
        LSRA
        LSRA
        LSRA
        LSRA
        BRSET   4,MACNEST,SCAN_35       Test for in-macro-mode scanning
        CLR     MACNEST
        BSET    7,MACNEST       Prevent macro pausing in scan mode
        JSR     PLAYMAC
        JSR     AUDIOFF

SCAN_3  JSR     GETKEY          Get *, 0 or #
        CMP     #11             # means end of scan
        BNE     SCAN_4
        JSR     CFBEEP
        LDA     TEMP6           Restore mode
        STA     MODE
SCAN_35 RTS

SCAN_4  CMP     #10             * means scan up
        BEQ     SCAN_5
        TSTA                    0 means scan down
        BEQ     SCAN_5
        JSR     SITBEEP
        BRA     SCAN_3

SCAN_5  STA     TEMP2
        LDA     MACSCAN
        AND     #%00001111
        CLRX
        STA     TEMP3           First find start of this macro
SCAN_6  DEC     TEMP3           This is the one ?
        BMI     SCAN_8
SCAN_7  JSR     READMAC         If not, read macro entry
        INCX                    Update counter for next read
        CMP     #%00111111      Last macro key
        BNE     SCAN_7
        BRA     SCAN_6

SCAN_8  STX     TEMP3           Offset to start of macro

SCAN_9  JSR     READMAC
        INCX
        CMP     #%00111111
        BNE     SCAN_9

        DECX
        DECX                    Offset to last digit of macro
        CPX     TEMP3           Is there at least one digit in this macro ?
        BHS     SCAN_11
SCAN_10 JSR     SITBEEP
        RTS

SCAN_11 LDA     TEMP2           Is it an up- or down-scan (* or 0) ?
        BNE     SCAN_13

        JSR     READMAC         Get last digit of number
        CMP     #9              Make sure it really is a digit
        BHI     SCAN_10

        SUB     MACSCNT         Subtract the counter value
        BMI     SCAN_12         < 0
        JSR     WRITMAC
        BRA     SCAN_2

SCAN_12 ADD     #10
        JSR     WRITMAC
        DECX
        CPX     TEMP3
        BLO     SCAN_2
        JSR     READMAC         Get next number and make sure it is a digit
        CMP     #9
        BHI     SCAN_2
        DECA
        BMI     SCAN_12
        JSR     WRITMAC
        JMP     SCAN_2

SCAN_13 JSR     READMAC         Get last digit of number
        CMP     #9              Make sure it really is a digit
        BHI     SCAN_10

        ADD     MACSCNT         Subtract the counter value
        CMP     #9
        BHI     SCAN_14         > 9
        JSR     WRITMAC
        JMP     SCAN_2

SCAN_14 SUB     #10
        JSR     WRITMAC
        DECX
        CPX     TEMP3
        BHS     SCAN_15
        JMP     SCAN_2
SCAN_15 JSR     READMAC         Get next number and make sure it is a digit
        CMP     #9
        BLS     SCAN_16
        JMP     SCAN_2
SCAN_16 INCA
        CMP     #9
        BHI     SCAN_14
        JSR     WRITMAC
        JMP     SCAN_2

*************************************************************************
*                                                                       *
* PROGKEY       : program a key definition                              *
*                                                                       *
* This routine will program a key definition of one of the two user     *
* modes (18 & 19)                                                       *
*                                                                       *
*************************************************************************

PROGKEY LDA     MODE            Check mode we're in, because only user
        AND     #%00011111      modes 18 and 19 are programmable
        CMP     #18
        BHS     PROG_1

PROG_0  JSR     SITBEEP         If not in user programmable mode, SIT
        RTS

PROG_1  JSR     CFBEEP
        JSR     GETKEY          Get the key to program
        CMP     #%00011001      ^* and ^# not allowed
        BHI     PROG_0

        BIT     #16             Shift pressed ?
        BEQ     PROG_2          Then adjust keycode (0-11 non-shifted,
        SUB     #4              12-21 shifted)

PROG_2  STA     TEMP2           Temporarely store key code
        JSR     KEYBEEP
        CLRX                    If in mode 18, offset into key area is 0
        BRCLR   0,MODE,PROG_3   If in mode 19, offset is US2OFS
        LDX     US2OFS
PROG_3  DEC     TEMP2           Now find key definition so far
        BMI     PROG_8          This is the one already ?

PROG_4  LDA     KEYAREA,X       If not, get the number of bytes needed
        INCX                    for the key at X
        BIT     #%00010000      Time format (0 and 1 mean one extra byte)
        BNE     PROG_5
        INCX

PROG_5  BIT     #%00100000      One tone, then 2 extra bytes
        BNE     PROG_6
        BIT     #%01100000      No tone, then no extra bytes
        BEQ     PROG_7

        INCX                    Else, double tone and 3 extra bytes
PROG_6  INCX
        INCX
PROG_7  BIT     #%10000000      Last tone ?
        BEQ     PROG_4
        BRA     PROG_3

PROG_8  STX     TEMP3           Key found
        STX     MACCNT
        LDA     KEYAREA,X       At this point X holds the offset into
        CMP     #%10010000      the key area, to the current definition
        BEQ     PROG_10         Check if the key is being used
        JSR     ALERT           The key is not empty, so alert user
        JSR     GETKEY          And want # for confirmation
        CMP     #11
        BEQ     PROG_9
        JSR     DNTBEEP
        RTS

PROG_9  JSR     CFBEEP          User confirmed to empty key, so let's do it

PROG_10 LDX     TEMP3
PROG_11 LDA     KEYAREA,X
        INCX
        BIT     #%00010000      Time format (0 and 1 mean one extra byte)
        BNE     PROG_12
        INCX

PROG_12 BIT     #%00100000      One tone, then 2 extra bytes
        BNE     PROG_13
        BIT     #%01100000      No tones, then no extra bytes
        BEQ     PROG_14

        INCX                    Else double tone, 3 extra bytes
PROG_13 INCX
        INCX
PROG_14 BIT     #%10000000      Last tone ?
        BEQ     PROG_11

PROG_15 STX     TEMP4           At this point X points to next key definition

PROG_16 LDA     KEYAREA,X       Now move the key area back to delete old
        LDX     TEMP3           definition
        STA     KEYAREA,X
        INC     TEMP3
        INC     TEMP4
        LDX     TEMP4
        CPX     MODKEYS         Have we done the whole area ?
        BNE     PROG_16

        LDA     TEMP3           Substract the displacement from the total
        SUB     TEMP4           number of keys
        STA     TEMP3
        ADD     MODKEYS
        STA     MODKEYS
        LDA     #%10000000      Indicate this is the first tone
        STA     TEMP5           
        BRSET   0,MODE,PROG_17
        LDA     TEMP3           And if in mode 18 (first user mode) also
        ADD     US2OFS          adjust offset into second mode
        STA     US2OFS

PROG_17 JSR     GETKEY          Get number of tones or # to end programming
        CMP     #11
        BNE     PROG_18
        JMP     PROG_70

PROG_18 CMP     #2              If number of tones > 2 then mistake
        BLS     PROG_19
        JSR     SITBEEP         And try again
        BRA     PROG_17

PROG_19 STA     TEMP3           Store # of tones
        JSR     KEYBEEP
PROG_20 JSR     GETKEY          Get time type
        CMP     #3
        BLS     PROG_21         Only tones 0,1,2 and 3 are allowed
        JSR     SITBEEP         If invalid type then try again
        BRA     PROG_20

PROG_21 STA     TEMP4
        JSR     KEYBEEP
        LDA     #1              Always one byte needed
        LDX     TEMP3           Now check if the number of bytes needed for
        BEQ     PROG_23         this tone is available in RAM
        CPX     #1              If 0 tones, no bytes needed for tone info
        BEQ     PROG_22         If 1 tone, 2 extra bytes
        INCA                    If 2 tones, 3 extra bytes
PROG_22 ADD     #2

PROG_23 LDX     TEMP4           Get the time format
        CPX     #2
        BHS     PROG_24         If template time, then no extra bytes
        INCA                    else one extra for # of ms

PROG_24 STA     TEMP4
        ADD     MODKEYS
        CMP     #MAXKEYS        Still enough room ?
        BLS     PRG_240

        JMP     PROG_69         If not, sound mistake bell and exit

PRG_240 STA     MODKEYS         Adjust number of key entries

        BRSET   0,MODE,PROG_25
        LDA     TEMP4           And if in mode 18 (first user mode) also
        ADD     US2OFS          adjust offset into second mode
        STA     US2OFS

PROG_25 LSLX                    Shift time template in proper bit position
        LSLX
        LSLX
        STX     TEMP5

        LDA     TEMP3           Shift # tones into position
        LSRA                    0000 000x (x)
        RORA                    x000 0000 (x)
        RORA                    xx00 0000 (0)
        LSRA                    0xx0 0000
        ORA     TEMP5           Or the time template and # of tones
        STA     TEMP3

        LDA     MODKEYS
        STA     TEMP5
        SUB     TEMP4
        STA     TEMP4

PROG_26 DEC     TEMP4           Now move the key area to make room for new
        DEC     TEMP5           definition
        LDX     TEMP4
        LDA     KEYAREA,X
        LDX     TEMP5
        STA     KEYAREA,X
        LDA     TEMP4
        CMP     MACCNT
        BNE     PROG_26

PROG_27 JSR     READVAL         Get time in ms or time template #
        BRSET   4,TEMP3,PROG_29 Is it a template time or ms
        LDA     VALUE           If in ms, range is 0-2047
        CMP     #7              Range valid ?
        BHI     PROG_28
        LDX     VALUE+1
        STX     TEMP4
        BRA     PROG_30

PROG_28 JSR     SITBEEP         If out of range, sound mistake beep
        BRA     PROG_27         And let user try again

PROG_29 LDA     VALUE           If time template, then range is 0-7
        BNE     PROG_28
        LDA     VALUE+1         Out of range ?
        CMP     #7
        BHI     PROG_28         Try again

PROG_30 ORA     TEMP3           OR template time or 3 MSB of time into word
        LDX     MACCNT
        STX     TEMP5           Preserve the offset to this tone in TEMP5
        STA     KEYAREA,X
        INC     MACCNT
        BRSET   4,TEMP3,PROG_31 If the time is in ms, then store low 8 bits
        LDA     TEMP4
        STA     KEYAREA+1,X
        INC     MACCNT

PROG_31 LDA     TEMP3           Now check the number of tones to read
        AND     #%01100000
        BEQ     PROG_44         Silence, then ready, get next tone definition
PROG_32 JSR     READVAL         Else get dB level of first tone
        LDA     VALUE
        BEQ     PROG_34         dB level should be between 0 and 15

PROG_33 JSR     SITBEEP
        BRA     PROG_32

PROG_34 LDA     VALUE+1
        CMP     #15
        BHI     PROG_33

        LDX     MACCNT
        LSLA
        LSLA
        LSLA
        LSLA
        STA     KEYAREA,X

PROG_35 JSR     READVAL         Get freq # for this tone
        LDA     VALUE           freq # should be between 0 and MAXFREQS
        BEQ     PROG_37

PROG_36 JSR     SITBEEP
        BRA     PROG_35

PROG_37 LDA     VALUE+1
        CMP     #MAXFREQ
        BHI     PROG_36

        LDX     MACCNT
        STA     KEYAREA+1,X     Store frequency #

        BRSET   6,TEMP3,PROG_38 Two tones, then read next
        INC     MACCNT          One tone means two bytes needed
        INC     MACCNT
        BRA     PROG_44

PROG_38 JSR     READVAL         Get dB level of second tone
        LDA     VALUE
        BEQ     PROG_40         db level should be between 0 and 15

PROG_39 JSR     SITBEEP
        BRA     PROG_38

PROG_40 LDA     VALUE+1
        CMP     #15
        BHI     PROG_39

        LDX     MACCNT
        ORA     KEYAREA,X
        STA     KEYAREA,X

PROG_41 JSR     READVAL         Get freq # for this tone
        LDA     VALUE           freq # should be between 0 and MAXFREQS
        BEQ     PROG_43

PROG_42 JSR     SITBEEP
        BRA     PROG_41

PROG_43 LDA     VALUE+1
        CMP     #MAXFREQ
        BHI     PROG_42

        LDX     MACCNT
        STA     KEYAREA+2,X     Store frequency #
        INCX                    Two tones mean 3 bytes needed
        INCX
        INCX
        STX     MACCNT

PROG_44 JSR     CFBEEP          Sound confirmation to indicate key programmed
        JMP     PROG_17         Get next tone (or # for end)

PROG_69 JSR     SITBEEP         End of key programming because of memory
        BRA     PROG_71         problems
PROG_70 JSR     CFBEEP          End of key programming, user pressed #
PROG_71 BRSET   7,TEMP5,PROG_72 Check if we already had a key
        LDX     TEMP5           If not, TEMP5 holds offset to start of last
        LDA     KEYAREA,X       tone
        ORA     #%10000000
        STA     KEYAREA,X
        RTS

PROG_72 LDX     MODKEYS
PROG_73 DECX
        LDA     KEYAREA,X
        INCX
        STA     KEYAREA,X
        DECX
        CPX     MACCNT
        BNE     PROG_73
        LDA     #%10010000
        STA     KEYAREA,X
        INC     MODKEYS
        BRSET   0,MODE,PROG_74
        INC     US2OFS
PROG_74 RTS

*************************************************************************
*                                                                       *
* PLAYKEY       : Plays key in current mode                             *
*                                                                       *
* On entry      : A = key                                               *
*                                                                       *
* A should be in the key format : 000s kkkk                             *
*                                                                       *
*************************************************************************

PLAYKEY BIT     #16             If shift key is pressed then
        BEQ     PLK_0           substract 4 of keycode, to let codes
        SUB     #4              16-25 become 12-21
PLK_0   STA     TEMP1
        LDA     MODE
        AND     #%00011111      Get current mode
        CMP     #18             Is it a ROM or RAM mode
        BLO     PLK_2
        BNE     PLK_1
        LDA     #KEYAREA        Mode 18 = User mode 1
        STA     LOC+1
        CLR     LOC             It is a RAM mode, so zero-page table
        CLRX
        BRA     PLK_3
PLK_1   LDA     #KEYAREA        Mode 19 = User mode 2
        ADD     US2OFS
        STA     LOC+1
        CLR     LOC             It is a RAM mode, so zero-page table
        CLRX
        BRA     PLK_3
PLK_2   CMP     #1              Is it special mode 1 (ATF1)
        BNE     PLK_200
        JMP     PLKATF1         Then play key special way
PLK_200 TAX                     It's a ROM mode, so get base offset
        LSLX
        LDA     ROMMDS,X
        STA     LOC
        LDA     ROMMDS+1,X
        STA     LOC+1           LOC now contains base of mode, now find key
        CLRX
PLK_3   DEC     TEMP1           Is this our key ?
        BMI     PLK_11          Then LOC +x is base of key
PLK_4   JSR     GETBYTE         Get byte from effective address LOC points to

        INCX                    Increment X for next read
        BNE     PLK_5
        INC     LOC

PLK_5   BIT     #%00010000      Test time format (0,1 means 1 extra byte)
        BNE     PLK_6
        INCX
        BNE     PLK_6
        INC     LOC

PLK_6   BIT     #%01000000      Two tones ? Then 3 extra bytes
        BNE     PLK_7
        BIT     #%00100000      One tone ? Then 2 extra byte
        BNE     PLK_8
        BIT     #%10000000      Last tone ?
        BEQ     PLK_4
        BRA     PLK_3
PLK_7   INCX
        BNE     PLK_8
        INC     LOC
PLK_8   INCX
        BNE     PLK_9
        INC     LOC
PLK_9   INCX
        BNE     PLK_10
        INC     LOC
PLK_10  BIT     #%10000000      Last tone ?
        BEQ     PLK_4
        BRA     PLK_3

PLK_11  TXA                     At this point the position (LOC) + x is base
        ADD     LOC+1
        STA     LOC+1
        BCC     PLK_12
        INC     LOC             Now LOC -> base of key

PLK_12  CLRX

PLK_13  JSR     GETBYTE
        STA     TEMP1
        AND     #%00011000
        BEQ     PLK_16          Fixed time tone

        CMP     #%00010000
        BEQ     PLK_15          Template time
        BHI     PLK_14
        BRSET   6,MODE,PLK_16   Play while pressed or fixed time in macro
        INCX                    If not in macro, just skip time
        BRA PLK_18

PLK_14  BRSET   6,MODE,PLK_15   Play while pressed or template time in macro
        BRA     PLK_18

PLK_15  STX     TEMP2           Template time, so get index into time
        LDA     TEMP1           template table
        AND     #%00000111
        TAX
        LSLX
        LDA     TIMTMPL,X       Get value in 1/1024 secs from time template
        NEGA
        SEI
        STA     TICKER
        LDA     TIMTMPL+1,X
        LDX     TEMP2
        BRA     PLK_17          And let fixed time routine finish the job

PLK_16  INCX                    Play fixed time, so get time in 1/1024 secs
        LDA     TEMP1
        AND     #%111           3 high bits in first key byte
        NEGA                    Negate, because we use an up counter to 0
        SEI
        STA     TICKER
        JSR     GETBYTE         Get lower 8 bits
PLK_17  NEGA
        STA     TICKER+1
        BCC     PLK_170
        DEC     TICKER
PLK_170 LSL     TICKER+1        Convert to 1/8192 sec (= *8)
        ROL     TICKER
        LSL     TICKER+1
        ROL     TICKER
        LSL     TICKER+1
        ROL     TICKER
        CLI
PLK_18  BSET    7,NEXTSTR       Set strobe bit for timing
        LDA     TEMP1
        AND     #%01100000      Now get # of tones
        BNE     PLK_20          No tones, no music
        SEI
        CLR     TONE1ST
        CLR     TONE1ST+1
        CLR     TONE1CT
        CLR     TONE1CT+1
        CLI
        STX     TEMP2
        LDA     TEMP1           Special case, silence on template 0 =
        AND     #%00011111      0 ms of silence
        CMP     #%00010000
        BNE     PLK_19
        JMP     PLK_26
PLK_19  JMP     PLK_23
PLK_20  INCX                    If tones, get dB levels
        JSR     GETBYTE
        STX     TEMP2
        BRCLR   7,GUARD,PLK_22  If guard tone is playing, calculate tone
        LDA     TEMP1           levels
        AND     #%01100000      If one tone is playing, guard and tone at -6 dB
        CMP     #%00100000
        BNE     PLK_21
        SEI
        LDA     JUMPTB3+12      -6 dB
        STA     TONE3+1
        LDA     JUMPTB3+13
        STA     TONE3+2
        CLI
        LDA     #$66            -6 dB
        BRA     PLK_22
PLK_21  SEI                     Two tones, play guard and 2 tones at -10 dB
        LDA     JUMPTB3+20      -10 dB
        STA     TONE3+1
        LDA     JUMPTB3+21
        STA     TONE3+2
        CLI
        LDA     #$AA            -10 dB
PLK_22  STA     TEMP3
        AND     #%11110000      dB level tone A
        TAX
        LSRX
        LSRX
        LSRX
        LDA     JUMPTB1,X
        LDX     JUMPTB1+1,X
        SEI
        STA     TONE1+1
        STX     TONE1+2
        CLI
        LDA     TEMP3
        AND     #%00001111      dB level tone B
        TAX
        LSLX
        LDA     JUMPTB2,X
        LDX     JUMPTB2+1,X
        SEI
        STA     TONE2+1
        STX     TONE2+2
        CLI
        INC     TEMP2           Now, get tone A
        LDX     TEMP2
        JSR     GETBYTE
        TAX
        LSLX
        LDA     FREQTBL,X
        LDX     FREQTBL+1,X
        TSTA
        BNE     PLK_222         Test if it's 1 or 2 Hz (off/on hook)
        CPX     #8
        BNE     PLK_220
        BSET    4,PORTB
        BRA     PLK_221
PLK_220 CPX     #16
        BNE     PLK_222
        BCLR    4,PORTB
PLK_221 SEI
        CLR     TONE1ST
        CLR     TONE1ST+1
        BRA     PLK_223
PLK_222 SEI
        STA     TONE1ST
        STX     TONE1ST+1
PLK_223 CLI
        BRCLR   6,TEMP1,PLK_23   Check if there are 1 or 2 tones here
        INC     TEMP2           Now, get tone B
        LDX     TEMP2
        JSR     GETBYTE
        TAX
        LSLX
        LDA     FREQTBL,X
        LDX     FREQTBL+1,X
        SEI
        STA     TONE2ST
        STX     TONE2ST+1
        CLI
        BRA     PLK_24
PLK_23  SEI                     If 1 tone, make sure tone 2 is DC at 0 V
        CLR     TONE2ST
        CLR     TONE2ST+1
        CLR     TONE2CT
        CLR     TONE2CT+1
        CLI
PLK_24  LDA     TEMP1
        AND     #%00011000
        BEQ     PLK_25          Fixed time
        CMP     #%00010000
        BEQ     PLK_25          Template time
        BRCLR   6,MODE,PLK_27
PLK_25  BRSET   7,NEXTSTR,PLK_25        Play as long as strobe is set
PLK_26  BRSET   7,TEMP1,PLK_28   Last tone of this key ?
        LDX     TEMP2
        INCX
        JMP     PLK_13

PLK_27  JSR     CLRTIME         Make sure thingy doesn't die
        JSR     CURKEY
        CMP     #$FF
        BNE     PLK_27
        BRA     PLK_26

PLK_28  RTS                     Mind that at return, tone is still playing

PLKATF1 LDA     TEMP1           Plays an ATF1 key. ATF1 and C3 are somewhat
        CMP     #12             different than 'normal' mode
        BLS     PLATF_0         Only 0-9, *, # and ^0 are allowed
        JSR     SITBEEP
        RTS
PLATF_0 LSLA                    Get offset into ATF1 table
        TAX                     And get bit pattern of message to send
        LDA     ATF1TBL,X
        STA     TEMP2
        LDA     ATF1TBL+1,X
        STA     TEMP3
        LDA     #16             We are going to send 16 bits
        STA     TEMP4
        SEI
        CLR     TONE2CT+1       Single tone, so tone 2 shut up
        CLR     TONE2CT
        CLR     TONE2ST+1
        CLR     TONE2ST
        BRCLR   7,GUARD,PLATF_1 If guard tone is playing, set level at -6 dB
        LDA     JUMPTB3+12
        STA     TONE3+1
        LDA     JUMPTB3+13
        STA     TONE3+2
PLATF_1 LDA     JUMPTB1+12
        STA     TONE1+1
        LDA     JUMPTB1+13
        STA     TONE1+2
        LDA     TEMP1
        CMP     #10             * pressed, then special case, send preamble
        BNE     PLATF_3
        LDA     #236            600 ms preamble
        STA     TICKER
        LDA     #205
        STA     TICKER+1
        LDX     #ATF1_HI/256
        LDA     #ATF1_HI
        STX     TONE1ST
        STA     TONE1ST+1
        CLI
        BSET    7,NEXTSTR
PLATF_2 BRSET   7,NEXTSTR,PLATF_2       Play as long as strobe is set

PLATF_3 SEI
        LDA     #$FF            Program bit period to 10 ms
        STA     TICKER
        LDA     #$AF
        STA     TICKER+1
        CLI
        LSL     TEMP3
        ROL     TEMP2
        BCC     PLATF_4
        LDX     #ATF1_HI/256
        LDA     #ATF1_HI
        BRA     PLATF_5
PLATF_4 LDX     #ATF1_LO/256
        LDA     #ATF1_LO
PLATF_5 SEI
        STX     TONE1ST
        STA     TONE1ST+1
        CLI
        BSET    7,NEXTSTR
PLATF_6 BRSET   7,NEXTSTR,PLATF_6       Play as long as strobe is set
        DEC     TEMP4
        BNE     PLATF_3
        RTS

ATF1TBL FCB     %01110110,%00000011            0
        FCB     %01110101,%00000101            1
        FCB     %01110100,%10001001            2
        FCB     %01110100,%01010001            3
        FCB     %01110011,%00000110            4
        FCB     %01110010,%10001010            5
        FCB     %01110010,%01010010            6
        FCB     %01110001,%10001100            7
        FCB     %01110001,%01010100            8
        FCB     %01110000,%11011000            9
        FCB     %01110010,%00100010            * - Start
        FCB     %01110100,%00100001            # - Stop
        FCB     %01110101,%01010101            ^0 - Cancel

*************************************************************************
*                                                                       *
* SETMODE       : Set current mode                                      *
*                                                                       *
* On entry      :   A = mode #                                          *
*                                                                       *
*************************************************************************


SETMODE STA     TEMP1
        LDA     MODE
        AND     #%11100000
        ORA     TEMP1
        STA     MODE
        RTS

*************************************************************************
*                                                                       *
* INKEY         : gets a key from the keyboard buffer                   *
*                                                                       *
* On entry      :   -----                                               *
* On exit       :   A = $FF     : keyboard buffer empty                 *
*                   otherwise   : A = keycode                           *
*                                                                       *
*************************************************************************

INKEY   SEI                     Disable interrupts to prevent keyboard
        LDX     KEYS            buffer status to be changed within this
        BEQ     INK_1           function
        LDA     KEYBUF          Get key code at top of keyboard buffer
        STA     TEMP1           And shift all other keyboard entries
        CLRX                    one to the top
INK_0   LDA     KEYBUF+1,X
        STA     KEYBUF,X
        INCX
        CPX     KEYS
        BNE     INK_0
        DEC     KEYS
        LDA     TEMP1
        CLI                     Enable interrupts again
        RTS

INK_1   LDA     #$FF            No keys in buffer, then return $FF
        CLI
        RTS

*************************************************************************
*                                                                       *
* GETKEY         : waits for a key to be pressed and returns key code   *
*                                                                       *
* On entry      :   -----                                               *
* On exit       :   A = keycode                                         *
*                                                                       *
*************************************************************************

GETKEY  JSR     INKEY           Get key from keyboard buffer
        CMP     #$FF            If buffer empty, wait
        BEQ     GETKEY
        RTS

*************************************************************************
*                                                                       *
* CURKEY        : returns key code of key currently pressed (or serial) *
*                                                                       *
* On entry      :   -----                                               *
* On exit       :   A = $FF     : no key pressed at the moment          *
*                   otherwise   : A = keycode                           *
*                                                                       *
*************************************************************************

CURKEY  BRCLR   6,KEYSTAT,CURK_0

        LDA     KEYSTAT
        AND     #%00011111
        RTS

CURK_0  BRCLR   6,SERSTAT,CURK_1
        LDA     SERSTAT
        AND     #%00011111
        RTS

CURK_1  LDA     #$FF
        RTS

*************************************************************************
*                                                                       *
* READMAC       : gets a 6-bit entry from the macro area                *
*                                                                       *
* On entry      :   X = entry #                                         *
* On exit       :   A = entry, X is preserved                           *
*                                                                       *
*************************************************************************

READMAC STX     TEMP1           Find the byte(s) the 6-bit entry will be in
        TXA
        LSLA
        ADD     TEMP1           A*3
        TAX
        RORX                    X will point to the first byte (maybe the only)
        LSRX                    that holds the 6-bit entry
        LSLA
        AND     #6              A will now hold the number of right shifts
        CMP     #2
        BLO     READM_0         No right shifts are needed
        BEQ     READM_1         2 right shifts are needed
        CMP     #4
        BEQ     READM_2         4 right shifts are needed

        LDA     MACROS+1,X      Else 6 right shifts are needed (2 left shifts)
        LDX     MACROS,X        X -> kkxx xxxx = X 
        LSLX                         xxxx kkkk = A 
        ROLA
        LSLX
        ROLA
        AND     #%00111111
        LDX     TEMP1
        RTS

READM_0 LDA     MACROS,X        X -> xxkk kkkk = A
        AND     #%00111111           xxxx xxxx
        LDX     TEMP1
        RTS

READM_1 LDA     MACROS,X        X -> kkkk kkxx = A
        LSRA                         xxxx xxxx
        LSRA
        LDX     TEMP1
        RTS

READM_2 LDA     MACROS,X        X -> kkkk xxxx = A
        LDX     MACROS+1,X           xxxx xxkk = X
        LSRX
        RORA
        LSRX
        RORA
        LSRA
        LSRA
        LDX     TEMP1
        RTS

*************************************************************************
*                                                                       *
* WRITMAC       : write a 6-bit entry into the macro area               *
*                                                                       *
* On entry      :   A = entry                                           *
*                   X = entry #                                         *
* On exit       :   X is preserved                                      *
*                                                                       *
*************************************************************************

WRITMAC STA     TEMP1           Find the byte(s) the 6-bit entry will be in
        STX     TEMP2
        TXA
        LSLA
        ADD     TEMP2           A*3 (Note that the carry bit is used)
        TAX
        RORX                    X will point to the first byte (maybe the only)
        LSRX                    that holds the 6-bit entry
        LSLA
        AND     #6              A will now hold the number of left shifts
        CMP     #2
        BLO     WRITM_0         No left shifts are needed
        BEQ     WRITM_1         2 left shifts are needed
        CMP     #4
        BEQ     WRITM_2         4 left shifts are needed

        LDA     TEMP1           X -> kkxx xxxx
        STA     VALUE+1              xxxx kkkk
        CLR     VALUE
        LSR     VALUE+1
        ROR     VALUE
        LSR     VALUE+1
        ROR     VALUE
        LDA     MACROS,X
        AND     #%00111111
        ORA     VALUE
        STA     MACROS,X
        LDA     MACROS+1,X
        AND     #%11110000
        ORA     VALUE+1
        STA     MACROS+1,X
        LDX     TEMP2
        RTS

WRITM_0 LDA     MACROS,X        X -> xxkk kkkk
        AND     #%11000000           xxxx xxxx
        ORA     TEMP1
        STA     MACROS,X
        LDX     TEMP2
        RTS

WRITM_1 LDA     MACROS,X        X -> kkkk kkxx
        AND     #%00000011           xxxx xxxx
        LSL     TEMP1
        LSL     TEMP1
        ORA     TEMP1
        STA     MACROS,X
        LDX     TEMP2
        RTS

WRITM_2 LDA     TEMP1           X -> kkkk xxxx
        STA     VALUE                xxxx xxkk
        CLR     VALUE+1
        LSL     VALUE
        ROL     VALUE+1
        LSL     VALUE
        ROL     VALUE+1
        LSL     VALUE
        ROL     VALUE+1
        LSL     VALUE
        ROL     VALUE+1
        LDA     MACROS,X
        AND     #%00001111
        ORA     VALUE
        STA     MACROS,X
        LDA     MACROS+1,X
        AND     #%11111100
        ORA     VALUE+1
        STA     MACROS+1,X
        LDX     TEMP2
        RTS

*************************************************************************
*                                                                       *
* READVAL       : read a value from keyboard                            *
*                                                                       *
* On entry      :   ----                                                *
* On exit       :   Two byte value in RAM locations VALUE and VALUE+1   *
*                                                                       *
*************************************************************************

READVAL CLR     VALUE           On init no value
        CLR     VALUE+1

READV_0 JSR     GETKEY          We are only interested in keys 0-9 and #

        STA     TEMP2
        JSR     KEYBEEP
        LDA     TEMP2

        CMP     #11             Skip shifted keys
        BHI     READV_0

        CMP     #10             Skip *'s
        BEQ     READV_0
        BLO     READV_1         digit pressed
        RTS                     Else # pressed and ready

READV_1 LSL     VALUE+1         First multiply value so far by 10
        ROL     VALUE           First by 2
        LDA     VALUE+1
        LDX     VALUE
        LSLA                    Then by 4 (=*8)
        ROLX
        LSLA
        ROLX
        ADD     VALUE+1         Add these two (x*2 + x*8 = x*10)
        STA     VALUE+1
        TXA
        ADC     VALUE
        STA     VALUE
        LDA     TEMP2           And finally add our new digit
        ADD     VALUE+1
        STA     VALUE+1
        BCC     READV_0
        LDA     VALUE
        ADD     #1
        STA     VALUE
        BHS     READV_0
        JSR     SITBEEP         Higher than 65535
        BRA     READVAL

*************************************************************************
*                                                                       *
* OFFBEEP       : makes sound for power-off                             *
*                                                                       *
*************************************************************************

OFFBEEP SEI
        LDA     #64
        STA     TONE1ST
        CLR     TONE1ST+1

        LDA     JUMPTB1         Tone 1 at 0 dB
        STA     TONE1+1
        LDA     JUMPTB1+1
        STA     TONE1+2
        CLR     TONE3ST         No guard during power-down
        CLR     TONE3ST+1
        CLR     TONE3CT
        CLR     TONE3CT+1

        CLI
OFFB_0  DEC     TONE1ST+1
        LDA     TONE1ST+1
        CMP     #$FF
        BNE     OFFB_0
        DEC     TONE1ST
        BPL     OFFB_0
        RTS

*************************************************************************
*                                                                       *
* ONBEEP       : makes sound for power-on                               *
*                                                                       *
*************************************************************************

ONBEEP  SEI
        CLR     TONE1ST
        CLR     TONE1ST+1

        LDA     JUMPTB1         Tone 1 at 0 dB
        STA     TONE1+1
        LDA     JUMPTB1+1
        STA     TONE1+2

        CLI

ONB_0   INC     TONE1ST+1
        BNE     ONB_0
        INC     TONE1ST
        LDA     TONE1ST
        CMP     #64
        BNE     ONB_0
        JSR     AUDIOFF
        RTS


*************************************************************************
*                                                                       *
* SITBEEP       : makes SIT sound                                       *
*                                                                       *
*************************************************************************

SITBEEP LDA     #150            ñ 300 ms
        LDX     #67             SIT first tone
        JSR     BEEP
        LDA     #150
        LDX     #68             SIT second tone
        JSR     BEEP
        LDA     #150
        LDX     #69             SIT third tone
        BRA     ENDBEEP

*************************************************************************
*                                                                       *
* ALERT         : produces alert tone                                   *
*                                                                       *
*************************************************************************

ALERT   LDA     #25             ñ 50 ms
        LDX     #75             2000 Hz
        JSR     BEEP
        LDA     #25             ñ 50 ms
        LDX     #74             0 Hz (silence)
        JSR     BEEP

        LDA     #25             ñ 50 ms
        LDX     #75             2000 Hz
        JSR     BEEP
        LDA     #25             ñ 50 ms
        LDX     #74             0 Hz (silence)
        JSR     BEEP

        LDA     #25             ñ 50 ms
        LDX     #75             2000 Hz
        JSR     BEEP
        LDA     #25             ñ 50 ms
        LDX     #74             0 Hz (silence)
        JSR     BEEP
*************************************************************************
* KEYBEEP       : makes 2000 Hz, 50 ms beep for key-press feedback      *
*************************************************************************
KEYBEEP LDA     #25             ñ 50 ms
        LDX     #75             2000 Hz
        BRA     ENDBEEP

*************************************************************************
*                                                                       *
* EMMBEEP       : make beep for entering macro mode                     *
*                                                                       *
*************************************************************************

EMMBEEP LDA     #75             ñ 150 ms
        LDX     #69             SIT third tone
        JSR     BEEP
        LDA     #75
        LDX     #67             SIT first tone

ENDBEEP JSR     BEEP
        JSR     AUDIOFF
        RTS


*************************************************************************
*                                                                       *
* XMMBEEP       : make beep for exiting macro mode                      *
*                                                                       *
*************************************************************************

XMMBEEP LDA     #75             ñ 150 ms
        LDX     #67             SIT first tone
        JSR     BEEP
        LDA     #75
        LDX     #69             SIT third tone
        BRA     ENDBEEP

*************************************************************************
*                                                                       *
* PASBEEP       : produces password beep                                *
*                                                                       *
*************************************************************************

PASBEEP LDA     #25
        LDX     #22
        JSR     BEEP
        LDA     #25
        LDX     #74
        JSR     BEEP

        LDA     #25
        LDX     #22
        JSR     BEEP
        LDA     #25
        LDX     #74
        JSR     BEEP

        LDA     #25
        LDX     #22
        JSR     BEEP
        LDA     #25
        LDX     #74
        JSR     BEEP

        LDA     #50
        LDX     #25
        JSR     BEEP
        LDA     #50
        LDX     #74
        JSR     BEEP

        LDA     #25
        LDX     #22
        JSR     BEEP
        LDA     #25
        LDX     #74
        JSR     BEEP

        LDA     #100
        LDX     #25
        BRA     ENDBEEP

*************************************************************************
*                                                                       *
* DNTBEEP       : make beep for not-confirming destructive action(don't)*
*                                                                       *
*************************************************************************

DNTBEEP LDA     #125
        LDX     #67             SIT first tone
        BRA     ENDBEEP

*************************************************************************
*                                                                       *
* CFBEEP        : make beep for confirming destructive action           *
*                                                                       *
*************************************************************************

CFBEEP  LDA     #25             ñ 50 ms
        LDX     #75             2000 Hz
        JSR     BEEP
CFBEEP2 LDA     #25             ñ 50 ms
        LDX     #74             0 Hz (silence)
        JSR     BEEP

        LDA     #50             ñ 100 ms
        LDX     #75             2000 Hz
        BRA     ENDBEEP



*************************************************************************
*                                                                       *
* BEEP          : makes single tone sound                               *
*                                                                       *
* On entry      :   A = time in 16 cycles (of 1/8192 sec)               *
*                   X = frequency #                                     *
*                                                                       *
* This routine will make a single tone during A*16 cycles at 0 dB. The  *
* routine uses channel 1 to produce the tone. If the other two channels *
* are also in use, overflow will occur. If a guard tone is produced,    *
* the level will be -6 dB for both beep and guard tone.                 *
*                                                                       *
*************************************************************************

BEEP    SEI
        STA     TEMP1
        LSLX                    Get proper offset in table
        LDA     FREQTBL,X       Get frequency
        STA     TONE1ST
        LDA     FREQTBL+1,X
        STA     TONE1ST+1

        BRSET   7,GUARD,BEEP_0  Test for guard tone
        LDA     JUMPTB1         Tone 1 at 0 dB
        STA     TONE1+1
        LDA     JUMPTB1+1
        STA     TONE1+2
        BRA     BEEP_1

BEEP_0  LDA     JUMPTB1+12      If guard tone, then level beep at -6 dB
        STA     TONE1+1
        LDA     JUMPTB1+13
        STA     TONE1+2

BEEP_1  LDA     TEMP1           Multiply by 16 to get # cycles
        CLRX
        LSLA
        ROLX
        LSLA
        ROLX
        LSLA
        ROLX
        LSLA
        ROLX

        NEGX                    Negate value, since ticker counts up
        STX     TICKER          to 0
        NEGA
        STA     TICKER+1
        BCC     BEEP_2
        DEC     TICKER
BEEP_2  BSET    7,NEXTSTR       Set strobe to detect end of tone
        CLI

BEEP_3  BRSET   7,NEXTSTR,BEEP_3        Wait till tone is over
        RTS

*************************************************************************
*                                                                       *
* AUDIOFF       : turns off all audio, except when guard tone is on     *
*                                                                       *
*************************************************************************

AUDIOFF SEI
        BRSET   7,GUARD,AUDIO_0 If guard tone then don't shut down audio
        BRSET   5,MACNEST,AUDIO_1       Don't set timeout for paused macro
        LDA     #16             Switch off after 2 seconds
        STA     TIMOUTA
        BRA     AUDIO_1
AUDIO_0 LDA     JUMPTB1
        STA     TONE1+1
        LDA     JUMPTB1+1
        STA     TONE1+2
        LDA     JUMPTB3+12      Guard tone at -6 dB
        STA     TONE3+1
        LDA     JUMPTB3+13
        STA     TONE3+2
AUDIO_1 CLR     TONE1ST
        CLR     TONE1ST+1
        CLR     TONE1CT
        CLR     TONE1CT+1
        CLR     TONE2ST
        CLR     TONE2ST+1
        CLR     TONE2CT
        CLR     TONE2CT+1
        CLI
        RTS

*************************************************************************
*                                                                       *
* CLRTIME       : clears time out period                                *
*                                                                       *
*************************************************************************

CLRTIME CLR     TIMEOUT
        RTS

*************************************************************************
*                                                                       *
*
* TX            : Send a byte                                           *
*                                                                       *
*************************************************************************

TX      BRCLR   7,SCSR,TX       Wait until Transmit Data Register is empty
        STA     SCDAT
        RTS

*************************************************************************
*                                                                       *
* RX            : Receive a byte                                        *
*                                                                       *
*************************************************************************

RX      BRCLR   5,SCSR,RX       Wait until byte is received
        LDA     SCDAT
        RTS

* Dummy interrupt, does nothing but return right away

DUMINT  RTI

*************************************************************************
*                                                                       *
* INTSER        : serial interrupt routine                              *
*                                                                       *
* This routine gets a byte from the serial port and places it in the    *
* keyboard buffer                                                       *
*                                                                       *
*************************************************************************

INTSER  JSR     CLRTIME
        LDA     SCSR            Clear interrupt
        LDA     SCDAT
        CMP     #'U'            U means upload RAM contents
        BNE     INTS_10
        BRCLR   7,MODE,ATY_3
        LDA     MODE            Send mode word
        JSR     TX
        LDA     MACKEYS         Send # of macro keys
        JSR     TX
        LDA     US2OFS          Send offset into user mode 2 (mode 19)
        JSR     TX
        LDA     MODKEYS         Send # bytes in key area
        JSR     TX
        CLRX
ATY_0   LDA     GUARD,X         Send guard and time template info
        JSR     TX
        INCX
        CPX     #19
        BNE     ATY_0
        CLRX
ATY_1   LDA     KEYAREA,X       Send all key definitions
        JSR     TX
        INCX
        CPX     #100
        BNE     ATY_1
        CLRX
ATY_2   LDA     MACROS,X        Send macro and frequeny table
        JSR     TX
        INCX
        CPX     #96
        BNE     ATY_2
ATY_3   RTI

INTS_10 CMP     #'D'
        BNE     INTS_15
        BRCLR   7,MODE,ATY_13
        JSR     RX
        STA     MODE            Set mode word
        JSR     RX
        STA     MACKEYS         Set # of macro keys
        JSR     RX
        STA     US2OFS          Set offset into user mode 2 (mode 19)
        JSR     RX
        STA     MODKEYS         Set # of bytes in key area
        CLRX
ATY_10  JSR     RX
        STA     GUARD,X         Set guard and time template info
        INCX
        CPX     #19
        BNE     ATY_10
        CLRX
ATY_11  JSR     RX
        STA     KEYAREA,X       Set all key definitions
        INCX
        CPX     #100
        BNE     ATY_11
        CLRX
ATY_12  JSR     RX
        STA     MACROS,X        Set macro and frequeny table
        INCX
        CPX     #96
        BNE     ATY_12
ATY_13  RTI

INTS_15 CMP     #'P'
        BNE     INTS_20
        BRCLR   7,MODE,INTS_17
        LDA     VERSION
        JSR     TX
        LDA     PASDIGS
        JSR     TX
        CLRX
INTS_16 LDA     PASSWRD,X
        JSR     TX
        INCX
        CPX     PASDIGS
        BNE     INTS_16
INTS_17 RTI

INTS_20 CMP     #255
        BNE     INTS_30
        BCLR    6,SERSTAT
        RTI

INTS_30 LDX     KEYS            Has the keyboard buffer got room ?
        CPX     #4
        BNE     INTS_31
        RTI

INTS_31 STA     KEYBUF,X        Store key in keyboard buffer
        ORA     #%01000000
        STA     SERSTAT
        INC     KEYS
        RTI

*************************************************************************
*                                                                       *
* INTTIM        : timer interrupt routine                               *
*                                                                       *
* This routine is called when output compare situation occurs or when   *
* the timer overflows                                                   *
*                                                                       *
* The routine is responsible for the auto-power off, keyboard handling  *
* and tone producing                                                    *
*                                                                       *
*************************************************************************

INTTIM  BRCLR   5,TSR,TIM_OCM   Did we have timer overflow ?
        LDA     TCNT+1          Clear overflow flag
        LDA     #$55            Reset COP timer
        STA     COPR
        LSLA
        STA     COPR
        INC     TIMEOUT         Increment power-off counter
        BNE     TIM_0           After 256*65536 timer cycles (= 32 sec)
        BRSET   5,MODE,INTT_00  device will automatically switch off
        JSR     OFFBEEP         Only beep when password protection is on
INTT_00 JSR     AUDIOFF
        LDA     #%10000000      Switch off audio circuit
        STA     PORTC
        BCLR    3,PORTB         Switch off power upper
        STOP                    And stop this device. Wake it by pressing shift
        BRCLR   5,MODE,INTT_0   If password protection is off, just return
        BSET    3,PORTB         after switching on power again
        RTI

INTT_0  JMP     INIT            If password protection is on, init

TIM_0   BRSET   5,MODE,TIM_1    If password protection is off, don't alert
        LDA     TIMEOUT         on power-off
        CMP     #208            Warn 6 seconds before auto power-off
        BNE     TIM_1           Mind that by jumping to ALERT we actually leave
        JSR     ALERT           interrupt routine. This causes no problems.

TIM_1   LDA     TIMOUTA         Check if audio is still on
        BMI     TIM_100
        DEC     TIMOUTA
        BNE     TIM_100
        DEC     TIMOUTA
        LDA     #%10000000      Switch off audio circuitry
        STA     PORTC
        LDA     #NOAUDIO/256    Interrupt routine jumps through fake
        STA     TONE1+1         tone routines
        LDA     #NOAUDIO
        STA     TONE1+2
TIM_100 BRSET   6,TSR,TIM_OCM   Did we have an output compare situation ?
        RTI                     If not, just return

TIM_OCM JMP     TONE1           -> TONE1 -> TONE2 -> TONE3 -> REENTRY
REENTRY LDA     OCMP+1          or -> NOAUDIO -> REENTRY
        ADD     #64             sample period (= 64 timer cycles = 8.192 kHz)
        BCC     TIM_2
        INC     OCMP
TIM_2   STA     OCMP+1

        INC     TICKER+1        Increment ticker value
        BNE     TIM_3
        INC     TICKER
        BNE     TIM_3           If ticker runs through zero, alert foreground
        CLR     NEXTSTR         program to update tone values

TIM_3   DEC     KEYCNT          Time to scan the keyboard already ?
        BEQ     KEYSCAN

        RTI

*************************************************************************
*                                                                       *
* At this point the keyboard is going to be scanned                     *
* The keyboard is being scanned every 1/128 second                      *
*                                                                       *
* Because of the critical timing this piece of software is written a    *
* 'bit' dirty, so we will not blame you for not understanding one bit   *
* of it.                                                                *
*                                                                       *
* KEYSTAT       : current key status                                    *
*                                                                       *
* 00000000      - no key pressed                                        *
* 10000000      - key pressed, not debounced yet                        *
* 010skkkk      - key pressed, debounced, kkkk=key code, s=shift key    *
* 001xxxxx      - key released, not denounced yet                       *
*                                                                       *
*************************************************************************

KEYSCAN BSET    6,KEYCNT        Set key-count to 64

        LDA     KEYSTAT         We are now going to read the keyboard

        BMI     TIM_4           Key pressed, but not debounced yet ?

        BEQ     TIM_9           No key pressed at all ?

        BRCLR   6,KEYSTAT,TIM_11        Key released, not debounced yet ?

        LDA     PORTD           Key pressed and debounced, check to see
        AND     #%00111100      if it is being released again
        BNE     TIM_13          If not, leave it as it is

        LSR     KEYSTAT         If so, indicate that the key has been released
        RTI

TIM_4   LDA     PORTD           Key pressed, not debounced yet
        AND     #%00111100      If we now get no key pressed, then clear
        BEQ     TIM_12          KEYSTAT again

        TAX                     X will contain an offset into the keytable
        LSRX
        LSRX

        BCLR    0,PORTB         Clear bit of row 1,4,7,*
        LDA     PORTD           If we now read the keyboard and the data
        AND     #%00111100      is still present, the key should be in one
        BNE     TIM_5           of the other two rows

        LDA     COL147,X        Else it is in this row

        LDX     KEYS            Check to see if the keyboard buffer is full
        CPX     #4
        BNE     TIM_7
        BSET    0,PORTB         Activate port b for next read
        RTI

TIM_5   BCLR    1,PORTB         Clear bit of row 2,5,8,0

        LDA     PORTD           If we now read the keyboard and the data
        AND     #%00111100      is still present, the key should be in
        BNE     TIM_6           row 3,6,9,#

        LDA     COL258,X

        LDX     KEYS            Check to see if the keyboard buffer is full
        CPX     #4
        BNE     TIM_7
        BSET    0,PORTB         Activate port b for next read
        BSET    1,PORTB
        RTI

TIM_6   LDA     COL369,X

        LDX     KEYS            Check to see if the keyboard buffer is full
        CPX     #4
        BNE     TIM_7
        BSET    0,PORTB         Activate port b for next read
        BSET    1,PORTB
        RTI

TIM_7   BIH     TIM_8           Check the shift key; it's connected to the
        ORA     #16             IRQ-pin

TIM_8   STA     KEYBUF,X        Put key in keyboard buffer
        INC     KEYS
        ORA     #64             Indicate that a key is being pressed right now
        STA     KEYSTAT
        BSET    0,PORTB         Activate port b for next read
        BSET    1,PORTB
        RTI

TIM_9   LDA     PORTD           No key pressed yet, check to see if there is a
        AND     #%00111100      key being pressed

        BEQ     TIM_13          If not, leave it
        BSET    7,KEYSTAT       Else, indicate that key needs debouncing

        JSR     CLRTIME

TIM_10  RTI

TIM_11  LDA     PORTD           Key released, not debounced
        AND     #%00111100      Key pressed right now ?
        BNE     TIM_13          If so, don`t alter situation
TIM_12  CLR     KEYSTAT         else, it's released and debounced

TIM_13  RTI

NOAUDIO JMP     REENTRY         Tone 1 is indirected to this jump for no audio

*************************************************************************
*                                                                       *
*   Tone 1 routines to produce 16 levels of tone 1 from 0 to -15 dB     *
*                                                                       *
*************************************************************************

TON1_0  LDA     TONE1CT+1
        ADD     TONE1ST+1
        STA     TONE1CT+1
        LDA     TONE1CT
        TAX
        ADC     TONE1ST
        STA     TONE1CT
        LDA     SINE0,X
        ADD     #64
        STA     TONEOUT
        JMP     TONE2

TON1_6  LDA     TONE1CT+1
        ADD     TONE1ST+1
        STA     TONE1CT+1
        LDA     TONE1CT
        TAX
        ADC     TONE1ST
        STA     TONE1CT
        LDA     SINE6,X
        ADD     #64
        STA     TONEOUT
        JMP     TONE2

TON1_10 LDA     TONE1CT+1
        ADD     TONE1ST+1
        STA     TONE1CT+1
        LDA     TONE1CT
        TAX
        ADC     TONE1ST
        STA     TONE1CT
        LDA     SINE10,X
        ADD     #64
        STA     TONEOUT
        JMP     TONE2

TON1_15 LDA     TONE1CT+1
        ADD     TONE1ST+1
        STA     TONE1CT+1
        LDA     TONE1CT
        TAX
        ADC     TONE1ST
        STA     TONE1CT
        LDA     SINE15,X
        ADD     #64
        STA     TONEOUT
        JMP     TONE2

*************************************************************************
*                                                                       *
*   Tone 2 routines to produce 16 levels of tone 2 from 0 to -15 dB     *
*                                                                       *
*************************************************************************

TON2_0  LDA     TONE2CT+1
        ADD     TONE2ST+1
        STA     TONE2CT+1
        LDA     TONE2CT
        TAX
        ADC     TONE2ST
        STA     TONE2CT
        LDA     SINE0,X
        ADD     TONEOUT
        STA     TONEOUT
        JMP     TONE3

TON2_6  LDA     TONE2CT+1
        ADD     TONE2ST+1
        STA     TONE2CT+1
        LDA     TONE2CT
        TAX
        ADC     TONE2ST
        STA     TONE2CT
        LDA     SINE6,X
        ADD     TONEOUT
        STA     TONEOUT
        JMP     TONE3

TON2_10 LDA     TONE2CT+1
        ADD     TONE2ST+1
        STA     TONE2CT+1
        LDA     TONE2CT
        TAX
        ADC     TONE2ST
        STA     TONE2CT
        LDA     SINE10,X
        ADD     TONEOUT
        STA     TONEOUT
        JMP     TONE3

TON2_15 LDA     TONE2CT+1
        ADD     TONE2ST+1
        STA     TONE2CT+1
        LDA     TONE2CT
        TAX
        ADC     TONE2ST
        STA     TONE2CT
        LDA     SINE15,X
        ADD     TONEOUT
        STA     TONEOUT
        JMP     TONE3

*************************************************************************
*                                                                       *
*   Tone 3 routines to produce 16 levels of tone 3 from 0 to -15 dB     *
*                                                                       *
*************************************************************************

TON3_0  LDA     TONE3CT+1
        ADD     TONE3ST+1
        STA     TONE3CT+1
        LDA     TONE3CT
        TAX
        ADC     TONE3ST
        STA     TONE3CT
        LDA     SINE0,X
        ADD     TONEOUT
        STA     PORTC
        JMP     REENTRY

TON3_6  LDA     TONE3CT+1
        ADD     TONE3ST+1
        STA     TONE3CT+1
        LDA     TONE3CT
        TAX
        ADC     TONE3ST
        STA     TONE3CT
        LDA     SINE6,X
        ADD     TONEOUT
        STA     PORTC
        JMP     REENTRY

TON3_10 LDA     TONE3CT+1
        ADD     TONE3ST+1
        STA     TONE3CT+1
        LDA     TONE3CT
        TAX
        ADC     TONE3ST
        STA     TONE3CT
        LDA     SINE10,X
        ADD     TONEOUT
        STA     PORTC
        JMP     REENTRY

TON3_15 LDA     TONE3CT+1
        ADD     TONE3ST+1
        STA     TONE3CT+1
        LDA     TONE3CT
        TAX
        ADC     TONE3ST
        STA     TONE3CT
        LDA     SINE15,X
        ADD     TONEOUT
        STA     PORTC
        JMP     REENTRY

*************************************************************************
*                                                                       *
* INTIRQ        : external IRQ routine                                  *
*                                                                       *
* This routine is called whenever shift is pressed. It's only task is   *
* to reset the power-off counter                                        *
*                                                                       *
*************************************************************************

INTIRQ  JSR     CLRTIME
        RTI

MOTHER  FCB     2,5,16+8,7,8,16+3,7,3,16+8,2,5  Mother key
VERSION FCB     131                     Version 1.31
MESSAGE FCB CR,LF
        FCC 'Demon-Dialer v1.31'
        FCB CR,LF,CR,LF,0


* Here, the 3*16 jump addresses are held for the 16 dB levels of
* the 3 tone channels

JUMPTB1 FDB     TON1_0
        FDB     TON1_6          Note that -1, -2, -3, -4 and -5 all redirect
        FDB     TON1_6          to -6 dB
        FDB     TON1_6
        FDB     TON1_6
        FDB     TON1_6
        FDB     TON1_6
        FDB     TON1_10
        FDB     TON1_10
        FDB     TON1_10
        FDB     TON1_10
        FDB     TON1_15
        FDB     TON1_15
        FDB     TON1_15
        FDB     TON1_15
        FDB     TON1_15

JUMPTB2 FDB     TON2_0
        FDB     TON2_6
        FDB     TON2_6
        FDB     TON2_6
        FDB     TON2_6
        FDB     TON2_6
        FDB     TON2_6
        FDB     TON2_10
        FDB     TON2_10
        FDB     TON2_10
        FDB     TON2_10
        FDB     TON2_15
        FDB     TON2_15
        FDB     TON2_15
        FDB     TON2_15
        FDB     TON2_15

JUMPTB3 FDB     TON3_0
        FDB     TON3_6
        FDB     TON3_6
        FDB     TON3_6
        FDB     TON3_6
        FDB     TON3_6
        FDB     TON3_6
        FDB     TON3_10
        FDB     TON3_10
        FDB     TON3_10
        FDB     TON3_10
        FDB     TON3_15
        FDB     TON3_15
        FDB     TON3_15
        FDB     TON3_15
        FDB     TON3_15

COL147  FCB     0,1,4,4,7,7,7,7,10,10,10,10,10,10,10,10
COL258  FCB     0,2,5,5,8,8,8,8,0,0,0,0,0,0,0,0
COL369  FCB     0,3,6,6,9,9,9,9,11,11,11,11,11,11,11,11

*************************************************************************
*                                                                       *
* Now following is the list of the ROM modes                            *
*                                                                       *
* Some of the ROM modes use template values, don't use them in user     *
* modes                                                                 *
*                                                                       *
* Time templates :                                                      *
*                                                                       *
* 0 - DTMF/C3/pulse dial mark     (50 ms default)                       *
* 1 - DTMF/C3/pulse dial space    (50 ms default)                       *
* 2 - C5/R2 mark                  (50 ms default)                       *
* 3 - C5/R2 space                 (50 ms default)                       *
* 4 - kp period                   (100 ms default)                      *
* 5 - free                                                              *
* 6 - C3 interdigit time          (500 ms default)                      *
* 7 - free                                                              *
*                                                                       *
* RAM frequencies (special : 1 Hz = off hook, 2 Hz = on hook)           *
*                                                                       *
* 0 - C3/pulse dial mark          (2 Hz default, meaning on-hook)       *
* 1 - C3/pulse dial space         (1 Hz default, meaning off-hook)      *
* 2 - Special menu freq # 1       (0 Hz)                                *
* 3 - Special menu freq # 2       (0 Hz)                                *
*                                                                       *
*************************************************************************

ROMMDS  FDB     DTMF            0       Dual tone multi-frequency
        FDB       DTMF          1
        FDB     R2frwrd         2       R2 forward
        FDB     C3              3       CCITT standard 3 template
        FDB     C4              4       CCITT standard 4
        FDB     C5              5       CCITT standard 5
        FDB     Red             6       Red
        FDB     Special         7
        FDB     Toneslt         8
        FDB       DTMF          9
        FDB       DTMF          ^0
        FDB       DTMF          ^1
        FDB     R2bkwrd         ^2      R2 backward
        FDB       DTMF          ^3
        FDB       DTMF          ^4
        FDB       DTMF          ^5
        FDB       DTMF          ^6
        FDB       DTMF          ^7      ^8 and ^9 are RAM modes


DTMF    FCB %01011000,$66,21,23         0       0
        FCB %10011001
        FCB %01011000,$66,18,22         1       1
        FCB %10011001
        FCB %01011000,$66,18,23         2       2
        FCB %10011001
        FCB %01011000,$66,18,24         3       3
        FCB %10011001
        FCB %01011000,$66,19,22         4       4
        FCB %10011001
        FCB %01011000,$66,19,23         5       5
        FCB %10011001
        FCB %01011000,$66,19,24         6       6
        FCB %10011001
        FCB %01011000,$66,20,22         7       7
        FCB %10011001
        FCB %01011000,$66,20,23         8       8
        FCB %10011001
        FCB %01011000,$66,20,24         9       9
        FCB %10011001
        FCB %01011000,$66,21,22         *       *
        FCB %10011001
        FCB %01011000,$66,21,24         #       #
        FCB %10011001
        FCB %10010000                   ^0      -
        FCB %01011000,$66,18,25         ^1      A
        FCB %10011001
        FCB %01011000,$66,19,25         ^2      B
        FCB %10011001
        FCB %01011000,$66,20,25         ^3      C
        FCB %10011001
        FCB %01011000,$66,21,25         ^4      D
        FCB %10011001
        FCB %10010000                   ^5      -
        FCB %10010000                   ^6      -
        FCB %10010000                   ^7      -
        FCB %10010000                   ^8      -
        FCB %10010000                   ^9      -

R2frwrd FCB %01011010,$66,29,30         0       10
        FCB %10011011
        FCB %01011010,$66,26,27         1       1
        FCB %10011011
        FCB %01011010,$66,26,28         2       2
        FCB %10011011
        FCB %01011010,$66,27,28         3       3
        FCB %10011011
        FCB %01011010,$66,26,29         4       4
        FCB %10011011
        FCB %01011010,$66,27,29         5       5
        FCB %10011011
        FCB %01011010,$66,28,29         6       6
        FCB %10011011
        FCB %01011010,$66,26,30         7       7
        FCB %10011011
        FCB %01011010,$66,27,30         8       8
        FCB %10011011
        FCB %01011010,$66,28,30         9       9
        FCB %10011011
        FCB %10010000                   *       -
        FCB %10010000                   #       -
        FCB %10011011                   ^0      pause
        FCB %01011010,$66,26,31         ^1      11
        FCB %10011011
        FCB %01011010,$66,27,31         ^2      12
        FCB %10011011
        FCB %01011010,$66,28,31         ^3      13
        FCB %10011011
        FCB %01011010,$66,29,31         ^4      14
        FCB %10011011
        FCB %01011010,$66,30,31         ^5      15
        FCB %10011011
        FCB %10010000                   ^6      -
        FCB %10010000                   ^7      -
        FCB %10010000                   ^8      -
        FCB %10010000                   ^9      -

C3      FCB %00110000,$00,0             0       10 pulses
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %10110110,$00,1

        FCB %00110000,$00,0             1       1 pulse
        FCB %10110110,$00,1

        FCB %00110000,$00,0             2       2 pulses
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %10110110,$00,1

        FCB %00110000,$00,0             3       3 pulses
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %10110110,$00,1

        FCB %00110000,$00,0             4       4 pulses
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %10110110,$00,1

        FCB %00110000,$00,0             5       5 pulses
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %10110110,$00,1

        FCB %00110000,$00,0             6       6 pulses
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %10110110,$00,1

        FCB %00110000,$00,0             7       7 pulses
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %10110110,$00,1

        FCB %00110000,$00,0             8       8 pulses
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %10110110,$00,1

        FCB %00110000,$00,0             9       9 pulses
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %00110001,$00,1
        FCB %00110000,$00,0
        FCB %10110110,$00,1

        FCB %10100000,204,$00,11        *       200 ms space

        FCB %10100000,204,$00,10        #       200 ms mark

        FCB %10010000                   ^0      -
        FCB %10010000                   ^1      -
        FCB %10010000                   ^2      -
        FCB %10010000                   ^3      -
        FCB %10010000                   ^4      -
        FCB %10010000                   ^5      -
        FCB %10010000                   ^6      -
        FCB %10010000                   ^7      -
        FCB %10010000                   ^8      -
        FCB %10010000                   ^9      -
                                          
C4      FCB %00100000,36,$66,50         0       10
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %10000000,102

        FCB %00100000,36,$66,53         1       1
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %10000000,102

        FCB %00100000,36,$66,53         2       2
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %10000000,102

        FCB %00100000,36,$66,53         3       3
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %10000000,102

        FCB %00100000,36,$66,53         4       4
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %10000000,102

        FCB %00100000,36,$66,53         5       5
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %10000000,102

        FCB %00100000,36,$66,53         6       6
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %10000000,102

        FCB %00100000,36,$66,53         7       7
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %10000000,102

        FCB %00100000,36,$66,50         8       8
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %10000000,102

        FCB %00100000,36,$66,50         9       9
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %10000000,102

        FCB %01000000,154,$66,50,53     *       PXX     Clear forward
        FCB %10100001,102,$66,50

        FCB %01000000,154,$66,50,53     #       PY      Transit seizure
        FCB %10100000,102,$66,53

        FCB %10010000                   ^0

        FCB %00100000,36,$66,50         ^1      11
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %10000000,102

        FCB %00100000,36,$66,50         ^2      12
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %10000000,102

        FCB %00100000,36,$66,50         ^3      13
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %10000000,102

        FCB %00100000,36,$66,50         ^4      14
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %10000000,102

        FCB %00100000,36,$66,50         ^5      15
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %00000000,36
        FCB %00100000,36,$66,50
        FCB %10000000,102

        FCB %00100000,36,$66,53         ^6      16
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %00000000,36
        FCB %00100000,36,$66,53
        FCB %10000000,102

        FCB %01000000,154,$66,50,53     *       PX      Terminal seizure
        FCB %10100000,102,$66,50

        FCB %10010000                   ^8

        FCB %01000000,154,$66,50,53     ^9      PYY     Forward transfer
        FCB %10100001,102,$66,53

C5      FCB %01011010,$66,15,16         0       10
        FCB %10011011
        FCB %01011010,$66,12,13         1       1
        FCB %10011011
        FCB %01011010,$66,12,14         2       2
        FCB %10011011
        FCB %01011010,$66,13,14         3       3
        FCB %10011011
        FCB %01011010,$66,12,15         4       4
        FCB %10011011
        FCB %01011010,$66,13,15         5       5
        FCB %10011011
        FCB %01011010,$66,14,15         6       6
        FCB %10011011
        FCB %01011010,$66,12,16         7       7
        FCB %10011011
        FCB %01011010,$66,13,16         8       8
        FCB %10011011
        FCB %01011010,$66,14,16         9       9
        FCB %10011011
        FCB %11000000,179,$66,53,55     *       CF175
        FCB %10100001,51,$66,53         #       SZ300
        FCB %10011011                   ^0      pause
        FCB %01011010,$66,12,17         ^1      11
        FCB %10011011
        FCB %01011010,$66,13,17         ^2      12
        FCB %10011011
        FCB %01011100,$66,14,17         ^3      KP1
        FCB %10011011
        FCB %01011100,$66,15,17         ^4      KP2
        FCB %10011011
        FCB %11011010,$66,16,17         ^5      ST
        FCB %10101010,0,$00,55          ^6      2600 play while pressed/500 ms
        FCB %11000000,123,$66,53,55     ^7      CF120
        FCB %10100000,123,$66,53        ^8      SZ120
        FCB %10100000,246,$66,53        ^9      SZ240


Red     FCB %10010000                   0       -

        FCB %01000000,62,$66,39,40      1       5 cents ACTS
        FCB %10000010,0

        FCB %01000000,62,$66,39,40      2       10 cents
        FCB %00000000,62
        FCB %01000000,62,$66,39,40
        FCB %10000010,0

        FCB %01000000,36,$66,39,40      3       25 cents
        FCB %00000000,36
        FCB %01000000,36,$66,39,40
        FCB %00000000,36
        FCB %01000000,36,$66,39,40
        FCB %00000000,36
        FCB %01000000,36,$66,39,40
        FCB %00000000,36
        FCB %01000000,36,$66,39,40
        FCB %10000010,0

        FCB %01000000,62,$66,38,40      4       5 cents IPTS
        FCB %10000010,0

        FCB %01000000,62,$66,38,40      5       10 cents
        FCB %00000000,62
        FCB %01000000,62,$66,38,40
        FCB %10000010,0

        FCB %01000000,36,$66,38,40      6       25 cents
        FCB %00000000,36
        FCB %01000000,36,$66,38,40
        FCB %00000000,36
        FCB %01000000,36,$66,38,40
        FCB %00000000,36
        FCB %01000000,36,$66,38,40
        FCB %00000000,36
        FCB %01000000,36,$66,38,40
        FCB %10000010,0

        FCB %00100000,62,$00,40         7       5 cents non ACTS
        FCB %10000010,0

        FCB %00100000,62,$00,40         8       10 cents
        FCB %00000000,62
        FCB %00100000,62,$00,40
        FCB %10000010,0

        FCB %00100000,36,$00,40         9       25 cents
        FCB %00000000,36
        FCB %00100000,36,$00,40
        FCB %00000000,36
        FCB %00100000,36,$00,40
        FCB %00000000,36
        FCB %00100000,36,$00,40
        FCB %00000000,36
        FCB %00100000,36,$00,40
        FCB %10000010,0

        FCB %10010000                   *       -
        FCB %10010000                   #       -
        FCB %10010000                   ^0      -
        FCB %10010000                   ^1      -
        FCB %10010000                   ^2      -
        FCB %10010000                   ^3      -
        FCB %10010000                   ^4      -
        FCB %10010000                   ^5      -
        FCB %10010000                   ^6      -
        FCB %10010000                   ^7      -
        FCB %10010000                   ^8      -
        FCB %10010000                   ^9      -

Special FCB %10001000,51                0       Silence   50 ms
        FCB %11001000,51,$66,53,55      1       2400/2600 50 ms
        FCB %10101000,51,$66,53         2       2400      50 ms
        FCB %10101000,51,$00,55         3       2600      50 ms
        FCB %11001000,51,$66,50,53      4       2040/2400 50 ms
        FCB %10101000,51,$00,52         5       2280      50 ms
        FCB %10101000,51,$00,56         6       3000      50 ms
        FCB %10101000,51,$00,48         7       1700      50 ms
        FCB %10101000,51,$00,49         8       1900      50 ms
        FCB %10101000,51,$00,54         9       2500      50 ms
        FCB %11001000,51,$66,2,3        *       #2/#3     50 ms
        FCB %11001000,10,$66,2,3        #       #2/#3     10 ms
        FCB %10001000,10                ^0      Silence   10 ms
        FCB %11001000,10,$66,53,55      ^1      2400/2600 10 ms
        FCB %10101000,10,$66,53         ^2      2400      10 ms
        FCB %10101000,10,$00,55         ^3      2600      10 ms
        FCB %11001000,10,$66,50,53      ^4      2040/2400 10 ms
        FCB %10101000,10,$00,52         ^5      2280      10 ms
        FCB %10101000,10,$00,56         ^6      3000      10 ms
        FCB %10101000,10,$00,48         ^7      1700      10 ms
        FCB %10101000,10,$00,49         ^8      1900      10 ms
        FCB %10101000,10,$00,54         ^9      2500      10 ms

Toneslt FCB %10101000,71,$00,53         0       0
        FCB %10101000,71,$00,81         1       1
        FCB %10101000,71,$00,91         2       2
        FCB %10101000,71,$00,82         3       3
        FCB %10101000,71,$00,68         4       4
        FCB %10101000,71,$00,92         5       5
        FCB %10101000,71,$00,93         6       6
        FCB %10101000,71,$00,94         7       7
        FCB %10101000,71,$00,75         8       8
        FCB %10101000,71,$00,40         9       9
        FCB %10101000,71,$00,55         *       A
        FCB %10010000                   #       -
        FCB %10010000                   ^0      -
        FCB %10010000                   ^1      -
        FCB %10010000                   ^2      -
        FCB %10010000                   ^3      -
        FCB %10010000                   ^4      -
        FCB %10010000                   ^5      -
        FCB %10010000                   ^6      -
        FCB %10010000                   ^7      -
        FCB %10010000                   ^8      -
        FCB %10010000                   ^9      -

R2bkwrd FCB %01011010,$66,35,36         0       10
        FCB %10011011
        FCB %01011010,$66,32,33         1       1
        FCB %10011011
        FCB %01011010,$66,32,34         2       2
        FCB %10011011
        FCB %01011010,$66,33,34         3       3
        FCB %10011011
        FCB %01011010,$66,32,35         4       4
        FCB %10011011
        FCB %01011010,$66,33,35         5       5
        FCB %10011011
        FCB %01011010,$66,34,35         6       6
        FCB %10011011
        FCB %01011010,$66,32,36         7       7
        FCB %10011011
        FCB %01011010,$66,33,36         8       8
        FCB %10011011
        FCB %01011010,$66,34,36         9       9
        FCB %10011011
        FCB %10010000                   *       -
        FCB %10010000                   #       -
        FCB %10011011                   ^0      pause
        FCB %01011010,$66,32,37         ^1      11
        FCB %10011011
        FCB %01011010,$66,33,37         ^2      12
        FCB %10011011
        FCB %01011010,$66,34,37         ^3      13
        FCB %10011011
        FCB %01011010,$66,35,37         ^4      14
        FCB %10011011
        FCB %01011010,$66,36,37         ^5      15
        FCB %10011011
        FCB %10010000                   ^6      -
        FCB %10010000                   ^7      -
        FCB %10010000                   ^8      -
        FCB %10010000                   ^9      -

SINE0   FCB 0,1,3,4,6,7,9,10,12,13,15,16,18,19,21,22
        FCB 24,25,26,28,29,31,32,33,35,36,37,38,39,41,42,43
        FCB 44,45,46,47,48,49,50,51,52,53,54,54,55,56,56,57
        FCB 58,58,59,59,60,60,61,61,61,62,62,62,62,62,62,62
        FCB 62,62,62,62,62,62,62,62,61,61,61,60,60,59,59,58
        FCB 58,57,56,56,55,54,54,53,52,51,50,49,48,47,46,45
        FCB 44,43,42,41,39,38,37,36,35,33,32,31,29,28,26,25
        FCB 24,22,21,19,18,16,15,13,12,10,9,7,6,4,3,1
        FCB 0,255,253,252,250,249,247,246,244,243,241,240,238,237,235,234
        FCB 232,231,230,228,227,225,224,223,221,220,219,218,217,215,214,213
        FCB 212,211,210,209,208,207,206,205,204,203,202,202,201,200,200,199
        FCB 198,198,197,197,196,196,195,195,195,194,194,194,194,194,194,194
        FCB 193,194,194,194,194,194,194,194,195,195,195,196,196,197,197,198
        FCB 198,199,200,200,201,202,202,203,204,205,206,207,208,209,210,211
        FCB 212,213,214,215,217,218,219,220,221,223,224,225,227,228,230,231
        FCB 232,234,235,237,238,240,241,243,244,246,247,249,250,252,253,255


SINE6   FCB 0,0,1,2,3,3,4,5,6,6,7,8,9,9,10,11
        FCB 12,12,13,14,14,15,16,16,17,18,18,19,20,20,21,21
        FCB 22,22,23,23,24,24,25,25,26,26,27,27,27,28,28,28
        FCB 29,29,29,29,30,30,30,30,30,31,31,31,31,31,31,31
        FCB 31,31,31,31,31,31,31,31,30,30,30,30,30,29,29,29
        FCB 29,28,28,28,27,27,27,26,26,25,25,24,24,23,23,22
        FCB 22,21,21,20,20,19,18,18,17,16,16,15,14,14,13,12
        FCB 12,11,10,9,9,8,7,6,6,5,4,3,3,2,1,0
        FCB 0,0,255,254,253,253,252,251,250,250,249,248,247,247,246,245
        FCB 244,244,243,242,242,241,240,240,239,238,238,237,236,236,235,235
        FCB 234,234,233,233,232,232,231,231,230,230,229,229,229,228,228,228
        FCB 227,227,227,227,226,226,226,226,226,225,225,225,225,225,225,225
        FCB 225,225,225,225,225,225,225,225,226,226,226,226,226,227,227,227
        FCB 227,228,228,228,229,229,229,230,230,231,231,232,232,233,233,234
        FCB 234,235,235,236,236,237,238,238,239,240,240,241,242,242,243,244
        FCB 244,245,246,247,247,248,249,250,250,251,252,253,253,254,255,0


SINE10  FCB 0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7
        FCB 7,8,8,8,9,9,10,10,11,11,11,12,12,13,13,13
        FCB 14,14,14,15,15,15,16,16,16,16,17,17,17,17,18,18
        FCB 18,18,18,18,19,19,19,19,19,19,19,19,19,19,19,19
        FCB 19,19,19,19,19,19,19,19,19,19,19,19,19,18,18,18
        FCB 18,18,18,17,17,17,17,16,16,16,16,15,15,15,14,14
        FCB 14,13,13,13,12,12,11,11,11,10,10,9,9,8,8,8
        FCB 7,7,6,6,5,5,4,4,3,3,2,2,1,1,0,0
        FCB 0,0,0,255,255,254,254,253,253,252,252,251,251,250,250,249
        FCB 249,248,248,248,247,247,246,246,245,245,245,244,244,243,243,243
        FCB 242,242,242,241,241,241,240,240,240,240,239,239,239,239,238,238
        FCB 238,238,238,238,237,237,237,237,237,237,237,237,237,237,237,237
        FCB 237,237,237,237,237,237,237,237,237,237,237,237,237,238,238,238
        FCB 238,238,238,239,239,239,239,240,240,240,240,241,241,241,242,242
        FCB 242,243,243,243,244,244,245,245,245,246,246,247,247,248,248,248
        FCB 249,249,250,250,251,251,252,252,253,253,254,254,255,255,0,0


SINE15  FCB 0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,4
        FCB 4,4,4,5,5,5,5,5,6,6,6,6,7,7,7,7
        FCB 7,8,8,8,8,8,8,9,9,9,9,9,9,10,10,10
        FCB 10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11
        FCB 11,11,11,11,11,11,11,11,10,10,10,10,10,10,10,10
        FCB 10,10,10,10,9,9,9,9,9,9,8,8,8,8,8,8
        FCB 7,7,7,7,7,6,6,6,6,5,5,5,5,5,4,4
        FCB 4,4,3,3,3,2,2,2,2,1,1,1,1,0,0,0
        FCB 0,0,0,0,255,255,255,255,254,254,254,254,253,253,253,252
        FCB 252,252,252,251,251,251,251,251,250,250,250,250,249,249,249,249
        FCB 249,248,248,248,248,248,248,247,247,247,247,247,247,246,246,246
        FCB 246,246,246,246,246,246,246,246,246,245,245,245,245,245,245,245
        FCB 245,245,245,245,245,245,245,245,246,246,246,246,246,246,246,246
        FCB 246,246,246,246,247,247,247,247,247,247,248,248,248,248,248,248
        FCB 249,249,249,249,249,250,250,250,250,251,251,251,251,251,252,252
        FCB 252,252,253,253,253,254,254,254,254,255,255,255,255,0,0,0

        ORG     $1EF0

PASDIGS FCB     4                       Number of password digits
PASSWRD FCB     1,2,3,4


* Interrupt & Reset vectors

        ORG     $1FF4

        FDB     DUMINT  SPI interrupt should never occur
        FDB     INTSER  Serial interrupt service routine
        FDB     INTTIM  Timer interrupt
        FDB     INTIRQ  External IRQ-interrupt
        FDB     DUMINT  Software interrupts
        FDB     RESET   Reset vector

