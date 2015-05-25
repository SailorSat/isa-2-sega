Attribute VB_Name = "TVicLib"
'  ========================================================================
'  =================    TVicHW32 6.0  DLL interface        ================
'  ==========  Copyright (c) 1997-2004 Victor I.Ishikeev        ===========
'  ========================================================================
'  ==========         mailto: tools@entechtaiwan.com            ===========
'  ==========     http://www.entechtaiwan.com/tools.htm         ===========
'  ========================================================================

Public Type IrqClearRec
  ClearIrq       As Byte   ' 1 - Irq must be cleared, 0 - not
  TypeOfRegister As Byte   ' 0 - memory, 1 - port
  WideOfRegister As Byte   ' 1 - Byte, 2 - Word, 4 - Double Word
  ReadOrWrite    As Byte   ' 0 - read register to clear Irq, 1 - write
  RegBaseAddress As Long   ' Memory or port i/o register base address to clear
  RegOffset      As Long   ' Register offset
  ValueToWrite   As Long   ' Value to write (if ReadOrWrite=1)
End Type

Public Type TDmaBufferRequest
  LengthOfBuffer As Long ' Length in Bytes
  AlignMask      As Long ' 0-4K, 1-8K, 3-16K, 7-32K, $0F-64K, $1F-128K
  PhysDmaAddress As Long ' returned physical address of DMA buffer
  LinDmaAddress  As Long ' returned linear address
  DmaMemHandle   As Long ' returned memory handle (do not use and keep it!)
  reserved1      As Long
  KernelDmaAddress As Long ' do not use and keep it!
  reserved2      As Long
End Type

'- Ide Hdd hardware manufacturer info structure ---
Public Type TypeHddInfo   ' Create user-defined type.
  BufferSize      As Long
  DoubleTransfer  As Long
  ControllerType  As Long
  ECCMode         As Long
  SectorsPerInterrupt As Long
  Cylinders           As Long
  Heads               As Long
  SectorsPerTrack     As Long
  Model  As String * 41
  SerialNumber   As String * 21
  Revision As String * 9
End Type

Public Type PortByteFifo
  PortAddr     As Long
  NumPorts     As Long
  Buffer(256)  As Byte ' you can change the dimension of this array
End Type

Public Type PortWordFifo
  PortAddr     As Long
  NumPorts     As Long ' you can change the dimension of this array
  Buffer(128)  As Integer
End Type

Public Type PortLongFifo
  PortAddr     As Long
  NumPorts     As Long
  Buffer(64)   As Long ' you can change the dimension of this array
End Type

'- PCI non-bridge configuration record
Public Const LPT_NOT_ACQUIRED = 0
Public Const LPT_ACQUIRE_SUCCESS = 1
Public Const LPT_ACQUIRE_REFUSED = 2
Public Const LPT_ACQUIRE_BAD_PORT = 3
Public Const LPT_ACQUIRE_NOT_OPENED = 4

Public Type PciNonBridge
  VendorId        As Integer 'common part
  DeviceId        As Integer
  command_reg     As Integer
  status_reg      As Integer
  revisionID      As Byte
  progIF          As Byte
  subclass        As Byte
  classcode       As Byte
  cacheline_size  As Byte
  latency         As Byte
  header_type     As Byte
  BIST            As Byte
  
  base_address0        As Long     'header specific part
  base_address1        As Long
  base_address2        As Long
  base_address3        As Long
  base_address4        As Long
  base_address5        As Long
  
  CardBus_CIS        As Long
  subsystem_vendorID As Integer
  subsystem_deviceID As Integer
  ROMBaseAddress     As Long
  
  cap_ptr            As Byte
  reserved1(1 To 3)  As Byte
  reserved2          As Long
  
  interrupt_line       As Byte
  interrupt_pin        As Byte
  min_grant            As Byte
  max_latency          As Byte
  device_specific(1 To 192) As Byte
End Type

'- PCI bridge configuration record
Public Type PciBridge
  VendorId        As Integer 'common part
  DeviceId        As Integer
  command_reg     As Integer
  status_reg      As Integer
  revisionID      As Byte
  progIF          As Byte
  subclass        As Byte
  classcode       As Byte
  cacheline_size  As Byte
  latency         As Byte
  header_type     As Byte
  BIST            As Byte
  
  base_address0        As Long 'header specific part
  base_address1        As Long
  primary_bus          As Byte
  secondary_bus        As Byte
  subordinate_bus      As Byte
  secondary_latency    As Byte
  IO_base_low          As Byte
  IO_limit_low         As Byte
  secondary_status     As Integer
  memory_base_low      As Integer
  memory_limit_low     As Integer
  prefetch_base_low    As Integer
  prefetch_limit_low   As Integer
  prefetch_base_high   As Long
  prefetch_limit_high  As Long
  IO_base_high         As Integer
  IO_limit_high        As Integer
  reserved2            As Long
  expansion_ROM        As Long
  interrupt_line       As Byte
  interrupt_pin        As Byte
  bridge_control       As Integer
  device_specific(1 To 48)  As Long
End Type

'- PCI CardBus configuration record
Public Type PciCardBus

       VendorId        As Integer 'common part
       DeviceId        As Integer
       command_reg     As Integer
       status_reg      As Integer
       revisionID      As Byte
       progIF          As Byte
       subclass        As Byte
       classcode       As Byte
       cacheline_size  As Byte
       latency         As Byte
       header_type     As Byte
       BIST            As Byte
       
       ExCa_base           As Long 'header specific part
       cap_ptr             As Byte
       reserved05          As Byte
       secondary_status    As Integer
       PCI_bus             As Byte
       CardBus_bus         As Byte
       subordinate_bus     As Byte
       latency_timer       As Byte
       memory_base0        As Long
       memory_limit0       As Long
       memory_base1        As Long
       memory_limit1       As Long
       IObase_0low         As Integer
       IObase_0high        As Integer
       IOlimit_0low        As Integer
       IOlimit_0high       As Integer
       IObase_1low         As Integer
       IObase_1high        As Integer
       IOlimit_1low        As Integer
       IOlimit_1high       As Integer
       interrupt_line      As Byte
       interrupt_pin       As Byte
       bridge_control      As Integer
       subsystem_vendorID  As Integer
       subsystem_deviceID  As Integer
       legacy_baseaddr     As Long
       cardbus_reserved(1 To 14) As Long
       vendor_specific(1 To 32)  As Long
       
End Type

'-------------------------------------
'---  Win32 API functions ------------
'-------------------------------------
Public Declare Sub ShellExecute Lib "shell32.dll" _
    Alias "ShellExecuteA" (ByVal hwnd As Long, _
    ByVal lpOperation As String, _
    ByVal lpFile As String, _
    ByVal lpParameters As String, _
    ByVal lpDirectory As String, ByVal nShowCmd As Long)
    
Public Declare Function GetDesktopWindow Lib "user32" () As Long

Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" _
                   (Destination As Any, Source As Any, ByVal Length As Long)

'-------------------------------------
'----------- Common Group ------------
'-------------------------------------

Public Declare Function OpenTVicHW Lib "TVicHW32.DLL" Alias "_OpenTVicHW@0" () As Long
Public Declare Function OpenTVicHW32 Lib "TVicHW32.DLL" Alias "_OpenTVicHW32@12" _
                                     (ByVal HW32 As Long, _
                                      ByVal ServiceName As String, _
                                      ByVal EntryPoint As String) As Long
Public Declare Function CloseTVicHW32 Lib "TVicHW32.DLL" Alias "_CloseTVicHW32@4" (ByVal HW32 As Long) As Long
Public Declare Function GetActiveHW Lib "TVicHW32.DLL" Alias "_GetActiveHW@4" (ByVal HW32 As Long) As Long

'------------------------------------
'---------- Ring0  ------------------
'------------------------------------

Public Declare Function RunRing0Function Lib "TVicHW32.DLL" Alias "_RunRing0Function@12" _
                                (ByVal HW32 As Long, _
                                  ByVal Ring0Function As Long, _
                                  ByRef Parm As Any) As Long

'The Ring0 function must be declared in separate module (not in form!)
'by this way:

' Public Function MyRRing0Function(ByRef Parm As Any)
' ... you are in Ring0 now ....
' End Fun

' The call to RunRing0Function:
' a = RunRing0Function (HW32, AddressOf MyRing0Function, AnyVariable)


'-------------------------------------
'--------- Port I/O Group ------------
'-------------------------------------

Public Declare Sub SetHardAccess Lib "TVicHW32.DLL" Alias "_SetHardAccess@8" (ByVal HW32 As Long, ByVal HardAccess As Long)

Public Declare Function GetHardAccess Lib "TVicHW32.DLL" Alias "_GetHardAccess@4" (ByVal HW32 As Long) As Long

Public Declare Function GetPortByte Lib "TVicHW32.DLL" Alias "_GetPortByte@8" (ByVal HW32 As Long, ByVal PortAddr As Long) As Byte
 
Public Declare Sub SetPortByte Lib "TVicHW32.DLL" Alias "_SetPortByte@12" (ByVal HW32 As Long, ByVal PortAddr As Long, ByVal nNewValue As Byte)

Public Declare Function GetPortWord Lib "TVicHW32.DLL" Alias "_GetPortWord@8" (ByVal HW32 As Long, ByVal PortAddr As Long) As Integer

Public Declare Sub SetPortWord Lib "TVicHW32.DLL" Alias "_SetPortWord@12" (ByVal HW32 As Long, ByVal PortAddr As Long, ByVal nNewValue As Integer)

Public Declare Function GetPortLong Lib "TVicHW32.DLL" Alias "_GetPortLong@8" (ByVal HW32 As Long, ByVal PortAddr As Long) As Long

Public Declare Sub SetPortLong Lib "TVicHW32.DLL" Alias "_SetPortLong@12" (ByVal HW32 As Long, ByVal PortAddr As Long, ByVal nNewValue As Long)


Public Declare Sub ReadPortFIFO Lib "TVicHW32.DLL" Alias "_ReadPortFIFO@8" (ByVal HW32 As Long, ByRef pBuffer As PortByteFifo)
                
Public Declare Sub ReadPortWFIFO Lib "TVicHW32.DLL" Alias "_ReadPortWFIFO@8" (ByVal HW32 As Long, ByRef pBuffer As PortWordFifo)

Public Declare Sub ReadPortLFIFO Lib "TVicHW32.DLL" Alias "_ReadPortLFIFO@8" (ByVal HW32 As Long, ByRef pBuffer As PortLongFifo)
                

Public Declare Sub WritePortFIFO Lib "TVicHW32.DLL" Alias "_WritePortFIFO@8" (ByVal HW32 As Long, ByRef pBuffer As PortByteFifo)
                
Public Declare Sub WritePortWFIFO Lib "TVicHW32.DLL" Alias "_WritePortWFIFO@8" (ByVal HW32 As Long, ByRef pBuffer As PortWordFifo)
                 
Public Declare Sub WritePortLFIFO Lib "TVicHW32.DLL" Alias "_WritePortLFIFO@8" (ByVal HW32 As Long, ByRef pBuffer As PortLongFifo)

                 
'------------------ Memory Group  -----------------

Public Declare Function MapPhysToLinear Lib "TVicHW32.DLL" Alias "_MapPhysToLinear@12" (ByVal HW32 As Long, ByVal PhAddr As Long, ByVal nNewValue As Long) As Long
                 
Public Declare Sub UnmapMemory Lib "TVicHW32.DLL" Alias "_UnmapMemory@12" (ByVal HW32 As Long, ByVal PhAddr As Long, ByVal PhSize As Long)

Public Declare Sub GetLockedMemory Lib "TVicHW32.DLL" Alias "_GetLockedMemory@4" (ByVal HW32 As Long)
                 
Public Declare Function GetMemByte Lib "TVicHW32.DLL" Alias "_GetMem@12" (ByVal HW32 As Long, ByVal MappedAddr As Long, ByVal Offset As Long) As Byte
                 
Public Declare Sub SetMemByte Lib "TVicHW32.DLL" Alias "_SetMem@16" (ByVal HW32 As Long, ByVal MappedAddr As Long, ByVal Offset As Long, ByVal nNewValue As Byte)

Public Declare Function GetMem Lib "TVicHW32.DLL" Alias "_GetMem@12" (ByVal HW32 As Long, ByVal MappedAddr As Long, ByVal Offset As Long) As Byte
                 
Public Declare Sub SetMem Lib "TVicHW32.DLL" Alias "_SetMem@16" (ByVal HW32 As Long, ByVal MappedAddr As Long, ByVal Offset As Long, ByVal nNewValue As Byte)
                 
Public Declare Function GetMemW Lib "TVicHW32.DLL" Alias "_GetMemW@12" (ByVal HW32 As Long, ByVal MappedAddr As Long, ByVal Offset As Long) As Integer
                
Public Declare Sub SetMemW Lib "TVicHW32.DLL" Alias "_SetMemW@16" (ByVal HW32 As Long, ByVal MappedAddr As Long, ByVal Offset As Long, ByVal nNewValue As Integer)
                 
Public Declare Function GetMemL Lib "TVicHW32.DLL" Alias "_GetMemL@12" (ByVal HW32 As Long, ByVal MappedAddr As Long, ByVal Offset As Long) As Long
                 
Public Declare Sub SetMemL Lib "TVicHW32.DLL" Alias "_SetMemW@16" (ByVal HW32 As Long, ByVal MappedAddr As Long, ByVal Offset As Long, ByVal nNewValue As Long)
                 
'-------------------------- IRQ Group  -----------------

Public Declare Function IsIRQMasked Lib "TVicHW32.DLL" Alias "_IsIRQMasked@8" (ByVal HW32 As Long, ByVal IrqNumber As Integer) As Long
                 
Public Declare Sub UnmaskIRQ Lib "TVicHW32.DLL" Alias "_UnmaskIRQ@12" (ByVal HW32 As Long, ByVal IrqNumber As Integer, ByVal lpHWHandler As Long)

Public Declare Sub UnmaskIRQEx Lib "TVicHW32.DLL" Alias "_UnmaskIRQEx@20" _
                                                  (ByVal HW32 As Long, _
                                                   ByVal IrqNumber As Integer, _
                                                   ByVal IrqShared As Long, _
                                                   ByVal HWHandler As Long, _
                                                   ByRef ClearRec As IrqClearRec)
                 
Public Declare Sub MaskIRQ Lib "TVicHW32.DLL" Alias "_MaskIRQ@8" (ByVal HW32 As Long, ByVal IrqNumber As Integer)
                 
Public Declare Function GetIRQCounter Lib "TVicHW32.DLL" Alias "_GetIRQCounter@8" (ByVal HW32 As Long, ByVal IrqNumber As Integer) As Long
                 
'-------------------------- Keyboard Group  -----------------

Public Declare Sub PutScanCode Lib "TVicHW32.DLL" Alias "_PutScanCode@8" (ByVal HW32 As Long, ByVal scan_code As Byte)

Public Declare Function GetScanCode Lib "TVicHW32.DLL" Alias "_GetScanCode@4" (ByVal HW32 As Long) As Byte

Public Declare Sub HookKeyboard Lib "TVicHW32.DLL" Alias "_HookKeyboard@8" (ByVal HW32 As Long, ByVal KbdHandler As Long)
                
Public Declare Sub UnhookKeyboard Lib "TVicHW32.DLL" Alias "_UnhookKeyboard@4" (ByVal HW32 As Long)
                 
Public Declare Sub PulseKeyboard Lib "TVicHW32.DLL" Alias "_PulseKeyboard@4" (ByVal HW32 As Long)
                
Public Declare Sub PulseKeyboardLocal Lib "TVicHW32.DLL" Alias "_PulseKeyboardLocal@4" (ByVal HW32 As Long)
                 

'-------------------- LPT port Group -------------

Public Declare Sub SetLPTReadMode Lib "TVicHW32.DLL" Alias "_SetLPTReadMode@4" (ByVal HW32 As Long)
Public Declare Sub SetLPTWriteMode Lib "TVicHW32.DLL" Alias "_SetLPTWriteMode@4" (ByVal HW32 As Long)


Public Declare Function IsLPTAcquired Lib "TVicHW32.DLL" Alias "_IsLPTAcquired@8" (ByVal HW32 As Long, ByVal LPTNumber As Integer) As Integer

Public Declare Function AcquireLPT Lib "TVicHW32.DLL" Alias "_AcquireLPT@8" (ByVal HW32 As Long, ByVal LPTNumber As Integer) As Integer

Public Declare Sub ReleaseLPT Lib "TVicHW32.DLL" Alias "_ReleaseLPT@8" (ByVal HW32 As Long, ByVal LPTNumber As Integer)

Public Declare Function AddNewLPT Lib "TVicHW32.DLL" Alias "_AddNewLPT@8" (ByVal HW32 As Long, ByVal PortBaseAddress As Integer) As Byte

Public Declare Function GetLPTNumber Lib "TVicHW32.DLL" Alias "_GetLPTNumber@4" (ByVal HW32 As Long) As Byte
                
Public Declare Sub SetLPTNumber Lib "TVicHW32.DLL" Alias "_SetLPTNumber@8" (ByVal HW32 As Long, ByVal nNewValue As Byte)
                 
Public Declare Function GetLPTNumPorts Lib "TVicHW32.DLL" Alias "_GetLPTNumPorts@4" (ByVal HW32 As Long) As Byte
                 
Public Declare Function GetLPTBasePort Lib "TVicHW32.DLL" Alias "_GetLPTBasePort@4" (ByVal HW32 As Long) As Long
                 

Public Declare Function GetPin Lib "TVicHW32.DLL" Alias "_GetPin@8" (ByVal HW32 As Long, ByVal nPin As Byte) As Long
                 
Public Declare Sub SetPin Lib "TVicHW32.DLL" Alias "_SetPin@12" (ByVal HW32 As Long, ByVal nPin As Byte, ByVal bNewValue As Long)

Public Declare Function GetLPTAckwl Lib "TVicHW32.DLL" Alias "_GetLPTAckwl@4" (ByVal HW32 As Long) As Long
                 
Public Declare Function GetLPTBusy Lib "TVicHW32.DLL" Alias "_GetLPTBusy@4" (ByVal HW32 As Long) As Long
                 
Public Declare Function GetLPTPaperEnd Lib "TVicHW32.DLL" Alias "_GetLPTPaperEnd@4" (ByVal HW32 As Long) As Long
               
Public Declare Function GetLPTSlct Lib "TVicHW32.DLL" Alias "_GetLPTSlct@4" (ByVal HW32 As Long) As Long
                
Public Declare Function GetLPTError Lib "TVicHW32.DLL" Alias "_GetLPTError@4" (ByVal HW32 As Long) As Long
                

Public Declare Sub LPTInit Lib "TVicHW32.DLL" Alias "_LPTInit@4" (ByVal HW32 As Long)
                 
Public Declare Sub LPTSlctIn Lib "TVicHW32.DLL" Alias "_LPTSlctIn@4" (ByVal HW32 As Long)
                 
Public Declare Sub LPTStrobe Lib "TVicHW32.DLL" Alias "_LPTStrobe@4" (ByVal HW32 As Long)
                 
Public Declare Sub LPTAutofd Lib "TVicHW32.DLL" Alias "_LPTAutofd@8" (ByVal HW32 As Long, ByVal Flag As Long)

Public Declare Sub ForceIrqLPT Lib "TVicHW32.DLL" Alias "_ForceIrqLPT@8" (ByVal HW32 As Long, ByVal IrqEnable As Long)

Public Declare Function LPTPrintChar Lib "TVicHW32.DLL" Alias "_LPTPrintChar@8" (ByVal HW32 As Long, ByVal ch As Byte) As Long

Public Declare Sub GetHDDInfo Lib "TVicHW32.DLL" Alias "_GetHDDInfo@16" _
                             (ByVal HW32 As Long, _
                              ByVal IdeNumber As Integer, _
                              ByVal Master As Integer, _
                              ByRef Info As TypeHddInfo)
                 
Public Declare Function GetPciHeader Lib "TVicHW32.DLL" Alias "_GetPciHeader@24" _
                                        (ByVal HW32 As Long, _
                                         ByVal VendorId As Long, _
                                         ByVal DeviceId As Long, _
                                         ByVal OffsetInBytes As Long, _
                                         ByVal LengthInBytes As Long, _
                                         ByRef CfgInfo As Any) As Long

Public Declare Function SetPciHeader Lib "TVicHW32.DLL" Alias "_SetPciHeader@24" _
                                        (ByVal HW32 As Long, _
                                         ByVal VendorId As Long, _
                                         ByVal DeviceId As Long, _
                                         ByVal OffsetInBytes As Long, _
                                         ByVal LengthInBytes As Long, _
                                         ByRef CfgInfo As Any) As Long

Public Declare Function GetLastPciBus Lib "TVicHW32.DLL" Alias "_GetLastPciBus@4" (ByVal HW32 As Long) As Integer
                 
Public Declare Function GetHardwareMechanism Lib "TVicHW32.DLL" Alias "_GetHardwareMechanism@4" (ByVal HW32 As Long) As Integer
                 
Public Declare Function GetPciDeviceInfo Lib "TVicHW32.DLL" Alias "_GetPciDeviceInfo@20" _
                                        (ByVal HW32 As Long, _
                                         ByVal bus As Integer, _
                                         ByVal Device As Integer, _
                                         ByVal Fun As Integer, _
                                         ByRef CfgInfo As Any) As Long
                                         
'============================
'== DMA Buffer allocation
'============================

Public Declare Function GetSysDmaBuffer Lib "TVicHW32.DLL" Alias "_GetSysDmaBuffer@8" (ByVal HW32 As Long, ByRef Buf As TDmaBufferRequest) As Boolean
Public Declare Function GetBusmasterDmaBuffer Lib "TVicHW32.DLL" Alias "_GetBusmasterDmaBuffer@8" (ByVal HW32 As Long, ByRef Buf As TDmaBufferRequest) As Boolean
Public Declare Sub FreeDmaBuffer Lib "TVicHW32.DLL" Alias "_FreeDmaBuffer@8" (ByVal HW32 As Long, ByRef Buf As TDmaBufferRequest)

' ============== additional (non-TVicHW32) procedures =======
Public Sub LaunchMail()
  Call ShellExecute(GetDesktopWindow, vbNullString, "mailto:""Victor Ishikeev""<tools@entechtaiwan.com>?Subject=TVicHW32", vbNullString, vbNullString, 0)
End Sub
Public Sub LaunchWeb()
  Call ShellExecute(GetDesktopWindow, vbNullString, "http://www.entechtaiwan.com/tvicHW32.htm", vbNullString, vbNullString, 0)
End Sub


Public Function HexToInt(strMyString As String) As Long
  Dim lngMyInteger As Long
  lngMyInteger = 0
  On Error Resume Next
  lngMyInteger = "&h" & strMyString
  HexToInt = lngMyInteger
End Function

Public Function IntToHex2(MyVal As Byte) As String
  Dim s As String
  s = Hex(MyVal)
  If Len(s) = 1 Then s = "0" & s
  IntToHex2 = s
End Function
Public Function IntToHex4(MyVal As Integer) As String
  Dim s As String
  s = Hex(MyVal)
  While Len(s) < 4
    s = "0" & s
  Wend
  IntToHex4 = s
End Function
Public Function IntToHex8(MyVal As Long) As String
  Dim s As String
  s = Hex(MyVal)
  While Len(s) < 8
    s = "0" & s
  Wend
  IntToHex8 = s
End Function

