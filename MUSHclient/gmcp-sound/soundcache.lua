
-- soundcache.lua
-- by myonara@unitopia
-- Version 1.0
-- 08.Feb.2018

-- If-Modified-Since: 
-- <day-name>, <day> <month> <year> <hour>:<minute>:<second> GMT
-- e.g.: Thu, 08 Feb 2018 19:40:37 GMT


function createLocalSoundDb(mudname,base_url)
    localSoundDB = GetInfo (74) .. mudname .. "_soundcache.sqlite"
    localURL = base_url.."/"
    local localDB = sqlite3.open(localSoundDB)
    DatabaseOpen ("db",   -- database ID
              localSoundDB,
              6)      -- flags
    localDB:exec( [[
        CREATE TABLE IF NOT EXISTS soundcache (
        filename TEXT PRIMARY KEY,  -- access path
        ISOtime TEXT, -- time format for If-Modified-Since
        wav BLOB )    -- the content.
        ]] )
    localDB:close()  -- close it
end -- function

function playFromCacheOrServer(filename)
    local localDB = sqlite3.open(localSoundDB)
    local http = require("socket.http")
    local body,code,he,so,rc
    local isotime = os.date("!%a, %d %b %Y %H:%M:%S GMT")
    local modtime, dberr 
    local stat = localDB:prepare(
        "SELECT ISOtime FROM soundcache WHERE filename = ?")
    local rc
    rc = stat:bind(1,filename)
    if rc == sqlite3.OK then
        rc = stat:step()
        if  rc == sqlite3.ROW then
            modtime = stat:get_value(0)
            stat:finalize()
        elseif rc == sqlite3.DONE then
            modtime = nil
            stat:finalize()
        else
            dberr = rc.."["..localDB:errcode().."]: "..localDB:errmsg()
            stat:finalize()
            localDB:close()
            return false,dberr
        end
    else -- bind
        dberr = localDB:errcode()..": "..localDB:errmsg()
        stat:finalize()
        localDB:close()
        return false,dberr
    end -- if sql ok.
    
    
    if modtime == nil then
        body,code,he,so = http.request(localURL..filename)
        modtime = 'nil'
        if (code == 200) then isotime = he["last-modified"] end
    else
        local header = { }
        header["If-Modified-Since"] = modtime 
        body,code,he,so = http.request{
            url= localURL..filename,
            headers = header
            }
        if (code == 200) then isotime = he["last-modified"] end
    end -- if nil
    -- Note (isotime.."#"..modtime.."#"..code) -- for debugging.
    if code == 304 then -- HTTP 304 Not modified
        stat = localDB:prepare(
            "SELECT wav FROM soundcache WHERE filename = ?")  --> returns 0 (sqlite3.OK)
        stat:bind(1,filename)
        stat:step()
        body = stat:get_value(0)
        stat:finalize()
        localDB:close()  -- close it
    elseif code == 200 then -- HTTP 200 with body.
        stat = localDB:prepare(
            "INSERT OR REPLACE INTO soundcache (filename,ISOtime,wav) "..
            "VALUES (?,?,?)")
        stat:bind(1,filename)
        stat:bind(2,isotime)
        stat:bind_blob(3,body)
        rc = stat:step()
        if rc == sqlite3.DONE then
            stat:finalize()
            localDB:close()  -- close it
        else
            dberr = rc.."["..localDB:errcode().."]: "..localDB:errmsg()
            stat:finalize()
            localDB:close()
            return false,dberr
        end -- if done
    elseif code == 404 then -- HTTP 404 not existent
        stat = localDB:prepare(
            "DELETE FROM soundcache WHERE filename = ?") 
        stat:bind(1,filename)
        rc = stat:step()
        if rc == sqlite3.DONE then
            stat:finalize()
            localDB:close()
            return true
        else
            dberr = rc.."["..localDB:errcode().."]: "..localDB:errmsg()
            stat:finalize()
            localDB:close()
            return false,dberr
        end -- if done
    else
        dberr = "HTTP-code:"..code..": "..filename
        localDB:close()  -- close it
        return false,dberr
    end -- if code
    
    local ret = PlaySoundMemory (1, body, false, 0, 0)
    if ret == 0 then
        return true
    else
        dberr = "sound-ret:"..ret..": "..filename
        return false, dberr
    end -- if.
end -- function playFromCacheOrServer
