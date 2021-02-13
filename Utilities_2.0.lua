local script_name = "Utilities"

utils.make_dir(os.getenv("APPDATA").."\\PopstarDevs\\2Take1Menu\\scripts\\Utilities")
utils.make_dir(os.getenv("APPDATA").."\\PopstarDevs\\2Take1Menu\\scripts\\Utilities\\logs")
utils.make_dir(os.getenv("APPDATA").."\\PopstarDevs\\2Take1Menu\\scripts\\Utilities\\debug")
local utilities_home = os.getenv("APPDATA").."\\PopstarDevs\\2Take1Menu\\scripts\\Utilities"
local utilities_logs = utilities_home.."\\logs"
local utilities_debug = utilities_home.."\\debug"

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
    local log_file = io.open(path.."\\Utilities\\debug\\"..file_name, "a")
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
-- info
setting[0][#setting[0]+1] = "section_1"
setting["section_1"] = "[Info]"
setting[0][#setting[0]+1] = "version"
setting["version"] = "2.0.0"
-- clear area range
setting[0][#setting[0]+1] = "section_5"
setting["section_5"] = "[Clear Area Range]"
setting[0][#setting[0]+1] = "clear_objects_area"
setting["clear_objects_area"] = 250
setting[0][#setting[0]+1] = "clear_objects_area_t"
setting["clear_objects_area_t"] = 250
setting[0][#setting[0]+1] = "clear_peds_area"
setting["clear_peds_area"] = 250
setting[0][#setting[0]+1] = "clear_peds_area_t"
setting["clear_peds_area_t"] = 250
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
-- clear area req ctrl attempt limit
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
-- Clear area req ctrl delay -----------------------
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
-- log info Settings - clear area -----------------
setting[0][#setting[0]+1] = "section_11"
setting["section_11"] = "[Clear Area Info]"
--clear area entity debug/log on/off
setting[0][#setting[0]+1] = "clear_area_ped_dbg"   -- clear area peds debug
setting["clear_area_ped_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_ped_log"   -- clear area peds log
setting["clear_area_ped_log"] = false
setting[0][#setting[0]+1] = "clear_area_object_dbg"   -- clear area objects debug
setting["clear_area_object_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_object_log"   -- clear area objects log
setting["clear_area_object_log"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_dbg"   -- clear area vehicles debug
setting["clear_area_vehicle_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_log"   -- clear area vehicles log
setting["clear_area_vehicle_log"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_dbg"  -- clear area pickups debug
setting["clear_area_pickup_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_log"  -- clear area pickups log
setting["clear_area_pickup_log"] = false
-- object log stuff
setting[0][#setting[0]+1] = "clear_area_object_ent_id_log"
setting["clear_area_object_ent_id_log"] = false
setting[0][#setting[0]+1] = "clear_area_object_hash_log"
setting["clear_area_object_hash_log"] = false
setting[0][#setting[0]+1] = "clear_area_object_model_log"
setting["clear_area_object_model_log"] = false
setting[0][#setting[0]+1] = "clear_area_object_coord_log"
setting["clear_area_object_coord_log"] = false
setting[0][#setting[0]+1] = "clear_area_object_rot_log"
setting["clear_area_object_rot_log"] = false
setting[0][#setting[0]+1] = "clear_area_object_head_log"
setting["clear_area_object_head_log"] = false
setting[0][#setting[0]+1] = "clear_area_object_vis_log"
setting["clear_area_object_vis_log"] = false
setting[0][#setting[0]+1] = "clear_area_object_ent_id_dbg"
setting["clear_area_object_ent_id_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_object_hash_dbg"
setting["clear_area_object_hash_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_object_model_dbg"
setting["clear_area_object_model_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_object_coord_dbg"
setting["clear_area_object_coord_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_object_rot_dbg"
setting["clear_area_object_rot_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_object_head_dbg"
setting["clear_area_object_head_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_object_vis_dbg"
setting["clear_area_object_vis_dbg"] = false
-- ped log stuff    
setting[0][#setting[0]+1] = "clear_area_ped_ent_id_log"
setting["clear_area_ped_ent_id_log"] = false
setting[0][#setting[0]+1] = "clear_area_ped_hash_log"
setting["clear_area_ped_hash_log"] = false
setting[0][#setting[0]+1] = "clear_area_ped_model_log"
setting["clear_area_ped_model_log"] = false
setting[0][#setting[0]+1] = "clear_area_ped_coord_log"
setting["clear_area_ped_coord_log"] = false
setting[0][#setting[0]+1] = "clear_area_ped_rot_log"
setting["clear_area_ped_rot_log"] = false
setting[0][#setting[0]+1] = "clear_area_ped_head_log"
setting["clear_area_ped_head_log"] = false
setting[0][#setting[0]+1] = "clear_area_ped_vis_log"
setting["clear_area_ped_vis_log"] = false
setting[0][#setting[0]+1] = "clear_area_ped_ent_id_dbg"
setting["clear_area_ped_ent_id_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_ped_hash_dbg"
setting["clear_area_ped_hash_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_ped_model_dbg"
setting["clear_area_ped_model_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_ped_coord_dbg"
setting["clear_area_ped_coord_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_ped_rot_dbg"
setting["clear_area_ped_rot_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_ped_head_dbg"
setting["clear_area_ped_head_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_ped_vis_dbg"
setting["clear_area_ped_vis_dbg"] = false
-- vehicle log stuff    
setting[0][#setting[0]+1] = "clear_area_vehicle_ent_id_log"
setting["clear_area_vehicle_ent_id_log"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_hash_log"
setting["clear_area_vehicle_hash_log"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_model_log"
setting["clear_area_vehicle_model_log"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_coord_log"
setting["clear_area_vehicle_coord_log"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_rot_log"
setting["clear_area_vehicle_rot_log"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_head_log"
setting["clear_area_vehicle_head_log"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_vis_log"
setting["clear_area_vehicle_vis_log"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_ent_id_dbg"
setting["clear_area_vehicle_ent_id_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_hash_dbg"
setting["clear_area_vehicle_hash_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_model_dbg"
setting["clear_area_vehicle_model_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_coord_dbg"
setting["clear_area_vehicle_coord_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_rot_dbg"
setting["clear_area_vehicle_rot_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_head_dbg"
setting["clear_area_vehicle_head_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_vehicle_vis_dbg"
setting["clear_area_vehicle_vis_dbg"] = false
-- pickups log stuff   
setting[0][#setting[0]+1] = "clear_area_pickup_ent_id_log"
setting["clear_area_pickup_ent_id_log"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_hash_log"
setting["clear_area_pickup_hash_log"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_model_log"
setting["clear_area_pickup_model_log"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_coord_log"
setting["clear_area_pickup_coord_log"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_rot_log"
setting["clear_area_pickup_rot_log"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_head_log"
setting["clear_area_pickup_head_log"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_vis_log"
setting["clear_area_pickup_vis_log"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_ent_id_dbg"
setting["clear_area_pickup_ent_id_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_hash_dbg"
setting["clear_area_pickup_hash_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_model_dbg"
setting["clear_area_pickup_model_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_coord_dbg"
setting["clear_area_pickup_coord_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_rot_dbg"
setting["clear_area_pickup_rot_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_head_dbg"
setting["clear_area_pickup_head_dbg"] = false
setting[0][#setting[0]+1] = "clear_area_pickup_vis_dbg"
setting["clear_area_pickup_vis_dbg"] = false
-- log info settings - entity log -------
setting[0][#setting[0]+1] = "section_12"
setting["section_12"] = "[Entity log Info]"
-- object log info on/off ----------------
setting[0][#setting[0]+1] = "log_object_ent_id"
setting["log_object_ent_id"] = false
setting[0][#setting[0]+1] = "log_object_hash"
setting["log_object_hash"] = false
setting[0][#setting[0]+1] = "log_object_model"
setting["log_object_model"] = false
setting[0][#setting[0]+1] = "log_object_coord"
setting["log_object_coord"] = false
setting[0][#setting[0]+1] = "log_object_rot"
setting["log_object_rot"] = false
setting[0][#setting[0]+1] = "log_object_head"
setting["log_object_head"] = false
setting[0][#setting[0]+1] = "log_object_vis"
setting["log_object_vis"] = false
-- ped log info on/off --------------
setting[0][#setting[0]+1] = "log_ped_ent_id"
setting["log_ped_ent_id"] = false
setting[0][#setting[0]+1] = "log_ped_hash"
setting["log_ped_hash"] = false
setting[0][#setting[0]+1] = "log_ped_model"
setting["log_ped_model"] = false
setting[0][#setting[0]+1] = "log_ped_coord"
setting["log_ped_coord"] = false
setting[0][#setting[0]+1] = "log_ped_rot"
setting["log_ped_rot"] = false
setting[0][#setting[0]+1] = "log_ped_head"
setting["log_ped_head"] = false
setting[0][#setting[0]+1] = "log_ped_vis"
setting["log_ped_vis"] = false
-- vehicle log info on/off --------
setting[0][#setting[0]+1] = "log_vehicle_ent_id"
setting["log_vehicle_ent_id"] = false
setting[0][#setting[0]+1] = "log_vehicle_hash"
setting["log_vehicle_hash"] = false
setting[0][#setting[0]+1] = "log_vehicle_model"
setting["log_vehicle_model"] = false
setting[0][#setting[0]+1] = "log_vehicle_coord"
setting["log_vehicle_coord"] = false
setting[0][#setting[0]+1] = "log_vehicle_rot"
setting["log_vehicle_rot"] = false
setting[0][#setting[0]+1] = "log_vehicle_head"
setting["log_vehicle_head"] = false
setting[0][#setting[0]+1] = "log_vehicle_vis"
setting["log_vehicle_vis"] = false
-- pickup log info on/off ----------
setting[0][#setting[0]+1] = "log_pickup_ent_id"
setting["log_pickup_ent_id"] = false
setting[0][#setting[0]+1] = "log_pickup_hash"
setting["log_pickup_hash"] = false
setting[0][#setting[0]+1] = "log_pickup_model"
setting["log_pickup_model"] = false
setting[0][#setting[0]+1] = "log_pickup_coord"
setting["log_pickup_coord"] = false
setting[0][#setting[0]+1] = "log_pickup_rot"
setting["log_pickup_rot"] = false
setting[0][#setting[0]+1] = "log_pickup_head"
setting["log_pickup_head"] = false
setting[0][#setting[0]+1] = "log_pickup_vis"
setting["log_pickup_vis"] = false
-- log info settings - Entity Manager ----
setting[0][#setting[0]+1] = "section_13"
setting["section_13"] = "[Entity Manager Info]"
--clear area entity debug/log on/off
setting[0][#setting[0]+1] = "entity_manager_ped_dbg"   -- entity manager peds debug
setting["entity_manager_ped_dbg"] = false
setting[0][#setting[0]+1] = "entity_manager_ped_log"   -- entity manager peds log
setting["entity_manager_ped_log"] = false
setting[0][#setting[0]+1] = "entity_manager_object_dbg"   -- entity manager objects debug
setting["entity_manager_object_dbg"] = false
setting[0][#setting[0]+1] = "entity_manager_object_log"   -- entity manager objects log
setting["entity_manager_object_log"] = false
setting[0][#setting[0]+1] = "entity_manager_vehicle_dbg"   -- entity manager vehicles debug
setting["entity_manager_vehicle_dbg"] = false
setting[0][#setting[0]+1] = "entity_manager_vehicle_log"   -- entity manager vehicles log
setting["entity_manager_vehicle_log"] = false
setting[0][#setting[0]+1] = "entity_manager_pickup_dbg"  -- entity manager pickups debug
setting["entity_manager_pickup_dbg"] = false
setting[0][#setting[0]+1] = "entity_manager_pickup_log"  -- entity manager pickups log
setting["entity_manager_pickup_log"] = false
-- misc ---------------------------------
setting[0][#setting[0]+1] = "section_3"
setting["section_3"] = "[Misc]"
setting[0][#setting[0]+1] = "delete_gun"
setting["delete_gun"] = false
setting[0][#setting[0]+1] = "info_gun"
setting["info_gun"] = false
-- delay settings ------------------------
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
-- log entities on startup
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
-- misc logs enabled on startup
setting[0][#setting[0]+1] = "section_6"
setting["section_6"] = "[Misc logs Enabled on Startup]"
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
-- delete .log files on script start
setting[0][#setting[0]+1] = "section_7"
setting["section_7"] = "[Kill .log Files on Startup]"
setting[0][#setting[0]+1] = "destroylog"
setting["destroylog"] = false
-- Net Event log Settings
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
-- save settings
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
-- load settings
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
-- read settings
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

-- submenus
local utilities = menu.add_feature("Utilities", "parent", 0).id
    local clear_area = menu.add_feature("Clear Area", "parent", utilities).id
        menu.add_feature("CAUTION: Game may lag or crash", "action", clear_area, function()end)
        menu.add_feature("if you set the ranges too high", "action", clear_area, function()end)
        local clear_objects_menu = menu.add_feature("Clear Objects", "parent", clear_area).id
        local clear_peds_menu = menu.add_feature("Clear Peds", "parent", clear_area).id
        local clear_vehicles_menu = menu.add_feature("Clear Vehicles", "parent", clear_area).id
        local clear_pickups_menu = menu.add_feature("Clear Pickups", "parent", clear_area).id
        local clear_cops_menu = menu.add_feature("Clear Cops", "parent", clear_area).id
        local clear_all_menu = menu.add_feature("Clear All", "parent", clear_area).id
    local entity_manager = menu.add_feature("(WIP)Entity Manager", "parent", utilities).id
    local misc_shit = menu.add_feature("Misc Shit", "parent", utilities).id
    local new_entity_log = menu.add_feature("New Entity log", "parent", utilities).id
    local log_misc = menu.add_feature("Misc log", "parent", utilities).id
        local ne_log = menu.add_feature("(WIP) Net Event log", "parent",  log_misc).id
        local se_log = menu.add_feature("(WIP) Script Event log", "parent", log_misc).id
    local log_cleanup = menu.add_feature("log Cleanup", "parent", utilities).id
    local settings_menu = menu.add_feature("Settings", "parent", utilities).id
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
        local ca_settings = menu.add_feature("Clear Area Settings", "parent", settings_menu).id
            local ca_settings_range = menu.add_feature("Clear Area Range", "parent", ca_settings).id
                menu.add_feature("Set the range then confirm the option", "action", ca_settings_range)
            local ca_settings_rcl = menu.add_feature("Req Ctrl Limit", "parent", ca_settings).id
                menu.add_feature("Clear Area function will attempt to get control of", "action", ca_settings_rcl, function()end)
                menu.add_feature("Entities, then give up after this many attempts.", "action", ca_settings_rcl, function()end)
            local ca_settings_rcd = menu.add_feature("Req Ctrl Delay", "parent", ca_settings).id
                menu.add_feature("This is the Delay between Request Control Attempts", "action", ca_settings_rcd, function()end)
            local ca_settings_info = menu.add_feature("Clear Area Info", "parent", ca_settings).id
                local cas_info_ped = menu.add_feature("Peds Info", "parent", ca_settings_info).id
                local cas_info_veh = menu.add_feature("Vehicles Info", "parent", ca_settings_info).id
                local cas_info_obj = menu.add_feature("Objects Info", "parent", ca_settings_info).id
                local cas_info_pus = menu.add_feature("Pickups Info", "parent", ca_settings_info).id
        local el_settings = menu.add_feature("Entity log Settings", "parent", settings_menu).id
            local el_settings_ped = menu.add_feature("Ped log Settings", "parent", el_settings).id
            local el_settings_veh = menu.add_feature("Vehicle log Settings", "parent", el_settings).id
            local el_settings_obj = menu.add_feature("Object log Settings", "parent", el_settings).id
            local el_settings_pus = menu.add_feature("Pickup log Settings", "parent", el_settings).id
        local em_settings = menu.add_feature("Entity Manager Settings", "parent", settings_menu).id
            -- entity manager settings shit
        local ml_settings = menu.add_feature("Misc log Settings", "parent", settings_menu).id
        local misc_settings = menu.add_feature("Misc Settings", "parent", settings_menu).id
            local md_settings = menu.add_feature("Modder Detection", "parent", settings_menu).id
        local nel_settings = menu.add_feature("Net Event log Settings", "parent", settings_menu).id
        local dl_settings = menu.add_feature("Delete log Files Startup", "parent", settings_menu).id
local pl_utilities = menu.add_player_feature("Utilities", "parent", 0).id
    local entity_shit = menu.add_player_feature("Entity Shit", "parent", pl_utilities).id

--------------------------------------------------------------
local oob = v3() -- used to teleport entities to out of bounds, for GTA to delete.
oob.x = -5784.258301
oob.y = -8289.385742
oob.z = -136.411270
-- player stuff
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
-- other player stuff
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
-----------------------------------------
local knownObjects = {}
local knownPeds = {}
local knownVehicles = {}
local knownPickups  = {}
-----------------------------------------
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
---- Clear Area fucntions ---------------
local function ClearObjects(area)
    local objects = object.get_all_objects()
    local myPed = MyPed()
    local myPos = MyPos(myPed)
    for j=1, #objects do
        if myPos:magnitude(MyPos(objects[j])) <= area then
            local string_start = "[Entity Type: Object]"
            local log_string = ""
            local dbg_string = ""
            local objhash = entity.get_entity_model_hash(objects[j])
            local objmodel = objectmapper.GetModelFromHash(objhash)
            local objcoord = entity.get_entity_coords(objects[j])
            local objrot = entity.get_entity_rotation(objects[j])
            local objhead = entity.get_entity_heading(objects[j])
            local objvis = entity.is_entity_visible(objects[j])            
            if setting["clear_area_object_ent_id_log"] then
                log_string = log_string.." [Entity ID: "..objects[j].."]"
            end
            if setting["clear_area_object_model_log"] then
                log_string = log_string.." [Entity Hash: "..objhash.."]"
            end
            if setting["clear_area_object_hash_log"] then
                log_string = log_string.." [Entity Model: "..(objmodel or "unknown").."]"
            end
            if setting["clear_area_object_coord_log"] then
                log_string = log_string.." [Entity Co-ords: X: "..objcoord.x.." Y: "..objcoord.y.." Z: "..objcoord.z.."]"
            end
            if setting["clear_area_object_rot_log"] then
                log_string = log_string.." [Entity Rotation: X: "..objrot.x.." Y: "..objrot.y.." Z: "..objrot.z.."]"
            end
            if setting["clear_area_object_head_log"] then
                log_string = log_string.." [Entity Heading: "..objhead.."]"
            end
            if setting["clear_area_object_vis_log"] then
                if objvis then
                    log_string = log_string.." [Entity is Visible]"
                elseif not objvis then
                    log_string = log_string.." [Entity is Not Visible]"
                end
            end
            if setting["clear_area_object_ent_id_dbg"] then
                dbg_string = dbg_string.." [Entity ID: "..objects[j].."]"
            end
            if setting["clear_area_object_model_dbg"] then
                dbg_string = dbg_string.." [Entity Hash: "..objhash.."]"
            end
            if setting["clear_area_object_hash_dbg"] then
                dbg_string = dbg_string.." [Entity Model: "..(objmodel or "unknown").."]"
            end
            if setting["clear_area_object_coord_dbg"] then
                dbg_string = dbg_string.." [Entity Co-ords: X: "..objcoord.x.." Y: "..objcoord.y.." Z: "..objcoord.z.."]"
            end
            if setting["clear_area_object_rot_dbg"] then
                dbg_string = dbg_string.." [Entity Rotation: X: "..objrot.x.." Y: "..objrot.y.." Z: "..objrot.z.."]"
            end
            if setting["clear_area_object_head_dbg"] then
                dbg_string = dbg_string.." [Entity Heading: "..objhead.."]"
            end
            if setting["clear_area_object_vis_dbg"] then
                if objvis then
                    dbg_string = dbg_string.." [Entity is Visible]"
                elseif not objvis then
                    dbg_string = dbg_string.." [Entity is Not Visible]"
                end
            end
            local checkcount = 0
            network.request_control_of_entity(objects[j])
            while not network.has_control_of_entity(objects[j]) do
                system.wait(setting["clr_obj_req_ctrl_del"])
                checkcount = checkcount + 1
                if setting["clear_area_object_dbg"] then
                    string_start = string_start.." [Request Control Attempt: "..checkcount.."]"
                    local dbg_final = string_start..dbg_string
                    dbg(dbg_final, "[Clear Objects]", "ClearAreaDebug.log")
                end
                if CheckCount > tonumber(setting["clr_obj_req_ctrl_limit"]) then
                    if setting["clear_area_object_dbg"] then
                        string_start = string_start.." [Request Control Failed]"
                        local dbg_final = string_start..dbg_string
                        dbg(dbg_final, "[Clear Objects]", "ClearAreaDebug.log")
                    end
                break end
            end
            if setting["clear_area_object_log"] then
                local log_final = ""..string_start..log_string..""
                log(log_final, "[Clear Objects]", "Cleanup.log")
            end
            if setting["clear_area_object_dbg"] then
                string_start = string_start.." [Request Control Successful]"
                local dbg_final = string_start..dbg_string
                dbg(dbg_final, "[Clear Objects]", "ClearAreaDebug.log")
            end
            entity.set_entity_as_no_longer_needed(objects[j])
            entity.set_entity_coords_no_offset(objects[j], oob)
        end
    end
end
--------------------------------------
local function ClearPeds(area)
    local peds = ped.get_all_peds()
    local myPed = MyPed()
    local myPos = MyPos(myPed)
    for j=1, #peds do
        local pped = ped.is_ped_a_player(peds[j])
        if pped ~= peds[j] and myPed ~= peds[j] and myPos:magnitude(MyPos(peds[j])) <= area then
            local string_start = "[Entity Type: Ped]"
            local log_string = ""
            local dbg_string = ""
            local pedhash = entity.get_entity_model_hash(peds[j])
            local pedmodel = pedmapper.GetModelFromHash(pedhash)
            local pedcoord = entity.get_entity_coords(peds[j])
            local pedrot = entity.get_entity_rotation(peds[j])
            local pedhead = entity.get_entity_heading(peds[j])
            local pedvis = entity.is_entity_visible(peds[j])            
            if setting["clear_area_ped_ent_id_log"] then
                log_string = log_string.." [Entity ID: "..peds[j].."]"
            end
            if setting["clear_area_ped_model_log"] then
                log_string = log_string.." [Entity Hash: "..pedhash.."]"
            end
            if setting["clear_area_ped_hash_log"] then
                log_string = log_string.." [Entity Model: "..(pedmodel or "unknown").."]"
            end
            if setting["clear_area_ped_coord_log"] then
                log_string = log_string.." [Entity Co-ords: X: "..pedcoord.x.." Y: "..pedcoord.y.." Z: "..pedcoord.z.."]"
            end
            if setting["clear_area_ped_rot_log"] then
                log_string = log_string.." [Entity Rotation: X: "..pedrot.x.." Y: "..pedrot.y.." Z: "..pedrot.z.."]"
            end
            if setting["clear_area_ped_head_log"] then
                log_string = log_string.." [Entity Heading: "..pedhead.."]"
            end
            if setting["clear_area_ped_vis_log"] then
                if pedvis then
                    log_string = log_string.." [Entity is Visible]"
                elseif not pedvis then
                    log_string = log_string.." [Entity is Not Visible]"
                end
            end
            if setting["clear_area_ped_ent_id_dbg"] then
                dbg_string = dbg_string.." [Entity ID: "..peds[j].."]"
            end
            if setting["clear_area_ped_model_dbg"] then
                dbg_string = dbg_string.." [Entity Hash: "..pedhash.."]"
            end
            if setting["clear_area_ped_hash_dbg"] then
                dbg_string = dbg_string.." [Entity Model: "..(pedmodel or "unknown").."]"
            end
            if setting["clear_area_ped_coord_dbg"] then
                dbg_string = dbg_string.." [Entity Co-ords: X: "..pedcoord.x.." Y: "..pedcoord.y.." Z: "..pedcoord.z.."]"
            end
            if setting["clear_area_ped_rot_dbg"] then
                dbg_string = dbg_string.." [Entity Rotation: X: "..pedrot.x.." Y: "..pedrot.y.." Z: "..pedrot.z.."]"
            end
            if setting["clear_area_ped_head_dbg"] then
                dbg_string = dbg_string.." [Entity Heading: "..pedhead.."]"
            end
            if setting["clear_area_ped_vis_dbg"] then
                if pedvis then
                    dbg_string = dbg_string.." [Entity is Visible]"
                elseif not pedvis then
                    dbg_string = dbg_string.." [Entity is Not Visible]"
                end
            end
            local checkcount = 0
            network.request_control_of_entity(peds[j])
            while not network.has_control_of_entity(peds[j]) do
                system.wait(setting["clr_ped_req_ctrl_del"])
                checkcount = checkcount + 1
                if setting["clear_area_ped_dbg"] then
                    string_start = string_start.." [Request Control Attempt: "..checkcount.."]"
                    local dbg_final = string_start..dbg_string
                    dbg(dbg_final, "[Clear Peds]", "ClearAreaDebug.log")
                end
                if CheckCount > tonumber(setting["clr_ped_req_ctrl_limit"]) then
                    if setting["clear_area_ped_dbg"] then
                        string_start = string_start.." [Request Control Failed]"
                        local dbg_final = string_start..dbg_string
                        dbg(dbg_final, "[Clear Peds]", "ClearAreaDebug.log")
                    end
                break end
            end
            if setting["clear_area_ped_log"] then
                local log_final = ""..string_start..log_string..""
                log(log_final, "[Clear Peds]", "Cleanup.log")
            end
            if setting["clear_area_ped_dbg"] then
                string_start = string_start.." [Request Control Successful]"
                local dbg_final = string_start..dbg_string
                dbg(dbg_final, "[Clear Peds]", "ClearAreaDebug.log")
            end
            entity.set_entity_as_no_longer_needed(peds[j])
            entity.set_entity_coords_no_offset(peds[j], oob)
        end
    end
end
--------------------------------------
local function ClearVehicles(area)
    local vehicles = vehicle.get_all_vehicles()
    local myPed = MyPed()
    local myPos = MyPos(myPed)
    for j=1, #vehicles do
        if myVeh ~= vehicles[j] and myPos:magnitude(MyPos(vehicles[j])) <= area then
            local string_start = "[Entity Type: Vehicle]"
            local log_string = ""
            local dbg_string = ""
            local vehhash = entity.get_entity_model_hash(vehicles[j])
            local vehmodel = vehmapper.GetModelFromHash(vehhash)
            local vehcoord = entity.get_entity_coords(vehicles[j])
            local vehrot = entity.get_entity_rotation(vehicles[j])
            local vehhead = entity.get_entity_heading(vehicles[j])
            local vehvis = entity.is_entity_visible(vehicles[j])            
            if setting["clear_area_veh_ent_id_log"] then
                log_string = log_string.." [Entity ID: "..vehicles[j].."]"
            end
            if setting["clear_area_veh_model_log"] then
                log_string = log_string.." [Entity Hash: "..vehhash.."]"
            end
            if setting["clear_area_veh_hash_log"] then
                log_string = log_string.." [Entity Model: "..(vehmodel or "unknown").."]"
            end
            if setting["clear_area_veh_coord_log"] then
                log_string = log_string.." [Entity Co-ords: X: "..vehcoord.x.." Y: "..vehcoord.y.." Z: "..vehcoord.z.."]"
            end
            if setting["clear_area_veh_rot_log"] then
                log_string = log_string.." [Entity Rotation: X: "..vehrot.x.." Y: "..vehrot.y.." Z: "..vehrot.z.."]"
            end
            if setting["clear_area_veh_head_log"] then
                log_string = log_string.." [Entity Heading: "..vehhead.."]"
            end
            if setting["clear_area_veh_vis_log"] then
                if vehvis then
                    log_string = log_string.." [Entity is Visible]"
                elseif not vehvis then
                    log_string = log_string.." [Entity is Not Visible]"
                end
            end
            if setting["clear_area_veh_ent_id_dbg"] then
                dbg_string = dbg_string.." [Entity ID: "..vehicles[j].."]"
            end
            if setting["clear_area_veh_model_dbg"] then
                dbg_string = dbg_string.." [Entity Hash: "..vehhash.."]"
            end
            if setting["clear_area_veh_hash_dbg"] then
                dbg_string = dbg_string.." [Entity Model: "..(vehmodel or "unknown").."]"
            end
            if setting["clear_area_veh_coord_dbg"] then
                dbg_string = dbg_string.." [Entity Co-ords: X: "..vehcoord.x.." Y: "..vehcoord.y.." Z: "..vehcoord.z.."]"
            end
            if setting["clear_area_veh_rot_dbg"] then
                dbg_string = dbg_string.." [Entity Rotation: X: "..vehrot.x.." Y: "..vehrot.y.." Z: "..vehrot.z.."]"
            end
            if setting["clear_area_veh_head_dbg"] then
                dbg_string = dbg_string.." [Entity Heading: "..vehhead.."]"
            end
            if setting["clear_area_veh_vis_dbg"] then
                if vehvis then
                    dbg_string = dbg_string.." [Entity is Visible]"
                elseif not vehvis then
                    dbg_string = dbg_string.." [Entity is Not Visible]"
                end
            end
            local checkcount = 0
            network.request_control_of_entity(vehicles[j])
            while not network.has_control_of_entity(vehicles[j]) do
                system.wait(setting["clr_veh_req_ctrl_del"])
                checkcount = checkcount + 1
                if setting["clear_area_veh_dbg"] then
                    string_start = string_start.." [Request Control Attempt: "..checkcount.."]"
                    local dbg_final = string_start..dbg_string
                    dbg(dbg_final, "[Clear Vehicles]", "ClearAreaDebug.log")
                end
                if CheckCount > tonumber(setting["clr_veh_req_ctrl_limit"]) then
                    if setting["clear_area_veh_dbg"] then
                        string_start = string_start.." [Request Control Failed]"
                        local dbg_final = string_start..dbg_string
                        dbg(dbg_final, "[Clear Vehicles]", "ClearAreaDebug.log")
                    end
                break end
            end
            if setting["clear_area_veh_log"] then
                local log_final = ""..string_start..log_string..""
                log(log_final, "[Clear Vehicles]", "Cleanup.log")
            end
            if setting["clear_area_veh_dbg"] then
                string_start = string_start.." [Request Control Successful]"
                local dbg_final = string_start..dbg_string
                dbg(dbg_final, "[Clear Vehicles]", "ClearAreaDebug.log")
            end
            entity.set_entity_as_no_longer_needed(vehicles[j])
            entity.set_entity_coords_no_offset(vehicles[j], oob)
        end
    end
end
--------------------------------------
local function ClearPickups(area)
    local pickups = entity.get_all_pickups()
    local myPed = MyPed()
    local myPos = MyPos(myPed)
    for j=1, #pickups do
        if myPos:magnitude(MyPos(pickups[j])) <= area then
            local string_start = "[Entity Type: Pickup]"
            local log_string = ""
            local dbg_string = ""
            local pushash = entity.get_entity_model_hash(pickups[j])
            local pusmodel = objectmapper.GetModelFromHash(pushash)
            local puscoord = entity.get_entity_coords(pickups[j])
            local pusrot = entity.get_entity_rotation(pickups[j])
            local pushead = entity.get_entity_heading(pickups[j])
            local pusvis = entity.is_entity_visible(pickups[j])            
            if setting["clear_area_pus_ent_id_log"] then
                log_string = log_string.." [Entity ID: "..pickups[j].."]"
            end
            if setting["clear_area_pus_model_log"] then
                log_string = log_string.." [Entity Hash: "..pushash.."]"
            end
            if setting["clear_area_pus_hash_log"] then
                log_string = log_string.." [Entity Model: "..(pusmodel or "unknown").."]"
            end
            if setting["clear_area_pus_coord_log"] then
                log_string = log_string.." [Entity Co-ords: X: "..puscoord.x.." Y: "..puscoord.y.." Z: "..puscoord.z.."]"
            end
            if setting["clear_area_pus_rot_log"] then
                log_string = log_string.." [Entity Rotation: X: "..pusrot.x.." Y: "..pusrot.y.." Z: "..pusrot.z.."]"
            end
            if setting["clear_area_pus_head_log"] then
                log_string = log_string.." [Entity Heading: "..pushead.."]"
            end
            if setting["clear_area_pus_vis_log"] then
                if pusvis then
                    log_string = log_string.." [Entity is Visible]"
                elseif not pusvis then
                    log_string = log_string.." [Entity is Not Visible]"
                end
            end
            if setting["clear_area_pus_ent_id_dbg"] then
                dbg_string = dbg_string.." [Entity ID: "..pickups[j].."]"
            end
            if setting["clear_area_pus_model_dbg"] then
                dbg_string = dbg_string.." [Entity Hash: "..pushash.."]"
            end
            if setting["clear_area_pus_hash_dbg"] then
                dbg_string = dbg_string.." [Entity Model: "..(pusmodel or "unknown").."]"
            end
            if setting["clear_area_pus_coord_dbg"] then
                dbg_string = dbg_string.." [Entity Co-ords: X: "..puscoord.x.." Y: "..puscoord.y.." Z: "..puscoord.z.."]"
            end
            if setting["clear_area_pus_rot_dbg"] then
                dbg_string = dbg_string.." [Entity Rotation: X: "..pusrot.x.." Y: "..pusrot.y.." Z: "..pusrot.z.."]"
            end
            if setting["clear_area_pus_head_dbg"] then
                dbg_string = dbg_string.." [Entity Heading: "..pushead.."]"
            end
            if setting["clear_area_pus_vis_dbg"] then
                if pusvis then
                    dbg_string = dbg_string.." [Entity is Visible]"
                elseif not pusvis then
                    dbg_string = dbg_string.." [Entity is Not Visible]"
                end
            end
            local checkcount = 0
            network.request_control_of_entity(pickups[j])
            while not network.has_control_of_entity(pickups[j]) do
                system.wait(setting["clr_pus_req_ctrl_del"])
                checkcount = checkcount + 1
                if setting["clear_area_pus_dbg"] then
                    string_start = string_start.." [Request Control Attempt: "..checkcount.."]"
                    local dbg_final = string_start..dbg_string
                    dbg(dbg_final, "[Clear Pickups]", "ClearAreaDebug.log")
                end
                if CheckCount > tonumber(setting["clr_pus_req_ctrl_limit"]) then
                    if setting["clear_area_pus_dbg"] then
                        string_start = string_start.." [Request Control Failed]"
                        local dbg_final = string_start..dbg_string
                        dbg(dbg_final, "[Clear Pickups]", "ClearAreaDebug.log")
                    end
                break end
            end
            if setting["clear_area_pus_log"] then
                local log_final = ""..string_start..log_string..""
                log(log_final, "[Clear Pickups]", "Cleanup.log")
            end
            if setting["clear_area_pus_dbg"] then
                string_start = string_start.." [Request Control Successful]"
                local dbg_final = string_start..dbg_string
                dbg(dbg_final, "[Clear Pickups]", "ClearAreaDebug.log")
            end
            entity.set_entity_as_no_longer_needed(pickups[j])
            entity.set_entity_coords_no_offset(pickups[j], oob)
        end
    end
end
--------------------------------------
local function ClearCops(area)
    local myPed = MyPed()
    local myPos = MyPos(myPed)
    gameplay.clear_area_of_cops(myPos, area, true)
end
-------------------------------------

-------------------------------------
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
-------------------------------------
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
-------------------------------------
local clear_peds = menu.add_feature("Clear Peds", "action_value_i", clear_peds_menu, function(f)
    ui.notify_above_map("Please Wait...", script_name, 12)
    ClearPeds(f.value_i)
    ui.notify_above_map("Cleared Area of Peds", script_name, 18)
    return HANDLER_POP
end)
clear_peds.max_i = 5000000    -- max range of 5000000
clear_peds.min_i = 10         -- min range of 10
clear_peds.mod_i = 10         -- range goes up/down by 10
clear_peds.value_i = setting["clear_peds_area"]      -- default of 250
-------------------------------------
local clear_peds_toggle = menu.add_feature("Clear Peds", "value_i", clear_peds_menu, function(f)
    if not f.on then return HANDLER_POP end
    ClearPeds(f.value_i)
    system.wait(setting["clear_ped_delay"])
    return HANDLER_CONTINUE
end)
clear_peds_toggle.max_i = 5000000    -- max range of 5000000
clear_peds_toggle.min_i = 10         -- min range of 10
clear_peds_toggle.mod_i = 10         -- range goes up/down by 10
clear_peds_toggle.value_i = setting["clear_peds_area_t"]      -- default of 250
-------------------------------------
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
-------------------------------------
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
-------------------------------------
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
-------------------------------------
local clear_pickups_toggle = menu.add_feature("Clear Pickups", "value_i", clear_pickups_menu, function(f)
    if not f.on then return HANDLER_POP end
    ClearPickups(f.value_i)
    return HANDLER_CONTINUE
end)
clear_pickups_toggle.max_i = 5000000    -- max range of 5000000
clear_pickups_toggle.min_i = 10         -- min range of 10
clear_pickups_toggle.mod_i = 10         -- range goes up/down by 10
clear_pickups_toggle.value_i = setting["clear_pickups_area_t"]      -- default of 250 
-------------------------------------
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
-------------------------------------
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
-------------------------------------
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
-------------------------------------
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
-------------------------------------

-------------SETTINGS----------------
local Settings = {}
Settings[0] = menu.add_feature("clear_objects_area", "action_value_i", ca_settings_range, function(f)
    setting["clear_objects_area"] = f.value_i
    dbg("Option: clear_objects_area set to "..f.value_i, "[Settings Change]", "Debug.log")
    ui.notify_above_map("Option: clear_objects_area set to "..f.value_i, script_name, 25)
    end)
    Settings[0].max_i = 5000000    -- max range of 5000000
    Settings[0].min_i = 10         -- min range of 10
    Settings[0].mod_i = 10         -- range goes up/down by 10
    Settings[0].value_i = setting["clear_objects_area"]      -- default of 250
Settings[1] = menu.add_feature("clear_objects_area_t", "action_value_i", ca_settings_range, function(f)
    setting["clear_objects_area_t"] = f.value_i
    dbg("Option: clear_objects_area_t set to "..f.value_i, "[Settings Change]", "Debug.log")
    ui.notify_above_map("Option: clear_objects_area_t set to "..f.value_i, script_name, 25)
    end)
    Settings[1].max_i = 5000000    -- max range of 5000000
    Settings[1].min_i = 10         -- min range of 10
    Settings[1].mod_i = 10         -- range goes up/down by 10
    Settings[1].value_i = setting["clear_objects_area_t"]      -- default of 250
Settings[2] = menu.add_feature("clear_peds_area", "action_value_i", ca_settings_range, function(f)
    setting["clear_peds_area"] = f.value_i
    dbg("Option: clear_peds_area set to "..f.value_i, "[Settings Change]", "Debug.log")
    ui.notify_above_map("Option: clear_peds_area set to "..f.value_i, script_name, 25)
    end)
    Settings[2].max_i = 5000000    -- max range of 5000000
    Settings[2].min_i = 10         -- min range of 10
    Settings[2].mod_i = 10         -- range goes up/down by 10
    Settings[2].value_i = setting["clear_peds_area"]      -- default of 250
Settings[3] = menu.add_feature("clear_peds_area_t", "action_value_i", ca_settings_range, function(f)
    setting["clear_peds_area_t"] = f.value_i
    dbg("Option: clear_peds_area_t set to "..f.value_i, "[Settings Change]", "Debug.log")
    ui.notify_above_map("Option: clear_peds_area_t set to "..f.value_i, script_name, 25)
    end)
    Settings[3].max_i = 5000000    -- max range of 5000000
    Settings[3].min_i = 10         -- min range of 10
    Settings[3].mod_i = 10         -- range goes up/down by 10
    Settings[3].value_i = setting["clear_peds_area_t"]      -- default of 250
Settings[4] = menu.add_feature("clear_vehicle_area", "action_value_i", ca_settings_range, function(f)
    setting["clear_vehicle_area"] = f.value_i
    dbg("Option: clear_vehicle_area set to "..f.value_i, "[Settings Change]", "Debug.log")
    ui.notify_above_map("Option: clear_vehicle_area set to "..f.value_i, script_name, 25)
    end)
    Settings[4].max_i = 5000000
    Settings[4].min_i = 10
    Settings[4].mod_i = 10
    Settings[4].value_i = setting["clear_vehicle_area"]
Settings[5] = menu.add_feature("clear_vehicle_area_t", "action_value_i", ca_settings_range, function(f)
    setting["clear_vehicle_area_t"] = f.value_i
    dbg("Option: clear_vehicle_area_t set to "..f.value_i, "[Settings Change]", "Debug.log")
    ui.notify_above_map("Option: clear_vehicle_area_t set to "..f.value_i, script_name, 25)
    end)
    Settings[5].max_i = 5000000
    Settings[5].min_i = 10
    Settings[5].mod_i = 10
    Settings[5].value_i = setting["clear_vehicle_area_t"]

--------------------------------------
menu.add_feature("Save Settings", "action", settings_menu, function(f)
    SaveSettings()
    ui.notify_above_map("Settings Saved", script_name, 25)
    local sav_set = ("Saved Settings to Utilities.ini")
    dbg(sav_set, "[Settings Change]", "Debug.log")
end)
-------------------------------------
local dbg_sl = (script_name.." Version: "..setting["version"].." loaded successfully")
dbg(dbg_sl, "[Load Successful]", "Debug.log")
Utilities_Script = true