object SearchDlg: TSearchDlg
  Left = 290
  Top = 143
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'QuickReport Preview : Text Search'
  ClientHeight = 118
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 273
    Height = 16
    AutoSize = False
    Caption = 'Search for :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 8
    Top = 88
    Width = 113
    Height = 25
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 184
    Top = 88
    Width = 113
    Height = 25
    Caption = 'Search'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = SpeedButton2Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 289
    Height = 21
    TabOrder = 0
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 56
    Width = 289
    Height = 17
    Caption = 'Match Case'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
end
