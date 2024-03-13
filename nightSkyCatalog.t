#charset "us-ascii"
//
// nightSkyCatalog.t
//
//	Format of an object catalog for use with NightSky.
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

// Catalog class.  This is a container for Ephem instances.
class NightSkyCatalog: object
	objectList = perInstance(new Vector())

	catalogID = nil
	name = nil

	// Add an object's ephemeris data to ourselves.
	addEphem(obj) {
		// Make sure the arg is a valid Ephem instance.
		if((obj == nil) || !obj.ofKind(Ephem))
			return(nil);

		objectList.append(obj);

		return(true);
	}

	// Handle an EphemOrder object.  This is just for assigning
	// the order property to the enumerated objects.
	addEphemOrder(obj) {
		local e, i;

		// Make sure the arg is an EphemOrder instance.
		if((obj == nil) || !obj.ofKind(EphemOrder))
			return(nil);

		// If the order object doesn't have an order property,
		// there's nothing to do, bail.
		if(obj.order == nil)
			return(nil);

		// Go through the listed objects, assigning their order
		// property to be their index in the EphemOrder list.
		for(i = 1; i <= obj.order.length(); i++) {
			if((e = getObjectByID(obj.order[i])) != nil)
				e.order = i;
		}

		return(true);
	}

	// Returns the object, if any, with the given name or abbreviation.
	getObjectByID(id) {
		local i;

		// Make sure we have an argument.
		if(id == nil)
			return(nil);

		// We don't care about case for matching.
		id = id.toLower();

		// Walk through our objects and check each.
		for(i = 1; i <= objectList.length; i++) {
			if((objectList[i].name.toLower() == id)
				|| (objectList[i].abbr.toLower() == id))
				return(objectList[i]);
		}

		// Nope, fail.
		return(nil);
	}

	// Returns an object by its position in the object list.
	getObjectByIndex(idx) {
		if(idx == nil)
			return(nil);
		if((idx < 1) || (idx > objectList.length()))
			return(nil);
		return(objectList[idx]);
	}

	// Return the entire object list.
	getObjects() { return(objectList); }
	getObjectList() { return(getObjects()); }

	// Return objects in the catalog for which the given test function
	// returns boolean true.
	matchObjects(fn) {
		local v;

		// Make sure we have a test function.
		if(fn == nil)
			return([]);

		// Vector to hold the return value.
		v = new Vector(objectList.length);

		objectList.forEach(function(o) {
			// Call the test function on the object.
			if((fn)(o) == true)
				v.append(o);
		});

		return(v);
	}
;

// One-off Ephem instance for Polaris.  Used by the map in the debugging tools.
class PolarisEphem: Ephem
	name = 'Polaris'
	abbr = '*'
	ra = 3
	dec = 89
;
