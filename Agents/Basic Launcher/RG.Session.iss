#include "BL.Common.iss"

objectdef rgSession
{
    variable blSettings Settings

    method Initialize()
    {    
    }
}

objectdef rgTeam1
{
    method Initialize()
    {    
    }

    method JoinRelayGroup1()
    {
        uplink relaygroup -join party
        uplink relaygroup -join tank
        uplink relaygroup -join melee
        uplink relaygroup -join monk
    }
    method JoinRelayGroup2()
    {
        uplink relaygroup -join party
        uplink relaygroup -join heal
        uplink relaygroup -join ranged
        uplink relaygroup -join priest
    }
    method JoinRelayGroup3()
    {
        uplink relaygroup -join party
        uplink relaygroup -join dps
        uplink relaygroup -join ranged
        uplink relaygroup -join mage
    }
    method JoinRelayGroup4()
    {
        uplink relaygroup -join party
        uplink relaygroup -join dps
        uplink relaygroup -join ranged
        uplink relaygroup -join warlock
    }
    method JoinRelayGroup5()
    {
        uplink relaygroup -join party
        uplink relaygroup -join dps
        uplink relaygroup -join melee
        uplink relaygroup -join warrior
    }
}

objectdef rgTeam2
{
    method Initialize()
    {    
    }

    method JoinRelayGroup1()
    {
        uplink relaygroup -join party
        uplink relaygroup -join tank
        uplink relaygroup -join melee
        uplink relaygroup -join warrior
    }
    method JoinRelayGroup2()
    {
        uplink relaygroup -join party
        uplink relaygroup -join heal
        uplink relaygroup -join ranged
        uplink relaygroup -join monk
    }
    method JoinRelayGroup3()
    {
        uplink relaygroup -join party
        uplink relaygroup -join dps
        uplink relaygroup -join ranged
        uplink relaygroup -join warlock
    }
    method JoinRelayGroup4()
    {
        uplink relaygroup -join party
        uplink relaygroup -join dps
        uplink relaygroup -join ranged
        uplink relaygroup -join warlock
    }
    method JoinRelayGroup5()
    {
        uplink relaygroup -join party
        uplink relaygroup -join dps
        uplink relaygroup -join melee
        uplink relaygroup -join warlock
    }
}

variable(global) rgSession RGSession
variable(global) rgTeam1 RGTeam1
variable(global) rgTeam2 RGTeam2

function main()
{
    
    while 1
        waitframe
}
    

