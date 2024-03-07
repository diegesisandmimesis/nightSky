#charset "us-ascii"
//
// nightSkyData.t
//
//	Data for the nightSky module.
//
//	This provides the RA and DEC for the IAU designated constellations
//	plus M45 (the Pleiades).
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

modify NightSky
	_constellations = static [
		[ 'Andromeda', 'And', 1, 37, true ],
		[ 'Antlia', 'Ant', 10, -32, nil ],
		[ 'Apus', 'Aps', 16, -75, nil ],
		[ 'Aquarius', 'Aqr', 22, -9, true ],
		[ 'Aquila', 'Aql', 20, 3, true ],
		[ 'Ara', 'Ara', 17, -55, nil ],
		[ 'Aries', 'Ari', 3, 21, true ],
		[ 'Auriga', 'Aur', 6, 42, nil ],
		[ 'Bootes', 'Boo', 15, 31, true ],
		[ 'Caelum', 'Cae', 5, -36, nil ],
		[ 'Camelopardalis', 'Cam', 9, 69, nil ],
		[ 'Cancer', 'Cnc', 9, 20, true ],
		[ 'Canes Venatici', 'CVn', 13, 40, nil ],
		[ 'Canis Major', 'CMa', 7, -22, true ],
		[ 'Canis Minor', 'CMi', 8, 6, true ],
		[ 'Capricornus', 'Cap', 21, -18, true ],
		[ 'Carina', 'Car', 9, -63, nil ],
		[ 'Cassiopeia', 'Cas', 1, 62, true ],
		[ 'Centaurus', 'Cen', 13, -47, nil ],
		[ 'Cepheus', 'Cep', 3, 71, true ],
		[ 'Cetus', 'Cet', 2, -7, nil ],
		[ 'Chamaeleon', 'Cha', 11, -79, nil ],
		[ 'Circinus', 'Cir', 15, -63, nil ],
		[ 'Columba', 'Col', 6, -35, nil ],
		[ 'Coma Berenices', 'Com', 13, 23, nil ],
		[ 'Corona Australis', 'CrA', 19, -41, nil ],
		[ 'Corona Borealis', 'CrB', 16, 33, nil ],
		[ 'Corvus', 'Crv', 12, -18, nil ],
		[ 'Crater', 'Crt', 11, -14, nil ],
		[ 'Crux', 'Cru', 12, -60, nil ],
		[ 'Cygnus', 'Cyg', 21, 45, true ],
		[ 'Delphinus', 'Del', 21, 12, nil ],
		[ 'Dorado', 'Dor', 5, -59, nil ],
		[ 'Draco', 'Dra', 15, 67, true ],
		[ 'Equuleus', 'Equ', 21, 8, nil ],
		[ 'Eridanus', 'Eri', 3, -27, nil ],
		[ 'Fornax', 'For', 3, -30, nil ],
		[ 'Gemini', 'Gem', 7, 23, true ],
		[ 'Grus', 'Gru', 22, -46, nil ],
		[ 'Hercules', 'Her', 17, 27, nil ],
		[ 'Horologium', 'Hor', 3, -53, nil ],
		[ 'Hydra', 'Hya', 12, -13, nil ],
		[ 'Hydrus', 'Hyi', 2, -68, nil ],
		[ 'Indus', 'Ind', 22, -58, nil ],
		[ 'Lacerta', 'Lac', 22, 46, nil ],
		[ 'Leo', 'Leo', 11, 13, true ],
		[ 'Leo Minor', 'LMi', 10, 32, nil ],
		[ 'Lepus', 'Lep', 6, -19, nil ],
		[ 'Libra', 'Lib', 15, -15, true ],
		[ 'Lupus', 'Lup', 15, -41, nil ],
		[ 'Lynx', 'Lyn', 8, 47, nil ],
		[ 'Lyra', 'Lyr', 19, 37, true ],
		[ 'Mensa', 'Men', 5, -76, nil ],
		[ 'Microscopium', 'Mic', 21, -36, nil ],
		[ 'Monoceros', 'Mon', 7, 0, nil ],
		[ 'Musca', 'Mus', 13, -70, nil ],
		[ 'Norma', 'Nor', 16, -51, nil ],
		[ 'Octans', 'Oct', 23, -82, nil ],
		[ 'Ophiuchus', 'Oph', 17, -6, nil ],
		[ 'Orion', 'Ori', 6, 6, true ],
		[ 'Pavo', 'Pav', 20, -64, nil ],
		[ 'Pegasus', 'Peg', 23, 19, true ],
		[ 'Perseus', 'Per', 3, 45, nil ],
		[ 'Phoenix', 'Phe', 1, -47, nil ],
		[ 'Pictor', 'Pic', 6, -53, nil ],
		[ 'Pisces', 'Psc', 0, 14, true ],
		[ 'Piscis Austrinus', 'PsA', 22, -29, nil ],
		[ 'Puppis', 'Pup', 7, -31, nil ],
		[ 'Pyxis', 'Pyx', 9, -27, nil ],
		[ 'Reticulum', 'Ret', 4, -58, nil ],
		[ 'Sagitta', 'Sge', 20, 19, nil ],
		[ 'Sagittarius', 'Sgr', 19, -28, true ],
		[ 'Scorpius', 'Sco', 17, -27, true ],
		[ 'Sculptor', 'Scl', 0, -32, nil ],
		[ 'Scutum', 'Sct', 19, -8, nil ],
		[ 'Serpens (Caput)', 'Ser', 16, 11, true ],
		[ 'Serpens (Cauda)', 'Ser', 18, -3, true ],
		[ 'Sextans', 'Sex', 10, -1, nil ],
		[ 'Taurus', 'Tau', 5, 15, true ],
		[ 'Telescopium', 'Tel', 19, -51, nil ],
		[ 'Triangulum', 'Tri', 2, 31, nil ],
		[ 'Triangulum Australe', 'TrA', 16, -65, nil ],
		[ 'Tucana', 'Tuc', 24, -64, nil ],
		[ 'Ursa Major', 'UMa', 11, 51, true ],
		[ 'Ursa Minor', 'UMi', 15, 78, nil ],
		[ 'Vela', 'Vel', 10, -47, nil ],
		[ 'Virgo', 'Vir', 13, -4, true ],
		[ 'Volans', 'Vol', 8, -68, nil ],
		[ 'Vulpecula', 'Vul', 20, 24, nil ],
		[ 'Pleiades', 'M45', 4, 24, true ]
	]
;