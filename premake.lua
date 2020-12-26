
require("premake-modules/raspberry")

include "ispc-premake/premake.lua"

-- ------------------------------------------------------------------------------
function GetFileName(str)
  return str:match("^.+/(.+)$")
end

function GetFileNameNoExtension(str)
  return str:match("([^/]+)$")
end

function GetFileExtension(str)
  return str:match("^.+(%..+)$")
end

-- ------------------------------------------------------------------------------
function ConfigureCommonBuildSettings()

    objdir      ( "$(SolutionDir)_obj/%{cfg.shortname}/$(ProjectName)/" )
    debugdir    ( "$(OutDir)" )
    targetdir   ( "$(SolutionDir)_builds/$(Configuration)/%{cfg.platform}" )

end

function ConfigureCommonBuildFiles()

    includedirs { "src/support" }
    files {
        "src/**.cpp",
        "src/**.h",
        "src/**.inl",
        "src/**.ispc",
        "src/**.isph",
    }

end

-- ------------------------------------------------------------------------------
workspace ("Tether_" .. _ACTION)

    configurations  { "Debug", "Release", "Release-AVX2" }
    platforms       { "x86", "x86_64" }

    useISPC()

    filter "platforms:x86"
        architecture    "x86"
        system          "windows"
        defines {
           "WIN32",
           "_WINDOWS",
        }
        vectorextensions "SSE2"
        ispcVars { 
            OS              = "windows",
            Architecture    = "x86",
            CPU             = "core2",
            TargetISA       = "sse2-i32x8",
        }

    filter "platforms:x86_64"
        architecture    "x64"
        system          "windows"
        defines {
           "WIN32",
           "_WINDOWS",
        }
        vectorextensions "AVX"
        ispcVars { 
            OS              = "windows",
            Architecture    = "x64",
            CPU             = "corei7-avx",
            TargetISA       = "avx1-i32x16",
        }

    filter {}

    floatingpoint         "Fast"
    ispcVars  {
        MathLibrary     = "Fast",
    }

    filter "configurations:Debug"
        defines   { "DEBUG" }
        symbols   "On"
        ispcVars {
            GenerateDebugInformation = true,
            Opt         = "disabled"
        }

    filter "configurations:Release"
        defines   { "NDEBUG" }
        flags     { "LinkTimeOptimization" }
        optimize  "Full"
        ispcVars  {
            Opt         = "maximum",
        }

    filter "configurations:Release-AVX2"
        defines   { "NDEBUG" }
        flags     { "LinkTimeOptimization" }
        optimize  "Full"
        vectorextensions "AVX2"
        ispcVars  {
            CPU         = "core-avx2",
            TargetISA   = "avx2-i32x16",
        }

    filter {}


-- ------------------------------------------------------------------------------
project "Tether"
    kind "ConsoleApp"
    language "C++"

    ConfigureCommonBuildSettings()
    ConfigureCommonBuildFiles()


-- ------------------------------------------------------------------------------
workspace ("Tether_Raspberry_" .. _ACTION)

    configurations  { "Debug", "Release" }
    platforms       { "Pi-3", "Pi-4" }

    useISPC()

    ispcVars { 
        OS              = "linux",
        Architecture    = "arm",
        TargetISA       = "neon-i32x4",
    }

    filter "platforms:Pi-3"
        defines {
           "RPI=3",
        }
        ispcVars { 
            CPU             = "arm-cortex-a53",     -- tested on my Raspberry Pi 3 Model B+
        }

    filter "platforms:Pi-4"
        defines {
           "RPI=4",
        }
        ispcVars { 
            CPU             = "arm-cortex-a72",     -- 
        }

    filter {}

    filter "configurations:Debug"
        defines   { "DEBUG" }
        symbols   "On"
        ispcVars {
            GenerateDebugInformation = true,
            Opt         = "disabled"
        }

    filter "configurations:Release"
        defines   { "NDEBUG" }
        flags     { "LinkTimeOptimization" }
        optimize  "Full"
        ispcVars  {
            Opt         = "maximum",
            MathLibrary = "Fast",
        }

    filter {}

project "Tether_Raspberry"
    kind "ConsoleApp"
    language "C++"

    system          "raspberry"

    ConfigureCommonBuildSettings()

    -- for tasksys code
    buildoptions    { "-pthread" }
    linkoptions     { "-lpthread" }


    -- currently we have to manually inject the ISPC object files into the remote
    -- copy procedure and into the linker as the Linux VS stuff doesn't pick up
    -- the local compilation process outputs
    --
    -- this is a combination of the VS-Linux stuff not expecting something doing cross-compilation
    -- on the Windows-side and my inability to decode the nightmare realm MSBuild that might somehow fix this properly
    --
    -- THIS IS MAKING ASSUMPTIONS THAT YOUR ISPC .O OUTPUT FILES DROP IN THE DEFAULT PLACE
    --
    manualISPC = os.matchfiles("src/ispc/*.ispc")

    remoteCopyFiles = {}
    for i, ifile in ipairs(manualISPC) do
        
        -- "rt.ispc.sdf"
        justFilename = GetFileNameNoExtension(ifile)

        -- to match the `objdir` defined in ConfigureCommonBuildSettings()
        remoteObjectFile = string.format( "$(RemoteProjectDir)/_obj/%%{cfg.shortname}/$(ProjectName)/%s.o", justFilename )

        table.insert( remoteCopyFiles, string.format("$(IntDir)%s.o:=%s", justFilename, remoteObjectFile) )
        table.insert( remoteCopyFiles, string.format("$(SolutionDir)%s:=$(RemoteProjectDir)/%s", ifile, ifile) )
        linkoptions { remoteObjectFile }
    end

    additionalcopy  { remoteCopyFiles }

    ConfigureCommonBuildFiles()
