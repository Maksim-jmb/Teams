#include "FTL.Common.iss"

objectdef ftlSession
{
    variable ftlSettings Settings

    method Initialize()
    {
        LGUI2:LoadPackageFile[xFTL.Session.lgui2Package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[xFTL.Session.lgui2Package.json]
    }
}

variable(global) ftlSession FTLSession

function main()
{
    while 1
    {
        waitframe
    }
}
