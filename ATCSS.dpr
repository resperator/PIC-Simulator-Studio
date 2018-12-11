program ATCSS;



{$R *.dres}

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  CHILDWIN in 'CHILDWIN.PAS' {MDIChild},
  about in 'about.pas' {AboutBox},
  UnitFormat in 'Units\Other\UnitFormat.pas',
  BinaryFlag in 'Components\BinaryFlag\BinaryFlag.pas',
  DeltaBreakPoint in 'Components\DeltaBreakPoint\DeltaBreakPoint.pas',
  frmOpen in 'frmOpen.pas' {frmopn},
  theadRefresh in 'Units\Other\theadRefresh.pas',
  unitWeb in 'Units\Other\unitWeb.pas',
  frmBugReport in 'frmBugReport.pas' {formBugReport},
  frmCheckUpdates in 'frmCheckUpdates.pas' {formCheckUpdates},
  UnitRegistry in 'Units\Other\UnitRegistry.pas',
  unitRes in 'Units\Other\unitRes.pas',
  ChildComp in 'ChildComp.pas' {frmChildComp},
  unitDev in 'Units\Other\unitDev.pas',
  frmDevices in 'frmDevices.pas' {formDevices},
  unitClasses4Devices in 'Units\Other\unitClasses4Devices.pas',
  frmSplash in 'frmSplash.pas' {formSplash},
  frmNodes in 'frmNodes.pas' {formNodes},
  Vcl.Themes,
  Vcl.Styles,
  frmOptions in 'frmOptions.pas' {FormOptions},
  frmShareware in 'frmShareware.pas' {formShareware};

{$R *.RES}


begin
  SetLang();
    Application.CreateForm(TformShareware, formShareware);
  formSplash:=TformSplash.Create(application);
  formSplash.ShowModal;
  formShareware.Free;
  formSplash.Free;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TformNodes, formNodes);

  //Application.CreateForm(TformSplash, formSplash);

  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(Tfrmopn, frmopn);
  Application.CreateForm(TformBugReport, formBugReport);
  Application.CreateForm(TformCheckUpdates, formCheckUpdates);
  Application.CreateForm(TformDevices, formDevices);

  // Application.CreateForm(TfrmChildComp, frmChildComp);
  Application.Run;

end.
