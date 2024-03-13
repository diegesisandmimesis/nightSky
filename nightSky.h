//
// nightSky.h
//

// Uncomment to enable debugging options.
//#define __DEBUG_NIGHT_SKY

#include "calendar.h"
#ifndef CALENDAR_H
#error "This module requires the calendar module."
#error "https://github.com/diegesisandmimesis/calendar"
#error "It should be in the same parent directory as this module.  So if"
#error "nightSky is in /home/user/tads/nightSky, then"
#error "calendar should be in /home/user/tads/calendar ."
#endif // CALENDAR_H

#define gSetPosition(l0, l1) (gameSky.setPosition(l0, l1))
#define gSky (gameSky)

NightSkyCatalog template 'catalogID' 'name'?;
Ephem template 'name' 'abbr';
EphemOrder template [ order ];

#define NIGHT_SKY_H
