object formNodes: TformNodes
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = '10'
  ClientHeight = 305
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object list: TValueListEditor
    Left = 0
    Top = 0
    Width = 309
    Height = 257
    Align = alTop
    FixedCols = 1
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
    TabOrder = 0
    TitleCaptions.Strings = (
      'Pin'
      'Node')
    OnGetPickList = listGetPickList
    OnKeyPress = listKeyPress
    ColWidths = (
      150
      153)
    RowHeights = (
      18
      18)
  end
  object Button1: TButton
    Left = 216
    Top = 263
    Width = 85
    Height = 34
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 121
    Top = 263
    Width = 89
    Height = 34
    Caption = 'Ok'
    Default = True
    TabOrder = 2
    OnClick = Button2Click
  end
end
