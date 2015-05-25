Attribute VB_Name = "mCOMM"
Option Explicit

Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Public Declare Function GetTickCount Lib "kernel32" () As Long

Public Declare Function timeGetTime Lib "winmm.dll" () As Long
Public Declare Function timeBeginPeriod Lib "winmm.dll" (ByVal uPeriod As Long) As Long

Public HW32 As Long

Public COMM(0 To 1) As cCOMM

