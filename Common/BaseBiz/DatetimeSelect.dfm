object SelectDatetime: TSelectDatetime
  Left = 327
  Top = 291
  BorderStyle = bsDialog
  Caption = #36873#25321#26085#26399
  ClientHeight = 194
  ClientWidth = 366
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
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 288
    Height = 194
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 17
      Top = 5
      Width = 24
      Height = 22
      Hint = #19978#24180
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333FF3333333333333744333333333333F773333333333337
        44473333333333F777F3333333333744444333333333F7733733333333374444
        4433333333F77333733333333744444447333333F7733337F333333744444444
        433333F77333333733333744444444443333377FFFFFFF7FFFFF999999999999
        9999733777777777777333CCCCCCCCCC33333773FF333373F3333333CCCCCCCC
        C333333773FF3337F333333333CCCCCCC33333333773FF373F3333333333CCCC
        CC333333333773FF73F33333333333CCCCC3333333333773F7F3333333333333
        CCC333333333333777FF33333333333333CC3333333333333773}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 49
      Top = 5
      Width = 24
      Height = 22
      Hint = #19978#26376
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object Label1: TLabel
      Left = 88
      Top = 10
      Width = 49
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Label1'
    end
    object Label2: TLabel
      Left = 145
      Top = 10
      Width = 49
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Label2'
    end
    object SpeedButton3: TSpeedButton
      Left = 201
      Top = 5
      Width = 24
      Height = 22
      Hint = #19979#26376
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 233
      Top = 5
      Width = 24
      Height = 22
      Hint = #19979#24180
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333FF3333333333333447333333333333377FFF33333333333744473333333
        333337773FF3333333333444447333333333373F773FF3333333334444447333
        33333373F3773FF3333333744444447333333337F333773FF333333444444444
        733333373F3333773FF333334444444444733FFF7FFFFFFF77FF999999999999
        999977777777777733773333CCCCCCCCCC3333337333333F7733333CCCCCCCCC
        33333337F3333F773333333CCCCCCC3333333337333F7733333333CCCCCC3333
        333333733F77333333333CCCCC333333333337FF7733333333333CCC33333333
        33333777333333333333CC333333333333337733333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton4Click
    end
    object MonthCalendar1: TCalendar
      Left = 1
      Top = 32
      Width = 287
      Height = 157
      Color = clInfoBk
      StartOfWeek = 0
      TabOrder = 0
      OnDblClick = MonthCalendar1DblClick
    end
  end
  object Panel4: TPanel
    Left = 288
    Top = 0
    Width = 78
    Height = 194
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object BitBtn4: TBitBtn
      Left = 8
      Top = 153
      Width = 60
      Height = 25
      Cancel = True
      Caption = #21462#28040'(&C)'
      DoubleBuffered = True
      ModalResult = 2
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = BitBtn4Click
    end
    object BitBtn2: TBitBtn
      Left = 8
      Top = 64
      Width = 60
      Height = 25
      Caption = #26126#22825
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      OnClick = BitBtn2Click
    end
    object BitBtn1: TBitBtn
      Left = 8
      Top = 35
      Width = 60
      Height = 25
      Caption = #26152#22825
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 2
      OnClick = BitBtn1Click
    end
    object BitBtn3: TBitBtn
      Left = 8
      Top = 6
      Width = 60
      Height = 25
      Caption = #20170#22825
      Default = True
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 3
      OnClick = BitBtn3Click
    end
    object BitBtn5: TBitBtn
      Left = 8
      Top = 93
      Width = 60
      Height = 25
      Caption = #19978#26376
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 4
      OnClick = BitBtn5Click
    end
    object BitBtn6: TBitBtn
      Left = 8
      Top = 123
      Width = 60
      Height = 25
      Caption = #19979#26376
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 5
      OnClick = BitBtn6Click
    end
  end
  object s: TZjhSkin
    Section = 'SelDate'
    Left = 80
    Top = 84
  end
end
