object MainForm: TMainForm
  Left = 194
  Top = 111
  Caption = '1'
  ClientHeight = 581
  ClientWidth = 734
  Color = clAppWorkSpace
  Constraints.MinHeight = 640
  Constraints.MinWidth = 750
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  FormStyle = fsMDIForm
  Padding.Left = 380
  Padding.Top = 30
  Padding.Bottom = 19
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefault
  WindowMenu = Window1
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object imgGreenBreackpoint: TImage
    Left = 338
    Top = 486
    Width = 9
    Height = 9
    Center = True
    Picture.Data = {
      07544269746D6170DE000000424DDE0000000000000036000000280000000700
      0000070000000100180000000000A80000000000000000000000000000000000
      0000E2EFF1E2EFF1008000008000008000E2EFF1E2EFF1000000E2EFF1008000
      008000008000008000008000E2EFF10000000080000080000080000080000080
      0000800000800000000000800000800000800000800000800000800000800000
      0000008000008000008000008000008000008000008000000000E2EFF1008000
      008000008000008000008000E2EFF1000000E2EFF1E2EFF10080000080000080
      00E2EFF1E2EFF1000000}
    Transparent = True
    Visible = False
  end
  object imgRedBreackpoint: TImage
    Left = 353
    Top = 486
    Width = 9
    Height = 9
    Picture.Data = {
      07544269746D6170DE000000424DDE0000000000000036000000280000000700
      0000070000000100180000000000A80000000000000000000000000000000000
      0000E2EFF1E2EFF10000FF0000FF0000FFE2EFF1E2EFF1000000E2EFF10000FF
      0000FF0000FF0000FF0000FFE2EFF10000000000FF0000FF0000FF0000FF0000
      FF0000FF0000FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF00
      00000000FF0000FF0000FF0000FF0000FF0000FF0000FF000000E2EFF10000FF
      0000FF0000FF0000FF0000FFE2EFF1000000E2EFF1E2EFF10000FF0000FF0000
      FFE2EFF1E2EFF1000000}
    Transparent = True
    Visible = False
  end
  object imgGreenDelta: TImage
    Left = 368
    Top = 486
    Width = 17
    Height = 13
    Picture.Data = {
      07544269746D617096010000424D960100000000000036000000280000000A00
      00000B0000000100180000000000600100000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      0000008000008000008000008000008000008000008000008000008000FFFFFF
      0000008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF008000FFFFFF
      0000FFFFFF008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF008000FFFFFFFFFFFF
      0000FFFFFF008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF008000FFFFFFFFFFFF
      0000FFFFFFFFFFFF008000FFFFFFFFFFFFFFFFFF008000FFFFFFFFFFFFFFFFFF
      0000FFFFFFFFFFFF008000FFFFFFFFFFFFFFFFFF008000FFFFFFFFFFFFFFFFFF
      0000FFFFFFFFFFFFFFFFFF008000FFFFFF008000FFFFFFFFFFFFFFFFFFFFFFFF
      0000FFFFFFFFFFFFFFFFFF008000FFFFFF008000FFFFFFFFFFFFFFFFFFFFFFFF
      0000FFFFFFFFFFFFFFFFFFFFFFFF008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      0000FFFFFFFFFFFFFFFFFFFFFFFF008000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      0000}
    Transparent = True
    Visible = False
  end
  object imgRedDelta: TImage
    Left = 391
    Top = 486
    Width = 17
    Height = 13
    Picture.Data = {
      07544269746D617096010000424D960100000000000036000000280000000A00
      00000B0000000100180000000000600100000000000000000000000000000000
      0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      00000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FFFFFFFF
      00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFF
      0000FFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFF
      0000FFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFF
      0000FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
      0000FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFF
      0000FFFFFFFFFFFFFFFFFF0000FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFF
      0000FFFFFFFFFFFFFFFFFF0000FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFF
      0000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      0000FFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      0000}
    Transparent = True
    Visible = False
  end
  object imgnil: TImage
    Left = 414
    Top = 481
    Width = 19
    Height = 18
    Visible = False
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 527
    Width = 368
    Height = 19
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    AutoHint = True
    Align = alCustom
    Panels = <>
    SimplePanel = True
  end
  object ToolBar2: TToolBar
    Left = 0
    Top = 0
    Width = 362
    Height = 30
    Align = alCustom
    BorderWidth = 1
    Color = clBtnFace
    Images = ImageList2
    Indent = 5
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Wrapable = False
    object ToolButton9: TToolButton
      Left = 5
      Top = 0
      Action = FileNew1
    end
    object ToolButton1: TToolButton
      Left = 28
      Top = 0
      Action = FileOpen1
    end
    object ToolButton2: TToolButton
      Left = 51
      Top = 0
      Action = FileSave1
    end
    object ToolButton3: TToolButton
      Left = 74
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object ToolButton4: TToolButton
      Left = 82
      Top = 0
      Action = EditCut1
    end
    object ToolButton5: TToolButton
      Left = 105
      Top = 0
      Action = EditCopy1
    end
    object ToolButton6: TToolButton
      Left = 128
      Top = 0
      Action = EditPaste1
    end
    object ToolButton7: TToolButton
      Left = 151
      Top = 0
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object ToolButton8: TToolButton
      Left = 159
      Top = 0
      Action = WindowCascade1
    end
    object ToolButton10: TToolButton
      Left = 182
      Top = 0
      Action = WindowTileHorizontal1
    end
    object ToolButton11: TToolButton
      Left = 205
      Top = 0
      Action = WindowTileVertical1
    end
    object ToolButton12: TToolButton
      Left = 228
      Top = 0
      Width = 8
      Caption = 'ToolButton12'
      ImageIndex = 17
      Style = tbsSeparator
    end
    object tlbRate: TToolButton
      Left = 236
      Top = 0
      Action = ActionRate
      DropdownMenu = popupRate
      OnMouseDown = tlbRateMouseDown
      OnMouseUp = tlbRateMouseUp
    end
    object tlbRun: TToolButton
      Left = 259
      Top = 0
      Action = ActionRun
    end
    object tlbPause: TToolButton
      Left = 282
      Top = 0
      Action = ActionPause
    end
    object tlbStop: TToolButton
      Left = 305
      Top = 0
      Action = ActionStop
    end
    object tlbStep: TToolButton
      Left = 328
      Top = 0
      Action = ActionStep
    end
  end
  object pnlSFR: TPanel
    Left = 0
    Top = 184
    Width = 190
    Height = 362
    Align = alCustom
    BorderStyle = bsSingle
    Color = cl3DLight
    Ctl3D = True
    DoubleBuffered = True
    ParentBackground = False
    ParentCtl3D = False
    ParentDoubleBuffered = False
    TabOrder = 2
    object Shape1: TShape
      Left = 0
      Top = 0
      Width = 186
      Height = 17
      Brush.Color = clActiveCaption
      Shape = stRoundRect
    end
    object Image1: TImage
      Left = 0
      Top = 27
      Width = 12
      Height = 12
      Hint = 'breakpoint to change/Mark'
      ParentShowHint = False
      Picture.Data = {
        07544269746D6170E6010000424DE60100000000000036000000280000000C00
        00000C0000000100180000000000B00100000000000000000000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFF
        FFFFFFFFFF0000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF0000FF
        FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
        FF0000FFFFFFFF0000FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
        FFFFFFFFFF0000FF0000FFFFFFFF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF000000FFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF
        0000FF0000FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF0000FF0000FF0000FF0000FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF0000FF0000FF0000FF0000FFFFFFFFFFFFFF000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF0000
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF}
      ShowHint = True
      Transparent = True
    end
    object Image2: TImage
      Left = 10
      Top = 17
      Width = 165
      Height = 23
      Transparent = True
    end
    object Label1: TLabel
      Left = 4
      Top = 1
      Width = 148
      Height = 13
      Caption = 'Special Function Registers'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -11
      Font.Name = 'Default'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object scrlSFR: TScrollBar
      Left = 176
      Top = 41
      Width = 9
      Height = 334
      Kind = sbVertical
      PageSize = 0
      TabOrder = 0
      OnChange = scrlSFRChange
    end
  end
  object pnlGPR: TPanel
    Left = 189
    Top = 184
    Width = 190
    Height = 355
    Align = alCustom
    BorderStyle = bsSingle
    Color = cl3DLight
    Ctl3D = True
    DoubleBuffered = True
    ParentBackground = False
    ParentCtl3D = False
    ParentDoubleBuffered = False
    TabOrder = 3
    object Shape3: TShape
      Left = 0
      Top = 0
      Width = 186
      Height = 17
      Brush.Color = clActiveCaption
      Shape = stRoundRect
    end
    object Image3: TImage
      Left = -1
      Top = 28
      Width = 12
      Height = 12
      Hint = 'breakpoint to change/Mark'
      ParentShowHint = False
      Picture.Data = {
        07544269746D6170E6010000424DE60100000000000036000000280000000C00
        00000C0000000100180000000000B00100000000000000000000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFF
        FFFFFFFFFF0000FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF0000FF
        FFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
        FF0000FFFFFFFF0000FFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFF000000FFFF
        FFFFFFFFFF0000FF0000FFFFFFFF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF000000FFFFFFFF0000FFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFF
        0000FF0000FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF0000FF0000FF0000FF0000FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF0000FF0000FF0000FF0000FFFFFFFFFFFFFF000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF0000
        00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF}
      ShowHint = True
      Transparent = True
    end
    object Image4: TImage
      Left = 10
      Top = 17
      Width = 165
      Height = 23
      Transparent = True
    end
    object Label2: TLabel
      Left = 4
      Top = 2
      Width = 150
      Height = 13
      Caption = 'General Purpose Registers'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -11
      Font.Name = 'Default'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object scrlGPR: TScrollBar
      Left = 176
      Top = 40
      Width = 9
      Height = 408
      Kind = sbVertical
      PageSize = 0
      TabOrder = 0
      OnChange = scrlGPRChange
      OnScroll = scrlGPRScroll
    end
  end
  object pnlCounters: TPanel
    Left = 0
    Top = 23
    Width = 190
    Height = 162
    BorderStyle = bsSingle
    Color = cl3DLight
    Ctl3D = True
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 4
    object Shape2: TShape
      Left = 0
      Top = 0
      Width = 186
      Height = 17
      Brush.Color = clActiveCaption
      Shape = stRoundRect
    end
    object Label3: TLabel
      Left = 4
      Top = 1
      Width = 145
      Height = 13
      Caption = 'Counters and instructions'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -11
      Font.Name = 'Default'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label4: TLabel
      Left = 2
      Top = 18
      Width = 60
      Height = 11
      Caption = 'Last instruction'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 95
      Top = 18
      Width = 63
      Height = 11
      Caption = 'Next instruction'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 1
      Top = 59
      Width = 76
      Height = 11
      Caption = 'Instruction counter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 1
      Top = 78
      Width = 62
      Height = 11
      Caption = 'Machine cycles'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 1
      Top = 101
      Width = 75
      Height = 11
      Caption = 'Real time duration'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 1
      Top = 121
      Width = 66
      Height = 11
      Caption = 'Real time speed'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 1
      Top = 140
      Width = 43
      Height = 11
      Caption = 'User timer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
    end
    object txtLast: TEdit
      Left = 0
      Top = 36
      Width = 96
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object txtNext: TEdit
      Left = 93
      Top = 36
      Width = 96
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object txtIC: TEdit
      Left = 93
      Top = 57
      Width = 94
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object txtMC: TEdit
      Left = 93
      Top = 77
      Width = 94
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
    object txtRT: TEdit
      Left = 93
      Top = 97
      Width = 94
      Height = 21
      ReadOnly = True
      TabOrder = 4
    end
    object txtRTSpeed: TEdit
      Left = 93
      Top = 116
      Width = 94
      Height = 21
      ReadOnly = True
      TabOrder = 5
    end
    object txtUserTimer: TEdit
      Left = 93
      Top = 135
      Width = 94
      Height = 21
      ReadOnly = True
      TabOrder = 6
    end
    object btnClear: TButton
      Left = 56
      Top = 137
      Width = 37
      Height = 18
      Caption = 'Clear'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = btnClearClick
    end
  end
  object pnlStack: TPanel
    Left = 189
    Top = 25
    Width = 190
    Height = 162
    Align = alCustom
    BorderStyle = bsSingle
    Color = cl3DLight
    Ctl3D = True
    DoubleBuffered = True
    ParentBackground = False
    ParentCtl3D = False
    ParentDoubleBuffered = False
    TabOrder = 5
    object Shape4: TShape
      Left = 0
      Top = 0
      Width = 186
      Height = 17
      Brush.Color = clActiveCaption
      Shape = stRoundRect
    end
    object Label10: TLabel
      Left = 6
      Top = 1
      Width = 98
      Height = 13
      Caption = 'Timers and Stack'
      Color = clActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -11
      Font.Name = 'Default'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label11: TLabel
      Left = 1
      Top = 70
      Width = 59
      Height = 11
      Caption = 'Stack Counter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
    end
    object Image5: TImage
      Left = 92
      Top = 62
      Width = 83
      Height = 23
      AutoSize = True
      Transparent = True
    end
    object prgWDT: TGauge
      Left = 61
      Top = 45
      Width = 122
      Height = 14
      Progress = 0
    end
    object Label13: TLabel
      Left = 2
      Top = 46
      Width = 45
      Height = 11
      Caption = 'WDT filling'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 1
      Top = 23
      Width = 13
      Height = 11
      Caption = 'PC'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Default'
      Font.Style = []
      ParentFont = False
    end
    object txtStackCounter: TEdit
      Left = 72
      Top = 65
      Width = 19
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object scrlStack: TScrollBar
      Left = 175
      Top = 63
      Width = 10
      Height = 92
      Kind = sbVertical
      PageSize = 0
      TabOrder = 1
    end
    object txtPChex: TEdit
      Left = 20
      Top = 19
      Width = 31
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
  end
  object MainMenu1: TMainMenu
    Images = ImageList1
    Left = 423
    Top = 504
    object File1: TMenuItem
      Caption = '&File'
      object FileNewItem: TMenuItem
        Action = FileNew1
      end
      object FileOpenItem: TMenuItem
        Action = FileOpen1
      end
      object FileCloseItem: TMenuItem
        Action = FileClose1
        Enabled = False
      end
      object FileSaveItem: TMenuItem
        Action = FileSave1
      end
      object FileSaveAsItem: TMenuItem
        Action = FileSaveAs1
        ShortCut = 49235
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object FileExportAsmItem: TMenuItem
        Action = FileExportAsm1
      end
      object FileExportHexItem: TMenuItem
        Action = FileExportHex1
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object FileExitItem: TMenuItem
        Action = FileExit1
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object CutItem: TMenuItem
        Action = EditCut1
      end
      object CopyItem: TMenuItem
        Action = EditCopy1
      end
      object PasteItem: TMenuItem
        Action = EditPaste1
      end
    end
    object Run1: TMenuItem
      Caption = '&Run'
      object ActionRate1: TMenuItem
        Action = ActionRate
        object StepByStep1: TMenuItem
          Action = ActionRateSBS
          AutoCheck = True
          RadioItem = True
        end
        object N5: TMenuItem
          Caption = '-'
        end
        object VerySlow1: TMenuItem
          Action = ActionRateVS
          AutoCheck = True
          RadioItem = True
        end
        object Slow1: TMenuItem
          Action = ActionRateSlow
          AutoCheck = True
          RadioItem = True
        end
        object Normal1: TMenuItem
          Action = ActionRateNormal
          AutoCheck = True
          RadioItem = True
        end
        object Fast1: TMenuItem
          Action = ActionRateFast
          AutoCheck = True
          RadioItem = True
        end
        object VeryFast1: TMenuItem
          Action = ActionRateVF
          AutoCheck = True
          RadioItem = True
        end
        object N6: TMenuItem
          Caption = '-'
        end
        object RealTime1: TMenuItem
          Action = ActionRateRT
          AutoCheck = True
          RadioItem = True
        end
        object VerySlow2: TMenuItem
          Action = ActionRateX2
          AutoCheck = True
          RadioItem = True
        end
        object Ultimate1: TMenuItem
          Action = ActionRateUL
          AutoCheck = True
          RadioItem = True
        end
      end
      object ActionRun1: TMenuItem
        Action = ActionRun
      end
      object Pause1: TMenuItem
        Action = ActionPause
      end
      object Stop1: TMenuItem
        Action = ActionStop
      end
      object Step1: TMenuItem
        Action = ActionStep
      end
      object ActionClearBP1: TMenuItem
        Action = ActionClearBP
      end
    end
    object Option1: TMenuItem
      Caption = '&Option'
      object mnuConfigBits: TMenuItem
        Action = OptionConfigBits1
      end
      object Action11: TMenuItem
        Action = ActionOptions
      end
    end
    object Window1: TMenuItem
      Caption = '&Window'
      object WindowCascadeItem: TMenuItem
        Action = WindowCascade1
      end
      object WindowTileItem: TMenuItem
        Action = WindowTileHorizontal1
      end
      object WindowTileItem2: TMenuItem
        Action = WindowTileVertical1
      end
      object WindowMinimizeItem: TMenuItem
        Action = WindowMinimizeAll1
      end
      object WindowArrangeItem: TMenuItem
        Action = WindowArrangeAll1
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object HelpHelp1: TMenuItem
        Action = HelpHelp
      end
      object iHelpChkUpdItem: TMenuItem
        Action = HelpChkUpdItem
      end
      object iBugReportItem: TMenuItem
        Action = BugReportItem
      end
      object HelpDonateItem: TMenuItem
        Caption = 'Donate...'
        OnClick = HelpDonateItemClick
      end
      object HelpAboutItem: TMenuItem
        Action = HelpAbout1
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'Intel HEX (*.hex)|*.hex|Assembler code (*.asm)|*.asm|ATCSS proje' +
      'ct (*.atcp)|*.atcss|All supported formats|*.hex; *.asm; *.atcss'
    FilterIndex = 4
    Title = 'Open project, asm or hex file'
    Left = 391
    Top = 504
  end
  object ActionList1: TActionList
    Images = ImageList1
    Left = 455
    Top = 504
    object FileNew1: TAction
      Category = 'File'
      Caption = '&New'
      Hint = 'New Project|Create a new project'
      ImageIndex = 6
      ShortCut = 16462
      OnExecute = FileNew1Execute
    end
    object FileOpen1: TAction
      Category = 'File'
      Caption = '&Open'
      Hint = 'Open|Open a file'
      ImageIndex = 7
      ShortCut = 16463
      OnExecute = FileOpen1Execute
    end
    object FileClose1: TWindowClose
      Category = 'File'
      Caption = '&Close'
      Hint = 'Close|Close current file'
      OnExecute = FileClose1Execute
      OnUpdate = FileClose1Update
    end
    object FileSave1: TAction
      Category = 'File'
      Caption = '&Save'
      Enabled = False
      Hint = 'Save|Save current project'
      ImageIndex = 8
      ShortCut = 16467
      OnExecute = FileSave1Execute
      OnUpdate = FileSave1Update
    end
    object FileSaveAs1: TAction
      Category = 'File'
      Caption = 'Save &As...'
      Enabled = False
      Hint = 'Save As|Save current file with different name'
      OnExecute = FileSaveAs1Execute
      OnUpdate = FileSaveAs1Update
    end
    object FileExit1: TAction
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Exit application'
      OnExecute = FileExit1Execute
    end
    object EditCut1: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 0
      ShortCut = 16472
    end
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
    end
    object EditPaste1: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 2
      ShortCut = 16470
    end
    object WindowCascade1: TWindowCascade
      Category = 'Window'
      Caption = '&Cascade'
      Hint = 'Cascade'
      ImageIndex = 17
    end
    object WindowTileHorizontal1: TWindowTileHorizontal
      Category = 'Window'
      Caption = 'Tile &Horizontally'
      Hint = 'Tile Horizontally'
      ImageIndex = 15
    end
    object WindowTileVertical1: TWindowTileVertical
      Category = 'Window'
      Caption = 'Tile &Vertically'
      Hint = 'Tile Vertically'
      ImageIndex = 16
    end
    object WindowMinimizeAll1: TWindowMinimizeAll
      Category = 'Window'
      Caption = '&Minimize All'
      Hint = 'Minimize All'
    end
    object WindowArrangeAll1: TWindowArrange
      Category = 'Window'
      Caption = '&Arrange All'
      Hint = 'Arrange All'
      OnExecute = WindowArrangeAll1Execute
    end
    object HelpAbout1: TAction
      Category = 'Help'
      Caption = '&About...'
      Hint = 
        'About|Displays program information, version number, and copyrigh' +
        't'
      OnExecute = HelpAbout1Execute
    end
    object FileExportAsm1: TAction
      Category = 'File'
      Caption = '&Export ASM text...'
      Enabled = False
      OnExecute = FileExportAsmItemClick
      OnUpdate = FileExportAsm1Update
    end
    object FileExportHex1: TAction
      Category = 'File'
      Caption = 'Export Intel &HEX file...'
      Enabled = False
      OnExecute = FileExportHexItemClick
      OnUpdate = FileExportHex1Update
    end
    object OptionConfigBits1: TAction
      Caption = 'Configuration Bits'
      Enabled = False
      OnExecute = mnuConfigBitsClick
      OnUpdate = OptionConfigBits1Update
    end
    object WindowArrange1: TWindowArrange
      Category = 'Window'
      Caption = '&Arrange'
    end
    object ActionRate: TAction
      Caption = 'R&ate'
      ImageIndex = 18
      OnExecute = ActionRateExecute
      OnUpdate = ActionRateUpdate
    end
    object WindowArrange2: TWindowArrange
      Category = 'Window'
      Caption = '&Arrange'
      Enabled = False
    end
    object ActionRun: TAction
      Caption = 'Run'
      Enabled = False
      ImageIndex = 19
      ShortCut = 120
      OnExecute = tlbRunClick
      OnUpdate = ActionRunUpdate
    end
    object ActionPause: TAction
      Caption = 'Pause'
      Enabled = False
      ImageIndex = 21
      ShortCut = 113
      OnExecute = tlbPauseClick
    end
    object ActionStop: TAction
      Caption = 'Stop'
      Enabled = False
      ImageIndex = 22
      ShortCut = 16497
      OnExecute = tlbStopClick
    end
    object ActionStep: TAction
      Caption = 'Step'
      Enabled = False
      ImageIndex = 20
      ShortCut = 119
      OnExecute = tlbStepClick
    end
    object ActionRateSBS: TAction
      AutoCheck = True
      Caption = 'Step By Step'
      OnExecute = mnuStepByStepClick
    end
    object ActionRateVS: TAction
      AutoCheck = True
      Caption = 'Very Slow'
      OnExecute = mnuVerySlowClick
    end
    object ActionRateSlow: TAction
      AutoCheck = True
      Caption = 'Slow'
      OnExecute = mnuSlowClick
    end
    object ActionRateNormal: TAction
      AutoCheck = True
      Caption = 'Normal'
      OnExecute = mnuNormalClick
    end
    object ActionRateFast: TAction
      AutoCheck = True
      Caption = 'Fast'
      OnExecute = mnuFastClick
    end
    object ActionRateVF: TAction
      AutoCheck = True
      Caption = 'Very Fast'
      OnExecute = mnuVeryfastClick
    end
    object ActionRateRT: TAction
      AutoCheck = True
      Caption = 'Real Time'
      Checked = True
      OnExecute = mnuRealTimeClick
    end
    object ActionRateX2: TAction
      AutoCheck = True
      Caption = 'X2'
      OnExecute = mnuX2Click
    end
    object ActionRateUL: TAction
      AutoCheck = True
      Caption = 'Ultimate'
      OnExecute = mnuUltimateClick
    end
    object HelpChkUpdItem: TAction
      Category = 'Window'
      Caption = 'HelpChkUpdItem'
      OnExecute = iHelpChkUpdItemClick
    end
    object BugReportItem: TAction
      Category = 'Window'
      Caption = 'BugReportItem'
      OnExecute = iBugReportItemClick
    end
    object ActionOptions: TAction
      Caption = 'Options'
      OnExecute = ActionOptionsExecute
    end
    object ActionClearBP: TAction
      Caption = 'ActionClearBP'
      ImageIndex = 23
      OnExecute = ActionClearBPExecute
      OnUpdate = ActionClearBPUpdate
    end
    object HelpHelp: TAction
      Category = 'Help'
      Caption = 'HelpHelp'
      ShortCut = 112
      OnExecute = HelpHelpExecute
    end
  end
  object ImageList1: TImageList
    Left = 487
    Top = 504
    Bitmap = {
      494C01011800C802780110001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000007000000001002000000000000070
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000028E2340000DE0F0000DE0F0000DE0F0000DE0F0000DE0F0000DE0F0010DF
      1D00000000000000000000000000000000000000000000000000D9A77D00A376
      0000A3760000A3760000D9A77D000000000000000000D9A77D00A3760000A376
      0000A3760000D9A77D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000DE
      0F0000DE0F0018E0250058E9610078ED7F0078ED7F0060EA680028E2340000DE
      0F0000DE0F0060EA680000000000000000000000000000000000A3760000D9A7
      7D00CB8C4400CB8C4400A37600000000000000000000A3760000FF9F7F00CB8C
      4400CB8C4400A37600000000000000000000BEBEBE0097979700979797009797
      9700979797009797970097979700979797009797970097979700979797009797
      9700979797009797970097979700979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000DE0F0000DE
      0F0060EA68000000000000000000000000000000000000000000000000000000
      000008DE160000DE0F0060EA6800000000000000000000000000AA7F5500FF9F
      7F00D9A77D00CB8C4400A37600000000000000000000AA7F5500FF9F7F00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200F1F1F100F1F1
      F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1
      F100F1F1F100F1F1F100F1F1F1009797970000000000484848B7B7B7B7480000
      000000000000000000004F4CECFF1823E8FF1324E6FF2D39E7FF8688EDFF0000
      000000000000CFCFCF30505050AF000000000000000008DE160000DE0F000000
      000000000000FE6650000000000000000000000000000000000000000000FD43
      28000000000008DE160000DE0F00000000000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200979797002727
      2700272727002727270027272700272727002727270027272700272727002727
      27002727270097979700F1F1F1009797970000000000F7F7F708505050AFA7A7
      A7585E5BEDFF6265EBFF032BE4FF0128E0FF0128E0FF0128E0FF0D2FE1FF3F45
      E9FFB7B7B748404040BFEFEFEF100000000040E64A0000DE0F0050E859000000
      00000000000000000000FE573E0000000000000000000000000000000000FE6D
      5800000000007FED860000DE0F0018E025000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000027272700F1F1F100979797000000000000000000F7F7F7082423
      51FF0B259EFF052DE7FF0128E0FF0128E0FF0128E0FF0128E0FF0128E0FF021C
      9BFF18174AFFEFEFEF10000000000000000008DE160000DE0F00000000000000
      0000000000000000000000000000FE4B31000000000000000000FE6D58000000
      0000000000000000000020E12C0000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000008B8BF2000B0BC1000B0BC1000B0BC1000B0BC1008B8BF2000000
      00000000000027272700F1F1F100979797000000000000000000000000006561
      EDFF05155DFF00136FFF0128E0FF0128E0FF0125D3FF0121BAFF001473FF000C
      46FF535DE0FF9693EDFF000000000000000000DE0F0028E23400000000000000
      0000000000000000000000000000FE422700FE634C00FE746000FE3619000000
      0000000000000000000050E8590000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000B0BC1000000FF000000FF000000FF000000FF000B0BC1000000
      00000000000027272700F1F1F1009797970000000000000000006B67EDFF123C
      FEFF0B34F2FF00136FFF001162FF0128E0FF0125D3FF001162FF000C46FF0128
      E0FF0229E1FF524EEDFF000000000000000000DE0F0050E85900000000000000
      0000000000000000000000000000FE290900FE21000000000000000000000000
      0000FE6650000000000078ED7F0000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000B0BC1000000FF000000FF000000FF000000FF000B0BC1000000
      00000000000027272700F1F1F1009797970000000000000000003F3BEDFF123C
      FEFF0C36F4FF0128E0FF00167DFF000F54FF001269FF001163FF0125D3FF0128
      E0FF0128E0FF2C27EDFF000000000000000000DE0F0048E75200000000000000
      000000000000FD51380000000000FE7B6800FE210000FF8F7F0000000000FE3F
      2300000000000000000078ED7F0000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000B0BC1000000FF000000FF000000FF000000FF000B0BC1000000
      00000000000027272700F1F1F1009797970000000000000000004C47EDFF1C46
      FFFF2852FFFF0128E0FF0128E0FF000934FF000521FF0026D8FF0128E0FF0128
      E0FF0128E0FF332EEDFF000000000000000000DE0F0018E02500000000000000
      00000000000000000000FE82700000000000FE210000FE311400FE3F23000000
      0000000000000000000048E7520000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000B0BC1000000FF000000FF000000FF000000FF000B0BC1000000
      00000000000027272700F1F1F1009797970000000000000000007774EDFF143E
      FFFF1C46FFFF062EE4FF000C46FF00188BFF001CA0FF000B3FFF0025D1FF042C
      E5FF022AE3FF5E5BEDFF000000000000000010DF1D0000DE0F00000000000000
      00000000000000000000FE7B6800FE210000FE2B0C00FE210000000000000000
      0000000000000000000008DE160000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000008B8BF2000B0BC1000B0BC1000B0BC1000B0BC1008B8BF2000000
      00000000000027272700F1F1F10097979700000000000000000000000000524E
      EDFF1A41EFFF0D1A50FF0420A1FF0128E0FF0128E0FF001DA7FF010B3AFF062C
      DCFF5858ECFF00000000000000000000000068EB700000DE0F0028E234000000
      000000000000000000000000000000000000FE210000FE210000FE2909000000
      00000000000048E7520000DE0F0038E443000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000027272700F1F1F10097979700000000000000000000000000807E
      DFFF1E1D3BFF1B39B7FF2B55FFFF1943FFFF264FFFFF0F38F9FF0E30CEFF1919
      2CFF6865CFFF0000000000000000000000000000000028E2340000DE0F0050E8
      590000000000000000000000000000000000FE210000FE210000FE2100000000
      00007FED860000DE0F0008DE1600000000000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200979797002727
      2700272727002727270027272700272727002727270027272700272727002727
      27002727270097979700F1F1F100979797000000000000000000DFDFDF203838
      38C77473C1FF4E49EFFF5565ECFF143EFFFF1C46FFFF5362E6FF524EEDFF7370
      CFFF404040BFCFCFCF300000000000000000000000000000000000DE0F0000DE
      0F0028E23400000000000000000000000000FF2D0D00FE210000FF2D0D0038E4
      430000DE0F0000DE0F0000000000000000000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200727272007272
      7200727272007272720072727200727272007272720072727200727272007272
      72007272720072727200727272009797970000000000D7D7D728404040BFD7D7
      D72800000000000000008481EDFF5854EDFF5854EDFF7E7BEDFF000000000000
      0000DFDFDF20404040BFCFCFCF300000000000000000000000000000000028E2
      340000DE0F0000DE0F0000DE0F0040E64A005DC83E0067950D0027C10C0000DE
      0F0010DF1D000000000000000000000000000000000000000000AA7F5500FFFF
      CC00FFFFCC00D9A77D00A37600000000000000000000AA7F5500FFFFCC00FFFF
      CC00FF9F7F00A37600000000000000000000BEBEBE00BEBEBE00BEBEBE00BEBE
      BE00BEBEBE00BEBEBE00BEBEBE00BEBEBE00BEBEBE00BEBEBE00BEBEBE00BEBE
      BE00BEBEBE00BEBEBE00BEBEBE00BEBEBE000000000068686897DFDFDF200000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFEFEF107070708F000000000000000000000000000000000000
      000078ED7F0018E0250000DE0F0000DE0F0000DE0F0000DE0F0010DF1D0058E9
      6100000000000000000000000000000000000000000000000000D9A77D00AA7F
      5500AA7F5500AA7F5500D9A77D000000000000000000D9A77D00AA7F5500AA7F
      5500AA7F5500D9A77D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000808080000000000000000000000000000000000080808000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EEEEEE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004B4B4B004B4B4B00000000000000
      0000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000081818100484848000000
      0000000000001818180000000000000000000000000000000000181818000000
      0000EEEEEE003636360081818100000000000000000000000000000000000000
      0000000000000000000000000000007F000000DF000000BF2A004B4B4B000000
      0000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000000000003B3B3B000D0D0D006060
      6000000000000000000000000000000000000000000000000000000000000000
      0000505050003B3B3B0036363600000000000000000000000000000000000000
      0000000000000000000000000000007F000000DF000000DF000000BF2A004B4B
      4B00000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000006868680036363600747474000000
      0000606060000000000000000000000000000000000000000000000000007070
      7000000000009999990036363600484848000000000000000000000000000000
      00001A1A1A001A1A1A000000B9001A1A1A0000DF000000DF000000DF000000BF
      2A004B4B4B000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF0080000000800000008000000080000000800000008000
      00008000000080000000FFFFFF00800000003B3B3B0036363600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000004E4E4E0036363600000000001A1A1A00000000000000
      B9001A1A1A001A1A1A002525FF000000FF001A1A1A0000FF09001A1A1A0000DF
      000000BF2A004B4B4B0000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF0080000000800000008000000080000000800000008000
      0000800000008000000080000000800000003636360055555500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000747474003636360000000000000000001A1A1A000000
      FF002525FF002525FF002525FF002525FF000000FF000000B90000FF090000DF
      000000DF000000BF2A004B4B4B00000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000003636360074747400000000000000
      00000000000000000000000000003C3C3C003C3C3C0000000000000000000000
      00000000000000000000999999003636360000000000000000001A1A1A000000
      FF000000FF002525FF000000FF002525FF001A1A1A001A1A1A0000DF000000FF
      090000DF000000DF000000BF2A004B4B4B000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000000000000000000000000000363636006E6E6E00404040004040
      40000000000000000000000000003C3C3C003C3C3C0079797900000000000000
      00004040400040404000646464003636360000000000000000001A1A1A000000
      FF002525FF001A1A1A001A1A1A002525FF001A1A1A001A1A1A0000FF2A0000DF
      000000FF090000DF000000DF0000007F00000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF008000
      000080000000800000008000000080000000800000008000000080000000FFFF
      FF00800000000000000000000000000000003636360048484800000000000000
      0000000000000000000000000000000000004E4E4E003C3C3C00000000000000
      000000000000000000006E6E6E003636360000000000000000001A1A1A000000
      FF002525FF001A1A1A001A1A1A002525FF000000FF000000B90000FF090000FF
      2A0000DF000055FFAA00007F0000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000004040400036363600000000000000
      000000000000000000000000000000000000000000003C3C3C00404040000000
      000000000000000000003B3B3B0036363600000000001A1A1A00000000001A1A
      1A000000FF000000FF002525FF000000FF001A1A1A0000FF09001A1A1A0000FF
      090000FF2A00007F000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      0000000000000000000000000000000000008686860036363600555555000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006E6E6E0036363600606060000000000000000000000000000000
      00001A1A1A001A1A1A001A1A1A001A1A1A00AAFF2A0000FF090000FF0900AAFF
      2A00007F00000000000000000000000000000000000080000000800000008000
      00008000000080000000FFFFFF00800000008000000080000000800000008000
      0000FFFFFF008000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000055555500363636007474
      7400000000005050500000000000000000000000000000000000505050000000
      000099999900363636003B3B3B00000000000000000000000000000000000000
      0000000000001A1A1A001A1A1A00007F0000AAFFAA0000FF0900AAFF2A00007F
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000800000008000
      00008000000080000000800000008000000080000000FFFFFF00800000000000
      0000000000000000000000000000000000000000000000000000363636003636
      3600252525000000000000000000000000000000000000000000000000002A2A
      2A00363636003636360000000000000000000000000000000000000000000000
      00001A1A1A0000000000000000001A1A1A00AAFFAA00AAFFAA00007F00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000005555
      550036363600363636003636360068686800686868003B3B3B00363636003636
      3600404040000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000007F0000AAFFAA00007F0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000949494004848480036363600363636003636360036363600404040007979
      7900000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000007F000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000C0C0C0008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080000000C0C0
      C000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C0000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000C0C0C0008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080000000C0C0C000800000008000
      000080000000000000000000000000000000000000000000000080808000C0C0
      C000FFFFFF008080800000000000800000000000000000000000000000000000
      00000000800000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000FFFFFF008080800080000000800000008000
      0000000000000000000000000000000000000000000080808000C0C0C000C0C0
      C000C0C0C000FFFFFF0080808000000000000000000000000000000000000000
      80000000800000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000808080008080800080808000C0C0C000C0C0
      C00000000000C0C0C00000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000000000000000000000000000000000000080808000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF0080808000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000FFFFFF00000000000000000000000000000080000000
      8000000080000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000FFFFFF008000000000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000FFFFFF00000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      80000000800000000000000000000000800000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C00000000000C0C0C000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00008000000080000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000080808000FFFFFF00FFFF
      FF00C0C0C000C0C0C00080808000000000000000000000000000000000000000
      0000000080000000000000000000000080000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      000000000000000000000000000000000000000000000000000080808000C0C0
      C000C0C0C0008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000008000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080000000000000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0080000000000000000000000000000000C0C0C000FFFFFF00FFFF
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFF0000FFFF0000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000080000000800000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000FFFFFF00800000000000000000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000080000000800000008000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AF611CFFAB5916FFAF611CFFB06B
      2AFFB06B2AFFB06B2AFFB06B2AFFB06B2AFFB06B2AFFB06B2AFFB06B2AFFB06B
      2AFFB06B2AFFAF611CFFAC5B18FFAC5B18FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BC7228FFE39916FF908F9DFFDBDA
      D8FFDEDCDBFFDFDEDDFFE0DFDDFFE1E0DFFFE2E1DFFFE3E2E1FFE4E3E1FFE5E3
      E2FFE1E0DEFF908F9DFFE49C1DFFB6681CFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BD762DFFE49B1EFF9594A1FFAFA4
      A6FF9A898EFF87777FFF7F7175FF6D5F66FF64575FFF55484EFF4E4249FF3C32
      39FF5F555BFF9594A1FFE59E25FFBA6B20FF00000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C37A31FFE6A32BFF9F9DAAFFDCDA
      DAFFD9D8D7FFD8D7D6FFD8D5D6FFD6D4D3FFD6D2D3FFD4D1D1FFD3D1D0FFD0CD
      CEFFD3D2D1FF9F9DAAFFE7A631FFBE7026FF00000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      000080000000000000000000000000000000C57F35FFE7A732FFA4A2AFFFB2A8
      AAFF97878BFF85757DFF7D6F73FF6C5D63FF62555DFF53464CFF4C3F47FF392F
      36FF62565DFFA4A2AFFFE9AA39FFC07327FF00000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C0008080
      80000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      000080000000000000000000000000000000C98539FFEBAE3EFFACAAB8FFF8F7
      F7FFF8F7F7FFF8F7F7FFF8F7F7FFF8F7F7FFF8F7F7FFF8F7F7FFF8F7F7FFF8F7
      F7FFF8F7F7FFACAAB8FFECB143FFC67B2CFF00000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C000FFFF00008080
      80008080800000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CB8939FFECB244FFB2AFBDFFC7C0
      C2FFB3A9ABFFA79D9FFFA0999BFF968B90FF8F858BFF847A80FF80737BFF7068
      6DFF928B8EFFB2AFBDFFEDB549FFC87D2EFF00000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C0C0C000C0C0C000C0C0C000C0C0C0008080
      8000C0C0C00000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      000080000000000000000000000000000000D09040FFEEBA50FFA6A6B5FFFEFF
      FFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFF
      FFFFFEFFFFFFA6A6B5FFEFBC56FFCD8833FF00000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000C0C0C000FFFF0000C0C0C000C0C0C0008080
      8000C0C0C00000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      000080000000000000000000000000000000D29442FFF0BF5CFFB89269FF977B
      67FF977B65FF977B65FF977B65FF977B65FF977B65FF977B65FF977B65FF977B
      65FF977B67FFB89269FFF0C163FFCF8A35FF00000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000080808000FFFF0000FFFF0000C0C0C0008080
      80008080800000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000C0C0C00000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000080000000800000000000000000000000D69A47FFEFC367FFF0C56CFFA29E
      AAFFD8D8D9FFD4D3D5FFD4D3D5FFD4D3D5FFD4D3D5FFD7D6D7FFD7D7D8FFD8D9
      DAFFA29EABFFF0C56CFFF0C56CFFD4933AFF00000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000080808000C0C0C000C0C0C0008080
      80000000000000000000000000000000000000000000FFFFFF0000000000C0C0
      C00000000000FFFFFF0000000000C0C0C00000000000C0C0C000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080000000800000008000000000000000D99D49FFF0C66CFFF0C771FFACA9
      B4FFDBD9D8FFD8D6D5FFD8D6D5FFD8D6D5FFD8D6D5FFBAB7B9FFBAB8BCFFD1D0
      D0FFAFADB5FFF0C771FFF0C771FFD8973CFF00000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C00000000000C0C0C00000000000C0C0C000C0C0
      C000C0C0C0000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      000000000000800000008000000080000000DEA64EFFF1CB74FFF2CD79FFB8B4
      BFFFE4E3E2FFE1E0DFFFE1E0DFFFE1E0DFFFE1E0DFFFA38052FFFFD97FFF918F
      9BFFC0BDC5FFF2CD79FFF2CD79FFDC9F42FF00000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000C0C0C00000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      000000000000800000008000000080000000E0A951FFF3CD79FFF4CE7DFFBCB9
      C4FFE8E7E6FFE5E4E3FFE5E4E3FFE5E4E3FFE5E4E3FF9F7E54FFFBD580FF9694
      9CFFC3C0CBFFF4CE7DFFF4CE7DFFDFA144FF00000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C00000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080000000800000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000000000000000
      000000000000800000008000000080000000E4AF54FFF4D37DFFF5D483FFC8C5
      CDFFF0F0EFFFEDEDECFFEDEDECFFEDEDECFFEDEDECFF83694AFFDCB871FF9E9B
      A1FFCCCAD4FFF5D584FFF7D98BFFE3AA59D700000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      000080000000800000008000000000000000E6B359FFF6D98DFFF5D480FFCBC8
      D0FFF4F4F3FFF1F1F0FFF1F1F0FFF1F1F0FFF1F1F0FF9D9AA0FFA09EA5FFD5D3
      D4FFCECBD3FFF8DA8DFFE8B656FFFFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      000080000000800000000000000000000000E5A942FFEBBB5CFFEBBA5CFFE7BB
      69FFE7BB69FFEABE6BFFEABE6BFFEABE6BFFEABE6BFFEABE6BFFEABE6BFFE7BB
      69FFE0AF5DFFE9B55DD7FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CB6B17FF00000000000000000000
      0000000000000000000000000000000000000000000000000000EBEBEC15D1D2
      D431000000000000000000000000000000000000000000000000000000000000
      0000D1D2D431EBEBEC15000000000000000000000000000000007A4E0DFF7C4D
      08FF7B4D08FF7B4D08FF7B4D08FF7B4D08FF7B4D08FF7B4D08FF7B4D08FF7B4D
      08FF7A4C07FF764708FF764708FF000000000000000000000000000000000000
      00000000000000000000DDDDDD22CBCBCB34FEFEFE0100000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FAF0E51DDF8604FFDF8604FF00000000000000000000
      00000000000000000000000000000000000000000000CDCED036151722FE1517
      22FE575961B7000000000000000000000000000000000000000000000000484A
      52C7151722FE151722FEBEBEC1470000000000000000000000007F5314FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF2EEE4FF7F5314FF000000000000000000000000000000000000
      000000000000E3E3E31C08A0D7FF49575DB6C2C2C23DFEFEFE01000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F3D5B258DC821AFFE28C00FFDE8505FF00000000000000000000
      000000000000000000000000000000000000E2E2E320191B25FE191B25FF191B
      25FF191B25FE595C63B7000000000000000000000000000000004B4D55C7191B
      25FE191B25FF191B25FF191B25FEE3E3E41F000000000000000090682AFFFFFF
      FFFFF2F0E8FFF2EFE3FFF2EFE5FFF2EFE5FFF2EFE5FFECE2DAFFEDE5DBFFF0E9
      E0FFE8DFCFFFE4DBCCFF835410FF000000000000000000000000000000000000
      0000E3E3E31C099BD3FE08A0D7FF48D0F5FF48575CB7C2C2C23DFEFEFE010000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E09443D0DD7E03FFE08606FFE49008FFE59307FFE18C09FFD1710DFFD8A4
      81820000000000000000000000000000000098999E731D1F28FF1D1F28FF1D1F
      28FF1D1F28FF1D1F28FE5D5E65B700000000000000004E5057C71D1F28FE1D1F
      28FF1D1F28FF1D1F28FF1D1F28FEB6B7BA5100000000000000009E7B41FFFFFF
      FFFFF5F3EDFFF5F2EDFFF5F2EDFFF5F2EDFFF5F2EDFFF5F2EBFFF4F2E7FFF5F2
      EDFFF2EFE4FFE3D9CAFF845611FF00000000000000000000000000000000E3E3
      E31C09A0D5FE3ED1FEFF08A0D7FF62DEFEFF3ECDF6FF48575CB7C3C3C33CFEFE
      FE0100000000000000000000000000000000000000000000000000000000DF84
      21F5EBB652FFE69B1DFFDD800AFFE5950FFFE79810FFE89A10FFE99C0FFFC761
      0AFFBA6533D00000000000000000000000000000000031333BEC21242CFF2124
      2CFF21242CFF21242CFF21242CFE606168B752545AC721242CFE21242CFF2124
      2CFF21242CFF21242CFE2B2D35F30000000000000000000000009E7B41FFFFFF
      FFFFF5F3EDFFF5F2EDFFF5F2EDFFF5F2EDFFF5F2EDFFF6F2EEFFF6F3EEFFF6F4
      F0FFF3F2E7FFE3D9CAFF845611FF000000000000000000000000E3E3E31C09A0
      D5FE59DDFFFF3ACEFEFF08A0D7FF68DFFFFF54DCFFFF33CBF5FF49575DB6C3C3
      C33CFEFEFE010000000000000000000000000000000000000000000000000000
      000000000000D68324FFFFE9A7FFE69415FFF3C75CFFF5CA56FFECA51EFFEDA8
      24FFF1B025FFD19D7F800000000000000000000000000000000035373EEC2528
      2FFF25282FFF25282FFF25282FFF25282FFE25282FFE25282FFF25282FFF2528
      2FFF25282FFE2F3138F3FCFCFC030000000000000000000000009E7B41FFFFFF
      FFFFF5F3EDFFF5F2EDFFF5F2EDFFF5F1ECFFF9F7F2FFF8F4F0FFFCF6F4FFFDF6
      F4FFF5EEECFFE3D9C9FF845611FF0000000000000000E3E3E31C0AA0D5FE88E6
      FFFF5ADDFFFF3ACEFFFF08A0D7FF76E3FFFF5BDDFFFF47D9FFFF29C9F6FF4A58
      5EB5C4C4C43BFEFEFE0100000000000000000000000000000000000000000000
      000000000000E8C2AA58CA6815FFF2C051FFEAAA37FFD7842BFFF4CB6AFFEEAF
      2BFFEFB02DFFA83D00FFFAF5F20D00000000000000000000000000000000383A
      41EC2A2C33FF2A2C33FF2A2C33FF2A2C33FF2A2C33FF2A2C33FF2A2C33FF2A2C
      33FE33343BF3FCFCFC03000000000000000000000000000000009E7B41FFFFFF
      FFFFF5F3EDFFF5F2EDFFF5F2EDFFF5F2ECFFF7F5EFFFFCF9F2FFFAF7F1FFFCF7
      F6FFF4ECE1FFE3DACBFF845612FF00000000E9E9E9160AA0D5FEA4ECFEFF92E9
      FFFF5BDDFEFF37CDFFFF08A0D7FF8EE8FFFF62DEFFFF4EDBFFFF39D6FEFF1FC8
      F6FF4A585EB5C4C4C43BFEFEFE01000000000000000000000000000000000000
      0000000000000000000000000000C15C0BFFF9E39FFF00000000ECD1BF43F6C3
      44FFF2BC41FFF2B838FFAC5122DD000000000000000000000000000000000000
      00003C3E44EC2E3036FF2E3036FF2E3036FF2E3036FF2E3036FF2E3036FE3638
      3FF3FCFCFC0300000000000000000000000000000000000000009C7D4EFFFFFF
      FFFFF7F4ECFFF5F2ECFFF7F4F0FFFAF4F3FFFAFAF3FFFBFAF9FFFCF7F6FFF4ED
      E9FFE9E0D4FFE2D3C4FF855915FF000000000CA1D6FDBCF1FFFFAEEEFFFF9CEB
      FFFF5BDDFEFF38CDFEFF08A0D7FFA3ECFFFF68E0FFFF55DCFFFF40D8FEFF2CD3
      FEFF17C5F5FF4E5D62B1E2E2E21D000000000000000000000000000000000000
      000000000000000000000000000000000000C86311FF0000000000000000F0B6
      39FFF4C449FFF8CC4EFFB04602FF000000000000000000000000000000000000
      00005F5F64C7323439FF323439FF323439FF323439FF323439FF323439FE6B6C
      70B7000000000000000000000000000000000000000000000000A08659FFFFFF
      FFFFFBFAF4FFF8F8EFFFFAF8F6FFFAF9F8FFFAFBF6FFF9F8F9FFF5F4EEFFEDE9
      E3FFE3DBCEFFDACAB6FF875B17FF0000000045BCE5FFC5F3FFFFB7EEFDFFA7EC
      FFFF7FE5FFFF44D5FFFF11A4D4FF96CBD9FF7ED7EEFF5BDBFDFF47D9FEFF32D5
      FEFF20D1FEFF1394C2F3D7D7D7280000000000000000F3BE3FFFF7D162FFF7D3
      62FFF0B943FF000000000000000000000000000000000000000000000000E398
      2DFFF8D261FFFAD764FFBE5D0CFF000000000000000000000000000000006263
      67C736383DFE36383DFF36383DFF36383DFF36383DFF36383DFF36383DFF3638
      3DFE6E7073B70000000000000000000000000000000000000000B1946EFFFFFF
      FFFFFCFCFBFFFAFAFBFFFAFAFBFFFAFAFBFFFCFCFAFFF2EFE5FFEEEAE3FFE4DD
      D1FFDCCDBDFFC7B695FF8A5E1DFF0000000090D2EA72ADE9FAFFA7D2DDFFABE6
      F5FFA0ECFEFF57DCFEFF1EA6AAFF126D1FFF4D8975FF4AA8BFFF45C0E1FF37CF
      F6FF25D2FEFF1394C2F3D7D7D7280000000000000000F2B937FFF9D567FFF8D4
      65FFF6CD5AFF000000000000000000000000000000000000000000000000F4C6
      52FFF9D566FFFEDF6DFFB14700FF00000000000000000000000066666AC73B3C
      40FE3B3C40FF3B3C40FF3B3C40FF3B3C40FF3B3C40FF3B3C40FF3B3C40FF3B3C
      40FF3B3C40FE727376B700000000000000000000000000000000B89E75FFFFFF
      FFFFFCFCFCFFFAFAFAFFFAFAFBFFFAFCF9FFF8F9F5FFF1EDE3FFECE8E0FFE5D8
      CFFFDAC8B7FFC1AE8FFF8B6220FF000000000000000090D2EA722A8538FF85AB
      B5FF90C8D6FF86CFE1FF34AECCFF0E920EFF109D11FF077408FF126D35FF30A5
      C1FF2CD2FDFF1394C2F3D7D7D7280000000000000000F6D38894F6D26DFFFBDD
      75FFFCDF77FFDF8A1DFFF8E8D52F0000000000000000F3E0D22FBE570AFFFCE0
      78FFFBDD75FFE29C33FFC98C6B94000000000000000069696DC73F4044FE3F40
      44FF3F4044FF3F4044FF3F4044FE47484BF34C4D51EC3F4044FF3F4044FF3F40
      44FF3F4044FF3F4044FE757578B7000000000000000000000000BCA682FFFFFF
      FFFFF7FCFCFFFAFBFBFFFAFCFAFFF4F1E6FFF1EBE2FFE0D4C3FFBDA178FFF3F1
      F0FFF2EEE4FFB89D74FF90682AFF00000000000000000000000079C97AFF1191
      11FF036C05FF057107FF0E910EFF14A614FF13A413FF12A213FF0D910DFF3BB7
      D2FF32D5FEFF1494C2F3D7D7D7280000000000000000FEFBF50CEFB233FFFCE1
      7AFFFCE27CFFF9DB6DFFDF8A1DFFE7B88C7CE4B58B7CCB660EFFFAD86BFFFCE2
      7CFFFDE37CFFA83D00FFFAF6F30C00000000BBBBBC5C434447FE434447FF4344
      47FF434447FF434447FE535357E8FCFCFC0300000000515154EC434447FF4344
      47FF434447FF434447FF434447FECBCBCC460000000000000000BCA584FFFFFF
      FFFFF9FCFCFFFCFCFCFFF8F9F4FFEFE9E0FFEEE3DAFFD1C1A9FFBDA178FFF2EE
      E4FFDCCEBDFF9E7B41FF000000000000000000000000000000002D862DF8A4E1
      A4FF36B735FF12AA12FF13AA12FF14A714FF13A513FF13A613FF2F8046FF6DDA
      F7FF39D6FFFF1495C2F3D7D7D72800000000000000000000000000000000F5D7
      80FFFFEFADFFFDE688FFFDE78AFFFEE98DFFFEEA8EFFFDE78AFFFDE688FFFFF4
      A7FFE7B052FF000000000000000000000000CCCCCD4647484AFE47484AFF4748
      4AFF47484AFE57575AE800000000000000000000000000000000545457EC4748
      4AFF47484AFF47484AFF47474AFED1D1D23F0000000000000000BEAB89FFFFFF
      FFFFFAFAFCFFF9F0E9FFF4E8E0FFE3DBD0FFDED0BDFFCAB28FFFAC9467FFB599
      6FFF9E7B41FF0000000000000000000000000000000000000000C9DCC93654A5
      54FFA8E4A8FF86D585FF51C052FF3BB83BFF20A221FF219E20FF53A5BCEAA3EC
      FFFF74E2FEFF1595C2F3D7D7D72800000000000000000000000000000000E9A4
      39E3F2C664FFFFECA0FFFFE788FFFEE689FFFEE689FFFFE88AFFFFEE96FFDF99
      3EFFB1501CE3000000000000000000000000000000009090929B4C4C4EFE4C4C
      4EFE5B5B5DE80000000000000000000000000000000000000000000000005858
      5AEC4C4C4EFF4B4B4DFE98989990000000000000000000000000BEAB89FFFFFF
      FFFFFFFFFFFFF8F5F4FFF5EDE7FFE0D7CBFFDACCB4FFC3AD86FF997B41FF9E7B
      41FF00000000000000000000000000000000000000000000000000000000E1EB
      E11E4A904ABE308830FF318931F769A1699D8FB78F71478E47C4F4F4F40B63C9
      EBE59AEAFEFF1A97C3F3D7D7D728000000000000000000000000000000000000
      000000000000ECBD8389DE9340CCDF9A35FFDD9432FFCB7735CCD9A37A890000
      0000000000000000000000000000000000000000000000000000B4B4B56A8D8D
      8EA1000000000000000000000000000000000000000000000000000000000000
      00009090919EB2B2B26D00000000000000000000000000000000C0AE8CFFBFA9
      87FFBEA886FFBFA988FFC0AA89FFBEA27BFFBEA47EFFA78D5CFF9A723AFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000EEF4EE11D7E4D728FEFEFE010000
      000060C9EBE529A4D1E6E3E3E31C000000000000000000000000000000000000
      00000000000000000000E7E7E718BBBBBB44E3E3E31C00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006F3B00FF835716FF835716FF835716FF835716FF8357
      16FF835716FF835716FF835716FF633300FF00000000000000002A79A7FF255E
      A0FF255EA0FF255EA0FF265EA0FF255D9EFF255C9FFF245C9FFF245B9DFF255C
      9EFF265E9FFF2978A6FF00000000000000000000000000000000000000000000
      0000000000000000000000000000CB6B17FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000785A4EBBC16827FFD2984BFFCC8C3BFFC894779B000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B09365FFF6F4EFFFF4F1E7FFF4F1E8FFF4F1E8FFEDE7
      DFFFF1E7E0FFF1EBE2FFEDE6D9FF8B601FFF000000004CA5FEFF48A0FEFF3091
      FFFF3091FFFF3092FFFF3091FFFF2E8FFFFF2E8EFFFF2C8EFFFF2B8DFFFF2B8C
      FFFF2B8CFFFF2D8EFFFF1282FFFF000000000000000000000000000000000000
      0000000000000000000000000000DF8604FFDF8604FFFAF0E51D000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AF612BF7C27D2AFFF6EBDA30D2B28B86B66823FFFCFAF9060000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B69D76FFF7F5EFFFF5F2EDFFF5F2EDFFF5F2EDFFF6F3
      EAFFF2F1E8FFF5F3EEFFF5EFE9FF8B601FFF000000004DA8FEFF4BA4FEFF3A9E
      FFFF3C9FFFFF3CA0FFFF3B9EFFFF399EFFFF3498FFFF3092FFFF3092FFFF2F8F
      FFFF2E8CFFFF2E8DFFFF1280FFFF000000000000000000000000000000000000
      0000000000000000000000000000DE8505FFE28C00FFDC821AFFF3D5B2580000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C87424FFBC6F28FF00000000E5E6E51ACA842FFFE6CFBE4F0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B89F75FFF7F5EFFFF5F2EDFFF5F2EDFFF5F2EDFFF5F2
      EDFFF7F2F1FFF7F5F0FFF6F5EBFF8B601FFF0000000052ACFEFF52B6FFFF47AD
      FFFF47ADFFFF47ADFFFF49AEFFFF4BB0FFFF48AEFFFF3FA4FFFF3DA1FFFF379B
      FFFF3597FFFF2F8FFFFF1280FFFF000000000000000000000000000000000000
      0000D8A48182D1710DFFE18C09FFE59307FFE49008FFE08606FFDD7E03FFE094
      43D00000000000000000000000000000000000000000CCCCCC339C9C9D63B3B1
      B250EEEEEE11B07543D9C98231FFF3F3F30C87888978CB8A35FFF5ECE4220000
      000000000000000000000000000000000000875D1EFF9F7A45FF9F7A45FF9F7A
      45FF9F7A45FF9E7843FFB69E73FFF7F5EFFFF5F2EDFFF5F2EDFFF5F2EDFFF4F1
      ECFFFBF5F3FFFBF5F2FFF6F1EFFF8B601FFF0000000054ADFEFF57BCFFFF4CB2
      FFFF4CB2FFFF4DB3FFFF50B6FFFF4EB4FFFF4DB3FFFF49AFFFFF46ABFFFF3FA2
      FFFF3A9DFFFF3090FFFF1381FFFF00000000000000000000000000000000BA65
      33D0C7610AFFE99C0FFFE89A10FFE79810FFE5950FFFDD800AFFE69B1DFFEBB6
      52FFDF8421F5000000000000000000000000E3E3E31CC16F28FFC4802EFFC679
      31F4C67B30FFBA8F61B5B6936F9EDEA250FFE0A75AFFEED4B460000000000000
      000000000000000000000000000000000000B79C71FAF8F4EFFFF6F3EBFFF6F3
      EBFFF6F5EDFFF7F1ECFFAC9164FFF7F5EFFFF5F2EDFFF4F1ECFFF7F1F0FFFAFB
      F1FFFAFBF6FFF5F0EAFFEFE7DEFF8B6121FF0000000055AEFEFF65C6FFFF53B8
      FFFF52B8FFFF52B8FFFF55BBFFFF54BAFFFF53B9FFFF51B7FFFF4EB4FFFF4AB0
      FFFF45ABFFFF3496FFFF1B87FFFF000000000000000000000000D19D7F80F1B0
      25FFEDA824FFECA51EFFF5CA56FFF3C75CFFE69415FFFFE9A7FFD68324FF0000
      000000000000000000000000000000000000BCBCBC43CE8B3DFFDBAF75B00000
      0000D3BCAF58DDA04FFFB59369AAD79543FFD89A46FF00000000000000000000
      000000000000000000000000000000000000BBA47FFAF7F3EEFFF5F2EDFFF5F2
      EDFFF5F2EDFFF8F9F2FFB4986CFFFAF7F1FFF7F5F0FFFBF7F6FFFAF7F5FFFAFB
      F8FFFBF7F6FFF0EAE4FFE7DFD4FF8D6223FF0000000055AEFEFF6BC8FFFF56BB
      FFFF55BBFFFF54B9FFFF56BBFFFF56BCFFFF56BBFFFF53B8FFFF50B6FFFF4CB3
      FFFF49AFFFFF399CFFFF1F8BFFFF0000000000000000FAF5F20DA83D00FFEFB0
      2DFFEEAF2BFFF4CB6AFFD7842BFFEAAA37FFF2C051FFCA6815FFE8C2AA580000
      000000000000000000000000000000000000EBEBEB14CB8735FFC69B68ACD6D6
      D62988888877DEA453FFE0A251FFAFA89BFF66625CFFD8CFC4FFD9D1C4FFBAB3
      A8FF9D988FE998938EA0DDDBD92900000000BBA37BFAF7F3EEFFF5F2EDFFF5F2
      EDFFF5F2EDFFFBF8F9FFBAA07BFFFCFCFCFFFAFAF6FFFAFAFAFFFAFAFBFFF5F2
      E9FFF0EEE6FFE3DCCFFFDBCDBBFF8F6526FF0000000053ADFEFF76CFFFFF5ABF
      FFFF59BFFFFF59BFFFFF58BEFFFF58BEFFFF59BFFFFF58BEFFFF56BCFFFF50B6
      FFFF4CB2FFFF3FA4FFFF2092FFFF0000000000000000AC5122DDF2B838FFF2BC
      41FFF6C344FFECD1BF4300000000F9E39FFFC15C0BFF00000000000000000000
      00000000000000000000000000000000000000000000B96725FFC6812BFF905E
      3DD8AD612AF3DFAA6AFFC3925CFFA8A197FFB4ACA0FFC8BFB3FFEDE2D4FFF9EE
      DEFFFFF5E7FFF6ECE0FFBAB3AAFF00000000BBA37BFAF7F3EEFFF5F2EDFFF5F2
      EDFFF6F3EEFFFDFAF9FFBCA47EFFFCFCFCFFFAFAFAFFFAFAFBFFFAFBF8FFF3EE
      E3FFEBE6DDFFE0CFC2FFD4C2ABFF8F6729FF0000000053ADFEFF7BD5FFFF5CC1
      FFFF5BC1FFFF5BC2FFFF5AC0FFFF59C1FFFF59C0FFFF59C0FFFF58BFFFFF53BA
      FFFF51B7FFFF42A9FFFF1C91FFFF0000000000000000B04602FFF8CC4EFFF4C4
      49FFF0B639FF0000000000000000C86311FF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F5EC
      E61E000000000000000000000000928D86EAEEE3D2FFB6AFA4C8EAE7E143C7C0
      B6D6D4CDC2FFF5EADDFFFFF7E9FFBFBAB1BABAA07AFAF8F3EEFFF6F2EDFFF7F4
      F1FFF9F4F4FFFFFFFEFFBFA988FFF9FCFCFFFAFAFAFFF7F6F0FFF2EDE5FFE7DE
      D1FFC8B497FFF0EBE7FFCCB89DFF000000000000000052ADFEFF86DAFFFF61C5
      FFFF5FC5FFFF6FE7FFFF71E6FFFF62E2FFFF62E2FFFF62E2FFFF62E2FFFF5EC4
      FFFF5EC4FFFF43AAFFFF1791FFFF0000000000000000BE5D0CFFFAD764FFF8D2
      61FFE3982DFF000000000000000000000000000000000000000000000000F0B9
      43FFF7D362FFF7D162FFF3BE3FFF000000000000000000000000000000000000
      0000000000000000000000000000817D76E3F6ECDDFFC7BEB4F3000000000000
      000000000000DDD8D070C8C0B7B5C1B8ACFFBFA988FAFBF8F4FFF9F8F1FFFCFA
      FAFFFAF9F8FFFDFFFFFFC1AC8BFFFCFCFCFFFAFBFBFFEFEDE9FFEAE3DCFFDCCC
      BCFFC1A783FFEAE1D7FFCAB595FF000000000000000052ADFEFF8BDCFFFF65CA
      FFFF63D5FFFF2D83ACFF328BC0FF2F8CC6FF2F8CC6FF2F8CC6FF2F8CC6FF62D4
      FFFF54C0FFFF43A9FFFF1790FFFF0000000000000000B14700FFFEDF6DFFF9D5
      66FFF4C652FF000000000000000000000000000000000000000000000000F6CD
      5AFFF8D465FFF9D567FFF2B937FF000000000000000000000000000000000000
      000000000000000000000000000075716BCEFEF5E7FFDDD5C9FFEEEBE7350000
      000000000000000000000000000000000000C3AE90FAFCFCFCFFFAFAF8FFFAFA
      FCFFFBFCF9FFF5F3EBFFC8B796FFFDFFFFFFF8F5F3FFEBE1D5FFDCD3C2FFCBB4
      97FFAC935EFF0000000000000000000000000000000050ACFEFF8EDFFFFF53CC
      FFFF66A3C7FFC1BBBBFFB8B0AAFFBAB0AAFFBAB0AAFFBAB0AAFFD1BBB1FF2560
      91FF3DA9FFFF43A6FFFF1E89F1FF0000000000000000C98C6B94E29C33FFFBDD
      75FFFCE078FFBE570AFFF3E0D22F0000000000000000F8E8D52FDF8A1DFFFCDF
      77FFFBDD75FFF6D26DFFF6D38894000000000000000000000000000000000000
      000000000000000000000000000088847EAEF7ECDEFFEFE7D9FFE0DAD26A0000
      000000000000000000000000000000000000C7B594FAFBFCFCFFFAFAFAFFFAFB
      F8FFF8F5EEFFC7B093FFBBA27BFFDBCFBAFFD6C6B4FFC8B99DFFC4AF8CFFB29A
      6BFFA58956FF0000000000000000000000000000000050ACFEFFB9EDFEFF74D9
      FFFF80BAD5FFF0F3F5FFDCDEDEFFDFDFE0FFDFDFE0FFDCE1E3FFFFF7F3FF286B
      98FF41A6F7FF48A8FFFF1E88F1FF0000000000000000FAF6F30CA83D00FFFDE3
      7CFFFCE27CFFFAD86BFFCB660EFFE4B58B7CE7B88C7CDF8A1DFFF9DB6DFFFCE2
      7CFFFCE17AFFEFB233FFFEFBF50C000000000000000000000000000000000000
      0000000000000000000000000000BEBCB84BD1CBC0FFFEF4E5FFD8D0C2CF0000
      000000000000000000000000000000000000CAB79BFAFCFCFCFFFAFBFBFFEEEB
      E7FFEAE2D9FFCAB598FFDCCCBCFFAC8D5CFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D9DCDDFFFFFFFFFF878787FFBCBCBCFFEEF2F3FFE1E0DFFF0000
      000000000000000000000000000000000000000000000000000000000000E7B0
      52FFFFF4A7FFFDE688FFFDE78AFFFEEA8EFFFEE98DFFFDE78AFFFDE688FFFFEF
      ADFFF5D780FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FEFEFE01A29F96D1FEF4E6FFE4DBCDF70000
      000000000000000000000000000000000000CABA9EFAFBFBFCFFF8F7F1FFEAE3
      DAFFE1D8CAFFC2A983FFCDBDA3FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E4E4E4FF8D8D8DFFC4C4C4FFE5E5E5FF000000000000
      000000000000000000000000000000000000000000000000000000000000B150
      1CE3DF993EFFFFEE96FFFFE88AFFFEE689FFFEE689FFFFE788FFFFECA0FFF2C6
      64FFE9A439E30000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D8D4CE7DC6BFB6F70000
      000000000000000000000000000000000000C0A883FFDCCFBBFFD6C7B3FFC8B8
      98FFC4AD88FFAC9261FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000979797FF989898FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D9A37A89CB7735CCDD9432FFDF9A35FFDE9340CCECBD83890000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000700000000100010000000000800300000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000F00FC183FFFFFFFFE003C1830000FFFF
      C7F1C18300009C199BE9C183000080011DE8C1831FF8C0033EDCC1831818E003
      3E1CC1831818C0033E74C1831818C0033A2CC1831818C0033D1CC1831818C003
      3C3CC1831818E0071F18C1831FF8E0078F11C1830000C003C703C18300008C31
      E007C18300009FF9F00FC183FFFFFFFFFFFFFC00F81FFFFF8003FC00F81BFF3F
      8003FC009811FE1F8003FC008FF1FE0F8003E00017E8F0078003E0003FFCA003
      8003E0003FFCC0018003E0073E7CC000800380070E30C000800380073F3CC001
      800380073F9CA0038003801F1FF8F0078003801F8BD1F80F8003801FC7E3F61F
      FFFF801FE007FE3FFFFFFFFFF00FFF7FFFF3FFFFFFFFFFFFFFE1FF3FC0078003
      FFC1FE3F80038003FF83C07F00018003F00780F700018003C00F00E700018003
      801F00C100008003801F00E600008003000F00F680008003000F81FEC0008003
      000FC3BFE0018003000FFFB7E0078003801FFFB3F0078003801FFFC1F0038003
      C03FFFF3F803FFFFF0FFFFF7FFFFFFFF0000FFFFFFFFFFFF0000000C000FF9FF
      00000008000FF9FF00000001000FF3C700000003000F73C700000003000F27FF
      00000003000F07C700000003000F00C700000003000F01E300000007000403F1
      0000000F000006380000000F00000E380000000FF8001E380000001FFC003F01
      0000003FFE047F830000007FFFFFFFFFFF7FCFF3C001FC7FFC7F87E1C001F83F
      F87F03C0C001F01FF00F0180C001E00FE0078001C001C007F803C001C0018003
      F801E003C0010001FE41F007C0010001FF61F00FC001000187E1E007C0010001
      87E1C003C001800181818001C001C00180010080C003C001E00703C0C007C001
      E00787E1C00FE001F81FCFF3C01FFF11FC7FFC00C003FEFFF83FFC008001FE3F
      F81FFC008001FE1FF91FFC008001F00F801F00008001E007003F00008001C01F
      107F00008001801F000100008001827F80010000800186FFEE000001800187E1
      FE380001800187E1FE1F000780018181FE1F000780018001FE1F00FFF81FE007
      FE1F01FFFC3FE007FF9F03FFFE7FF81F00000000000000000000000000000000
      000000000000}
  end
  object popupRate: TPopupMenu
    Left = 519
    Top = 504
    object mnuStepByStep: TMenuItem
      Action = ActionRateSBS
      AutoCheck = True
      RadioItem = True
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuVerySlow: TMenuItem
      Action = ActionRateVS
      AutoCheck = True
      RadioItem = True
    end
    object mnuSlow: TMenuItem
      Action = ActionRateSlow
      AutoCheck = True
      RadioItem = True
    end
    object mnuNormal: TMenuItem
      Action = ActionRateNormal
      AutoCheck = True
      RadioItem = True
    end
    object mnuFast: TMenuItem
      Action = ActionRateFast
      AutoCheck = True
      RadioItem = True
    end
    object mnuVeryfast: TMenuItem
      Action = ActionRateVF
      AutoCheck = True
      RadioItem = True
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mnuRealTime: TMenuItem
      Action = ActionRateRT
      AutoCheck = True
      RadioItem = True
    end
    object mnuX2: TMenuItem
      Action = ActionRateX2
      AutoCheck = True
      RadioItem = True
    end
    object mnuUltimate: TMenuItem
      Action = ActionRateUL
      AutoCheck = True
      RadioItem = True
    end
  end
  object TmrRTS: TTimer
    Enabled = False
    OnTimer = TmrRTSTimer
    Left = 384
    Top = 288
  end
  object dlgExportASM: TSaveDialog
    DefaultExt = '*.asm'
    Filter = 'Assembler source code (*.asm)|*.asm'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofEnableSizing]
    Title = 'Export assembler source code'
    Left = 616
    Top = 448
  end
  object dlgExportHex: TSaveDialog
    DefaultExt = '*.hex'
    Filter = 'Intel Hex (*.hex)|*.hex'
    Options = [ofOverwritePrompt, ofExtensionDifferent, ofPathMustExist, ofEnableSizing]
    Title = 'Export assembler source code'
    Left = 616
    Top = 496
  end
  object tmrRefresh: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tmrRefreshTimer
    Left = 456
    Top = 288
  end
  object SD: TSaveDialog
    DefaultExt = '*.atcss'
    Filter = 'ATCSS project (*.atcss)|*.atcss'
    Options = [ofOverwritePrompt, ofExtensionDifferent, ofPathMustExist, ofEnableSizing]
    Title = 'Enter the name of the file to create'
    Left = 616
    Top = 400
  end
  object ImageList2: TImageList
    ColorDepth = cd32Bit
    Left = 488
    Top = 464
    Bitmap = {
      494C010117003000280110001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000006000000001002000000000000060
      0000000000000000000000000000000000000000000000000000000000000000
      000028E2340000DE0F0000DE0F0000DE0F0000DE0F0000DE0F0000DE0F0010DF
      1D00000000000000000000000000000000000000000000000000D9A77D00A376
      0000A3760000A3760000D9A77D000000000000000000D9A77D00A3760000A376
      0000A3760000D9A77D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000DE
      0F0000DE0F0018E0250058E9610078ED7F0078ED7F0060EA680028E2340000DE
      0F0000DE0F0060EA680000000000000000000000000000000000A3760000D9A7
      7D00CB8C4400CB8C4400A37600000000000000000000A3760000FF9F7F00CB8C
      4400CB8C4400A37600000000000000000000BEBEBE0097979700979797009797
      9700979797009797970097979700979797009797970097979700979797009797
      9700979797009797970097979700979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000DE0F0000DE
      0F0060EA68000000000000000000000000000000000000000000000000000000
      000008DE160000DE0F0060EA6800000000000000000000000000AA7F5500FF9F
      7F00D9A77D00CB8C4400A37600000000000000000000AA7F5500FF9F7F00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200F1F1F100F1F1
      F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1F100F1F1
      F100F1F1F100F1F1F100F1F1F100979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000008DE160000DE0F000000
      000000000000FE6650000000000000000000000000000000000000000000FD43
      28000000000008DE160000DE0F00000000000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200979797002727
      2700272727002727270027272700272727002727270027272700272727002727
      27002727270097979700F1F1F100979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000040E64A0000DE0F0050E859000000
      00000000000000000000FE573E0000000000000000000000000000000000FE6D
      5800000000007FED860000DE0F0018E025000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000027272700F1F1F100979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000008DE160000DE0F00000000000000
      0000000000000000000000000000FE4B31000000000000000000FE6D58000000
      0000000000000000000020E12C0000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000008B8BF2000B0BC1000B0BC1000B0BC1000B0BC1008B8BF2000000
      00000000000027272700F1F1F100979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000DE0F0028E23400000000000000
      0000000000000000000000000000FE422700FE634C00FE746000FE3619000000
      0000000000000000000050E8590000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000B0BC1000000FF000000FF000000FF000000FF000B0BC1000000
      00000000000027272700F1F1F100979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000DE0F0050E85900000000000000
      0000000000000000000000000000FE290900FE21000000000000000000000000
      0000FE6650000000000078ED7F0000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000B0BC1000000FF000000FF000000FF000000FF000B0BC1000000
      00000000000027272700F1F1F100979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000DE0F0048E75200000000000000
      000000000000FD51380000000000FE7B6800FE210000FF8F7F0000000000FE3F
      2300000000000000000078ED7F0000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000B0BC1000000FF000000FF000000FF000000FF000B0BC1000000
      00000000000027272700F1F1F100979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000DE0F0018E02500000000000000
      00000000000000000000FE82700000000000FE210000FE311400FE3F23000000
      0000000000000000000048E7520000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000B0BC1000000FF000000FF000000FF000000FF000B0BC1000000
      00000000000027272700F1F1F100979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000010DF1D0000DE0F00000000000000
      00000000000000000000FE7B6800FE210000FE2B0C00FE210000000000000000
      0000000000000000000008DE160000DE0F000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000008B8BF2000B0BC1000B0BC1000B0BC1000B0BC1008B8BF2000000
      00000000000027272700F1F1F100979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000068EB700000DE0F0028E234000000
      000000000000000000000000000000000000FE210000FE210000FE2909000000
      00000000000048E7520000DE0F0038E443000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200272727000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000027272700F1F1F100979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028E2340000DE0F0050E8
      590000000000000000000000000000000000FE210000FE210000FE2100000000
      00007FED860000DE0F0008DE1600000000000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200979797002727
      2700272727002727270027272700272727002727270027272700272727002727
      27002727270097979700F1F1F100979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000DE0F0000DE
      0F0028E23400000000000000000000000000FF2D0D00FE210000FF2D0D0038E4
      430000DE0F0000DE0F0000000000000000000000000000000000AA7F5500FFFF
      CC00D9A77D00CB8C4400A37600000000000000000000AA7F5500FFFFCC00D9A7
      7D00CB8C4400A37600000000000000000000BEBEBE0072727200727272007272
      7200727272007272720072727200727272007272720072727200727272007272
      7200727272007272720072727200979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000028E2
      340000DE0F0000DE0F0000DE0F0040E64A005DC83E0067950D0027C10C0000DE
      0F0010DF1D000000000000000000000000000000000000000000AA7F5500FFFF
      CC00FFFFCC00D9A77D00A37600000000000000000000AA7F5500FFFFCC00FFFF
      CC00FF9F7F00A37600000000000000000000BEBEBE00BEBEBE00BEBEBE00BEBE
      BE00BEBEBE00BEBEBE00BEBEBE00BEBEBE00BEBEBE00BEBEBE00BEBEBE00BEBE
      BE00BEBEBE00BEBEBE00BEBEBE00BEBEBE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000078ED7F0018E0250000DE0F0000DE0F0000DE0F0000DE0F0010DF1D0058E9
      6100000000000000000000000000000000000000000000000000D9A77D00AA7F
      5500AA7F5500AA7F5500D9A77D000000000000000000D9A77D00AA7F5500AA7F
      5500AA7F5500D9A77D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000001616161754545561656568815A5A5B6A2828282A000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000000000000000000003838
      383C3331AEFD3A38C7FF6273D2FF7192DEFF798CE1FF8382F5FF8E8CF1FF5757
      5867000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004B4B4B004B4B4B00000000000000
      0000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF008000000000000000000000006F6F81AB2B29
      BAFF6FB1D8FF66B3D6FF69B5DCFF596A62FF71BDE7FF71C0E7FF80C3EBFFE1E1
      FFFF8F8F96CE0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000007F000000DF000000BF2A004B4B4B000000
      0000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000000000006E6D78983E44BFFF63B2
      D1FF576F6BFF68B6DFFF6BB5DCFF69A4BEFF72BDE7FF76C4F0FF5B6D64FF6EBE
      E9FFC4CDF3FF82828EC600000000000000000000000000000000000000000000
      0000000000000000000000000000007F000000DF000000DF000000BF2A004B4B
      4B00000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000008000000080000000111111121616B2FFA7C7C9FF5EAA
      D1FF64AFD5FF67B0D6FF6BB5DCFF6FBAE1FF72BDE6FF74BFE7FF75C1ECFF74BF
      E8FF6DBEE7FF9795F2FF4444444B000000000000000000000000000000000000
      00001A1A1A001A1A1A000000B9001A1A1A0000DF000000DF000000DF000000BF
      2A004B4B4B000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF0080000000800000008000000080000000800000008000
      00008000000080000000FFFFFF008000000058589BDDB9B6C4FF766747FFC8CC
      C7FF5CABD3FF66B0D5FF6AB4DBFF6EB8E0FF71BCE4FF73BEE7FF73BEE8FF73C0
      EAFF586253FF81BDE2FF6C69B8F500000000000000001A1A1A00000000000000
      B9001A1A1A001A1A1A002525FF000000FF001A1A1A0000FF09001A1A1A0000DF
      000000BF2A004B4B4B0000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF0080000000800000008000000080000000800000008000
      0000800000008000000080000000800000001414B4FFE7E4D4FFD0CDC3FFD0CD
      C3FFDCD5C9FF67B0D4FF68B2D7FF6BB7DFFF6EB9E0FF70BAE3FF71BBE3FF70BA
      E2FF6EBBE4FF69B7DBFF5955D8FF0909090A00000000000000001A1A1A000000
      FF002525FF002525FF002525FF002525FF000000FF000000B90000FF090000DF
      000000DF000000BF2A004B4B4B00000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000008000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000000000000000000000000000002F2EB1FFE8E6DDFFDCDAD3FFCDC9
      BEFFD3D0C6FFDED7CBFF8ABDD6FF6495A6FF6AB7E0FF6CB8E0FF6CB8E0FF6CB8
      E0FF6AB5DDFF67B4DAFF5D62D2FF3131313400000000000000001A1A1A000000
      FF000000FF002525FF000000FF002525FF001A1A1A001A1A1A0000DF000000FF
      090000DF000000DF000000BF2A004B4B4B000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000004644B6FFB2A995FFC1BBACFFDCDA
      D3FFD0CEC3FFD6D3CAFFB8AF9EFF51380DFF6296A9FF6293A4FF6293A5FF6192
      A3FF6090A1FF556B65FF5564D1FF3E3E3E4300000000000000001A1A1A000000
      FF002525FF001A1A1A001A1A1A002525FF001A1A1A001A1A1A0000FF2A0000DF
      000000FF090000DF000000DF0000007F00000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF008000
      000080000000800000008000000080000000800000008000000080000000FFFF
      FF00800000000000000000000000000000003D3DC0FFE8E4DAFFE1DFD9FFDEDC
      D5FFDBD9D1FFDCDAD2FFD7D4CBFF8E9C99FF61AED4FF63AED4FF63AED4FF62AD
      D3FF63AED3FF7BBBDAFF4044C9FF2222222300000000000000001A1A1A000000
      FF002525FF001A1A1A001A1A1A002525FF000000FF000000B90000FF090000FF
      2A0000DF000055FFAA00007F0000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000080000000FFFFFF008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000003B3BCDFFE3D9C6FFE8E6E1FFE0DE
      D7FFDDDBD4FFDBD8D0FFDCDAD2FFAEB8B5FF94C6E0FF93C5DFFF96C7E0FF99C8
      E1FF9ACCE6FF9ED0E0FF1714BAFF00000000000000001A1A1A00000000001A1A
      1A000000FF000000FF002525FF000000FF001A1A1A0000FF09001A1A1A0000FF
      090000FF2A00007F000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00800000000000
      00000000000000000000000000000000000081819BBEB4ACC2FFA59B85FFE4E3
      DDFFE0DED7FFDEDCD4FFDCDAD2FFA9B3B0FF8DC1DDFF8FC2DCFF90C3DDFF92C5
      DFFF8C9995FF8BAFE2FF525096DC000000000000000000000000000000000000
      00001A1A1A001A1A1A001A1A1A001A1A1A00AAFF2A0000FF090000FF0900AAFF
      2A00007F00000000000000000000000000000000000080000000800000008000
      00008000000080000000FFFFFF00800000008000000080000000800000008000
      0000FFFFFF008000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      000000000000000000000000000000000000000000006869F2FFDCCEBAFFE6E6
      E1FFE5E3DEFFE1DFD8FFDFDDD6FFA9B4B0FF8BC1DDFF8CC1DCFF8EC3DEFF90C3
      DDFF9ACFDEFF0B08B4FF0B0B0B0C000000000000000000000000000000000000
      0000000000001A1A1A001A1A1A00007F0000AAFFAA0000FF0900AAFF2A00007F
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000080000000800000008000
      00008000000080000000800000008000000080000000FFFFFF00800000000000
      000000000000000000000000000000000000000000004B4B4B50A0A0FEFFD8CA
      BBFFA29883FFE9E8E2FFE3E1DBFFA1A399FF8AC2E0FF8CC4E1FF818A80FF97CF
      E0FF2121BEFF5B5B5E6D00000000000000000000000000000000000000000000
      00001A1A1A0000000000000000001A1A1A00AAFFAA00AAFFAA00007F00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000000000
      00000000000000000000000000000000000000000000000000004E4E4E53FDFE
      FFFFCCC4C9FFE4DBCCFFE9E7DEFF9A9C8DFF8AC5E2FF90CADFFF85A9E1FF0F0C
      B6FF59595C690000000000000000000000000000000000000000000000000000
      0000000000000000000000000000007F0000AAFFAA00007F0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009190A1BE7B7BF6FF6E6DDEFF6668D2FF494ACCFF2724C2FF686897C80303
      0304000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000007F000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000545254D62E2A2DFF706E6F8F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000545254D62E2A2DFF706E6F8F0000000004040405101010113939
      393C3D3D3D41424242484747474E484848504747474E434343493E3E3E423A3A
      3A3D333333350606060700000001000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001C1C
      1C1D2F2D2DFF3E3A3AFF383635FF262326FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001C1C
      1C1D2F2D2DFF3E3A3AFF383635FF262326FF00000000000000000909090A9B9B
      9BFFACACACFFACACACFFACACACFFACACACFFACACACFFACACACFFACACACFFABAB
      ABFF8C8C8CC90101010200000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003331
      32FF53524FFF464442FF403E3CFF49484BD60000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003331
      32FF53524FFF464442FF403E3CFF49484BD6070707086F6F6F7E6C6C6C809C9C
      9CFFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD0D0D0FFD1D1D1FFCCCC
      CCFF898989C66969697E31313132000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C1D3D3A3AFF827B
      79FF726E6DFF434141FF414142E3000000000000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C1D3D3A3AFF827B
      79FF726E6DFF434141FF414142E3000000006A6A6A72F0F0F0FFD0D0D0FF8989
      89FFE0E0E0FFDEDEDEFFDEDEDEFFDEDEDEFFDEDEDEFFDEDEDEFFDDDDDDFFCDCD
      CDFF6D6D6DFFC7C7C7FFABABABE7000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003B3A38FF999593FF8D89
      88FF85807DFF686768A600000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003B3A38FF999593FF8D89
      88FF85807DFF686768A6000000000000000077777783F0F0F0FFCFCFCFFF5858
      58FF818181FF818181FF818181FF818181FF818181FF7D7D7DFF7A7A7AFF7171
      71FF535353FFC9C9C9FFB3B3B3F2000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00800000000000000000000000000000000000000031303032BDBC
      BCFFCDC6C0FFCBBEB3FFCBBCB2FF9A9799FF858082D5CECCC8FF878381FF7B76
      74FF6A6A6AA7000000000000000000000000000000000000000031303032BDBC
      BCFFCDC6C0FFCBBEB3FFCBBCB2FF9A9799FF858082D5CECCC8FF878381FF7B76
      74FF6A6A6AA700000000000000000000000078787884F0F0F0FFF0F0F0FFF0F0
      F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFEFEFEFFFE7E7E7FFDEDE
      DEFFD5D5D5FFCCCCCCFFB2B2B2F2000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000053535358C1BFBFFFE4C9
      A9FFECC99DFFEAC99FFFE9C89EFFDABCA1FFB7B2AAFFC6C2C1FFCDC9C8FF6B6B
      6B96000000000000000000000000000000000000000053535358C1BFBFFFE4C9
      A9FFECC99DFFEAC99FFFE9C89EFFDABCA1FFB7B2AAFFC6C2C1FFCDC9C8FF6B6B
      6B960000000000000000000000000000000076767682F0F0F0FFF0F1F2FFF0F1
      F2FFF0F1F2FFF0F1F2FFF0F1F2FFF0F1F2FFF0F1F2FFF1F1F2FFECEDEEFFE4E4
      E5FFDBDBDCFFD2D2D3FFB4B4B4F1000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000FFFFFF0080000000000000000000000000000000DDD2C6FFEFD9B0FFEFDE
      BEFFF0E0BFFFF0E0BFFFEFDEBDFFECD7B3FFECD0ACFFB6ABA4FF7C7779D80000
      00000000000000000000000000000000000000000000DDD2C6FFEFD9B0FFEFDE
      BEFFF0E0BFFFF0E0BFFFEFDEBDFFECD7B3FFECD0ACFFB6ABA4FF7C7779D80000
      0000000000000000000000000000000000006F6F6F7AD8C4B5FFB4815AFFB480
      59FFB48059FFB48059FFB48059FFB48059FFB48059FFB48059FFB48059FFB480
      59FFB48059FFB5835DFFB5B6B6EE000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000006C6A6A76EFDDBBFFF1E1C1FFF4E8
      CAFFF4EBCDFFF4EBCDFFF4E8CBFFF1E0C0FFEFDBBAFFE3CAA7FF989698FF0000
      0000000000000000000000000000000000006C6A6A76EFDDBBFFF1E1C1FFF4E8
      CAFFF4EBCDFFF4EBCDFFF4E8CBFFF1E0C0FFEFDBBAFFE3CAA7FF989698FF0000
      00000000000000000000000000000000000051515154D6BDABFFD6B9A4FFD0B0
      9AFFCBAA91FFC8A48AFFC59E83FFC29A7BFFC09777FFBF9575FFBF9574FFBF94
      74FFC19776FFBF9372FFA4A4A5D5000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00800000000000000000000000BFBBBDFFF7EFD2FFF5F1D5FFF6F1
      D5FFF6F1D6FFF6F1D6FFF6F1D5FFF5F1D5FFF5ECD0FFF1E0BFFFD3C3AAFF0000
      000000000000000000000000000000000000BFBBBDFFF7EFD2FFF5F1D5FFF6F1
      D5FFF6F1D6FFF6F1D6FFF6F1D5FFF5F1D5FFF5ECD0FFF1E0BFFFD3C3AAFF0000
      00000000000000000000000000000000000004040405D7CFCAFDC8C0BAFFC3C3
      C3FFE4E4E5FFD6D7D7FFD4D5D5FFD5D6D6FFD7D8D8FFD8D9D9FFD7D8D8FFE4E5
      E5FF9A9490FFD3BBAAFF4A4A4A4D000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00800000000000000000000000C8C4C5FFF9F4E1FFF7F2D3FFF6F1
      D8FFF7F1D8FFF7F1D8FFF6F1D8FFF6F1D5FFF5F0D5FFF4E7C7FFD5C6B0FF0000
      000000000000000000000000000000000000C8C4C5FFF9F4E1FFF7F2D3FFF6F1
      D8FFF7F1D8FFF7F1D8FFF6F1D8FFF6F1D5FFF5F0D5FFF4E7C7FFD5C6B0FF0000
      000000000000000000000000000000000000000000000000000002020203B0B0
      B0E4EEEEEEFFEAEAEAFFEAEAEAFFEAEAEAFFECECECFFEBEBEBFFEAEAEAFFEEEE
      EEFF7070707D0101010200000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00800000000000000000000000B6B0B3F1FAF6E5FFFAF5E5FFFFFE
      FCFFFFFEFCFFF8F2DEFFF8F3DDFFF7F1D9FFF6F1D7FFFBF2D5FFC4BDACFF0000
      000000000000000000000000000000000000B6B0B3F1FAF6E5FFFAF5E5FFFFFE
      FCFFFFFEFCFFF8F2DEFFF8F3DDFFF7F1D9FFF6F1D7FFFBF2D5FFC4BDACFF0000
      000000000000000000000000000000000000000000000000000000000000B2B2
      B2E3EFEFEFFFDDDDDDFFD7D7D7FFD7D7D7FFD5D5D5FFD2D2D2FFCFCFCFFFE0E0
      E0FF6F6F6F7A0000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000800000000000000000000000918D8FACFCF8E7FFFAF6E7FFFEFF
      FCFFFEFEFCFFF9F4E3FFF8F4DFFFF7F2D9FFF7F0D8FFFBF7E0FFA9A7A1FF0000
      000000000000000000000000000000000000918D8FACFCF8E7FFFAF6E7FFFEFF
      FCFFFEFEFCFFF9F4E3FFF8F4DFFFF7F2D9FFF7F0D8FFFBF7E0FFA9A7A1FF0000
      000000000000000000000000000000000000000000000000000000000000B3B3
      B3E3EFEFEFFFE0E0E0FFDBDBDBFFD9D9D9FFD6D6D6FFDBDBDBFFDEDEDEFFDCDC
      DCFF6F6F6F7B0000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000FFFFFF0080000000000000000000000000000000D1CFCDFFF8F5E7FFFBF8
      ECFFFCFAEFFFFCFAF0FFFBF8EDFFFBF7E8FFFFF9EAFFA29C9CFF6B6A6A810000
      00000000000000000000000000000000000000000000D1CFCDFFF8F5E7FFFBF8
      ECFFFCFAEFFFFCFAF0FFFBF8EDFFFBF7E8FFFFF9EAFFA29C9CFF6B6A6A810000
      000000000000000000000000000000000000000000000000000000000000B2B2
      B2E3F0F0F0FFDBDBDBFFD5D5D5FFD2D2D2FFCFCFCFFFCCCCCCFFEBEBEBFFE7E7
      E7FF1A1A1A1B0000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00008000000080000000000000000000000000000000ABA4A6E3CECCCAFFFFFD
      F2FFFEFBF1FFFDFAF0FFFDFAEDFFFFFDEEFFDFDCCEFF7E7A7CA8000000000000
      00000000000000000000000000000000000000000000ABA4A6E3CECCCAFFFFFD
      F2FFFEFBF1FFFDFAF0FFFDFAEDFFFFFDEEFFDFDCCEFF7E7A7CA8000000000000
      000000000000000000000000000000000000000000000000000000000000B3B3
      B3E2EDEDEDFFE2E2E2FFDDDDDDFFDADADAFFD9D9D9FFDCDCDCFFEAEAEAFF2D2D
      2D2E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000807F
      7F989F999BF2A6A1A1FF9E9797FF7A78799B0707070800000000000000000000
      000000000000000000000000000000000000000000000000000000000000807F
      7F989F999BF2A6A1A1FF9E9797FF7A78799B0707070800000000000000000000
      0000000000000000000000000000000000000000000000000000000000008C8C
      8CABA2A2A2C0A0A0A0C09F9F9FC09F9F9FC09E9E9EC09D9D9DC1434343450000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AF5F1AFFAB5714FFAF5F1AFFB069
      28FFB06928FFB06928FFB06928FFB06928FFB06928FFB06928FFB06928FFB069
      28FFB06928FFAF5F1AFFAC5916FFAC5916FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000545254D62E2A2DFF706E6F8F0000000000000000000000000000
      00000000000000000000B25817FFB85D17FFB65C15FFAA5114FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001D1D1D1E484848505858586D555555653A3A3A3E0909090A0000
      000000000000000000000000000000000000BC7026FFE39914FF908F9DFFDBDA
      D8FFDEDCDBFFDFDEDDFFE0DFDDFFE1E0DFFFE2E1DFFFE3E2E1FFE4E3E1FFE5E3
      E2FFE1E0DEFF908F9DFFE49C1BFFB6661AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001C1C
      1C1D2F2D2DFF3E3A3AFF383635FF262326FF000000000000000000000000D287
      2AFFB2703FE710101011BE681EFFE0A027FFE09D23FFB96018FF10101011A867
      39E7C56F16FF0000000000000000000000000000000000000000000000003C3C
      3C40717171F9C7C5C3FFF2EFEBFFEBEEF3FFEFEEEDFFCBC8C5FF666666FF6363
      638805050506000000000000000000000000BD742BFFE49B1CFF9594A1FFAFA4
      A6FF9A898EFF87757DFF7D6F73FF6B5D64FF62555DFF53464CFF4C4047FF3A30
      37FF5D5359FF9594A1FFE59E23FFBA691EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003331
      32FF53524FFF464442FF403E3CFF49484BD60000000000000000937B67A9EAB5
      40FFE3A637FFCB7B25FFDC992EFFE3A42DFFE1A22AFFD88F22FFC56E1BFFDC93
      1DFFE39E1BFF8F7565A9000000000000000000000000000000007D7D7DC4DEDC
      DAFFEFBBB3FFD22A00FFE04500FFDE5600FFE25B00FFFB6700FFFED8B4FFE7E3
      E1FF575757E7111111120000000000000000C3782FFFE6A329FF9F9DAAFFDCDA
      DAFFD9D8D7FFD8D7D6FFD8D5D6FFD6D4D3FFD6D2D3FFD4D1D1FFD3D1D0FFD0CD
      CEFFD3D2D1FF9F9DAAFFE7A62FFFBE6E24FF0000000000000000000000000000
      000000000000000000000000000000000000000000001C1C1C1D3D3A3AFF827B
      79FF726E6DFF434141FF414142E30000000000000000DB9837FFEDC353FFE9B7
      49FFE8B546FFE8B242FFE6AC33FFE6AC33FFE6AC33FFE6AC33FFE5A72FFFE1A3
      28FFE09F25FFE2A020FFCA771BFF0000000000000000818181C0FAF9F6FFCA20
      02FFD62C01FFDE4100FFD7510AFFE4F1F2FFEFECE9FFE37C00FFFD9F09FFF885
      12FFFBFAFAFF575757E70404040500000000C57D33FFE7A730FFA4A2AFFFB2A8
      AAFF97878BFF85737BFF7B6D71FF6A5B61FF60535BFF51444AFF4A3D45FF372D
      34FF60545BFFA4A2AFFFE9AA37FFC07125FF0000000000000000000000000000
      000000000000000000000000000000000000000000003B3A38FF999593FF8D89
      88FF85807DFF686768A6000000000000000000000000BE8246E7E9B74DFFEABB
      4EFFE9B94BFFEABA4BFFEABA4BFFEABA4BFFEBB641FFE7AD34FFE7AD34FFE4A5
      30FFE2A32CFFDE9924FFAF6E3DE70000000025252526D7D6D3FFD42D01FFD730
      01FFD52901FFDC3D00FFD48A61FFB2B5B5FFBDC9D0FFE07C07FFFF9A00FFFDA0
      0DFFFB7C0BFFE6E3E0FF6363638900000000C98537FFEBAE3CFFACAAB8FFF8F7
      F7FFF8F7F7FFF8F7F7FFF8F7F7FFF8F7F7FFF8F7F7FFF8F7F7FFF8F7F7FFF8F7
      F7FFF8F7F7FFACAAB8FFECB141FFC6792AFF000000000000000031303032BDBC
      BCFFCDC6C0FFCBBEB3FFCBBCB2FF9A9799FF858082D5CECCC8FF878381FF7B76
      74FF6A6A6AA70000000000000000000000000000000010101011DA9838FFEEC2
      59FFEEC259FFEDC256FFE5AB40FFB28B5FCB8E7C6A9CDE9A20FFE8AF3AFFE8AF
      3AFFE8AF3AFFCB7B24FF10101011000000007D7D7DF7F6C4B2FFDE4300FFD934
      01FFD42601FFDA3801FFDF4000FFD7AE94FFCE8A4EFFF47B00FFFA8B00FFFD94
      00FFFE9800FFFED3B2FF666666FF08080809CB8937FFECB242FFB2AFBDFFC7C0
      C2FFB3A9ABFFA79D9FFFA0999BFF968B90FF8F858BFF847880FF807179FF6E66
      6BFF928B8EFFB2AFBDFFEDB547FFC87B2CFF0000000053535358C1BFBFFFE4C9
      A9FFECC99DFFEAC99FFFE9C89EFFDABCA1FFB7B2AAFFC6C2C1FFCDC9C8FF6B6B
      6B9600000000000000000000000000000000D2872AFFD89131FFE9BB55FFEEC3
      5EFFEEC35EFFE7B446FFDE9D35FF0000000000000000B45B1BFFDE9A20FFE8B0
      3CFFE8B03CFFDE9B33FFC57122FFBB651FFFBDBDBDFFEF8050FFDF4400FFDA39
      00FFD52A01FFD72F01FFD75018FFEFE5DEFFEBE0DAFFE26200FFF37800FFF681
      00FFF68300FFF04E00FFCAC8C5FF3939393DD0903EFFEEBA4EFFA6A6B5FFFEFF
      FFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFFFFFFFEFF
      FFFFFEFFFFFFA6A6B5FFEFBC54FFCD8831FF00000000DDD2C6FFEFD9B0FFEFDE
      BEFFF0E0BFFFF0E0BFFFEFDEBDFFECD7B3FFECD0ACFFB6ABA4FF7C7779D80000
      000000000000000000000000000000000000ECCF95FFF7E4B8FFF4DC9BFFF2D5
      88FFECC156FFC8A35CDA00000000000000000000000000000000A36A43DCE3A8
      3CFFEBBA46FFE8B241FFE6AF3DFFC6721DFFE6E3E0FFF08D4EFFEC8347FFDD3C
      00FFD83201FFD32601FFD23F11FFECF6F5FFFBFFFFFFB83A00FFED6700FFEE6B
      00FFEF6D00FFEB5500FFEAE7E8FF56565668D29440FFF0BF5AFFB89267FF9779
      65FF977963FF977963FF977963FF977963FF977963FF977963FF977963FF9779
      63FF977965FFB89267FFF0C161FFCF8A33FF6C6A6A76EFDDBBFFF1E1C1FFF4E8
      CAFFF4EBCDFFF4EBCDFFF4E8CBFFF1E0C0FFEFDBBAFFE3CAA7FF989698FF0000
      000000000000000000000000000000000000ECCF94FFF7E5B9FFF6E5BAFFF6E1
      ADFFF3DCA3FFC5B184D100000000000000000000000000000000996B4EC5E7B6
      52FFEFC75DFFEDCA70FFEFC971FFE4BF82FFECE9E7FFF5A363FFED8744FFE980
      4CFFE0501EFFD52B00FFD32000FFCEDDDCFFD3D9D7FFC7B5A8FFD64800FFE858
      00FFE75900FFE55001FFE8E7F2FF5959596FD69A45FFEFC365FFF0C56AFFA29E
      AAFFD8D8D9FFD4D3D5FFD4D3D5FFD4D3D5FFD4D3D5FFD7D6D7FFD7D7D8FFD8D9
      DAFFA29EABFFF0C56AFFF0C56AFFD49338FFBFBBBDFFF7EFD2FFF5F1D5FFF6F1
      D5FFF6F1D6FFF6F1D6FFF6F1D5FFF5F1D5FFF5ECD0FFF1E0BFFFD3C3AAFF0000
      000000000000000000000000000000000000EDCE8FFFEDD096FFF6E1B1FFF8E7
      BDFFF8E7BDFFEFD18FFFBDB29BC60000000000000000B6A68FC6D3A261FFF4E0
      A9FFF4E0A9FFF0D69DFFE5C285FFE1BB7CFFE6E2DFFFF8B476FFF08D40FFEB82
      42FFE77646FFE5744BFFDF522CFFD23716FFB5BEC0FFC0C5C5FFB07458FFDD3F
      00FFDF4500FFDE5021FFEFECEBFF49494952D99D47FFF0C66AFFF0C76FFFACA9
      B4FFDBD9D8FFD8D6D5FFD8D6D5FFD8D6D5FFD8D6D5FFBAB7B9FFBAB8BCFFD1D0
      D0FFAFADB5FFF0C76FFFF0C76FFFD8973AFFC8C4C5FFF9F4E1FFF7F2D3FFF6F1
      D8FFF7F1D8FFF7F1D8FFF6F1D8FFF6F1D5FFF5F0D5FFF4E7C7FFD5C6B0FF0000
      0000000000000000000000000000000000000000000010101011EFD79FFFF9E7
      BFFFF9E7BFFFF6E2B0FFEBCB88FFA29C91A9A19A8FA8D8A869FFF0D7A1FFF4E0
      ABFFF4E0ABFFEACC8FFF1010101100000000BBBABAFFFAAB6DFFF3943CFFEF89
      3EFFEA7D40FFE77442FFE26D44FFE56E4CFFD5ACA1FFC7C6C6FFCED5D7FFD96B
      4BFFE5795AFFE57869FFC5C4C3FF18181819DEA64CFFF1CB72FFF2CD77FFB8B4
      BFFFE4E3E2FFE1E0DFFFE1E0DFFFE1E0DFFFE1E0DFFFA38050FFFFD97DFF918F
      9BFFC0BDC5FFF2CD77FFF2CD77FFDC9F40FFB6B0B3F1FAF6E5FFFAF5E5FFFFFE
      FCFFFFFEFCFFF8F2DEFFF8F3DDFFF7F1D9FFF6F1D7FFFBF2D5FFC4BDACFF0000
      00000000000000000000000000000000000000000000D9C595E7F8E9BEFFF9E9
      C1FFF8EAC2FFF8EAC2FFF8EAC2FFF8EAC2FFF7E5B6FFF7E5B6FFF7E5B6FFF7E5
      B6FFF5E1B1FFF3DEAAFFD4B98BE7000000007F7F7FFCF8DCC4FFFAC896FFF392
      3AFFEE873DFFDE7D49FFCBB5ACFFC6917AFFC6C7C8FFC3C3C3FFCCD5D7FFD960
      43FFE9907AFFF4C9C3FF727272FA00000000E0A94FFFF3CD77FFF4CE7BFFBCB9
      C4FFE8E7E6FFE5E4E3FFE5E4E3FFE5E4E3FFE5E4E3FF9F7C52FFFBD580FF9694
      9CFFC3C0CBFFF4CE7BFFF4CE7BFFDFA142FF918D8FACFCF8E7FFFAF6E7FFFEFF
      FCFFFEFEFCFFF9F4E3FFF8F4DFFFF7F2D9FFF7F0D8FFFBF7E0FFA9A7A1FF0000
      00000000000000000000000000000000000000000000F5DFACFFFAEEC8FFF9E9
      C2FFF9E9C1FFF9EAC2FFF9EAC2FFF9EAC2FFF9EAC2FFF7E5BAFFF7E8BAFFF6E3
      B5FFF6E3B4FFF6E4B5FFEFD49CFF0000000036363638CFCECDFFF5812AFFFAC7
      94FFF39238FFEACEB9FFE4E5E5FFDDDEDFFFD7D7D7FFCFD3D4FFCF9F8CFFED99
      79FFDF5A41FFDEDBD9FF3D3D3D4100000000E4AF52FFF4D37BFFF5D483FFC8C5
      CDFFF0F0EFFFEDEDECFFEDEDECFFEDEDECFFEDEDECFF836748FFDCB86FFF9E9B
      A1FFCCCAD4FFF5D584FFF7D98BFFC29A5FD700000000D1CFCDFFF8F5E7FFFBF8
      ECFFFCFAEFFFFCFAF0FFFBF8EDFFFBF7E8FFFFF9EAFFA29C9CFF6B6A6A810000
      0000000000000000000000000000000000000000000000000000A49B88A9FBEF
      CAFFF9E9C0FFF3DDA6FFF6E6B9FFF9E9C1FFF8E9C0FFF5E3B4FFF1D79FFFF6E4
      B7FFF8E9BDFFA19786A9000000000000000000000000878787CFF6F5F4FFF57B
      23FFFBD0A5FFF6AE68FFEBA264FFEDC4A7FFE8BEA2FFE79A6EFFF4BFA2FFE259
      31FFF8F6F5FF767676C30000000000000000E6B357FFF6D98DFFF5D480FFCBC8
      D0FFF4F4F3FFF1F1F0FFF1F1F0FFF1F1F0FFF1F1F0FF9D9AA0FFA09EA5FFD5D3
      D4FFCECBD3FFF8DA8DFFE8B654FF0000000000000000ABA4A6E3CECCCAFFFFFD
      F2FFFEFBF1FFFDFAF0FFFDFAEDFFFFFDEEFFDFDCCEFF7E7A7CA8000000000000
      000000000000000000000000000000000000000000000000000000000000F7E2
      B0FFDCC79BE710101011F1DA9EFFF9E9C2FFF9E9C2FFEFD599FF10101011D7C2
      93E7F2DBA6FF0000000000000000000000000000000000000000878787CFCECE
      CDFFF9DBC4FFF79B54FFFBC496FFFAC9A0FFF9BF96FFF49361FFFAD4C1FFD6D5
      D2FF828282BF000000000000000000000000E5A940FFEBBB5AFFEBBA5AFFE7BB
      67FFE7BB67FFEABE69FFEABE69FFEABE69FFEABE69FFEABE69FFEABE69FFE7BB
      67FFE0AF5BFFC7A263D70000000000000000000000000000000000000000807F
      7F989F999BF2A6A1A1FF9E9797FF7A78799B0707070800000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F3DB9FFFF2DCA1FFF2DBA0FFF1D598FF000000000000
      0000000000000000000000000000000000000000000000000000000000003838
      383A818181FBBBBABAFFE6E2E0FFEEEAE9FFE7E3E0FFBDBCBAFF7C7D7DF72121
      2122000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CB6915FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000784C0BFF7A4B
      06FF794B06FF794B06FF794B06FF794B06FF794B06FF794B06FF794B06FF794B
      06FF784A05FF744506FF744506FF000000000000000000000000000000000000
      0000000000000000000021212122313131340000000100000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001C1C1C1DDF8602FFDF8602FF00000000000000000000
      000000000000000000000000000000000000000000005A5A96CC474CBAF90000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007D5112FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF2EEE4FF7D5112FF000000000000000000000000000000000000
      0000000000001B1B1B1C06A0D7FF585F63B63939393D00000001000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000056524E58DC8218FFE28C00FFDE8503FF00000000000000000000
      000000000000000000000000000000000000343435379EACFFFF5C74FCFF323A
      A5E8000000000000000000000000000000000000000000000000000000000000
      00006262778A0000000000000000000000000000000000000000906628FFFFFF
      FFFFF2F0E8FFF2EFE3FFF2EFE5FFF2EFE5FFF2EFE5FFECE2DAFFEDE5DBFFF0E9
      E0FFE8DFCFFFE4DBCCFF83520EFF000000000000000000000000000000000000
      00001B1B1B1C089AD2FE06A0D7FF46D0F5FF576062B73939393D000000010000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BA8952D0DD7C01FFE08604FFE49006FFE59305FFE18C07FFD16F0BFF776A
      6182000000000000000000000000000000005E5F8EB55863EBFF2236E9FF0A1E
      CAFE000000000000000000000000000000000000000000000000000000000000
      00000811D8FF00000000000000000000000000000000000000009E793FFFFFFF
      FFFFF5F3EDFFF5F2EDFFF5F2EDFFF5F2EDFFF5F2EDFFF5F2EBFFF4F2E7FFF5F2
      EDFFF2EFE4FFE3D9CAFF84540FFF000000000000000000000000000000001B1B
      1B1C089FD4FE3CD1FEFF06A0D7FF60DEFEFF3CCDF6FF576062B73838383C0000
      000100000000000000000000000000000000000000000000000000000000D784
      27F5EBB650FFE69B1BFFDD8008FFE5950DFFE7980EFFE89A0EFFE99C0DFFC75F
      08FFA16947D0000000000000000000000000202020212127DDFF040FD9FF0513
      CDFF000000000000000000000000000000000000000000000000000000002228
      ABEE46499CD000000000000000000000000000000000000000009E793FFFFFFF
      FFFFF5F3EDFFF5F2EDFFF5F2EDFFF5F2EDFFF5F2EDFFF6F2EEFFF6F3EEFFF6F4
      F0FFF3F2E7FFE3D9CAFF84540FFF0000000000000000000000001B1B1B1C089F
      D4FE57DDFFFF38CEFEFF06A0D7FF66DFFFFF52DCFFFF31CBF5FF585F63B63838
      383C000000010000000000000000000000000000000000000000000000000000
      000000000000D68322FFFFE9A7FFE69413FFF3C75AFFF5CA54FFECA51CFFEDA8
      22FFF1B023FF74675F800000000000000000000000000002B7FE0004D0FF020B
      DAFF464894D000000000000000000000000000000000000000005858616B0C25
      F3FF0000000000000000000000000000000000000000000000009E793FFFFFFF
      FFFFF5F3EDFFF5F2EDFFF5F2EDFFF5F1ECFFF9F7F2FFF8F4F0FFFCF6F4FFFDF6
      F4FFF5EEECFFE3D9C9FF84540FFF00000000000000001B1B1B1C099FD4FE88E6
      FFFF58DDFFFF38CEFFFF06A0D7FF74E3FFFF59DDFFFF45D9FFFF27C9F6FF5960
      63B53737373B0000000100000000000000000000000000000000000000000000
      00000000000055504D58CA6613FFF2C04FFFEAAA35FFD78429FFF4CB68FFEEAF
      29FFEFB02BFFA83B00FF0C0C0C0D0000000000000000030303040000CFFF0002
      CDFF0108DAFF32323335000000000000000000000000151515160C2CF8FF4E50
      95C80000000000000000000000000000000000000000000000009E793FFFFFFF
      FFFFF5F3EDFFF5F2EDFFF5F2EDFFF5F2ECFFF7F5EFFFFCF9F2FFFAF7F1FFFCF7
      F6FFF4ECE1FFE3DACBFF845410FF0000000015151516099FD4FEA4ECFEFF92E9
      FFFF59DDFEFF35CDFFFF06A0D7FF8EE8FFFF60DEFFFF4CDBFFFF37D6FEFF1DC8
      F6FF596063B53737373B00000001000000000000000000000000000000000000
      0000000000000000000000000000C15A09FFF9E39FFF00000000413F3E43F6C3
      42FFF2BC3FFFF2B836FF9E5836DD00000000000000000000000055555D650000
      CFFF0000CBFF0003C7FF0000000000000000000000000924E5FF0A26E1FF0000
      00000000000000000000000000000000000000000000000000009C7B4CFFFFFF
      FFFFF7F4ECFFF5F2ECFFF7F4F0FFFAF4F3FFFAFAF3FFFBFAF9FFFCF7F6FFF4ED
      E9FFE9E0D4FFE2D3C4FF855713FF000000000CA1D4FDBCF1FFFFAEEEFFFF9CEB
      FFFF59DDFEFF36CDFEFF06A0D7FFA3ECFFFF66E0FFFF53DCFFFF3ED8FEFF2AD3
      FEFF15C5F5FF5B6264B11C1C1C1D000000000000000000000000000000000000
      000000000000000000000000000000000000C8610FFF0000000000000000F0B6
      37FFF4C447FFF8CC4CFFB04400FF000000000000000000000000000000005A5B
      66710000D1FF0000CBFF0709ACFB05050506020DD3FF0519E9FF3F3F42450000
      0000000000000000000000000000000000000000000000000000A08657FFFFFF
      FFFFFBFAF4FFF8F8EFFFFAF8F6FFFAF9F8FFFAFBF6FFF9F8F9FFF5F4EEFFEDE9
      E3FFE3DBCEFFDACAB6FF875915FF0000000043BCE5FFC5F3FFFFB7EEFDFFA7EC
      FFFF7DE5FFFF42D5FFFF0FA4D4FF96CBD9FF7CD7EEFF59DBFDFF45D9FEFF30D5
      FEFF1ED1FEFF1C92BBF3262626280000000000000000F3BE3DFFF7D160FFF7D3
      60FFF0B941FF000000000000000000000000000000000000000000000000E398
      2BFFF8D25FFFFAD762FFBE5B0AFF000000000000000000000000000000000000
      0000424244480000D0FF0000CBFF0000CBFF0004D2FF444696D2000000000000
      0000000000000000000000000000000000000000000000000000B1946CFFFFFF
      FFFFFCFCFBFFFAFAFBFFFAFAFBFFFAFAFBFFFCFCFAFFF2EFE5FFEEEAE3FFE4DD
      D1FFDCCDBDFFC7B695FF8A5C1BFF000000005B686D72ADE9FAFFA7D2DDFFABE6
      F5FFA0ECFEFF55DCFEFF1CA6AAFF106B1DFF4B8973FF48A8BFFF43C0E1FF35CF
      F6FF23D2FEFF1C92BBF3262626280000000000000000F2B935FFF9D565FFF8D4
      63FFF6CD58FF000000000000000000000000000000000000000000000000F4C6
      50FFF9D564FFFEDF6BFFB14500FF000000000000000000000000000000000000
      000000000000505092C50003D0FF0000CAFF0000BAFF00000000000000000000
      0000000000000000000000000000000000000000000000000000B89E73FFFFFF
      FFFFFCFCFCFFFAFAFAFFFAFAFBFFFAFCF9FFF8F9F5FFF1EDE3FFECE8E0FFE5D8
      CFFFDAC8B7FFC1AE8FFF8B601EFF00000000000000005B686D72288536FF85AB
      B5FF90C8D6FF86CFE1FF32AECCFF0C920CFF0E9D0FFF057206FF106B33FF2EA5
      C1FF2AD2FDFF1C92BBF326262628000000000000000090846C94F6D26BFFFBDD
      73FFFCDF75FFDF8A1BFF2E2E2D2F00000000000000002E2D2D2FBE5508FFFCE0
      76FFFBDD73FFE29C31FF816D6194000000000000000000000000000000002E2E
      2F300612CFFF0310DDFF010AD5FF0004C1FF0001D0FF0708AEFC000000000000
      0000000000000000000000000000000000000000000000000000BCA682FFFFFF
      FFFFF7FCFCFFFAFBFBFFFAFCFAFFF4F1E6FFF1EBE2FFE0D4C3FFBDA176FFF3F1
      F0FFF2EEE4FFB89D72FF906628FF00000000000000000000000077C978FF0F91
      0FFF016A03FF036F05FF0C910CFF12A612FF11A411FF10A211FF0B910BFF39B7
      D2FF30D5FEFF1C92BBF32626262800000000000000000B0B0B0CEFB231FFFCE1
      78FFFCE27AFFF9DB6BFFDF8A1BFF766B607C756A607CCB640CFFFAD869FFFCE2
      7AFFFDE37AFFA83B00FF0B0B0B0C000000000000000001010102373CB6F02D4C
      FEFF1029EDFF071CE6FF0710BDFC00000000585991B80C0FD7FF1A1CC3FF0B0B
      0B0C000000000000000000000000000000000000000000000000BCA584FFFFFF
      FFFFF9FCFCFFFCFCFCFFF8F9F4FFEFE9E0FFEEE3DAFFD1C1A9FFBDA176FFF2EE
      E4FFDCCEBDFF9E793FFF00000000000000000000000000000000308530F8A4E1
      A4FF34B733FF10AA10FF11AA10FF12A712FF11A511FF11A611FF2D8044FF6BDA
      F7FF37D6FFFF1C93BBF32626262800000000000000000000000000000000F5D7
      80FFFFEFADFFFDE688FFFDE78AFFFEE98DFFFEEA8EFFFDE78AFFFDE688FFFFF4
      A7FFE7B050FF0000000000000000000000006566A6D59EAAFFFF7488FCFF4E66
      FAFF2648FEFF1C25B1F20000000000000000000000000F0F0F102325C6FF5354
      E1FF5E5E6C790000000000000000000000000000000000000000BEAB89FFFFFF
      FFFFFAFAFCFFF9F0E9FFF4E8E0FFE3DBD0FFDED0BDFFCAB28FFFAC9465FFB599
      6DFF9E793FFF00000000000000000000000000000000000000003334333652A5
      52FFA8E4A8FF86D585FF4FC050FF39B839FF1EA21FFF1F9E1EFF579EB1EAA3EC
      FFFF72E2FEFF1D93BBF32626262800000000000000000000000000000000D19B
      45E3F2C662FFFFECA0FFFFE788FFFEE689FFFEE689FFFFE88AFFFFEE96FFDF99
      3CFFA4562EE3000000000000000000000000C5C9F2FFB3BAFEFF95A1FEFF7487
      FBFF6364839D0000000000000000000000000000000000000000000000006263
      7F966F70E2FF5C5DC5FD20202021000000000000000000000000BEAB89FFFFFF
      FFFFFFFFFFFFF8F5F4FFF5EDE7FFE0D7CBFFDACCB4FFC3AD86FF99793FFF9E79
      3FFF000000000000000000000000000000000000000000000000000000001D1D
      1D1E588058BE2E882EFF358935F76379639D5A625A71568156C40A0A0A0B65B9
      D4E59AEAFEFF2295BCF326262628000000000000000000000000000000000000
      00000000000083756589B68651CCDF9A33FFDD9430FFAA744ACC7D6E62890000
      000000000000000000000000000000000000030303048082C2ED6E6FBDEB0B0B
      0B0C000000000000000000000000000000000000000000000000000000000000
      00000000000064647C905A5CC4F94D4E94C80000000000000000C0AE8CFFBFA9
      87FFBEA886FFBFA988FFC0AA89FFBEA279FFBEA47CFFA78D5AFF9A7038FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001010101126272628000000010000
      000063B9D4E5369CC0E61B1B1B1C000000000000000000000000000000000000
      00000000000000000000171717183E3E3E441B1B1B1C00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006D3900FF835514FF835514FF835514FF835514FF8355
      14FF835514FF835514FF835514FF613100FF00000000000000002877A7FF235C
      A0FF235CA0FF235CA0FF245CA0FF235B9EFF235A9FFF225A9FFF22599DFF235A
      9EFF245C9FFF2776A6FF00000000000000000000000000000000000000000000
      0000000000000000000000000000CB6915FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000071615ABBC16625FFD29849FFCC8C39FF8673689B000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B09363FFF6F4EFFFF4F1E7FFF4F1E8FFF4F1E8FFEDE7
      DFFFF1E7E0FFF1EBE2FFEDE6D9FF8B5E1DFF000000004AA5FEFF46A0FEFF2E91
      FFFF2E91FFFF2E92FFFF2E91FFFF2C8FFFFF2C8EFFFF2A8EFFFF298DFFFF298C
      FFFF298CFFFF2B8EFFFF1082FFFF000000000000000000000000000000000000
      0000000000000000000000000000DF8602FFDF8602FF1C1C1C1D000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AB612FF7C27B28FF2F2F2E3079706686B66621FF050505060000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B69D74FFF7F5EFFFF5F2EDFFF5F2EDFFF5F2EDFFF6F3
      EAFFF2F1E8FFF5F3EEFFF5EFE9FF8B5E1DFF000000004BA8FEFF49A4FEFF389E
      FFFF3A9FFFFF3AA0FFFF399EFFFF379EFFFF3298FFFF2E92FFFF2E92FFFF2D8F
      FFFF2C8CFFFF2C8DFFFF1080FFFF000000000000000000000000000000000000
      0000000000000000000000000000DE8503FFE28C00FFDC8218FF56524E580000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C87222FFBC6D26FF000000001919191ACA842DFF4C4A484F0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B89F73FFF7F5EFFFF5F2EDFFF5F2EDFFF5F2EDFFF5F2
      EDFFF7F2F1FFF7F5F0FFF6F5EBFF8B5E1DFF0000000050ACFEFF50B6FFFF45AD
      FFFF45ADFFFF45ADFFFF47AEFFFF49B0FFFF46AEFFFF3DA4FFFF3BA1FFFF359B
      FFFF3397FFFF2D8FFFFF1080FFFF000000000000000000000000000000000000
      0000776A6182D16F0BFFE18C07FFE59305FFE49006FFE08604FFDD7C01FFBA89
      52D0000000000000000000000000000000000000000030303033535354634848
      485010101011A0744FD9C9822FFF0B0B0B0C5D5D5D78CB8A33FF212121220000
      000000000000000000000000000000000000875B1CFF9F7843FF9F7843FF9F78
      43FF9F7843FF9E7641FFB69E71FFF7F5EFFFF5F2EDFFF5F2EDFFF5F2EDFFF4F1
      ECFFFBF5F3FFFBF5F2FFF6F1EFFF8B5E1DFF0000000052ADFEFF55BCFFFF4AB2
      FFFF4AB2FFFF4BB3FFFF4EB6FFFF4CB4FFFF4BB3FFFF47AFFFFF44ABFFFF3DA2
      FFFF389DFFFF2E90FFFF1181FFFF00000000000000000000000000000000A169
      47D0C75F08FFE99C0DFFE89A0EFFE7980EFFE5950DFFDD8008FFE69B1BFFEBB6
      50FFD78427F50000000000000000000000001B1B1B1CC16D26FFC4802CFFBF78
      36F4C6792EFF927C65B58174669EDEA24EFFE0A758FF5D595560000000000000
      000000000000000000000000000000000000B49B70FAF8F4EFFFF6F3EBFFF6F3
      EBFFF6F5EDFFF7F1ECFFAC9162FFF7F5EFFFF5F2EDFFF4F1ECFFF7F1F0FFFAFB
      F1FFFAFBF6FFF5F0EAFFEFE7DEFF8B5F1FFF0000000053AEFEFF63C6FFFF51B8
      FFFF50B8FFFF50B8FFFF53BBFFFF52BAFFFF51B9FFFF4FB7FFFF4CB4FFFF48B0
      FFFF43ABFFFF3296FFFF1987FFFF00000000000000000000000074675F80F1B0
      23FFEDA822FFECA51CFFF5CA54FFF3C75AFFE69413FFFFE9A7FFD68322FF0000
      0000000000000000000000000000000000003E3E3E43CE8B3BFF9E8A6EB00000
      0000524F4E58DDA04DFF887A66AAD79541FFD89A44FF00000000000000000000
      000000000000000000000000000000000000B8A37EFAF7F3EEFFF5F2EDFFF5F2
      EDFFF5F2EDFFF8F9F2FFB4986AFFFAF7F1FFF7F5F0FFFBF7F6FFFAF7F5FFFAFB
      F8FFFBF7F6FFF0EAE4FFE7DFD4FF8D6021FF0000000053AEFEFF69C8FFFF54BB
      FFFF53BBFFFF52B9FFFF54BBFFFF54BCFFFF54BBFFFF51B8FFFF4EB6FFFF4AB3
      FFFF47AFFFFF379CFFFF1D8BFFFF00000000000000000C0C0C0DA83B00FFEFB0
      2BFFEEAF29FFF4CB68FFD78429FFEAAA35FFF2C04FFFCA6613FF55504D580000
      00000000000000000000000000000000000013131314CB8733FF917E66AC2727
      27295C5C5C77DEA451FFE0A24FFFAFA89BFF64605AFFD8CFC4FFD9D1C4FFBAB3
      A8FF97938CE9777573A02828272900000000B8A27AFAF7F3EEFFF5F2EDFFF5F2
      EDFFF5F2EDFFFBF8F9FFBAA079FFFCFCFCFFFAFAF6FFFAFAFAFFFAFAFBFFF5F2
      E9FFF0EEE6FFE3DCCFFFDBCDBBFF8F6324FF0000000051ADFEFF74CFFFFF58BF
      FFFF57BFFFFF57BFFFFF56BEFFFF56BEFFFF57BFFFFF56BEFFFF54BCFFFF4EB6
      FFFF4AB2FFFF3DA4FFFF1E92FFFF00000000000000009E5836DDF2B836FFF2BC
      3FFFF6C342FF413F3E4300000000F9E39FFFC15A09FF00000000000000000000
      00000000000000000000000000000000000000000000B96523FFC68129FF8863
      4BD8A86230F3DFAA68FFC3925AFFA8A197FFB4ACA0FFC8BFB3FFEDE2D4FFF9EE
      DEFFFFF5E7FFF6ECE0FFBAB3AAFF00000000B8A27AFAF7F3EEFFF5F2EDFFF5F2
      EDFFF6F3EEFFFDFAF9FFBCA47CFFFCFCFCFFFAFAFAFFFAFAFBFFFAFBF8FFF3EE
      E3FFEBE6DDFFE0CFC2FFD4C2ABFF8F6527FF0000000051ADFEFF79D5FFFF5AC1
      FFFF59C1FFFF59C2FFFF58C0FFFF57C1FFFF57C0FFFF57C0FFFF56BFFFFF51BA
      FFFF4FB7FFFF40A9FFFF1A91FFFF0000000000000000B04400FFF8CC4CFFF4C4
      47FFF0B637FF0000000000000000C8610FFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001D1D
      1D1E0000000000000000000000008E8A84EAEEE3D2FF9A968FC841414043AEA9
      A2D6D4CDC2FFF5EADDFFFFF7E9FF979490BAB79F79FAF8F3EEFFF6F2EDFFF7F4
      F1FFF9F4F4FFFFFFFEFFBFA988FFF9FCFCFFFAFAFAFFF7F6F0FFF2EDE5FFE7DE
      D1FFC8B497FFF0EBE7FFCCB89DFF000000000000000050ADFEFF86DAFFFF5FC5
      FFFF5DC5FFFF6DE7FFFF6FE6FFFF60E2FFFF60E2FFFF60E2FFFF60E2FFFF5CC4
      FFFF5CC4FFFF41AAFFFF1591FFFF0000000000000000BE5B0AFFFAD762FFF8D2
      5FFFE3982BFF000000000000000000000000000000000000000000000000F0B9
      41FFF7D360FFF7D160FFF3BE3DFF000000000000000000000000000000000000
      00000000000000000000000000007F7B75E3F6ECDDFFBFB8AEF3000000000000
      00000000000069686670999590B5C1B8ACFFBCA787FAFBF8F4FFF9F8F1FFFCFA
      FAFFFAF9F8FFFDFFFFFFC1AC8BFFFCFCFCFFFAFBFBFFEFEDE9FFEAE3DCFFDCCC
      BCFFC1A783FFEAE1D7FFCAB595FF000000000000000050ADFEFF8BDCFFFF63CA
      FFFF61D5FFFF2B83ACFF308BC0FF2D8CC6FF2D8CC6FF2D8CC6FF2D8CC6FF60D4
      FFFF52C0FFFF41A9FFFF1590FFFF0000000000000000B14500FFFEDF6BFFF9D5
      64FFF4C650FF000000000000000000000000000000000000000000000000F6CD
      58FFF8D463FFF9D565FFF2B935FF000000000000000000000000000000000000
      000000000000000000000000000073706DCEFEF5E7FFDDD5C9FF343333350000
      000000000000000000000000000000000000C0AB8FFAFCFCFCFFFAFAF8FFFAFA
      FCFFFBFCF9FFF5F3EBFFC8B796FFFDFFFFFFF8F5F3FFEBE1D5FFDCD3C2FFCBB4
      97FFAC935CFF000000000000000000000000000000004EACFEFF8EDFFFFF51CC
      FFFF64A3C7FFC1BBBBFFB8B0AAFFBAB0AAFFBAB0AAFFBAB0AAFFD1BBB1FF235E
      91FF3BA9FFFF41A6FFFF1C89F1FF0000000000000000816D6194E29C31FFFBDD
      73FFFCE076FFBE5508FF2E2D2D2F00000000000000002E2E2D2FDF8A1BFFFCDF
      75FFFBDD73FFF6D26BFF90846C94000000000000000000000000000000000000
      0000000000000000000000000000767471AEF7ECDEFFEFE7D9FF6463626A0000
      000000000000000000000000000000000000C4B293FAFBFCFCFFFAFAFAFFFAFB
      F8FFF8F5EEFFC7B093FFBBA279FFDBCFBAFFD6C6B4FFC8B99DFFC4AF8CFFB29A
      69FFA58954FF000000000000000000000000000000004EACFEFFB9EDFEFF72D9
      FFFF80BAD5FFF0F3F5FFDCDEDEFFDFDFE0FFDFDFE0FFDCE1E3FFFFF7F3FF2669
      98FF3FA6F7FF46A8FFFF1C88F1FF00000000000000000B0B0B0CA83B00FFFDE3
      7AFFFCE27AFFFAD869FFCB640CFF756A607C766B607CDF8A1BFFF9DB6BFFFCE2
      7AFFFCE178FFEFB231FF0B0B0B0C000000000000000000000000000000000000
      00000000000000000000000000004545444BD1CBC0FFFEF4E5FFB5AFA6CF0000
      000000000000000000000000000000000000C7B49AFAFCFCFCFFFAFBFBFFEEEB
      E7FFEAE2D9FFCAB598FFDCCCBCFFAC8D5AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D9DCDDFFFFFFFFFF878787FFBCBCBCFFEEF2F3FFE1E0DFFF0000
      000000000000000000000000000000000000000000000000000000000000E7B0
      50FFFFF4A7FFFDE688FFFDE78AFFFEEA8EFFFEE98DFFFDE78AFFFDE688FFFFEF
      ADFFF5D780FF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000192908AD1FEF4E6FFDCD5C7F70000
      000000000000000000000000000000000000C7B79DFAFBFBFCFFF8F7F1FFEAE3
      DAFFE1D8CAFFC2A983FFCDBDA3FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E4E4E4FF8D8D8DFFC4C4C4FFE5E5E5FF000000000000
      000000000000000000000000000000000000000000000000000000000000A456
      2EE3DF993CFFFFEE96FFFFE88AFFFEE689FFFEE689FFFFE788FFFFECA0FFF2C6
      62FFD19B45E30000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007372717DC1BBB2F70000
      000000000000000000000000000000000000C0A883FFDCCFBBFFD6C7B3FFC8B8
      98FFC4AD88FFAC925FFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000979797FF989898FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007D6E6289AA744ACCDD9430FFDF9A33FFB68651CC837565890000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000600000000100010000000000000300000000000000000000
      000000000000000000000000FFFFFF00F00FC183FFFF0000E003C18300000000
      C7F1C183000000009BE9C183000000001DE8C1831FF800003EDCC18318180000
      3E1CC183181800003E74C183181800003A2CC183181800003D1CC18318180000
      3C3CC183181800001F18C1831FF800008F11C18300000000C703C18300000000
      E007C18300000000F00FC183FFFF0000FFFFFC00F83FFFFF8003FC00E00FFF3F
      8003FC00C007FE1F8003FC008003FE0F8003E0000001F0078003E0000001A003
      8003E0000000C0018003E0070000C000800380070000C000800380070000C001
      800380070001A0038003801F0001F0078003801F8001F80F8003801F8003F61F
      FFFF801FC007FE3FFFFFFFFFF00FFF7FFFF8FFF88001FFFFFFE0FFE0C0038003
      FFE0FFE000018003FF81FF8100018003FF83FF8300018003C007C00700018003
      800F800F00018003801F801F00018003001F001F00018003001F001F00018003
      001F001FC0038003001F001FE0078003001F001FE0078003801F801FE0078003
      803F803FE00FFFFFE07FE07FE01FFFFF0000FFF8FC3FF81F0000FFE0E007E007
      0000FFE0C003C0030000FF81800180010000FF83800100010000C00780010000
      0000800F018000000000801F03C000000000001F03C000000000001F01800000
      0000001F800100000000001F800100010000001F800100010000801FC0038003
      0000803FE007C0070000E07FFC3FE00FFF7FFFFFC001FC7FFC7F9FFFC001F83F
      F87F0FF7C001F01FF00F0FF7C001E00FE0070FE7C001C007F80387CFC0018003
      F801838FC0010001FE41C39FC0010001FF61E01FC001000187E1F03FC0010001
      87E1F87FC00180018181E03FC001C0018001810FC003C001E0070387C007C001
      E00707E1C00FE001F81F0FF8C01FFF11FC7FFC00C003FEFFF83FFC008001FE3F
      F81FFC008001FE1FF91FFC008001F00F801F00008001E007003F00008001C01F
      107F00008001801F000100008001827F80010000800186FFEE000001800187E1
      FE380001800187E1FE1F000780018181FE1F000780018001FE1F00FFF81FE007
      FE1F01FFFC3FE007FF9F03FFFE7FF81F00000000000000000000000000000000
      000000000000}
  end
end
