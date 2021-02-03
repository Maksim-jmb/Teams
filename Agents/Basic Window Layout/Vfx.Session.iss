#include "BWL.Common.iss"

objectdef vfxsession
{
    variable filepath GlobalFolder="${LavishScript.HomeDirectory}"
    variable bwlSettings Settings
    variable blSettings blSettings
    variable uint RefreshedSlots
    variable string UseLayout

    method Initialize()
    {
        LavishScript:RegisterEvent[OnSessionRenamed]
        LavishScript:RegisterEvent[On Activate]
        Event[OnSessionRenamed]:AttachAtom[This:OnSetup]

        This:Load
        This:Setup
        This:Store
        LGUI2:LoadPackageFile[xVfx.Session.lgui2Package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[xVfx.Session.lgui2package.json]
    }

    method Load()
    {
        variable jsonvalue ja
        if !${ja:ParseFile["${GlobalFolder~}/Configuration/Settings/bwl.Settings.json"](exists)} || !${ja.Type.Equal[object]}
        {
            return
        }
        if ${ja.Has[useLayout]}
            UseLayout:Set["${ja.Get[useLayout]~}"]
    }

    method Store()
    {
        variable jsonvalue ja
        ja:SetValue["${This.AsJSONvfx~}"]
        ja:WriteFile["${GlobalFolder~}/Configuration/Settings/vfx.sessionlayout.json",multiline]
    }

    member AsJSONvfx()
    {
        variable jsonvalue ja
        ja:SetValue["$$>
        {
            "useLayout":${UseLayout.AsJSON~},
        }
        <$$"]
        return "${ja.AsJSON~}"
    }

    method VfxButton()
    {
        if ${JMB.Slot}==${FtlSlot}
        {
            return
        }
        else
        {
            relay ${Session} BWLSession:UpdateCurrentLayout[${UseLayout}]
            relay ${Session} BRRSession:Disable
            relay jmb1 BWLSession:ApplyWindowLayout
        }
    }

    method VfxButton2()
    {
        relay ${Session} BWLSession:UpdateCurrentLayout[${UseLayout}]
        relay ${Session} BWLSession:ApplyWindowLayout 
    }

    method Focus(uint Slot)
    {
        uplink focus "jmb${Slot}"
        relay "jmb${Slot}" "Event[OnHotkeyFocused]:Execute"
    }

    variable int setlayout

    method OnSetup()
    {
        switch ${Settings.UseLayout}
        {    
            case Vfx3
                setlayout:Set[3]
                This:ClearVfxViews
                break
            case Vfx4
                setlayout:Set[4]
                This:ClearVfxViews
                break
            case Vfx5
                setlayout:Set[5]
                This:ClearVfxViews
                break
        }
        if ${ULSfix}!=${RefreshedSlots}
            This:RefreshSlots${setlayout}
    }

    ; not reliable - timing issues, misses sessions sometimes - work in progress - catch all put on BWLSession:ApplyWindowLayout
    method ClearVfxViews(uint Slot)
    {
        variable uint NumAdded
        for (NumAdded:Set[1] ; ${NumAdded}<${ULSfix3} ; NumAdded:Inc)
        {
            relay jmb${NumAdded} LGUI2.Element[vfx${setlayout}.window]:SetVisibility[Hidden]
        }
    }

    method DestroyPartyVfx()
    {
        relay party LGUI2.Element["vfx${setlayout}.window"]:Destroy
    }
    
    method RefreshSlots3()
    {
        variable uint Slot

        RefreshedSlots:Set[${ULSfix2}]
        LGUI2.Element[vfx3.panel]:ClearChildren
        LGUI2.Element[leftvfx.viewerpanel]:ClearChildren
        LGUI2.Element[midvfx.viewerpanel]:ClearChildren
        LGUI2.Element[rightvfx.viewerpanel]:ClearChildren
        
        if ${ULSfix3}>=1
            This:VfxPanelLeft
        if ${ULSfix3}>=3
            This:VfxPanelMid
        if ${ULSfix3}>=6
            This:VfxPanelRight
    }

    method VfxPanelLeft()
    {
        variable uint Slot
        variable jsonvalue jo

        jo:SetValue["$$>
        {
            "type":"stackpanel",
            "name":"vfx.window",
            "orientation": "vertical",
            "name":"leftvfx.viewerpanel"
        }
        <$$"]
        LGUI2.Element[vfx3.panel]:AddChild["${jo.AsJSON~}"]

        for ( Slot:Set[1] ; ${Slot}<=3 ; Slot:Inc )
        {
            This:LeftAddSlot[${Slot}]
        }
    }

    method VfxPanelMid()
    {
        variable uint Slot
        variable jsonvalue jo

        jo:SetValue["$$>
        {
            "type":"stackpanel",
            "name":"vfx3.window",
            "orientation":"vertical",
            "name":"midvfx.viewerpanel",
            "x":640
        }
        <$$"]
        LGUI2.Element[vfx3.panel]:AddChild["${jo.AsJSON~}"]

        for ( Slot:Set[4] ; ${Slot}<=6 ; Slot:Inc )
        {
            This:MidAddSlot[${Slot}]
        }
    }

    method VfxPanelRight()
    {
        variable uint Slot
        variable jsonvalue jo

        jo:SetValue["$$>
        {
            "type":"stackpanel",
            "name":"vfx3.window",
            "orientation":"vertical",
            "name":"rightvfx.viewerpanel",
            "x":1280
        }
        <$$"]
        LGUI2.Element[vfx3.panel]:AddChild["${jo.AsJSON~}"]
        
        for ( Slot:Set[7] ; ${Slot}<=${ULSfix3} ; Slot:Inc )
        {
            This:RightAddSlot[${Slot}]
        }
    }

    method LeftAddSlot(uint Slot)
    {
       variable jsonvalue jo

        variable string focusCommand="VfxSession:Focus[${Slot}]"
        jo:SetValue["$$>
        {
            "type":"button",
            "name":"vfx3.window",
            "jsonTemplate":"vfx.button",
            "borderThickness":0,
            "content":{
                "jsonTemplate": "vfx3.viewer",
                "feedName": "jmb${Slot}"
            },
            "eventHandlers":{
                "onMouse2Press":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                },
                "onMouse2Release":{
                    "type":"method",
                    "object":"VfxSession",
                    "method":"VfxButton"
                },
                "onMouseWheel":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
            }
        }
        <$$"]
        LGUI2.Element[leftvfx.viewerpanel]:AddChild["${jo.AsJSON~}"]
    }

    method MidAddSlot(uint Slot)
    {
        variable jsonvalue jo

        variable string focusCommand="VfxSession:Focus[${Slot}]"
        jo:SetValue["$$>
        {
            "type":"button",
            "name":"vfx3.window",
            "jsonTemplate":"vfx.button",
            "borderThickness":0,
            "content":{
                "jsonTemplate": "vfx3.viewer",
                "feedName": "jmb${Slot}"
            },
            "eventHandlers":{
                "onMouse2Press":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                },
                "onMouse2Release":{
                    "type":"method",
                    "object":"VfxSession",
                    "method":"VfxButton"
                },
                "onMouseWheel":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
            }
        }
        <$$"]
        LGUI2.Element[midvfx.viewerpanel]:AddChild["${jo.AsJSON~}"]
    }

    method RightAddSlot(uint Slot)
    {
        variable jsonvalue jo

        variable string focusCommand="VfxSession:Focus[${Slot}]"
        jo:SetValue["$$>
        {
            "type":"button",
            "name":"vfx3.window",
            "jsonTemplate":"vfx.button",
            "borderThickness":0,
            "content":{
                "jsonTemplate": "vfx3.viewer",
                "feedName": "jmb${Slot}"
            },
            "eventHandlers":{
                "onMouse2Press":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                },
                "onMouse2Release":{
                    "type":"method",
                    "object":"VfxSession",
                    "method":"VfxButton"
                },
                "onMouseWheel":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
            }
        }
        <$$"]
        LGUI2.Element[rightvfx.viewerpanel]:AddChild["${jo.AsJSON~}"]
    }

    method RefreshSlots4()
    {
        variable uint Slot

        RefreshedSlots:Set[${ULSfix2}]
        LGUI2.Element[vfx4.panel]:ClearChildren
        LGUI2.Element[leftvfx2.viewerpanel]:ClearChildren
        LGUI2.Element[midvfx2.viewerpanel]:ClearChildren
        LGUI2.Element[rightvfx2.viewerpanel]:ClearChildren

        if ${ULSfix3}>=1
            This:VfxPanelLeft2
        if ${ULSfix3}>=4
            This:VfxPanelMid2
        if ${ULSfix3}>=8
            This:VfxPanelRight2
    }

    method VfxPanelLeft2()
    {
        variable uint Slot
        variable jsonvalue jo

        jo:SetValue["$$>
        {
            "type":"stackpanel",
            "orientation": "vertical",
            "name":"leftvfx2.viewerpanel"
        }
        <$$"]
        LGUI2.Element[vfx4.panel]:AddChild["${jo.AsJSON~}"]

        for ( Slot:Set[1] ; ${Slot}<=4 ; Slot:Inc )
        {
            This:LeftAddSlot2[${Slot}]
        }
    }

    method VfxPanelMid2()
    {
        variable uint Slot
        variable jsonvalue jo

        jo:SetValue["$$>
        {
            "type":"stackpanel",
            "orientation":"vertical",
            "name":"midvfx2.viewerpanel",
            "x":640
        }
        <$$"]
        LGUI2.Element[vfx4.panel]:AddChild["${jo.AsJSON~}"]

        for ( Slot:Set[5] ; ${Slot}<=8 ; Slot:Inc )
        {
            This:MidAddSlot2[${Slot}]
        }
    }

    method VfxPanelRight2()
    {
        variable uint numSlots=${JMB.Slots.Used}
        variable uint Slot
        variable jsonvalue jo

        jo:SetValue["$$>
        {
            "type":"stackpanel",
            "orientation":"vertical",
            "name":"rightvfx2.viewerpanel",
            "x":1280
        }
        <$$"]
        LGUI2.Element[vfx4.panel]:AddChild["${jo.AsJSON~}"]
        
        for ( Slot:Set[9] ; ${Slot}<=${ULSfix3} ; Slot:Inc )
        {
            This:RightAddSlot2[${Slot}]
        }
    }

    method LeftAddSlot2(uint Slot)
    {
        variable jsonvalue jo

        variable string focusCommand="VfxSession:Focus[${Slot}]"
        jo:SetValue["$$>
        {
            "type":"button",
            "jsonTemplate":"vfx.button",
            "borderThickness":0,
            "content":{
                "jsonTemplate": "vfx4.viewer",
                "feedName": "jmb${Slot}"
            },
            "eventHandlers":{
                "onMouse2Press":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
                "onMouseWheel":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
            }
        }
        <$$"]

        LGUI2.Element[leftvfx2.viewerpanel]:AddChild["${jo.AsJSON~}"]
    }

    method MidAddSlot2(uint Slot)
    {
        variable jsonvalue jo

        variable string focusCommand="VfxSession:Focus[${Slot}]"
        jo:SetValue["$$>
        {
            "type":"button",
            "jsonTemplate":"vfx.button",
            "borderThickness":0,
            "content":{
                "jsonTemplate": "vfx4.viewer",
                "feedName": "jmb${Slot}"
            },
            "eventHandlers":{
                "onMouse2Press":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
                "onMouseWheel":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
            }
        }
        <$$"]

        LGUI2.Element[midvfx2.viewerpanel]:AddChild["${jo.AsJSON~}"]
    }

    method RightAddSlot2(uint Slot)
    {
        variable jsonvalue jo

        variable string focusCommand="VfxSession:Focus[${Slot}]"
        jo:SetValue["$$>
        {
            "type":"button",
            "jsonTemplate":"vfx.button",
            "content":{
                "jsonTemplate": "vfx4.viewer",
                "feedName": "jmb${Slot}"
            },
            "eventHandlers":{
                "onMouse2Press":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
                "onMouseWheel":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
            }
        }
        <$$"]

        LGUI2.Element[rightvfx2.viewerpanel]:AddChild["${jo.AsJSON~}"]
    }

    method RefreshSlots5()
    {
        variable uint Slot

        RefreshedSlots:Set[${ULSfix2}]
        LGUI2.Element[vfx5.panel]:ClearChildren
        LGUI2.Element[firstvfx.viewerpanel]:ClearChildren
        LGUI2.Element[secondvfx.viewerpanel]:ClearChildren
        LGUI2.Element[thirdvfx.viewerpanel]:ClearChildren
        LGUI2.Element[fourthvfx.viewerpanel]:ClearChildren

        if ${ULSfix3}>=2
            This:VfxPanelFirst
        if ${ULSfix3}>=5
            This:VfxPanelSecond
        if ${ULSfix3}>=10
            This:VfxPanelThird
        if ${ULSfix3}>=15
            This:VfxPanelFourth
    }

    method VfxPanelFirst()
    {
        variable uint Slot
        variable jsonvalue jo

        jo:SetValue["$$>
        {
            "type":"stackpanel",
            "orientation": "horizontal",
            "name":"firstvfx.viewerpanel"
        }
        <$$"]
        LGUI2.Element[vfx5.panel]:AddChild["${jo.AsJSON~}"]

        for ( Slot:Set[1] ; ${Slot}<=5 ; Slot:Inc )
        {
            This:FirstAddSlot[${Slot}]
        }
    }

    method VfxPanelSecond()
    {
        variable uint Slot
        variable jsonvalue jo

        jo:SetValue["$$>
        {
            "type":"stackpanel",
            "orientation":"horizontal",
            "name":"secondvfx.viewerpanel",
            "y":270
        }
        <$$"]
        LGUI2.Element[vfx5.panel]:AddChild["${jo.AsJSON~}"]

        for ( Slot:Set[6] ; ${Slot}<=10 ; Slot:Inc )
        {
            This:SecondAddSlot[${Slot}]
        }
    }

    method VfxPanelThird()
    {
        variable uint Slot
        variable jsonvalue jo

        jo:SetValue["$$>
        {
            "type":"stackpanel",
            "orientation":"horizontal",
            "name":"thirdvfx.viewerpanel",
            "y":540
        }
        <$$"]
        LGUI2.Element[vfx5.panel]:AddChild["${jo.AsJSON~}"]
        
        for ( Slot:Set[11] ; ${Slot}<=15 ; Slot:Inc )
        {
            This:ThirdAddSlot[${Slot}]
        }
    }

    method VfxPanelFourth()
    {
        variable uint numSlots=${JMB.Slots.Used}
        variable uint Slot

        variable jsonvalue jo
        jo:SetValue["$$>
        {
            "type":"stackpanel",
            "orientation":"horizontal",
            "name":"fourthvfx.viewerpanel",
            "y":810
        }
        <$$"]
        LGUI2.Element[vfx5.panel]:AddChild["${jo.AsJSON~}"]
        
        for ( Slot:Set[16] ; ${Slot}<=${ULSfix3} ; Slot:Inc )
        {
            This:FourthAddSlot[${Slot}]
        }
    }

    method FirstAddSlot(uint Slot)
    {
        variable jsonvalue jo

        variable string focusCommand="VfxSession:Focus[${Slot}]"
        jo:SetValue["$$>
        {
            "type":"button",
            "jsonTemplate":"vfx.button",
            "borderThickness":0,
            "content":{
                "jsonTemplate": "vfx5.viewer",
                "feedName": "jmb${Slot}"
            },
            "eventHandlers":{
                "onMouse2Press":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
                "onMouseWheel":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
            }
        }
        <$$"]
        LGUI2.Element[firstvfx.viewerpanel]:AddChild["${jo.AsJSON~}"]
    }

    method SecondAddSlot(uint Slot)
    {
        variable jsonvalue jo

        variable string focusCommand="VfxSession:Focus[${Slot}]"
        jo:SetValue["$$>
        {
            "type":"button",
            "jsonTemplate":"vfx.button",
            "borderThickness":0,
            "content":{
                "jsonTemplate": "vfx5.viewer",
                "feedName": "jmb${Slot}"
            },
            "eventHandlers":{
                "onMouse2Press":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
                "onMouseWheel":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
            }
        }
        <$$"]
        LGUI2.Element[secondvfx.viewerpanel]:AddChild["${jo.AsJSON~}"]
    }

    method ThirdAddSlot(uint Slot)
    {
        variable jsonvalue jo

        variable string focusCommand="VfxSession:Focus[${Slot}]"
        jo:SetValue["$$>
        {
            "type":"button",
            "jsonTemplate":"vfx.button",
            "content":{
                "jsonTemplate": "vfx5.viewer",
                "feedName": "jmb${Slot}"
            },
            "eventHandlers":{
                "onMouse2Press":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
                "onMouseWheel":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
            }
        }
        <$$"]
        LGUI2.Element[thirdvfx.viewerpanel]:AddChild["${jo.AsJSON~}"]
    }

    method FourthAddSlot(uint Slot)
    {
        variable jsonvalue jo

        variable string focusCommand="VfxSession:Focus[${Slot}]"
        jo:SetValue["$$>
        {
            "type":"button",
            "jsonTemplate":"vfx.button",
            "content":{
                "jsonTemplate": "vfx5.viewer",
                "feedName": "jmb${Slot}"
            },
            "eventHandlers":{
                "onMouse2Press":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
                "onMouseWheel":{
                    "type":"code",
                    "code":${focusCommand.AsJSON~}
                }
            }
        }
        <$$"]
        LGUI2.Element[fourthvfx.viewerpanel]:AddChild["${jo.AsJSON~}"]
    }
}

variable(global) vfxsession VfxSession

function main()
{
    while 1
        waitframe
}