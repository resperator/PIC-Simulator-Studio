unit PIC10FSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TfrmPIC10FSettings = class(TForm)
    ImgDesignTime: TImage;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPIC10FSettings: TfrmPIC10FSettings;
  cnv:TCanvas;
implementation

{$R *.dfm}

end.
