<#
.SYNOPSIS
This script defines the app layout by importing and processing necessary module.

.DESCRIPTION
This script is intented to import the module which contains news app scripts
and runs it by passing necessary parameters.

.NOTES
Author             Version		 Date			Notes
----------------------------------------------------------------------
harish.karthic     1.0	        22/04/2020		Initial script
harish.karthic     1.1	        24/04/2020		Minor tweak
harish.karthic     1.3	        24/04/2020		Removed hard coded values and moved
                                                mandatory settings to settings.json
                                                file.
#>

#region module refresh

Import-Module .\Module

# run functions

$settings = Get-Content -Path ".\settings.json" -Raw | ConvertFrom-Json

$countries = @("UK", "INDIA")

foreach ($country in $countries) {

    $params = @{
        ApiKey = (Import-Clixml $settings.parameters.apiKey).GetNetworkCredential().Password
        Url = $settings.parameters.countries.$($country).url
        ExportPath = $settings.parameters.countries.$($country).fileName
        Country = $settings.parameters.countries.$($country).name
        ReferenceName = $settings.parameters.countries.$($country).referenceName
        ReferenceLink = $settings.parameters.countries.$($country).referenceLink
        LogPath = $settings.parameters.reportPaths.logPath
        Verbose = $true
    }

    Read-News @params

}

$CovidData = @{
    Url = $settings.parameters.covid19.url
    CountryUrl = $settings.parameters.covid19.countryUrl
    FilePath = $settings.parameters.covid19.filePath
    ExportPath = $settings.parameters.reportPaths.exportPath
    LogPath = $settings.parameters.reportPaths.logPath
    Verbose = $true
}

Get-CovidData @CovidData