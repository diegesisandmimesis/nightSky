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
		object: Ephem {
			name = 'Andromeda'
			abbr = 'And'
			ra = 1
			dec = 37
			major = true
		},
		object: Ephem {
			name = 'Antlia'
			abbr = 'Ant'
			ra = 10
			dec = -32
		},
		object: Ephem {
			name = 'Apus'
			abbr = 'Aps'
			ra = 16
			dec = -75
		},
		object: Ephem {
			name = 'Aquarius'
			abbr = 'Aqr'
			ra = 22
			dec = -9
			major = true
		},
		object: Ephem {
			name = 'Aquila'
			abbr = 'Aql'
			ra = 20
			dec = 3
			major = true
		},
		object: Ephem {
			name = 'Ara'
			abbr = 'Ara'
			ra = 17
			dec = -55
		},
		object: Ephem {
			name = 'Aries'
			abbr = 'Ari'
			ra = 3
			dec = 21
			major = true
		},
		object: Ephem {
			name = 'Auriga'
			abbr = 'Aur'
			ra = 6
			dec = 42
		},
		object: Ephem {
			name = 'Bootes'
			abbr = 'Boo'
			ra = 15
			dec = 31
			major = true
		},
		object: Ephem {
			name = 'Caelum'
			abbr = 'Cae'
			ra = 5
			dec = -36
		},
		object: Ephem {
			name = 'Camelopardalis'
			abbr = 'Cam'
			ra = 9
			dec = 69
		},
		object: Ephem {
			name = 'Cancer'
			abbr = 'Cnc'
			ra = 9
			dec = 20
			major = true
		},
		object: Ephem {
			name = 'Canes Venatici'
			abbr = 'CVn'
			ra = 13
			dec = 40
		},
		object: Ephem {
			name = 'Canis Major'
			abbr = 'CMa'
			ra = 7
			dec = -22
			major = true
		},
		object: Ephem {
			name = 'Canis Minor'
			abbr = 'CMi'
			ra = 8
			dec = 6
		},
		object: Ephem {
			name = 'Capricornus'
			abbr = 'Cap'
			ra = 21
			dec = -18
			major = true
		},
		object: Ephem {
			name = 'Carina'
			abbr = 'Car'
			ra = 9
			dec = -63
		},
		object: Ephem {
			name = 'Cassiopeia'
			abbr = 'Cas'
			ra = 1
			dec = 62
			major = true
		},
		object: Ephem {
			name = 'Centaurus'
			abbr = 'Cen'
			ra = 13
			dec = -47
		},
		object: Ephem {
			name = 'Cepheus'
			abbr = 'Cep'
			ra = 3
			dec = 71
			major = true
		},
		object: Ephem {
			name = 'Cetus'
			abbr = 'Cet'
			ra = 2
			dec = -7
		},
		object: Ephem {
			name = 'Chamaeleon'
			abbr = 'Cha'
			ra = 11
			dec = -79
		},
		object: Ephem {
			name = 'Circinus'
			abbr = 'Cir'
			ra = 15
			dec = -63
		},
		object: Ephem {
			name = 'Columba'
			abbr = 'Col'
			ra = 6
			dec = -35
		},
		object: Ephem {
			name = 'Coma Berenices'
			abbr = 'Com'
			ra = 13
			dec = 23
		},
		object: Ephem {
			name = 'Corona Australis'
			abbr = 'CrA'
			ra = 19
			dec = -41
		},
		object: Ephem {
			name = 'Corona Borealis'
			abbr = 'CrB'
			ra = 16
			dec = 33
		},
		object: Ephem {
			name = 'Corvus'
			abbr = 'Crv'
			ra = 12
			dec = -18
		},
		object: Ephem {
			name = 'Crater'
			abbr = 'Crt'
			ra = 11
			dec = -14
		},
		object: Ephem {
			name = 'Crux'
			abbr = 'Cru'
			ra = 12
			dec = -60
		},
		object: Ephem {
			name = 'Cygnus'
			abbr = 'Cyg'
			ra = 21
			dec = 45
			major = true
		},
		object: Ephem {
			name = 'Delphinus'
			abbr = 'Del'
			ra = 21
			dec = 12
		},
		object: Ephem {
			name = 'Dorado'
			abbr = 'Dor'
			ra = 5
			dec = -59
		},
		object: Ephem {
			name = 'Draco'
			abbr = 'Dra'
			ra = 15
			dec = 67
			major = true
		},
		object: Ephem {
			name = 'Equuleus'
			abbr = 'Equ'
			ra = 21
			dec = 8
		},
		object: Ephem {
			name = 'Eridanus'
			abbr = 'Eri'
			ra = 3
			dec = -27
		},
		object: Ephem {
			name = 'Fornax'
			abbr = 'For'
			ra = 3
			dec = -30
		},
		object: Ephem {
			name = 'Gemini'
			abbr = 'Gem'
			ra = 7
			dec = 23
			major = true
		},
		object: Ephem {
			name = 'Grus'
			abbr = 'Gru'
			ra = 22
			dec = -46
		},
		object: Ephem {
			name = 'Hercules'
			abbr = 'Her'
			ra = 17
			dec = 27
		},
		object: Ephem {
			name = 'Horologium'
			abbr = 'Hor'
			ra = 3
			dec = -53
		},
		object: Ephem {
			name = 'Hydra'
			abbr = 'Hya'
			ra = 12
			dec = -13
		},
		object: Ephem {
			name = 'Hydrus'
			abbr = 'Hyi'
			ra = 2
			dec = -68
		},
		object: Ephem {
			name = 'Indus'
			abbr = 'Ind'
			ra = 22
			dec = -58
		},
		object: Ephem {
			name = 'Lacerta'
			abbr = 'Lac'
			ra = 22
			dec = 46
		},
		object: Ephem {
			name = 'Leo'
			abbr = 'Leo'
			ra = 11
			dec = 13
			major = true
		},
		object: Ephem {
			name = 'Leo Minor'
			abbr = 'LMi'
			ra = 10
			dec = 32
		},
		object: Ephem {
			name = 'Lepus'
			abbr = 'Lep'
			ra = 6
			dec = -19
		},
		object: Ephem {
			name = 'Libra'
			abbr = 'Lib'
			ra = 15
			dec = -15
			major = true
		},
		object: Ephem {
			name = 'Lupus'
			abbr = 'Lup'
			ra = 15
			dec = -41
		},
		object: Ephem {
			name = 'Lynx'
			abbr = 'Lyn'
			ra = 8
			dec = 47
		},
		object: Ephem {
			name = 'Lyra'
			abbr = 'Lyr'
			ra = 19
			dec = 37
			major = true
		},
		object: Ephem {
			name = 'Mensa'
			abbr = 'Men'
			ra = 5
			dec = -76
		},
		object: Ephem {
			name = 'Microscopium'
			abbr = 'Mic'
			ra = 21
			dec = -36
		},
		object: Ephem {
			name = 'Monoceros'
			abbr = 'Mon'
			ra = 7
			dec = 0
		},
		object: Ephem {
			name = 'Musca'
			abbr = 'Mus'
			ra = 13
			dec = -70
		},
		object: Ephem {
			name = 'Norma'
			abbr = 'Nor'
			ra = 16
			dec = -51
		},
		object: Ephem {
			name = 'Octans'
			abbr = 'Oct'
			ra = 23
			dec = -82
		},
		object: Ephem {
			name = 'Ophiuchus'
			abbr = 'Oph'
			ra = 17
			dec = -6
		},
		object: Ephem {
			name = 'Orion'
			abbr = 'Ori'
			ra = 6
			dec = 6
			major = true
		},
		object: Ephem {
			name = 'Pavo'
			abbr = 'Pav'
			ra = 20
			dec = -64
		},
		object: Ephem {
			name = 'Pegasus'
			abbr = 'Peg'
			ra = 23
			dec = 19
			major = true
		},
		object: Ephem {
			name = 'Perseus'
			abbr = 'Per'
			ra = 3
			dec = 45
		},
		object: Ephem {
			name = 'Phoenix'
			abbr = 'Phe'
			ra = 1
			dec = -47
		},
		object: Ephem {
			name = 'Pictor'
			abbr = 'Pic'
			ra = 6
			dec = -53
		},
		object: Ephem {
			name = 'Pisces'
			abbr = 'Psc'
			ra = 0
			dec = 14
			major = true
		},
		object: Ephem {
			name = 'Piscis Austrinus'
			abbr = 'PsA'
			ra = 22
			dec = -29
		},
		object: Ephem {
			name = 'Puppis'
			abbr = 'Pup'
			ra = 7
			dec = -31
		},
		object: Ephem {
			name = 'Pyxis'
			abbr = 'Pyx'
			ra = 9
			dec = -27
		},
		object: Ephem {
			name = 'Reticulum'
			abbr = 'Ret'
			ra = 4
			dec = -58
		},
		object: Ephem {
			name = 'Sagitta'
			abbr = 'Sge'
			ra = 20
			dec = 19
		},
		object: Ephem {
			name = 'Sagittarius'
			abbr = 'Sgr'
			ra = 19
			dec = -28
			major = true
		},
		object: Ephem {
			name = 'Scorpius'
			abbr = 'Sco'
			ra = 17
			dec = -27
			major = true
		},
		object: Ephem {
			name = 'Sculptor'
			abbr = 'Scl'
			ra = 0
			dec = -32
		},
		object: Ephem {
			name = 'Scutum'
			abbr = 'Sct'
			ra = 19
			dec = -8
		},
		object: Ephem {
			name = 'Serpens (Caput)'
			abbr = 'Ser'
			ra = 16
			dec = 11
			major = true
		},
		object: Ephem {
			name = 'Serpens (Cauda)'
			abbr = 'Ser'
			ra = 18
			dec = -3
			major = true
		},
		object: Ephem {
			name = 'Sextans'
			abbr = 'Sex'
			ra = 10
			dec = -1
		},
		object: Ephem {
			name = 'Taurus'
			abbr = 'Tau'
			ra = 5
			dec = 15
			major = true
		},
		object: Ephem {
			name = 'Telescopium'
			abbr = 'Tel'
			ra = 19
			dec = -51
		},
		object: Ephem {
			name = 'Triangulum'
			abbr = 'Tri'
			ra = 2
			dec = 31
		},
		object: Ephem {
			name = 'Triangulum Australe'
			abbr = 'TrA'
			ra = 16
			dec = -65
		},
		object: Ephem {
			name = 'Tucana'
			abbr = 'Tuc'
			ra = 24
			dec = -64
		},
		object: Ephem {
			name = 'Ursa Major'
			abbr = 'UMa'
			ra = 11
			dec = 51
			major = true
		},
		object: Ephem {
			name = 'Ursa Minor'
			abbr = 'UMi'
			ra = 15
			dec = 78
		},
		object: Ephem {
			name = 'Vela'
			abbr = 'Vel'
			ra = 10
			dec = -47
		},
		object: Ephem {
			name = 'Virgo'
			abbr = 'Vir'
			ra = 13
			dec = -4
			major = true
		},
		object: Ephem {
			name = 'Volans'
			abbr = 'Vol'
			ra = 8
			dec = -68
		},
		object: Ephem {
			name = 'Vulpecula'
			abbr = 'Vul'
			ra = 20
			dec = 24
		},
		object: Ephem {
			name = 'Pleiades'
			abbr = 'M45'
			ra = 4
			dec = 24
			major = true
		}
	]
;

class PolarisEphem: Ephem
	name = 'Polaris'
	abbr = '*'
	ra = 3
	dec = 89
;
