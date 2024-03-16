#charset "us-ascii"
//
// nightSkyPreinit.t
//
//	Preinit bookkeeping for the module.
//
//
#include <adv3.h>
#include <en_us.h>

#include "nightSky.h"

nightSkyPreinit: PreinitObject
	execute() {
		forEachInstance(Ephem, function(o) {
			o.initializeEphem();
		});

		forEachInstance(EphemOrder, function(o) {
			o.initializeEphemOrder();
		});
	}
;
