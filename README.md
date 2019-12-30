# Rainbow-Player-Color-Cycle
Gives a rainbow color cycle to players.

---

Client cvars list:
* **xp_rpcc_cl_enable**: Enable the rainbow color cycle for yourself (bool).  Default: 1
* **xp_rpcc_cl_physgun**: Enable the rainbow color cycle for your physgun and other compatible weapons (bool).  Default: 1
* **xp_rpcc_cl_health_lightness**: Should your health affect color lightness (this can be disabled by the server) (bool).  Default: 1
* **xp_rpcc_cl_health_speed**: Should your health affect color cycle speed (this can be disabled by the server) (bool).  Default: 1
* **xp_rpcc_cl_disable_cycle**: If you wish to only have one static random color upon respawn (this can be disabled by the server) (bool).  Default: 0

---

Server cvars list:
* **xp_rpcc_enable**: Enable/disable the Rainbow Player Color Cycle (bool). Default: 1
* **xp_rpcc_offset**: Enable/disable an offset so that players doesn't cycle the same color (bool). Default: 1
* **xp_rpcc_default_speed**: Default cycle speed (float). Default: 1
* **xp_rpcc_health_lightness**: Should player health affect color lightness (bool). Default: 1
* **xp_rpcc_health_speed**: Should player health affect cycle speed (bool). Default: 1
* **xp_rpcc_gamemode_whitelist**: Gamemode whitelist (string). Default: "sandbox,cinema,elevator,jazztronauts,melonbomber"
* **xp_rpcc_gamemode_blacklist**: Gamemode blacklist (string). Default: "guesswho,hideandseek,morbusgame,murder,superpedobear,terrortown,prophunters"
* **xp_rpcc_gamemode_whitelist_only**: Set if gamemodes have to be whitelisted (bool). Default: 1
* **xp_rpcc_enable_bots**: Enable the Rainbow Player Color Cycle for bots (bool). Default: 1
