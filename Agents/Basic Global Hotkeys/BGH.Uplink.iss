objectdef bghUplink
{
    variable filepath GlobalFolder="${LavishScript.HomeDirectory}"
    variable jsonvalue GlobalHotkeys="[]"
    variable jsonvalue GlobalShiftkeys="[]"
    variable bool Enabled=1

    method Initialize()
    {
        This:LoadSettings

        LGUI2:LoadPackageFile[xBGH.Uplink.lgui2package.json]
        LGUI2.Element[bgh.filename]:SetText["${GlobalFolder.Replace["/","\\"]~}\\Configuration\\Settings\\bgh.Settings.json"]
    }
    
    method Shutdown()
    {
        This:Disable
        LGUI2:UnloadPackageFile[xBGH.Uplink.lgui2package.json]
    }

    method LoadSettings()
    {
        variable jsonvalue jo

        if !${GlobalFolder.FileExists[\\Configuration\\Settings\\bgh.Settings.json]}
        {
            jo:SetValue["$$>
            {
                "globalHotkeys":[
                    "F1",
                    "F2",
                    "F3",
                    "F4",
                    "F5"
                ],
                "globalShiftkeys":[
                    "Shift+F1",
                    "Shift+F2",
                    "Shift+F3",
                    "Shift+F4",
                    "Shift+F5"
                ]
            }
            <$$"]

            jo:WriteFile["${GlobalFolder~}/Configuration/Settings/bgh.Settings.json",multiline]
        }

        if !${jo:ParseFile["${GlobalFolder~}/Configuration/Settings/bgh.Settings.json"](exists)} || !${jo.Type.Equal[object]}
        {
            return
        }

        GlobalHotkeys:SetValue["${jo.Get["globalHotkeys"].AsJSON~}"]
        GlobalShiftkeys:SetValue["${jo.Get["globalShiftkeys"].AsJSON~}"]

        if !${GlobalHotkeys.Type.Equal[array]}
            GlobalHotkeys:SetValue["[]"]
            GlobalShiftkeys:SetValue["[]"]
    }

    method StoreSettings()
    {
        variable jsonvalue jo
        jo:SetValue["${This.AsJSON~}"]
        jo:WriteFile["${GlobalFolder~}/Configuration/Settings/bgh.Settings.json",multiline]
    }

    member AsJSON()
    {
        variable jsonvalue jo="{}"
        jo:Set["globalHotkeys","${GlobalHotkeys.AsJSON~}"]
        jo:Set["globalShiftkeys","${GlobalShiftkeys.AsJSON~}"]
        return "${jo.AsJSON~}"
    }

    method Enable()
    {
        if ${Enabled}
            return

        Enabled:Set[1]
        
        relay all BGHSession:InstallHotkey
    }

    method Disable()
    {
        if !${Enabled}
            return
        Enabled:Set[0]
        relay all BGHSession:UninstallHotkey
    }

    method HideUI()
    {
        LGUI2.Element[bgh.window]:SetVisibility[hidden]
    }
}

variable(global) bghUplink BGHUplink

function main()
{
    while 1
        waitframe
}