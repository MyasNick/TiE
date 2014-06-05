library TiEsuw;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows,
  unitSuW in 'unitSuW.pas' {frmSuW};

{$R *.res}

procedure FirstStartWizardShow;
begin
  frmSuW.Show;
end;

procedure FirstStartWizardClose;
begin
  frmSuW.Close;
end;

procedure FirstStartWizardFree;
begin
  frmSuW.Free;
end;


exports
  FirstStartWizardClose,
  FirstStartWizardFree,
  FirstStartWizardShow;


begin
  frmSuW := TfrmSuW.Create(nil);
  CM_TIE_INFO := RegisterWindowMessage ('CM_TIE_INFO');
end.
