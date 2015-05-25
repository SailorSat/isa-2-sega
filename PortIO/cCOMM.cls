VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCOMM"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Sub Init(BASE As Long)
End Sub

Public Sub Log(Text As String)
End Sub

Public Function ReadIO(Address As Integer) As Integer
End Function

Public Sub WriteIO(Address As Integer, Data As Integer)
End Sub

Public Sub EnableCN()
End Sub

Public Sub DisableCN()
End Sub

Public Sub ReadCN()
End Sub

Public Sub EnableFG()
End Sub

Public Sub DisableFG()
End Sub

Public Sub ReadFG()
End Sub

Public Sub ReadSTATUS()
End Sub

Public Sub TestSTATUS()
End Sub

Public Sub DumpMEMORY(FileNumber As Integer)
End Sub

Public Sub TestMEMORY()
End Sub

Public Sub ZeroMEMORY()
End Sub

Public Sub InitMaster()
End Sub

Public Sub InitSlave()
End Sub

Public Sub InitRelay()
End Sub

