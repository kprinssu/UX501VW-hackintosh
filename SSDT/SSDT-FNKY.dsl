// Enables most of Asus FN Keys
DefinitionBlock ("", "SSDT", 2, "hack", "FNKY", 0)
{
    External(\_SB.ATKD.IANE, MethodObj)
    External (\_SB.KBLV, FieldUnitObj)
    External (\_SB.PCI0.LPCB.EC.WRAM, MethodObj)
    External (\_SB.ATKD, DeviceObj)
    External (\_SB.ATKD.PWKB, BuffObj)
    External(_SB.PCI0.LPCB.EC, DeviceObj)
    External(_SB.PCI0.LPCB.EC.ATKP, IntObj)
    External(_SB.PCI0.LPCB.EC.XQ0E, MethodObj)
    External(_SB.PCI0.LPCB.EC.XQ0F, MethodObj)

    // externals needed for LID and Fn+F7 fixes
    External(_SB.PCI0.LPCB.EC.ECAV, MethodObj)
    External(_SB.PCI0.LPCB.EC.MUEC, UnknownObj)
    External(_SB.PCI0.LPCB.EC.CDT1, UnknownObj)
    External(_SB.PCI0.LPCB.EC.CDT2, UnknownObj)
    External(_SB.PCI0.LPCB.EC.CDT3, UnknownObj)
    External(_SB.PCI0.LPCB.EC.CMD1, UnknownObj)
    External(_SB.PCI0.LPCB.EC.CMD2, UnknownObj)
    External(_SB.PCI0.LPCB.EC.CMD3, UnknownObj)
    
    // Fn+F7
    External(_SB.PCI0.LPCB.EC.BLCT, UnknownObj)
    
    // Lid
    External(_SB.LID, DeviceObj)
    External(VGAF, UnknownObj)
    External (_SB_.PCI0.IGPU.CLID, UnknownObj)
    
    // Lid Fixes
    Scope(\) {
        Method (GLID, 0, Serialized)
        {
            Return (\_SB.PCI0.LPCB.EC.RPUN (0x11))
        }
    }
    
    Scope(_SB.LID) {
         Method (_LID, 0, NotSerialized)  // _LID: Lid Status
            {
                Store (One, Local0)
                Store (^^PCI0.LPCB.EC.RPUN (0x11), Local0)
                If (LEqual (Local0, Ones))
                {
                    Store (One, Local0)
                }

                If (And (VGAF, One))
                {
                    Store (One, ^^PCI0.IGPU.CLID)
                }

                Return (Local0)
            }
    }
    
    Scope(_SB.PCI0.LPCB.EC)
    {
        // Fixes Fn+F7
         Method (ECCM, 4, Serialized)
            {
                If (ECAV ())
                {
                    Acquire (MUEC, 0xFFFF)
                    Store (Arg0, CDT1)
                    Store (Arg1, CDT2)
                    Store (Arg2, CDT3)
                    Store (Arg3, CMD1)
                    Store (0x7F, Local0)
                    While (LAnd (Local0, CMD1))
                    {
                        Sleep (One)
                        Decrement (Local0)
                    }
                    If (LEqual (CMD1, Zero))
                    {
                        Store (CDT1, Local0)
                    }
                    Else
                    {
                        Store (Ones, Local0)
                    }
                    Release (MUEC)
                    Return (Local0)
                }
                Return (Ones)
            }
            Method (RPUN, 1, Serialized)
            {
                Return (ECCM (0x87, Zero, Arg0, 0xB6))
            }
            Method (SPUN, 2, Serialized)
            {
                If (Arg1)
                {
                    ECCM (0x87, 0x20, Arg0, 0xB6)
                }
                Else
                {
                    ECCM (0x87, 0x40, Arg0, 0xB6)
                }
            }
            
        Method (_Q0E)
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x20) // For brightness
            }
        }

        Method (_Q0F)
        {
            If (ATKP)
            {
                \_SB.ATKD.IANE (0x10) // For brightness
            }
        }
        
        // Fn+F7
         Method (_Q10, 0, NotSerialized)  // _Qxx: EC Query
        {
            If (ATKP)
            {
                ^^^^ATKD.IANE (0x35)
            }
        }

    }

    Scope (_SB.ATKD) // To change keyboard backlight this needs to be injected
    {
        Name (BOFF, Zero)
        Method (SKBL, 1, NotSerialized)
        {
            If (Or (LEqual (Arg0, 0xED), LEqual (Arg0, 0xFD)))
            {
                If (And (LEqual (Arg0, 0xED), LEqual (BOFF, 0xEA)))
                {
                    Store (Zero, Local0)
                    Store (Arg0, BOFF)
                }
                Else
                {
                    If (And (LEqual (Arg0, 0xFD), LEqual (BOFF, 0xFA)))
                    {
                        Store (Zero, Local0)
                        Store (Arg0, BOFF)
                    }
                    Else
                    {
                        Return (BOFF)
                    }
                }
            }
            Else
            {
                If (Or (LEqual (Arg0, 0xEA), LEqual (Arg0, 0xFA)))
                {
                    Store (KBLV, Local0)
                    Store (Arg0, BOFF)
                }
                Else
                {
                    Store (Arg0, Local0)
                    Store (Arg0, KBLV)
                }
            }
            Store (DerefOf (Index (PWKB, Local0)), Local1)
            ^^PCI0.LPCB.EC.WRAM (0x04B1, Local1)
            Return (Local0)
        }

        Method (GKBL, 1, NotSerialized)
        {
            If (LEqual (Arg0, 0xFF))
            {
                Return (BOFF)
            }
            Return (KBLV)
        }
    }
}