object FrmCheckIndexs: TFrmCheckIndexs
  Left = 0
  Top = 0
  Caption = #26816#26597#25968#25454#24211#32034#24341
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
  DesignSize = (
    764
    382)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 13
    Width = 49
    Height = 13
    Caption = 'Server IP:'
  end
  object Label2: TLabel
    Left = 8
    Top = 101
    Width = 50
    Height = 13
    Caption = 'Database:'
  end
  object Label3: TLabel
    Left = 8
    Top = 44
    Width = 43
    Height = 13
    Caption = 'Account:'
  end
  object Label4: TLabel
    Left = 8
    Top = 71
    Width = 50
    Height = 13
    Caption = 'Password:'
  end
  object Button1: TButton
    Left = 207
    Top = 40
    Width = 186
    Height = 25
    Caption = '&'#26816#26597#26377#26080'UpdateKey'#32034#24341
    TabOrder = 0
    OnClick = Button1Click
  end
  object edtServer: TEdit
    Left = 80
    Top = 13
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '192.168.0.86'
  end
  object edtAccount: TEdit
    Left = 80
    Top = 44
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'sa'
  end
  object edtPassword: TEdit
    Left = 80
    Top = 71
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
    Text = 'ping0909'
  end
  object Button2: TButton
    Left = 207
    Top = 8
    Width = 186
    Height = 25
    Caption = #32852#25509#21040#25968#25454#24211' master'
    TabOrder = 4
    OnClick = Button2Click
  end
  object cboDatabase: TComboBox
    Left = 80
    Top = 101
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 'YL1'
    OnChange = cboDatabaseChange
  end
  object ListView1: TListView
    Left = 80
    Top = 128
    Width = 121
    Height = 246
    Anchors = [akLeft, akTop, akBottom]
    Checkboxes = True
    Columns = <
      item
        Width = 95
      end>
    TabOrder = 6
    ViewStyle = vsReport
  end
  object PageControl1: TPageControl
    Left = 399
    Top = 0
    Width = 365
    Height = 382
    ActivePage = 当前SQL指令
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 7
    object 当前SQL指令: TTabSheet
      Caption = #24403#21069'SQL'#25351#20196
      object DBGrid2: TDBGrid
        Left = 0
        Top = 0
        Width = 357
        Height = 354
        Align = alClient
        DataSource = dsCurJob
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object 执行检查结果: TTabSheet
      Caption = #25191#34892#26816#26597#32467#26524
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DBGrid1: TDBGrid
        Left = -75
        Top = 0
        Width = 432
        Height = 354
        Align = alRight
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = dsView
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
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
            FieldName = 'UpdateKey_'
            Title.Caption = #23384#22312#21542
            Visible = True
          end>
      end
    end
  end
  object Button3: TButton
    Left = 207
    Top = 71
    Width = 186
    Height = 25
    Caption = #24403#21069#25191#34892#25351#20196#26816#26597
    TabOrder = 8
    OnClick = Button3Click
  end
  object qSQL: TADOQuery
    CacheSize = 100
    Connection = oCn
    CursorType = ctStatic
    CommandTimeout = 0
    EnableBCD = False
    Parameters = <>
    Left = 472
    Top = 56
  end
  object oCn: TADOConnection
    CommandTimeout = 6000
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=ping0909;Persist Security Info=True' +
      ';User ID=sa;Initial Catalog=YL1;Data Source=192.168.0.86'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 432
    Top = 56
  end
  object cdsView: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 512
    Top = 56
    object cdsViewTable_: TStringField
      FieldName = 'Table_'
      Size = 30
    end
    object cdsViewCount_: TIntegerField
      FieldName = 'Count_'
    end
    object cdsViewUpdateKey_: TBooleanField
      FieldName = 'UpdateKey_'
    end
    object cdsViewDatabase_: TStringField
      FieldName = 'Database_'
      Size = 30
    end
  end
  object dsView: TDataSource
    DataSet = cdsView
    Left = 552
    Top = 56
  end
  object dsCurJob: TDataSource
    DataSet = adoCurJob
    Left = 472
    Top = 120
  end
  object adoCurJob: TADOQuery
    CacheSize = 100
    Connection = oCn
    CursorType = ctStatic
    CommandTimeout = 0
    EnableBCD = False
    Parameters = <>
    Left = 432
    Top = 120
  end
end
