#include "BRR.Common.iss"


objectdef brrSession
{
    variable taskmanager TaskManager=${LMAC.NewTaskManager["brrSession"]}
    variable brrSettings Settings
    variable blSettings BlSettings

    method Initialize()
    {
        LGUI2:LoadPackageFile[xBRR.Session.lgui2Package.json]
        This.Settings:EnableHotkeys
        focusclick eat
    }

    method Shutdown()
    {
        This:Disable
        This.Settings:DisableHotkeys
        TaskManager:Destroy
        LGUI2:UnloadPackageFile[xBRR.Session.lgui2Package.json]
    }

    method NextWindow()
    {
        if ${Settings.CurrentProfile.Name.Equal["melee"]} 
            uplink focus -next melee
            ; FlushQueued
        if ${Settings.CurrentProfile.Name.Equal["party"]}
            uplink focus -next party
            ; FlushQueued
        if ${Settings.CurrentProfile.Name.Equal["ranged"]}
            uplink focus -next ranged
            ; FlushQueued
        if ${Settings.CurrentProfile.Name.Equal["mouse2"]}
            uplink focus -next party
            ; FlushQueued
    }

    method NextWindowHealing()
    {
        if ${Settings.CurrentProfile.Name.Equal["party"]}
            switch ${mod}
            {
                default
                case 1
                    uplink focus -first heal
                    mod:Set[2]
                    brrnum:Inc
                    ; echo "case 1 ${mod} ${brrnum}"
                    break
                case 2
                    uplink focus -next (jmb1,jmb3,jmb4,jmb5)%${brrnum}
                    mod:Set[1]
                    ; echo "case 2 ${mod} ${brrnum}"
                    break
            }
            if ${brrnum}>=5
                brrnum:Set[0]
    }

    method OnControlHook(string controlName)
    {
        variable bool Advance=${Settings.CurrentProfile.DefaultAllow}

        ; check for overrides
        variable jsonvalueref Override
        Override:SetReference["Settings.CurrentProfile.Overrides[${controlName.AsJSON~}]"]

        if ${Override.Type.Equal[object]}
        {
        ;    echo "Button released: \"${Context.Args[controlName]}\" override=${Override.AsJSON~}"
            if ${Override.Get[allow]}
            {
                Advance:Set[1]
            }
            if ${Override.Get[ignore]}
            {
                Advance:Set[0]
            }
        }
        else
        {
        ;    echo "Button released: \"${Context.Args[controlName]}\""
        }

        if ${Advance}
            This:NextWindow
    }

    ; method OnButtonHook()
    ; {
    ;     This:OnControlHook["${Context.Args[controlName]~}"]
    ; }

    method OnMouseButtonHook()
    {
        if ${Settings.CurrentProfile.IncludeMouse}
            This:OnControlHook["${Context.Args[controlName]~}"]
    }

    method Enable(string profile)
    {
        Settings:SetCurrentProfile["${profile~}"]
        LGUI2.Element[basicRoundRobin.allButtons]:Destroy
        LGUI2:LoadJSON["${LGUI2.Template[${profile~}.allButtons].AsJSON~}"]
    }

    method Disable()
    {
        Settings:ClearCurrentProfile
        LGUI2.Element[basicRoundRobin.allButtons]:Destroy
    }

    ; used by the GUI to indicate profile hotkey was pressed. pass to the uplink for processing
    method ToggleProfile(string profile)
    {
        relay uplink "BRRUplink:ToggleProfile[${profile.AsJSON~}]"
    }
}

variable(global) brrSession BRRSession
variable(globalkeep) uint brrnum=1
variable(globalkeep) uint mod=1

function main()
{
    while 1
        waitframe
}
