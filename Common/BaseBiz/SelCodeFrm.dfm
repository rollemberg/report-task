object SelectDialog: TSelectDialog
  Left = 236
  Top = 209
  ActiveControl = Edit1
  BorderIcons = [biSystemMenu]
  Caption = #36873#25321
  ClientHeight = 246
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 472
    Height = 246
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object dg1: TDBGrid
      Left = 4
      Top = 57
      Width = 464
      Height = 185
      Align = alClient
      DataSource = dsSource
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = dg1DblClick
    end
    object GroupBox1: TGroupBox
      Left = 4
      Top = 4
      Width = 464
      Height = 53
      Align = alTop
      Caption = ' '#24555#36895#26597#35810' '
      TabOrder = 1
      object Label1: TLabel
        Left = 16
        Top = 23
        Width = 65
        Height = 14
        AutoSize = False
        Caption = #21462#20540#65306
      end
      object ComboBox1: TComboBox
        Left = 55
        Top = 20
        Width = 81
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = ComboBox1Change
      end
      object Edit1: TEdit
        Left = 143
        Top = 20
        Width = 129
        Height = 21
        TabOrder = 1
        OnChange = Edit1Change
      end
      object BitBtn1: TBitBtn
        Left = 286
        Top = 17
        Width = 75
        Height = 25
        Caption = #30830#35748
        Kind = bkOK
        TabOrder = 2
        OnClick = BitBtn1Click
      end
      object BitBtn2: TBitBtn
        Left = 374
        Top = 17
        Width = 75
        Height = 25
        Caption = #21462#28040
        Kind = bkCancel
        TabOrder = 3
      end
    end
  end
  object dsSource: TDataSource
    DataSet = cdsSource
    Left = 56
    Top = 144
  end
  object s: TZjhSkin
    Section = 'SelCode'
    Left = 24
    Top = 112
  end
  object cdsSource: TZjhDataSet
    Aggregates = <>
    FetchOnDemand = False
    Params = <>
    ProviderName = 'dspSQL'
    Left = 56
    Top = 112
  end
end
