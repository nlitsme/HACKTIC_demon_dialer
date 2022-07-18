Do it yourself
Demon-Dialer
Operation & Software reference manual
(v 1.40)
Hack-Tic Technologies
tel/fax: +31 20 6000581

1 The basic functions

1.1 Getting started

Once the device is powered up by pressing the shift-key.
short upward tone sweep will emit from the system speaker.
When changing batteries hold down the shift key when the
power comes on to make sure the device starts up properly. If
you power-up for the first time since changing batteries, all the
settings will default to their standard values. This will also
mean that in order to gain access to the system you will firs t
have to type your system password. This password is supplied
with the Demon-Dialer and should not (repeat NOT) be lo t.
The password that we supplied with your device is not
archived at Hack-Tic Technologies or anywhere else, it's onl:
in your device and on the piece of paper that came with it.

1.2 Getting in

As said, when the device starts up for the first time, you have
to type a password. While you are typing this, the device
act like a normal Touch-Tone dialer. A word of warning
here: Touch-Tones all sound similar, but a trained ear
identify all the digits. If you wish to keep your password
secret, it is advisable to cover the speaker with your
while you type the password. If the wrong password is keyed
in, the device will remain operative as a Touch-Tone dialer.
To get access to it's more sophisticated functions, leave the
device untouched for 30 seconds. The device will then au
power off (6 seconds after a four beep alert-sound), at whi
point you can restart the device with the shift-key and tart
over.

Once the correct code is entered a victorious tune sounds.
signalling you that it is now ready to emulate any in-band
signalling system.

Of course the security of this device depends fully on how
secure the data is within the heart of it, the MC68HC705C8/
DD. The program in this chip (which also contains your
password) is protected with a security-bit that tells the
processor not to allow the outside world to read the contents of
its PROM. We do not know of any methods to read the
contents of a security-bit protected PROM short of probing on
the surface of the chip itself, which is a hyper-expensive
operation, even if you did get the bare silicon out of the
package in one piece. In other words, it is VERY HARD for
someone who does not know the code to prove that your
device is anything but an ordinary DTMF-dialer.

If you decide not to deal with all this ultra-paranoid password
nonsense, you can switch off the password protection using a
special command sequence discussed later on.

1.3 Getting used to it

Of all the in-band signalling systems, Touch-Tone (also
known as DTMF to the more technically minded) is the most
well-known. The Demon-Dialer includes many more systems,
whose only similarity is that they use tones to get a message
across. Modems all over the world use in-band signalling to
send data. One might even find in-band systems used to signal
information between phone-switches, or from mobile phones
to their base-stations. Rumour has it that there exists countries
that have payphones using · in-band signalling to indicate coin
deposits. An unlikely story, but you never know.

The Demon-Dialer starts up in Touch-Tone mode, but can be
switched to a lot of other modes. Modes are numbered 0
through 19. Modes 0 through 9 are accessed by pressing shift
and the * key together followed by the number of the mode.
From now on we will refer to keys that are pressed with the
shift down by printing a ^ in front of the key. Modes 10
through 19 are accessed by pressing `^*` followed by ^o through
^9. Here is a list of modes currently implemented:

* 0 Touch-Tone
* 1 ATF1
* 2 R2-forward
* 3 CCITT No. 3
* 4 CCITT No. 4
* 5 CCITT No. 5 / R1
* 6 RedBox
* 7 line signalling menu
* 8 tone slot
* 12R2-backward
* 18userprogrammable

Mode 18 is a RAM-mode, which means it can be user-defined.
See chapter 5 for more information on mode 18.

2 Macro mode
2.1 Using macros

Now that you are familiar with the basic operation of the unit it
is time for macros. A macro is nothing but a stored sequence
of keypresses that can be played back. It means that you do not
have to retype something that you may need to send multiple
times. It also means that you can send sequences of tones at
speeds otherwise impossible.

To work with macros you must first put the device in "macro
mode". This is done by typing A#. Two tones, the last one
lower than the first tell you that you are now in macro mode.
There are 10 different macros and they can be played by
pressing 0 through 9 while in macro mode.

To record anything in the macros first press `^<M>` (where `<M>`
is the macro you wish to record). If the macro you are
recording into is not empty the four-beep alert sequence will
sound. Press # to confirm programming, or any other key to
abort it. If it was empty you will get only two beeps and you
can start programming right away. Now just press the keys that
you want to put in the macro. The keys will produce one beep
when you press them; they will not produce the sounds they
would when pressed outside the macro mode. Don't worry,
they'll sound just fine when the macro is played. If you wish to
change modes inside the macro just do what you would
normally do: press `^*` followed by the mode you want.

Of the special functions (see section 4), only `^* * 4` and `^* * 5`
(guard tone on and guard tone off) can be put in a macro.

To end macro recording press `^#` followed by #. To go back to
normal operation just press #. Two tones, the last one higher
than the first will sound to indicate that you have left the
macro mode. You can stop a macro while it is playing by
pressing #.

2.2 Macro nesting

It is even possible to nest macros. This means that inside one
macro you can tell the device to play the contents of another
macro. The nested macros are called by name which means
that if macro B is nested inside macro A and the contents of
macro B are changed, the change will also affect the nested B
that is played as part of macro A. To nest a macro press A#
followed by the macro you wish to nest while recording.

2.3 Macro aliasing

It is possible to set up a macro-alias. This enables you to
"rename" one of the macros to another macro. If we for
instance alias macro 3 to macro 4, it means that whenever
macro 3 is referenced, macro 4 is played instead. Macro 3 is
still there, it can just not be accessed until this function is
disabled.

To use macro aliasing go to macro mode and press
`*<Ml><M2>` where `<Ml>` is the macro that aliased to `<M2>`.
If you now press `<Ml>` you hear `<M2>.` To turn this off press
`*<Ml><Ml>`. In effect, you are then aliasing the macro back
to itself. Only one alias can be in effect at any time. It is also
possible to alias a macro to silence by pressing `*<M>#`.

2.4 Macro pausing and retry

You can include special sequences in the macros to tell the
Demon-Dialer to wait for shift to be pressed, and you can
place retry points.

Using `^* # 0` in a macro places a retry marker.

`^* # 1` means that at this point, when the macro is played, the
Demon-Dialer waits for the shift to be pressed before
continuing.

`^* # 2` means that at this point the Demon-Dialer macro Just
continues. unless shift is pressed. If it is, it waits until shift i
released and pressed again before continuing.

`^* # 3` is the same as `^* # 2` except that in order to continue
shift has to be repressed within 125 ms, otherwise the macro is
'rewound' to the last retry marker (nifty huh?).

`^* # 4` is like putting `^* # 0` and `^* # 1` in the macro.
If you programmed a macro with some of the above sequences
and you want to play the macro normally, use `^* # <M>`. This
will ignore all pause and retry sequences.

3 The FIN-table

Inside your Demon-Dialer is a frequency table. This table
contains twelve RAM-based frequencies that you can change
and 82 ROM-based (fixed) frequencies. The frequencies are
referenced to by number. These numbers are called Frequency
Index Numbers (FIN). Apart from the tone made during
frequency stepping and sweeping, these are the tones the
device will produce. Some of the RAM-based frequencies
have been used in modes 3 and 7 and have a default value that
is loaded in them every time you change the batteries or reset
the device. The FIN-table is listed in full in Appendix A.

4 Special functions

A number of special functions is built into the device. They are
all accessed by pressing `^* *` followed by the number of the
function.

4.o Device init

This function will initialize the device, deleting all macro
definitions, RAM mode 18, all time-templates and RAM
frequencies. It will also tum the password protection back on
(if it was oft). In other words: EVERYTHING YOU EVER
PUT INTO THE DEVICE IS GONE. When you press `^* * 0`
an alert will sound. If you press # the Demon-Dialer will
initialize, if you press anything else it will not.

4.1 RAM FIN programming

The Demon-Dialer has 12 FIN-locations in its memory where
the user can define frequencies. Type `^* * 1 <FIN> # <frequency> #`

The frequency number ranges from 0 to 11, the frequency has
to be entered in Hertz. The system will acknowledge
programming by playing a short sample of the frequency just
programmed.

These user-defined FINs as well as the ROM-based FINs can
be used when programming your own keys into mode 18, they
can also be used as guard tones. The C3 mode uses two RAM
frequencies (0 and 1) as its mark and space frequency
respectively so that you can use it to emulate any Single
Frequency system.

4.2 Time template programming

The user of the Demon-Dialer can define up to 8 periods in
milliseconds and then use these periods in the User Defined
Mode as durations for tones. Most of the time-templates are
also used in the ROM-modes of the device. The fact that a
certain time-template has been used in a ROM-mode does not
mean you cannot use it in one of your own modes. Time
templates are programmed in a manner similar to the user-
defined frequencies above. Typing `^* * 2 <time-template
number> <time in milliseconds> #` will program a time-
template. Note that the time-template number itself is not
followed by a pound because it is always one digit long (0-7).
Here is a list of time-templates, what the system uses them for,
and what their default values are:

0 - DTMF and C3 mark (50 ms default)
1 - DTMF and C3 space (50 ms default)
2 - C5/R2 mark (50 ms default)
3 - C5/R2 space (50 ms default)
4 - CS kp time (100 ms default)
5 - free
6 - C3 interdigit time (500 ms default)
7 - free

4.3 Guard tone programming

Guard tones are tones that are played simultaneously with the
real signalling. They are used to jam any filters on the line so
that they act as if the signal you are sending is speech. The
Demon-Dialer has three guard tones that it can store in
memory. To program any of these three guard tones press `^* *
3 <Guard tone number> <FIN> #` The Guard tone number is 0,
1 or 2. See section 3 and Appendix A for more info.
If you first tum on the Demon-Dialer, the guard tones default
to certain values. Guard tone 0 defaults to 2280 Hz, guard tone
1 to 3100 Hz and guard tone 2 defaults to 3250 Hz.

4.4 Start guard tone

Pressing `^* * 4 <guard tone number>` will tum on that guard
tone. It will then continuously sound until it is turned off or
another guard tone is started.

4.s Stop guard tone

If a guard tone is on, `^* * 5` will stop it. This command and the
previous one can be used inside macros. If you are
programming a macro, don't forget that a guard tone will still
sound when the macro is finished. Use this command in the
macro if that is not what you want.

4.6 Frequency stepping

Pressing `^* * 6 <start frequency> # <step size> #` will sound
the start frequency. If you then press `*` the tone will step up
with the step size specified, pressing 0 will step down. If you
press # the tone will end. Frequencies have to be typed in
Hertz.

4.7 Continuous sweep

This will sound a tone sweep through the full voice-range (0 -
4 kHz) and back in+/- 15 seconds and then start over. Pressing
`#` ends the sweep.

4.8 Password protection on

If you tum on the password protection, the device will tum
itself off. To continue using it, press shift to tum it on and type
your password.

4.9 Password protection off

If password protection is turned off, the device will not sound
the down-going sweep when it times out, it will not sound the
up-going sweep if it is turned on. If the password protection is
turned off, the device will come back alive at the same point in
the software where it powered down. If you were in the middle
of programming a macro and let the device time out and power
down, you can finish the macro when you power up again.

4.10 Number scan

This function can be used to scan through numbers in a
sequential way. First assign a macro to contain the first try in
your scan. This macro is called the 'number macro'. Optionally
you can program a second macro to contain the whole
sequence you want to play each time around. This second
macro is called the 'play macro' and contains the number
macro nested somewhere in it. See macro nesting (Section 2)
for details on how to define and nest macros.

Type `^* * * <play macro> <number macro> <step size> #` to
start the number scan. The device will then play the play
macro and wait for the user to press either * or 0 to increment
or decrement the `<number macro>` with the step size and then
play the `<play macro>`. Pressing# will end the scan.

To use this you can either use the same macro as both the play
and the number macro if you only wish to play the number
itself. You can also use a different macro for playing and nest
the number macro somewhere in it. The number macro has to
have digits at the end, so that the Demon-Dialer knows what to
increment or decrement. The contents of the number macro are
changed by scanning.

It is also possible to use scanning in macro mode by pressing `*
*` for scanning down and `* #` for scanning up. In order to use
this function set up a scan using `^* * *` and switch to macro
mode.

4.11 Power off

If you press `^* ^*` the system will power down after producing
the short down-going sweep. The system also has an automatic
power-down so that you can never leave it on and drain the
batteries.

4.12 Hookswitch Control

See chapter 7 "Demon-Dialer and the outside world"

5 Key programming

Mode 18 is a User Programmable Mode. This means that you
can program a pause, a single tone or a double tone and even a
whole sequence of tones to sound when a key is pressed. Keys
0/9 and ^0/^9 as well as * and # (a total of 22 keys) can be
programmed. To program a key first switch to mode 18 by
pressing `^*^8`. Then type `^*#<key>` where `<key>` is the key to
be programmed. An alert tone will sound if the key is already
programmed. Press # to confirm reprogramming, or any other
key to cancel. You can now enter the data on the first silence
or tone that you wish to attach to that key. Use the following
format:

    <# of tones> <timing type> <time> #(<tone 1 dB level>#
    <tone 1 FIN># [<tone 2 dB level># <tone 2 FIN>#]]

`<# of tones>` 0, 1 or 2 for silence, a single or a double tone. If
you just type a # at this point, you tell the dialer that you are
done programming this key. If you type # as the first tone, it
means that you 'empty' the key.

`<timing type>` Four different timing types can be entered (0
through 3).

0 play fixed time, in this case <time> 1s entered in
milliseconds

1 play while pressed when not used in macro mode, fixed time
in macros. Again, <time> is entered in milliseconds.

2 play template time, in this case <time> is a time-template
riumber (0-7).

3 play while pressed when not used in macro, template time in
macros, <time> is a time-template number (0-7).

The `<dB level>` is entered as a value between 0 and 15, giving
dB levels ranging from 0 to -15 dB of full volume. Presently 4
dB levels are implemented, 0, -6, -10 and -15 dB. If you enter
a different number, the machine will still store it, but rounds
down the value to the nearest implemented value. Future
versions of the Demon-Dialer may contain more possible dB
levels.

The `<FIN>` is a number from the table as described m
Appendix A.

If, after typing the `<timing type>`, an error-tone sounds, then
the memory of the device is full. The sequence you are then
programming is ended and key programming is finished. If
you need more RAM you could consider emptying non-used
keys in mode 18.

5.1 About timing and frequencies in the Demon-Dialer

The Demon-Dialer uses a crystal for its timing and frequency
generation. The tolerance of the used crystal is guaranteed to
be better than 0.01 %. This tolerance affects both timing and
frequency accuracy.

For the Demon-Dialer, a millisecond programmed into the
device is not really 1/1000 of a second. In fact it is 1/1024 of a
second. So if you want 50 ms, you should not type 50, but 51.
The tone will then last 49.8 ms, which is within 0.4 % of the
range. For most if not all of your applications none of this will
make any difference.

Frequencies used in stepping are to the Hertz exact (within the
tolerance of the crystal).

5.2 dB levels and distortion, a little bit of theory

As said, the Demon-Dialer supports a number of different
volumes. Inside your device are sinewave tables, 1 per volume.
Making a double tone you have to make sure that the level of
the combined tones does not exceed 100% of the amplitude
range of the DIA converter that makes the tones. Using 0 dB
means 100% of the amplitude range. -6 dB means 50%, -10 dB
means 32%, -15 dB means 18%. More than 100% causes
distortion, try it for yourself!

If the device is generating a guard-tone, the standard settings
for a played tone are ignored. A single tone is played at -6 dB,
as is the guard tone. A double tone is played at -10 dB each,
and the guard tone is then also played at -10 dB.

6 A few examples ....

If the contents of this manual have utterly confused you, here
are a few examples that may help in understanding all the
functions. These examples were constructed to make use of as
many of the functions in the Demon-Dialer as possible, they
do not necessarily mean anything to the phone system or any
other system for that matter.

6.1 A guard tone while playing macros

In this example we will program a guarded clear forward in a
macro. This means the clear-forward is played together with
the guard-tone.

Type `^* * 3 0 2 #`. This means that we have programmed
guard-tone 0 to FIN 2. This is a RAM FIN which defaults to 0
Hz. We have to set it to something else to use it as a guard
tone.

So now we press `^* * 1 2 # 3125 #`. The system will then play
a quick sample of 3125 Hz as a confirmation. FIN 2, and
therefore guard tone 0 is now programmed to 3125 Hz.

Now go to the macro mode (`^#`). Type `^o` to start programming
macro 0. If something was in macro 0, the device will sound
four beeps to warn you. Pressing # will erase macro 0 and
overwrite it with what you are about to type. If on pressing ·o
only two beeps sounded you start typing right away (do not
press#, for it will end up in the macro).

Press `^* * 4 0` to start the guard tone. This tone will not sound
now, but only once the macro is played. Now press `^* 5` to go
to the C5 mode, and then * to sound a clear forward. Then type
`^* * 5` to end the guard tone. Finish off by typing `^#` followed
by `#` to end macro recording.

Now press 0 to hear your guarded clear-forward.

6.2 Using templates to make an SF (Single Frequency) system

Suppose we want to use a 2280 Hz pulse system that uses 35
ms mark and space timing and 300 ms interdigit delay.

Type `^* * 2 0 35 #` to set time-template 0 (mode 3 mark
timing) to 35 ms. Also type `^* * 2 1 35 #` to set the space
timing to 35 ms as well. Then do `^* * 2 6 300 #` to set the
interdigit time to 300 ms.

Now press `^* * 1 0 2280 #` to program FIN 0 to 2280 Hz. FIN
0 is the mark frequency for this mode. Typing `^* * 1 1 0 #` sets
FIN 1, the space frequency for this mode, to 0 Hz (silence).

Switch to mode 3 by pressing `^* 3` and use!

6.3 Programming the RAM-mode

We will program key 0 in mode 18 to be the following
sequence:

* A dual tone consisting of 1400 and 1700 Hz for 250 milliseconds
* a silence lasting 200 milliseconds
* and finally a single tone of 900 Hz lasting 400 milliseconds.

First go to mode 18 by typing `^* ^8`. Then press: `^* # 0` to start
programming key 0. If an alert (4 beeps) sounds press # to
confirm reprogramming. Then press:

`2 0 250 # 6 # 68 # 6 # 17 # 0 0 200 # 1 0 400 # 0 # 13 # #`.

The spaces are in there for 'easy reading'. The first part means:
program 2 tones of timing type 0 (fixed time) that last 250
milliseconds, the first · one at -6 dB, frequency number 68
(1400 Hz) and the second one also -6d.B, frequency number 17
(1700 Hz). The other two sequences are similar and fairly easy
to understand. If you are done press 0 to hear the key that you
have programmed.

6.4 Macro nesting and scanning

In this example we will scan numbers in C5 with the format
KPl XXX ST. To do this we make two macros. One is called
the 'play macro', it holds the KPl, a reference to the part that
has to be scanned (the number macro) and then an ST.

After typing ^# to get to macro mode press ^0 to record macro
0. If you hear four beeps confirm reprogramming by pressing
#.

Press `^* 5 ^3 ^# 1 ^5 ^# #`

Step by step, this means: switch to mode 5, play a KPl (^3),
nest macro 1 (^# 1), play an ST (^5) and stop recording (^# #).

Then program macro 1 to contain '000' as follows: ^l [#] 000
^## and leave macro mode (#)

Now type `^* * * 0 1 1 #` to scan using macro 0 as play macro,
1 as number macro and a step size of 1. The system will
respond by playing the first sequence (KPl 000 ST). If you
now press 0 you will get KPl 001 ST. If you then press * it
will scan back to KPl 000 ST. If you press star again it will
play KPl 999 ST, which (to this device) is before 000.

7 Demon-Dialer and outside world

You may have noticed the pin called AUX on the PCB of your
Demon-Dialer and the serial connector. The AUX pin is used
to control an external hookswitch relay, with the serial port
you can connect your Demon-Dialer to a computer.

7.1 Hookswitch control

You can use the hookswitch control bit (AUX) to control an
external relay to 'pick up the phone' and you can also pulse-
dial through it. To toggle the hookswitch-control bit press `^* ^#`.

As you have seen in the part about the FIN-table,
programming a frequency of 1 Hz means that the device puts
the external hookswitch control bit in a high position (+5 V), a
frequency of 2 Hz means putting it in a low position (0 V). All
other frequencies will just sound and not affect the hookswitch
bit. If FINs 0 and 1 are at their default values (1 and 2 Hz) then
you can use the external relay to pulse dial in mode 3. Time-
templates 0 and 1 are used for mark and space timing
respectively (default 50 ms). Time-template 6 is used for the
interdigit time (default 500 ms). Please note that the device has
only a 4 position keyboard-buffer so you can easily out-type it
when pulse dialling.

7.2 Serial interface

The serial interface signals are sent asynchronously at a speed
of 16384 bps. The format is 1 start bit, 8 data-bits, no parity, 1
stop-bit. The port is at TTL-level. Most computers will talk to
it as it is. If your computer requires the real RS-232 levels,
appendix A of the construction manual contains a circuit to
convert voltages.

To use the serial interface single byte commands are sent to
the Demon-Dialer. Keys 0-9 are sent as ASCII values 0
through 9 (not the characters, but the values). * is sent as IO,#
as 11. To send shifted keys add 16 to the key code. These keys
are then interpreted as if the user presses the key on the
keyboard and holds it down. To release a key send code 255.
All functions are accessible from the serial port, except for
turning the device on, this has to be done with the shift key on
the device itself.

Apart from these functions, three extra functions have been
incorporated. There is an upload function that lets you read the
contents of all the .relevant RAM in the device to the computer.
Directly after issuing the upload command, ASCII character
'U', the Demon-Dialer sends a stream of bytes. The format of
this data-packet is described in appendix B.

The download is used to put information in the Demon-
Dialer's memory. The data-format is exactly the same as what
the Demon-Dialer uses for the upload function. After sending
the download command, ASCII value 'D', you send the packet
of data as described in Appendix B. The Demon-Dialer does
not do any error-checking on the incoming data. You can
program impossible key or macro combinations which might
cause the device to hang. To un-hang the device, remove the
batteries and power up with the shift key pressed.

If you send an ASCII 'P' to the device, it will respond with a
sequence containing:

* one byte Demon-Dialer Software version `* 100`
* one byte telling how many digits the password consists of
* several bytes containing the key codes for the password

Upload, Download and Password functions will only work
once the password was entered correctly. Once the Demon-
Dialer is powered up you can also enter the password using the
serial interface.


Appendix A

RAM-based FINs
0 - CJ (Mode J) Marie Frequency. Defaults to 2 Hz, meaning off-hook
1 - CJ (Mode J) Space Frequency. Defaults to 1 Hz, meaning on-hook
2 - Special Menu (Mode 7) frequency number 1. Defaults to O Hz
J - Special Menu (Mode 7) frequency number 2. Defaults to 0 Hz
4 ..  Free, no default value
5
6
7
8
9
10
11

ROM-Based FINs
12  - 700 Hz    -- MF
13  - 900 Hz
14  - 1100 Hz
15  - 1300 Hz
16  - 1500 Hz
17  - 1700 Hz
18  - 694.8 Hz     -- DTMF
19  - 770.1 Hz
20  - 852.4 Hz
21  - 940.0 Hz
22  - 1206.0 Hz
23  - 1331.7 Hz
24  - 1486.5 Hz
25  - 1639.0 Hz
26  - 1380 Hz     -- R2 forward
27  - 1500 Hz
28  - 1620 Hz
29  - 1740 Hz
30  - 1860 Hz
31  - 1980 Hz
32  - 1140 Hz     -- R2 backward
33  - 1020 Hz
34  - 900 Hz
35  - 780 Hz
36  - 660 Hz
37  - 540 Hz

38  - 1500 Hz     -- Red
39  - 1700 Hz
40  - 2200 Hz
41  - 1950 Hz   -- ATF1
42  - 2070 Hz
43  - 600 Hz      -- Pliek
44  - 750 Hz
45  - 1200 Hz
46  - 1600 Hz
47  - 1625 Hz
48  - 1700 Hz
49  - 1900 Hz
50  - 2040 Hz
51  - 2100 Hz
52  - 2280 Hz
53  - 2400 Hz
54  - 2500 Hz
55  - 2600 Hz
56  - 3000 Hz
51  - 3350 Hz
58  - 3825 Hz
59  - 147 Hz        -- Call Progress
60  - 350 Hz
61  - 400 Hz
62  - 440 Hz
63  - 450 Hz
64  - 480 Hz
65  - 500 Hz
66  - 620 Hz
67  - 950 Hz        -- SIT
68  - 1400 Hz
69  - 1800 Hz
70  - 1400 Hz      -- Call progress HI
71  - 1850 Hz
72  - 2450 Hz
73  - 2600 Hz
74  - 0 Hz          -- Special
15  - 2000 Hz
76  - 2700 Hz
77  - 150 Hz        Call Progress
78  - 550 Hz       Modem Tone
79  - 853 Hz      EBS
80  - 960 Hz        EBS
81  - 1060 Hz       -- Modem tone
82  - 1270 Hz
83  - 2025 Hz
84  - 2225 Hz
85  - 2713 Hz     Loopback
86  - 2750 Hz       -- Guard
87  - 2800 Hz
88  - 2850 Hz
89  - 2900 Hz
90  - 2950 Hz
91  - 1160 Hz     -- Tone slot
92  - 1530 Hz
93  - 1670 Hz
94  - 1830 Hz

FINs in ascending frequency order

74  - 0 Hz         14  - 1100 Hz          30  - 1860 Hz
59  - 147 Hz       32  - 1140 Hz          49  - 1900 Hz
77  - 150 Hz       91  - 1160 Hz          41  - 1950 Hz
60  - 350 Hz       45  - 1200 Hz          31  - 1980 Hz
61  - 400 Hz       22  - 1206 Hz          15  - 2000 Hz
62  - 440 Hz       82  - 1270 Hz          83  - 2025 Hz
63  - 450 Hz       15  - 1300 Hz          50  - 2040 Hz
64  - 480 Hz       23  - 1331.7 Hz        42  - 2070 Hz
65  - 500 Hz       26  - 1380 Hz          51  - 2100 Hz
37  - 540 Hz       68  - 1400 Hz          40  - 2200 Hz
78  - 550 Hz       70  - 1400 Hz          84  - 2225 Hz
43  - 600 Hz       24  - 1486.5 Hz        52  - 2280 Hz
66  - 620 Hz       16  - 1500 Hz          53  - 2400 Hz
36  - 660 Hz       27  - 1500 Hz          72  - 2450 Hz
18  - 694.8 Hz     38  - 1500 Hz          54  - 2500 Hz
12  - 700 Hz       92  - 1530 Hz          SS  - 2600 Hz
44  - 750 Hz       46  - 1600 Hz          73  - 2600 Hz
19  - 770.1 Hz     28  - 1620 Hz          76  - 2700 Hz
35  - 780 Hz       47  - 1625 Hz          85  - 2713 Hz
20  - 852.4 Hz     25  - 1639 Hz          86  - 2750 Hz
79  - 853 Hz       93  - 1670 Hz          87  - 2800 Hz
13  - 900 Hz       17  - 1700 Hz          88  - 2850 Hz
34  - 900 Hz       39  - 1700 Hz          89  - 2900 Hz
21  - 940 Hz       48  - 1700 Hz          90  - 2950 Hz
67  - 950 Hz       29  - 1740 Hz          56  - 3000 Hz
80  - 960 Hz       69  - 1800 Hz          57  - 3350 Hz
33  - 1020 Hz      94  - 1830 Hz          58  - 3825 Hz
81  - 1060 Hz      71  - 1850 Hz



Appendix B

Serial upload and download format

byte(s)       meaning
0             current mode
1             # of macro keys
2             #of bytes in programmable key area
3-5           guard tones FINs 0,1and2
6-21          time-templates
22-121        key area (always 100 bytes sent)
122-193       macro area
194-207       RAM frequencies

    current mode :
    7 6 5 4 3 2 1 0
    p i o m m m m m

p      - set when password is entered correctly
i      - key is played in macro mode when set
o      - password protection off when set
mmmmm  - current mode (0-19, 20-31 unused)




The guard tones are stored as FINs. Bit 7 of guard 0 set means
a guard tone is played (not necessarily guard tone 0).

The time-templates are 2-byte values MSB first. The value is
stored in ms. (1/1024 seconds actually)

The programmable keys are stored one after each other first 0-
9 then `*` and `#` and finally ^O-^9. The keyarea format for each
tone is:

    7 6 5 4 3 2 1 0
    l n n t t h h h

l   - when set indicates last tone of key, else
      indicates more tones are following
nn  - #oftones(0,1,2)

tt   - 0 means play fixed time hhh=high 3 bits
     - 1 means play while pressed if not in macro, else fixed time
     - 2 means play template time hhh=index
     - 3 means play while pressed if not in macro, else
     template time hhh=index

If fixed time then next byte is lower 8 bits of time in 1/1024
secs If more than one tone then next bytes :

     7 6 5 4 3 2 1 0
     a a a a b b b b
aaaa - dB level tone a
bbbb - dB level tone b

Then for each tone a one byte FIN

This sequence is repeated until all tones of one key are done.

The RAM-frequencies are 2-byte values MSB first. The values
are stored as 8*freq in Hz. So 1000 Hz is stored as 8000.

The macro area is a 72 byte area. It can hold up to 96 macro
entries, which are stored as 6-bit values. The first 6 bit-value is
stored in the 6 LSB of byte 0, the second 6-bit value is stored
in the 2 MSB of byte 0 and the 4 LSB of byte 1, etc.

The macro entries have the following format :

Oskkkk : key code skkkk where
        s = shift and kkkk 4-bit key
        kkkk = 0-11 for non-shifted and 0-9 for shifted
        keys)


001100  : start guard tone 0
001101  : start guard tone l
001110  : start guard tone 2
001111  : stop guard tone


lmrnmrnm  : ifO <<= rnmrnmrnm <<= 19 sets mode mrnmrnm
           if 20 <<= mrnmmm <<= 29 nests macro mmmmm-20
111111    : end of macro



Appendix C

Mode 0, DTMF (default)

The tones in the right hand column are commonly referred to
as A, B, C and D. In military networks they are Flash
Override, Flash, Immediate and Priority. The keys are played
while pressed, in macros the mark is time-template 0, the space
is time-template 1. These timings are also used in C3 / Pulse
Dial. The tones are slightly off from the specified frequency to
match those produced by the popular 5089 DTMF chip.

        1206.0 1331.7 1486.5 1639.0
694.8     1      2      3      ^1 (A)
770.1     4      5      6      ^2 (B)
852.4     7      8      9      ^3 (C)
940.0     *      0      #      ^4 (D)

Mode 1, ATFl (B-netz)

This standard uses a 100 baud FSK modulated signal, using
1950 Hz as '1' and 2070 Hz as 'O'. The start is preceded by a
600 millisecond preamble of 2070 Hz. The keys are defined as
follows:

`*` (start) 01110 01000100010
`#`(stop) 01110 10000100001
^0 (cancel) 01110 10101010101
0 01110 11000 0 0001
1 01110 10100 0 00101
2 01110 10010 0 01001
3 01110 10001 0 10001
4 01110 01100 000110
5 01110 01010 0 01010
6 01110 01001 0 10010
7 01110 00110 0 01100
8 01110 00101 0 10100
9 0111000011011000


Mode 2, R2-forward

Key is played while pressed, in macro mode, each key is
played for the duration of time-template 2, and then a pause of
time-template 3 follows . Both time-templates are also used as
the mark and space timing ofC5. They both default to 50 ms.

1    1380    1500
2    1380    1620
3    1500    1620
4    1380    1740
5    1500    1740
6    1620    1740
7    1380    1860
8    1500    1860
9    1620    1860
0    1740    1860
^1   1380    1980
^2   1500    1980
^3   1620    1980
^4   1740    1980
^5   1860    1980

Mode 3, C3/pulse dial

This mode is very flexible: signal is pulsed, mark and space
timing of pulses are stored in time-templates 0 and 1. They
both default to 50 ms. This timing is also used for the DTMF
mark and space.

The mark tone is stored in RAM-frequency 0 and the space is
RAM-frequency 1. The space defaults to 2 Hz, which has a
special meaning, it means the external relay is off-hook. The
mark defaults to 1 Hz, which means on-hook. The interdigit
delay is set in time-template 6, it defaults to 500 ms.

Mode4, C4

All digit signals have 3S ms pauses between the tones,
interdigit delay is 100 ms.

x    = 2040, 3S ms
y    = 2400, 3S ms
X    = 2040, 100 ms
Y    = 2400, 100 ms
XX   = 2040, 350 ms
YY   = 2400, 350 ms
P    = 2040 + 2400, 150 ms

Clear Forward PXX *
Transit Seizure PX ^7
Forward Transfer PYY ^9
Terminal Seize PY #
1  yyyx
2  yyxy
3  yyxx
4  yxyy
s  yxyx
6  yxxy
7  yxxx
8  xyyy



9   xyyx
0   xyxy
11  ^1  xyxx
12  ^2  xxyy
13  ^3  xxyx
14  ^4  xxxy
lS  ^s  xxxx
16  ^6  YYYY

Mode 5, c5

Digits are played while pressed, in macros they last for the
duration of time-template 2, followed by a pause of time-
template 3. In CS Al is called 'Code 11', ^2 is called 'Code 12',
^3 is 'KPl ', ^4 is 'KP2' and AS is 'ST. ^6 lasts 500 ms, ^7 is
120 ms, AS is 120 ms, ^9 is 240 ms and ^0 is a silence of 50
ms. * is called clear forward and lasts l 7S ms. #is called seize
and lasts 300 ms.


1  700  900         ^1  700  1700
2  700  1100        ^2  900  1700
3  900  1100        ^3  1100  1700
4  700  1300        ^4  1300  1700
5  900  1300        ^5  1500  1700
6  1100  1300       ^6  2600
7  700  1500        ^7  2400  2600
8  900  1500        ^s 2400
9  1100  1500       ^9 2400
0  1300  1500       ^0 0
*  2400  2600       # 2400



Mode 6, redbox

These tones are used for payphone coin signalling in North
America. There are three types of tones for different systems
and three types of cadences for the coins.

Tones:

ACTS 1700 2200
IPTS 1500 2200
non ACTS 2200

Cadences:

0.05 = 60 ms on
0.10 = 60 ms on, 60 ms off, 60 ms on
0.25 = 5 x (35 ms on, 35 ms oft)

Key Layout:

       $0.05 $0.10 $0.25
ACTS     1     2     3
IPTS     4     5     6
non ACTS 7     8     9


Mode 7, line signalling menu

This mode contains several line signalling tones from various
systems, the * and # keys are user programmable. All
frequencies are played while pressed, In Macro mode they will
sound for 50 ms (not shifted) and 10 ms (shifted). In macro
mode * is always 50 ms and# is always 10 ms.

1 = 2400 + 2600 Hz
2 = 2400 Hz
3 = 2600 Hz
4 = 2040 + 2400 Hz
5 = 2280 Hz
6 = 3000 Hz
7 = 1700 Hz
8 = 1900 Hz
9 = 2500 Hz
0 = silent
`*` = RAM freq. #2 + #3 (50 ms)
`#` = RAM freq. #2 + #3 (10 ms)

Mode 8, tone-slot

Each tone is 70 ms. No pause between tones when in macro.
1 = 1060 Hz
2 = 1160 Hz
3 = 1270 Hz
4 = 1400 Hz
5 = 1530 Hz
6 = 1670 Hz
7 = 1830 Hz
8 = 2000 Hz
9 = 2200 Hz
0 = 2400 Hz
* = 2600 Hz (separator)

Mode 12 (^2), R2-backward

Key is played while pressed, in macro mode, each key is
played for the duration of time-template 2, and then a pause of
time-template 3 follows. Both time-templates are also used as
the mark and space timing of CS. They both default to 50 ms.

1 1140  1020
2 1140  900
3 1020  900
4 1140  780
5 1020  780
6 900  780
7 1140  660
8 1020  660
9 900  660
0 780  660
^1 1140  540
^2 1020  540
^3 900  540
^4 780  540
^s 660  540

Mode 18 (^8), user programmable mode

This mode is user programmable. The data is stored in 100
bytes in the format listed in Appendix B. See section 5 of this
manual for more details on how to program the keys.


