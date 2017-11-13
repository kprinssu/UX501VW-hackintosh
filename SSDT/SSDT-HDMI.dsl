DefinitionBlock ("", "SSDT", 2, "hack", "HDMI", 0x00000000)
{
    External(_SB.PCI0.HDEF, DeviceObj)
    Scope(_SB.PCI0.HDEF) {
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If (LEqual (Arg2, Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                           
                    })
                }

                Return (Package (0x06)
                {
                    "layout-id", 
                    Buffer (0x04)
                    {
                         0x03, 0x00, 0x00, 0x00                         
                    }, 

                    "hda-gfx", 
                    Buffer (0x0A)
                    {
                        "onboard-1"
                    }, 

                    "PinConfigurations", 
                    Buffer (Zero) {}
                })
            }

    }
}