object formCheckUpdates: TformCheckUpdates
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '8'
  ClientHeight = 313
  ClientWidth = 532
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar1: TProgressBar
    Left = 291
    Top = 276
    Width = 129
    Height = 29
    Max = 5000
    Position = 1000
    Style = pbstMarquee
    MarqueeInterval = 30
    TabOrder = 4
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 516
    Height = 262
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ChkDontCheck: TCheckBox
    Left = 8
    Top = 282
    Width = 277
    Height = 17
    Caption = 'Check for updates at startup'
    TabOrder = 1
    OnClick = ChkDontCheckClick
  end
  object btnDownNInst: TButton
    Left = 291
    Top = 276
    Width = 129
    Height = 29
    Caption = 'Download and install'
    Enabled = False
    TabOrder = 2
    OnClick = btnDownNInstClick
  end
  object btnCancel: TButton
    Left = 426
    Top = 276
    Width = 98
    Height = 29
    Cancel = True
    Caption = 'Close'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object SaveDialog1: TSaveDialog
    Left = 224
    Top = 280
  end
  object tmrCanShow: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = tmrCanShowTimer
    Left = 256
    Top = 280
  end
end
