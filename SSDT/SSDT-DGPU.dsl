DefinitionBlock ("", "SSDT", 2, "hack", "DGPU", 0)
{
  External (_SB_.PCI0.PEG0.PEGP._OFF, MethodObj)
Device(ZRD1) // Custom device to call _OFF on _INI
    {
       
        Name(_HID, "ZRD10000")
        Method(_INI)
        {
            If (CondRefOf(\_SB.PCI0.PEG0.PEGP._OFF)) { \_SB.PCI0.PEG0.PEGP._OFF() }
        }
    }
}