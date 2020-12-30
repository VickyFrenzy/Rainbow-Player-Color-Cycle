# Rainbow Player Color Cycle (RGB)

[![Steam Views](https://img.shields.io/steam/views/1949419667?logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=1949419667)
[![Steam Subscriptions](https://img.shields.io/steam/subscriptions/1949419667?logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=1949419667)
[![Steam Downloads](https://img.shields.io/steam/downloads/1949419667?logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=1949419667)
[![Steam Favorites](https://img.shields.io/steam/favorites/1949419667?logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=1949419667)
[![Steam File Size](https://img.shields.io/steam/size/1949419667?logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=1949419667)

Gives an RGB rainbow color cycle to players. Also work on physgun color!

---

Client cvars list:
* **xp_rpcc_cl_enable**: Enable the rainbow color cycle for yourself (bool).  Default: 1
* **xp_rpcc_cl_physgun**: Enable the rainbow color cycle for your physgun and other compatible weapons (bool).  Default: 1
* **xp_rpcc_cl_health_lightness**: Should your health affect color lightness (this can be disabled by the server) (bool).  Default: 1
* **xp_rpcc_cl_health_speed**: Should your health affect color cycle speed (this can be disabled by the server) (bool).  Default: 1
* **xp_rpcc_cl_disable_cycle**: If you wish to only have one static random color upon respawn (bool).  Default: 0

---

Server cvars list:
* **xp_rpcc_enable**: Enable/disable the Rainbow Player Color Cycle (bool). Default: 1
* **xp_rpcc_offset**: Enable/disable an offset so that players doesn't cycle the same color (bool). Default: 1
* **xp_rpcc_default_speed**: Default cycle speed (float). Default: 1
* **xp_rpcc_health_lightness**: Should player health affect color lightness (bool). Default: 1
* **xp_rpcc_health_speed**: Should player health affect cycle speed (bool). Default: 1
* **xp_rpcc_gamemode_whitelist**: Gamemode whitelist (string). Default: "sandbox,cinema,elevator,jazztronauts"
* **xp_rpcc_gamemode_blacklist**: Gamemode blacklist (string). Default: "guesswho,hideandseek,morbusgame,murder,superpedobear,terrortown,prophunters,supercookingpanic"
* **xp_rpcc_gamemode_whitelist_only**: Set if gamemodes have to be whitelisted (bool). Default: 1
* **xp_rpcc_enable_bots**: Enable the Rainbow Player Color Cycle for bots (bool). Default: 1
