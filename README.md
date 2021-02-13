# 2Take1-Utilities

## Features
- Only Applicable with Utilities 1.x
### Clear Area
#### Clear Objects
- Clear Objects (Selectable range in metres)
- Clear Objects Toggle (Selectable range in metres)

#### Clear Peds
- Clear Peds (Selectable range in metres)
- Clear Peds Toggle (Selectable range in metres)

#### Clear Vehicles
- Clear Vehicles (Selectable range in metres)
- Clear Vehicles Toggle (Selectable range in metres)

#### Clear Pickups
- Clear Pickups (Selectable range in metres)
- Clear Pickups Toggle (Selectable range in metres)

#### Clear Cops
- Clear Cops (Selectable range in metres)
- Clear Cops Toggle (Selectable range in metres)

#### Clear All
- Clear All (Selectable range in metres)
- Clear All Toggle (Selectable range in metres)

### New Entity Log
>   Will log Net ID's, Hashes and model names of chosen entity types. 
>   Will only log entities you haven't encountered this current play session

- Log Objects
- Log Objects Toggle
- Log Vehicles
- Log Vehicles Toggle
- Log Peds
- Log Peds Toggle
- Log Pickups
- Log Pickups Toggle
- Log All Entities
- Log All Entities Toggle

### Misc Log
- Net Events
>   Still Work In Progress due to slight lag issues
- log Players
>   Logs joining players
- log Modder Flags
>   Logs all flags for why someone was marked as modder

### Entity Manager
>   This Feature is still Work In Progress

- Refresh Entity Pools
>   Enable this to be able to access Entity Manager

#### **Entity** Manager
>   Peds, Vehicles, Objects
>   Options for each are very similar

##### All **Entity**
- Teleport All to out of bounds
>   Attempts to tp all **Chosen Entity** in your **Chosen Entity** pool to out of bounds area.
- Teleport all to me
>   Attempts to tp all **Chosen Entity** in your **Chosen Entity** pool to you.
- Explode **Entity**
>   Explodes all **Chosen Entity** in your **Chosen Entity** pool with invisible explosion (includes players)

##### Individual **Entity**
- Refresh **Entity** List 
>   Must toggle this to see new **Chosen Entity**
- Shows how many Peds it found
- Select desired **Chosen Entity**, options similar to All Peds

### log Cleanup
>   This section should be self explanatory. Can choose what .log files to delete and option to delete all.
- Cleanup all log Files
- Cleanup **logtype**.log

### Settings
- Version
>   Shows current script Version
- Delays
>   Clear **Entity Type** delay, log delay
>   lets you modify the delays of certain things within the script
- Adv Clear Area Settings
    - Req Ctrl Timeout Limit
        >   After this many attempts, clear area will give up on that entity.
    - Req Ctrl Delay
        >   Delay in ms between Request Control attempts

- Startup Logs
>   Choose what logs will be enabled on script startup
- Net Event log Settings
>   Choose what to do with each net event when net event log is enabled
>   0: log only 1: Notify & log 2: block & log 3: block, notify & log

- Destroy logs on startup
>   on script startup, delete *all* log files.
- Save Settings
>   Saves all Settings

## Installation

Utilities.lua can be installed one of two ways.
Firstly, you can just run the .exe to have it automatically install itself.
Or you can open the .rar and manually copy the .lua file and lib folder to your %appdata%\PopstarDevs\2Take1Menu\scripts\ folder

## Notes

- to use my Net Event log, you must turn off EVERTYTHING in online - event hooks - net events 
- clear peds loop and clear cops loop may crash you at higher ranges
- clear vehicles will probably cause lag..
- all normal .log files made by this script are in %appdata%\PopstarDevs\2Take1Menu\scripts\Utilities\logs
- all debug .log files made by this script are in %appdata%\PopstarDevs\2Take1Menu\scripts\Utilities\logs\debug
- Utilities.ini is found in %appdata%\PopstarDevs\2take1menu\scripts\Utilities

## Installation
- Grab the latest .zip or .exe (self extracting archive) of either version, or download directly from here.
- .exe method: 
    - run the .exe and thats it, done. ez
- .zip method:
    - copy the "lib" folder to %appdata%\PopstarDevs\2Take1Menu\scripts\
    - copy the .lua file to %appdata%\PopstarDevs\2Take1Menu\scripts\
    - done

## Changelog
**V1.0.0**  
- initial release
- added Clear Peds
	- added Clear Peds loop
- added Clear Vehicles
	- added Clear Vehicles loop
- added Clear Cops
	- added Clear Cops loop
- added Clear All (doesnt work on objects yet)  
	- added Clear All loop (doesnt work on objects yet)

**V1.2.0**
- all clear area options now get all entities, get control of all entities, mark them as no longer needed, then deletes them
- clear all peds now checks for player peds, and freezes non player peds
- added clear pickups
	- added clear pickups loop
		>doesnt work atm :(
-  clear objects now kinda works..

**V1.3.0**
- added log Vehicles/Peds/Objects/Pickups EntityID + Entity Hash
- added log all entities EntityID + Entity HASH
    - .log files can be found in %appdata%/PopstarDevs/2Take1Menu/Entity Logs/
- added clean up .log files

**V1.3.5**
- added ability to manually edit log delay
    >open this file and edit local log_delay = 250 (its in ms)
- fixed clear cops

**V1.4.0**
- added Adv Entity Log
    - logs Entity ID, Entity Hash and Entity Name
- moved cleanup log files from Log Entities submenu to Clear Area submenu

**V1.4.2**
- Fixed adv log all entities loop

**V1.5.0**
- Now using proper PedMapper.lua
- added Ped Name: and Ped Model: to log
- Added if file exists check to log cleanup notification
    - added 3 diff types of "cleanup log" with different notification types.
- added more delay options
    - clear_ped_delay, clear_cops_delay, clear_object_delay, clear_all_delay
- changed log style

**V1.5.2**
- fixed some weird ass error, like wtf lua?!

**V1.6.0**
- rewrote parts of the script to be more effecient
- clear vehicle no longer deletes vehicle you're in
- made entity.delete_entity() actually obey distance setting
- logs cleared entities to Cleanup.log
    - and add Cleanup.log to Cleanup log Files
- fixed clear objects.. finally (i think)

**V1.7.0**
- renamed to Utilities instead of Clear Area
- moved logs from /Entity Logs/ to /Utilities/
- added Net Event log with net event names
- made it so can no longer double load the script
- added log cleanup submenu
- added individiual clear log options
- added new entity logger, only logs *new* entities. (entities not in the .log)
- removed basic entity log cos it sucks
- renamed Object ID/Ped ID/Vehicle ID/Pickup ID to Object/Ped/Vehicle/Pickup Net ID
- modified adv entity logs
    - added extra delays to adv log all entities.
- added "local destroylog = *" set to true, to automatically delete log files on script load

**V1.7.2**
- fixed ValidSCID error
- fixed neteventmapper error

**V1.7.5**
- added in-menu config options
    - can adjust different delays used by the script
    - can adjust what logs will be enabled on script startup
    - Save Settings will save clear entity ranges 
    >(have to use the option at least once before being able to save area)
- moved .log files and Utilities folder to %appdata%\PopstarDevs\2Take1Menu\scripts\Utilities\
- added some debug shit
- maybe i added some other shit, i cant remember.

**V1.7.6**
- fixed a small bug

**V1.8.0**
- Changed format to a Self-Extracting Archive.
    - just run either .exe to install the script. You can also open the .exe with winrar/7zip for manual install
- added player join log

**V1.8.2**
- added Clear Area Req Ctrl attempt limit settings
- added clear area req ctrl delay settings
- added modder reason log
- fixed net event log from blokcing all net events
- added option to modify what net events net event log will block
    >2t1 inbuilt net event hooks will stop the lua API from receiving those events..
- edit local nh_bad_event = {x, y, z} to set what NetEvent ID's to block
- utilities > settings > Blocked Net Events   to see what net events you're blocking.

**V1.8.3**
- removed net event log
- raged at lua a bit...

**V1.8.4**
- brought back net event log
- added settings for notify/block/block & notify for each net event (careful with this, lol)
- broke Save Settings.. rip
- fixed Save Settings.. yay

**V1.8.6**
- changed somethin to make it better (tbh i forgot what)
- fixed net event log (blocks selected net events properly..)
- fixed another thing
- added entity manager
    - can do certain things to _all_ peds, vehicles or objects, or can do certain things to individual peds/objects/vehicles
- added teleport all peds/vehicles/objects/pickups/all entities to selected player
- added attach all peds/vehicles/objects/pickups/all entities to selected player
- changed net event log status to WIP

**V1.8.8**
- changed some log behaviour/messages.
- added extra log info/shit
- added EntityManager.log for Entity Manager and Entity Shit (player feature)
- moved logs to /scripts/utilities/logs/
- added couple extra debug logs
- moved debug type logs to /scripts/utilities/logs/debug/
- updated Settings structure to be better
- fixed some bugs
- probs did some other shit, idk...

**V1.8.9**
- removed adv entity log cos it sucks.

**V1.9.1**
- adjusted a few things to now work with latest 2t1 version
- updated included vehiclemapper.lua


## to-do
- add option to adjust x.mod_i "precision"
- add way to manually input range values (can kinda be done by editing Utilities.ini)
- add delete gun
- added nh_bad_event_md for net event id's to trigger modder detection when received. probs gonna do a lib thing for modder detections...
- add block from modder function for net events
- add clear area entity whitelist.. somehow
- add more "entity.is_an_entity(Entity entity)" checks to reduce chances of things breaking... 
