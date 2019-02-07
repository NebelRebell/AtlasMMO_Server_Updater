# ATLAS MMO - SERVERUPDATER

__WARNING__

This tool got written after midnight, so expect some spelling mistakes or even bugs...we had to defend ourselves against werewolves and others during the scripts...we will update soon ;)

## Authors

https://nebelbank.net => https://github.com/NebelRebell

https://Moonlight-Gaming.eu => https://github.com/BrutalBirdie

Idea from https://arkforum.de/thread/717-ark-windows-server-einrichten-autoupdate/

Use at your own risk! 2019

Be sure to change the Script paths.

**Programmed on request by AtlasServerWelten [Discord] (ttps://discord.gg/R3H5BEa)**
**A ATLAS MMO - Project from Impact-Gaming & Partner**


__Steamstore__
https://store.steampowered.com/app/834910/ATLAS/


__Attention!__

Don't forget to start redis before you start this AtlasServerUpdater.

I used https://nssm.cc/ to make redis a Windows Service so I don't have to deal with that "step"...


## Got no Server yet?

Well this tool would also install the server for you, but that's not the main point of this tool :)


__Steps__
1. Make Folder like "C:/Atlas"
2. Install [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD)
3. Change settings / paths 
4. Start AtlasServerUpdater
5. Ignore red messages ;) Stop the Server or it will crash.
6. Start "..\Atlas\AtlasTools\RedisDatabase\redis-server_start.bat
7. Start AtlasServerUpdate again!
