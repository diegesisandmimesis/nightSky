#charset "us-ascii"
//
// nightSkyPlanets.t
//
//	Data and math adapted from JPL's "Approximate Positions of the Planets"
//	page:
//		https://ssd.jpl.nasa.gov/planets/approx_pos.html
//
#include <adv3.h>
#include <en_us.h>

#include "bignum.h"

#include "nightSky.h"

class Planet: DynamicEphem
	abbr = (name.substr(0, 3))

	// Orbital elements, ephemeris
	_a = nil		// semi-major axis
	_e = nil		// eccentricity
	_I = nil		// inclination
	_L = nil		// mean longitude
	_Lperi = nil		// longitude of perihelion
	_Lnode = nil		// longitude of the ascending node
	_correction = nil	// corrections

	// Computed elements for current time
	a = nil
	e = nil
	I = nil
	L = nil
	Lperi = nil
	Lnode = nil

	dist = nil

	// Position in heliocentric rectangular coordinates, units of AU
	_rect = nil

	// Timestamp for the rectangular coordinates
	_rectTS = nil

	computeRADec(jd) {
		local r, v;

		r = computePosition(jd);
		v = _rectToRADecDist(r);

		ra = v[1].radiansToDegrees();
		dec = v[2].radiansToDegrees();
		raDeg = toInteger(ra.roundToDecimal(0));
		ra = toInteger((ra / 15).roundToDecimal(0));
		dec = toInteger(dec.roundToDecimal(0));
		dist = v[3];
	}

	// Returns the heliocentric rectangular coordinates.
	computePosition(jd) {
		local E, M, recl, req, t, w, x, y;

		// Convert date to centuries after the ephemeris.
		t = (new BigNumber(jd) - 2451545.0) / 36525;

		if((_rectTS == t) && (_rect != nil))
			return(_rect);

		_computeElements(t);

		// Argument of perihelion
		w = Lperi - Lnode;

		M = _computeMeanAnomaly(t);

		E = _computeEccentricAnomaly(t, M);

		// Heliocentric coords in orbital plane.
		x = a * (E.degreesToRadians().cosine() - e);
		y = a * (1 - (e * e)).sqrt() * E.degreesToRadians().sine();

		// Convert to coordinates in the ecliptic.
		recl = _computeEcliptic(w, Lnode, I, x, y);

		// Convert to equitorial coordinates.
		req = _computeEquitorial(recl[1], recl[2], recl[3]);

		// Covert to geocentric coordinates and cache the
		// result.
		_rect = _convertEquitorial(req[1], req[2], req[3], jd);
		_rectTS = jd;

		return(_rect);
	}

	// Compute the six orbital elements at our date.
	_computeElements(t) {
		a = _a[1] + (_a[2] * t);
		e = _e[1] + (_e[2] * t);
		I = _I[1] + (_I[2] * t);
		L = _L[1] + (_L[2] * t);
		Lperi = _Lperi[1] + (_Lperi[2] * t);
		Lnode = _Lnode[1] + (_Lnode[2] * t);
	}

	// Mean anomaly.
	_computeMeanAnomaly(t) {
		local b, c, s, f, ft, m;

		m = L - Lperi;
		if(_correction != nil) {
			b = _correction[1];
			c = _correction[2];
			s = _correction[3];
			f = _correction[4];

			ft = (f * t).degreesToRadians();

			m += (b * t * t) + (c * ft.cosine()) + (s * ft.sine());
		}

		while(m > 180)
			m -= 360;

		return(m);
	}

	// Eccentric anomaly
	_computeEccentricAnomaly(t, m) {
		local dE, E, i;

		// First estimate
		E = m - (57.29578 * e) * m.degreesToRadians().sine();

		dE = 1;
		i = 0;

		while((abs(dE) > 0.0000001) && (i < 10)) {
			dE = _kepler(m, e, E);
			E += dE;
			i++;
		}

		return(E);
	}

	// Numeric approximation of solution to Kepler's equation.
	_kepler(M, e, E) {
		local dM;

		dM = M - (E - (57.29578 * e) * E.degreesToRadians().sine());
		return(dM / (1 - e * E.degreesToRadians().cosine()));
	}

	// Compute the coordinates in the ecliptic, @J2000.
	_computeEcliptic(w, o, i, x, y) {
		local sinW, cosW, sinO, cosO, sinI, cosI;

		w = w.degreesToRadians();
		o = o.degreesToRadians();
		i = i.degreesToRadians();

		sinW = w.sine(); cosW = w.cosine();
		sinO = o.sine(); cosO = o.cosine();
		sinI = i.sine(); cosI = i.cosine();

		return([
			// xecl
			(cosW * cosO - sinW * sinO * cosI) * x
				+ (-sinW * cosO - cosW * sinO * cosI) * y,
			// yecl
			(cosW * sinO + sinW * cosO * cosI) * x
				+ (-sinW * sinO + cosW * cosO * cosI) * y,
			// zecl
			(sinW * sinI) * x + (cosW * sinI) * y
		]);
	}

	// Convert ecliptic coordinates to equitorial coordinates, @J2000.
	_computeEquitorial(x, y, z) {
		local e, sinE, cosE;

		// Obliquity @ J2000.
		e = (23.43928).degreesToRadians();

		sinE = e.sine();
		cosE = e.cosine();

		// Equitorial coords in J2000.
		return([
			x,
			(cosE * y) - (sinE * z),
			(sinE * y) + (cosE * z)
		]);
	}

	// Convert equitorial coordinates from heliocentric to
	// geocentric (assuming we're not the Ephem instance for
	// the Earth-Moon barycenter.
	_convertEquitorial(x, y, z, t) {
		local rE;

		if(self != emBarycenter) {
			rE = emBarycenter.computePosition(t);
			x -= rE[1];
			y -= rE[2];
			z -= rE[3];
		}

		return([ x, y, z ]);
	}

	// Returns RA, DEC, and distance in AU.
	_rectToRADecDist(v) {
		local l, r, t;

		r = ((v[1] * v[1]) + (v[2] * v[2]) + (v[3] * v[3])).sqrt();
		l = atan2(v[2], v[1]);
		t = (v[3] / r).arccosine();

		while(l < 0) l += _pi2;
		t = 0.5 * _pi - t;

		return([l, t, r]);
	}
;

// Orbital elements for the planets of the solar system.
planets: NightSkyCatalog 'planets' 'The Solar System';
+mercury: Planet 'Mercury'
	[ 0.38709843, 0.00000000 ]
	[ 0.20563661, 0.00002123 ]
	[ 7.00559432, -0.00590158 ]
	[ 252.25166724, 149472.67486623 ]
	[ 77.45771895, 0.15940013 ]
	[ 48.33961819, -0.12214182 ]
;
+venus: Planet 'Venus' +1
	[ 0.72332102, -0.00000026 ]
	[ 0.00676399, -0.00005107 ]
	[ 3.39777545, 0.00043494 ]
	[ 181.97970850, 58517.81560260 ]
	[ 131.76755713, 0.05679648 ]
	[ 76.67261496, -0.27274174 ]
;
+mars: Planet 'Mars' +4
	[ 1.52371243, 0.00000097 ]
	[ 0.09336511, 0.00009149 ]
	[ 1.85181869, -0.00724757 ]
	[ -4.56813164, 19140.29934243 ]
	[ -23.91744784, 0.45223625 ]
	[ 49.71320984, -0.26852431 ]
;
+jupiter: Planet 'Jupiter' +2
	[ 5.20248019, -0.00002864 ]
	[ 0.04853590, 0.00018026 ]
	[ 1.29861416, -0.00322699 ]
	[ 34.33479152, 3034.90371757 ]
	[ 14.27495244, 0.18199196 ]
	[ 100.29282654, 0.13024619 ]
	[ -0.00012452, 0.06064060, -0.35635438, 38.35125000 ]
;
+saturn: Planet 'Saturn' +3
	[ 9.54149883, -0.00003065 ]
	[ 0.05550825, -0.00032044 ]
	[ 2.49424102, 0.00451969 ]
	[ 50.07571329, 1222.11494724 ]
	[ 92.86136063, 0.54179478 ]
	[ 113.63998702, -0.25015002 ]
	[ 0.00025899, -0.13434469, 0.87320147, 38.35125000 ]
;
+uranus: Planet 'Uranus'
	[ 19.18797948, -0.00020455 ]
	[ 0.04685740, -0.00001550 ]
	[ 0.77298127, -0.00180155 ]
	[ 314.20276625, 428.49512595 ]
	[ 172.43404441, 0.09266985 ]
	[ 73.96250215, 0.05739699 ]
	[ 0.00058331, -0.97731848, 0.17689245, 7.67025000 ]
;
+neptune: Planet 'Neptune'
	[ 30.06952752, 0.00006447 ]
	[ 0.00895439, 0.00000818 ]
	[ 1.77005520, 0.00022400 ]
	[ 304.22289287, 218.46515314 ]
	[ 46.68158724, 0.01009938 ]
	[ 131.78635853, -0.00606302 ]
	[ -0.00041348, 0.68346318, -0.10162547, 7.67025000 ]
;

// The Earth-Moon barycenter.
// IMPORTANT: This is necessary for computing the apparent positions of
// 	the other planets, but it ISN'T suitable (as implemented) for
//	use as a catalog object by itself.
emBarycenter: Planet 'EM Barycenter'
	[ 1.00000018, -0.00000003 ]
	[ 0.01673163, -0.00003661 ]
	[ -0.00054346, -0.01337178 ]
	[ 100.46691572, 35999.37306329 ]
	[ 102.93005885, 0.31795260 ]
	[ -5.11260389, -0.24123856 ]
;
