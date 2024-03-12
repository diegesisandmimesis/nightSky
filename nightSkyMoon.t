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

class MoonEphem: Ephem
	name = 'Moon'
	abbr = '@'

	// The lunar declination actually varies quite a bit, but because
	// all we care about is whether or not its visible and (roughly)
	// how close to the local meridian it is, we just use a
	// fixed declination to save a few floating point ops.
	dec = 23

	// The RA in degrees.
	raDeg = nil

	// Remember the Julian date we computed the RA for.
	_julianDate = nil

	// pi times two.
	_pi2 = 6.28318530

	compute(d0) {
		if(_julianDate == d0)
			return;

		_computeRA(d0);
		_julianDate = d0;
	}

	// Computes the lunar RA at local midnight for the current
	// day IN DEGREES.
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
	// the largest term for each element and not bothering to
	// compute declination at all.
	//
	// We return a value in degrees (instead of hours) because we
	// want to do our math with integers (because TADS3 floating point
	// performance is DIRE).  We end up saving the lunar RA at local
	// midnight, and when we want to figure out the moon's position in
	// the sky at a given hour we treat it as if the moon is a fixed
	// star with the given RA.
	_computeRA(jd) {
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
	}

	clear() {
		alt = nil;
		az = nil;
	}
;
