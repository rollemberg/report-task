object FrmMain: TFrmMain
  Left = 0
  Top = 0
  ClientHeight = 402
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 272
    Top = 224
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 158
    Width = 651
    Height = 244
    Align = alClient
    DataSource = dsView
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'CorpNo_'
        Title.Alignment = taCenter
        Title.Caption = #20225#19994#32534#21495
        Width = 71
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Group_'
        Title.Alignment = taCenter
        Title.Caption = #20998#32452#21517#31216
        Width = 74
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RetNo_'
        Title.Alignment = taCenter
        Title.Caption = #25253#34920#32534#21495
        Width = 125
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'RetName_'
        Title.Alignment = taCenter
        Title.Caption = #25253#34920#21517#31216
        Width = 76
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Param_'
        Title.Alignment = taCenter
        Title.Caption = 'SQL'#25351#20196
        Width = 125
        Visible = True
      end>
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 651
    Height = 158
    Align = alTop
    BorderWidth = 8
    TabOrder = 1
    ExplicitWidth = 732
    object Panel3: TPanel
      Left = 9
      Top = 9
      Width = 633
      Height = 30
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 714
      object Label4: TLabel
        Left = 8
        Top = 4
        Width = 73
        Height = 13
        AutoSize = False
        Caption = #26381#21209#20027#27231
      end
      object Label5: TLabel
        Left = 205
        Top = 4
        Width = 73
        Height = 13
        AutoSize = False
        Caption = #24115#34399
      end
      object Label6: TLabel
        Left = 338
        Top = 4
        Width = 73
        Height = 13
        AutoSize = False
        Caption = #23494#30908
      end
      object cboRemoteHost: TComboBox
        Left = 67
        Top = 1
        Width = 130
        Height = 21
        TabOrder = 0
      end
      object edtRemoteUser: TEdit
        Left = 237
        Top = 1
        Width = 76
        Height = 21
        TabOrder = 1
      end
      object edtRemotePwd: TEdit
        Left = 370
        Top = 1
        Width = 87
        Height = 21
        PasswordChar = '*'
        TabOrder = 2
      end
      object BitBtn3: TBitBtn
        Left = 493
        Top = 1
        Width = 57
        Height = 23
        Caption = #36899#25509'(&C)'
        TabOrder = 3
        OnClick = BitBtn3Click
      end
      object Button1: TButton
        Left = 561
        Top = 0
        Width = 57
        Height = 25
        Caption = #25191#34892
        TabOrder = 4
        OnClick = Button1Click
      end
    end
    object DBGrid2: TDBGrid
      Left = 9
      Top = 39
      Width = 633
      Height = 110
      Align = alClient
      DataSource = dsDBList
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Database_'
          Title.Alignment = taCenter
          Title.Caption = #25968#25454#24211
          Width = 92
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Host_'
          Title.Alignment = taCenter
          Title.Caption = #20027#26426#22320#22336
          Width = 130
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Account_'
          Title.Alignment = taCenter
          Title.Caption = #24080#21495
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PortNo_'
          Title.Alignment = taCenter
          Title.Caption = #31471#21475
          Width = 56
          Visible = True
        end>
    end
  end
  object cdsView: TZjhDataSet
    Aggregates = <>
    FetchOnDemand = False
    Params = <>
    ProviderName = 'dspSQL'
    Left = 248
    Top = 208
    object cdsViewCorpNo_: TWideStringField
      FieldName = 'CorpNo_'
    end
    object cdsViewGroup_: TWideStringField
      FieldName = 'Group_'
      Size = 30
    end
    object cdsViewRetNo_: TWideStringField
      FieldName = 'RetNo_'
      Size = 30
    end
    object cdsViewRetName_: TWideStringField
      FieldName = 'RetName_'
      Size = 30
    end
    object cdsViewParam_: TWideMemoField
      FieldName = 'Param_'
      OnGetText = cdsViewParam_GetText
      BlobType = ftWideMemo
      Size = 1000
    end
    object cdsViewDBUID_: TWideStringField
      FieldName = 'DBUID_'
      Size = 10
    end
    object cdsViewVer_: TWideStringField
      FieldName = 'Ver_'
      Size = 10
    end
  end
  object dsView: TDataSource
    DataSet = cdsView
    Left = 248
    Top = 256
  end
  object cdsDBList: TZjhDataSet
    Aggregates = <>
    FetchOnDemand = False
    Params = <>
    ProviderName = 'dspSQL'
    Left = 136
    Top = 56
    object cdsDBListDatabase_: TWideStringField
      FieldName = 'Database_'
    end
    object cdsDBListHost_: TWideStringField
      FieldName = 'Host_'
      Size = 100
    end
    object cdsDBListPassword_: TWideStringField
      FieldName = 'Password_'
      Size = 50
    end
    object cdsDBListAccount_: TWideStringField
      FieldName = 'Account_'
      Size = 50
    end
    object cdsDBListPortNo_: TWideStringField
      FieldName = 'PortNo_'
      Size = 5
    end
    object cdsDBListDBUID_: TWideStringField
      FieldName = 'DBUID_'
      Size = 10
    end
  end
  object dsDBList: TDataSource
    DataSet = cdsDBList
    Left = 136
    Top = 104
  end
  object cdsSQL: TZjhDataSet
    Aggregates = <>
    FetchOnDemand = False
    Params = <>
    ProviderName = 'dspSQL'
    Left = 416
    Top = 208
  end
end
