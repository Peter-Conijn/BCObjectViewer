namespace ALRabbit.BCObjectViewer.Common.Excel;

using System.IO;
using System.Utilities;

tableextension 50131 "OVW Excel Buffer" extends "Excel Buffer"
{
    fields
    {
        field(50131; "OVW Value is BLOB"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Value is BLOB';
        }
    }

    procedure AddCell(RowNo: Integer; var ColumnNo: Integer; CellValueVariant: Variant; HeadingTxt: Text[250]; ColumnIncrement: Integer)
    begin
        AddCellWithFormatting(RowNo, ColumnNo, CellValueVariant, HeadingTxt, false, false, false, 2, ColumnIncrement);
    end;

    procedure AddCellWithFormatting(RowNo: Integer; var ColumnNo: Integer; CellValueVariant: Variant; HeadingTxt: Text[250]; IsBold: Boolean; IsItalic: Boolean; IsUnderlined: Boolean; NumberOfDecimals: Integer; ColumnIncrement: Integer)
    var
        ExcelBuffer: Record "Excel Buffer";
        DecimalNotationTxt: Text;
    begin
        Init();
        Validate("Row No.", RowNo);
        Validate("Column No.", ColumnNo);
        TestField("Row No.");
        TestField("Column No.");
        Formula := '';
        Bold := IsBold;
        Italic := IsItalic;
        Underline := IsUnderlined;

        DecimalNotationTxt := '#,##0';
        if NumberOfDecimals > 0 then begin
            DecimalNotationTxt += '.';
            DecimalNotationTxt := PadStr(DecimalNotationTxt, StrLen(DecimalNotationTxt) + NumberOfDecimals, '0');
        end;

        case true of
            CellValueVariant.IsInteger,
            CellValueVariant.IsDecimal,
            CellValueVariant.IsDuration,
            CellValueVariant.IsBigInteger:
                begin
                    NumberFormat := '0';
                    "Cell Type" := "Cell Type"::Number;
                    if CellValueVariant.IsDecimal then
                        NumberFormat := CopyStr(DecimalNotationTxt, 1, MaxStrLen(NumberFormat));
                end;

            CellValueVariant.IsDate:
                "Cell Type" := "Cell Type"::Date;
            CellValueVariant.IsTime:
                "Cell Type" := "Cell Type"::Time;
            CellValueVariant.IsDateTime:
                "Cell Type" := "Cell Type"::Date;
            else begin
                "Cell Type" := "Cell Type"::Text;
                if StrLen(Format(CellValueVariant)) > MaxStrLen("Cell Value as Text") then begin
                    "OVW Value is BLOB" := true;
                    ConvertStringToBlob(Format(CellValueVariant), TempBlob);
                    TempBlob.FromRecord(Rec, FieldNo("Cell Value as Blob"));
                end;
            end;
        end;
        if not "OVW Value is BLOB" then
            "Cell Value as Text" := Format(CellValueVariant);

        if not ExcelBuffer.Get(Rec."Row No.", Rec."Column No.") then
            Rec.Insert()
        else
            Rec.Modify();

        AddHeading(ColumnNo, HeadingTxt);
        ColumnNo += ColumnIncrement;
    end;

    procedure AddHeading(ColumnNo: Integer; HeadingTxt: Text[250])
    begin
        AddHeadingAtRow(1, ColumnNo, HeadingTxt);
    end;

    procedure AddHeadingAtRow(RowNo: Integer; var ColumnNo: Integer; HeadingTxt: Text[250])
    begin
        IF HeadingTxt = '' THEN
            exit;
        if RowNo <> 1 then
            ColumnNo += 1;
        if Get(RowNo, ColumnNo) then
            exit;
        Init();
        Validate("Row No.", RowNo);
        Validate("Column No.", ColumnNo);
        "Cell Value as Text" := HeadingTxt;
        Bold := true;
        "Cell Type" := "Cell Type"::Text;
        Insert();
    end;

    procedure CreateExcelBook(SheetNameTxt: Text)
    begin
        CreateFile(SheetNameTxt);
    end;

    procedure CreateFile(SheetNameTxt: Text)
    begin
        CreateNewBook(CopyStr(SheetNameTxt, 1, 250));
        WriteSheet(CopyStr(SheetNameTxt, 1, 80), CompanyName, UserId);
        CloseBook();
        OpenExcel();
    end;


    procedure ConvertStringToBlob(Input: Text; var NewTempBlob: Codeunit "Temp Blob"): Integer
    var
        DataOutStream: OutStream;
    begin
        NewTempBlob.CreateOutStream(DataOutStream, TextEncoding::UTF8);
        DataOutStream.WriteText(Input);
    end;

    var
        TempBlob: Codeunit "Temp Blob";
}