// Enables GPI0 interrupts for ELAN1000 on Asus Zenbook UX501VW
DefinitionBlock ("", "SSDT", 2, "hack", "ETPD", 0) {
    External(_SB.PCI0.GPI0, DeviceObj)
    External(_SB.PCI0.I2C1.ETPD, DeviceObj)
    
    Scope(_SB.PCI0.GPI0) {
        Method (_STA, 0, NotSerialized)  // _STA: Status
         {
              Return (0x0F) 
         }
    }

    Scope(_SB.PCI0.I2C1.ETPD) {
         Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
            {
                Name (LBFG, ResourceTemplate ()
                {
                    GpioInt (Level, ActiveLow, Exclusive, PullUp, 0x0000,
                        "_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                        )
                        {   // Pin list
                            0x0047
                        }
                })
                Name (LBFI, ResourceTemplate ()
                {
                    I2cSerialBusV2 (0x0015, ControllerInitiated, 0x00061A80,
                        AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                       0x00, ResourceConsumer, , Exclusive,
                       )
                })
                Return (ConcatenateResTemplate (LBFI, LBFG))
             }
    }
}