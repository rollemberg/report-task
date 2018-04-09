object FrmRebuildIndexs: TFrmRebuildIndexs
  Left = 0
  Top = 0
  Caption = #37325#24314#25968#25454#24211#32034#24341
  ClientHeight = 382
  ClientWidth = 764
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 97
    Width = 764
    Height = 285
    ActivePage = TabSheet1
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #25968#25454#34920#28165#21333
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 756
        Height = 216
        Align = alClient
        DataSource = dsView
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = DBGrid1DblClick
        Columns = <
          item
            Expanded = False
            FieldName = 'Select'
            Title.Alignment = taCenter
            Title.Caption = #36873#25321
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Database_'
            Title.Caption = #25968#25454#24211#21517
            Width = 95
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Table_'
            Title.Caption = #25968#25454#34920#21517
            Width = 95
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Count_'
            Title.Caption = #24403#21069#31508#25968
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'IndexFile_'
            Title.Caption = #32034#24341#33050#26412#25991#20214
            Width = 325
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'IndexName_'
            Title.Caption = #25191#34892#32467#26524
            Width = 65
            Visible = True
          end>
      end
      object Panel1: TPanel
        Left = 0
        Top = 216
        Width = 756
        Height = 38
        Align = alBottom
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object chkSelectAll: TCheckBox
          Left = 16
          Top = 6
          Width = 97
          Height = 17
          Caption = #20840#36873'(&A)'
          TabOrder = 0
          OnClick = chkSelectAllClick
        end
        object btnCreate: TButton
          Left = 88
          Top = 5
          Width = 109
          Height = 25
          Caption = 'Rebuild All'
          TabOrder = 1
          OnClick = btnCreateClick
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #29616#26377#32034#24341#28165#21333
      ImageIndex = 3
      OnShow = TabSheet4Show
      object DBGrid2: TDBGrid
        Left = 0
        Top = 0
        Width = 756
        Height = 254
        Align = alClient
        DataSource = dsIndexs
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object TabSheet2: TTabSheet
      Caption = #32034#24341#33050#26412#25991#20214
      ImageIndex = 1
      OnShow = TabSheet2Show
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 756
        Height = 216
        Align = alClient
        Color = clBtnFace
        Lines.Strings = (
          'Memo1')
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Panel3: TPanel
        Left = 0
        Top = 216
        Width = 756
        Height = 38
        Align = alBottom
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object btnRebuild: TButton
          Left = 16
          Top = 6
          Width = 75
          Height = 25
          Caption = '&Rebuild'
          TabOrder = 0
          OnClick = btnRebuildClick
        end
        object chkOverwrite: TCheckBox
          Left = 112
          Top = 10
          Width = 129
          Height = 17
          Caption = #20197#35206#30422#30340#26041#24335#37325#24314
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object chkDemo: TCheckBox
          Left = 247
          Top = 10
          Width = 129
          Height = 17
          Caption = #27169#25311#25191#34892
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #37325#24314'SQL'#25351#20196
      ImageIndex = 2
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 756
        Height = 254
        Align = alClient
        Color = clBtnFace
        Lines.Strings = (
          'Memo2')
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 764
    Height = 97
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 13
      Width = 49
      Height = 13
      Caption = 'Server IP:'
    end
    object Label2: TLabel
      Left = 224
      Top = 13
      Width = 50
      Height = 13
      Caption = 'Database:'
    end
    object Label3: TLabel
      Left = 8
      Top = 36
      Width = 43
      Height = 13
      Caption = 'Account:'
    end
    object Label4: TLabel
      Left = 8
      Top = 63
      Width = 50
      Height = 13
      Caption = 'Password:'
    end
    object Label5: TLabel
      Left = 224
      Top = 44
      Width = 57
      Height = 13
      Caption = 'Index Path:'
    end
    object Button1: TButton
      Left = 511
      Top = 43
      Width = 186
      Height = 25
      Caption = #37325#24314#25351#23450#25968#25454#34920#32034#24341
      TabOrder = 0
      OnClick = Button1Click
    end
    object edtServer: TEdit
      Left = 80
      Top = 13
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '127.0.0.1'
    end
    object edtAccount: TEdit
      Left = 80
      Top = 36
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'sa'
    end
    object edtPassword: TEdit
      Left = 80
      Top = 63
      Width = 121
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
      Text = 'ping0909'
    end
    object Button2: TButton
      Left = 511
      Top = 11
      Width = 186
      Height = 25
      Caption = #32852#25509#21040#25968#25454#24211' master'
      TabOrder = 4
      OnClick = Button2Click
    end
    object cboDatabase: TComboBox
      Left = 296
      Top = 13
      Width = 193
      Height = 21
      TabOrder = 5
      Text = 'TEST'
    end
    object edtIndexPath: TEdit
      Left = 296
      Top = 40
      Width = 193
      Height = 21
      TabOrder = 6
      Text = 'D:\MIMRC\Frame2011\Common\Indexs'
    end
    object CheckBox1: TCheckBox
      Left = 224
      Top = 65
      Width = 265
      Height = 17
      Caption = #26080'SQL'#32034#24341#25991#20214#21017#24573#30053
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
  end
  object qSQL: TADOQuery
    CacheSize = 100
    Connection = oCn
    CursorType = ctStatic
    CommandTimeout = 0
    EnableBCD = False
    Parameters = <>
    Left = 72
    Top = 184
  end
  object oCn: TADOConnection
    CommandTimeout = 6000
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=ping0909;Persist Security Info=True' +
      ';User ID=sa;Initial Catalog=YL1;Data Source=192.168.0.86'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 32
    Top = 184
  end
  object cdsView: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 160
    Top = 184
    object cdsViewSelect: TBooleanField
      FieldKind = fkInternalCalc
      FieldName = 'Select'
      OnGetText = cdsViewSelectGetText
      OnSetText = cdsViewSelectSetText
    end
    object cdsViewDatabase_: TStringField
      FieldName = 'Database_'
      Size = 30
    end
    object cdsViewTable_: TStringField
      FieldName = 'Table_'
      Size = 30
    end
    object cdsViewCount_: TIntegerField
      FieldName = 'Count_'
    end
    object cdsViewIndexName_: TStringField
      FieldName = 'IndexName_'
      Size = 30
    end
    object cdsViewIndexFile_: TStringField
      FieldName = 'IndexFile_'
      Size = 255
    end
  end
  object dsView: TDataSource
    DataSet = cdsView
    Left = 160
    Top = 240
  end
  object cdsIndexs: TADOQuery
    CacheSize = 100
    Connection = oCn
    CursorType = ctStatic
    CommandTimeout = 0
    EnableBCD = False
    Parameters = <>
    Left = 112
    Top = 184
  end
  object dsIndexs: TDataSource
    DataSet = cdsIndexs
    Left = 112
    Top = 240
  end
end
