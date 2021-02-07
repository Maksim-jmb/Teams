objectdef ftlSettings
{
    method Initialize()
    {
    }

    method Shutdown()
    {
    }

    method FTLset(uint mslot)
    {
        if ${mslot.Equal[${FtlSlot}]}
        {
            return
        }
        else
        {
            FtlSlot:Set[${mslot}]
            This:Popup
        }
    }

    method Popup(string caps=${Session})
    {
        relay jmb${JMB.MouseOverSlot} LGUI2.Element[jmbpopup]:SetVisibility[visible]
        LGUI2.Element[jmbpopup.text]:SetText["Switching Main to ${caps.Upper}"]
        TimedCommand 40 LGUI2.Element[jmbpopup]:SetVisibility[hidden]
    }

    method FTLfocus(uint toSlot)
    {
        if ${toSlot.Equal[${FtlSlot}]}
        {
            ; echo "FTLfocus return toSlot ${toSlot} ${FtlSlot}"
            return
        }
        else
        {
            uplink focus jmb${FtlSlot}
            ; echo "FTLfocus toSlot ${toSlot} ${FtlSlot}"
        }
    }

    method FTLswaplayout(uint mslot)
    {
        if ${mslot.Equal[${FtlSlot}]}
        {
            relay jmb${JMB.MouseOverSlot} BWLSession:ApplyWindowLayout
            relay party BRRSession:Disable
            ; echo "FTLswaplayout return toSlot ${toSlot} ${FtlSlot}"
            return
        }
        else
        {
            uplink focus jmb${FtlSlot}
            TimedCommand 2 relay jmb${JMB.MouseOverSlot} BWLSession:ApplyWindowLayout
            TimedCommand 3 relay party BRRSession:Disable
        }
    }
}

variable(global) ftlSettings FTLSettings
variable(globalkeep) uint FtlSlot


