object frmopn: Tfrmopn
  Left = 0
  Top = 0
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AlphaBlend = True
  AlphaBlendValue = 250
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = '5'
  ClientHeight = 185
  ClientWidth = 188
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 3
    Top = 169
    Width = 185
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'not available in this version'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Button2: TButton
    Left = 106
    Top = 143
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button1: TButton
    Left = 8
    Top = 143
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object grpHexSelectMC: TGroupBox
    Left = 3
    Top = 16
    Width = 185
    Height = 105
    Caption = 'Select microcontroller'
    TabOrder = 2
    object Label1: TLabel
      Left = 3
      Top = 16
      Width = 179
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Architecture:'
    end
    object Label2: TLabel
      Left = 3
      Top = 56
      Width = 179
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Model:'
    end
    object cbHexSelectFamily: TComboBox
      Left = 3
      Top = 32
      Width = 179
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbHexSelectFamilyChange
    end
    object cbHexSelectMC: TComboBox
      Left = 3
      Top = 72
      Width = 179
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = cbHexSelectMCChange
    end
  end
end
