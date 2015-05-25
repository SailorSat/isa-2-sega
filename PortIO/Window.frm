VERSION 5.00
Begin VB.Form Window 
   Caption         =   "Form1"
   ClientHeight    =   1560
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5415
   LinkTopic       =   "Form1"
   ScaleHeight     =   1560
   ScaleWidth      =   5415
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdTIMING 
      Caption         =   "TIMING"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   4080
      TabIndex        =   16
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton cmdRESET 
      Caption         =   "RESET"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   4080
      TabIndex        =   15
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton cmdFG_Read 
      Caption         =   "Read FG"
      Height          =   255
      Left            =   1440
      TabIndex        =   1
      Top             =   1200
      Width           =   1215
   End
   Begin VB.CommandButton cmdFG_Disable 
      Caption         =   "Disable FG"
      Height          =   255
      Left            =   1440
      TabIndex        =   5
      Top             =   960
      Width           =   1215
   End
   Begin VB.CommandButton cmdINIT_Relay 
      Caption         =   "INIT RELAY"
      Height          =   255
      Left            =   2760
      TabIndex        =   14
      Top             =   1200
      Width           =   1215
   End
   Begin VB.CommandButton cmdINIT_Slave 
      Caption         =   "INIT SLAVE"
      Height          =   255
      Left            =   2760
      TabIndex        =   13
      Top             =   960
      Width           =   1215
   End
   Begin VB.OptionButton optBoard 
      Caption         =   "Board 1"
      Height          =   255
      Index           =   1
      Left            =   1440
      TabIndex        =   12
      Top             =   360
      Width           =   1215
   End
   Begin VB.OptionButton optBoard 
      Caption         =   "Board 0"
      Height          =   255
      Index           =   0
      Left            =   1440
      TabIndex        =   11
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton cmdSTATUS_Test 
      Caption         =   "Test STATUS"
      Height          =   255
      Left            =   2760
      TabIndex        =   10
      Top             =   360
      Width           =   1215
   End
   Begin VB.CommandButton cmdSRAM_Dump 
      Caption         =   "Dump SRAM"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   360
      Width           =   1215
   End
   Begin VB.CommandButton cmdINIT_Master 
      Caption         =   "INIT MASTER"
      Height          =   255
      Left            =   2760
      TabIndex        =   8
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton cmdSTATUS_Read 
      Caption         =   "Read STATUS"
      Height          =   255
      Left            =   2760
      TabIndex        =   7
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton cmdFG_Enable 
      Caption         =   "Enable FG"
      Height          =   255
      Left            =   1440
      TabIndex        =   6
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton cmdCN_Read 
      Caption         =   "Read CN"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   1200
      Width           =   1215
   End
   Begin VB.CommandButton cmdCN_Disable 
      Caption         =   "Disable CN"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   960
      Width           =   1215
   End
   Begin VB.CommandButton cmdCN_Enable 
      Caption         =   "Enable CN"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton cmdSRAM_Test 
      Caption         =   "Test SRAM"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "Window"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Selected As Integer

Private Sub cmdCN_Disable_Click()
  COMM(Selected).DisableCN
End Sub

Private Sub cmdCN_Enable_Click()
  COMM(Selected).EnableCN
End Sub

Private Sub cmdCN_Read_Click()
  COMM(Selected).ReadCN
End Sub

Private Sub cmdFG_Disable_Click()
  COMM(Selected).DisableFG
End Sub

Private Sub cmdFG_Enable_Click()
  COMM(Selected).EnableFG
End Sub

Private Sub cmdFG_Read_Click()
  COMM(Selected).ReadFG
End Sub

Private Sub cmdINIT_Master_Click()
  COMM(Selected).InitMaster
End Sub

Private Sub cmdINIT_Relay_Click()
  COMM(Selected).InitRelay
End Sub

Private Sub cmdINIT_Slave_Click()
  COMM(Selected).InitSlave
End Sub

Private Sub cmdRESET_Click()
  Dim Index As Integer
  For Index = LBound(COMM) To UBound(COMM)
    With COMM(Index)
      .DisableCN
      .DisableFG
      .ZeroMEMORY
    End With
  Next
End Sub

Private Sub cmdSRAM_Dump_Click()
  Dim FileName As String
  Dim FileNumber As Integer
  
  FileName = App.Path & "\dump_" & Selected & ".bin"
  If Dir(FileName) <> "" Then Kill FileName
  
  FileNumber = FreeFile
  Open FileName For Binary As FileNumber
    COMM(Selected).DumpMEMORY FileNumber
  Close FileNumber
End Sub

Private Sub cmdSRAM_Test_Click()
  COMM(Selected).TestMEMORY
End Sub

Private Sub cmdSTATUS_Read_Click()
  COMM(Selected).ReadSTATUS
End Sub

Private Sub cmdSTATUS_Test_Click()
  COMM(Selected).TestSTATUS
End Sub

Private Sub Form_Load()
  HW32 = OpenTVicHW
  GetActiveHW HW32
  
  timeBeginPeriod 1
  
  Set COMM(0) = New cM1COMM
  COMM(0).Init &H300
  
  Set COMM(1) = New cM1COMM
  COMM(1).Init &H308
  
  optBoard(0).Value = True
  Selected = 0
  
  cmdRESET_Click
End Sub

Private Sub Form_Unload(Cancel As Integer)
  CloseTVicHW32 HW32
End Sub

Private Sub optBoard_Click(Index As Integer)
  Selected = Index
End Sub
