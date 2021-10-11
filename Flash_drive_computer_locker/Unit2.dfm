object Form2: TForm2
  Left = 243
  Top = 202
  BorderStyle = bsDialog
  Caption = 'Change password'
  ClientHeight = 105
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 35
    Height = 16
    Caption = 'Drive:'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 63
    Height = 16
    Caption = 'Password:'
  end
  object drives: TComboBox
    Left = 48
    Top = 8
    Width = 57
    Height = 24
    ItemHeight = 16
    MaxLength = 1
    TabOrder = 0
    OnDropDown = drivesDropDown
  end
  object Edit1: TEdit
    Left = 80
    Top = 40
    Width = 105
    Height = 25
    MaxLength = 500
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 72
    Width = 113
    Height = 25
    Caption = 'Apply'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 128
    Top = 72
    Width = 113
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 112
    Top = 8
    Width = 121
    Height = 17
    Caption = 'Autorun'
    TabOrder = 4
  end
  object Button3: TButton
    Left = 192
    Top = 40
    Width = 49
    Height = 25
    Hint = 'Random'
    Caption = 'RND'
    TabOrder = 5
    OnClick = Button3Click
  end
end
