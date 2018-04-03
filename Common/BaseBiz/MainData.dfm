object DM: TDM
  OldCreateOrder = False
  Height = 147
  Width = 400
  object DCOM: TSocketConnection
    ServerGUID = '{FF0F518E-1D90-4DFE-AEF8-77EE476EA436}'
    ServerName = 'CERC.Server'
    AfterConnect = DCOMAfterConnect
    Left = 40
    Top = 24
  end
end
