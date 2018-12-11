object FormOptions: TFormOptions
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FormOptions'
  ClientHeight = 201
  ClientWidth = 288
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
  object gpbLang: TGroupBox
    Left = 24
    Top = 48
    Width = 233
    Height = 57
    Caption = 'Lang'
    TabOrder = 0
    object cbxLang: TComboBox
      Left = 24
      Top = 24
      Width = 185
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      Items.Strings = (
        'English ('#1040#1085#1075#1083#1080#1081#1089#1082#1080#1081')'
        #1056#1091#1089#1089#1082#1080#1081' (Russian)')
    end
  end
  object btnOk: TButton
    Left = 125
    Top = 170
    Width = 75
    Height = 25
    Caption = 'btnOk'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 206
    Top = 170
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'btnCancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
