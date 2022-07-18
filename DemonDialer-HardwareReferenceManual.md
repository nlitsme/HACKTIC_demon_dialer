Do it yourself
Demon-Dialer
Construction & Hardware reference manual
(rev. B)
Hack-Tic Technologies
tel/fax: +31 20 6000581

1. Building your Demon-Dialer

1.1 About this kit

Check the bag of parts to see that it contains:

 * 2 printed circuit boards (PCBS)
 * 1 bag containing 13 pushbutton switches
 * 1 bag containing all the other parts, you will find a partlist in appendix C
 * A piece of anti-static foam holding 2 IC's, the
   MC68HC705C8P/DD (the heart of the Demon-Dialer) and
   the LM386N3, an amplifier chip. The foam also holds two
   IC-sockets for these chips.

As said before, the bag contains 2 PCBS, one of them is the
actual Demon-Dialer, while the other PCB is the keyboard.
You should be able to see which is which. A header is supplied
to connect both PCBS together.

You're going to use a soldering iron to solder all the parts in. If
you have never done so before it is probably a gocid idea to as
someone that has done it before to keep an eye on you. Do nol
use soldering irons any heavier than 30 Watts and make sure
your soldering iron has a relatively fine tip (i.e. lmm.). Use
solder that has a rosin core and NEVER use plain solder and S-
39.

1.2 The keyboard PCB

First you will build the keyboard, you need the male header,
the push buttons and the keyboard PCB for that. The male
·header looks like a strip of 9 gold plated pins which are kept
together by a thin black plastic strip. Take the header and stick
it in the 9 holes marked JP3, with the black plastic strip on the
top side of the board (the top side of the board is the side with
the printing on it). Next flip the board over and solder the 9
pins. Make sure that the plastic strip lies firmly against the
board (see drawing). Be careful that a component does not
move until the solder is hard (takes only a few seconds at
most). DO NOT CUT OFF THE REMAINING PART OF
THE PINS, YOU WILL NEED nns TO CONNECT THE
KEYBOARD PCB TO THE MAIN PCB.

Now take the buttons, line up the pins and push them into the
top side of the board and solder them on the other side. It does
not matter which way the keys go in, either way will do. The
keyboard PCB is now done.

            header           component side
    board=====================================
            ||||||           solder side
    do not use too
    much solder

     right ( solder around the base of the pin )
     wrong ( solder drooping along pin )

     soldering the header


1 .3 Resistors

Now it is time to solder the other PCB, the actual Demon-
Dialer itself. All parts on the Demon-Dialer can be soldered in
any order you choose. Our· suggested way will work, but is not
the only way. We suggest you now take one of the resistors
(see list below) and put it into it's position on the board (on the
top side). Make sure each lead of the resistor sticks through a
different hole in the board and that the resistor lies flat on the
board between the two holes. Now go to the bottom side and
bend the leads sharply. Cut the leads with a pair of wire
clippers close to the bend in the lead, but not so close that the
resistor will fall out (Be careful not to damage the trace). Now
solder the wires of the resistor and repeat this procedure until
all resistors are done.

You may wonder what a resistor looks like, or how to find the
right resistor, since the values are not printed on them.
Resistors (in this kit) are small cylinders with 4 or 5 coloured
stripes that have leads coming out on both ends. They're also
the most used parts in the Demon-Dialer. Resistors have colour
codes to identify them. A list of part numbers (as used on the
Demon-Dialer silk-screen), resistor values and the colour-code
on the resistor follows:

Res. Value      Resistor colour coding
R1   10kΩ       Brown-Black-Orange-Gold
R2   10kΩ       Brown-Black-Orange-Gold
R3   10kΩ       Brown-Black-Orange-Gold
R4   10kΩ       Brown-Black-Orange-Gold
R5   10kΩ       Brown-Black-Orange-Gold
R6   10MΩ       Brown-Black-Blue-Gold
R7   3.3kΩ      Orange-Orange-Red-Gold
R8   1kΩ        Brown-Black-Red-Gold
R9   10Ω        Brown-Black-Black-Gold
R10  10kΩ       Brown-Black-Orange-Gold
R11  10kΩ       Brown-Black-Orange-Gold
R12  10kΩ       Brown-Black-Orange-Gold
R13  10kΩ       Brown-Black-Orange-Gold
R14  27kΩ       Red-Purple-Orange-Red - Brown
R15  68kΩ       Blue-Grey-Orange-Gold
R16  56kΩ       Green-Blue-Orange-Gold
R17  8.2kΩ      Grey-Red-Orange-Gold
R18  200kΩ 1%   Red-Black-Black-Orange - Brown
R19  200kΩ 1%   Red-Black-Black-Orange - Brown
R20  200kΩ 1%   Red-Black-Black-Orange - Brown
R21  200kΩ 1%   Red-Black-Black-Orange - Brown
R22  200kΩ 1%   Red-Black-Black-Orange - Brown
R23  200kΩ 1%   Red-Black-Black-Orange - Brown
R24  200kΩ 1%   Red-Black-Black-Orange - Brown
R25  200kΩ 1%   Red-Black-Black-Orange - Brown
R26  100kΩ 1%   Brown-Black-Black-Orange - Brown
R27  100kΩ 1%   Brown-Black-Black-Orange - Brown
R28  100kΩ 1%   Brown-Black-Black-Orange - Brown
R29  100kΩ 1%   Brown-Black-Black-Orange - Brown
R30  100kΩ 1%   Brown-Black-Black-Orange - Brown
R31  100kΩ 1%   Brown-Black-Black-Orange - Brown


1.4 The Diodes

There are two small orange glass things with a black stripe on
it in your bag of parts. These are diodes, with very tiny letters
one of them says BAT85 while the other (slightly bigger)
diode says 1N4148. You can only put the diodes in ONE
WAY, On the silkscreen you will find two designations
marked 01 and 02, in those designations you will find a white
triangle, this triangle should correspond with the .black line on
the diode. At designation Dl you should put the 1N4148
diode, At designation 02 you should put the BA T85 diode. A
diode is a semi-conductor which in practical terms means, that
you can destroy the component if you heat it for too long. You
can solder a diode in as if it was a resistor, however you should
NOT be holding your soldering iron up to the lead of a diode
for more than about 3 seconds otherwise it will break.

1.5 Capacitors

There are four different types of capacitors on the board. The
first type is a MMK capacitor. They are plastic little boxes
with two leads coming out the bottom they have the letters
MMK written on them. After soldering you can clip off the
excess wire. There are three MMK capacitors on the board.


Cap. Value        Writing on capacitor
C5   10nF/100V    .01K
C8   100nF/63V    .1K  or 0.1  63-A WIMA BD
C9   100nF/63V    .1K  or 0.1  63-A WIMA BD

Next, there are two multilayer capacitors called C6 and ClO
which have a value of respectively 47nF and 100 nF. They are
the little blue things with two wires that have '473M' for the
47nF and 'OulZ' for the lOOnF written on them. You can
solder it in as if it was a resistor, bending the leads and
clipping them before you solder.

The third type is called a plate capacitor. There are three of
them on the board They are little stone like things, with two
leads coming out the bottom here is their description:

Cap. Value      Colour       Writing on capacitor
C2   330pF      yellow                n33
C3   33pF       grey/black            33p
                or brown/purple       33
C4   33pF       grey/black            33p
                or brown/purple       33
The fourth type are the elco's (electrolytic capacitors).

Cap. Value          Colour   Writing on capacitor
Cl    10 μF/50 v    Blue       50V 10uF
C7   100 μF/6.3V    Black     100μF 6.3V


On one side of the elco is a minus sign pointing to the shortest
lead. The longer lead should be put in the hole marked"+" on
the board. Make sure you put them in right, or you will blow
up the elco.

1.6 The Crystal

The crystal is a fairly large metal object that has two wires
coming out from one side. It is a 4.1943 MHz Crystal. It's
designation is X1. The wires should be bent because the
crystal lies flat on the board in this design. The wires should be
bent close to the crystal, but not touching the metal housing.
Make sure it all fits.

1.7 Chip Sockets

Take the 40 pin chip-socket and place it on the the board. Do
the same with the small 8-pin chip-socket in position U2. Do
NOT put the chips into the sockets yet

1.8 Transistors

There are four transistors in the Demon-Dialer. They are black
with three wires coming out on one side. Here are their
designations and types.

Tr.    Value
Ql     BC557B
Q2     BC557B
Q3     BC547B
Q4     BC547B

When you put them in, make sure that the round edge of the
transistor lies over the 'round' side of the symbol printed on
the silk-screen. The middle lead of the transistor should be
bent a little bit to make the transistor fit the hole-pattern on the
board. Just bend the leads on the back of the board, clip them
off and solder. Beware, transistors are also semi-conductors, so
take the same precautions as with the diodes.

1.9 The connectors

There are four connectors delivered with your Demon-Dialer
of which you already used one on the keyboard PCB, the
others are a 9 pin RS232 connector, a 3.5mm mono jack to
hook up an external speaker (designation JPl) and a 9 pin
female header (designation JP2). It should be obvious which
one is which and where to solder them.

1.10 Connecting it all together

Put the chip marked MC68HC705C8P/DD into the 40 pin
socket with the notch facing towards CIO (VERY
IMPORTANT!!!). When taking the chips out of the static
foam, make sure you are GROUNDED, and that no static can
get at the contacts. When inserting the chip, hold the board in
one hand and the chip in the other, this makes sure that that
board and chip are at the same potential. Put the small chip
(marked LM386N3) into the 8-pin socket with the notch facing
towards CS (ALSO IMPORTANT!!). Make sure all the pins
on the chip really go into the socket.

IF YOU PUT THE CHIPS IN THE WRONG WAY YOU
MAY DAMAGE THEM AS YOU APPLY POWER!!!

We did not ship a speaker with this kit, this was done on
purpose, because the choice of speaker varies per person, one
might like a nice and small speaker while somebody else may
want a big and firm speaker.

When you have found the speaker of your choice (we
recommend you use a telephone earpiece) solder two wires to
the speaker and solder the other end to a 3.Smm mono jack or
directly on to the board (into the holes marked 'SPKR'). Here
you have a choice, if you are building your Demon-Dialer into
an again for the same reasons not shipped housing, you may
want to use the two holes on the board if you are using a built
in speaker. If you want to use an external speaker you should
connect it to the Demon-Dialer through the jack connector.

NOTE: You can also do a combination of both, however if you
then plug in the external speaker, the internal speaker will
automatically tum off.

Now connect the Battery holder to the Demon-Dialer, the red
wire is the plus and the black wire is the minus. Make sure that
you put the wires in the right position. You will find two holes
on the board marked + and -.

NOTE: Some of the Demon-Dialers are shipped with a
separate battery block and a 9 Volt battery connector to
connect the battery holder. However you should NEVER hook
up a 9 Volt battery to this connector, YOU WILL BLOW UP
YOUR DEMON-DIALER. Who ever invented the system of
hooking up a 6 Volt battery holder that way, was either drunk
or plain stupid.

Finally take the four bolts and stick them through the four
holes on the keyboard PCB, now take the four spacers an put
them over the bolts. Take the main PCB and put it underneath
the keyboard PCB Connect JP2 and JP3 together and put the
nuts on the bolts. Your Demon-Dialer is now ready.

1.11 Testing

Now put the batteries into the holder, be sure to keep the shift
key pressed till all the batteries are in. When you have stuck in
all four batteries an upgoing sweep will sound indicating that
your Demon-Dialer has power. You can now proceed to the
software manual. If your Demon-Dialer did not produce a
sweep tone you should read on.

1.12 You fucked up!

It's not working huh? Are you sure that you held the shift key
down when you put the batteries in? If it still doesn't work:
Check your solder connections. If it looks as if a connection
has not 'flowed' nicely around the wire or if the solder is not
as shiny as on the other connections, solder that connection
again. Make sure that you did not inadvertently connect two
traces on the print. Check the polarity on the elco's and the
diodes. Check the position of the transistors, are the right
transistors in the place, and are they the right way round. Also
check that the right parts are in the right places. Here the
printed silk-screen layout in Appendix Dis particularly handy,
since the writing on the silk-screen of the board is now
covered with parts. If the transistors and the chips are also in
the right way, you have a problem! If you really can't fix it, try
calling somebody you know that has done this kind of work
before. If you applied power with the chips facing the wrong
way, the MC68HC705C8P/DD (the big chip) is almost
certainly wasted.

Except for this chip, all parts to the Demon-Dialer can be
obtained at your local electronics store.

Appendix A

Hookswitch Control

You can use the hookswitch control bit (AUX) to control an
external relay to 'pick up the phone' and you can also pulse-
dial through it. To toggle the hookswitch-control bit press `^*^#`.
Here is how you do it.

<<< relay driver schematic >>>


The serial port

The Demon-Dialer is equipped with a serial interface here are
the settings for the serial interface: Speed is 16384 bps, format
is 1 start bit, 8 data-bits, no parity, 1 stop-bit. The port is at
TTL-level. Most computers will talk to it as it is. If your
computer requires the real RS-232 levels, you can use this
circuit to convert voltages.

<<< rs232 driver schematic >>>


Audio to phone

The audio signal that comes out of the device is 2.0 Volt peak
to peak. If you want to do any serious phreaking, you probably
want to hook this device up to a phone-line directly. The
switch in this schematic is for muting the audio when you are
signalling.

<<< phone line schematic >>>

Appendix B

<<< full schematic >>>

Appendix C

List of parts
Cl                            10 μF/50V
C2                            330 pF plate
C3,C4                         33 pF plate
C5                            10nF MMK
C6                            47 nF multilayer
C7                            100 μF/6.3V
C8,C9                         100nF MMK
ClO                           100 nF multilayer
Dl                            1N4148
D2                            BAT85
JPl                           jack3.5mm
JP2,JP3                       9 pin header
Ql,Q2                         BC557B
Q3,Q4                         BC547B
Rl, R2, R3, R4, R5            10kΩ
RlO, Rl 1, R12, R13           
R6                            10MΩ
R7                            3.3kΩ
R8                            1kΩ
R9                            10Ω
R14                           27kΩ
R15                           68kΩ
R16                           56kΩ
R17                           8.2kΩ
R18, R19, R20, R21            200kΩ 1%
R22, R23, R24, R25            
R26, R27, R28, R29            100kΩ 1 %
R30, R31                      
RS232                         DB9 female
U1                            MC68HC705C8P/DD
U2                            LM386
XI                            4.194304 MHz


Appendix D

Silk Screen

<<< silk screen images >>>


Index
A
Audio to phone                    11
c                                 
Capacitors                        5
Chip Sockets                      7
Connectors                        8
Crystal                           7
D                                 
Diodes                            5
F                                 
Fucked up!                        10
H                                 
Hack-Tic                          1
Hookswitch Control                10
K                                 
Keyboard PCB                      2
L                                 
List of parts                     13
M                                 
MC68HC705C8P/DD                   8, 10
R                                 
Resistor colour coding            4
Resistors                         3
Rosin core                        2
s                                 
S-39                              2
Schematic                         12
Serial port                       11
Silk Screen                       14
Soldering iron                    2
Static foam                       8
T          
Transistors                       7


