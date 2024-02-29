namespace ALRabbit.BCObjectViewer.Viewers.ObjectsPerApp.Dependencies;

using System.Apps;

codeunit 50137 "OVW Dependency Management"
{
    Permissions = tabledata "NAV App Installed App" = R,
                  tabledata "OVW App Dependency" = RIMD;

    trigger OnRun()
    begin
        FillDependencyTable();
    end;

    local procedure FillDependencyTable()
    var
        NAVAppInstalledApp: Record "NAV App Installed App";
    begin
        ClearDependencyTable();
        if not NAVAppInstalledApp.FindSet() then
            exit;
        repeat
            InitDependencyRecords(NAVAppInstalledApp);
        until NAVAppInstalledApp.Next() = 0;
    end;

    local procedure InitDependencyRecords(NAVAppInstalledApp: Record "NAV App Installed App")
    var
        ModuleDependencies: List of [ModuleDependencyInfo];
        ModuleDependency: ModuleDependencyInfo;
        IsHandled: Boolean;
    begin
        OnBeforeInitDependencyRecords(NAVAppInstalledApp, IsHandled);
        if IsHandled then
            exit;

        ModuleDependencies := GetDependencies(NAVAppInstalledApp);
        if ModuleDependencies.Count() = 0 then
            exit;

        foreach ModuleDependency in ModuleDependencies do
            InitDependencyRecord(NAVAppInstalledApp, ModuleDependency);

        OnAfterInitDependencyRecords(NAVAppInstalledApp);
    end;

    local procedure InitDependencyRecord(NAVAppInstalledApp: Record "NAV App Installed App"; ModuleDependency: ModuleDependencyInfo)
    var
        OVWAppDependency: Record "OVW App Dependency";
    begin
        OVWAppDependency.Init();
        OVWAppDependency."App Id" := NAVAppInstalledApp."App ID";
        OVWAppDependency."Dependent App Id" := ModuleDependency.Id;
        OVWAppDependency."App Name" := NAVAppInstalledApp.Name;
        OVWAppDependency."Dependent App Name" := CopyStr(ModuleDependency.Name, 1, MaxStrLen(OVWAppDependency."Dependent App Name"));
        OVWAppDependency."App Publisher" := NAVAppInstalledApp.Publisher;
        OVWAppDependency."Dependent App Publisher" := CopyStr(ModuleDependency.Publisher, 1, MaxStrLen(OVWAppDependency."Dependent App Publisher"));
#if CLEAN2
        OnBeforeInitDependencyRecord(NAVAppInstalledApp, ModuleDependency, OVWAppDependency);
#endif        
        OnBeforeInitializeDependencyRecord(NAVAppInstalledApp, ModuleDependency, OVWAppDependency);
        OVWAppDependency.Insert(true);
    end;

    local procedure GetDependencies(NAVAppInstalledApp: Record "NAV App Installed App"): List of [ModuleDependencyInfo];
    var
        Module: ModuleInfo;
    begin
        NavApp.GetModuleInfo(NAVAppInstalledApp."App ID", Module);
        exit(Module.Dependencies());
    end;

    local procedure ClearDependencyTable()
    var
        OVWAppDependency: Record "OVW App Dependency";
    begin
        if not OVWAppDependency.IsEmpty() then
            OVWAppDependency.DeleteAll(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitDependencyRecords(var NAVAppInstalledApp: Record "NAV App Installed App"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitDependencyRecords(NAVAppInstalledApp: Record "NAV App Installed App")
    begin
    end;

#if CLEAN2
    [IntegrationEvent(false, false)]
    [Obsolete('Use OnBeforeInitializeDependencyRecord instead')]
    local procedure OnBeforeInitDependencyRecord(NAVAppInstalledApp: Record "NAV App Installed App"; ModuleDependency: ModuleDependencyInfo; var OVWAppDependencies: Record "OVW App Dependency")
    begin
    end;
#endif    

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitializeDependencyRecord(NAVAppInstalledApp: Record "NAV App Installed App"; ModuleDependency: ModuleDependencyInfo; var OVWAppDependency: Record "OVW App Dependency")
    begin
    end;
}