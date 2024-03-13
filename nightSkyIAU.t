#charset "us-ascii"
//
// nightSkyIAU.t
//
//	Data for the nightSky module.
//
//	This provides the RA and DEC for the IAU designated constellations
//	plus M45 (the Pleiades).
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

iauConstellations: NightSkyCatalog 'iau' 'IAU Designated Constellations';
+Ephem 'Andromeda' 'And' ra = 1 dec = 37;
+Ephem 'Antlia' 'Ant' ra = 10 dec = -32;
+Ephem 'Apus' 'Aps' ra = 16 dec = -75;
+Ephem 'Aquarius' 'Aqr' ra = 22 dec = -9;
+Ephem 'Aquila' 'Aql' ra = 20 dec = 3;
+Ephem 'Ara' 'Ara' ra = 17 dec = -55;
+Ephem 'Aries' 'Ari' ra = 3 dec = 21;
+Ephem 'Auriga' 'Aur' ra = 6 dec = 42;
+Ephem 'Bootes' 'Boo' ra = 15 dec = 31;
+Ephem 'Caelum' 'Cae' ra = 5 dec = -36;
+Ephem 'Camelopardalis' 'Cam' ra = 9 dec = 69;
+Ephem 'Cancer' 'Cnc' ra = 9 dec = 20;
+Ephem 'Canes Venatici' 'CVn' ra = 13 dec = 40;
+Ephem 'Canis Major' 'CMa' ra = 7 dec = -22;
+Ephem 'Canis Minor' 'CMi' ra = 8 dec = 6;
+Ephem 'Capricornus' 'Cap' ra = 21 dec = -18;
+Ephem 'Carina' 'Car' ra = 9 dec = -63;
+Ephem 'Cassiopeia' 'Cas' ra = 1 dec = 62;
+Ephem 'Centaurus' 'Cen' ra = 13 dec = -47;
+Ephem 'Cepheus' 'Cep' ra = 3 dec = 71;
+Ephem 'Cetus' 'Cet' ra = 2 dec = -7;
+Ephem 'Chamaeleon' 'Cha' ra = 11 dec = -79;
+Ephem 'Circinus' 'Cir' ra = 15 dec = -63;
+Ephem 'Columba' 'Col' ra = 6 dec = -35;
+Ephem 'Coma Berenices' 'Com' ra = 13 dec = 23;
+Ephem 'Corona Australis' 'CrA' ra = 19 dec = -41;
+Ephem 'Corona Borealis' 'CrB' ra = 16 dec = 33;
+Ephem 'Corvus' 'Crv' ra = 12 dec = -18;
+Ephem 'Crater' 'Crt' ra = 11 dec = -14;
+Ephem 'Crux' 'Cru' ra = 12 dec = -60;
+Ephem 'Cygnus' 'Cyg' ra = 21 dec = 45;
+Ephem 'Delphinus' 'Del' ra = 21 dec = 12;
+Ephem 'Dorado' 'Dor' ra = 5 dec = -59;
+Ephem 'Draco' 'Dra' ra = 15 dec = 67;
+Ephem 'Equuleus' 'Equ' ra = 21 dec = 8;
+Ephem 'Eridanus' 'Eri' ra = 3 dec = -27;
+Ephem 'Fornax' 'For' ra = 3 dec = -30;
+Ephem 'Gemini' 'Gem' ra = 7 dec = 23;
+Ephem 'Grus' 'Gru' ra = 22 dec = -46;
+Ephem 'Hercules' 'Her' ra = 17 dec = 27;
+Ephem 'Horologium' 'Hor' ra = 3 dec = -53;
+Ephem 'Hydra' 'Hya' ra = 12 dec = -13;
+Ephem 'Hydrus' 'Hyi' ra = 2 dec = -68;
+Ephem 'Indus' 'Ind' ra = 22 dec = -58;
+Ephem 'Lacerta' 'Lac' ra = 22 dec = 46;
+Ephem 'Leo' 'Leo' ra = 11 dec = 13;
+Ephem 'Leo Minor' 'LMi' ra = 10 dec = 32;
+Ephem 'Lepus' 'Lep' ra = 6 dec = -19;
+Ephem 'Libra' 'Lib' ra = 15 dec = -15;
+Ephem 'Lupus' 'Lup' ra = 15 dec = -41;
+Ephem 'Lynx' 'Lyn' ra = 8 dec = 47;
+Ephem 'Lyra' 'Lyr' ra = 19 dec = 37;
+Ephem 'Mensa' 'Men' ra = 5 dec = -76;
+Ephem 'Microscopium' 'Mic' ra = 21 dec = -36;
+Ephem 'Monoceros' 'Mon' ra = 7 dec = 0;
+Ephem 'Musca' 'Mus' ra = 13 dec = -70;
+Ephem 'Norma' 'Nor' ra = 16 dec = -51;
+Ephem 'Octans' 'Oct' ra = 23 dec = -82;
+Ephem 'Ophiuchus' 'Oph' ra = 17 dec = -6;
+Ephem 'Orion' 'Ori' ra = 6 dec = 6;
+Ephem 'Pavo' 'Pav' ra = 20 dec = -64;
+Ephem 'Pegasus' 'Peg' ra = 23 dec = 19;
+Ephem 'Perseus' 'Per' ra = 3 dec = 45;
+Ephem 'Phoenix' 'Phe' ra = 1 dec = -47;
+Ephem 'Pictor' 'Pic' ra = 6 dec = -53;
+Ephem 'Pisces' 'Psc' ra = 0 dec = 14;
+Ephem 'Piscis Austrinus' 'PsA' ra = 22 dec = -29;
+Ephem 'Puppis' 'Pup' ra = 7 dec = -31;
+Ephem 'Pyxis' 'Pyx' ra = 9 dec = -27;
+Ephem 'Reticulum' 'Ret' ra = 4 dec = -58;
+Ephem 'Sagitta' 'Sge' ra = 20 dec = 19;
+Ephem 'Sagittarius' 'Sgr' ra = 19 dec = -28;
+Ephem 'Scorpius' 'Sco' ra = 17 dec = -27;
+Ephem 'Sculptor' 'Scl' ra = 0 dec = -32;
+Ephem 'Scutum' 'Sct' ra = 19 dec = -8;
+Ephem 'Serpens (Caput)' 'Ser' ra = 16 dec = 11;
+Ephem 'Serpens (Cauda)' 'Ser' ra = 18 dec = -3;
+Ephem 'Sextans' 'Sex' ra = 10 dec = -1;
+Ephem 'Taurus' 'Tau' ra = 5 dec = 15;
+Ephem 'Telescopium' 'Tel' ra = 19 dec = -51;
+Ephem 'Triangulum' 'Tri' ra = 2 dec = 31;
+Ephem 'Triangulum Australe' 'TrA' ra = 16 dec = -65;
+Ephem 'Tucana' 'Tuc' ra = 24 dec = -64;
+Ephem 'Ursa Major' 'UMa' ra = 11 dec = 51;
+Ephem 'Ursa Minor' 'UMi' ra = 15 dec = 78;
+Ephem 'Vela' 'Vel' ra = 10 dec = -47;
+Ephem 'Virgo' 'Vir' ra = 13 dec = -4;
+Ephem 'Volans' 'Vol' ra = 8 dec = -68;
+Ephem 'Vulpecula' 'Vul' ra = 20 dec = 24;
+Ephem 'Pleiades' 'M45' ra = 4 dec = 24;
+EphemOrder [ 'Orion', 'Ursa Major', 'Cassiopeia', 'Cygnus', 'Leo',
	'Canis Major', 'Aquarius', 'Gemini', 'Pisces', 'Aries',
	'Aquila', 'Bootes', 'Libra', 'Lyra', 'Pegasus', 'Perseus',
	'Sagittarius', 'Serpens (Caput)', 'Serpens (Cauda)',
	'Scorpius', 'Taurus', 'Virgo', 'Pleadies', 'Andromeda', 'Aquarius',
	'Cancer', 'Capricornus', 'Cepheus', 'Draco' ];
