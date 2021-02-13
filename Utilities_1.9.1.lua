--[[    Utilities by Entrodor

Changelog:
V1.0.0  - initial release
        - added Clear Peds
            - added Clear Peds loop
        - added Clear Vehicles
            - added Clear Vehicles loop
        - added Clear Cops
            - added Clear Cops loop
        - added Clear All (doesnt work on objects yet)
            - added Clear All loop (doesnt work on objects yet)
V1.2.0  - all clear area options now get all entities, get control of all entities, mark them as no longer needed, then deletes them
        - clear all peds now checks for player peds, and freezes non player peds
        - added clear pickups
            - added clear pickups loop
            - doesnt work atm :(
        -  clear objects now kinda works..
V1.3.0  - added log Vehicles/Peds/Objects/Pickups EntityID + EntityHash
            - added log all entities EntityID + EntityHASH
                - .log files can be found in %appdata%/PopstarDevs/2Take1Menu/Entity Logs/
        - added clean up .log files
V1.3.5  - added ability to manually edit log delay
            - open this file and edit local log_delay = 250 (its in ms)
        - fixed clear cops
V1.4.0  - added Adv Entity Log
            - logs Entity ID, Entity Hash and Entity Name
        - moved cleanup log files from Log Entities submenu to Clear Area submenu
V1.4.2  - Fixed adv log all entities loop
V1.5.0  - Now using proper PedMapper.lua
            - added Ped Name: and Ped Model: to log
        - Added if file exists check to log cleanup notification
            - added 3 diff types of "cleanup log" with different notification types.
        - added more delay options
            - clear_ped_delay, clear_cops_delay, clear_object_delay, clear_all_delay
        - changed log style
V1.5.2  - fixed some weird ass error, like wtf lua?!
V1.6.0  - rewrote parts of the script to be more effecient
        - clear vehicle no longer deletes vehicle you're in
        - made entity.delete_entity() actually obey distance setting
        - logs cleared entities to Cleanup.log
            - and add Cleanup.log to Cleanup log Files
        - fixed clear objects.. finally (i think)
V1.7.0  - renamed to Utilities instead of Clear Area
        - moved logs from /Entity Logs/ to /Utilities/
        - added Net Event log with net event names
        - made it so can no longer double load the script
        - added log cleanup submenu
        - added individiual clear log options
        - added new entity logger, only logs *new* entities. (entities not in the .log)
        - removed basic entity log cos it sucks
        - renamed Object Net ID/Ped Net ID/Vehicle Net ID/Pickup ID to Object/Ped/Vehicle/Pickup Net ID
        - modified adv entity logs
            - added extra delays to adv log all entities.
        - added "local destroylog = *" set to true, to automatically delete log files on script load
V1.7.2  - fixed ValidSCID error
        - fixed neteventmapper error
V1.7.5  - added in-menu config options
            - can adjust different delays used by the script
            - can adjust what logs will be enabled on script startup
            - Save Settings will save clear entity ranges 
                (have to use the option at least once before being able to save area)
        - moved .log files and Utilities folder to %appdata%\PopstarDevs\2Take1Menu\scripts\Utilities\
        - added some debug shit
        - maybe i added some other shit, i cant remember.
V1.7.6  - fixed a small bug
V1.8.0  - Changed format to a Self-Extracting Archive.
            - just run either .exe to install the script. You can also open the .exe with  winrar/7zip for manual install
        - added player join log
V1.8.2  - added Clear Area Req Ctrl attempt limit settings
        - added clear area req ctrl delay settings
        - added modder reason log
        - fixed net event log from blokcing all net events
        - added option to modify what net events net event log will block
            - 2t1 inbuilt net event hooks will stop the lua API from receiving those events..
            - edit local nh_bad_event = {x, y, z} to set what NetEvent ID's to block
        - utilities > settings > Blocked Net Events   to see what net events you're blocking.
V1.8.3  - removed net event log
        - raged at lua a bit...
V1.8.4  - brought back net event log
        - added settings for notify/block/block & notify for each net event (careful with this, lol)
        - broke Save Settings.. rip
        - fixed Save Settings.. yay
V1.8.6  - changed somethin to make it better (tbh i forgot what)
        - fixed net event log (blocks selected net events properly..)
        - fixed another thing
        - added entity manager
            - can do certain things to _all_ peds, vehicles or objects, or can do certain things to individual peds/objects/vehicles
        - added teleport all peds/vehicles/objects/pickups/all entities to selected player
        - added attach all peds/vehicles/objects/pickups/all entities to selected player
        - changed net event log status to WIP
V1.8.8  - changed some log behaviour/messages.
        - added extra log info/shit
        - added EntityManager.log for Entity Manager and Entity Shit (player feature)
        - moved logs to /scripts/utilities/logs/
        - added couple extra debug logs
        - moved debug type logs to /scripts/utilities/logs/debug/
        - updated Settings structure to be better
        - fixed some bugs
        - probs did some other shit, idk...
V1.8.9  - Removed Adv Entity Log
V1.9.1  - Updated to work with new lua changes

to-do:  - add option to adjust x.mod_i "precision"
        - make adv ped log loop better
        - add way to manually input range values (can kinda be done by editing Utilities.ini)
        - add delete gun
        - added nh_bad_event_md for net event id's to trigger modder detection when received. probs gonna do a lib thing for modder detections...
        - add block from modder function for net events
        - add clear area entity whitelist.. somehow
        - add more "entity.is_an_entity(Entity entity)" checks to reduce chances of things breaking... 


--]]
local script_name = "Utilities"

utils.make_dir(os.getenv("APPDATA").."\\PopstarDevs\\2Take1Menu\\scripts\\Utilities")
utils.make_dir(os.getenv("APPDATA").."\\PopstarDevs\\2Take1Menu\\scripts\\Utilities\\logs")
utils.make_dir(os.getenv("APPDATA").."\\PopstarDevs\\2Take1Menu\\scripts\\Utilities\\logs\\debug")
local utilities_home = os.getenv("APPDATA").."\\PopstarDevs\\2Take1Menu\\scripts\\Utilities"
local utilities_logs = utilities_home.."\\logs"
local utilities_debug = utilities_logs.."\\debug"

-- log file locations
local logfiles = {}
local lognames = {}

logfiles[0] = utilities_logs.."\\Objects.log"
lognames[0] = "Objects.log"
logfiles[1] = utilities_logs.."\\Peds.log"
lognames[1] = "Peds.log"
logfiles[2] = utilities_logs.."\\Vehicles.log"
lognames[2] = "Vehicles.log"
logfiles[3] = utilities_logs.."\\Pickups.log"
lognames[3] = "Pickups.log"
logfiles[4] = utilities_logs.."\\Cleanup.log"
lognames[4] = "Cleanup.log"
logfiles[5] = utilities_logs.."\\NetEvents.log"
lognames[5] = "NetEvents.log"
logfiles[6] = utilities_logs.."\\Players.log"
lognames[6] = "Players.log"
logfiles[7] = utilities_logs.."\\Modders.log"
lognames[7] = "Modders.log"
logfiles[8] = utilities_logs.."\\EntityManager.log"
lognames[8] = "EntityManager.log"
-- debug type log files
logfiles[9] = utilities_debug.."\\Debug.log"
lognames[9] = "Debug.log"
logfiles[10] = utilities_debug.."\\ClearAreaDebug.log"
lognames[10] = "ClearAreaDebug.log"
logfiles[11] = utilities_debug.."\\EntityManagerDebug.log"
lognames[11] = "EntityManagerDebug.log"

-- log function
local function log(text, c_prefix, file_name)
    local path = os.getenv("APPDATA").."\\PopstarDevs\\2Take1Menu\\scripts"
    local log_file = io.open(path.."\\Utilities\\logs\\"..file_name, "a")
    local t = os.date("*t")
    if t.month < 10 then
        t.month = "0" .. t.month
    end
    if t.day < 10 then
        t.day = "0" .. t.day
    end
    if t.hour < 10 then
        t.hour = "0" .. t.hour
    end
    if t.min < 10 then
        t.min = "0" .. t.min
    end
    if t.sec < 10 then
        t.sec = "0" .. t.sec
    end
    local prefix = "["..t.year.."-"..t.month.."-"..t.day.." "..t.hour..":"..t.min..":"..t.sec.."] "
    if c_prefix ~= nil then
        prefix = prefix..c_prefix.." "
    end
    io.output(log_file)
    io.write(prefix..text.."\n")
    io.close(log_file)
end
local function dbg(text, c_prefix, file_name)
    local path = os.getenv("APPDATA").."\\PopstarDevs\\2Take1Menu\\scripts"
    local log_file = io.open(path.."\\Utilities\\logs\\debug\\"..file_name, "a")
    local t = os.date("*t")
    if t.month < 10 then
        t.month = "0" .. t.month
    end
    if t.day < 10 then
        t.day = "0" .. t.day
    end
    if t.hour < 10 then
        t.hour = "0" .. t.hour
    end
    if t.min < 10 then
        t.min = "0" .. t.min
    end
    if t.sec < 10 then
        t.sec = "0" .. t.sec
    end
    local prefix = "["..t.year.."-"..t.month.."-"..t.day.." "..t.hour..":"..t.min..":"..t.sec.."] "
    if c_prefix ~= nil then
        prefix = prefix..c_prefix.." "
    end
    io.output(log_file)
    io.write(prefix..text.."\n")
    io.close(log_file)
end

-- make sure user can only load script once.
if Utilities_Script then
    ui.notify_above_map("Utilities is already loaded", script_name, 140)
    return
end
-- load library stuff
if not package.path:find(os.getenv("APPDATA") .. "\\PopstarDevs\\2Take1Menu\\scripts\\lib\\?.lua", 1, true) then package.path = package.path .. ";" .. os.getenv("APPDATA") .. "\\PopstarDevs\\2Take1Menu\\scripts\\lib\\?.lua" end
local objectmapper = require("ObjectMapper")
if objectmapper then
    dbg("ObjectMapper successfully loaded", "[lib Load]", "Debug.log")
else
    dbg("ObjectMapper failed to load. Does file exist in lib folder?", "[lib Load]", "Debug.log")
end
local vehiclemapper = require("VehicleMapper")
if vehiclemapper then
    dbg("VehicleMapper successfully loaded", "[lib Load]", "Debug.log")
else
    dbg("VehicleMapper failed to load. Does file exist in lib folder?", "[lib Load]", "Debug.log")
end
local pedmapper = require("PedMapper")
if pedmapper then
    dbg("PedMapper successfully loaded", "[lib Load]", "Debug.log")
else
    dbg("PedMapper failed to load. Does file exist in lib folder?", "[lib Load]", "Debug.log")
end
local neteventmapper = require("NetEventMapper")
if neteventmapper then
    dbg("NetEventMapperMapper successfully loaded", "[lib Load]", "Debug.log")
else
    dbg("NetEventMapperMapper failed to load. Does file exist in lib folder?", "[lib Load]", "Debug.log")
end

-- credits to Haekkzar for save settings shit :)
local setting = {}
setting[0] = {}

setting[0][#setting[0]+1] = "section_1"
setting["section_1"] = "[Info]"
setting[0][#setting[0]+1] = "version"
setting["version"] = "1.9.1"

setting[0][#setting[0]+1] = "section_2"
setting["section_2"] = "[Delays]"
setting[0][#setting[0]+1] = "clear_object_delay"
setting["clear_object_delay"] = 1000
setting[0][#setting[0]+1] = "clear_ped_delay"
setting["clear_ped_delay"] = 0
setting[0][#setting[0]+1] = "clear_vehicles_delay"
setting["clear_vehicles_delay"] = 500
setting[0][#setting[0]+1] = "clear_cops_delay"
setting["clear_cops_delay"] = 500
setting[0][#setting[0]+1] = "clear_all_delay"
setting["clear_all_delay"] = 1000
setting[0][#setting[0]+1] = "log_delay"
setting["log_delay"] = 500

setting[0][#setting[0]+1] = "section_3"
setting["section_3"] = "[Misc]"

setting[0][#setting[0]+1] = "section_4"
setting["section_4"] = "[log New Entities on Startup]"
setting[0][#setting[0]+1] = "log_new_objects"
setting["log_new_objects"] = false
setting[0][#setting[0]+1] = "log_new_vehicles"
setting["log_new_vehicles"] = false
setting[0][#setting[0]+1] = "log_new_peds"
setting["log_new_peds"] = false
setting[0][#setting[0]+1] = "log_new_pickups"
setting["log_new_pickups"] = false
setting[0][#setting[0]+1] = "log_new_entities"
setting["log_new_entities"] = false

setting[0][#setting[0]+1] = "section_5"
setting["section_5"] = "[Kill .log Files on Startup]"
setting[0][#setting[0]+1] = "destroylog"
setting["destroylog"] = false

setting[0][#setting[0]+1] = "section_6"
setting["section_6"] = "[Clear Area Range]"
setting[0][#setting[0]+1] = "clear_objects_area"
setting["clear_objects_area"] = 250
setting[0][#setting[0]+1] = "clear_objects_area_t"
setting["clear_objects_area_t"] = 250
setting[0][#setting[0]+1] = "clear_ped_area"
setting["clear_ped_area"] = 250
setting[0][#setting[0]+1] = "clear_ped_area_t"
setting["clear_ped_area_t"] = 250
setting[0][#setting[0]+1] = "clear_vehicle_area"
setting["clear_vehicle_area"] = 250
setting[0][#setting[0]+1] = "clear_vehicle_area_t"
setting["clear_vehicle_area_t"] = 250
setting[0][#setting[0]+1] = "clear_pickups_area"
setting["clear_pickups_area"] = 250
setting[0][#setting[0]+1] = "clear_pickups_area_t"
setting["clear_pickups_area_t"] = 250
setting[0][#setting[0]+1] = "clear_cops_area"
setting["clear_cops_area"] = 250
setting[0][#setting[0]+1] = "clear_cops_area_t"
setting["clear_cops_area_t"] = 250
setting[0][#setting[0]+1] = "clear_all_area"
setting["clear_all_area"] = 250
setting[0][#setting[0]+1] = "clear_all_area_t"
setting["clear_all_area_t"] = 250

setting[0][#setting[0]+1] = "section_7"
setting["section_7"] = "[Misc logs Enabled on Startup]"
setting[0][#setting[0]+1] = "net_event_log"
setting["net_event_log"] = false
setting[0][#setting[0]+1] = "script_event_log"
setting["script_event_log"] = false
setting[0][#setting[0]+1] = "player_log"
setting["player_log"] = false
setting[0][#setting[0]+1] = "modder_log"
setting["modder_log"] = false
setting[0][#setting[0]+1] = "attack_log"
setting["attack_log"] = false

setting[0][#setting[0]+1] = "section_8"
setting["section_8"] = "[Clear Area Req Ctrl limit]"
setting[0][#setting[0]+1] = "clr_obj_req_ctrl_limit"
setting["clr_obj_req_ctrl_limit"] = 10
setting[0][#setting[0]+1] = "clr_veh_req_ctrl_limit"
setting["clr_veh_req_ctrl_limit"] = 10
setting[0][#setting[0]+1] = "clr_ped_req_ctrl_limit"
setting["clr_ped_req_ctrl_limit"] = 10
setting[0][#setting[0]+1] = "clr_pus_req_ctrl_limit"
setting["clr_pus_req_ctrl_limit"] = 10

setting[0][#setting[0]+1] = "section_9"
setting["section_9"] = "[Clear Area Req Ctrl delay]"
setting[0][#setting[0]+1] = "clr_obj_req_ctrl_del"
setting["clr_obj_req_ctrl_del"] = 100
setting[0][#setting[0]+1] = "clr_veh_req_ctrl_del"
setting["clr_veh_req_ctrl_del"] = 100
setting[0][#setting[0]+1] = "clr_ped_req_ctrl_del"
setting["clr_ped_req_ctrl_del"] = 100
setting[0][#setting[0]+1] = "clr_pus_req_ctrl_del"
setting["clr_pus_req_ctrl_del"] = 50

setting[0][#setting[0]+1] = "section_10"
setting["section_10"] = "[Net Event settings]"
setting[0][#setting[0]+1] = "OBJECT_ID_FREED_EVENT"
setting["OBJECT_ID_FREED_EVENT"] = 0
setting[0][#setting[0]+1] = "OBJECT_ID_REQUEST_EVENT"
setting["OBJECT_ID_REQUEST_EVENT"] = 0
setting[0][#setting[0]+1] = "ARRAY_DATA_VERIFY_EVENT"
setting["ARRAY_DATA_VERIFY_EVENT"] = 0
setting[0][#setting[0]+1] = "SCRIPT_ARRAY_DATA_VERIFY_EVENT"
setting["SCRIPT_ARRAY_DATA_VERIFY_EVENT"] = 0
setting[0][#setting[0]+1] = "REQUEST_CONTROL_EVENT"
setting["REQUEST_CONTROL_EVENT"] = 0
setting[0][#setting[0]+1] = "GIVE_CONTROL_EVENT"
setting["GIVE_CONTROL_EVENT"] = 0
setting[0][#setting[0]+1] = "WEAPON_DAMAGE_EVENT"
setting["WEAPON_DAMAGE_EVENT"] = 0
setting[0][#setting[0]+1] = "REQUEST_PICKUP_EVENT"
setting["REQUEST_PICKUP_EVENT"] = 0
setting[0][#setting[0]+1] = "REQUEST_MAP_PICKUP_EVENT"
setting["REQUEST_MAP_PICKUP_EVENT"] = 0
setting[0][#setting[0]+1] = "GAME_CLOCK_EVENT"
setting["GAME_CLOCK_EVENT"] = 0
setting[0][#setting[0]+1] = "GAME_WEATHER_EVENT"
setting["GAME_WEATHER_EVENT"] = 0
setting[0][#setting[0]+1] = "RESPAWN_PLAYER_PED_EVENT"
setting["RESPAWN_PLAYER_PED_EVENT"] = 0
setting[0][#setting[0]+1] = "GIVE_WEAPON_EVENT"
setting["GIVE_WEAPON_EVENT"] = 0
setting[0][#setting[0]+1] = "REMOVE_WEAPON_EVENT"
setting["REMOVE_WEAPON_EVENT"] = 0
setting[0][#setting[0]+1] = "REMOVE_ALL_WEAPONS_EVENT"
setting["REMOVE_ALL_WEAPONS_EVENT"] = 0
setting[0][#setting[0]+1] = "VEHICLE_COMPONENT_CONTROL_EVENT"
setting["VEHICLE_COMPONENT_CONTROL_EVENT"] = 0
setting[0][#setting[0]+1] = "FIRE_EVENT"
setting["FIRE_EVENT"] = 0
setting[0][#setting[0]+1] = "EXPLOSION_EVENT"
setting["EXPLOSION_EVENT"] = 0
setting[0][#setting[0]+1] = "START_PROJECTILE_EVENT"
setting["START_PROJECTILE_EVENT"] = 0
setting[0][#setting[0]+1] = "UPDATE_PROJECTILE_TARGET_EVENT"
setting["UPDATE_PROJECTILE_TARGET_EVENT"] = 0
setting[0][#setting[0]+1] = "BREAK_PROJECTILE_TARGET_LOCK_EVENT"
setting["BREAK_PROJECTILE_TARGET_LOCK_EVENT"] = 0
setting[0][#setting[0]+1] = "REMOVE_PROJECTILE_ENTITY_EVENT"
setting["REMOVE_PROJECTILE_ENTITY_EVENT"] = 0
setting[0][#setting[0]+1] = "ALTER_WANTED_LEVEL_EVENT"
setting["ALTER_WANTED_LEVEL_EVENT"] = 0
setting[0][#setting[0]+1] = "CHANGE_RADIO_STATION_EVENT"
setting["CHANGE_RADIO_STATION_EVENT"] = 0
setting[0][#setting[0]+1] = "RAGDOLL_REQUEST_EVENT"
setting["RAGDOLL_REQUEST_EVENT"] = 0
setting[0][#setting[0]+1] = "PLAYER_TAUNT_EVENT"
setting["PLAYER_TAUNT_EVENT"] = 0
setting[0][#setting[0]+1] = "PLAYER_CARD_STAT_EVENT"
setting["PLAYER_CARD_STAT_EVENT"] = 0
setting[0][#setting[0]+1] = "DOOR_BREAK_EVENT"
setting["DOOR_BREAK_EVENT"] = 0
setting[0][#setting[0]+1] = "SCRIPTED_GAME_EVENT"
setting["SCRIPTED_GAME_EVENT"] = 0
setting[0][#setting[0]+1] = "REMOTE_SCRIPT_INFO_EVENT"
setting["REMOTE_SCRIPT_INFO_EVENT"] = 0
setting[0][#setting[0]+1] = "REMOTE_SCRIPT_LEAVE_EVENT"
setting["REMOTE_SCRIPT_LEAVE_EVENT"] = 0
setting[0][#setting[0]+1] = "MARK_AS_NO_LONGER_NEEDED_EVENT"
setting["MARK_AS_NO_LONGER_NEEDED_EVENT"] = 0
setting[0][#setting[0]+1] = "CONVERT_TO_SCRIPT_ENTITY_EVENT"
setting["CONVERT_TO_SCRIPT_ENTITY_EVENT"] = 0
setting[0][#setting[0]+1] = "SCRIPT_WORLD_STATE_EVENT"
setting["SCRIPT_WORLD_STATE_EVENT"] = 0
setting[0][#setting[0]+1] = "INCIDENT_ENTITY_EVENT"
setting["INCIDENT_ENTITY_EVENT"] = 0
setting[0][#setting[0]+1] = "CLEAR_AREA_EVENT"
setting["CLEAR_AREA_EVENT"] = 0
setting[0][#setting[0]+1] = "CLEAR_RECTANGLE_AREA_EVENT"
setting["CLEAR_RECTANGLE_AREA_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_REQUEST_SYNCED_SCENE_EVENT"
setting["NETWORK_REQUEST_SYNCED_SCENE_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_START_SYNCED_SCENE_EVENT"
setting["NETWORK_START_SYNCED_SCENE_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_UPDATE_SYNCED_SCENE_EVENT"
setting["NETWORK_UPDATE_SYNCED_SCENE_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_STOP_SYNCED_SCENE_EVENT"
setting["NETWORK_STOP_SYNCED_SCENE_EVENT"] = 0
setting[0][#setting[0]+1] = "GIVE_PED_SCRIPTED_TASK_EVENT"
setting["GIVE_PED_SCRIPTED_TASK_EVENT"] = 0
setting[0][#setting[0]+1] = "GIVE_PED_SEQUENCE_TASK_EVENT"
setting["GIVE_PED_SEQUENCE_TASK_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_CLEAR_PED_TASKS_EVENT"
setting["NETWORK_CLEAR_PED_TASKS_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_START_PED_ARREST_EVENT"
setting["NETWORK_START_PED_ARREST_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_START_PED_UNCUFF_EVENT"
setting["NETWORK_START_PED_UNCUFF_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_SOUND_CAR_HORN_EVENT"
setting["NETWORK_SOUND_CAR_HORN_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_ENTITY_AREA_STATUS_EVENT"
setting["NETWORK_ENTITY_AREA_STATUS_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_GARAGE_OCCUPIED_STATUS_EVENT"
setting["NETWORK_GARAGE_OCCUPIED_STATUS_EVENT"] = 0
setting[0][#setting[0]+1] = "PED_CONVERSATION_LINE_EVENT"
setting["PED_CONVERSATION_LINE_EVENT"] = 0
setting[0][#setting[0]+1] = "SCRIPT_ENTITY_STATE_CHANGE_EVENT"
setting["SCRIPT_ENTITY_STATE_CHANGE_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_PLAY_SOUND_EVENT"
setting["NETWORK_PLAY_SOUND_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_STOP_SOUND_EVENT"
setting["NETWORK_STOP_SOUND_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_PLAY_AIRDEFENSE_FIRE_EVENT"
setting["NETWORK_PLAY_AIRDEFENSE_FIRE_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_BANK_REQUEST_EVENT"
setting["NETWORK_BANK_REQUEST_EVENT"] = 0
setting[0][#setting[0]+1] = "NETWORK_AUDIO_BARK_EVENT"
setting["NETWORK_AUDIO_BARK_EVENT"] = 0
setting[0][#setting[0]+1]= "REQUEST_DOOR_EVENT"
setting["REQUEST_DOOR_EVENT"] = 0
setting[0][#setting[0]+1]= "NETWORK_TRAIN_REQUEST_EVENT"
setting["NETWORK_TRAIN_REQUEST_EVENT"] = 0
setting[0][#setting[0]+1]= "NETWORK_TRAIN_REPORT_EVENT"
setting["NETWORK_TRAIN_REPORT_EVENT"] = 0
setting[0][#setting[0]+1]= "NETWORK_INCREMENT_STAT_EVENT"
setting["NETWORK_INCREMENT_STAT_EVENT"] = 0
setting[0][#setting[0]+1]= "MODIFY_VEHICLE_LOCK_WORD_STATE_DATA"
setting["MODIFY_VEHICLE_LOCK_WORD_STATE_DATA"] = 0
setting[0][#setting[0]+1]= "MODIFY_PTFX_WORD_STATE_DATA_SCRIPTED_EVOLVE_EVENT"
setting["MODIFY_PTFX_WORD_STATE_DATA_SCRIPTED_EVOLVE_EVENT"] = 0
setting[0][#setting[0]+1]= "REQUEST_PHONE_EXPLOSION_EVENT"
setting["REQUEST_PHONE_EXPLOSION_EVENT"] = 0
setting[0][#setting[0]+1]= "REQUEST_DETACHMENT_EVENT"
setting["REQUEST_DETACHMENT_EVENT"] = 0
setting[0][#setting[0]+1]= "KICK_VOTES_EVENT"
setting["KICK_VOTES_EVENT"] = 0
setting[0][#setting[0]+1]= "GIVE_PICKUP_REWARDS_EVENT"
setting["GIVE_PICKUP_REWARDS_EVENT"] = 0
setting[0][#setting[0]+1]= "NETWORK_CRC_HASH_CHECK_EVENT"
setting["NETWORK_CRC_HASH_CHECK_EVENT"] = 0
setting[0][#setting[0]+1]= "BLOW_UP_VEHICLE_EVENT"
setting["BLOW_UP_VEHICLE_EVENT"] = 0
setting[0][#setting[0]+1]= "NETWORK_SPECIAL_FIRE_EQUIPPED_WEAPON"
setting["NETWORK_SPECIAL_FIRE_EQUIPPED_WEAPON"] = 0
setting[0][#setting[0]+1]= "NETWORK_RESPONDED_TO_THREAT_EVENT"
setting["NETWORK_RESPONDED_TO_THREAT_EVENT"] = 0
setting[0][#setting[0]+1]= "NETWORK_SHOUT_TARGET_POSITION"
setting["NETWORK_SHOUT_TARGET_POSITION"] = 0
setting[0][#setting[0]+1]= "VOICE_DRIVEN_MOUTH_MOVEMENT_FINISHED_EVENT"
setting["VOICE_DRIVEN_MOUTH_MOVEMENT_FINISHED_EVENT"] = 0
setting[0][#setting[0]+1]= "PICKUP_DESTROYED_EVENT"
setting["PICKUP_DESTROYED_EVENT"] = 0
setting[0][#setting[0]+1]= "UPDATE_PLAYER_SCARS_EVENT"
setting["UPDATE_PLAYER_SCARS_EVENT"] = 0
setting[0][#setting[0]+1]= "NETWORK_CHECK_EXE_SIZE_EVENT"
setting["NETWORK_CHECK_EXE_SIZE_EVENT"] = 0
setting[0][#setting[0]+1]= "NETWORK_PTFX_EVENT"
setting["NETWORK_PTFX_EVENT"] = 0
setting[0][#setting[0]+1]= "NETWORK_PED_SEEN_DEAD_PED_EVENT"
setting["NETWORK_PED_SEEN_DEAD_PED_EVENT"] = 0
setting[0][#setting[0]+1]= "REMOVE_STICKY_BOMB_EVENT"
setting["REMOVE_STICKY_BOMB_EVENT"] = 0
setting[0][#setting[0]+1]= "NETWORK_CHECK_CODE_CRCS_EVENT"
setting["NETWORK_CHECK_CODE_CRCS_EVENT"] = 0
setting[0][#setting[0]+1]= "INFORM_SILENCED_GUNSHOT_EVENT"
setting["INFORM_SILENCED_GUNSHOT_EVENT"] = 0
setting[0][#setting[0]+1]= "PED_PLAY_PAIN_EVENT"
setting["PED_PLAY_PAIN_EVENT"] = 0
setting[0][#setting[0]+1]= "CACHE_PLAYER_HEAD_BLEND_DATA_EVENT"
setting["CACHE_PLAYER_HEAD_BLEND_DATA_EVENT"] = 0
setting[0][#setting[0]+1]= "REMOVE_PED_FROM_PEDGROUP_EVENT"
setting["REMOVE_PED_FROM_PEDGROUP_EVENT"] = 0
setting[0][#setting[0]+1]= "REPORT_MYSELF_EVENT"
setting["REPORT_MYSELF_EVENT"] = 0
setting[0][#setting[0]+1]= "REPORT_CASH_SPAWN_EVENT"
setting["REPORT_CASH_SPAWN_EVENT"] = 0
setting[0][#setting[0]+1]= "ACTIVATE_VEHICLE_SPECIAL_ABILITY_EVENT"
setting["ACTIVATE_VEHICLE_SPECIAL_ABILITY_EVENT"] = 0
setting[0][#setting[0]+1]= "BLOCK_WEAPON_SELECTION"
setting["BLOCK_WEAPON_SELECTION"] = 0
setting[0][#setting[0]+1]= "NETWORK_CHECK_CATALOG_CRC"
setting["NETWORK_CHECK_CATALOG_CRC"] = 0

local function SaveSettings()
local settings_file = io.open(utilities_home.."\\Utilities.ini", "w")
    io.output(settings_file)
    for i = 1, #setting[0] do
        local C = setting[0][i]
        if string.find(C, "section", 1) == nil then
            io.write(C .. "=" .. tostring(setting[C]) .. "\n")
        else
            io.write(tostring(setting[C]) .. "\n")
        end
    end
io.close(settings_file)
end

local _file = io.open(utilities_home.."\\Utilities.ini", "r")
if _file ~= nil then
    for value in io.lines(utilities_home.."\\Utilities.ini") do
        if string.find(value, "]", 1) == nil then
            local index = ""
            while string.find(value, "=", 1) ~= nil do
                index = index .. string.sub(value, 1, 1)
                value = string.sub(value, 2)
            end
            index = string.sub(index, 1, #index - 1)
            if setting[index] ~= nil then
                if value == "true" then
                    setting[index] = true
                elseif value == "false" then
                    setting[index] = false
                elseif type(value) == "number" then
                    setting[index] = tonumber(value)
                else
                    setting[index] = value
                end
            else
                ui.notify_above_map("You got an old settings file, unfortunately i cant read it :(\nPlease save settings first.", script_name, 130)
                local dbglse = ("Old settings file detected, stopping reading it.")
                dbg(dbglse, "[Load Settings]", "Debug.log")
            end
        end
    end
    io.close(_file)
else
    SaveSettings()
end

local function ReadSettings()
local i = 1
    for li in io.lines(utilities_home.."\\Utilities.ini") do
        -- this line below will remove 'leave_session=' from the string line. the rest is just the value
        li = string.gsub(li, "".."=", "")
        -- with this i set the value from the file into settings variable
        setting[""] = li
        i = i + 1
    end
end

-- WIP, plz ignore
-- Clear Objects blacklist (use the object hash)
local co_blacklist = {238789712}
-- Clear Vehicles blacklist (use the vehicle hash)
local cv_blacklist = {}
-- Clear Peds blacklist (use the ped hash)
local cp_blacklist = {}

local dbg_vers = ("["..script_name.." "..setting["version"].."]")
dbg(dbg_vers, "[Version Check]", "Debug.log")

-- submenus
local utilities = menu.add_feature("Utilities", "parent", 0).id
local clear_area = menu.add_feature("Clear Area", "parent", utilities).id
--local misc_shit = menu.add_feature("Misc Shit", "parent", utilities).id
local new_entity_log = menu.add_feature("New Entity log", "parent", utilities).id
local log_misc = menu.add_feature("Misc log", "parent", utilities).id
local entity_manager = menu.add_feature("(WIP)Entity Manager", "parent", utilities).id
local log_cleanup = menu.add_feature("log Cleanup", "parent", utilities).id
local settings_menu = menu.add_feature("Settings", "parent", utilities).id


local pl_utilities = menu.add_player_feature("Utilities", "parent", 0, nil).id
local pl_ent_shit = menu.add_player_feature("Entity Shit", "parent", pl_utilities, nil).id

local oob = v3() -- used to teleport entities to out of bounds, for GTA to delete.
oob.x = -5784.258301
oob.y = -8289.385742
oob.z = -136.411270

local MyId = player.player_id
local getPed = player.get_player_ped
local function MyPed()
    return getPed(MyId())
end
local getCoords = entity.get_entity_coords
local function MyPos(ped)
    return getCoords(ped or MyPed())
end
local getVeh = ped.get_vehicle_ped_is_using
local function MyVeh(ped)
    return getVeh(ped or MyPed())
end

local function ValidScid(scid)
    return scid ~= -1 and scid ~= 4294967295
end

local function pl_scid(pid)
    return player.get_player_scid(pid)
end
local function pl_name(pid)
    return player.get_player_name(pid)
end
local function Pl_Ped(pid)
    return getPed(pid)
end
local function Pl_Pos(pl_ped, pid)
    return getCoords(pl_ped or Pl_Ped(pid))
end
local function Pl_Veh(pl_ped, pid)
    return getVeh(pl_ped or Pl_Ped(pid))
end

local knownObjects = {}
local knownPeds = {}
local knownVehicles = {}
local knownPickups  = {}

--[[ used for  new entity logs
local knownObjects = {}
if utils.file_exists(objlog) then
for line in io.lines(objlog) do
    local hash = tonumber(line)
    if hash then knownObjects[hash] = true end
end
end
local knownPeds = {}
if utils.file_exists(pedlog) then
for line in io.lines(pedlog) do
    local hash = tonumber(line)
    if hash then knownPeds[hash] = true end
end
end
local knownVehicles = {}
if utils.file_exists(vehlog) then
for line in io.lines(vehlog) do
    local hash = tonumber(line)
    if hash then knownVehicles[hash] = true end
end
end
local knownPickups = {}
if utils.file_exists(pulog) then
for line in io.lines(pulog) do
    local hash = tonumber(line)
    if hash then knownPickups[hash] = true end
end
end
]]
-- clear area functions
local function ClearObjects(area)
    local objects = object.get_all_objects()
    local myPed = MyPed()
    local myPos = MyPos(myPed)
    for j=1, #objects do
        if myPos:magnitude(MyPos(objects[j])) <= area then
            local objhash = entity.get_entity_model_hash(objects[j])
            local objmodel = objectmapper.GetModelFromHash(objhash)
            network.request_control_of_entity(objects[j])
            local CheckCount = 0
            while not network.has_control_of_entity(objects[j]) do
                system.wait(setting["clr_obj_req_ctrl_del"])
                CheckCount = CheckCount + 1
                dbg("[Entity Type: Object] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..objects[j].."]", "[Clear Objects]", "ClearAreaDebug.log")
                if CheckCount > tonumber(setting["clr_obj_req_ctrl_limit"]) then
                    dbg("[Entity Type: Object] [Request Control Failed] [Entity ID: "..objects[j].."]", "[Clear Objects]", "ClearAreaDebug.log")
                break end --So we don't infinite loop for some reason if we can't get control
            end
            entity.set_entity_as_no_longer_needed(objects[j])
            local clearobjlog = ("[Entity Type: Object] [Entity ID: "..objects[j].."] [Entity Hash: "..objhash.."] [Model Name: "..(objmodel or "unknown").."]")
            log(clearobjlog, "[Clear Objects]", "Cleanup.log")
            dbg("[Entity Type: Object] [Request Control Succeeded] [Entity ID: "..objects[j].."]", "[Clear Objects]", "ClearAreaDebug.log")
            entity.set_entity_coords_no_offset(objects[j], oob)
        end
    end
end

local function ClearPeds(area)
    local peds = ped.get_all_peds()
    local myPed = MyPed()
    local myPos = MyPos(myPed)
    for k=1, #peds do
        local pped = ped.is_ped_a_player(peds[k])
        if pped ~= peds[k] and myPed ~= peds[k] and myPos:magnitude(MyPos(peds[k])) <= area then
            network.request_control_of_entity(peds[k])
            local CheckCount = 0
            while not network.has_control_of_entity(peds[k]) do
                system.wait(setting["clr_ped_req_ctrl_del"])
                CheckCount = CheckCount + 1
                dbg("[Entity Type: Ped] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..peds[k].."]", "[Clear Peds]", "ClearAreaDebug.log")
                if CheckCount > tonumber(setting["clr_ped_req_ctrl_limit"]) then
                    dbg("[Entity Type: Ped] [Request Control Failed] [Entity ID: "..peds[k].."]", "[Clear Peds]", "ClearAreaDebug.log")
                break end --So we don't infinite loop for some reason if we can't get control
            end
            entity.set_entity_as_mission_entity(peds[k], 0, 1)
            entity.set_entity_as_no_longer_needed(peds[k])
            local pedhash = entity.get_entity_model_hash(peds[k])
            local pedmodel = pedmapper.GetModelFromHash(pedhash)
            local clearpedlog = ("[Entity Type: Ped] [Entity ID: "..peds[k].."] [Entity Hash: "..pedhash.."] [Model Name: "..(pedmodel or "unknown").."]")
            log(clearpedlog, "[Clear Peds]", "Cleanup.log")
            dbg("[Entity Type: Ped] [Request Control Succeeded] [Entity ID: "..peds[k].."]", "[Clear Peds]", "ClearAreaDebug.log")
            entity.set_entity_coords_no_offset(peds[k], oob)
        end
    end
end

local function ClearVehicles(area)
    local vehicles = vehicle.get_all_vehicles()
    local myPed = MyPed()
    local myPos = MyPos(myPed)
    local myVeh = MyVeh(myPed)
    for l=1, #vehicles do
        if myVeh ~= vehicles[l] and myPos:magnitude(MyPos(vehicles[l])) <= area then
            network.request_control_of_entity(vehicles[l])
            local CheckCount = 0
            while not network.has_control_of_entity(vehicles[l]) do
                system.wait(setting["clr_veh_req_ctrl_del"])
                CheckCount = CheckCount + 1
                dbg("[Entity Type: Vehicle] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..vehicles[l].."]", "[Clear Vehicles]", "ClearAreaDebug.log")
                if CheckCount > tonumber(setting["clr_veh_req_ctrl_limit"]) then
                    dbg("[Entity Type: Vehicle] [Request Control Failed] [Entity ID: "..vehicles[l].."]", "[Clear Vehicles", "ClearAreaDebug.log")
                break end --So we don't infinite loop for some reason if we can't get control
            end
            entity.set_entity_as_mission_entity(vehicles[l], 0, 1)
            entity.set_entity_as_no_longer_needed(vehicles[l])
            local vehhash = entity.get_entity_model_hash(vehicles[l])
            local vehmodel = vehiclemapper.GetModelFromHash(vehhash)
            local clearvehlog = ("[Entity Type: Vehicle] [Entity ID: "..vehicles[l].."] [Entity Hash: "..vehhash.."] [Model Name: "..(vehmodel or "unknown").."]")
            log(clearvehlog, "[Clear Vehicles]", "Cleanup.log")
            dbg("[Entity Type: Vehicle] [Request Control Succeeded] [Entity ID: "..vehicles[l].."]", "[Clear Vehicles]", "ClearAreaDebug.log")
            entity.set_entity_coords_no_offset(vehicles[l], oob)
        end
    end
end

local function ClearPickups(area)
    local pickups = object.get_all_pickups()
    local myPed = MyPed()
    local myPos = MyPos(myPed)
    for m=1, #pickups do
        if myPos:magnitude(MyPos(pickups[m])) <= area then
            network.request_control_of_entity(pickups[m])
            local CheckCount = 0
            while not network.has_control_of_entity(pickups[m]) do
                system.wait(setting["clr_obj_req_ctrl_del"])
                CheckCount = CheckCount + 1
                dbg("[Entity Type: Pickups] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pickups[m].."]", "[Clear Pickups]", "ClearAreaDebug.log")
                if CheckCount > tonumber(setting["clr_obj_req_ctrl_del"]) then
                    dbg("[Entity Type: Pickup] [Request Control Failed] [Entity ID: "..pickups[m].."]", "[Clear Pickups]", "ClearAreaDebug.log")
                break end --So we don't infinite loop for some reason if we can't get control
            end
            entity.set_entity_as_no_longer_needed(pickups[m])
            local puhash = entity.get_entity_model_hash(pickups[m])
            local pumodel = objectmapper.GetModelFromHash(puhash)
            local clearpulog = ("[Entity Type: Pickup] [Entity ID: "..pickups[m].."] [Entity Hash: "..puhash.."] [Model Name: "..(pumodel or "unknown").."]")
            log(clearpulog, "[Clear Pickups]", "Cleanup.log")
            dbg("[Entity Type: Pickup] [Request Control Succeeded] [Entity ID: "..pickups[m].."]", "[Clear Pickups]", "ClearAreaDebug.log")
            entity.set_entity_coords_no_offset(pickups[m], oob)
        end
    end
end

local function ClearCops(area)
    local myPed = MyPed()
    local myPos = MyPos(myPed)
    gameplay.clear_area_of_cops(myPos, area, true)
end

--NetEventHook function shit
local NHFunctions = {}
local NetHookId = {}

NHFunctions[0] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 0 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["OBJECT_ID_FREED_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["OBJECT_ID_FREED_EVENT"] == 2 then
            return true
        elseif setting["OBJECT_ID_FREED_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end

NHFunctions[1] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 1 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["OBJECT_ID_REQUEST_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["OBJECT_ID_REQUEST_EVENT"] == 2 then
            return true
        elseif setting["OBJECT_ID_REQUEST_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end

NHFunctions[2] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 2 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["ARRAY_DATA_VERIFY_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["ARRAY_DATA_VERIFY_EVENT"] == 2 then
            return true
        elseif setting["ARRAY_DATA_VERIFY_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end

NHFunctions[3] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 3 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["SCRIPT_ARRAY_DATA_VERIFY_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["SCRIPT_ARRAY_DATA_VERIFY_EVENT"] == 2 then
            return true
        elseif setting["SCRIPT_ARRAY_DATA_VERIFY_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end

NHFunctions[4] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 4 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REQUEST_CONTROL_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REQUEST_CONTROL_EVENT"] == 2 then
            return true
        elseif setting["REQUEST_CONTROL_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end

NHFunctions[5] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 5 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["GIVE_CONTROL_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["GIVE_CONTROL_EVENT"] == 2 then
            return true
        elseif setting["GIVE_CONTROL_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end

NHFunctions[6] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 6 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["WEAPON_DAMAGE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["WEAPON_DAMAGE_EVENT"] == 2 then
            return true
        elseif setting["WEAPON_DAMAGE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end

NHFunctions[7] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 7 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REQUEST_PICKUP_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REQUEST_PICKUP_EVENT"] == 2 then
            return true
        elseif setting["REQUEST_PICKUP_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end

NHFunctions[8] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 8 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REQUEST_MAP_PICKUP_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REQUEST_MAP_PICKUP_EVENT"] == 2 then
            return true
        elseif setting["REQUEST_MAP_PICKUP_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end

NHFunctions[9] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 9 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["GAME_CLOCK_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["GAME_CLOCK_EVENT"] == 2 then
            return true
        elseif setting["GAME_CLOCK_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end

NHFunctions[10] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 10 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["GAME_WEATHER_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["GAME_WEATHER_EVENT"] == 2 then
            return true
        elseif setting["GAME_WEATHER_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[11] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 11 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["RESPAWN_PLAYER_PED_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["RESPAWN_PLAYER_PED_EVENT"] == 2 then
            return true
        elseif setting["RESPAWN_PLAYER_PED_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[12] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 12 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["GIVE_WEAPON_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["GIVE_WEAPON_EVENT"] == 2 then
            return true
        elseif setting["GIVE_WEAPON_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[13] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 13 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REMOVE_WEAPON_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REMOVE_WEAPON_EVENT"] == 2 then
            return true
        elseif setting["REMOVE_WEAPON_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[14] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 14 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REMOVE_ALL_WEAPONS_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REMOVE_ALL_WEAPONS_EVENT"] == 2 then
            return true
        elseif setting["REMOVE_ALL_WEAPONS_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[15] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 15 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["VEHICLE_COMPONENT_CONTROL_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["VEHICLE_COMPONENT_CONTROL_EVENT"] == 2 then
            return true
        elseif setting["VEHICLE_COMPONENT_CONTROL_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[16] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 16 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["FIRE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["FIRE_EVENT"] == 2 then
            return true
        elseif setting["FIRE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[17] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 17 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["EXPLOSION_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["EXPLOSION_EVENT"] == 2 then
            return true
        elseif setting["EXPLOSION_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[18] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 18 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["START_PROJECTILE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["START_PROJECTILE_EVENT"] == 2 then
            return true
        elseif setting["START_PROJECTILE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[19] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 19 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["UPDATE_PROJECTILE_TARGET_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["UPDATE_PROJECTILE_TARGET_EVENT"] == 2 then
            return true
        elseif setting["UPDATE_PROJECTILE_TARGET_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[20] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 20 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REMOVE_PROJECTILE_ENTITY_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REMOVE_PROJECTILE_ENTITY_EVENT"] == 2 then
            return true
        elseif setting["REMOVE_PROJECTILE_ENTITY_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[21] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 21 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["BREAK_PROJECTILE_TARGET_LOCK_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["BREAK_PROJECTILE_TARGET_LOCK_EVENT"] == 2 then
            return true
        elseif setting["BREAK_PROJECTILE_TARGET_LOCK_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[22] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 22 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["ALTER_WANTED_LEVEL_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["ALTER_WANTED_LEVEL_EVENT"] == 2 then
            return true
        elseif setting["ALTER_WANTED_LEVEL_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[23] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 23 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["CHANGE_RADIO_STATION_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["CHANGE_RADIO_STATION_EVENT"] == 2 then
            return true
        elseif setting["CHANGE_RADIO_STATION_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[24] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 24 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["RAGDOLL_REQUEST_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["RAGDOLL_REQUEST_EVENT"] == 2 then
            return true
        elseif setting["RAGDOLL_REQUEST_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[25] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 25 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["PLAYER_TAUNT_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["PLAYER_TAUNT_EVENT"] == 2 then
            return true
        elseif setting["PLAYER_TAUNT_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[26] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 26 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["PLAYER_CARD_STAT_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["PLAYER_CARD_STAT_EVENT"] == 2 then
            return true
        elseif setting["PLAYER_CARD_STAT_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[27] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 27 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["DOOR_BREAK_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["DOOR_BREAK_EVENT"] == 2 then
            return true
        elseif setting["DOOR_BREAK_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[28] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 28 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["SCRIPTED_GAME_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["SCRIPTED_GAME_EVENT"] == 2 then
            return true
        elseif setting["SCRIPTED_GAME_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[29] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 29 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REMOTE_SCRIPT_INFO_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REMOTE_SCRIPT_INFO_EVENT"] == 2 then
            return true
        elseif setting["REMOTE_SCRIPT_INFO_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[30] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 30 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REMOTE_SCRIPT_LEAVE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REMOTE_SCRIPT_LEAVE_EVENT"] == 2 then
            return true
        elseif setting["REMOTE_SCRIPT_LEAVE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[31] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 31 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["MARK_AS_NO_LONGER_NEEDED_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["MARK_AS_NO_LONGER_NEEDED_EVENT"] == 2 then
            return true
        elseif setting["MARK_AS_NO_LONGER_NEEDED_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[32] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 32 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["CONVERT_TO_SCRIPT_ENTITY_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["CONVERT_TO_SCRIPT_ENTITY_EVENT"] == 2 then
            return true
        elseif setting["CONVERT_TO_SCRIPT_ENTITY_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[33] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 33 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["SCRIPT_WORLD_STATE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["SCRIPT_WORLD_STATE_EVENT"] == 2 then
            return true
        elseif setting["SCRIPT_WORLD_STATE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[34] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 34 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["CLEAR_AREA_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["CLEAR_AREA_EVENT"] == 2 then
            return true
        elseif setting["CLEAR_AREA_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[35] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 35 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["CLEAR_RECTANGLE_AREA_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["CLEAR_RECTANGLE_AREA_EVENT"] == 2 then
            return true
        elseif setting["CLEAR_RECTANGLE_AREA_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[36] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 36 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_REQUEST_SYNCED_SCENE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_REQUEST_SYNCED_SCENE_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_REQUEST_SYNCED_SCENE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[37] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 37 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_START_SYNCED_SCENE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_START_SYNCED_SCENE_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_START_SYNCED_SCENE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[38] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 38 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_STOP_SYNCED_SCENE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_STOP_SYNCED_SCENE_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_STOP_SYNCED_SCENE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[39] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 39 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_UPDATE_SYNCED_SCENE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_UPDATE_SYNCED_SCENE_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_UPDATE_SYNCED_SCENE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[40] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 40 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["INCIDENT_ENTITY_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["INCIDENT_ENTITY_EVENT"] == 2 then
            return true
        elseif setting["INCIDENT_ENTITY_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[41] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 41 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["GIVE_PED_SCRIPTED_TASK_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["GIVE_PED_SCRIPTED_TASK_EVENT"] == 2 then
            return true
        elseif setting["GIVE_PED_SCRIPTED_TASK_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[42] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 42 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["GIVE_PED_SEQUENCE_TASK_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["GIVE_PED_SEQUENCE_TASK_EVENT"] == 2 then
            return true
        elseif setting["GIVE_PED_SEQUENCE_TASK_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[43] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 43 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_CLEAR_PED_TASKS_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_CLEAR_PED_TASKS_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_CLEAR_PED_TASKS_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[44] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 44 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_START_PED_ARREST_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_START_PED_ARREST_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_START_PED_ARREST_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[45] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 45 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_START_PED_UNCUFF_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_START_PED_UNCUFF_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_START_PED_UNCUFF_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[46] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 46 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_SOUND_CAR_HORN_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_SOUND_CAR_HORN_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_SOUND_CAR_HORN_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[47] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 47 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_ENTITY_AREA_STATUS_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_ENTITY_AREA_STATUS_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_ENTITY_AREA_STATUS_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[48] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 48 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_GARAGE_OCCUPIED_STATUS_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_GARAGE_OCCUPIED_STATUS_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_GARAGE_OCCUPIED_STATUS_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[49] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 49 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["PED_CONVERSATION_LINE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["PED_CONVERSATION_LINE_EVENT"] == 2 then
            return true
        elseif setting["PED_CONVERSATION_LINE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[50] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 50 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["SCRIPT_ENTITY_STATE_CHANGE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["SCRIPT_ENTITY_STATE_CHANGE_EVENT"] == 2 then
            return true
        elseif setting["SCRIPT_ENTITY_STATE_CHANGE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[51] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 51 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_PLAY_SOUND_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_PLAY_SOUND_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_PLAY_SOUND_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[52] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 52 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_STOP_SOUND_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_STOP_SOUND_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_STOP_SOUND_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[53] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 53 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_PLAY_AIRDEFENSE_FIRE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_PLAY_AIRDEFENSE_FIRE_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_PLAY_AIRDEFENSE_FIRE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[54] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 54 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_BANK_REQUEST_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_BANK_REQUEST_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_BANK_REQUEST_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[55] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 55 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_AUDIO_BARK_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_AUDIO_BARK_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_AUDIO_BARK_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[56] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 56 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REQUEST_DOOR_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REQUEST_DOOR_EVENT"] == 2 then
            return true
        elseif setting["REQUEST_DOOR_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[57] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 57 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_TRAIN_REPORT_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_TRAIN_REPORT_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_TRAIN_REPORT_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[58] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 58 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_TRAIN_REQUEST_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_TRAIN_REQUEST_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_TRAIN_REQUEST_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[59] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 59 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_INCREMENT_STAT_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_INCREMENT_STAT_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_INCREMENT_STAT_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[60] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 60 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["MODIFY_VEHICLE_LOCK_WORD_STATE_DATA"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["MODIFY_VEHICLE_LOCK_WORD_STATE_DATA"] == 2 then
            return true
        elseif setting["MODIFY_VEHICLE_LOCK_WORD_STATE_DATA"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[61] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 61 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["MODIFY_PTFX_WORD_STATE_DATA_SCRIPTED_EVOLVE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["MODIFY_PTFX_WORD_STATE_DATA_SCRIPTED_EVOLVE_EVENT"] == 2 then
            return true
        elseif setting["MODIFY_PTFX_WORD_STATE_DATA_SCRIPTED_EVOLVE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[62] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 62 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REQUEST_PHONE_EXPLOSION_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REQUEST_PHONE_EXPLOSION_EVENT"] == 2 then
            return true
        elseif setting["REQUEST_PHONE_EXPLOSION_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[63] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 63 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REQUEST_DETACHMENT_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REQUEST_DETACHMENT_EVENT"] == 2 then
            return true
        elseif setting["REQUEST_DETACHMENT_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[64] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 64 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["KICK_VOTES_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["KICK_VOTES_EVENT"] == 2 then
            return true
        elseif setting["KICK_VOTES_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[65] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 65 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["GIVE_PICKUP_REWARDS_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["GIVE_PICKUP_REWARDS_EVENT"] == 2 then
            return true
        elseif setting["GIVE_PICKUP_REWARDS_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[66] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 66 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_CRC_HASH_CHECK_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_CRC_HASH_CHECK_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_CRC_HASH_CHECK_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[67] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 67 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["BLOW_UP_VEHICLE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["BLOW_UP_VEHICLE_EVENT"] == 2 then
            return true
        elseif setting["BLOW_UP_VEHICLE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[68] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 68 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_SPECIAL_FIRE_EQUIPPED_WEAPON"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_SPECIAL_FIRE_EQUIPPED_WEAPON"] == 2 then
            return true
        elseif setting["NETWORK_SPECIAL_FIRE_EQUIPPED_WEAPON"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[69] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 69 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_RESPONDED_TO_THREAT_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_RESPONDED_TO_THREAT_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_RESPONDED_TO_THREAT_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[70] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 70 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_SHOUT_TARGET_POSITION"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_SHOUT_TARGET_POSITION"] == 2 then
            return true
        elseif setting["NETWORK_SHOUT_TARGET_POSITION"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[71] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 71 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["VOICE_DRIVEN_MOUTH_MOVEMENT_FINISHED_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["VOICE_DRIVEN_MOUTH_MOVEMENT_FINISHED_EVENT"] == 2 then
            return true
        elseif setting["VOICE_DRIVEN_MOUTH_MOVEMENT_FINISHED_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[72] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 72 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["PICKUP_DESTROYED_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["PICKUP_DESTROYED_EVENT"] == 2 then
            return true
        elseif setting["PICKUP_DESTROYED_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[73] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 73 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["UPDATE_PLAYER_SCARS_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["UPDATE_PLAYER_SCARS_EVENT"] == 2 then
            return true
        elseif setting["UPDATE_PLAYER_SCARS_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[74] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 74 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_CHECK_EXE_SIZE_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_CHECK_EXE_SIZE_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_CHECK_EXE_SIZE_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[75] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 75 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_PTFX_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_PTFX_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_PTFX_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[76] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 76 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_PED_SEEN_DEAD_PED_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_PED_SEEN_DEAD_PED_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_PED_SEEN_DEAD_PED_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[77] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 77 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REMOVE_STICKY_BOMB_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REMOVE_STICKY_BOMB_EVENT"] == 2 then
            return true
        elseif setting["REMOVE_STICKY_BOMB_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[78] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 78 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_CHECK_CODE_CRCS_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_CHECK_CODE_CRCS_EVENT"] == 2 then
            return true
        elseif setting["NETWORK_CHECK_CODE_CRCS_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[79] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 79 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["INFORM_SILENCED_GUNSHOT_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["INFORM_SILENCED_GUNSHOT_EVENT"] == 2 then
            return true
        elseif setting["INFORM_SILENCED_GUNSHOT_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[80] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 80 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["PED_PLAY_PAIN_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["PED_PLAY_PAIN_EVENT"] == 2 then
            return true
        elseif setting["PED_PLAY_PAIN_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[81] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 81 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["CACHE_PLAYER_HEAD_BLEND_DATA_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["CACHE_PLAYER_HEAD_BLEND_DATA_EVENT"] == 2 then
            return true
        elseif setting["CACHE_PLAYER_HEAD_BLEND_DATA_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[82] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 82 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REMOVE_PED_FROM_PEDGROUP_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REMOVE_PED_FROM_PEDGROUP_EVENT"] == 2 then
            return true
        elseif setting["REMOVE_PED_FROM_PEDGROUP_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[83] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 83 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REPORT_MYSELF_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REPORT_MYSELF_EVENT"] == 2 then
            return true
        elseif setting["REPORT_MYSELF_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[84] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 84 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["REPORT_CASH_SPAWN_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["REPORT_CASH_SPAWN_EVENT"] == 2 then
            return true
        elseif setting["REPORT_CASH_SPAWN_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[85] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 85 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["ACTIVATE_VEHICLE_SPECIAL_ABILITY_EVENT"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["ACTIVATE_VEHICLE_SPECIAL_ABILITY_EVENT"] == 2 then
            return true
        elseif setting["ACTIVATE_VEHICLE_SPECIAL_ABILITY_EVENT"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[86] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 86 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["BLOCK_WEAPON_SELECTION"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["BLOCK_WEAPON_SELECTION"] == 2 then
            return true
        elseif setting["BLOCK_WEAPON_SELECTION"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


NHFunctions[87] = function(Source, Target, EventId)
local SourceScid = player.get_player_scid(Source)
local SourceName = (ValidScid(SourceScid) and player.get_player_name(Source) or "nil") or "nil"
local NHnetevent = neteventmapper.GetEventName(EventId)
local logNHStr = string.format("Net Event: %s (%s) | sent by: %s (%s)]", NHnetevent, EventId, SourceName, SourceScid)
local notiNHStr = string.format("%s\n%s (%s)", NHnetevent, SourceName, SourceScid)
    if EventId == 87 then
        log(logNHStr, "[Net Event log]", "Events.log")
        if setting["NETWORK_CHECK_CATALOG_CRC"] == 1 then
            ui.notify_above_map(notiNHStr, "Net Event Received", 15)
        elseif setting["NETWORK_CHECK_CATALOG_CRC"] == 2 then
            return true
        elseif setting["NETWORK_CHECK_CATALOG_CRC"] == 3 then
            ui.notify_above_map(notiNHStr, "Net Event Blocked", 27)
            return true
        end
    end
end


local function NetHookOn()
    if NetHookId[0] == nil then NetHookId[0] = hook.register_net_event_hook(NHFunctions[0]) end
    if NetHookId[1] == nil then NetHookId[1] = hook.register_net_event_hook(NHFunctions[1]) end
    if NetHookId[2] == nil then NetHookId[2] = hook.register_net_event_hook(NHFunctions[2]) end
    if NetHookId[3] == nil then NetHookId[3] = hook.register_net_event_hook(NHFunctions[3]) end
    if NetHookId[4] == nil then NetHookId[4] = hook.register_net_event_hook(NHFunctions[4]) end
    if NetHookId[5] == nil then NetHookId[5] = hook.register_net_event_hook(NHFunctions[5]) end
    if NetHookId[6] == nil then NetHookId[6] = hook.register_net_event_hook(NHFunctions[6]) end
    if NetHookId[7] == nil then NetHookId[7] = hook.register_net_event_hook(NHFunctions[7]) end
    if NetHookId[8] == nil then NetHookId[8] = hook.register_net_event_hook(NHFunctions[8]) end
    if NetHookId[9] == nil then NetHookId[9] = hook.register_net_event_hook(NHFunctions[9]) end
    if NetHookId[10] == nil then NetHookId[10] = hook.register_net_event_hook(NHFunctions[10]) end
    if NetHookId[11] == nil then NetHookId[11] = hook.register_net_event_hook(NHFunctions[11]) end
    if NetHookId[12] == nil then NetHookId[12] = hook.register_net_event_hook(NHFunctions[12]) end
    if NetHookId[13] == nil then NetHookId[13] = hook.register_net_event_hook(NHFunctions[13]) end
    if NetHookId[14] == nil then NetHookId[14] = hook.register_net_event_hook(NHFunctions[14]) end
    if NetHookId[15] == nil then NetHookId[15] = hook.register_net_event_hook(NHFunctions[15]) end
    if NetHookId[16] == nil then NetHookId[16] = hook.register_net_event_hook(NHFunctions[16]) end
    if NetHookId[17] == nil then NetHookId[17] = hook.register_net_event_hook(NHFunctions[17]) end
    if NetHookId[18] == nil then NetHookId[18] = hook.register_net_event_hook(NHFunctions[18]) end
    if NetHookId[19] == nil then NetHookId[19] = hook.register_net_event_hook(NHFunctions[19]) end
    if NetHookId[20] == nil then NetHookId[20] = hook.register_net_event_hook(NHFunctions[20]) end
    if NetHookId[21] == nil then NetHookId[21] = hook.register_net_event_hook(NHFunctions[21]) end
    if NetHookId[22] == nil then NetHookId[22] = hook.register_net_event_hook(NHFunctions[22]) end
    if NetHookId[23] == nil then NetHookId[23] = hook.register_net_event_hook(NHFunctions[23]) end
    if NetHookId[24] == nil then NetHookId[24] = hook.register_net_event_hook(NHFunctions[24]) end
    if NetHookId[25] == nil then NetHookId[25] = hook.register_net_event_hook(NHFunctions[25]) end
    if NetHookId[26] == nil then NetHookId[26] = hook.register_net_event_hook(NHFunctions[26]) end
    if NetHookId[27] == nil then NetHookId[27] = hook.register_net_event_hook(NHFunctions[27]) end
    if NetHookId[28] == nil then NetHookId[28] = hook.register_net_event_hook(NHFunctions[28]) end
    if NetHookId[29] == nil then NetHookId[29] = hook.register_net_event_hook(NHFunctions[29]) end
    if NetHookId[30] == nil then NetHookId[30] = hook.register_net_event_hook(NHFunctions[30]) end
    if NetHookId[31] == nil then NetHookId[31] = hook.register_net_event_hook(NHFunctions[31]) end
    if NetHookId[32] == nil then NetHookId[32] = hook.register_net_event_hook(NHFunctions[32]) end
    if NetHookId[33] == nil then NetHookId[33] = hook.register_net_event_hook(NHFunctions[33]) end
    if NetHookId[34] == nil then NetHookId[34] = hook.register_net_event_hook(NHFunctions[34]) end
    if NetHookId[35] == nil then NetHookId[35] = hook.register_net_event_hook(NHFunctions[35]) end
    if NetHookId[36] == nil then NetHookId[36] = hook.register_net_event_hook(NHFunctions[36]) end
    if NetHookId[37] == nil then NetHookId[37] = hook.register_net_event_hook(NHFunctions[37]) end
    if NetHookId[38] == nil then NetHookId[38] = hook.register_net_event_hook(NHFunctions[38]) end
    if NetHookId[39] == nil then NetHookId[39] = hook.register_net_event_hook(NHFunctions[39]) end
    if NetHookId[40] == nil then NetHookId[40] = hook.register_net_event_hook(NHFunctions[40]) end
    if NetHookId[41] == nil then NetHookId[41] = hook.register_net_event_hook(NHFunctions[41]) end
    if NetHookId[42] == nil then NetHookId[42] = hook.register_net_event_hook(NHFunctions[42]) end
    if NetHookId[43] == nil then NetHookId[43] = hook.register_net_event_hook(NHFunctions[43]) end
    if NetHookId[44] == nil then NetHookId[44] = hook.register_net_event_hook(NHFunctions[44]) end
    if NetHookId[45] == nil then NetHookId[45] = hook.register_net_event_hook(NHFunctions[45]) end
    if NetHookId[46] == nil then NetHookId[46] = hook.register_net_event_hook(NHFunctions[46]) end
    if NetHookId[47] == nil then NetHookId[47] = hook.register_net_event_hook(NHFunctions[47]) end
    if NetHookId[48] == nil then NetHookId[48] = hook.register_net_event_hook(NHFunctions[48]) end
    if NetHookId[49] == nil then NetHookId[49] = hook.register_net_event_hook(NHFunctions[49]) end
    if NetHookId[50] == nil then NetHookId[50] = hook.register_net_event_hook(NHFunctions[50]) end
    if NetHookId[51] == nil then NetHookId[51] = hook.register_net_event_hook(NHFunctions[51]) end
    if NetHookId[52] == nil then NetHookId[52] = hook.register_net_event_hook(NHFunctions[52]) end
    if NetHookId[53] == nil then NetHookId[53] = hook.register_net_event_hook(NHFunctions[53]) end
    if NetHookId[54] == nil then NetHookId[54] = hook.register_net_event_hook(NHFunctions[54]) end
    if NetHookId[55] == nil then NetHookId[55] = hook.register_net_event_hook(NHFunctions[55]) end
    if NetHookId[56] == nil then NetHookId[56] = hook.register_net_event_hook(NHFunctions[56]) end
    if NetHookId[57] == nil then NetHookId[57] = hook.register_net_event_hook(NHFunctions[57]) end
    if NetHookId[58] == nil then NetHookId[58] = hook.register_net_event_hook(NHFunctions[58]) end
    if NetHookId[59] == nil then NetHookId[59] = hook.register_net_event_hook(NHFunctions[59]) end
    if NetHookId[60] == nil then NetHookId[60] = hook.register_net_event_hook(NHFunctions[60]) end
    if NetHookId[61] == nil then NetHookId[61] = hook.register_net_event_hook(NHFunctions[61]) end
    if NetHookId[62] == nil then NetHookId[62] = hook.register_net_event_hook(NHFunctions[62]) end
    if NetHookId[63] == nil then NetHookId[63] = hook.register_net_event_hook(NHFunctions[63]) end
    if NetHookId[64] == nil then NetHookId[64] = hook.register_net_event_hook(NHFunctions[64]) end
    if NetHookId[65] == nil then NetHookId[65] = hook.register_net_event_hook(NHFunctions[65]) end
    if NetHookId[66] == nil then NetHookId[66] = hook.register_net_event_hook(NHFunctions[66]) end
    if NetHookId[67] == nil then NetHookId[67] = hook.register_net_event_hook(NHFunctions[67]) end
    if NetHookId[68] == nil then NetHookId[68] = hook.register_net_event_hook(NHFunctions[68]) end
    if NetHookId[69] == nil then NetHookId[69] = hook.register_net_event_hook(NHFunctions[69]) end
    if NetHookId[70] == nil then NetHookId[70] = hook.register_net_event_hook(NHFunctions[70]) end
    if NetHookId[71] == nil then NetHookId[71] = hook.register_net_event_hook(NHFunctions[71]) end
    if NetHookId[72] == nil then NetHookId[72] = hook.register_net_event_hook(NHFunctions[72]) end
    if NetHookId[73] == nil then NetHookId[73] = hook.register_net_event_hook(NHFunctions[73]) end
    if NetHookId[74] == nil then NetHookId[74] = hook.register_net_event_hook(NHFunctions[74]) end
    if NetHookId[75] == nil then NetHookId[75] = hook.register_net_event_hook(NHFunctions[75]) end
    if NetHookId[76] == nil then NetHookId[76] = hook.register_net_event_hook(NHFunctions[76]) end
    if NetHookId[77] == nil then NetHookId[77] = hook.register_net_event_hook(NHFunctions[77]) end
    if NetHookId[78] == nil then NetHookId[78] = hook.register_net_event_hook(NHFunctions[78]) end
    if NetHookId[79] == nil then NetHookId[79] = hook.register_net_event_hook(NHFunctions[79]) end
    if NetHookId[80] == nil then NetHookId[80] = hook.register_net_event_hook(NHFunctions[80]) end
    if NetHookId[81] == nil then NetHookId[81] = hook.register_net_event_hook(NHFunctions[81]) end
    if NetHookId[82] == nil then NetHookId[82] = hook.register_net_event_hook(NHFunctions[82]) end
    if NetHookId[83] == nil then NetHookId[83] = hook.register_net_event_hook(NHFunctions[83]) end
    if NetHookId[84] == nil then NetHookId[84] = hook.register_net_event_hook(NHFunctions[84]) end
    if NetHookId[85] == nil then NetHookId[85] = hook.register_net_event_hook(NHFunctions[85]) end
    if NetHookId[86] == nil then NetHookId[86] = hook.register_net_event_hook(NHFunctions[86]) end
    if NetHookId[87] == nil then NetHookId[87] = hook.register_net_event_hook(NHFunctions[87]) end
end
local function NetHookOff()
    for i=1, #NetHookId do
        if NetHookId[i] ~= nil then hook.remove_net_event_hook(NetHookId[i]) end
        NetHookId[i] = nil
    end
end

local ped_pool = {}
local function PedsRefresh()
    ped_pool = ped.get_all_peds()
    return ped_pool
end
local vehicle_pool = {}
local function VehiclesRefresh()
    vehicle_pool = vehicle.get_all_vehicles()
end
local object_pool = {}
local function ObjectsRefresh()
    object_pool = object.get_all_objects()
end
local function PoolRefresh()
    PedsRefresh()
    VehiclesRefresh()
    ObjectsRefresh()
end

menu.add_feature("CAUTION: Game may lag or crash", "action", clear_area, function()end)
menu.add_feature("if you set the ranges too high", "action", clear_area, function()end)
local clear_objects_menu = menu.add_feature("Clear Objects", "parent", clear_area).id
local clear_objects = menu.add_feature("Clear Objects", "action_value_i", clear_objects_menu, function(f)
    ui.notify_above_map("Please Wait...", script_name, 12)
    ClearObjects(f.value_i)
    ui.notify_above_map("Cleared area of Objects", script_name, 18)
    -- add this line so it will get the new setted value
    setting["clear_objects_area"] = f.value_i
    return HANDLER_POP
end)
clear_objects.max_i = 5000000    -- max range of 5000000
clear_objects.min_i = 10         -- min range of 10
clear_objects.mod_i = 10         -- range goes up/down by 10
clear_objects.value_i = setting["clear_objects_area"]      -- default of 250

local clear_objects_toggle = menu.add_feature("Clear Objects", "value_i", clear_objects_menu, function(f)
    if not f.on then return HANDLER_POP end
    ClearObjects(f.value_i)
    system.wait(setting["clear_object_delay"])
    return HANDLER_CONTINUE
end)
clear_objects_toggle.max_i = 5000000    -- max range of 5000000
clear_objects_toggle.min_i = 10         -- min range of 10
clear_objects_toggle.mod_i = 10         -- range goes up/down by 10
clear_objects_toggle.value_i = setting["clear_objects_area_t"]      -- default of 250

local clear_peds_menu = menu.add_feature("Clear Peds", "parent", clear_area).id
local clear_peds = menu.add_feature("Clear Peds", "action_value_i", clear_peds_menu, function(f)
    ui.notify_above_map("Please Wait...", script_name, 12)
    ClearPeds(f.value_i)
    ui.notify_above_map("Cleared Area of Peds", script_name, 18)
    return HANDLER_POP
end)
clear_peds.max_i = 5000000    -- max range of 5000000
clear_peds.min_i = 10         -- min range of 10
clear_peds.mod_i = 10         -- range goes up/down by 10
clear_peds.value_i = setting["clear_ped_area"]      -- default of 250

local clear_peds_toggle = menu.add_feature("Clear Peds", "value_i", clear_peds_menu, function(f)
    if not f.on then return HANDLER_POP end
    ClearPeds(f.value_i)
    system.wait(setting["clear_ped_delay"])
    return HANDLER_CONTINUE
end)
clear_peds_toggle.max_i = 5000000    -- max range of 5000000
clear_peds_toggle.min_i = 10         -- min range of 10
clear_peds_toggle.mod_i = 10         -- range goes up/down by 10
clear_peds_toggle.value_i = setting["clear_ped_area_t"]      -- default of 250

local clear_vehicles_menu = menu.add_feature("Clear Vehicles", "parent", clear_area).id
local clear_vehicles = menu.add_feature("Clear Vehicles", "action_value_i", clear_vehicles_menu, function(f)
    ui.notify_above_map("Please Wait, Game may lag...", script_name, 12)
    ClearVehicles(f.value_i)
    ui.notify_above_map("Cleared Area of Vehicles", script_name, 18)
    return HANDLER_POP
end)
clear_vehicles.max_i = 5000000    -- max range of 5000000
clear_vehicles.min_i = 10         -- min range of 10
clear_vehicles.mod_i = 10         -- range goes up/down by 10
clear_vehicles.value_i = setting["clear_vehicle_area"]      -- default of 250

local notifSent = false
local clear_vehicles_toggle = menu.add_feature("Clear Vehicles", "value_i", clear_vehicles_menu, function(f)
    if not f.on then
        notifSent = false
        return HANDLER_POP
    end
    if not notifSent then
        ui.notify_above_map("Please Wait, Game may lag...", script_name, 12)
        notifSent = true
    end
    ClearVehicles(f.value_i)
    system.wait(setting["clear_vehicles_delay"])
    return HANDLER_CONTINUE
end)
clear_vehicles_toggle.max_i = 5000000    -- max range of 5000000
clear_vehicles_toggle.min_i = 10         -- min range of 10
clear_vehicles_toggle.mod_i = 10         -- range goes up/down by 10
clear_vehicles_toggle.value_i = setting["clear_vehicle_area_t"]      -- default of 250

local clear_pickups_menu = menu.add_feature("Clear Pickups", "parent", clear_area).id
local clear_pickups = menu.add_feature("Clear Pickups", "action_value_i", clear_pickups_menu, function(f)
    ui.notify_above_map("Please Wait...", script_name, 12)
    ClearPickups(f.value_i)
    ui.notify_above_map("Cleared Area of Pickups", script_name, 18)
    return HANDLER_POP
end)
clear_pickups.max_i = 5000000    -- max range of 5000000
clear_pickups.min_i = 10         -- min range of 10
clear_pickups.mod_i = 10         -- range goes up/down by 10
clear_pickups.value_i = setting["clear_pickups_area"]      -- default of 250 

local clear_pickups_toggle = menu.add_feature("Clear Pickups", "value_i", clear_pickups_menu, function(f)
    if not f.on then return HANDLER_POP end
    ClearPickups(f.value_i)
    return HANDLER_CONTINUE
end)
clear_pickups_toggle.max_i = 5000000    -- max range of 5000000
clear_pickups_toggle.min_i = 10         -- min range of 10
clear_pickups_toggle.mod_i = 10         -- range goes up/down by 10
clear_pickups_toggle.value_i = setting["clear_pickups_area_t"]      -- default of 250 

local clear_cops_menu = menu.add_feature("Clear Cops", "parent", clear_area).id
local clear_cops = menu.add_feature("Clear Cops", "action_value_i", clear_cops_menu, function(f)
    ui.notify_above_map("Please Wait...", script_name, 12)
    ClearCops(f.value_i)
    ui.notify_above_map("Cleared Area of Cops", script_name, 18)
    return HANDLER_POP
end)
clear_cops.max_i = 5000000    -- max range of 5000000
clear_cops.min_i = 10         -- min range of 10
clear_cops.mod_i = 10         -- range goes up/down by 10
clear_cops.value_i = setting["clear_cops_area"]      -- default of 250 

local clear_cops_toggle = menu.add_feature("Clear Cops", "value_i", clear_cops_menu, function(f)
if not f.on then return HANDLER_POP end
    ClearCops(f.value_i)
    system.wait(setting["clear_cops_delay"])
    return HANDLER_CONTINUE
end)
clear_cops_toggle.max_i = 5000000    -- max range of 5000000
clear_cops_toggle.min_i = 10         -- min range of 10
clear_cops_toggle.mod_i = 10         -- range goes up/down by 10
clear_cops_toggle.value_i = setting["clear_cops_area_t"]      -- default of 250 

local clear_all_menu = menu.add_feature("Clear All", "parent", clear_area).id
local clear_all = menu.add_feature("Clear All", "action_value_i", clear_all_menu, function(f)
    ui.notify_above_map("Please Wait...", script_name, 12)
    ClearObjects(f.value_i)
    ClearPeds(f.value_i)
    ClearVehicles(f.value_i)
    ClearPickups(f.value_i)
    ui.notify_above_map("Cleared All Entities", script_name, 18)
    return HANDLER_POP
end)
clear_all.max_i = 5000000    -- max range of 5000000
clear_all.min_i = 10         -- min range of 10
clear_all.mod_i = 10         -- range goes up/down by 10
clear_all.value_i = setting["clear_all_area"]      -- default of 250 

local clear_all_toggle = menu.add_feature("Clear All", "value_i", clear_all_menu, function(f)
    if not f.on then return HANDLER_POP end
    ClearObjects(f.value_i)
    ClearPeds(f.value_i)
    ClearVehicles(f.value_i)
    ClearPickups(f.value_i)
    system.wait(setting["clear_all_delay"])
    return HANDLER_CONTINUE
end)
clear_all_toggle.max_i = 5000000    -- max range of 5000000
clear_all_toggle.min_i = 10         -- min range of 10
clear_all_toggle.mod_i = 10         -- range goes up/down by 10
clear_all_toggle.value_i = setting["clear_all_area_t"]      -- default of 250 


local time = utils.time_ms() + 1000
-- new entity log, only logs "new" entities.
-- objects log
local lnoa = menu.add_feature("Log Objects", "action", new_entity_log, function(f)
local objects = object.get_all_objects()
for a=1, #objects do
    local objhash = entity.get_entity_model_hash(objects[a])
    if not knownObjects[objhash] then
        local objmodel = objectmapper.GetModelFromHash(objhash)
        local objlog = ("[Object Net ID: "..objects[a].. "] [Object Hash: " ..objhash.. "] [Object Model: " ..(objmodel or "unknown").. "]")
        log(objlog, "[Log new Objects]", "Objects.log")
        knownObjects[objhash] = true
    end
end
end)
local log_new_objects = menu.add_feature("Log Objects", "toggle", new_entity_log, function(f)
if f.on then
    local objects = object.get_all_objects()
        for a=1, #objects do
            local objhash = entity.get_entity_model_hash(objects[a])
            if not knownObjects[objhash] then
                local objmodel = objectmapper.GetModelFromHash(objhash)
                local objlog = ("[Object Net ID: "..objects[a].. "] [Object Hash: " ..objhash.. "] [Object Model: " ..(objmodel or "unknown").. "]")
                log(objlog, "[Log new Objects]", "Objects.log")
                knownObjects[objhash] = true
            end
        end
        return HANDLER_CONTINUE
    end
return HANDLER_POP
end)
log_new_objects.on = setting["log_new_objects"]
-- vehicles log
local lnva = menu.add_feature("Log Vehicles", "action", new_entity_log, function(f)
local vehicles = vehicle.get_all_vehicles()
for a=1, #vehicles do
    local vehhash = entity.get_entity_model_hash(vehicles[a])
    if not knownVehicles[vehhash] then
        local vehmodel = vehiclemapper.GetModelFromHash(vehhash)
        local vehlog = ("[Vehicle Net ID: "..vehicles[a].. "] [Vehicle Hash: " ..vehhash.. "] [Vehicle Model: " ..(vehmodel or "unknown").."]")
        log(vehlog, "[Log new Vehicles]", "Vehicles.log")
        knownVehicles[vehhash]  = true
    end
end
end)
local log_new_vehicles = menu.add_feature("Log Vehicles", "toggle", new_entity_log, function(f)
if f.on then
    local vehicles = vehicle.get_all_vehicles()
    for a=1, #vehicles do
        local vehhash = entity.get_entity_model_hash(vehicles[a])
        if not knownVehicles[vehhash] then
            local vehmodel = vehiclemapper.GetModelFromHash(vehhash)
            local vehlog = ("[Vehicle Net ID: "..vehicles[a].. "] [Vehicle Hash: " ..vehhash.. "] [Vehicle Model: " ..(vehmodel or "unknown").."]")
            log(vehlog, "[Log new Vehicles]", "Vehicles.log")
            knownVehicles[vehhash]  = true
        end
    end
    return HANDLER_CONTINUE
end
return HANDLER_POP
end)
log_new_vehicles.on = setting["log_new_vehicles"]

local lnpa = menu.add_feature("Log Peds", "action", new_entity_log, function(f)
local peds = ped.get_all_peds()
for a=1, #peds do
    local pedhash = entity.get_entity_model_hash(peds[a])
    if not knownPeds[pedhash] then
        local pedmodel = pedmapper.GetModelFromHash(pedhash)
        local pedname = pedmapper.GetNameFromHash(pedhash)
        local pedlog = ("[Ped Net ID: "..peds[a].. "] [Ped Hash: " ..pedhash.. "] [Ped Model: " ..(pedmodel or "unknown").. "] [Ped Name: "..(pedname or "unknown").."]")  
        log(pedlog, "[Log new Peds]", "Peds.log")
        knownPeds[pedhash] = true
    end
end
end)
local log_new_peds = menu.add_feature("Log Peds", "toggle", new_entity_log, function(f)
if f.on then
    local peds = ped.get_all_peds()
    for a=1, #peds do
        local pedhash = entity.get_entity_model_hash(peds[a])
        if not knownPeds[pedhash] then
            local pedmodel = pedmapper.GetModelFromHash(pedhash)
            local pedname = pedmapper.GetNameFromHash(pedhash)
            local pedlog = ("[Ped Net ID: "..peds[a].. "] [Ped Hash: " ..pedhash.. "] [Ped Model: " ..(pedmodel or "unknown").. "] [Ped Name: "..(pedname or "unknown").."]")  
            log(pedlog, "[Log new Peds]", "Peds.log")
            knownPeds[pedhash] = true
        end
    end
    return HANDLER_CONTINUE
end
return HANDLER_POP
end)
log_new_peds.on = setting["log_new_peds"]

local lnpua = menu.add_feature("Log Pickups", "action", new_entity_log, function(f)
local pickups = object.get_all_pickups()
for a=1, #pickups do
    local puhash = entity.get_entity_model_hash(pickups[a])
    if not knownPickups[puhash] then
        local pumodel = objectmapper.GetModelFromHash(puhash)
        local pulog = ("[Pickup Net ID: "..pickups[a].. "] [Pickups Hash: " ..puhash.. "] [Pickups Model: " ..(pumodel or "unknown").. "]")
        log(pulog, "[Log new Pickups]", "Pickups.log")
        knownPickups[puhash] = true
    end
end
end)
local log_new_pickups = menu.add_feature("Log Pickups", "toggle", new_entity_log, function(f)
if f.on then
    local pickups = object.get_all_pickups()
    for a=1, #pickups do
        local puhash = entity.get_entity_model_hash(pickups[a])
        if not knownPickups[puhash] then
            local pumodel = objectmapper.GetModelFromHash(puhash)
            local pulog = ("[Pickup Net ID: "..pickups[a].. "] [Pickups Hash: " ..puhash.. "] [Pickups Model: " ..(pumodel or "unknown").. "]")
            log(pulog, "[Log new Pickups]", "Pickups.log")
            knownPickups[puhash] = true
        end
    end
    return HANDLER_CONTINUE
end
return HANDLER_POP
end)
log_new_pickups.on = setting["log_new_pickups"]

local lnea = menu.add_feature("Log All Entities", "action", new_entity_log, function(f)
local objects = object.get_all_objects()
for a=1, #objects do
    local objhash = entity.get_entity_model_hash(objects[a])
    if not knownObjects[objhash] then
        local objmodel = objectmapper.GetModelFromHash(objhash)
        local objlog = ("[Object Net ID: "..objects[a].. "] [Object Hash: " ..objhash.. "] [Object Model: " ..(objmodel or "unknown").. "]")
        log(objlog, "[Log new Entities]", "Objects.log")
        knownObjects[objhash] = true
    end
end
local vehicles = vehicle.get_all_vehicles()
for b=1, #vehicles do
    local vehhash = entity.get_entity_model_hash(vehicles[b])
    if not knownVehicles[vehhash] then
        local vehmodel = vehiclemapper.GetModelFromHash(vehhash)
        local vehlog = ("[Vehicle Net ID: "..vehicles[b].. "] [Vehicle Hash: " ..vehhash.. "] [Vehicle Model: " ..(vehmodel or "unknown").."]")
        log(vehlog, "[Log new Entities]", "Vehicles.log")
        knownVehicles[vehhash]  = true
    end
end
local peds = ped.get_all_peds()
for c=1, #peds do
    local pedhash = entity.get_entity_model_hash(peds[c])
    if not knownPeds[pedhash] then
        local pedmodel = pedmapper.GetModelFromHash(pedhash)
        local pedname = pedmapper.GetNameFromHash(pedhash)
        local pedlog = ("[Ped Net ID: "..peds[c].. "] [Ped Hash: " ..pedhash.. "] [Ped Model: " ..(pedmodel or "unknown").. "] [Ped Name: "..(pedname or "unknown").."]")  
        log(pedlog, "[Log new Entities]", "Peds.log")
        knownPeds[pedhash] = true
    end
end
local pickups = object.get_all_pickups()
for d=1, #pickups do
    local puhash = entity.get_entity_model_hash(pickups[d])
    if not knownPickups[puhash] then
        local pumodel = objectmapper.GetModelFromHash(puhash)
        local pulog = ("[Pickup Net ID: "..pickups[d].. "] [Pickups Hash: " ..puhash.. "] [Pickups Model: " ..(pumodel or "unknown").. "]")
        log(pulog, "[Log new Entities]", "Pickups.log")
        knownPickups[puhash] = true
    end
end
end)
local log_new_entities = menu.add_feature("Log All Entities", "toggle", new_entity_log, function(f)
if f.on then
    local objects = object.get_all_objects()
    for a=1, #objects do
        local objhash = entity.get_entity_model_hash(objects[a])
        if not knownObjects[objhash] then
            local objmodel = objectmapper.GetModelFromHash(objhash)
            local objlog = ("[Object Net ID: "..objects[a].. "] [Object Hash: " ..objhash.. "] [Object Model: " ..(objmodel or "unknown").. "]")
            log(objlog, "[Log new Entities]", "Objects.log")
            knownObjects[objhash] = true
        end
    end
    local vehicles = vehicle.get_all_vehicles()
    for b=1, #vehicles do
        local vehhash = entity.get_entity_model_hash(vehicles[b])
        if not knownVehicles[vehhash] then
            local vehmodel = vehiclemapper.GetModelFromHash(vehhash)
            local vehlog = ("[Vehicle Net ID: "..vehicles[b].. "] [Vehicle Hash: " ..vehhash.. "] [Vehicle Model: " ..(vehmodel or "unknown").."]")
            log(vehlog, "[Log new Entities]", "Vehicles.log")
            knownVehicles[vehhash]  = true
        end
    end
    local peds = ped.get_all_peds()
    for c=1, #peds do
        local pedhash = entity.get_entity_model_hash(peds[c])
        if not knownPeds[pedhash] then
            local pedmodel = pedmapper.GetModelFromHash(pedhash)
            local pedname = pedmapper.GetNameFromHash(pedhash)
            local pedlog = ("[Ped Net ID: "..peds[c].. "] [Ped Hash: " ..pedhash.. "] [Ped Model: " ..(pedmodel or "unknown").. "] [Ped Name: "..(pedname or "unknown").."]")  
            log(pedlog, "[Log new Entities]", "Peds.log")
            knownPeds[pedhash] = true
        end
    end
    local pickups = object.get_all_pickups()
    for d=1, #pickups do
        local puhash = entity.get_entity_model_hash(pickups[d])
        if not knownPickups[puhash] then
            local pumodel = objectmapper.GetModelFromHash(puhash)
            local pulog = ("[Pickup Net ID: "..pickups[d].. "] [Pickups Hash: " ..puhash.. "] [Pickups Model: " ..(pumodel or "unknown").. "]")
            log(pulog, "[Log new Entities]", "Pickups.log")
            knownPickups[puhash] = true
        end
    end
    return HANDLER_CONTINUE
    end
return HANDLER_POP
end)
log_new_entities.on = setting["log_new_entities"]

--NET EVENT LOG
local net_event_log = menu.add_feature("(WIP)Net Events", "toggle", log_misc, function(f)
if f.on then
    NetHookOn()
    return HANDLER_POP
else
    NetHookOff()
    return HANDLER_POP
end
return HANDLER_POP
end)
net_event_log.on = setting["net_event_log"]

local player_log = menu.add_feature("log Players", "toggle", log_misc)
player_log.on = setting["player_log"]
local pjoin_el = event.add_event_listener("player_join", function(e)
if player_log.on then
    local pid = e.player
    local pname = player.get_player_name(pid)
    local pscid = player.get_player_scid(pid)
    local pip = player.get_player_ip(pid)
    local pip2 = string.format("%i.%i.%i.%i", (pip >> 24) & 0xff, ((pip >> 16) & 0xff), ((pip >> 8) & 0xff), pip & 0xff)
    local pl_log = ("[Player ID: "..pid.." | Player: "..pname.." | SCID: "..pscid.." | IP: "..pip2.." | IP(dec): "..pip.. "] Joined")
    log(pl_log, "[Player Log]", "Players.log")
end
end)

local modder_player = {}
--because fuck you lua
modder_player[1] = true
-- the thing with repeat until shit is kind of the same, here i just claculated the numbers.
local modder_flagss = {
    1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768,
    65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, 16777216,
    33554432, 67108864, 134217728, 268435456
}
local modder_log = menu.add_feature("Log Modder Flags", "toggle", log_misc, function(f)
if f.on then
  system.wait(2500)
  for i = 0, 31 do
    if player.is_player_valid(i) then
      for y = 1, #modder_flagss do
        if player.is_player_modder(i, modder_flagss[y]) then
          local int = modder_flagss[y]
          local text = player.get_modder_flag_text(int)
          --this thing is there to make sure i log each flag just once.
          --if i didnt logged him once, i create a table for his SCID (the else parte)
          --on the next loop, i check if doesnt have the flag in his table. if not, ill log it and set the flag to true.
          --next loop, it wont log this flag cuz its true
          if modder_player[pl_scid(i)] then
            if not modder_player[pl_scid(i)][int] then
              modder_player[pl_scid(i)][int] = true
              local modlog = (pl_scid(i)..":"..pl_name(i).." is a Modder with Tag: "..text)
              log(modlog, "[Modder log]", "Modders.log")
             end
          else
            modder_player[pl_scid(i)] = {}
          end

        end
      end
    end
  end
  return HANDLER_CONTINUE
end
end)
modder_log.on = setting["modder_log"]

local ped_parents = {}
local allpeds = {}
local veh_parents = {}
local allvehs = {}
local obj_parents = {}
local allobjs = {}

menu.add_feature("This feature may break a lot...", "action", entity_manager, function()end)
local ped_mngr = menu.add_feature("Ped Manager", "parent", entity_manager)
local ped_mngr_all = menu.add_feature("All Peds", "parent", ped_mngr.id).id
local ped_mngr_ind = menu.add_feature("Individiual Peds", "parent", ped_mngr.id).id

local vehicle_mngr = menu.add_feature("Vehicle Manager", "parent", entity_manager)
local veh_mngr_all = menu.add_feature("All Vehicles", "parent", vehicle_mngr.id).id
local veh_mngr_ind = menu.add_feature("Individiual Vehicles", "parent", vehicle_mngr.id).id

local object_mngr = menu.add_feature("Object Manager", "parent", entity_manager)
local obj_mngr_all = menu.add_feature("All Objects", "parent", object_mngr.id).id
local obj_mngr_ind = menu.add_feature("Individiual Objects", "parent", object_mngr.id).id

local function EM_Show()
    ped_mngr.hidden = false
    vehicle_mngr.hidden = false
    object_mngr.hidden = false
end
local function EM_Hide()
    ped_mngr.hidden = true
    vehicle_mngr.hidden = true
    object_mngr.hidden = true
end
EM_Hide()
local ep_refresh = menu.add_feature("Refresh Entity Pools", "toggle", entity_manager, function(f)
    if f.on then
        EM_Show()
        allpeds = ped.get_all_peds()
        allvehs = vehicle.get_all_vehicles()
        allobjs = object.get_all_objects()
        system.wait(250)
        return HANDLER_CONTINUE
    else
        EM_Hide()
        return HANDLER_POP
    end
end)

menu.add_feature("Teleport All to out of bounds", "action", ped_mngr_all, function(f)
    if ep_refresh.on then
        for i = 1, #allpeds do 
        local X = allpeds[i]   
        if not ped.is_ped_a_player(X) then
            local aphash = entity.get_entity_model_hash(X)
            local CheckCount = 0
            while not network.has_control_of_entity(X) do 
                network.request_control_of_entity(X)
                system.wait(250)
                CheckCount = CheckCount + 1
                dbg("[Entity Type: Ped] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..X.."] [Entity Hash: "..aphash.."]", "[TP all Peds away]", "EntityManagerDebug.log")
                if CheckCount > 10 then
                    dbg("[Entity Type: Ped] [Request Control Failed] [Entity ID: "..X.."] [Entity Hash: "..aphash.."]", "[TP all Peds away]", "EntityManagerDebug.log")
                break end --So we don't infinite loop for some reason if we can't get control  
            end
            entity.set_entity_coords_no_offset(X, oob)
            log("[Entity Type: Ped [Entity ID: "..X.."] [Entity Hash: "..aphash.."] - teleported to out of bounds.", "[TP all Peds away]", "EntityManager.log")
        end
        end
    end
end)
menu.add_feature("Teleport all to me", "action", ped_mngr_all, function(f)
    if ep_refresh.on then
        local myPos = MyPos(myPed)
        for i = 1, #allpeds do
        local X = allpeds[i]
        if not ped.is_ped_a_player(X) then
            local aphash = entity.get_entity_model_hash(X)
            local CheckCount = 0
            while not network.has_control_of_entity(allpeds[i]) do
                network.request_control_of_entity(allpeds[i])
                system.wait(250)
                CheckCount = CheckCount + 1
                dbg("[Entity Type: Ped] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..X.."] [Entity Hash: "..aphash.."]", "[TP all Peds to Me]", "EntityManagerDebug.log")
                if CheckCount > 10 then
                    dbg("[Entity Type: Ped] [Request Control Failed] [Entity ID: "..X.."] [Entity Hash: "..aphash.."]", "[TP all Peds to Me]", "EntityManagerDebug.log")
                break end --So we don't infinite loop for some reason if we can't get control  
            end
            entity.set_entity_coords_no_offset(X, myPos)
            log("[Entity Type: Ped] [Entity ID: "..X.."] [Entity Hash: "..aphash.."] - teleported to you.", "[TP all Peds to Me]", "EntityManager.log")
        end
        end
    end
end)
menu.add_feature("Explode Ped", "action", ped_mngr_all, function(f)
    if ep_refresh.on then
        for i=1, #allpeds do
            local aphash = entity.get_entity_model_hash(allpeds[i])
            local pedpos = entity.get_entity_coords(allpeds[i])
            fire.add_explosion(pedpos, 0, false, true, 0.0, allpeds[i])
            log("[Entity Type: Ped] [Entity ID: "..allpeds[i].."] [Entity Hash: "..aphash.."] - exploded.", "[Explode all Peds]", "EntityManager.log")
        end
    end
end)

local pf
menu.add_feature("NOTE: Doesn't work on players.", "action", ped_mngr_ind, function(f)end)
menu.add_feature("Ped list wont be 100% accurate.. cant fix", "action", ped_mngr_ind, function()end)
menu.add_feature("Refresh Ped List", "toggle", ped_mngr_ind, function(f)
    if f.on then
        pf = menu.add_feature("Peds Found: "..#allpeds, "action", ped_mngr_ind, function()
            dbg("[Peds Found: "..#allpeds.."]", "[Refresh Ped List]", "EntityManagerDebug.log")
        end)
        for i = 1, #allpeds do
            local pedhash = entity.get_entity_model_hash(allpeds[i])
            local pedname = pedmapper.GetNameFromHash(pedhash)
            if pedname ~= nil then
                ped_parents[i] = menu.add_feature("Ped Name: "..pedname.." | ID: "..allpeds[i], "parent", ped_mngr_ind, nil)
                menu.add_feature("Ped Name: "..pedname.."", "action", ped_parents[i].id, function()end)
            else
                ped_parents[i] = menu.add_feature("Ped Hash: "..pedhash.." | ID: "..allpeds[i], "parent", ped_mngr_ind, nil)
            end
            menu.add_feature("Ped Hash: "..pedhash.."", "action", ped_parents[i].id, function()end)
            menu.add_feature("Ped ID: "..allpeds[i].."", "action", ped_parents[i].id, function()end)
            menu.add_feature("---------------------------", "action", ped_parents[i].id, function()end)
            menu.add_feature("Teleport to me", "action", ped_parents[i].id, function()
                local myPos = MyPos(myPed)
                local CheckCount = 0
                network.request_control_of_entity(allpeds[i])
                    while not network.has_control_of_entity(allpeds[i]) do
                        system.wait(250)
                        CheckCount = CheckCount + 1
                        dbg("[Entity Type: Ped] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..allpeds[i].."] [Entity Hash: "..pedhash.."]", "[TP Chosen Ped to Me]", "EntityManagerDebug.log")
                        if CheckCount > 10 then
                            dbg("[Entity Type: Ped] [Request Control Failed] [Entity ID: "..allpeds[i].."] [Entity Hash: "..pedhash.."]", "[TP Chosen Ped to Me]", "EntityManagerDebug.log")
                        break end --So we don't infinite loop for some reason if we can't get control  
                    end
                entity.set_entity_coords_no_offset(allpeds[i], myPos)
                log("[Entity Type: Ped] [Entity ID: "..allpeds[i].."] [Entity Hash: "..pedhash.."]  - teleported to you.", "[TP Chosen Ped to Me]", "EntityManager.log")
            end)
            menu.add_feature("Teleport out of bounds", "action", ped_parents[i].id, function(f)
                local CheckCount = 0
                while not network.has_control_of_entity(allpeds[i]) do
                    network.request_control_of_entity(allpeds[i])
                    system.wait(250)
                    CheckCount = CheckCount + 1
                    dbg("[Entity Type: Ped] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..allpeds[i].."] [Entity Hash: "..pedhash.."]", "[TP Chosen Ped Away]", "EntityManagerDebug.log")
                    if CheckCount > 10 then
                        dbg("[Entity Type: Ped] [Request Control Failed] [Entity ID: "..allpeds[i].."] [Entity Hash: "..pedhash.."]", "[TP Chosen Ped Away]", "EntityManagerDebug.log")
                    break end --So we don't infinite loop for some reason if we can't get control  
                end
                entity.set_entity_coords_no_offset(allpeds[i], oob)
                log("[Entity Type: Ped [Entity ID: "..allpeds[i].."] [Entity Hash: "..pedhash.."] - teleported to out of bounds.", "[TP Chosen Ped Away]", "EntityManager.log")
            end)
            menu.add_feature("Explode Ped", "action", ped_parents[i].id, function()
                local pedpos = entity.get_entity_coords(allpeds[i])
                fire.add_explosion(pedpos, 0, false, true, 0.0, allpeds[i])
                log("[Entity Type: Ped] [Entity ID: "..allpeds[i].."] [Entity Hash: "..pedhash.."] - exploded.", "[Explode Chosen Ped]", "EntityManager.log")
            end)
        end
        return HANDLER_POP
    else
        for i=1, #ped_parents do
            if ped_parents[i] ~= nil then
                local children = ped_parents[i].children
                for j=#children, 1, -1 do
                    menu.delete_feature(children[j].id)
                end
                menu.delete_feature(ped_parents[i].id)
            end
        end
        menu.delete_feature(pf.id)
        return HANDLER_POP
    end
end)

menu.add_feature("Teleport All to out of bounds", "action", veh_mngr_all, function(f)
    if ep_refresh.on then
        for i = 1, #allvehs do  
            local CheckCount = 0
            local vehhash = entity.get_entity_model_hash(allvehs[i])
            while not network.has_control_of_entity(allvehs[i]) do 
                network.request_control_of_entity(allvehs[i])
                system.wait(250)   
                CheckCount = CheckCount + 1
                dbg("[Entity Type: Vehicle] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."]", "[TP All Vehicles Away]", "EntityManagerDebug.log")
                if CheckCount > 10 then
                    dbg("[Entity Type: Vehicle] [Request Control Failed] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."]", "[TP All Vehicles Away]", "EntityManagerDebug.log")
                break end --So we don't infinite loop for some reason if we can't get control  
            end
            entity.set_entity_coords_no_offset(allvehs[i], oob)
            log("[Entity Type: Vehicle] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."] - teleported to out of bounds.", "[TP All Vehicles Away]", "EntityManager.log")
        end
    else
        ui.notify_above_map("Refresh Entity Pools not enabled...\nPlease enable Refresh Entity Pools", "Entity Manager Error", 27)
    end
end)
menu.add_feature("Teleport all to me", "action", veh_mngr_all, function(f)
    if ep_refresh.on then
        local myPos = MyPos(myPed)
        for i = 1, #allvehs do
            local CheckCount = 0
            while not network.has_control_of_entity(allvehs[i]) do
                network.request_control_of_entity(allvehs[i])
                system.wait(250)
                CheckCount = CheckCount + 1
                dbg("[Entity Type: Vehicle] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."]", "[TP All Vehicles to ME]", "EntityManagerDebug.log")
                if CheckCount > 10 then
                    dbg("[Entity Type: Vehicle] [Request Control Failed] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."]", "[TP All Vehicles to ME]", "EntityManagerDebug.log")
                break end --So we don't infinite loop for some reason if we can't get control  
            end
            entity.set_entity_coords_no_offset(allvehs[i], myPos)
            log("[Entity Type: Vehicle] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."] - teleported to you.", "[TP All Vehicles to Me]", "EntityManager.log")
        end
    end
end)
menu.add_feature("Explode Vehicle", "action", veh_mngr_all, function(f)
    if ep_refresh.on then
        for i=1, #allvehs do
            local vehpos = entity.get_entity_coords(allvehs[i])
            fire.add_explosion(vehpos, 0, false, true, 0.0, allvehs[i])
            log("[Entity Type: Vehicle] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."] - exploded.", "[Explode All Vehicles]", "EntityManager.log")
        end
    end
end)

local vf
menu.add_feature("Won't work on vehicles too far away", "action", veh_mngr_ind, function()end)
menu.add_feature("Vehicle list wont be 100% accurate.. cant fix", "action", veh_mngr_ind, function()end)
menu.add_feature("Refresh Vehicle List", "toggle", veh_mngr_ind, function(f)
    if f.on then
        vf = menu.add_feature("Vehicles Found: "..#allvehs, "action", veh_mngr_ind, function()
            dbg("[Vehicles Found: "..#allvehs.."]", "[Refresh Vehicle List]", "EntityManagerDebug.log")
        end)
        for i = 1, #allvehs do
            local vehhash = entity.get_entity_model_hash(allvehs[i])
            local vehname = vehiclemapper.GetNameFromHash(vehhash)
            if vehname ~= nil then
                veh_parents[i] = menu.add_feature("Vehicle Name: "..vehname.." | ID: "..allvehs[i], "parent", veh_mngr_ind, nil)
                menu.add_feature("Vehicle Name: "..vehname.."", "action", veh_parents[i].id, function()end)
            else
                veh_parents[i] = menu.add_feature("Vehicle Hash: "..vehhash.." | ID: "..allvehs[i], "parent", veh_mngr_ind, nil)
            end
            menu.add_feature("Vehicle Hash: "..vehhash.."", "action", veh_parents[i].id, function()end)
            menu.add_feature("Vehicle ID: "..allvehs[i].."", "action", veh_parents[i].id, function()end)
            menu.add_feature("---------------------------", "action", veh_parents[i].id, function()end)
            menu.add_feature("Teleport to me", "action", veh_parents[i].id, function()
                local myPos = MyPos(myPed)
                local CheckCount = 0
                while not network.has_control_of_entity(allvehs[i]) do
                    network.request_control_of_entity(allvehs[i])
                    system.wait(250)
                    CheckCount = CheckCount + 1
                    dbg("[Entity Type: Vehicle] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."]", "[TP Chosen Vehicle to Me]", "EntityManagerDebug.log")
                    if CheckCount > 10 then
                        dbg("[Entity Type: Vehicle] [Request Control Failed] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."]", "[TP Chosen Vehicle to Me]", "EntityManagerDebug.log")
                    break end --So we don't infinite loop for some reason if we can't get control  
                end
                entity.set_entity_coords_no_offset(allvehs[i], myPos)
                log("[Entity Type: Vehicle] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."] - teleported to you.", "[TP Chosen Vehicle to Me", "EntityManager.log")
            end)
            menu.add_feature("Teleport out of bounds", "action", veh_parents[i].id, function(f)
                local CheckCount = 0
                while not network.has_control_of_entity(allvehs[i]) do
                    network.request_control_of_entity(allvehs[i])
                    system.wait(250)
                    CheckCount = CheckCount + 1
                    dbg("[Entity Type: Vehicle] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."]", "[TP Chosen Vehicle Away]", "EntityManagerDebug.log")
                    if CheckCount > 10 then
                        dbg("[Entity Type: Vehicle] [Request Control Failed] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."]", "[TP Chosen Vehicle Away]", "EntityManagerDebug.log")
                    break end --So we don't infinite loop for some reason if we can't get control  
                end
                entity.set_entity_coords_no_offset(allvehs[i], oob)
                log("[Entity Type: Vehicle] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."] - teleported to you.", "[TP Chosen Vehicle Away", "EntityManager.log")
            end)
            menu.add_feature("Explode Vehicle", "action", veh_parents[i].id, function()
                local vehpos = entity.get_entity_coords(allvehs[i])
                fire.add_explosion(vehpos, 0, false, true, 0.0, allvehs[i])
                log("[Entity Type: Vehicle] [Entity ID: "..allvehs[i].."] [Entity Hash: "..vehhash.."] - exploded.", "[Explode Chosen Vehicle]", "EntityManager.log")
            end)
        end
        return HANDLER_POP
    else
        for i=1, #veh_parents do
            if veh_parents[i] ~= nil then
                local children = veh_parents[i].children
                for j=#children, 1, -1 do
                    menu.delete_feature(children[j].id)
                end
                menu.delete_feature(veh_parents[i].id)
            end
        end
        menu.delete_feature(vf.id)
        return HANDLER_POP
    end
end)

--[[
local pf
menu.add_feature("NOTE: Doesn't work on players.", "action", ped_mngr_ind, function(f)end)
menu.add_feature("Refresh Ped List", "toggle", ped_mngr_ind, function(f)
    if f.on then
        pf = menu.add_feature("Peds Found: "..#allpeds, "action", ped_mngr_ind, function()end)
        for i = 1, #allpeds do
            local pedhash = entity.get_entity_model_hash(allpeds[i])
            local pedname = pedmapper.GetNameFromHash(pedhash)
            if pedname ~= nil then
                ped_parents[i] = menu.add_feature("Ped Name: "..pedname.." | ID: "..allpeds[i], "parent", ped_mngr_ind, nil)
                menu.add_feature("Ped Name: "..pedname.."", "action", ped_parents[i].id, function()end)
            else
                ped_parents[i] = menu.add_feature("Ped Hash: "..pedhash.." | ID: "..allpeds[i], "parent", ped_mngr_ind, nil)
            end
            menu.add_feature("Ped Hash: "..pedhash.."", "action", ped_parents[i].id, function()end)
            menu.add_feature("Ped ID: "..allpeds[i].."", "action", ped_parents[i].id, function()end)
            menu.add_feature("---------------------------", "action", ped_parents[i].id, function()end)
            menu.add_feature("Teleport to me", "action", ped_parents[i].id, function()
                local myPos = MyPos(myPed)
                network.request_control_of_entity(allpeds[i])
                local CheckCount = 0
                while not network.has_control_of_entity(allpeds[i]) do
                    system.wait(250)
                    CheckCount = CheckCount + 1
                    if CheckCount > 10 then break end --So we don't infinite loop for some reason if we can't get control
                end
                entity.set_entity_coords_no_offset(allpeds[i], myPos)
            end)
            menu.add_feature("Teleport out of bounds", "action", ped_parents[i].id, function(f)
                network.request_control_of_entity(allpeds[i])
                local CheckCount = 0
                while not network.has_control_of_entity(allpeds[i]) do
                    system.wait(250)
                    CheckCount = CheckCount + 1
                    if CheckCount > 10 then break end --So we don't infinite loop for some reason if we can't get control
                end
                entity.set_entity_coords_no_offset(allpeds[i], oob)
            end)
            menu.add_feature("Explode Ped", "action", ped_parents[i].id, function()
                local pedpos = entity.get_entity_coords(allpeds[i])
                fire.add_explosion(pedpos, 0, false, true, 0.0, allpeds[i])
            end)
        end
        return HANDLER_POP
    else
        for i=1, #ped_parents do
            if ped_parents[i] ~= nil then
                local children = ped_parents[i].children
                for j=#children, 1, -1 do
                    menu.delete_feature(children[j].id)
                end
                menu.delete_feature(ped_parents[i].id)
            end
        end
        menu.delete_feature(pf.id)
        return HANDLER_POP
    end
end)]]

-- other player entity shit
local pl_ent_junk = {}
local pl_ent_tp = {}
local pl_ent_atc = {}

local peao = v3() 
peao.x = 0
peao.y = 0
peao.z = 0
local pear = v3() 
pear.x = 0
pear.y = 0
pear.z = 0

pl_ent_junk[1] = menu.add_player_feature("All Peds", "parent", pl_ent_shit, nil).id
pl_ent_tp[1] = menu.add_player_feature("Teleport all Peds to this player", "action", pl_ent_junk[1], function(f, pid)
local pl_ped_pool = ped.get_all_peds()
local pl_coords = player.get_player_coords(pid)
local pname = player.get_player_name(pid)
    for i=1, #pl_ped_pool do
        local phash = entity.get_entity_model_hash(pl_ped_pool[i])
        local CheckCount = 0
        network.request_control_of_entity(pl_ped_pool[i])
        while not network.has_control_of_entity(pl_ped_pool[i]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Ped] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Teleport to: "..pname.."]", "[TP Peds to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Ped] [Request Control Failed] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Teleport to: "..pname.."]", "[TP Peds to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        if pl_ped_pool[i] ~= MyPed() then
            entity.set_entity_coords_no_offset(pl_ped_pool[i], pl_coords)
            log("[Entity Type: Ped] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Teleported to: "..pname.."]", "[TP Peds to Player]", "EntityManager.log")

        end
    end
end)
pl_ent_atc[1] = menu.add_player_feature("Attach all Peds to this player", "action", pl_ent_junk[1], function(f, pid)
local pl_ped_pool = ped.get_all_peds()
local pl_ped = player.get_player_ped(pid)
local pname = player.get_player_name(pid)
    for i=1, #pl_ped_pool do
        local phash = entity.get_entity_model_hash(pl_ped_pool[i])
        local CheckCount = 0
        network.request_control_of_entity(pl_ped_pool[i])
        while not network.has_control_of_entity(pl_ped_pool[i]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Ped] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Attach to: "..pname.."]", "[Attach Peds to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Ped] [Request Control Failed] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Attach to: "..pname.."]", "[Attach Peds to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        if pl_ped_pool[i] ~= MyPed() then
            entity.attach_entity_to_entity(pl_ped_pool[i], pl_ped, 0, peao, pear, false, true, true, 0, true)
            log("[Entity Type: Ped] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Attached to: "..pname.."]", "[Attach Peds to Player]", "EntityManager.log")
        end
    end
end)

pl_ent_junk[2] = menu.add_player_feature("All Vehicles", "parent", pl_ent_shit, nil).id
pl_ent_tp[2] = menu.add_player_feature("Teleport all Vehicles to this player", "action", pl_ent_junk[2], function(f, pid)
local pl_veh_pool = vehicle.get_all_vehicles()
local pl_coords = player.get_player_coords(pid)
local pname = player.get_player_name(pid)
    for i=1, #pl_veh_pool do
        local vhash = entity.get_entity_model_hash(pl_veh_pool[i])
        local CheckCount = 0
        network.request_control_of_entity(pl_veh_pool[i])
        while not network.has_control_of_entity(pl_veh_pool[i]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Vehicle] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_veh_pool[i].."] [Entity Hash: "..vhash.."] [Teleport to: "..pname.."]", "[Teleport Vehicles to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Vehicle] [Request Control Failed] [Entity ID: "..pl_veh_pool[i].."] [Entity Hash: "..vhash.."] [Teleport to: "..pname.."]", "[Teleport Vehicles to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        if pl_veh_pool[i] ~= MyVeh() then
            entity.set_entity_coords_no_offset(pl_veh_pool[i], pl_coords)
            log("[Entity Type: Vehicle] [Entity ID: "..pl_veh_pool[i].."] [Entity Hash: "..vhash.."] [Teleported to: "..pname.."]", "[Teleport Vehicles to Player]", "EntityManager.log")
        end
    end
end)
pl_ent_atc[2] = menu.add_player_feature("Attach all Vehicles to this player", "action", pl_ent_junk[2], function(f, pid)
local pl_veh_pool = vehicle.get_all_vehicles()
local pl_ped = player.get_player_ped(pid)
local pname = player.get_player_name(pid)
    for i=1, #pl_veh_pool do
        local CheckCount = 0
        local vhash = entity.get_entity_model_hash(pl_veh_pool[i])
        network.request_control_of_entity(pl_veh_pool[i])
        while not network.has_control_of_entity(pl_veh_pool[i]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Vehicle] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_veh_pool[i].."] [Entity Hash: "..vhash.."] [Attach to: "..pname.."]", "[Attach Vehicles to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Vehicle] [Request Control Failed] [Entity ID: "..pl_veh_pool[i].."] [Entity Hash: "..vhash.."] [Attach to: "..pname.."]", "[Attach Vehicles to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        if pl_veh_pool[i] ~= MyVeh() then
            entity.attach_entity_to_entity(pl_veh_pool[i], pl_ped, 0, peao, pear, false, true, false, 0, true)
            log("[Entity Type: Vehicle] [Entity ID: "..pl_veh_pool[i].."] [Entity Hash: "..vhash.."] [Attached to: "..pname.."]", "[Attach Vehicles to Player]", "EntityManager.log")
        end
    end
end)

pl_ent_junk[3] = menu.add_player_feature("All Objects", "parent", pl_ent_shit, nil).id
pl_ent_tp[3] = menu.add_player_feature("Teleport all Objects to this player", "action", pl_ent_junk[3], function(f, pid)
local pl_obj_pool = object.get_all_objects()
local pl_coords = player.get_player_coords(pid)
local pname = player.get_player_name(pid)
    for i=1, #pl_obj_pool do
        local ohash = entity.get_entity_model_hash(pl_obj_pool[i])
        local CheckCount = 0
        network.request_control_of_entity(pl_obj_pool[i])
        while not network.has_control_of_entity(pl_obj_pool[i]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Object] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_obj_pool[i].."] [Entity Hash: "..ohash.."] [Teleport to: "..pname.."]", "[Teleport Objects to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Object] [Request Control Failed] [Entity ID: "..pl_obj_pool[i].."] [Entity Hash: "..ohash.."] [Teleport to: "..pname.."]", "[Teleport Objects to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        entity.set_entity_coords_no_offset(pl_obj_pool[i], pl_coords)
        log("[Entity Type: Object] [Entity ID: "..pl_obj_pool[i].."] [Entity Hash: "..ohash.."] [Teleported to: "..pname.."]", "[Teleport Objects to Player]", "EntityManager.log")
    end
end)
pl_ent_atc[3] = menu.add_player_feature("Attach all Objects to this player", "action", pl_ent_junk[3], function(f, pid)
local pl_obj_pool = object.get_all_objects()
local pl_ped = player.get_player_ped(pid)
local pname = player.get_player_name(pid)
    for i=1, #pl_obj_pool do
        local ohash = entity.get_entity_model_hash(pl_obj_pool[i])
        local CheckCount = 0
        network.request_control_of_entity(pl_obj_pool[i])
        while not network.has_control_of_entity(pl_obj_pool[i]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Object] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_obj_pool[i].."] [Entity Hash: "..ohash.."] [Attach to: "..pname.."]", "[Attach Objects to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Object] [Request Control Failed] [Entity ID: "..pl_obj_pool[i].."] [Entity Hash: "..ohash.."] [Attach to: "..pname.."]", "[Attach Objects to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        entity.attach_entity_to_entity(pl_obj_pool[i], pl_ped, 0, peao, pear, false, true, false, 0, true)
        log("[Entity Type: Object] [Entity ID: "..pl_obj_pool[i].."] [Entity Hash: "..ohash.."] [Attached to: "..pname.."]", "[Attach Objects to Player]", "EntityManager.log")
    end
end)

pl_ent_junk[4] = menu.add_player_feature("All Pickups", "parent", pl_ent_shit, nil).id
pl_ent_tp[4] = menu.add_player_feature("Teleport all Pickups to this player", "action", pl_ent_junk[4], function(f, pid)
local pl_pus_pool = object.get_all_pickups()
local pl_coords = player.get_player_coords(pid)
local pname = player.get_player_name(pid)
    for i=1, #pl_pus_pool do
        local puhash = entity.get_entity_model_hash(pl_pus_pool[i])
        local CheckCount = 0
        network.request_control_of_entity(pl_pus_pool[i])
        while not network.has_control_of_entity(pl_pus_pool[i]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Pickup] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_pus_pool[i].."] [Entity Hash: "..puhash.."] [Teleport to: "..pname.."]", "[Teleport Pickups to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Pickup] [Request Control Failed] [Entity ID: "..pl_pus_pool[i].."] [Entity Hash: "..puhash.."] [Teleport to: "..pname.."]", "[Teleport Pickups to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        entity.set_entity_coords_no_offset(pl_pus_pool[i], pl_coords)
        log("[Entity Type: Pickup] [Entity ID: "..pl_pus_pool[i].."] [Entity Hash: "..puhash.."] [Teleported to: "..pname.."]", "[Teleport Pickups to Player]", "EntityManager.log")
    end
end)
pl_ent_atc[4] = menu.add_player_feature("Attach all Pickups to this player", "action", pl_ent_junk[4], function(f, pid)
local pl_pus_pool = object.get_all_pickups()
local pl_ped = player.get_player_ped(pid)
local pname = player.get_player_name(pid)
    for i=1, #pl_pus_pool do
        local puhash = entity.get_entity_model_hash(pl_pus_pool[i])
        local CheckCount = 0
        network.request_control_of_entity(pl_pus_pool[i])
        while not network.has_control_of_entity(pl_pus_pool[i]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Pickup] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_pus_pool[i].."] [Entity Hash: "..puhash.."] [Attach to: "..pname.."]", "[Attach Pickups to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Pickup] [Request Control Failed] [Entity ID: "..pl_pus_pool[i].."] [Entity Hash: "..puhash.."] [Attach to: "..pname.."]", "[Attach Pickups to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        entity.attach_entity_to_entity(pl_pus_pool[i], pl_ped, 0, peao, pear, false, true, false, 0, true)
        log("[Entity Type: Pickup] [Entity ID: "..pl_pus_pool[i].."] [Entity Hash: "..puhash.."] [Attached to: "..pname.."]", "[Attach Pickups to Player]", "EntityManager.log")
    end
end)

pl_ent_junk[5] = menu.add_player_feature("All Entities", "parent", pl_ent_shit, nil).id
pl_ent_tp[5] = menu.add_player_feature("Teleport all Entities to this player", "action", pl_ent_junk[5], function(f, pid)
local pl_coords = player.get_player_coords(pid)
local pname = player.get_player_name(pid)
local pl_ped_pool = ped.get_all_peds()
    for i=1, #pl_ped_pool do
        local phash = entity.get_entity_model_hash(pl_ped_pool[i])
        local CheckCount = 0
        network.request_control_of_entity(pl_ped_pool[i])
        while not network.has_control_of_entity(pl_ped_pool[i]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Ped] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Teleport to: "..pname.."]", "[TP Entities to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Ped] [Request Control Failed] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Teleport to: "..pname.."]", "[TP Entities to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        if pl_ped_pool[i] ~= MyPed() then
            entity.set_entity_coords_no_offset(pl_ped_pool[i], pl_coords)
            log("[Entity Type: Ped] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Teleported to: "..pname.."]", "[TP Entities to Player]", "EntityManager.log")
        end
    end
local pl_veh_pool = vehicle.get_all_vehicles()
    for j=1, #pl_veh_pool do
        local vhash = entity.get_entity_model_hash(pl_veh_pool[j])
        local CheckCount = 0
        network.request_control_of_entity(pl_veh_pool[j])
        while not network.has_control_of_entity(pl_veh_pool[j]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Vehicle] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_veh_pool[j].."] [Entity Hash: "..vhash.."] [Teleport to: "..pname.."]", "[TP Entities to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Vehicle] [Request Control Failed] [Entity ID: "..pl_veh_pool[j].."] [Entity Hash: "..vhash.."] [Teleport to: "..pname.."]", "[TP Entities to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        if pl_veh_pool[j] ~= MyVeh() then
            entity.set_entity_coords_no_offset(pl_veh_pool[j], pl_coords)
            log("[Entity Type: Vehicle] [Entity ID: "..pl_veh_pool[j].."] [Entity Hash: "..vhash.."] [Teleported to: "..pname.."]", "[TP Entities to Player]", "EntityManager.log")
        end
    end
local pl_obj_pool = object.get_all_objects()
    for k=1, #pl_obj_pool do
        local ohash = entity.get_entity_model_hash(pl_obj_pool[k])
        local CheckCount = 0
        network.request_control_of_entity(pl_obj_pool[k])
        while not network.has_control_of_entity(pl_obj_pool[k]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Object] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_obj_pool[k].."] [Entity Hash: "..ohash.."] [Teleport to: "..pname.."]", "[TP Entities to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Object] [Request Control Failed] [Entity ID: "..pl_obj_pool[k].."] [Entity Hash: "..ohash.."] [Teleport to: "..pname.."]", "[TP Entities to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        entity.set_entity_coords_no_offset(pl_obj_pool[k], pl_coords)
        log("[Entity Type: Object] [Entity ID: "..pl_obj_pool[k].."] [Entity Hash: "..ohash.."] [Teleported to: "..pname.."]", "[TP Entities to Player]", "EntityManager.log")
    end
local pl_pus_pool = object.get_all_pickups()
    for l=1, #pl_pus_pool do
        local puhash = entity.get_entity_model_hash(pl_pus_pool[l])
        local CheckCount = 0
        network.request_control_of_entity(pl_pus_pool[l])
        while not network.has_control_of_entity(pl_pus_pool[l]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Pickup] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_pus_pool[l].."] [Entity Hash: "..puhash.."] [Teleport to: "..pname.."]", "[TP Entities to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Pickup] [Request Control Failed] [Entity ID: "..pl_pus_pool[l].."] [Entity Hash: "..puhash.."] [Teleport to: "..pname.."]", "[TP Entities to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        entity.set_entity_coords_no_offset(pl_pus_pool[l], pl_coords)
        log("[Entity Type: Pickup] [Entity ID: "..pl_pus_pool[l].."] [Entity Hash: "..puhash.."] [Teleported to: "..pname.."]", "[TP Entities to Player]", "EntityManager.log")
    end
end)
pl_ent_atc[5] = menu.add_player_feature("Attach all Entities to this player", "action", pl_ent_junk[5], function(f, pid)
local pl_coords = player.get_player_coords(pid)
local pl_ped = player.get_player_ped(pid)
    for i=1, #pl_ped_pool do
        local phash = entity.get_entity_model_hash(pl_ped_pool[i])
        local CheckCount = 0
        network.request_control_of_entity(pl_ped_pool[i])
        while not network.has_control_of_entity(pl_ped_pool[i]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Ped] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Attach to: "..pname.."]", "[Attach Entities to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Ped] [Request Control Failed] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Attach to: "..pname.."]", "[Attach Entities to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        if pl_ped_pool[i] ~= MyPed() then
            entity.attach_entity_to_entity(pl_ped_pool[i], pl_ped, 0, peao, pear, false, true, true, 0, true)
            log("[Entity Type: Ped] [Entity ID: "..pl_ped_pool[i].."] [Entity Hash: "..phash.."] [Attached to: "..pname.."]", "[Attach Entities to Player]", "EntityManager.log")
        end
    end
local pl_veh_pool = vehicle.get_all_vehicles()
    for j=1, #pl_veh_pool do
        local vhash = entity.get_entity_model_hash(pl_veh_pool[j])
        local CheckCount = 0
        network.request_control_of_entity(pl_veh_pool[j])
        while not network.has_control_of_entity(pl_veh_pool[j]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Vehicle] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_veh_pool[j].."] [Entity Hash: "..vhash.."] [Attach to: "..pname.."]", "[Attach Entities to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Vehicle] [Request Control Failed] [Entity ID: "..pl_veh_pool[j].."] [Entity Hash: "..vhash.."] [Attach to: "..pname.."]", "[Attach Entities to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        if pl_veh_pool[j] ~= MyVeh() then
            entity.attach_entity_to_entity(pl_veh_pool[j], pl_ped, 0, peao, pear, false, true, false, 0, true)
            log("[Entity Type: Vehicle] [Entity ID: "..pl_veh_pool[j].."] [Entity Hash: "..vhash.."] [Attached to: "..pname.."]", "[Attach Entities to Player]", "EntityManager.log")
        end
    end
local pl_obj_pool = object.get_all_objects()
    for k=1, #pl_obj_pool do
        local ohash = entity.get_entity_model_hash(pl_obj_pool[i])
        local CheckCount = 0
        network.request_control_of_entity(pl_obj_pool[k])
        while not network.has_control_of_entity(pl_obj_pool[k]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Object] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_obj_pool[k].."] [Entity Hash: "..ohash.."] [Attach to: "..pname.."]", "[Attach Entities to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Object] [Request Control Failed] [Entity ID: "..pl_obj_pool[k].."] [Entity Hash: "..ohash.."] [Attach to: "..pname.."]", "[Attach Entities to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        entity.attach_entity_to_entity(pl_obj_pool[k], pl_ped, 0, peao, pear, false, true, false, 0, true)
        log("[Entity Type: Object] [Entity ID: "..pl_obj_pool[k].."] [Entity Hash: "..ohash.."] [Attached to: "..pname.."]", "[Attach Entities to Player]", "EntityManager.log")
    end
local pl_pus_pool = object.get_all_pickups()
    for l=1, #pl_pus_pool do
        local puhash = entity.get_entity_model_hash(pl_pus_pool[i])
        local CheckCount = 0
        network.request_control_of_entity(pl_pus_pool[l])
        while not network.has_control_of_entity(pl_pus_pool[l]) do
            system.wait(250)
            CheckCount = CheckCount + 1
            dbg("[Entity Type: Pickup] [Request Control Attempt: "..CheckCount.."] [Entity ID: "..pl_pus_pool[l].."] [Entity Hash: "..puhash.."] [Attach to: "..pname.."]", "[Attach Entities to Player]", "EntityManagerDebug.log")
            if CheckCount > 10 then
                dbg("[Entity Type: Pickup] [Request Control Failed] [Entity ID: "..pl_pus_pool[l].."] [Entity Hash: "..puhash.."] [Attach to: "..pname.."]", "[Attach Entities to Player]", "EntityManagerDebug.log") 
            break end --So we don't infinite loop for some reason if we can't get control
        end
        entity.attach_entity_to_entity(pl_pus_pool[l], pl_ped, 0, peao, pear, false, true, false, 0, true)
        log("[Entity Type: Pickup] [Entity ID: "..pl_pus_pool[l].."] [Entity Hash: "..puhash.."] [Attached to: "..pname.."]", "[Attach Entities to Player]", "EntityManager.log")
    end
end)

-- settings submenu shit
local vegg = 0
menu.add_feature("Version: "..setting["version"].."", "action", settings_menu, function()
    vegg = vegg + 1
    if vegg < 7 then
        ui.notify_above_map("Woo you found the secret easter egg although this does nothing\nYou've now clicked this "..vegg.." times", script_name, 23)
        local dbg_egg = "WOO, you found this easter egg. Though its pointless, so not sure why you clicked this... You have also clicked this "..vegg.." times this session"
        dbg(dbg_egg, "[Easter Egg]", "Debug.log")
    elseif vegg == 7 then
        ui.notify_above_map("Congratulations, you're now a developer.\nNot Actually", script_name, 50)
        local dbg_egg = "You clicked this option 7 times. Congratulations, you're now a developer.. well not actually."
        dbg(dbg_egg, "[Easter Egg]", "Debug.log")
    elseif vegg > 7 then
        ui.notify_above_map("Mate, you've already unlocked developer settings Stop pressing it.\nYou've now clicked this "..vegg.." times", script_name, 23)
        local dbg_egg = "You've already unlocked developer settings. Why're you still clicking this button?! By the way, You have now clicked this button "..vegg.." times this session"
        dbg(dbg_egg, "[Easter Egg]", "Debug.log")        
    end
end)
-- delays used within the script
local delay_settings = menu.add_feature("Delays", "parent", settings_menu, nil).id
menu.add_feature("NOTE: Delay values are in ms", "action", delay_settings, function()
    ui.notify_above_map("ms stands for milliseconds, dumby", script_name, 12)
    local dbg_egg = "mhmm, ms really does stand for milliseconds"
    dbg(dbg_egg, "[Easter Egg]", "Debug.log")
end)
menu.add_feature("Click the option to confirm the value", "action", delay_settings, function()
    ui.notify_above_map("NOT this option... the options below", script_name, 52)
    local dbg_egg = "bruh, why you clicking on useless options?"
    dbg(dbg_egg, "[Easter Egg]", "Debug.log")
end)

local cl_obj_del = menu.add_feature("Clear Object Delay", "action_value_i", delay_settings, function(f)
    setting["clear_object_delay"] = f.value_i
    ui.notify_above_map("Clear Object Delay set to: "..f.value_i.."", script_name, 18)
    local dbg_cl_obj_del = ("Option: Clear Object Delay set to "..f.value_i.."")
    dbg(dbg_cl_obj_del, "[Settings Change]", "Debug.log")
end)
cl_obj_del.max_i = 5000    -- max delay of 5000
cl_obj_del.min_i = 0         -- min delay of 0
cl_obj_del.mod_i = 10         -- delay goes up/down by 10
cl_obj_del.value_i = setting["clear_object_delay"]

local cl_ped_del = menu.add_feature("Clear Ped Delay", "action_value_i", delay_settings, function(f)
    setting["clear_ped_delay"] = f.value_i
    ui.notify_above_map("Clear Ped Delay set to: "..f.value_i.."", script_name, 18)
    local dbg_cl_ped_del = ("Option: Clear Ped Delay set to "..f.value_i.."")
    dbg(dbg_cl_ped_del, "[Settings Change]", "Debug.log")
end)
cl_ped_del.max_i = 5000    -- max delay of 5000
cl_ped_del.min_i = 0         -- min delay of 0
cl_ped_del.mod_i = 10         -- delay goes up/down by 10
cl_ped_del.value_i = setting["clear_ped_delay"]

local cl_veh_del = menu.add_feature("Clear Vehicle Delay", "action_value_i", delay_settings, function(f)
    setting["clear_vehicles_delay"] = f.value_i
    ui.notify_above_map("Clear Vehicle Delay set to: "..f.value_i.."", script_name, 18)
    local dbg_cl_veh_del = ("Option: Clear Vehicle Delay set to "..f.value_i.."")
    dbg(dbg_cl_veh_del, "[Settings Change]", "Debug.log")
end)
cl_veh_del.max_i = 5000    -- max delay of 5000
cl_veh_del.min_i = 0         -- min delay of 0
cl_veh_del.mod_i = 10         -- delay goes up/down by 10
cl_veh_del.value_i = setting["clear_vehicles_delay"]

local cl_cop_del = menu.add_feature("Clear Cops Delay", "action_value_i", delay_settings, function(f)
    setting["clear_cops_delay"] = f.value_i
    ui.notify_above_map("Clear Cops Delay set to: "..f.value_i.."", script_name, 18)
    local dbg_cl_cop_del = ("Option: Clear Cops Delay set to "..f.value_i.."")
    dbg(dbg_cl_cop_del, "[Settings Change]", "Debug.log")
end)
cl_cop_del.max_i = 5000    -- max delay of 5000
cl_cop_del.min_i = 0         -- min delay of 0
cl_cop_del.mod_i = 10         -- delay goes up/down by 10
cl_cop_del.value_i = setting["clear_cops_delay"]

local cl_all_del = menu.add_feature("Clear All Delay", "action_value_i", delay_settings, function(f)
    setting["clear_all_delay"] = f.value_i
    ui.notify_above_map("Clear All Delay set to: "..f.value_i.."", script_name, 18)
    local dbg_cl_all_del = ("Option: Clear All Delay set to "..f.value_i.."")
    dbg(dbg_cl_all_del, "[Settings Change]", "Debug.log")
end)
cl_all_del.max_i = 5000    -- max delay of 5000
cl_all_del.min_i = 0         -- min delay of 0
cl_all_del.mod_i = 10         -- delay goes up/down by 10
cl_all_del.value_i = setting["clear_all_delay"]

local log_del = menu.add_feature("log Delay", "action_value_i", delay_settings, function(f)
    setting["log_delay"] = f.value_i
    ui.notify_above_map("log Delay set to: "..f.value_i.."", script_name, 18)
    local dbg_log_del = ("Option: log Delay set to "..f.value_i.."")
    dbg(dbg_log_del, "[Settings Change]", "Debug.log")
end)
log_del.max_i = 5000    -- max delay of 5000
log_del.min_i = 0         -- min delay of 0
log_del.mod_i = 10         -- delay goes up/down by 10
log_del.value_i = setting["log_delay"]
-- adv settings for clear area request control shit
local asrc = menu.add_feature("Adv Clear Area Settings", "parent", settings_menu, nil).id
local carcl = menu.add_feature("Req Ctrl Timeout Limit", "parent", asrc, nil).id
menu.add_feature("Clear Area function will attempt to get control of", "action", carcl, function()end)
menu.add_feature("Entities, then give up after this many attempts.", "action", carcl, function()end)

local corcl = menu.add_feature("Clear Object Req Ctrl limit", "action_value_i", carcl, function(f)
    setting["clr_obj_req_ctrl_limit"] = f.value_i
    local dbg_corcl = ("Option: Clear Object Req Ctrl limit set to "..f.value_i.."")
    dbg(dbg_corcl, "[Settings Change]", "Debug.log")
end)
corcl.max_i = 25    
corcl.min_i = 1         
corcl.mod_i = 1         
corcl.value_i = setting["clr_obj_req_ctrl_limit"]

local cprcl = menu.add_feature("Clear Ped Req Ctrl limit", "action_value_i", carcl, function(f)
    setting["clr_ped_req_ctrl_limit"] = f.value_i
    local dbg_cprcl = ("Option: Clear Ped Req Ctrl limit set to "..f.value_i.."")
    dbg(dbg_cprcl, "[Settings Change]", "Debug.log")
end)
cprcl.max_i = 25    
cprcl.min_i = 1         
cprcl.mod_i = 1         
cprcl.value_i = setting["clr_ped_req_ctrl_limit"]

local cvrcl = menu.add_feature("Clear Vehicle Req Ctrl limit", "action_value_i", carcl, function(f)
    setting["clr_veh_req_ctrl_limit"] = f.value_i
    local dbg_cvrcl = ("Option: Clear Vehicle Req Ctrl limit set to "..f.value_i.."")
    dbg(dbg_cvrcl, "[Settings Change]", "Debug.log")
end)
cvrcl.max_i = 25    
cvrcl.min_i = 1         
cvrcl.mod_i = 1         
cvrcl.value_i = setting["clr_veh_req_ctrl_limit"]

local cpurcl = menu.add_feature("Clear Pickup Req Ctrl limit", "action_value_i", carcl, function(f)
    setting["clr_pus_req_ctrl_limit"] = f.value_i
    local dbg_cpurcl = ("Option: Clear Pickup Req Ctrl limit set to "..f.value_i.."")
    dbg(dbg_cpurcl, "[Settings Change]", "Debug.log")
end)
cpurcl.max_i = 25    
cpurcl.min_i = 1         
cpurcl.mod_i = 1         
cpurcl.value_i = setting["clr_pus_req_ctrl_limit"]

local carcd = menu.add_feature("Req Ctrl Delay", "parent", asrc, nil).id
menu.add_feature("This is the Delay between Request Control Attempts", "action", carcd, function()end)

local corcd = menu.add_feature("Clear Object Req Ctrl delay", "action_value_i", carcd, function(f)
    setting["clr_obj_req_ctrl_del"] = f.value_i
    local dbg_corcd = ("Option: Clear Object Req Ctrl delay set to "..f.value_i.."")
    dbg(dbg_corcd, "[Settings Change]", "Debug.log")
end)
corcd.max_i = 250    
corcd.min_i = 10         
corcd.mod_i = 10         
corcd.value_i = setting["clr_obj_req_ctrl_del"]

local cvrcd = menu.add_feature("Clear Vehicle Req Ctrl delay", "action_value_i", carcd, function(f)
    setting["clr_veh_req_ctrl_del"] = f.value_i
    local dbg_cvrcd = ("Option: Clear Vehicle Req Ctrl delay set to "..f.value_i.."")
    dbg(dbg_cvrcd, "[Settings Change]", "Debug.log")
end)
cvrcd.max_i = 250    
cvrcd.min_i = 10         
cvrcd.mod_i = 10         
cvrcd.value_i = setting["clr_veh_req_ctrl_del"]

local cprcd = menu.add_feature("Clear Ped Req Ctrl delay", "action_value_i", carcd, function(f)
    setting["clr_ped_req_ctrl_del"] = f.value_i
    local dbg_cprcd = ("Option: Clear Ped Req Ctrl delay set to "..f.value_i.."")
    dbg(dbg_cprcd, "[Settings Change]", "Debug.log")
end)
cprcd.max_i = 250    
cprcd.min_i = 10         
cprcd.mod_i = 10         
cprcd.value_i = setting["clr_ped_req_ctrl_del"]

local cpurcd = menu.add_feature("Clear Pickup Req Ctrl delay", "action_value_i", carcd, function(f)
    setting["clr_pus_req_ctrl_del"] = f.value_i
    local dbg_cpurcd = ("Option: Clear Pickup Req Ctrl delay set to "..f.value_i.."")
    dbg(dbg_cpurcd, "[Settings Change]", "Debug.log")
end)
cpurcd.max_i = 250    
cpurcd.min_i = 10         
cpurcd.mod_i = 10         
cpurcd.value_i = setting["clr_pus_req_ctrl_del"]

-- what logs will be enabled on startup?
local elos = menu.add_feature("Startup logs", "parent", settings_menu, nil).id
-- these are for "new entity logs"
menu.add_feature("Settings for New Entity logs", "action", elos, function()
    ui.notify_above_map("Man, you just really love pushing useless buttons", script_name, 49)
    local dbg_egg = "Look at me, I love pushing all useless buttons !!"
    dbg(dbg_egg, "[Easter Egg]", "Debug.log")
end)
local lnos = menu.add_feature("log New Objects Startup", "toggle", elos, function(f)
if f.on then
    setting["log_new_objects"] = true
    local dbg_lnos = ("Option: log New Objects Startup set to: True")
    dbg(dbg_lnos, "[Settings Change]", "Debug.log")
else
    setting["log_new_objects"] = false
    local dbg_lnos = ("Option: log New Objects Startup set to: False")
    dbg(dbg_lnos, "[Settings Change]", "Debug.log")
end
end)
lnos.on = setting["log_new_objects"]
local lnvs = menu.add_feature("log New Vehicles Startup", "toggle", elos, function(f)
if f.on then
    setting["log_new_vehicles"] = true
    local dbg_lnvs = ("Option: log New Vehicles Startup set to: True")
    dbg(dbg_lnvs, "[Settings Change]", "Debug.log")
else
    setting["log_new_vehicles"] = false
    local dbg_lnvs = ("Option: log New Vehicles Startup set to: False")
    dbg(dbg_lnvs, "[Settings Change]", "Debug.log")
end
end)
lnvs.on = setting["log_new_vehicles"]
local lnps = menu.add_feature("log New Peds Startup", "toggle", elos, function(f)
if f.on then
    setting["log_new_peds"] = true
    local dbg_lnps = ("Option: log New Peds Startup set to: True")
    dbg(dbg_lnps, "[Settings Change]", "Debug.log")
else
    setting["log_new_peds"] = false
    local dbg_lnps = ("Option: log New Peds Startup set to: False")
    dbg(dbg_lnps, "[Settings Change]", "Debug.log")
end
end)
lnps.on = setting["log_new_peds"]
local lnpus = menu.add_feature("log New Pickups Startup", "toggle", elos, function(f)
if f.on then
    setting["log_new_pickups"] = true
    local dbg_lnpus = ("Option: log New Pickups Startup set to: True")
    dbg(dbg_lnpus, "[Settings Change]", "Debug.log")
else
    setting["log_new_pickups"] = false
    local dbg_lnpus = ("Option: log New Pickups Startup set to: False")
    dbg(dbg_lnpus, "[Settings Change]", "Debug.log")
end
end)
lnpus.on = setting["log_new_pickups"]
local lnes = menu.add_feature("log New Entities Startup", "toggle", elos, function(f)
if f.on then
    setting["log_new_entities"] = true
    local dbg_lnes = ("Option: log New Entities Startup set to: True")
    dbg(dbg_lnes, "[Settings Change]", "Debug.log")
else
    setting["log_new_entities"] = false
    local dbg_lnes = ("Option: log New Entities Startup set to: False")
    dbg(dbg_lnes, "[Settings Change]", "Debug.log")
end
end)
lnes.on = setting["log_new_entities"]
-- these are for "misc logs"
menu.add_feature("Settings for Misc logs", "action", elos, function()
    ui.notify_above_map("STOP pushing random buttons..", script_name, 23)
    local dbg_egg = "Honestly, I've now run out of creative things to say... Thanks."
    dbg(dbg_egg, "[Easter Egg]", "Debug.log")
end)
local nels = menu.add_feature("Net Event log Startup", "toggle", elos, function(f)
if f.on then
    setting["net_event_log"] = true
    local dbg_nels = ("Option: Net Event log on Startup set to: True")
    dbg(dbg_nels, "[Settings Change]", "Debug.log")
else
    setting["net_event_log"] = false
    local dbg_nels = ("Option: Net Event log on Startup set to: False")
    dbg(dbg_nels, "[Settings Change]", "Debug.log")
end
end)
nels.on = setting["net_event_log"]

local pls = menu.add_feature("Player log Startup", "toggle", elos, function(f)
if f.on then
    setting["player_log"] = true
    local dbg_pls = ("Option: Player log on Startup set to: True")
    dbg(dbg_pls, "[Settings Change]", "Debug.log")
else
    setting["player_log"] = false
    local dbg_pls = ("Option: Player log on Startup set to: False")
    dbg(dbg_pls, "[Settings Change]", "Debug.log")
end
end)
pls.on = setting["player_log"]

local mls = menu.add_feature("Modder log Startup", "toggle", elos, function(f)
if f.on then
    setting["modder_log"] = true
    local dbg_mls = ("Option: Modder log on Startup set to: True")
    dbg(dbg_mls, "[Settings Change]", "Debug.log")
else
    setting["modder_log"] = false
    local dbg_mls = ("Option: Modder log on Startup set to: False")
    dbg(dbg_mls, "[Settings Change]", "Debug.log")
end
end)
mls.on = setting["modder_log"]

local neh_settings = menu.add_feature("Net Event log settings", "parent", settings_menu, nil).id
menu.add_feature("0: none 1: notify 2: block 3: block & notify", "action",neh_settings, function()end)
menu.add_feature("Be careful what you set to block/notify/both", "action",neh_settings, function()end)

local nehevent = {}

nehevent[0] = menu.add_feature("OBJECT_ID_FREED_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["OBJECT_ID_FREED_EVENT"] = f.value_i
end)
nehevent[0].max_i = 3
nehevent[0].min_i = 0
nehevent[0].mod_i = 1
nehevent[0].value_i = setting["OBJECT_ID_FREED_EVENT"]
nehevent[1] = menu.add_feature("OBJECT_ID_REQUEST_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["OBJECT_ID_REQUEST_EVENT"] = f.value_i
end)
nehevent[1].max_i = 3
nehevent[1].min_i = 0
nehevent[1].mod_i = 1
nehevent[1].value_i = setting["OBJECT_ID_REQUEST_EVENT"]
nehevent[2] = menu.add_feature("ARRAY_DATA_VERIFY_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["ARRAY_DATA_VERIFY_EVENT"] = f.value_i
end)
nehevent[2].max_i = 3
nehevent[2].min_i = 0
nehevent[2].mod_i = 1
nehevent[2].value_i = setting["ARRAY_DATA_VERIFY_EVENT"]
nehevent[3] = menu.add_feature("SCRIPT_ARRAY_DATA_VERIFY_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["SCRIPT_ARRAY_DATA_VERIFY_EVENT"] = f.value_i
end)
nehevent[3].max_i = 3
nehevent[3].min_i = 0
nehevent[3].mod_i = 1
nehevent[3].value_i = setting["SCRIPT_ARRAY_DATA_VERIFY_EVENT"]
nehevent[4] = menu.add_feature("REQUEST_CONTROL_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REQUEST_CONTROL_EVENT"] = f.value_i
end)
nehevent[4].max_i = 3
nehevent[4].min_i = 0
nehevent[4].mod_i = 1
nehevent[4].value_i = setting["REQUEST_CONTROL_EVENT"]
nehevent[5] = menu.add_feature("GIVE_CONTROL_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["GIVE_CONTROL_EVENT"] = f.value_i
end)
nehevent[5].max_i = 3
nehevent[5].min_i = 0
nehevent[5].mod_i = 1
nehevent[5].value_i = setting["GIVE_CONTROL_EVENT"]
nehevent[6] = menu.add_feature("WEAPON_DAMAGE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["WEAPON_DAMAGE_EVENT"] = f.value_i
end)
nehevent[6].max_i = 3
nehevent[6].min_i = 0
nehevent[6].mod_i = 1
nehevent[6].value_i = setting["WEAPON_DAMAGE_EVENT"]
nehevent[7] = menu.add_feature("REQUEST_PICKUP_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REQUEST_PICKUP_EVENT"] = f.value_i
end)
nehevent[7].max_i = 3
nehevent[7].min_i = 0
nehevent[7].mod_i = 1
nehevent[7].value_i = setting["REQUEST_PICKUP_EVENT"]
nehevent[8] = menu.add_feature("REQUEST_MAP_PICKUP_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REQUEST_MAP_PICKUP_EVENT"] = f.value_i
end)
nehevent[8].max_i = 3
nehevent[8].min_i = 0
nehevent[8].mod_i = 1
nehevent[8].value_i = setting["REQUEST_MAP_PICKUP_EVENT"]
nehevent[9] = menu.add_feature("GAME_CLOCK_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["GAME_CLOCK_EVENT"] = f.value_i
end)
nehevent[9].max_i = 3
nehevent[9].min_i = 0
nehevent[9].mod_i = 1
nehevent[9].value_i = setting["GAME_CLOCK_EVENT"]
nehevent[10] = menu.add_feature("GAME_WEATHER_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["GAME_WEATHER_EVENT"] = f.value_i
end)
nehevent[10].max_i = 3
nehevent[10].min_i = 0
nehevent[10].mod_i = 1
nehevent[10].value_i = setting["GAME_WEATHER_EVENT"]
nehevent[11] = menu.add_feature("RESPAWN_PLAYER_PED_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["RESPAWN_PLAYER_PED_EVENT"] = f.value_i
end)
nehevent[11].max_i = 3
nehevent[11].min_i = 0
nehevent[11].mod_i = 1
nehevent[11].value_i = setting["RESPAWN_PLAYER_PED_EVENT"]
nehevent[12] = menu.add_feature("GIVE_WEAPON_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["GIVE_WEAPON_EVENT"] = f.value_i
end)
nehevent[12].max_i = 3
nehevent[12].min_i = 0
nehevent[12].mod_i = 1
nehevent[12].value_i = setting["GIVE_WEAPON_EVENT"]
nehevent[13] = menu.add_feature("REMOVE_WEAPON_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REMOVE_WEAPON_EVENT"] = f.value_i
end)
nehevent[13].max_i = 3
nehevent[13].min_i = 0
nehevent[13].mod_i = 1
nehevent[13].value_i = setting["REMOVE_WEAPON_EVENT"]
nehevent[14] = menu.add_feature("REMOVE_ALL_WEAPONS_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REMOVE_ALL_WEAPONS_EVENT"] = f.value_i
end)
nehevent[14].max_i = 3
nehevent[14].min_i = 0
nehevent[14].mod_i = 1
nehevent[14].value_i = setting["REMOVE_ALL_WEAPONS_EVENT"]
nehevent[15] = menu.add_feature("VEHICLE_COMPONENT_CONTROL_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["VEHICLE_COMPONENT_CONTROL_EVENT"] = f.value_i
end)
nehevent[15].max_i = 3
nehevent[15].min_i = 0
nehevent[15].mod_i = 1
nehevent[15].value_i = setting["VEHICLE_COMPONENT_CONTROL_EVENT"]
nehevent[16] = menu.add_feature("FIRE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["FIRE_EVENT"] = f.value_i
end)
nehevent[16].max_i = 3
nehevent[16].min_i = 0
nehevent[16].mod_i = 1
nehevent[16].value_i = setting["FIRE_EVENT"]
nehevent[17] = menu.add_feature("EXPLOSION_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["EXPLOSION_EVENT"] = f.value_i
end)
nehevent[17].max_i = 3
nehevent[17].min_i = 0
nehevent[17].mod_i = 1
nehevent[17].value_i = setting["EXPLOSION_EVENT"]
nehevent[18] = menu.add_feature("START_PROJECTILE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["START_PROJECTILE_EVENT"] = f.value_i
end)
nehevent[18].max_i = 3
nehevent[18].min_i = 0
nehevent[18].mod_i = 1
nehevent[18].value_i = setting["START_PROJECTILE_EVENT"]
nehevent[19] = menu.add_feature("UPDATE_PROJECTILE_TARGET_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["UPDATE_PROJECTILE_TARGET_EVENT"] = f.value_i
end)
nehevent[19].max_i = 3
nehevent[19].min_i = 0
nehevent[19].mod_i = 1
nehevent[19].value_i = setting["UPDATE_PROJECTILE_TARGET_EVENT"]
nehevent[20] = menu.add_feature("REMOVE_PROJECTILE_ENTITY_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REMOVE_PROJECTILE_ENTITY_EVENT"] = f.value_i
end)
nehevent[20].max_i = 3
nehevent[20].min_i = 0
nehevent[20].mod_i = 1
nehevent[20].value_i = setting["REMOVE_PROJECTILE_ENTITY_EVENT"]
nehevent[21] = menu.add_feature("BREAK_PROJECTILE_TARGET_LOCK_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["BREAK_PROJECTILE_TARGET_LOCK_EVENT"] = f.value_i
end)
nehevent[21].max_i = 3
nehevent[21].min_i = 0
nehevent[21].mod_i = 1
nehevent[21].value_i = setting["BREAK_PROJECTILE_TARGET_LOCK_EVENT"]
nehevent[22] = menu.add_feature("ALTER_WANTED_LEVEL_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["ALTER_WANTED_LEVEL_EVENT"] = f.value_i
end)
nehevent[22].max_i = 3
nehevent[22].min_i = 0
nehevent[22].mod_i = 1
nehevent[22].value_i = setting["ALTER_WANTED_LEVEL_EVENT"]
nehevent[23] = menu.add_feature("CHANGE_RADIO_STATION_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["CHANGE_RADIO_STATION_EVENT"] = f.value_i
end)
nehevent[23].max_i = 3
nehevent[23].min_i = 0
nehevent[23].mod_i = 1
nehevent[23].value_i = setting["CHANGE_RADIO_STATION_EVENT"]
nehevent[24] = menu.add_feature("RAGDOLL_REQUEST_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["RAGDOLL_REQUEST_EVENT"] = f.value_i
end)
nehevent[24].max_i = 3
nehevent[24].min_i = 0
nehevent[24].mod_i = 1
nehevent[24].value_i = setting["RAGDOLL_REQUEST_EVENT"]
nehevent[25] = menu.add_feature("PLAYER_TAUNT_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["PLAYER_TAUNT_EVENT"] = f.value_i
end)
nehevent[25].max_i = 3
nehevent[25].min_i = 0
nehevent[25].mod_i = 1
nehevent[25].value_i = setting["PLAYER_TAUNT_EVENT"]
nehevent[26] = menu.add_feature("PLAYER_CARD_STAT_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["PLAYER_CARD_STAT_EVENT"] = f.value_i
end)
nehevent[26].max_i = 3
nehevent[26].min_i = 0
nehevent[26].mod_i = 1
nehevent[26].value_i = setting["PLAYER_CARD_STAT_EVENT"]
nehevent[27] = menu.add_feature("DOOR_BREAK_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["DOOR_BREAK_EVENT"] = f.value_i
end)
nehevent[27].max_i = 3
nehevent[27].min_i = 0
nehevent[27].mod_i = 1
nehevent[27].value_i = setting["DOOR_BREAK_EVENT"]
nehevent[28] = menu.add_feature("SCRIPTED_GAME_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["SCRIPTED_GAME_EVENT"] = f.value_i
end)
nehevent[28].max_i = 3
nehevent[28].min_i = 0
nehevent[28].mod_i = 1
nehevent[28].value_i = setting["SCRIPTED_GAME_EVENT"]
nehevent[29] = menu.add_feature("REMOTE_SCRIPT_INFO_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REMOTE_SCRIPT_INFO_EVENT"] = f.value_i
end)
nehevent[29].max_i = 3
nehevent[29].min_i = 0
nehevent[29].mod_i = 1
nehevent[29].value_i = setting["REMOTE_SCRIPT_INFO_EVENT"]
nehevent[30] = menu.add_feature("REMOTE_SCRIPT_LEAVE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REMOTE_SCRIPT_LEAVE_EVENT"] = f.value_i
end)
nehevent[30].max_i = 3
nehevent[30].min_i = 0
nehevent[30].mod_i = 1
nehevent[30].value_i = setting["REMOTE_SCRIPT_LEAVE_EVENT"]
nehevent[31] = menu.add_feature("MARK_AS_NO_LONGER_NEEDED_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["MARK_AS_NO_LONGER_NEEDED_EVENT"] = f.value_i
end)
nehevent[31].max_i = 3
nehevent[31].min_i = 0
nehevent[31].mod_i = 1
nehevent[31].value_i = setting["MARK_AS_NO_LONGER_NEEDED_EVENT"]
nehevent[32] = menu.add_feature("CONVERT_TO_SCRIPT_ENTITY_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["CONVERT_TO_SCRIPT_ENTITY_EVENT"] = f.value_i
end)
nehevent[32].max_i = 3
nehevent[32].min_i = 0
nehevent[32].mod_i = 1
nehevent[32].value_i = setting["CONVERT_TO_SCRIPT_ENTITY_EVENT"]
nehevent[33] = menu.add_feature("SCRIPT_WORLD_STATE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["SCRIPT_WORLD_STATE_EVENT"] = f.value_i
end)
nehevent[33].max_i = 3
nehevent[33].min_i = 0
nehevent[33].mod_i = 1
nehevent[33].value_i = setting["SCRIPT_WORLD_STATE_EVENT"]
nehevent[34] = menu.add_feature("CLEAR_AREA_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["CLEAR_AREA_EVENT"] = f.value_i
end)
nehevent[34].max_i = 3
nehevent[34].min_i = 0
nehevent[34].mod_i = 1
nehevent[34].value_i = setting["CLEAR_AREA_EVENT"]
nehevent[35] = menu.add_feature("CLEAR_RECTANGLE_AREA_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["CLEAR_RECTANGLE_AREA_EVENT"] = f.value_i
end)
nehevent[35].max_i = 3
nehevent[35].min_i = 0
nehevent[35].mod_i = 1
nehevent[35].value_i = setting["CLEAR_RECTANGLE_AREA_EVENT"]
nehevent[36] = menu.add_feature("NETWORK_REQUEST_SYNCED_SCENE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_REQUEST_SYNCED_SCENE_EVENT"] = f.value_i
end)
nehevent[36].max_i = 3
nehevent[36].min_i = 0
nehevent[36].mod_i = 1
nehevent[36].value_i = setting["NETWORK_REQUEST_SYNCED_SCENE_EVENT"]
nehevent[37] = menu.add_feature("NETWORK_START_SYNCED_SCENE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_START_SYNCED_SCENE_EVENT"] = f.value_i
end)
nehevent[37].max_i = 3
nehevent[37].min_i = 0
nehevent[37].mod_i = 1
nehevent[37].value_i = setting["NETWORK_START_SYNCED_SCENE_EVENT"]
nehevent[38] = menu.add_feature("NETWORK_STOP_SYNCED_SCENE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_STOP_SYNCED_SCENE_EVENT"] = f.value_i
end)
nehevent[38].max_i = 3
nehevent[38].min_i = 0
nehevent[38].mod_i = 1
nehevent[38].value_i = setting["NETWORK_STOP_SYNCED_SCENE_EVENT"]
nehevent[39] = menu.add_feature("NETWORK_UPDATE_SYNCED_SCENE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_UPDATE_SYNCED_SCENE_EVENT"] = f.value_i
end)
nehevent[39].max_i = 3
nehevent[39].min_i = 0
nehevent[39].mod_i = 1
nehevent[39].value_i = setting["NETWORK_UPDATE_SYNCED_SCENE_EVENT"]
nehevent[40] = menu.add_feature("INCIDENT_ENTITY_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["INCIDENT_ENTITY_EVENT"] = f.value_i
end)
nehevent[40].max_i = 3
nehevent[40].min_i = 0
nehevent[40].mod_i = 1
nehevent[40].value_i = setting["INCIDENT_ENTITY_EVENT"]
nehevent[41] = menu.add_feature("GIVE_PED_SCRIPTED_TASK_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["GIVE_PED_SCRIPTED_TASK_EVENT"] = f.value_i
end)
nehevent[41].max_i = 3
nehevent[41].min_i = 0
nehevent[41].mod_i = 1
nehevent[41].value_i = setting["GIVE_PED_SCRIPTED_TASK_EVENT"]
nehevent[42] = menu.add_feature("GIVE_PED_SEQUENCE_TASK_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["GIVE_PED_SEQUENCE_TASK_EVENT"] = f.value_i
end)
nehevent[42].max_i = 3
nehevent[42].min_i = 0
nehevent[42].mod_i = 1
nehevent[42].value_i = setting["GIVE_PED_SEQUENCE_TASK_EVENT"]
nehevent[43] = menu.add_feature("NETWORK_CLEAR_PED_TASKS_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_CLEAR_PED_TASKS_EVENT"] = f.value_i
end)
nehevent[43].max_i = 3
nehevent[43].min_i = 0
nehevent[43].mod_i = 1
nehevent[43].value_i = setting["NETWORK_CLEAR_PED_TASKS_EVENT"]
nehevent[44] = menu.add_feature("NETWORK_START_PED_ARREST_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_START_PED_ARREST_EVENT"] = f.value_i
end)
nehevent[44].max_i = 3
nehevent[44].min_i = 0
nehevent[44].mod_i = 1
nehevent[44].value_i = setting["NETWORK_START_PED_ARREST_EVENT"]
nehevent[45] = menu.add_feature("NETWORK_START_PED_UNCUFF_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_START_PED_UNCUFF_EVENT"] = f.value_i
end)
nehevent[45].max_i = 3
nehevent[45].min_i = 0
nehevent[45].mod_i = 1
nehevent[45].value_i = setting["NETWORK_START_PED_UNCUFF_EVENT"]
nehevent[46] = menu.add_feature("NETWORK_SOUND_CAR_HORN_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_SOUND_CAR_HORN_EVENT"] = f.value_i
end)
nehevent[46].max_i = 3
nehevent[46].min_i = 0
nehevent[46].mod_i = 1
nehevent[46].value_i = setting["NETWORK_SOUND_CAR_HORN_EVENT"]
nehevent[47] = menu.add_feature("NETWORK_ENTITY_AREA_STATUS_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_ENTITY_AREA_STATUS_EVENT"] = f.value_i
end)
nehevent[47].max_i = 3
nehevent[47].min_i = 0
nehevent[47].mod_i = 1
nehevent[47].value_i = setting["NETWORK_ENTITY_AREA_STATUS_EVENT"]
nehevent[48] = menu.add_feature("NETWORK_GARAGE_OCCUPIED_STATUS_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_GARAGE_OCCUPIED_STATUS_EVENT"] = f.value_i
end)
nehevent[48].max_i = 3
nehevent[48].min_i = 0
nehevent[48].mod_i = 1
nehevent[48].value_i = setting["NETWORK_GARAGE_OCCUPIED_STATUS_EVENT"]
nehevent[49] = menu.add_feature("PED_CONVERSATION_LINE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["PED_CONVERSATION_LINE_EVENT"] = f.value_i
end)
nehevent[49].max_i = 3
nehevent[49].min_i = 0
nehevent[49].mod_i = 1
nehevent[49].value_i = setting["PED_CONVERSATION_LINE_EVENT"]
nehevent[50] = menu.add_feature("SCRIPT_ENTITY_STATE_CHANGE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["SCRIPT_ENTITY_STATE_CHANGE_EVENT"] = f.value_i
end)
nehevent[50].max_i = 3
nehevent[50].min_i = 0
nehevent[50].mod_i = 1
nehevent[50].value_i = setting["SCRIPT_ENTITY_STATE_CHANGE_EVENT"]
nehevent[51] = menu.add_feature("NETWORK_PLAY_SOUND_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_PLAY_SOUND_EVENT"] = f.value_i
end)
nehevent[51].max_i = 3
nehevent[51].min_i = 0
nehevent[51].mod_i = 1
nehevent[51].value_i = setting["NETWORK_PLAY_SOUND_EVENT"]
nehevent[52] = menu.add_feature("NETWORK_STOP_SOUND_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_STOP_SOUND_EVENT"] = f.value_i
end)
nehevent[52].max_i = 3
nehevent[52].min_i = 0
nehevent[52].mod_i = 1
nehevent[52].value_i = setting["NETWORK_STOP_SOUND_EVENT"]
nehevent[53] = menu.add_feature("NETWORK_PLAY_AIRDEFENSE_FIRE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_PLAY_AIRDEFENSE_FIRE_EVENT"] = f.value_i
end)
nehevent[53].max_i = 3
nehevent[53].min_i = 0
nehevent[53].mod_i = 1
nehevent[53].value_i = setting["NETWORK_PLAY_AIRDEFENSE_FIRE_EVENT"]
nehevent[54] = menu.add_feature("NETWORK_BANK_REQUEST_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_BANK_REQUEST_EVENT"] = f.value_i
end)
nehevent[54].max_i = 3
nehevent[54].min_i = 0
nehevent[54].mod_i = 1
nehevent[54].value_i = setting["NETWORK_BANK_REQUEST_EVENT"]
nehevent[55] = menu.add_feature("NETWORK_AUDIO_BARK_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_AUDIO_BARK_EVENT"] = f.value_i
end)
nehevent[55].max_i = 3
nehevent[55].min_i = 0
nehevent[55].mod_i = 1
nehevent[55].value_i = setting["NETWORK_AUDIO_BARK_EVENT"]
nehevent[56] = menu.add_feature("REQUEST_DOOR_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REQUEST_DOOR_EVENT"] = f.value_i
end)
nehevent[56].max_i = 3
nehevent[56].min_i = 0
nehevent[56].mod_i = 1
nehevent[56].value_i = setting["REQUEST_DOOR_EVENT"]
nehevent[57] = menu.add_feature("NETWORK_TRAIN_REPORT_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_TRAIN_REPORT_EVENT"] = f.value_i
end)
nehevent[57].max_i = 3
nehevent[57].min_i = 0
nehevent[57].mod_i = 1
nehevent[57].value_i = setting["NETWORK_TRAIN_REPORT_EVENT"]
nehevent[58] = menu.add_feature("NETWORK_TRAIN_REQUEST_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_TRAIN_REQUEST_EVENT"] = f.value_i
end)
nehevent[58].max_i = 3
nehevent[58].min_i = 0
nehevent[58].mod_i = 1
nehevent[58].value_i = setting["NETWORK_TRAIN_REQUEST_EVENT"]
nehevent[59] = menu.add_feature("NETWORK_INCREMENT_STAT_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_INCREMENT_STAT_EVENT"] = f.value_i
end)
nehevent[59].max_i = 3
nehevent[59].min_i = 0
nehevent[59].mod_i = 1
nehevent[59].value_i = setting["NETWORK_INCREMENT_STAT_EVENT"]
nehevent[60] = menu.add_feature("MODIFY_VEHICLE_LOCK_WORD_STATE_DATA", "autoaction_value_i", neh_settings, function(f)
    setting["MODIFY_VEHICLE_LOCK_WORD_STATE_DATA"] = f.value_i
end)
nehevent[60].max_i = 3
nehevent[60].min_i = 0
nehevent[60].mod_i = 1
nehevent[60].value_i = setting["MODIFY_VEHICLE_LOCK_WORD_STATE_DATA"]
nehevent[61] = menu.add_feature("MODIFY_PTFX_WORD_STATE_DATA_SCRIPTED_EVOLVE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["MODIFY_PTFX_WORD_STATE_DATA_SCRIPTED_EVOLVE_EVENT"] = f.value_i
end)
nehevent[61].max_i = 3
nehevent[61].min_i = 0
nehevent[61].mod_i = 1
nehevent[61].value_i = setting["MODIFY_PTFX_WORD_STATE_DATA_SCRIPTED_EVOLVE_EVENT"]
nehevent[62] = menu.add_feature("REQUEST_PHONE_EXPLOSION_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REQUEST_PHONE_EXPLOSION_EVENT"] = f.value_i
end)
nehevent[62].max_i = 3
nehevent[62].min_i = 0
nehevent[62].mod_i = 1
nehevent[62].value_i = setting["REQUEST_PHONE_EXPLOSION_EVENT"]
nehevent[63] = menu.add_feature("REQUEST_DETACHMENT_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REQUEST_DETACHMENT_EVENT"] = f.value_i
end)
nehevent[63].max_i = 3
nehevent[63].min_i = 0
nehevent[63].mod_i = 1
nehevent[63].value_i = setting["REQUEST_DETACHMENT_EVENT"]
nehevent[64] = menu.add_feature("KICK_VOTES_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["KICK_VOTES_EVENT"] = f.value_i
end)
nehevent[64].max_i = 3
nehevent[64].min_i = 0
nehevent[64].mod_i = 1
nehevent[64].value_i = setting["KICK_VOTES_EVENT"]
nehevent[65] = menu.add_feature("GIVE_PICKUP_REWARDS_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["GIVE_PICKUP_REWARDS_EVENT"] = f.value_i
end)
nehevent[65].max_i = 3
nehevent[65].min_i = 0
nehevent[65].mod_i = 1
nehevent[65].value_i = setting["GIVE_PICKUP_REWARDS_EVENT"]
nehevent[66] = menu.add_feature("NETWORK_CRC_HASH_CHECK_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_CRC_HASH_CHECK_EVENT"] = f.value_i
end)
nehevent[66].max_i = 3
nehevent[66].min_i = 0
nehevent[66].mod_i = 1
nehevent[66].value_i = setting["NETWORK_CRC_HASH_CHECK_EVENT"]
nehevent[67] = menu.add_feature("BLOW_UP_VEHICLE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["BLOW_UP_VEHICLE_EVENT"] = f.value_i
end)
nehevent[67].max_i = 3
nehevent[67].min_i = 0
nehevent[67].mod_i = 1
nehevent[67].value_i = setting["BLOW_UP_VEHICLE_EVENT"]
nehevent[68] = menu.add_feature("NETWORK_SPECIAL_FIRE_EQUIPPED_WEAPON", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_SPECIAL_FIRE_EQUIPPED_WEAPON"] = f.value_i
end)
nehevent[68].max_i = 3
nehevent[68].min_i = 0
nehevent[68].mod_i = 1
nehevent[68].value_i = setting["NETWORK_SPECIAL_FIRE_EQUIPPED_WEAPON"]
nehevent[69] = menu.add_feature("NETWORK_RESPONDED_TO_THREAT_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_RESPONDED_TO_THREAT_EVENT"] = f.value_i
end)
nehevent[69].max_i = 3
nehevent[69].min_i = 0
nehevent[69].mod_i = 1
nehevent[69].value_i = setting["NETWORK_RESPONDED_TO_THREAT_EVENT"]
nehevent[70] = menu.add_feature("NETWORK_SHOUT_TARGET_POSITION", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_SHOUT_TARGET_POSITION"] = f.value_i
end)
nehevent[70].max_i = 3
nehevent[70].min_i = 0
nehevent[70].mod_i = 1
nehevent[70].value_i = setting["NETWORK_SHOUT_TARGET_POSITION"]
nehevent[71] = menu.add_feature("VOICE_DRIVEN_MOUTH_MOVEMENT_FINISHED_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["VOICE_DRIVEN_MOUTH_MOVEMENT_FINISHED_EVENT"] = f.value_i
end)
nehevent[71].max_i = 3
nehevent[71].min_i = 0
nehevent[71].mod_i = 1
nehevent[71].value_i = setting["VOICE_DRIVEN_MOUTH_MOVEMENT_FINISHED_EVENT"]
nehevent[72] = menu.add_feature("PICKUP_DESTROYED_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["PICKUP_DESTROYED_EVENT"] = f.value_i
end)
nehevent[72].max_i = 3
nehevent[72].min_i = 0
nehevent[72].mod_i = 1
nehevent[72].value_i = setting["PICKUP_DESTROYED_EVENT"]
nehevent[73] = menu.add_feature("UPDATE_PLAYER_SCARS_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["UPDATE_PLAYER_SCARS_EVENT"] = f.value_i
end)
nehevent[73].max_i = 3
nehevent[73].min_i = 0
nehevent[73].mod_i = 1
nehevent[73].value_i = setting["UPDATE_PLAYER_SCARS_EVENT"]
nehevent[74] = menu.add_feature("NETWORK_CHECK_EXE_SIZE_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_CHECK_EXE_SIZE_EVENT"] = f.value_i
end)
nehevent[74].max_i = 3
nehevent[74].min_i = 0
nehevent[74].mod_i = 1
nehevent[74].value_i = setting["NETWORK_CHECK_EXE_SIZE_EVENT"]
nehevent[75] = menu.add_feature("NETWORK_PTFX_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_PTFX_EVENT"] = f.value_i
end)
nehevent[75].max_i = 3
nehevent[75].min_i = 0
nehevent[75].mod_i = 1
nehevent[75].value_i = setting["NETWORK_PTFX_EVENT"]
nehevent[76] = menu.add_feature("NETWORK_PED_SEEN_DEAD_PED_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_PED_SEEN_DEAD_PED_EVENT"] = f.value_i
end)
nehevent[76].max_i = 3
nehevent[76].min_i = 0
nehevent[76].mod_i = 1
nehevent[76].value_i = setting["NETWORK_PED_SEEN_DEAD_PED_EVENT"]
nehevent[77] = menu.add_feature("REMOVE_STICKY_BOMB_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REMOVE_STICKY_BOMB_EVENT"] = f.value_i
end)
nehevent[77].max_i = 3
nehevent[77].min_i = 0
nehevent[77].mod_i = 1
nehevent[77].value_i = setting["REMOVE_STICKY_BOMB_EVENT"]
nehevent[78] = menu.add_feature("NETWORK_CHECK_CODE_CRCS_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_CHECK_CODE_CRCS_EVENT"] = f.value_i
end)
nehevent[78].max_i = 3
nehevent[78].min_i = 0
nehevent[78].mod_i = 1
nehevent[78].value_i = setting["NETWORK_CHECK_CODE_CRCS_EVENT"]
nehevent[79] = menu.add_feature("INFORM_SILENCED_GUNSHOT_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["INFORM_SILENCED_GUNSHOT_EVENT"] = f.value_i
end)
nehevent[79].max_i = 3
nehevent[79].min_i = 0
nehevent[79].mod_i = 1
nehevent[79].value_i = setting["INFORM_SILENCED_GUNSHOT_EVENT"]
nehevent[80] = menu.add_feature("PED_PLAY_PAIN_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["PED_PLAY_PAIN_EVENT"] = f.value_i
end)
nehevent[80].max_i = 3
nehevent[80].min_i = 0
nehevent[80].mod_i = 1
nehevent[80].value_i = setting["PED_PLAY_PAIN_EVENT"]
nehevent[81] = menu.add_feature("CACHE_PLAYER_HEAD_BLEND_DATA_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["CACHE_PLAYER_HEAD_BLEND_DATA_EVENT"] = f.value_i
end)
nehevent[81].max_i = 3
nehevent[81].min_i = 0
nehevent[81].mod_i = 1
nehevent[81].value_i = setting["CACHE_PLAYER_HEAD_BLEND_DATA_EVENT"]
nehevent[82] = menu.add_feature("REMOVE_PED_FROM_PEDGROUP_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REMOVE_PED_FROM_PEDGROUP_EVENT"] = f.value_i
end)
nehevent[82].max_i = 3
nehevent[82].min_i = 0
nehevent[82].mod_i = 1
nehevent[82].value_i = setting["REMOVE_PED_FROM_PEDGROUP_EVENT"]
nehevent[83] = menu.add_feature("REPORT_MYSELF_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REPORT_MYSELF_EVENT"] = f.value_i
end)
nehevent[83].max_i = 3
nehevent[83].min_i = 0
nehevent[83].mod_i = 1
nehevent[83].value_i = setting["REPORT_MYSELF_EVENT"]
nehevent[84] = menu.add_feature("REPORT_CASH_SPAWN_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["REPORT_CASH_SPAWN_EVENT"] = f.value_i
end)
nehevent[84].max_i = 3
nehevent[84].min_i = 0
nehevent[84].mod_i = 1
nehevent[84].value_i = setting["REPORT_CASH_SPAWN_EVENT"]
nehevent[85] = menu.add_feature("ACTIVATE_VEHICLE_SPECIAL_ABILITY_EVENT", "autoaction_value_i", neh_settings, function(f)
    setting["ACTIVATE_VEHICLE_SPECIAL_ABILITY_EVENT"] = f.value_i
end)
nehevent[85].max_i = 3
nehevent[85].min_i = 0
nehevent[85].mod_i = 1
nehevent[85].value_i = setting["ACTIVATE_VEHICLE_SPECIAL_ABILITY_EVENT"]
nehevent[86] = menu.add_feature("BLOCK_WEAPON_SELECTION", "autoaction_value_i", neh_settings, function(f)
    setting["BLOCK_WEAPON_SELECTION"] = f.value_i
end)
nehevent[86].max_i = 3
nehevent[86].min_i = 0
nehevent[86].mod_i = 1
nehevent[86].value_i = setting["BLOCK_WEAPON_SELECTION"]
nehevent[87] = menu.add_feature("NETWORK_CHECK_CATALOG_CRC", "autoaction_value_i", neh_settings, function(f)
    setting["NETWORK_CHECK_CATALOG_CRC"] = f.value_i
end)
nehevent[87].max_i = 3
nehevent[87].min_i = 0
nehevent[87].mod_i = 1
nehevent[87].value_i = setting["NETWORK_CHECK_CATALOG_CRC"]

-- Destroy logs on startup?
local destlogset = menu.add_feature("Destroy logs on Startup", "toggle", settings_menu, function(f)
if f.on then
    setting["destroylog"] = true
    local dbg_dls = ("Option: Destroy Logs on Startup. Set to: True")
    dbg(dbg_dls, "[Settings Change]", "Debug.log")
else
    setting["destroylog"] = false
    local dbg_dls = ("Option: Destroy Logs on Startup. Set to: False")
    dbg(dbg_dls, "[Settings Change]", "Debug.log")
end
end)
destlogset.on = setting["destroylog"]
-- save settings
menu.add_feature("Save Settings", "action", settings_menu, function(f)
    SaveSettings()
    ui.notify_above_map("Settings Saved", script_name, 25)
    local sav_set = ("Saved Settings to Utilities.ini")
    dbg(sav_set, "[Save Settings]", "Debug.log")
end)

menu.add_feature("Cleanup all log Files", "action", log_cleanup, function(f)
    for i=0, #logfiles do
        if utils.file_exists(logfiles[i]) then
            ui.notify_above_map("Deleted log Files", script_name, 12)
            knownObjects = {}
            knownPeds = {}
            knownVehicles = {}
            knownPickups = {}
            io.remove(logfiles[i])
            dbg("Deleted log file: "..lognames[i].."", "[Cleanup logs]", "Debug.log")
        end
    end
end)

menu.add_feature("Cleanup Objects.log", "action", log_cleanup, function(f)
    if utils.file_exists(logfiles[0]) then
        knownObjects = {}
        ui.notify_above_map("Deleted Objects.log", script_name, 12)
        local obj_log_cu = ("Deleted Objects.log")
        dbg(obj_log_cu, "[Cleanup logs]", "Debug.log")
        io.remove(logfiles[0])
    else
        ui.notify_above_map("Objects.log not Found", script_name, 148)
    end
end)

menu.add_feature("Cleanup Peds.log", "action", log_cleanup, function(f)
    if utils.file_exists(pedlog) then
        knownPeds = {}
        ui.notify_above_map("Deleted Peds.log", script_name, 12)
        local ped_log_cu = ("Deleted Peds.log")
        dbg(ped_log_cu, "[Cleanup logs]", "Debug.log")
        io.remove(pedlog)
    else
        ui.notify_above_map("Peds.log not Found", script_name, 148)
    end
end)

menu.add_feature("Cleanup Vehicles.log", "action", log_cleanup, function(f)
    if utils.file_exists(vehlog) then
        knownVehicles = {}
        ui.notify_above_map("Deleted Vehicles.log", script_name, 12)
        local veh_log_cu = ("Deleted Vehicles.log")
        dbg(veh_log_cu, "[Cleanup logs]", "Debug.log")
        io.remove(vehlog)
    else
        ui.notify_above_map("Vehicles.log not Found", script_name, 148)
    end
end)

menu.add_feature("Cleanup Pickups.log", "action", log_cleanup, function(f)
    if utils.file_exists(pulog) then
        knownPickups = {}
        ui.notify_above_map("Deleted Pickups.log", script_name, 12)
        local pu_log_cu = ("Deleted Pickups.log")
        dbg(pu_log_cu, "[Cleanup logs]", "Debug.log")
        io.remove(pulog)
    else
        ui.notify_above_map("Pickups.log not Found", script_name, 148)
    end
end)

for i=4, #logfiles do
    menu.add_feature(""..lognames[i].."", "action", log_cleanup, function(f)
        if utils.file_exists(logfiles[i]) then
            ui.notify_above_map("Deleted "..logfiles[i].."", script_name, 12)
            dbg("Deleted "..lognames[i].."", "[Cleanup logs]", "Debug.log")
            io.remove(logfiles[i])
        else
            ui.notify_above_map(""..logfiles[i].." not Found", script_name, 148)
        end
    end)
end

event.add_event_listener("exit", function()
    dbg("Utilities got unloaded.", "[Utilities Cleanup]", "Debug.log")
    dbg("Cleaning up...", "[Utilities Cleanup]", "Debug.log")
    dbg("Removing event listeners...", "[Utilities Cleanup]", "Debug.log")
    event.remove_event_listener("player_join", pjoin_el)
    dbg("Removed event listeners.", "[Utilities Cleanup]", "Debug.log")
    dbg("Removing Net Event hooks...", "[Utilities Cleanup]", "Debug.log")
    NetHookOff()
    dbg("Removed Net Event hooks.", "[Utilities Cleanup]", "Debug.log")
    if setting["destroylog"] then
    local dbg_egg = "All your .log are belong to us... Actually, now they're dead."
    dbg(dbg_egg, "[Destroy logs]", "Debug.log")
    for i=0, #logfiles do
        if utils.file_exists(logfiles[i]) then
            io.remove(logfiles[i])
        end
    end
    local dbg_dest_log = ("Destroyed all .log on script startup")
    dbg(dbg_dest_log, "[Destroy logs]", "Debug.log")
    end
    Utilities_Script = nil
    dbg("Utilities Unloaded", "[Utilities Cleanup]", "Debug.log")
    dbg("Finished cleanup.", "[Utilities Cleanup]", "Debug.log")
end)

local dbg_sl = (script_name.." loaded successfully")
dbg(dbg_sl, "[Load Successful]", "Debug.log")
Utilities_Script = true
