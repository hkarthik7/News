$testPath = $MyInvocation.MyCommand.Path
$scriptPath = Split-Path $testPath -Parent

Push-Location (Split-Path $scriptPath)

$contents = Get-Content -Path ".\settings.json" -Raw | ConvertFrom-Json
$modulePath = $contents.parameters.reportPaths.modulePath
$key = (Import-Clixml $contents.parameters.apiKey).GetNetworkCredential().Password

Import-Module $modulePath

Context "Test Module" {
    Describe "Test Response" {
        it "Should be string" {
            $res = Get-Response -Uri "https://www.google.com" `
            -LogFile "$($contents.parameters.reportPaths.logPath)\Response.Tests.log"
            
            $res.GetType() | Should -Be string
        }

        It "Should be an Object" {
            $r = Get-Response -ApiKey $key `
                -Uri $contents.parameters.countries.url.Replace("@countryName", "gb") `
                -LogFile "$($contents.parameters.reportPaths.logPath)\Response.Tests.log"
            
            $r.articles.GetType() | Should -Be System.Object[]
        }
    }
}

Pop-Location