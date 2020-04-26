<#
.SYNOPSIS
This script defines the app layout by importing and processing necessary module.

.DESCRIPTION
This script is intented to import the module which contains news app scripts
and runs it by passing necessary parameters.

.LINK
https://restcountries.eu/

.NOTES
Author             Version		 Date			Notes
----------------------------------------------------------------------
harish.karthic     1.0	        22/04/2020		Initial script
harish.karthic     1.1	        24/04/2020		Minor tweak
harish.karthic     1.3	        24/04/2020		Removed hard coded values and moved
                                                mandatory settings to settings.json
                                                file.
harish.karthic     1.4	        26/04/2020		Added homepage function and parameters

#>

#region module refresh

Import-Module .\Module

# set TLS version to 1.2

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# run functions

$settings = Get-Content -Path ".\settings.json" -Raw | ConvertFrom-Json

$countryCodes = $settings.parameters.countries.codes

# Get homepage

$homePage = @{
    ApiKey = (Import-Clixml $settings.parameters.apiKey).GetNetworkCredential().Password
    Url = $settings.parameters.countries.url
    Name = $settings.parameters.countries.referenceName
    FileName = $settings.parameters.countries.referenceLink
    CountryCodes = $settings.parameters.countries.codes
    CountryNames = $settings.parameters.countries.names
    FilePath = $settings.parameters.reportPaths.exportPath
    ExportPath = $settings.parameters.countries.referenceLink
    LogPath = $settings.parameters.reportPaths.logPath
    Verbose = $true
}

Get-HomePage @homePage

# Create news file for each available country

for ($i = 0; $i -lt $countryCodes.Count; $i++) {

    $fileName = $settings.parameters.countries.fileName.Replace("@countryName", $countryCodes[$i])

    $exportPath = "$($settings.parameters.reportPaths.exportPath)\$($fileName)"

    $params = @{
        ApiKey = (Import-Clixml $settings.parameters.apiKey).GetNetworkCredential().Password
        Url = $settings.parameters.countries.url.Replace("@countryName", $countryCodes[$i])
        ExportPath = $exportPath
        Country = $settings.parameters.countries.names[$i]
        ReferenceName = $settings.parameters.countries.referenceName
        ReferenceLink = "../" + $settings.parameters.countries.referenceLink
        LogPath = $settings.parameters.reportPaths.logPath
        Verbose = $true
    }

    Read-News @params
}

# fetch covid-19 daily data

$CovidData = @{
    Url = $settings.parameters.covid19.url
    CountryUrl = $settings.parameters.covid19.countryUrl
    FilePath = $settings.parameters.covid19.filePath
    Name = $settings.parameters.countries.referenceName
    FileName = $settings.parameters.countries.referenceLink
    ExportPath = $settings.parameters.reportPaths.exportPath.Replace("Countries", "")
    LogPath = $settings.parameters.reportPaths.logPath
    Verbose = $true
}

Get-CovidData @CovidData
