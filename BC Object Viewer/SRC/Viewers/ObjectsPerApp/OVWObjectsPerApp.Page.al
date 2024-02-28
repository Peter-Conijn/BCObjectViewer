namespace ALRabbit.BCObjectViewer.Viewers.ObjectsPerApp;

using System.Apps;
using ALRabbit.BCObjectViewer.Viewers.ObjectsPerApp.Dependencies;

page 50131 "OVW Objects per App"
{
    PageType = ListPlus;
    Caption = 'Objects per App';
    ApplicationArea = All;
    UsageCategory = Lists;
    DataCaptionFields = Name;
    SourceTable = "NAV App Installed App";
    DataCaptionExpression = Rec.Name;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                repeater(Apps)
                {
                    field(Name; Rec.Name)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the name of the extension.';
                    }
                    field(Publisher; Rec.Publisher)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the publisher of the app you want to see the objects for.';
                    }
                    field("Published As"; Rec."Published As")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies how the app was published. This might affect the options you have for app management.';
                    }
                }
            }
            part(AppObjedcts; "OVW Application Objects")
            {
                ApplicationArea = All;
                SubPageLink = "App Package ID" = field("Package Id");
            }
        }

        area(FactBoxes)
        {
            part(DependsOn; "OVW Depends On - Factbox")
            {
                SubPageLink = "App Id" = field("App ID");
            }
            part(DependedOnBy; "OVW Depended On By - Factbox")
            {
                SubPageLink = "Dependent App Id" = field("App ID");
            }
        }
    }

    trigger OnOpenPage()
    begin
        InitDependencyTable();
    end;

    local procedure InitDependencyTable()
    var
        OVWDependencyManagement: Codeunit "OVW Dependency Management";
    begin
        OVWDependencyManagement.Run();
    end;
}
