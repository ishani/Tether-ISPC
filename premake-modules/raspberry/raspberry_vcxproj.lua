--
-- Raspberry Pi ARM target in Visual Studio for premake5
-- harry denholm 2020, ishani.org / github.com/ishani
--

-- portions adapted from https://github.com/LORgames/premake-vslinux, Copyright (c) 2013-2015 Samuel Surtees

local p = premake

local raspberry = p.modules.raspberry
local vstudio = p.vstudio
local vc2010 = vstudio.vc2010
local project = p.project
local config = p.config

-- -----------------------------------------------------------------------------------
-- rewrite the globals section to have the magic Raspberry configuration VS uses

function raspberry.applicationType(cfg)
	vc2010.element("ApplicationType", nil, "Linux")
end

function raspberry.applicationTypeRevision(cfg)
	vc2010.element("ApplicationTypeRevision", nil, "1.0")
end

function raspberry.targetLinuxPlatform(cfg)
	vc2010.element("TargetLinuxPlatform", nil, "Raspberry")
end

function raspberry.targetLinuxProjectType(cfg)
	vc2010.element("LinuxProjectType", nil, "{8748239F-558C-44D1-944B-07B09C35B330}")
end

function raspberry.minimumVisualStudioVersion(cfg)
	vc2010.element("MinimumVisualStudioVersion", nil, "15.0")
end

p.override(vc2010.elements, "globals", function(oldfn, cfg)
	local elements = oldfn(cfg)
	if isRaspberryPi(cfg) then
		elements = table.join(elements, {
			raspberry.applicationType,
			raspberry.applicationTypeRevision,
			raspberry.targetLinuxPlatform,
			raspberry.targetLinuxProjectType,
			raspberry.minimumVisualStudioVersion,
		});
	end
	return elements
end)

p.override(vc2010, "keyword", function(oldfn, cfg)
    if isRaspberryPi(cfg) then
        vc2010.element("Keyword", nil, "Linux")
        vc2010.element("RootNamespace", nil, "%s", cfg.name)
    else
        oldfn(cfg)
    end
end)


-- -----------------------------------------------------------------------------------

p.override(vc2010, "debugInformationFormat", function(oldfn, cfg)
    if isRaspberryPi(cfg) then
        if cfg.symbols == p.OFF then
            vc2010.element("DebugInformationFormat", nil, "None")
        elseif cfg.symbols == p.ON then
            vc2010.element("DebugInformationFormat", nil, "FullDebug")
        end
    else
        oldfn(cfg)
    end
end)


-- -----------------------------------------------------------------------------------
-- disable or force entries that are not useful / valid for Raspberry Pi 

p.override(vc2010, "warningLevel", function(oldfn, cfg)
        if not isRaspberryPi(cfg) then
            oldfn(cfg)
        else
            vc2010.element("warningLevel", nil, "")
        end
    end)

p.override(vc2010, "characterSet", function(oldfn, cfg)
        if not isRaspberryPi(cfg) then
            oldfn(cfg)
        end
    end)

p.override(vc2010, "platformToolset", function(oldfn, cfg)
        if not isRaspberryPi(cfg) then
            oldfn(cfg)
        else
            vc2010.element("PlatformToolset", nil, "Remote_Clang_1_0")
        end
    end)

p.override(vc2010, "localDebuggerWorkingDirectory", function(oldfn, cfg)
        if not isRaspberryPi(cfg) then
            oldfn(cfg)
        end
    end)

p.override(vc2010, "subSystem", function(oldfn, cfg)
        if not isRaspberryPi(cfg) then
            return oldfn(cfg)
        end
    end)

p.override(vc2010, "targetExt", function(oldfn, cfg)
        if not isRaspberryPi(cfg) then
            return oldfn(cfg)
        else
            local addToCopy = table.implode(cfg.additionalcopy, "", "", ";") .. ";$(AdditionalSourcesToCopyMapping)"
            vc2010.element("AdditionalSourcesToCopyMapping", nil, addToCopy)
        end
    end)


p.override(vc2010, "debuggerFlavor", function(oldfn, cfg)
        if not isRaspberryPi(cfg) then
            oldfn(cfg)
        else
            p.w('<DebuggerFlavor>LinuxDebugger</DebuggerFlavor>')
        end
    end)


