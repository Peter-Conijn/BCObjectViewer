namespace ALRabbit.BCObjectViewer.Viewers.ObjectsPerApp;

using System.Reflection;
using ALRabbit.BCObjectViewer.Common;

page 50133 "OVW Application Objects"
{
    PageType = ListPart;
    Caption = 'Application Objects';
    SourceTable = AllObjWithCaption;
    SourceTableView = where("Object Type" = filter(<> TableData));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Permissions = tabledata AllObjWithCaption = R;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the object.';
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the object.';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the object.';
                }
                field("Object Caption"; Rec."Object Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the language-specific caption of the object.';
                }
                field(RecordCount; GetRecordCount(Rec."Object Type", Rec."Object ID"))
                {
                    ApplicationArea = All;
                    Caption = 'Record Count';
                    ToolTip = 'Specifies the number of records in the table for the current company.';
                    BlankZero = true;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunObject)
            {
                ApplicationArea = All;
                Caption = 'Run Object';
                ToolTip = 'Runs the selected object.';
                Image = Start;

                trigger OnAction();
                begin
                    RunApplicationObject();
                end;
            }
        }
    }

    local procedure RunApplicationObject()
    var
        OVWObjectManagement: Codeunit "OVW Object Management";
    begin
        OVWObjectManagement.RunApplicationObject(Rec);
    end;

    local procedure GetRecordCount(ForObjectType: Option; ForObjectID: Integer): Integer
    var
        OVWRecordCountMgt: Codeunit "OVW Record Count Mgt.";
    begin
        if ForObjectType <> Rec."Object Type"::Table then
            exit;
        exit(OVWRecordCountMgt.GetRecordCount(ForObjectID));
    end;
}