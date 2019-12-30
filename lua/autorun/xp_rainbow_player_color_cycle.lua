--[[---------------------------------------------------------
				Rainbow Player Color Cycle
					by VictorienXP (2019)
				released under MIT license
-----------------------------------------------------------]]

AddCSLuaFile()

XP_RPCC = XP_RPCC or {}
XP_RPCC.version = "0.2.0"

local xp_rpcc_enable = CreateConVar("xp_rpcc_enable", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Enable the Rainbow Player Color Cycle.")
local xp_rpcc_offset = CreateConVar("xp_rpcc_offset", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Enable an offset so that players doesn't cycle the same color.")
local xp_rpcc_default_speed = CreateConVar("xp_rpcc_default_speed", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Default cycle speed (float).")
local xp_rpcc_health_lightness = CreateConVar("xp_rpcc_health_lightness", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Should player health affect color lightness.")
local xp_rpcc_health_speed = CreateConVar("xp_rpcc_health_speed", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Should player health affect cycle speed.")
local xp_rpcc_gamemode_whitelist = CreateConVar("xp_rpcc_gamemode_whitelist", "sandbox,cinema,elevator,jazztronauts,melonbomber", {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Gamemode whitelist.")
local xp_rpcc_gamemode_blacklist = CreateConVar("xp_rpcc_gamemode_blacklist", "guesswho,hideandseek,morbusgame,murder,superpedobear,terrortown,prophunters", {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Gamemode blacklist.")
local xp_rpcc_gamemode_whitelist_only = CreateConVar("xp_rpcc_gamemode_whitelist_only", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Set if gamemodes have to be whitelisted.")
local xp_rpcc_enable_bots = CreateConVar("xp_rpcc_enable_bots", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Enable the Rainbow Player Color Cycle for bots.")

if SERVER then

	local current_gamemode = engine.ActiveGamemode()

	local function update_gamemode_whitelist(str)
		XP_RPCC.gamemode_whitelist = string.Explode(",", str)
		XP_RPCC.gamemode_whitelisted = table.HasValue(XP_RPCC.gamemode_whitelist, current_gamemode)
	end
	update_gamemode_whitelist(xp_rpcc_gamemode_whitelist:GetString())

	local function update_gamemode_blacklist(str)
		XP_RPCC.gamemode_blacklist = string.Explode(",", str)
		XP_RPCC.gamemode_blacklisted = table.HasValue(XP_RPCC.gamemode_blacklist, current_gamemode)
	end
	update_gamemode_blacklist(xp_rpcc_gamemode_blacklist:GetString())

	cvars.AddChangeCallback("xp_rpcc_gamemode_whitelist", function(convar, oldvalue, newvalue)
		update_gamemode_whitelist(newvalue)
	end)

	cvars.AddChangeCallback("xp_rpcc_gamemode_blacklist", function(convar, oldvalue, newvalue)
		update_gamemode_blacklist(newvalue)
	end)

	function XP_RPCC:Think()

		if xp_rpcc_enable:GetBool() and !XP_RPCC.gamemode_blacklisted and (XP_RPCC.gamemode_whitelisted or !xp_rpcc_gamemode_whitelist_only:GetBool()) then

			local default_speed = xp_rpcc_default_speed:GetFloat()
			local do_health_lightness = xp_rpcc_health_lightness:GetBool()
			local do_health_speed = xp_rpcc_health_speed:GetBool()
			local do_offset = xp_rpcc_offset:GetBool()
			local time = CurTime()

			for k, v in pairs(player.GetAll()) do

				local is_bot = xp_rpcc_enable_bots:GetBool() and v:IsBot()
				local player_color_enabled = (v:GetInfoNum("xp_rpcc_cl_enable", 1) == 1 or is_bot)
				local physgun_color_enabled = (v:GetInfoNum("xp_rpcc_cl_physgun", 1) == 1 or is_bot)
				local do_not_cycle = v:GetInfoNum("xp_rpcc_cl_disable_cycle", 0) == 1

				if player_color_enabled or physgun_color_enabled then

					local player_health_lightness = do_health_lightness and (v:GetInfoNum("xp_rpcc_cl_health_lightness", 1) == 1 or is_bot)
					local player_health_speed = do_health_speed and (v:GetInfoNum("xp_rpcc_cl_health_speed", 1) == 1 or is_bot)

					local health = v:Health()
					local lightness = player_health_lightness and (math.Clamp(health, 0, 100) / 100) or 1
					local speed = player_health_speed and (health / 100) or default_speed
					local offset = do_offset and v:EntIndex() or 0

					local base_value = do_not_cycle and v:Deaths() or time * speed + offset

					local r = ( 0.5 * (math.sin(base_value - 1) + 1) ) * lightness
					local g = ( 0.5 * (math.sin(base_value) + 1) ) * lightness
					local b = ( 0.5 * (math.sin(base_value + 1) + 1) ) * lightness

					if player_color_enabled then
						v:SetPlayerColor( Vector(r, g, b) )
					end

					if physgun_color_enabled then
						v:SetWeaponColor( Vector(r, g, b) )
					end

				end

			end

		end

	end

	hook.Add("Think", "XP_RPCC_Think", XP_RPCC.Think)

end

if CLIENT then

	CreateClientConVar("xp_rpcc_cl_enable", 1, true, true, "Enable the Rainbow Player Color Cycle for yourself.")
	CreateClientConVar("xp_rpcc_cl_physgun", 1, true, true, "Enable the rainbow color cycle for your physgun and other compatible weapons.")
	CreateClientConVar("xp_rpcc_cl_health_lightness", 1, true, true, "Should your health affect color lightness (this can be disabled by the server).")
	CreateClientConVar("xp_rpcc_cl_health_speed", 1, true, true, "Should your health affect color cycle speed (this can be disabled by the server).")
	CreateClientConVar("xp_rpcc_cl_disable_cycle", 0, true, true, "If you wish to only have one static random color upon respawn.")

	concommand.Add("xp_rpcc_cl_open_github_page", function(ply, cmd, args)
		gui.OpenURL("https://github.com/VictorienXP/Rainbow-Player-Color-Cycle")
	end)
	concommand.Add("xp_rpcc_cl_open_workshop_page", function(ply, cmd, args)
		gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1949419667")
	end)

	hook.Add("PopulateToolMenu", "XP_RPCC_MenuSettings", function()
		spawnmenu.AddToolMenuOption("Options", "Player", "XP_RPCC", "Rainbow Player Color Cycle", "", "", function(panel)
			panel:ClearControls()
			panel:Help("Welcome to the Rainbow Player Color Cycle settings.")
			panel:Help("This addon gives you a rainbow color cycle on your player color.")
			panel:Help("You are on version " .. XP_RPCC.version)
			panel:CheckBox("Enable for your player color", "xp_rpcc_cl_enable")
			panel:ControlHelp("Enable the rainbow color cycle for your player color.")
			panel:CheckBox("Enable for your physgun", "xp_rpcc_cl_physgun")
			panel:ControlHelp("Enable the rainbow color cycle for your physgun and other compatible weapons.")
			panel:CheckBox("Enable health color lightness", "xp_rpcc_cl_health_lightness")
			panel:ControlHelp("Should your health affect color lightness (this can be disabled by the server).")
			panel:CheckBox("Enable health color speed", "xp_rpcc_cl_health_speed")
			panel:ControlHelp("Should your health affect color cycle speed (this can be disabled by the server).")
			panel:CheckBox("Disable constant color cycle", "xp_rpcc_cl_disable_cycle")
			panel:ControlHelp("If you wish to only have one static random color upon respawn.")
			panel:Button("GitHub repo", "xp_rpcc_cl_open_github_page")
			panel:Button("Workshop page", "xp_rpcc_cl_open_workshop_page")
		end)
	end)

end

print("XP_RPCC v" .. XP_RPCC.version .. " loaded!" .. Either(SERVER, " (SV)", " (CL)"))
