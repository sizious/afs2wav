ADXUtil V1.0

Copyright 1997-2002 Jefferson Leandro Ramos Ricci aka Verdi Kasugano
(verdi@kasugano.cjb.net) / Brazil

Freeware program, leasing or sold is not allowed

"README's is not my passion" ! ;)

The purpose of this program is just search ADX(c) samples on files such as
AFS archive or a single file. Extract and convert to WAVE format if desired.

ADX - Sound format used on DreamCast(tm) games
AFS - Several data types compiled in one archive, ADX is one of formats


Usage:

  ADXUtil <file> [-all] [-wave]

* "-all" option is optional, the program extract all data in archive, not
  only ADX samples. Unless this option is given, the program only extract
  ADX's samples. I seen some archives containing some dummy ADX's samples.
  These "dummy's" is only extracted with the "-all" option. Other data is
  extracted with "RAW" extension.

* "-wave" option tell to program to convert "on the fly" the ADX sample
  extracted to WAVE format. You can play these files with any player such
  Windows Media Player(tm) or Winamp(tm). Dummy ADX are not converted, if
  "-all" option is present, the files is just extracted as ADX.

Examples:

  ADXUtil bomber.afs -wave
    (Extract and convert ADX samples of archive "bomber.afs")

  ADXUtil *.* -wave
    (Search every file for ADX samples, extract and convert when found)

  ADXUtil bomber.afs -all
    (Extract every data of "bomber.afs", don't convert any ADX)

  "The rest are self-explanatory"

* Files extracted of AFS archives are in sequences like as "BOMBER_00000"

* The program uses LFN (long filenames) functions, use the program with
  running Win9X(tm) or compatible system

* Do not distribute illegal data, is dangerous for you !


Changes since V0.2

  * Renamed AFS->ADX to ADXUtil ;)
  * Ported to DJGPP compiler
  * Convert ADX to WAV on extracting (based on BERO's source code)
  * Search single files
  * Small fixes

Changes since V0.1

  * Wildcards accepted
  * Fixed bug in detecting ADX sample


Any bugs ??? Email-me !

Thanks / Credits (no implicit order)
------------------------------------

* MegaGames for hosting my program
  http://www.megagames.com

* Delorie for DJGPP
  http://www.delorie.com

* Markus Oberhumer & Laszlo Molnar for UPX
  http://upx.sourceforge.net

* BERO to release source code of adx2wav
  http://www.geocities.co.jp/Playtown/2004/

Copyrights
----------
Windows(tm) / MS Media Player <-> Microsoft Corporation
Dreamcast(tm) <-> SEGA
Winamp(tm) <-> NullSoft
ADX <-> CRI (???)
AFS <-> (???) "unsure"

The author can't be responsible for wrong use of this program !

<eof>


