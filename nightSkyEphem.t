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
		if(n != nil) name = n;
		if(a != nil) abbr = a;
		if(r != nil) ra = r;
		if(d != nil) dec = d;
		if(m != nil) major = true;
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
