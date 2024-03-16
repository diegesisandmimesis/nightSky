#charset "us-ascii"
//
// nightSkyCache.t
//
//	Logic for creating and querying a per-day cache for dynamic objects.
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

	// Index of cached objects.  Used as a UID-ish thing for
	// objects added to the cache.
	_skyCacheIndex = 0

	// Returns boolean true if the cache is locked.  The cache is
	// normally locked during gameplay, and is only unlocked during
	// preinit (when it's generated).
	skyCacheLocked() { return(skyCacheLock != nil); }

	initSkyCache() {
		local i;

		// If we haven't been asked to cache any days,
		// we have nothing to do.
		if(cacheDays == nil)
			return;

		// Remember the start date, as a Date instance
		// and a Julian day number.
		cacheStartDate = gCalendar.cloneDate();
		cacheStartJD = gCalendar.getJulianDate();

		// Create the cache itself.
		skyCache = new LookupTable();

		// For each day, we create the cache and then
		// advance the calendar.
		for(i = 0; i < cacheDays; i++) {
			computeDayCache();
			gCalendar.advanceDay();
		}

		// Reset the current date to the starting date.
		gCalendar.setDate(cacheStartDate);

		// Lock the cache.
		skyCacheLock = true;
	}

	// Returns the SkyCache instance for the given Julian
	// day.  During preinit a cache miss will cause an empty
	// SkyCache instance to be returned (for the pre-cache
	// process to fill in).  During normal gameplay a cache
	// miss will return nil.
	getSkyCache(jd?) {
		local idx;

		if(jd == nil)
			jd = gCalendar.getJulianDate();

		// The day number, counting from our start date.
		idx = jd - cacheStartJD + 1;

		// If we already have a cache entry for this day, return it.
		if(skyCache[idx] != nil)
			return(skyCache[idx]);

		// If we're locked, bail.
		if(skyCacheLocked())
			return(nil);

		// Create a new cache object and stick it in the table.
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

	// Cache the Sun and Moon.
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
			if(!o.ofKind(DynamicEphem))
				return;
			o.compute(gCalendar.getJulianDate());
			cache.addObject(o);
		});
	}

	// Create a unique ID for each cached ephem object
	assignSkyCacheID(obj) {
		_skyCacheIndex += 1;
		obj.skyCacheID = _skyCacheIndex;
	}

	// Check the cache for the given skyCacheID, returning
	// the SkyCacheEphem instance if it exists, nil on a cache
	// miss.
	checkSkyCache(id, jd?) {
		local cache;

		if((cache = getSkyCache(jd)) == nil) {
			return(nil);
		}
		
		return(cache.getObject(id));
	}
;

modify DynamicEphem
	//cacheLocked() { return(gameEnvironment.skyCacheLocked()); }

	// Check to see if our position on the given date is cached.
	checkCache(jd) {
		local obj;

		// Query the cache.
		if((obj = gameEnvironment.checkSkyCache(skyCacheID, jd))
			== nil) {
			return(nil);
		}

		// Assign the current values from the cache.
		ra = obj.ra;
		raDeg = obj.raDeg;
		dec = obj.dec;

		return(true);
	}
;
