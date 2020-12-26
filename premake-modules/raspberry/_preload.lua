--
-- Raspberry Pi ARM target in Visual Studio for premake5
-- harry denholm 2020, ishani.org / github.com/ishani
--

local p = premake
local api = p.api

p.Raspberry = "raspberry"

api.addAllowed("system", p.Raspberry)
os.systemTags[p.Raspberry] = { "raspberry" }

-- list of files to copy remotely pre-build, in the format
-- <local_filename>:=<remote_filename>
api.register {
    name = "additionalcopy",
    scope = "config",
    kind = "list:string",
    tokens = true,
}

-- force ARM on by default
filter { "system:raspberry" }
    architecture    "ARM"
    defines {
        "_RASPBERRY_PI",
     }
filter {}


return function(cfg)
    return (cfg.system == p.Raspberry)
end