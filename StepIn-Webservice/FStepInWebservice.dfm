object StepInService: TStepInService
  OldCreateOrder = False
  OnCreate = FormCreate
  DisplayName = 'StepInService'
  AfterInstall = ServiceAfterInstall
  Height = 150
  Width = 215
  object IdStepInServer: TIdHTTPServer
    Bindings = <>
    OnQuerySSLPort = IdHUSSTServerQuerySSLPort
    OnCommandGet = IdHUSSTServerCommandGet
    Left = 56
    Top = 40
  end
end
