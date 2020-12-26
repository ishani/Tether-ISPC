--
-- Raspberry Pi ARM target in Visual Studio for premake5
-- harry denholm 2020, ishani.org / github.com/ishani
--

local p = premake

if not p.modules.raspberry then

    include ( "_preload.lua" )

    require ("vstudio")
    p.modules.raspberry = {}

    function isRaspberryPi(cfg)
        return ( cfg.system == premake.Raspberry )
    end
    
    include("raspberry_vcxproj.lua")
    include("raspberry_vstudio.lua")

end

return p.modules.raspberry