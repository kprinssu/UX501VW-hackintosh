DefinitionBlock ("", "SSDT", 2, "hack", "SMCD", 0)
{
    External(\_SB.PCI0.LPCB.EC.TH00, UnknownObj)
    External(\_SB.PCI0.LPCB.EC.TH01, UnknownObj)
    
    Device (SMCD)
    {
        Name (_HID, "FAN0000")  // _HID: Hardware ID
        Method (B1B3, 2, NotSerialized)
        {
            Return (Or (Arg0, ShiftLeft (Arg1, 0x08)))
        }

        Method (FAN0, 0, Serialized)
        {
            Store (B1B3 (\_SB.PCI0.LPCB.EC.TH00, \_SB.PCI0.LPCB.EC.TH01), Local0)
            If (LEqual (Local0, 0xFF))
            {
                Store (Zero, Local0)
            }
            If (Local0)
            {
                Store (0x80, Local1)
                Store (0x02, Local2)
                Multiply (Local1, Local2, Local3)
                Multiply (Local0, Local3, Local4)
                Divide (0x03938700, Local4, Local5, Local6)
                Multiply (Local6, 0x0A, Local6)
                Store (Local6, Local0)
            }
            Return (Local0)
        }
    }
}