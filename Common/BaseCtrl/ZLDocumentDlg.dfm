object DlgZLDocument: TDlgZLDocument
  Left = 372
  Top = 156
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 246
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    472
    246)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 12
    Width = 59
    Height = 13
    Caption = 'Style Select:'
  end
  object btnUP: TButton
    Left = 384
    Top = 19
    Width = 75
    Height = 25
    Caption = '&UP'
    TabOrder = 0
    OnClick = btnUPClick
  end
  object btnDown: TButton
    Left = 384
    Top = 50
    Width = 75
    Height = 25
    Caption = '&Down'
    TabOrder = 1
    OnClick = btnDownClick
  end
  object btnHide: TButton
    Left = 384
    Top = 81
    Width = 75
    Height = 25
    Caption = '&Hide'
    TabOrder = 2
    OnClick = btnHideClick
  end
  object btnSave: TButton
    Left = 384
    Top = 113
    Width = 75
    Height = 25
    Caption = '&Save'
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 384
    Top = 209
    Width = 75
    Height = 25
    Caption = '&Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object rbColumn: TRadioButton
    Left = 80
    Top = 11
    Width = 73
    Height = 17
    Caption = 'by Column'
    TabOrder = 5
    OnClick = rbColumnClick
  end
  object ListBox1: TListBox
    Left = 8
    Top = 32
    Width = 361
    Height = 201
    Anchors = [akLeft, akTop, akBottom]
    DragMode = dmAutomatic
    ItemHeight = 13
    TabOrder = 6
    OnClick = ListBox1Click
    OnDblClick = ListBox1DblClick
    OnDragDrop = ListBox1DragDrop
    OnDragOver = ListBox1DragOver
  end
  object rbRow: TRadioButton
    Left = 160
    Top = 11
    Width = 113
    Height = 17
    Caption = 'by Row'
    TabOrder = 7
    OnClick = rbColumnClick
  end
  object btnReset: TButton
    Left = 384
    Top = 145
    Width = 75
    Height = 25
    Caption = '&Reset'
    TabOrder = 8
    OnClick = btnResetClick
  end
end
