#charset "us-ascii"
//
// nightSkyCache.t
//
//	Classes for implementing the cache.
//
//	
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

class SkyCache: object
	julianDate = nil
	cache = nil

	construct(jd?) {
		if(jd != nil)
			julianDate = jd;
	}

	cacheLocked() { return(gameEnvironment.skyCacheLocked()); }

	initCache() { cache = new LookupTable(); }
	getCache() {
		if((cache == nil) && !cacheLocked())
			initCache();
		return(cache);
	}

	getObject(id) {
		local obj;

		if((obj = getCache()) == nil) {
			return(nil);
		}

		return(obj[id]);
	}

	addObject(obj) {
		local c;

		if((obj == nil) || !obj.ofKind(Ephem)) {
			return(nil);
		}
		if(obj.skyCacheID == nil)
			gameEnvironment.assignSkyCacheID(obj);

		if((c = getCache()) == nil) {
			return(nil);
		}

		c[obj.skyCacheID] = new SkyCacheEphem(obj.ra,
			obj.raDeg, obj.dec);

		return(true);
	}
;

class SkyCacheEphem: object
	ra = nil
	raDeg = nil
	dec = nil
	construct(v0, v1, v2) {
		ra = v0;
		raDeg = v1;
		dec = v2;
	}
;
