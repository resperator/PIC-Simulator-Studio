object formBugReport: TformBugReport
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '7'
  ClientHeight = 539
  ClientWidth = 695
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 55
    Height = 13
    Caption = 'User name:'
  end
  object Label2: TLabel
    Left = 327
    Top = 8
    Width = 69
    Height = 13
    Caption = 'E_mail adress:'
  end
  object edtUserName: TEdit
    Left = 69
    Top = 5
    Width = 252
    Height = 21
    TabOrder = 0
  end
  object edtEmail: TEdit
    Left = 405
    Top = 5
    Width = 282
    Height = 21
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 612
    Top = 503
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object btnSend: TButton
    Left = 531
    Top = 503
    Width = 75
    Height = 25
    Caption = 'Send'
    Default = True
    TabOrder = 3
    OnClick = btnSendClick
  end
  object memoReport: TMemo
    Left = 8
    Top = 32
    Width = 679
    Height = 465
    Lines.Strings = (
      'Enter your report here')
    TabOrder = 2
  end
end
