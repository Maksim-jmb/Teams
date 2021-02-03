

objectdef blSettings
{
   variable filepath GlobalFolder="${LavishScript.HomeDirectory}"
    
    variable uint UseLaunchSlots=3
    variable uint UseLaunchdxNSlots=1
    variable string UseGame
    variable string UsedxNothing
    variable string UseLayout
    variable string UseTeam
    variable string UseAgents
    variable string UseLayouts
    variable string UseTeams

    variable blTeam1 Team1
    variable blTeam2 Team2
    variable blTeam3 Team3
    variable blTeam4 Team4
    variable blTeam5 Team5
    variable blTeam6 Team6
    variable weakref CurrentTeam

    method Initialize()
    {    
        This:Load
        This:LoadSettings
    }

    method Load()
    {
        variable jsonvalue jo
        declare ULSfix uint global
        declare ULSfix2 uint global
        declare ULSfix3 uint global

        if !${GlobalFolder.FileExists[\\Configuration\\Settings\\bl.Settings.json]}
            return

        if !${jo:ParseFile["${GlobalFolder~}/Configuration/Settings/bl.Settings.json"](exists)} || !${jo.Type.Equal[object]}
        {
            return
        }
        if ${jo.Has[launchSlots]}
            UseLaunchSlots:Set["${jo.Get[launchSlots]~}"]
        if ${jo.Has[lsFix]}
            ULSfix:Set["(${UseLaunchSlots}+2)"]
        if ${jo.Has[lsFix2]}
            ULSfix2:Set["(${UseLaunchSlots}+1)"]
        if ${jo.Has[lsFix3]}
            ULSfix3:Set["${UseLaunchSlots}"]
        if ${jo.Has[launchdxNSlots]}
            UseLaunchdxNSlots:Set["${jo.Get[launchdxNSlots]~}"]
        if ${jo.Has[useGame]}
            UseGame:Set["${jo.Get[useGame]~}"]
        if ${jo.Has[usedxNothing]}
            UsedxNothing:Set["${jo.Get[usedxNothing]~}"]
        ; if ${jo.Has[uselayout]}
        ;     UseLayout:Set["${jo.Get[uselayout]~}"]
        if ${jo.Has[useteam]}
            UseTeam:Set["${jo.Get[useteam]~}"]
        if ${jo.Has[agents]}
            UseAgents:Set["${jo.Get[agents]~}"]
        if ${jo.Has[layouts]}
            UseLayouts:Set["${jo.Get[layouts]~}"]
        if ${jo.Has[teams]}
            UseTeams:Set["${jo.Get[teams]~}"]
    }

    method LoadSettings()
    {
        variable jsonvalue jo

        if !${GlobalFolder.FileExists[\\Configuration\\Settings\\settings.json]}
        {
            jo:SetValue["$$>
            {
                "launchSlots":3,
                "LaunchdxNSlots":1,
                "useGame":"WoW Retail",
                "usedxNothing":"dxNothing",
                "uselayout":"Horizontal",
                "agents": [
                    {
                    "name":"Basic Global Hotkeys"
                    },
                    {
                    "name":"Basic Performance"
                    },
                    {
                    "name":"Basic Round-Robin"
                    },
                    {
                    "name":"Basic Window Layout"
                    },
                    {
                    "name":"Reload"
                    }
                ],
                "layouts": [
                    {
                    "layout":"Horizontal"
                    },
                    {
                    "layout":"Vertical"
                    },
                    {
                    "layout":"Custom"
                    },
                    {
                    "layout":"Vfx3"
                    },
                    {
                    "layout":"Vfx4"
                    },
                    {
                    "layout":"Vfx5"
                    }
                ],
                "teams": [
                    {
                    "team":"Team1"
                    },
                    {
                    "team":"Team2"
                    },
                    {
                    "team":"Team3"
                    },
                    {
                    "team":"Team4"
                    },
                    {
                    "team":"Team5"
                    }
                ]
            }
            <$$"]
            jo:WriteFile["${GlobalFolder~}/Configuration/Settings/settings.json",multiline]
            This:ResetGlobalSettings
        }
    }

    method Store()
    {
        variable jsonvalue jo
        jo:SetValue["${This.AsJSON~}"]
        jo:WriteFile["${GlobalFolder~}/Configuration/Settings/bl.Settings.json",multiline]
    }

    member AsJSON()
    {
        variable jsonvalue jo

        ULSfix:Set["(${UseLaunchSlots}+2)"]
        ULSfix2:Set["(${UseLaunchSlots}+1)"]
        ULSfix3:Set["${UseLaunchSlots}"]

        jo:SetValue["$$>
        {
            "launchSlots":${UseLaunchSlots.AsJSON~},
            "lsFix":${ULSfix.AsJSON~},
            "lsFix2":${ULSfix2.AsJSON~},
            "lsFix3":${ULSfix3.AsJSON~},
            "launchdxNSlots":${UseLaunchdxNSlots.AsJSON~},
            "useGame":${UseGame.AsJSON~},
            "usedxNothing":${UsedxNothing.AsJSON~},
            "uselayout":${BWLUplink.Settings.UseLayout.AsJSON~},
            "useteam":${UseTeam.AsJSON~},
            "agents":${UseAgents},
            "layouts":${UseLayouts},
            "teams":${UseTeams}
        }
        <$$"]
        return "${jo.AsJSON~}"
    }

    method ResetGlobalSettings()
    {
        variable jsonvalue jo
        if ${GlobalFolder.FileExists[jmb.GlobalSettings.json]}
        {
            jo:SetValue["$$>
            {
                "$schema":"http://www.lavishsoft.com/schema/jmb/jmb.json#/globalSettings",
            }
            <$$"]
            jo:WriteFile["${GlobalFolder~}/jmb.GlobalSettings.json",multiline]
        }
    }

    method ViewAgents(string newValue)
    {
        switch ${newValue}
        {
            case Basic Global Hotkeys
                LGUI2.Element[bwl.window]:SetVisibility[hidden]
                LGUI2.Element[brr.window]:SetVisibility[hidden]
                LGUI2.Element[bp.window]:SetVisibility[hidden]
                LGUI2.Element[bgh.window]:SetVisibility[visible]
                break
            case Basic Performance
                LGUI2.Element[bwl.window]:SetVisibility[hidden]
                LGUI2.Element[brr.window]:SetVisibility[hidden]
                LGUI2.Element[bgh.window]:SetVisibility[hidden]
                LGUI2.Element[bp.window]:SetVisibility[visible]
                break
            case Basic Round-Robin
                LGUI2.Element[bwl.window]:SetVisibility[hidden]
                LGUI2.Element[bp.window]:SetVisibility[hidden]
                LGUI2.Element[bgh.window]:SetVisibility[hidden]
                LGUI2.Element[brr.window]:SetVisibility[visible]
                break
            case Basic Window Layout
                LGUI2.Element[brr.window]:SetVisibility[hidden]
                LGUI2.Element[bp.window]:SetVisibility[hidden]
                LGUI2.Element[bgh.window]:SetVisibility[hidden]
                LGUI2.Element[bwl.window]:SetVisibility[visible]
                break
            default
            case Reload
                BGHUplink:Initialize
                BPUplink:Initialize
                BRRUplink:Initialize
                BWLUplink:Initialize
                LGUI2.Element[bgh.window]:SetVisibility[hidden]
                LGUI2.Element[bp.window]:SetVisibility[hidden]
                LGUI2.Element[brr.window]:SetVisibility[hidden]
                LGUI2.Element[bwl.window]:SetVisibility[hidden]
                break
        }
    }

    method HideUI()
    {
        LGUI2.Element[brr.window]:SetVisibility[hidden]
    }

    method AllFullScreen()
    {
        relay all "WindowCharacteristics -pos -viewable ${Display.Monitor.Left},${Display.Monitor.Top} -size -viewable ${Display.Monitor.Width}x${Display.Monitor.Height} -frame none"
    }

    method ShowConsoles()
    {
        relay all "LGUI2.Element[consoleWindow]:SetVisibility[Visible]"
    }

    method HideConsoles()
    {
        relay all "LGUI2.Element[consoleWindow]:SetVisibility[Hidden]"
    }

    method HideAgent()
    {
        LGUI2.Element[bgh.window]:SetVisibility[hidden]
        LGUI2.Element[bp.window]:SetVisibility[hidden]
        LGUI2.Element[brr.window]:SetVisibility[hidden]
        LGUI2.Element[bwl.window]:SetVisibility[hidden]
    }

    method CloseAll()
    {
        relay all exit
    }

    method UpdateCurrentTeam()
    {
        switch ${UseTeam}
        {
            default
            case Team1
                CurrentTeam:SetReference["Team1"]
                break
            case Team2
                CurrentTeam:SetReference["Team2"]
                break
            case Team3
                CurrentTeam:SetReference["Team3"]
                break
            case Team4
                CurrentTeam:SetReference["Team4"]
                break
            case Team5
                CurrentTeam:SetReference["Team5"]
                break
        }
    }

    method SelectTeam(string newValue)
    {
        This:UpdateCurrentTeam
        This:ApplyTeam
    }

    method ApplyTeam()
    {
        CurrentTeam:ApplyTeam
    }
}

objectdef blTeam1 
{    
    member ToText()
    {
        return "Team1"   
    }

    method ApplyTeam()
    {
        BLUplink:SetLaunchSlots[5]
        BWLUplink:SelectLayout["Vfx3"]
    }
}
objectdef blTeam2 
{    
    member ToText()
    {
        return "Team2" 
    }

    method ApplyTeam()
    {
        BLUplink:SetLaunchSlots[5]
        BWLUplink:SelectLayout["Vfx3"]
    }
}
objectdef blTeam3 
{    
    member ToText()
    {
        return "Team3"
    }

    method ApplyTeam()
    {
        BLUplink:SetLaunchSlots[4]
        BWLUplink:SelectLayout["Vfx4"]
    }
}
objectdef blTeam4 
{    
    member ToText()
    {
        return "Team4"   
    }

    method ApplyTeam()
    {
        BLUplink:SetLaunchSlots[8]
        BWLUplink:SelectLayout["Vfx4"]
    }
}
objectdef blTeam5 
{    
    member ToText()
    {
        return "Team5"   
    }

    method ApplyTeam()
    {
        BLUplink:SetLaunchSlots[12]
        BWLUplink:SelectLayout["Vfx5"]
    }
}
objectdef blTeam6 
{    
    member ToText()
    {
        return "Team6"   
    }

    method ApplyTeam()
    {
        BLUplink:SetLaunchSlots[10]
        BWLUplink:SelectLayout["Vfx5"]
    }
}

variable(global) blSettings BLSettings



