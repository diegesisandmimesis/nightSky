#charset "us-ascii"
//
// nightSkyEphem.t
//
//	Utility classes for the nightSky module.
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

#include "bignum.h"

class Ephem: object
	name = nil
	abbr = nil
	ra = nil
	dec = nil
	major = nil

	alt = nil
	az = nil

	construct(n?, a?, r?, d?, m?, a0?, a1?) {
		name = n;
		abbr = a;
		ra = r;
		dec = d;
		major = m;
		if(a0 != nil)
			alt = new BigNumber(a0);
		if(a1 != nil)
			az = new BigNumber(a1);
	}

	clear() {
		alt = nil;
		az = nil;
	}
;
