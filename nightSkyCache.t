#charset "us-ascii"
//
// nightSkyCache.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

modify Ephem
	// A unique identifier for each cached object.
	skyCacheID = nil
;

modify gameEnvironment
	// Number of days to pre-cache.
	cacheDays = 0

	// List of catalogs to pre-cache.
	cacheCatalogs = nil

	// Date instance and integer Julian date of the start of the cache.
	cacheStartDate = nil
	cacheStartJD = nil

	// The cache itself, a Vector of NightSkyState instances whose
	// index is the day of the cache sequence.
	skyCache = nil

	// Flag set after cache generation.  When this is set, any
	// query to the cache for a non-existent object will return
	// nil instead of an empty object of the appropriate type.
	skyCacheLock = nil

	_skyCacheIndex = 0

	skyCacheLocked() { return(skyCacheLock != nil); }

	initSkyCache() {
		local i;

		if(cacheDays == nil)
			return;

		cacheStartDate = gCalendar.cloneDate();
		cacheStartJD = gCalendar.getJulianDate();

		skyCache = new LookupTable();

		for(i = 0; i < cacheDays; i++) {
			computeDayCache();
			gCalendar.advanceDay();
		}

		gCalendar.setDate(cacheStartDate);
		skyCacheLock = true;
	}

	// Returns the NightSkyState instance for the given Julian
	// day.  During preinit a cache miss will cause an empty
	// NightSkyState instance to be returned (for the pre-cache
	// process to fill in).  During normal gameplay a cache
	// miss will return nil.
	getSkyCache(jd?) {
		local idx;

		if(jd == nil)
			jd = gCalendar.getJulianDate();

		idx = jd - cacheStartJD + 1;

		if(skyCache[idx] != nil)
			return(skyCache[idx]);

		if(skyCacheLocked())
			return(nil);

		skyCache[idx] = new SkyCache(jd);

		return(skyCache[idx]);
	}

	// Compute the cache for a specific day.
	computeDayCache() {
		// If we don't have any catalogs to cache, we have
		// nothing to do.
		if(cacheCatalogs == nil)
			return;

		// Create the catalog caches.
		cacheCatalogs.forEach(function(o) {
			computeDayCacheCatalog(o);
		});

		computeDayCacheSunMoon();
	}

	computeDayCacheSunMoon() {
		local cache;

		cache = getSkyCache();

		cache.addObject(gSky.getSun());
		cache.addObject(gSky.getMoon());
	}

	// Create the cache for the given catalog.
	computeDayCacheCatalog(id) {
		local cat, cache;


		// Try to find a catalog with the given ID.
		cat = nil;
		forEachInstance(NightSkyCatalog, function(o) {
			if(o.catalogID == id)
				cat = o;
		});
		if(cat == nil) {
			"Unknown catalog <q><<id>></q>\n ";
			return;
		}

		// The SkyCache object for this day.
		cache = getSkyCache();

		// Compute the position of each object in the catalog
		// and cache it.
		cat.objectList.forEach(function(o) {
			//if(o.skyCacheID == nil)
				//assignSkyCacheID(o);
			o.compute(gCalendar.getJulianDate());
			cache.addObject(o);
			//obj.catalog[o.skyCacheID] = new SkyCatalogEphem(o.ra,
				//o.raDeg, o.dec);
		});
	}

	// Create a unique ID for each cached ephem object
	assignSkyCacheID(obj) {
		_skyCacheIndex += 1;
		obj.skyCacheID = _skyCacheIndex;
	}

	checkSkyCache(id, jd?) {
		local cache;

		if((cache = getSkyCache(jd)) == nil) {
			return(nil);
		}
		
		return(cache.getObject(id));
	}
;

modify DynamicEphem
	cacheLocked() { return(gameEnvironment.skyCacheLocked()); }

	checkCache(jd) {
		local obj;

		if((obj = gameEnvironment.checkSkyCache(skyCacheID, jd))
			== nil)
			return(nil);

		ra = obj.ra;
		raDeg = obj.raDeg;
		dec = obj.dec;

		return(true);
	}
;
