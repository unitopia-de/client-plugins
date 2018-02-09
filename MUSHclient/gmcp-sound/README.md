# Purpose

This plugin for MushClient plays sound as it is triggered by UNItopia via GMCP.
The sound files are fetched from the UNItopia web server on first use and will
saved locally in a sqlite database.

# Installation instruction
- copy the two lua files ([gmcphelper.lua](gmcphelper.lua) and [soundcache.lua](soundcache.lua)) within the lua directory of Mushclient.
- copy the plugin [U_GMCP_sound.xml](U_GMCP_sound.xml) into worlds/plugins of Mushclient.
- for all UNItopia-worlds use File->Plugins to add the plugin.

Tested with Mushclient 4.94

---

# Verwendungszweck

Das Plugin für MushClient spielt Sound ab, so wie er von UNItopia via GMCP signalisiert wird.
Die Töne werden beim ersten Abspielen vom UNItopia-Webserver heruntergeladen und lokal in einer SQLite Datenbank gespeichert.


# Installationsanweisung
- Beide lua-Dateien ([gmcphelper.lua](gmcphelper.lua) und [soundcache.lua](soundcache.lua)) sind im lua-Unterpfad vom MushClient zu kopieren.
- Kopiere [U_GMCP_sound.xml](U_GMCP_sound.xml) in den worlds/plugins Unterpfad von Mushclient.
- Für alle UNItopia-Welten das File->plugins nutzen, um das U_GMCP_sound-Plugin hinzuzufuegen.

Getestet für Mushclient 4.94
