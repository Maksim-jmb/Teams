#include "FTL.Common.iss"

objectdef ftlUplink
{
    variable ftlSettings Settings

    method Initialize()
    {
    }

    method Shutdown()
    {
    }
}

variable(global) ftlUplink FTLUplink

function main()
{
    while 1
    {
        waitframe
    }
}
