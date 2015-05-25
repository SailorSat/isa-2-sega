VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cM1COMM"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mBASE As Long
Private mADDR As Long
Private mCURR As Long

Implements cCOMM

Private Sub cCOMM_DisableCN()
  cCOMM_WriteIO &H1000, &H0
End Sub

Private Sub cCOMM_DisableFG()
  cCOMM_WriteIO &H1002, &H0
End Sub

Private Sub cCOMM_DumpMEMORY(FileNumber As Integer)
  cCOMM_Log "*** Dumping SRAM content..."
  Dim Index As Integer
  Dim DataR As Integer
  For Index = &H0 To &HFFF Step &H2
    DataR = cCOMM_ReadIO(Index)
    Put FileNumber, , DataR
  Next
  cCOMM_Log "--- done."
End Sub

Private Sub cCOMM_EnableCN()
  cCOMM_WriteIO &H1000, &H1
End Sub

Private Sub cCOMM_EnableFG()
  cCOMM_WriteIO &H1002, &H1
End Sub

Private Sub cCOMM_Init(BASE As Long)
  mBASE = BASE
  mADDR = BASE + 2
  mCURR = -1
End Sub

Private Sub cCOMM_InitMASTER()
  cCOMM_Log "*** INIT LINK (MASTER)"
  
  Dim Index As Integer
  Dim DataW As Integer
  Dim DataR As Integer
  Dim lastTickCount As Long

  ' disable CN & FG
  cCOMM_Log "* disable COMM board"
  cCOMM_DisableCN
  cCOMM_DisableFG

  ' zero memory
  cCOMM_Log "* flushing SRAM"
  cCOMM_ZeroMEMORY
  
  ' set master (&H100)
  ' begin linking (&H5)
  cCOMM_Log "* setting MASTER and LINKING PHASE"
  cCOMM_WriteIO &H0, &H105
  
  ' enable CN
  cCOMM_Log "* enable COMM board"
  cCOMM_EnableCN
  
  lastTickCount = timeGetTime
  cCOMM_Log "- waiting for link..."
  DataR = &H100
  While DataR <> &H101
    ' tick?
    cCOMM_WriteIO &H4, &H100
    
    ' read status
    DataR = cCOMM_ReadIO(&H0)
    
    Sleep 1
    DoEvents
  Wend
  
  cCOMM_Log "- linkup complete!"
  cCOMM_Log "took " & timeGetTime - lastTickCount & "ms."
  
  DataR = cCOMM_ReadIO(&H2)
  cCOMM_Log "* link size: " & (DataR And &HFF00) \ &H100
  cCOMM_Log "* link node: " & (DataR And &HFF)
End Sub

Private Sub cCOMM_InitRELAY()
  cCOMM_Log "*** INIT LINK (RELAY)"
  
  Dim Index As Integer
  Dim DataW As Integer
  Dim DataR As Integer
  Dim lastTickCount As Long

  ' disable CN & FG
  cCOMM_Log "* disable COMM board"
  cCOMM_DisableCN
  cCOMM_DisableFG

  ' zero memory
  cCOMM_Log "* flushing SRAM"
  cCOMM_ZeroMEMORY
  
  ' set relay (&H000)
  ' begin linking (&H5)
  cCOMM_Log "* setting RELAY and LINKING PHASE"
  cCOMM_WriteIO &H0, &H5
  
  ' enable CN
  cCOMM_Log "* enable COMM board"
  cCOMM_EnableCN
  
  lastTickCount = timeGetTime
  cCOMM_Log "- waiting for link..."
  DataR = &H0
  While DataR <> &H1
    ' read status
    DataR = cCOMM_ReadIO(&H0)
    
    Sleep 1
    DoEvents
  Wend
  
  cCOMM_Log "- linkup complete!"
  cCOMM_Log "took " & timeGetTime - lastTickCount & "ms."
  
  DataR = cCOMM_ReadIO(&H2)
  cCOMM_Log "* link size: " & (DataR And &HFF00) \ &H100
  cCOMM_Log "* link node: " & (DataR And &HFF)
End Sub

Private Sub cCOMM_InitSLAVE()
  cCOMM_Log "*** INIT LINK (SLAVE)"
  
  Dim Index As Integer
  Dim DataW As Integer
  Dim DataR As Integer
  Dim lastTickCount As Long

  ' disable CN & FG
  cCOMM_Log "* disable COMM board"
  cCOMM_DisableCN
  cCOMM_DisableFG

  ' zero memory
  cCOMM_Log "* flushing SRAM"
  cCOMM_ZeroMEMORY
  
  ' set slave (&H200)
  ' begin linking (&H5)
  cCOMM_Log "* setting SLAVE and LINKING PHASE"
  cCOMM_WriteIO &H0, &H205
  
  ' enable CN
  cCOMM_Log "* enable COMM board"
  cCOMM_EnableCN
  
  lastTickCount = timeGetTime
  cCOMM_Log "- waiting for link..."
  DataR = &H200
  While DataR <> &H201
    ' read status
    DataR = cCOMM_ReadIO(&H0)
    
    Sleep 1
    
    DoEvents
  Wend
  
  cCOMM_Log "- linkup complete!"
  cCOMM_Log "took " & timeGetTime - lastTickCount & "ms."
  
  DataR = cCOMM_ReadIO(&H2)
  cCOMM_Log "* link size: " & (DataR And &HFF00) \ &H100
  cCOMM_Log "* link node: " & (DataR And &HFF)
End Sub

Private Sub cCOMM_Log(Text As String)
  Debug.Print Time, Hex(mBASE), Text
End Sub

Private Sub cCOMM_ReadCN()
  Dim DataR As Integer
  DataR = cCOMM_ReadIO(&H1000)
  cCOMM_Log "Read_CN: " & Hex(DataR)
End Sub

Private Sub cCOMM_ReadFG()
  Dim DataR As Integer
  DataR = cCOMM_ReadIO(&H1002)
  cCOMM_Log "Read_FG: " & Hex(DataR)
End Sub

Private Function cCOMM_ReadIO(Address As Integer) As Integer
  If mCURR <> Address Then
    mCURR = Address
    SetPortWord HW32, mADDR, Address
  End If
  cCOMM_ReadIO = GetPortWord(HW32, mBASE)
End Function

Private Sub cCOMM_ReadSTATUS()
  Dim DataR As Integer
  DataR = cCOMM_ReadIO(&H0)
  cCOMM_Log "Read_STATUS(0): " & Hex(DataR)
  DataR = cCOMM_ReadIO(&H2)
  cCOMM_Log "Read_STATUS(2): " & Hex(DataR)
  DataR = cCOMM_ReadIO(&H4)
  cCOMM_Log "Read_STATUS(4): " & Hex(DataR)
End Sub

Private Sub cCOMM_TestMEMORY()
  Dim Index As Integer
  Dim TestH As Byte
  Dim TestL As Byte
  Dim DataW As Integer
  Dim DataR As Integer
  Dim Failed As Integer
  
  cCOMM_Log "*** Testing SRAM access.."

  ' disable CN & FG
  cCOMM_Log "* disable COMM board"
  cCOMM_DisableCN
  cCOMM_DisableFG
  
  ' fill memory
  cCOMM_Log "* writing to memory..."
  For Index = &H0 To &HFFF Step &H2
    If Index Mod &H10 = 0 Then DoEvents
    TestH = Index And &HF
    If TestH = 0 Then
      TestL = &HF
    Else
      TestL = TestH - 1
    End If
    DataW = CInt("&H" & Hex(TestH) & Hex(TestL) & Hex(TestH) & Hex(TestL))
    cCOMM_WriteIO Index, DataW
    DataR = cCOMM_ReadIO(Index)
    If DataR <> DataW Then
      cCOMM_Log "WRITE FAIL: " & Hex(Index) & ", " & Hex(DataR) & " != " & Hex(DataW)
    End If
  Next
  
  ' check memory
  cCOMM_Log "* reading from memory..."
  For Index = &H0 To &HFFF Step &H2
    If Index Mod &H10 = 0 Then DoEvents
    TestH = Index And &HF
    If TestH = 0 Then
      TestL = &HF
    Else
      TestL = TestH - 1
    End If
    DataW = CInt("&H" & Hex(TestH) & Hex(TestL) & Hex(TestH) & Hex(TestL))
    DataR = cCOMM_ReadIO(Index)
    If DataW <> DataR Then
      cCOMM_Log "READ FAIL: " & Hex(Index) & ", " & Hex(DataR) & " != " & Hex(DataW)
      Failed = Failed + 1
    End If
  Next

  cCOMM_Log "* flushing SRAM"
  cCOMM_ZeroMEMORY
  
  cCOMM_Log "--- finished with " & Failed & " errors."
End Sub

Private Sub cCOMM_TestSTATUS()
  cCOMM_Log "*** Testing STATUS changes..."
  Dim lastTickCount As Long
  Dim Index As Integer
  Dim DataS As Integer
  Dim DataR As Integer
  
  Index = 0
  While Index < 10
    DataR = cCOMM_ReadIO(&H0) And &HF
    If DataR <> DataS Then
      cCOMM_Log timeGetTime & ": " & DataS & " > " & DataR
      Index = Index + 1
    End If
    DataS = DataR
    DoEvents
  Wend
  cCOMM_Log "--- done."
End Sub

Private Sub cCOMM_WriteIO(Address As Integer, Data As Integer)
  If mCURR <> Address Then
    mCURR = Address
    SetPortWord HW32, mADDR, Address
  End If
  SetPortWord HW32, mBASE, Data
  SetPortWord HW32, mBASE, Data
End Sub

Private Sub cCOMM_ZeroMEMORY()
  Dim Index As Integer
  For Index = &H0 To &HFFF Step &H2
    cCOMM_WriteIO Index, &H0
  Next
End Sub
