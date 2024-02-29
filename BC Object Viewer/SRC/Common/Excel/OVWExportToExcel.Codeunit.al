namespace ALRabbit.BCObjectViewer.Common.Excel;

using System.IO;
using System.Reflection;

codeunit 50138 "OVW Export to Excel"
{
    internal procedure ExportRecordToExcel(TableID: Integer)
    var
        SourceRecordRef: RecordRef;
    begin
        if not TryOpenRecRef(SourceRecordRef, TableID) then
            exit;

        if not SourceRecordRef.ReadPermission then
            exit;

        RowNo := 1;
        if SourceRecordRef.FindSet() then
            repeat
                ExportRecordRefToExcel(SourceRecordRef);
            until SourceRecordRef.Next() = 0;

        TempExcelBuffer.CreateExcelBook(SourceRecordRef.Name); //change into table name?
    end;

    local procedure ExportRecordRefToExcel(var SourceRecordRef: RecordRef)
    var
        FieldIndex: Integer;
    begin
        ColumnNo := 1;
        RowNo += 1;

        for FieldIndex := 1 to SourceRecordRef.FieldCount() do
            ExportFieldRefToExcel(SourceRecordRef, FieldIndex);
    end;

    local procedure ExportFieldRefToExcel(var SourceRecordRef: RecordRef; Index: Integer)
    var
        SourceFieldRef: FieldRef;
    begin
        SourceFieldRef := SourceRecordRef.FieldIndex(Index);

        if not IsFieldEnabled(SourceFieldRef) then
            exit;

        case SourceFieldRef.Class of
            SourceFieldRef.Class::Normal:
                TempExcelBuffer.AddCell(RowNo, ColumnNo, SourceFieldRef.Value, CopyStr(SourceFieldRef.Caption(), 1, 250), 1);
            SourceFieldRef.Class::FlowField:
                begin
                    SourceFieldRef.CalcField();
                    TempExcelBuffer.AddCell(RowNo, ColumnNo, SourceFieldRef.Value, CopyStr(SourceFieldRef.Caption(), 1, 250), 1);
                end;
            else
                OnAfterAddCellWithFieldClass(RowNo, ColumnNo, SourceFieldRef);
        end;
    end;

    local procedure IsFieldEnabled(var SourceFieldRef: FieldRef): Boolean
    var
        FieldRecord: Record Field;
    begin
        if FieldRecord.Get(SourceFieldRef.Record().Number, SourceFieldRef.Number) then
            exit(FieldRecord.Enabled);
    end;

    [TryFunction]
    local procedure TryOpenRecRef(var SourceRecordRef: RecordRef; TableID: Integer)
    begin
        SourceRecordRef.Open(TableID);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAddCellWithFieldClass(RowNo: Integer; ColumnNo: Integer; SourceFieldRef: FieldRef)
    begin
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ColumnNo: Integer;
        RowNo: Integer;
}