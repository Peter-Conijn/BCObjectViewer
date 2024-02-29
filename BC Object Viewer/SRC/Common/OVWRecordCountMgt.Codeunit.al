namespace ALRabbit.BCObjectViewer.Common;

codeunit 50133 "OVW Record Count Mgt."
{
    procedure GetRecordCount(TableId: Integer): Integer
    var
        SourceRecordRef: RecordRef;
    begin
        SourceRecordRef.Open(TableId);
        if SourceRecordRef.ReadPermission() then
            exit(SourceRecordRef.Count());
    end;
}