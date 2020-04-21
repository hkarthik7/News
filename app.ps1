<#
.SYNOPSIS
This script defines the app layout by importing and processing necessary module.

.DESCRIPTION
This script is intented to import the module which contains news app scripts
and runs it by passing necessary parameters.
#>

#region module refresh

$ModulePath = Get-ChildItem -Path ".\Module" | Select-Object Name, FullName
$ModulePath | Foreach-Object {
    Import-Module -Name $_.FullName
}

#endregion module refresh

# run functions
$UK = @{
    ApiKey = (Import-Clixml .\Key.clixml).GetNetworkCredential().Password
    Url = 'http://newsapi.org/v2/top-headlines?country=gb'
    ExportPath = ".\index.html"
    Country = "UK"
    ReferenceName = "INDIA"
    ReferenceLink = "india.html"
    LogPath = ".\Logs"
    Verbose = $true
}

$INDIA = @{
    ApiKey = (Import-Clixml .\Key.clixml).GetNetworkCredential().Password
    Url = 'http://newsapi.org/v2/top-headlines?country=in'
    ExportPath = ".\india.html"
    Country = "INDIA"
    ReferenceName = "UK"
    ReferenceLink = "index.html"
    LogPath = ".\Logs"
    Verbose = $true
}

$CovidData = @{
    Url = "https://thevirustracker.com/free-api?global=stats"
    CountryUrl = "https://thevirustracker.com/free-api?countryTimeline=GB"
    FilePath = ".\Reports"
    LogPath = ".\Logs"
    Verbose = $true
}

Read-News @UK
Read-News @INDIA
Get-CovidData @CovidData
