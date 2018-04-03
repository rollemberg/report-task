object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'SQL Server '#24615#33021#20248#21270#24037#20855
  ClientHeight = 422
  ClientWidth = 764
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 192
    Top = 64
    object N1: TMenuItem
      Caption = #25991#20214'(&F)'
      object X1: TMenuItem
        Caption = #36864#20986'(&X)'
      end
    end
    object H1: TMenuItem
      Caption = #20027#26426#30828#20214'(&H)'
    end
    object SQLServer1: TMenuItem
      Caption = 'SQL&Server'
      object N2: TMenuItem
        Caption = #25968#25454#34920#32034#24341#26816#26597
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = #25968#25454#34920#32034#24341#37325#24314#24037#20855
        OnClick = N3Click
      end
    end
    object SQL1: TMenuItem
      Caption = 'S&QL'#25351#20196
    end
    object H2: TMenuItem
      Caption = #24110#21161'(&H)'
    end
  end
end
