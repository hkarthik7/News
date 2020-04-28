function Get-CovidData {

<#
    .SYNOPSIS
    This script gets the Covid19 data from thevirustracker.com.

    .DESCRIPTION
    This script gets the Covid19 data from thevirustracker.com and only UK report is
    currently provisioned and displayed.

    .PARAMETER CountryUrl
    Provide the url of country to get the covid reports from.

    .PARAMETER Uri
    Provide the Url to retrieve response.

    .PARAMETER FilePath
    Provide the path to save report.

    .PARAMETER LogPath
    Provide the path to save log files.

    .EXAMPLE
    Get-Response -Uri "https://www.google.com"

    .NOTES
    Author             Version		 Date			Notes
    ----------------------------------------------------------------------
    harish.karthic     1.0	        17/04/2020		Initial script
    harish.karthic     1.1	        21/04/2020		Added into module
    harish.karthic     1.2	        22/04/2020		Minor bug fix
    harish.karthic     1.3	        26/04/2020		Parameterised reference name and link values
    harish.karthic     1.4	        27/04/2020		Added code to open news in new tab

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [Parameter(Mandatory=$true)]
        [string]$CountryUrl,

        [Parameter(Mandatory=$true)]
        [string]$FilePath,

        [Parameter(Mandatory=$true)]
        [string]$Name,

        [Parameter(Mandatory=$true)]
        [string]$FileName,

        [Parameter(Mandatory=$true)]
        [string]$ExportPath,

        [Parameter(Mandatory=$true)]
        [string]$LogPath
    )

    begin {
        $functionName = $MyInvocation.MyCommand.Name
        $LogFile = $LogPath + "\Covid19_$(Get-Date -Format ddMMyyyy).log"

        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Begin Function.."
        "[$(Get-Date -Format s)] : $($functionName) : Begin Function.." | Out-File $LogFile -Append

        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Building HTML.."
        "[$(Get-Date -Format s)] : $($functionName) :  Building HTML.." | Out-File $LogFile -Append

        #region generate HTML static page
        $html = @"
        <!DOCTYPE html>
        <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>COVID-19</title>
                <link rel="icon" type="image/png" href="https://ps.w.org/corona-virus-data/assets/icon-256x256.png?rev=2248214">

                <!-- Bootstrap CSS -->
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
            </head>
            <body>
                <nav class="navbar navbar-expand-lg text-white navbar-dark bg-dark">
                    <a class="navbar-brand">
                        <img src="https://ps.w.org/corona-virus-data/assets/icon-256x256.png?rev=2248214" width="30" height="30" class="d-inline-block align-top" alt="Covid">
                        COVID-19
                    </a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
                        <div class="navbar-nav">
                        <a class="nav-link" href="$($FileName)">$($Name)</a>
                        </div>
                    </div>
                </nav>

                <br>
                <div class="container-fluid">
                    <div class="jumbotron">
                        <h1 class="display-4">COVID-19</h1>
                        <p class="lead">Over all new cases, affected countries and more details.</p>
                        <hr class="my-4">
                        <br>
                        <div class="row row-cols-1 row-cols-md-2">
"@
        #endregion generate HTML static page

    }

    process {
        try {
            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Getting COVID-19 details.."
            "[$(Get-Date -Format s)] : $($functionName) : Getting COVID-19 details.." | Out-File $LogFile -Append

            # instantiate class
            $covidResponse = Get-Response -Uri $Url -LogFile $LogFile -Verbose

            $covidResponse.results | ConvertTo-Json | Out-File -FilePath "$FilePath\covid-results.json"

            $responsesCovid = Get-Content "$FilePath\covid-results.json" -Raw | ConvertFrom-Json

            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Creating App contents and building Covid App page.."
            "[$(Get-Date -Format s)] : $($functionName) : Creating App contents and building Covid App page.." | Out-File $LogFile -Append

            $html += @"
            <div class="col mb-4">
                <div class="card bg-dark text-white text-center text-center">
                    <div class="card-body">
                        <p class="card-text">$($responsesCovid.total_cases)</p>
                        <p class="card-text text-muted">TOTAL CASES</p>
                    </div>
                </div>
            </div>
            <div class="col mb-4">
                <div class="card bg-dark text-white text-center text-center">
                    <div class="card-body">
                        <p class="card-text">$($responsesCovid.total_recovered)</p>
                        <p class="card-text text-muted">TOTAL RECOVERED</p>
                    </div>
                </div>
            </div>
            <div class="col mb-4">
                <div class="card bg-dark text-white text-center text-center">
                    <div class="card-body">
                        <p class="card-text">$($responsesCovid.total_unresolved)</p>
                        <p class="card-text text-muted">TOTAL UNRESOLVED</p>
                    </div>
                </div>
            </div>
            <div class="col mb-4">
                <div class="card bg-dark text-white text-center text-center">
                    <div class="card-body">
                        <p class="card-text">$($responsesCovid.total_deaths)</p>
                        <p class="card-text text-muted">TOTAL DEATHS</p>
                    </div>
                </div>
            </div>
            <div class="col mb-4">
                <div class="card bg-dark text-white text-center text-center">
                    <div class="card-body">
                        <p class="card-text">$($responsesCovid.total_new_cases_today)</p>
                        <p class="card-text text-muted">TOTAL NEW CASES TODAY</p>
                    </div>
                </div>
            </div>
            <div class="col mb-4">
                <div class="card bg-dark text-white text-center text-center">
                    <div class="card-body">
                        <p class="card-text">$($responsesCovid.total_new_deaths_today)</p>
                        <p class="card-text text-muted">TOTAL DEATHS TODAY</p>
                    </div>
                </div>
            </div>
"@
            $html += @"
            </div>
                <hr class="my-4">
                <p> <b>Stay at home</b>
                    <li>Only go outside for food, health reasons or work (but only if you cannot work from home)</li>
                    <li>If you go out, stay 2 metres (6ft) away from other people at all times</li>
                    <li>Wash your hands as soon as you get home</li>
                </p>
                    <p>Do not meet others, even friends or family.</p>
                    <p>You can spread the virus even if you don't have symptoms.</p>
                <hr class="my-4">
                <a class="btn btn-primary btn-sm" href="$($responsesCovid.source.url)" role="button" target="_blank">Learn more</a>
            </div>
                <h1 class="display-5">COVID-19 UK DATA</h1>
                <hr>
                <br>
                <table class="table table-hover table-bordered">
                    <thead class="table-info">
                        <tr>
                            <th scope="col">DATE</th>
                            <th scope="col">DAILY CASES</th>
                            <th scope="col">DAILY DEATHS</th>
                            <th scope="col">TOTAL CASES</th>
                            <th scope="col">TOTAL RECOVERIES</th>
                            <th scope="col">TOTAL DEATHS</th>
                        </tr>
                    </thead>
                    <tbody>
"@

            # Create COVID-19 UK TABLE
            $covidUK = Get-Response -Uri $CountryUrl -LogFile $LogFile -Verbose

            $covidUK.timelineitems | ConvertTo-Json -Depth 100 | Out-File "$FilePath\covid-uk.json"

            $uk = Get-Content -Path "$FilePath\covid-uk.json" -Raw | ConvertFrom-Json

            # $counter = ((Get-Date) - (Get-Date -Date "01/31/2020")).Days
            $counter = 11

            for ($i = 1; $i -le $counter; $i++) {

                $date = Get-Date ((Get-Date).AddDays(-$i)) -Format M/dd/yy

                $html += @"
                <tr>
                    <td>$date</td>
                    <td>$($uk.$date.new_daily_cases)</td>
                    <td>$($uk.$date.new_daily_deaths)</td>
                    <td>$($uk.$date.total_cases)</td>
                    <td>$($uk.$date.total_recoveries)</td>
                    <td>$($uk.$date.total_deaths)</td>
                </tr>
"@
                
            }

            $html += @"
                                </tbody>
                            </table>
                        </div>        
                    <!-- Bootstrap JS -->
                    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
                    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
                    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
                </body>
            </html>
"@

            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Exporting results.."
            "[$(Get-Date -Format s)] : $($functionName) : Exporting results.." | Out-File $LogFile -Append

            $html | Out-File "$ExportPath\covid-19.html"
        }
        catch {
            Write-Host "[$(Get-Date -Format s)] $functionName : Error at line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" -ForegroundColor Red
            "[$(Get-Date -Format s)] $functionName : Error at line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" | Out-File $LogFile -Append
        }
    }

    end {
        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : End Function.."
        "[$(Get-Date -Format s)] : $($functionName) : End Function.." | Out-File $LogFile -Append
    } 

    
}
Export-ModuleMember -Function Get-CovidData
# SIG # Begin signature block
# MIIFwgYJKoZIhvcNAQcCoIIFszCCBa8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUc4ri1ItV/+3JFPdalJqQSFdH
# UGSgggNLMIIDRzCCAjOgAwIBAgIQDp2TmZ27p7RI1Rz3x2O1GTAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0yMDA0MjgxOTAwNDZaFw0zOTEyMzEyMzU5NTlaMCMxITAfBgNVBAMTGFBvd2Vy
# U2hlbGwgU2NyaXB0IFNpZ25lcjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
# ggEBALWmYGUBOglQ0msii757d27Mlye+eRNWFI3uxM0xnYYCyZz6SpMrCczu7KS1
# tS4bR9iPzxvL3OwlocEuncawZ9eurStnVIFCc7ISQDVU/l7jKxgnPjVfWvhoQBZy
# UZsCyibTNYX9IyN4RG3c/BU2ulIQWZaJnd4xc2wsKgJTCKSQDFX2YNab8d+E20ju
# 6++hw8B2xzvdYqaqBi8tGvrPcpp5kUD/qFdfgV/aQ/02qZj4VzTkBTEUx+pEfFh8
# Sn6q7eQHO75BW/lwgORssTPtvDmPBU2Iehs1bi14/ADhiuGRwAUZ4rmTvQDCZHGE
# s2CqKzdsz3FePnEJZsxKyGmW+kUCAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYBBQUH
# AwMwXQYDVR0BBFYwVIAQSj+XnuMPkKa3vhrW3zVPUaEuMCwxKjAoBgNVBAMTIVBv
# d2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQkb6Bn8B09ZlM0D5qR1ed
# QTAJBgUrDgMCHQUAA4IBAQBFRyPmOFISQdISJu3HG8OL6mcFW5RjEzDc/nkVK1e0
# Ly69Vqvg83ARwYUyAEX42upVUNXfZmdlC834K1vKEr4lUU00l2ctt0fCvTLfqV5I
# N8Il3uDpS5OKX49OoHeWCAeV/HzcRKo4Y5Xy3CCktnzOulqMnckdm0M6YEFDfVUg
# n7JyVLe66fwSnUjkC7v5sWMkLoGQGRZOaReIox9b0tKa+Q/wYP5iVq9BjMdzqb+k
# Yr8BKfbdZEkSFFvBouOcWqidLLMuJIzDvNfL6dCyl+J0gryMZ/Ww5N+YUiLIXfZG
# sqf8aBKXiUJBsslpnsW0eqDx9/Z6BImZE5SqT87olzKTMYIB4TCCAd0CAQEwQDAs
# MSowKAYDVQQDEyFQb3dlclNoZWxsIExvY2FsIENlcnRpZmljYXRlIFJvb3QCEA6d
# k5mdu6e0SNUc98djtRkwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKA
# AKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFDMeCQWI73yQiRipSCLfA7H6
# YN1kMA0GCSqGSIb3DQEBAQUABIIBAJMU2iKQBJtVCxNRHbBDIaszN2lco0fsjY9y
# OPdVT3HEuraNINSyzd8zDojY4VNhqi07DUipIzeETfgxAO8OYxQ9qhnwwFkLO+Et
# yNVyex2irb5vFWnvT5BRwG6jYNVKgpbI3dVbJLwkJ4ufW/0xQM9c+JyMPsWOVDfZ
# Ln6gWETVuGjwtrfFxJjRCME77Aw0KKWiCFkNPfxUSCJrbswTOkwmSWKaMc2G+WCF
# ErfzLDkcOYYh2xbnCKWEtKLTij3obWbGJH8ly8E7/k1W2fOHwXEWdf3rAP2h9whV
# ygpB1JDT5lEro9QAP5r7y7jw+i+RytRemffgKbvjprVac/fVqws=
# SIG # End signature block
