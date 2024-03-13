#charset "us-ascii"
//
// nightSkyStars.t
//
//	A little toy bright star catalog consisting of the 52 brightest
//	stars (in apparent visual magnitude).
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

brightStars: NightSkyCatalog 'stars' 'Arbitrary Bright Star Catalog';
+Ephem 'Sirius' 'a' ra = 7 dec = -16 order = 1;
+Ephem 'Canopus' 'b' ra = 6 dec = -52 order = 2;
+Ephem 'Rigil Kentaurus' 'c' ra = 15 dec = -60 order = 3;
+Ephem 'Arcturus' 'd' ra = 14 dec = 19 order = 4;
+Ephem 'Vega' 'e' ra = 19 dec = 38 order = 5;
+Ephem 'Capella' 'f' ra = 5 dec = 46 order = 6;
+Ephem 'Rigel' 'g' ra = 5 dec = -8 order = 7;
+Ephem 'Procyon' 'h' ra = 8 dec = 5 order = 8;
+Ephem 'Achernar' 'i' ra = 2 dec = -57 order = 9;
+Ephem 'Betelgeuse' 'j' ra = 6 dec = 7 order = 10;
+Ephem 'Hadar' 'k' ra = 14 dec = -60 order = 11;
+Ephem 'Altair' 'l' ra = 20 dec = 8 order = 12;
+Ephem 'Acrux' 'm' ra = 12 dec = -63 order = 13;
+Ephem 'Aldebaran' 'n' ra = 5 dec = 16 order = 14;
+Ephem 'Antares' 'o' ra = 16 dec = -26 order = 15;
+Ephem 'Spica' 'p' ra = 13 dec = -11 order = 16;
+Ephem 'Pollux' 'q' ra = 8 dec = 28 order = 17;
+Ephem 'Fomalhaut' 'r' ra = 23 dec = -29 order = 18;
+Ephem 'Deneb' 's' ra = 21 dec = 45 order = 19;
+Ephem 'Mimosa' 't' ra = 13 dec = -59 order = 20;
+Ephem 'Regulus' 'u' ra = 10 dec = 12 order = 21;
+Ephem 'Adhara' 'v' ra = 7 dec = -29 order = 22;
+Ephem 'Castor' 'w' ra = 8 dec = 31 order = 23;
+Ephem 'Shaula' 'x' ra = 18 dec = -37 order = 24;
+Ephem 'Gacrux' 'y' ra = 13 dec = -57 order = 25;
+Ephem 'Bellatrix' 'z' ra = 5 dec = 6 order = 26;
+Ephem 'Elnath' 'A' ra = 5 dec = 28 order = 27;
+Ephem 'Miaplacidus' 'B' ra = 9 dec = -69 order = 28;
+Ephem 'Alnilam' 'C' ra = 6 dec = -1 order = 29;
+Ephem 'Alnair' 'D' ra = 22 dec = -47 order = 30;
+Ephem 'Alnitak' 'E' ra = 6 dec = -1 order = 31;
+Ephem 'Alioth' 'F' ra = 13 dec = 56 order = 32;
+Ephem 'Mirfak' 'G' ra = 3 dec = 49 order = 33;
+Ephem 'Dubhe' 'H' ra = 11 dec = 61 order = 34;
+Ephem 'Regor' 'I' ra = 8 dec = -47 order = 35;
+Ephem 'Wezen' 'J' ra = 7 dec = -26 order = 36;
+Ephem 'Kaus Australis' 'K' ra = 18 dec = -34 order = 37;
+Ephem 'Alkaid' 'L' ra = 14 dec = 49 order = 38;
+Ephem 'Sargas' 'M' ra = 18 dec = -43 order = 39;
+Ephem 'Avior' 'N' ra = 8 dec = -59 order = 40;
+Ephem 'Menkalinan' 'O' ra = 6 dec = 44 order = 41;
+Ephem 'Atria' 'P' ra = 17 dec = -69 order = 42;
+Ephem 'Alhena' 'Q' ra = 7 dec = 16 order = 43;
+Ephem 'Peacock' 'R' ra = 20 dec = -56 order = 44;
+Ephem 'Koo She' 'S' ra = 9 dec = -54 order = 45;
+Ephem 'Mirzam' 'T' ra = 6 dec = -18 order = 46;
+Ephem 'Alphard' 'U' ra = 9 dec = -8 order = 47;
+Ephem 'Polaris' 'V' ra = 3 dec = 89 order = 48;
+Ephem 'Algieba' 'W' ra = 10 dec = 19 order = 49;
+Ephem 'Hamal' 'X' ra = 2 dec = 23 order = 50;
+Ephem 'Diphda' 'Y' ra = 1 dec = -18 order = 51;
+Ephem 'Nunki' 'Z' ra = 19 dec = -26 order = 52;
