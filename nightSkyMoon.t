#charset "us-ascii"
//
// nightSkyMoon.t
//
//	Comically low precision lunar ephemeris.
//
//
#include <adv3.h>
#include <en_us.h>

#include "bignum.h"
#include "date.h"

#include "nightSky.h"

class MoonEphem: DynamicEphem
	name = 'Moon'
	abbr = 'Moon'
	symbol = '@'

	// Lunar declination varies quite a bit, but we don't REALLY
	// need it to figure out if the moon is visible.  So we can
	// optionally just use a fixed declination that'll work
	// for most of the Northern Hemisphere and save ourselves
	// a bit of floating point math every time we recompute things.
	// To do this, just set computeDeclination to nil.
	dec = 23
	computeDeclination = true

	// Computes the lunar RA at local midnight for the current
	// day and, optionally, the declination.
	//
	// This is an even lower-precision version of the
	// algorithm given by Flandern and Pulkkinen in:
	//
	// 	van Flandern, T.C. and Pulkkinen, K.F. 1979. Low-precision
	//	 	formulae for planetary positions. The Astrophysical
	//		Journal Supplement Series 41, 391.
	//		http://dx.doi.org/10.1086/190623.
	//
	// This version is comically simpler, basically just grabbing
	// the largest term for each element and optionally not bothering to
	// compute declination at all.
	//
	// We save the RA in both degrees and hours because we
	// want to do our math with integers.  The RA in hours is useful
	// for reporting, but we save the RA in degrees for the
	// marginal benefit of the extra precision when dealing with
	// integer values.
	computeRADec(jd) {
		local d, f, g, l, m, n, off, s, u, v, w;

		off = new BigNumber(jd) - 2451545;

		l = 0.606434 + (0.03660110129 * off);
		m = 0.374897 + (0.03629164709 * off);
		f = 0.259091 + (0.03674819520 * off);
		d = 0.827362 + (0.03386319198 * off);
		n = 0.347343 - (0.00014709391 * off);
		g = 0.993126 + (0.00273777850 * off);

		l = _pi2 * (l - l.getFloor());
		m = _pi2 * (m - m.getFloor());
		f = _pi2 * (f - f.getFloor());
		d = _pi2 * (d - d.getFloor());
		n = _pi2 * (n - n.getFloor());
		g = _pi2 * (g - g.getFloor());

		v = 0.39558 * (f + n).degreesToRadians().sine();
		u = 1 - (0.10828 * m.degreesToRadians().cosine());
		w = 0.10478 * m.degreesToRadians().sine();

		s = w / (u - (v * v)).sqrt();
		ra = l + (s / (1 - (s * s)).sqrt()).arctangent();

		raDeg = ra.radiansToDegrees();
		ra = toInteger(raDeg / 15);
		raDeg = toInteger(raDeg);

		if(computeDeclination == true) {
			s = v / u.sqrt();
			dec = (s / (1 - (s * s)).sqrt()).arctangent();
			dec = toInteger(dec.radiansToDegrees());
		}
	}
;
