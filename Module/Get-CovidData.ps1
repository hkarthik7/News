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
    harish.karthic     1.0	        21/04/2020		Added into module
    harish.karthic     1.0	        22/04/2020		Minor bug fix

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
                            <a class="nav-link" href="uk.html">UK</a>
                            <a class="nav-link" href="india.html">INDIA</a>
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
                <a class="btn btn-primary btn-sm" href="$($responsesCovid.source.url)" role="button">Learn more</a>
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