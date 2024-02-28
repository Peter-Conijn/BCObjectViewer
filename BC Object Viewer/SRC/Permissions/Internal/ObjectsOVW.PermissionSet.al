namespace ALRabbit.BCObjectViewer.Permissions.Internal;

using ALRabbit.BCObjectViewer.Common.Excel;
using ALRabbit.BCObjectViewer.Common;
using ALRabbit.BCObjectViewer.Viewers.ObjectsPerApp.Dependencies;
using ALRabbit.BCObjectViewer.Viewers.ObjectsPerApp;
using ALRabbit.BCObjectViewer.Viewers.ObjectInformation;

permissionset 50130 "OVW - Objects"
{
    Assignable = false;
    Access = Internal;

    Permissions =
        table "OVW App Dependency" = X,
        tabledata "OVW App Dependency" = RIMD,
        codeunit "OVW Dependency Management" = X,
        codeunit "OVW Export to Excel" = X,
        codeunit "OVW Object Management" = X,
        codeunit "OVW Record Count Mgt." = X,
        page "OVW Application Objects" = X,
        page "OVW Depended On By - Factbox" = X,
        page "OVW Depends On - Factbox" = X,
        page "OVW Objects per App" = X,
        page "OVW Object Viewer" = X;
}