# Verwendungszweck

Das Plugin für MushClient spielt Sound ab, so wie er von UNItopia via GMCP signalisiert wird.
Die Töne werden beim ersten Abspielen vom UNItopia-Webserver heruntergeladen und lokal in einer SQLite Datenbank gespeichert.


# Installationsanweisung
- Alle drei Dateien sind bei derAnzeige in github auf RAW (rechts über der Datei) zu klicken und dann erst zu speichen!
- Beide lua-Dateien ([gmcphelper.lua](gmcphelper.lua) und [soundcache.lua](soundcache.lua)) sind im lua-Unterpfad vom MushClient zu kopieren.
- Kopiere [U_GMCP_sound.xml](U_GMCP_sound.xml) in den worlds/plugins Unterpfad von Mushclient.
- Sicherstellen, dass es ein sounds Verzeichnis im MushClient-Hauptverzeichnis gibt.
- Für alle UNItopia-Welten das File->plugins nutzen, um das U_GMCP_sound-Plugin hinzuzufuegen.
- Aus- und Einloggen, um die Funktionen zu aktivieren.

Getestet für Mushclient 4.94 und 4.61

---

# Purpose

This plugin for MushClient plays sound as it is triggered by UNItopia via GMCP.
The sound files are fetched from the UNItopia web server on first use and will
saved locally in a sqlite database.

# Installation instruction
- For all three files only save the RAW file (mouseclick on the RAW button on the right above the file, then save).
- copy the two lua files ([gmcphelper.lua](gmcphelper.lua) and [soundcache.lua](soundcache.lua)) within the lua directory of Mushclient.
- copy the plugin [U_GMCP_sound.xml](U_GMCP_sound.xml) into worlds/plugins of Mushclient.
- Create a sounds subdirectory in the MushClient main directory, if not existing.
- for all UNItopia-worlds use File->Plugins to add the plugin.
- Please logout and login to activate the full functionality after plugin install.

Tested with Mushclient 4.94 and 4.61 
