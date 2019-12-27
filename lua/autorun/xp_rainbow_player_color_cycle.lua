--[[---------------------------------------------------------
				Rainbow Player Color Cycle
					by VictorienXP (2019)
				released under MIT license
-----------------------------------------------------------]]

AddCSLuaFile()

XP_RPCC = XP_RPCC or {}
XP_RPCC.version = "0.1.0"

local xp_rpcc_enable = CreateConVar("xp_rpcc_enable", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Enable the Rainbow Player Color Cycle.")
local xp_rpcc_offset = CreateConVar("xp_rpcc_offset", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Enable an offset so that players doesn't cycle the same color.")
local xp_rpcc_default_speed = CreateConVar("xp_rpcc_default_speed", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Default cycle speed (float).")
local xp_rpcc_health_lightness = CreateConVar("xp_rpcc_health_lightness", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Should player health affect color lightness.")
local xp_rpcc_health_speed = CreateConVar("xp_rpcc_health_speed", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Should player health affect cycle speed.")
local xp_rpcc_gamemode_whitelist = CreateConVar("xp_rpcc_gamemode_whitelist", "sandbox,cinema,elevator,jazztronauts,melonbomber", {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Gamemode whitelist.")
local xp_rpcc_gamemode_blacklist = CreateConVar("xp_rpcc_gamemode_blacklist", "guesswho,hideandseek,morbusgame,murder,superpedobear,terrortown,prophunters", {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Gamemode blacklist.")
local xp_rpcc_gamemode_whitelist_only = CreateConVar("xp_rpcc_gamemode_whitelist_only", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Set if gamemodes have to be whitelisted.")

if SERVER then

	local current_gamemode = engine.ActiveGamemode()

	XP_RPCC.gamemode_whitelist = string.Explode(",", xp_rpcc_gamemode_whitelist:GetString())
	XP_RPCC.gamemode_blacklist = string.Explode(",", xp_rpcc_gamemode_blacklist:GetString())

	cvars.AddChangeCallback("xp_rpcc_gamemode_whitelist", function(convar, oldvalue, newvalue)
		XP_RPCC.gamemode_whitelist = string.Explode(",", newvalue)
	end)

	cvars.AddChangeCallback("xp_rpcc_gamemode_blacklist", function(convar, oldvalue, newvalue)
		XP_RPCC.gamemode_blacklist = string.Explode(",", newvalue)
	end)

	function XP_RPCC:Think()

		if xp_rpcc_enable:GetBool() and !table.HasValue(XP_RPCC.gamemode_blacklist, current_gamemode) and (table.HasValue(XP_RPCC.gamemode_whitelist, current_gamemode) or !xp_rpcc_gamemode_whitelist_only:GetBool()) then

			for k, v in pairs(player.GetAll()) do

				if v:GetInfoNum("xp_rpcc_cl_enable", 1) == 1 then

					local health = v:Health()
					local lightness = xp_rpcc_health_lightness:GetBool() and (math.Clamp(health, 0, 100) / 100) or 1
					local speed = xp_rpcc_health_speed:GetBool() and (health / 100) or xp_rpcc_default_speed:GetFloat()
					local offset = xp_rpcc_offset:GetBool() and v:EntIndex() or 0

					local base_value = CurTime() * speed + offset

					local r = ( 0.5 * (math.sin(base_value - 1) + 1) ) * lightness
					local g = ( 0.5 * (math.sin(base_value) + 1) ) * lightness
					local b = ( 0.5 * (math.sin(base_value + 1) + 1) ) * lightness

					v:SetPlayerColor( Vector(r, g, b) )

				end

			end

		end

	end

	hook.Add("Think", "XP_RPCC_Think", XP_RPCC.Think)

end

if CLIENT then

	CreateClientConVar("xp_rpcc_cl_enable", 1, true, true, "Enable the Rainbow Player Color Cycle for yourself.")

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
			panel:CheckBox("Enable", "xp_rpcc_cl_enable")
			panel:ControlHelp("Enable the rainbow color cycle for yourself.")
			panel:Button("GitHub repo", "xp_rpcc_cl_open_github_page")
			panel:Button("Workshop page", "xp_rpcc_cl_open_workshop_page")
		end)
	end)

end

print("XP_RPCC v" .. XP_RPCC.version .. " loaded!" .. Either(SERVER, " (SV)", " (CL)"))
