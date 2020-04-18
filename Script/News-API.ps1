<#
    .SYNOPSIS
    This is designed to extract news from News API and create a mobile friendly app for displaying latest
    UK and other country news.

    .DESCRIPTION
    This script extracts News from News API and creates app only using PowerShell and HTML fragments.

    .PARAMETER ApiKey
    Provide the API key of News API. 

    NOTE: if API key is not available web scrapping can be done and the class UrlResponse returns the 
    response data of passed in url.

    .PARAMETER Url
    Provide the Url to retrieve response.

    .PARAMETER FilePath
    Provide the path of file to save the results.

    .EXAMPLE
    $response = [UrlResponse]::new()
    $response.GetResponse("https://www.google.com")

    .NOTES
    Author             Version		 Date			Notes
    ----------------------------------------------------------------------
    harish.karthic     1.0	        10/04/2020		Initial script
    harish.karthic     1.1	        11/04/2020		Read-News Advanced function to retrieve news from News API
    harish.karthic     1.2	        14/04/2020		Modified HTML code
    harish.karthic     1.3	        15/04/2020		Minor bug fix
    harish.karthic     1.4	        15/04/2020		Added multipage layout with additional news from another country
    harish.karthic     1.5	        18/04/2020		Added comment based help
    harish.karthic     2.0	        18/04/2020		Added Covid-19 data, link and function
#>

class UrlResponse {

    [string] $ApiKey
    [string] $FilePath
    [string] $Uri

    [string] ToString() {
        return ("{0}|{1}|{2}" -f $this.ApiKey, $this.FilePath, $this.Uri)
    }

    [PSCustomObject] GetResponse([string] $Url, [string] $UrlApiKey) {
        $headers = @{
            Authorization = $UrlApiKey
        }

        return Invoke-RestMethod -Uri $Url -Headers $headers
    }

    [PSCustomObject] GetResponse([string] $Url) {

        return Invoke-RestMethod -Uri $Url
    }

}

#####################################################################################
#                                   NEWS APP                                        #
#####################################################################################

function Read-News {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$ApiKey,

        [Parameter(Mandatory=$true)]
        [string]$Url,

        [Parameter(Mandatory=$true)]
        [string]$ExportPath,

        [Parameter(Mandatory=$true)]
        [string]$Country,

        [Parameter(Mandatory=$true)]
        [string]$ReferenceName,

        [Parameter(Mandatory=$true)]
        [string]$ReferenceLink
    )

    begin {
        $functionName = $MyInvocation.MyCommand.Name

        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Begin Function.."

        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) :  Building HTML.."

        #region generate HTML static page
        $html = @"
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>$($Country) NEWS</title>
            <link rel="icon" type="image/png" href="https://images.squarespace-cdn.com/content/v1/59d5623537c5817ce09196bf/1508964400127-ULPDNY4QJ0LER0CCNPTL/ke17ZwdGBToddI8pDm48kAg3YtiXGb9Y30HSwlFqSWBZw-zPPgdn4jUwVcJE1ZvWhcwhEtWJXoshNdA9f1qD7dso8WS9HrXe-DDzLfr_qHkbriZg0Iu-s4mCjNkVmIrbmHWNG1OBCSefqzw2QRxcVQ/favicon.png">

            <!-- Bootstrap CSS -->
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        </head>
        <body>
        <nav class="navbar navbar-expand-lg text-white navbar-dark bg-dark">
            <a class="navbar-brand">
                <img src="https://images.squarespace-cdn.com/content/v1/59d5623537c5817ce09196bf/1508964400127-ULPDNY4QJ0LER0CCNPTL/ke17ZwdGBToddI8pDm48kAg3YtiXGb9Y30HSwlFqSWBZw-zPPgdn4jUwVcJE1ZvWhcwhEtWJXoshNdA9f1qD7dso8WS9HrXe-DDzLfr_qHkbriZg0Iu-s4mCjNkVmIrbmHWNG1OBCSefqzw2QRxcVQ/favicon.png" width="30" height="30" class="d-inline-block align-top" alt="News">
                NEWS
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
                <div class="navbar-nav">
                    <a class="nav-link" href="$($ReferenceLink)">$($ReferenceName)</a>
                    <a class="nav-link" href="covid-19.html">COVID-19</a>
                </div>
            </div>
        </nav>
            <br>
            <div class="container-fluid">
                <div class="shadow-lg p-3 mb-5 bg-white rounded">
                    <div class="row row-cols-1 row-cols-md-2">
"@
        #endregion generate HTML static page

    }

    process {
        try {
            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Getting News from News API.."

            # instantiate class
            $news = [UrlResponse]::new()
            $response = $news.GetResponse($Url, $ApiKey)

            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Creating App contents and building News App.."

            $counter = if(($response.articles.Count % 3) -eq 0) { $response.articles.Count } else {
                for ($i = 0; $i -lt $response.articles.Count; $i++) {
                    if ((($response.articles.Count - $i) % 3) -eq 0) {
                        $response.articles.Count - $i
                        break
                    }
                    else {
                        continue
                    }
                }
            }

            # Create top news cards
            for ($i = 0; $i -lt $counter; $i++) {
                
                if ($null -ne $response.articles[$i].urlToImage) {
                    $html += @"
                    <div class="col mb-4">
                        <div class="card" style="width: 18rem;">
                            <img src="$($response.articles[$i].urlToImage)" class="card-img-top" alt="image">
                            <div class="card-body">
                                <a href="$($response.articles[$i].url)" class="card-link">$($response.articles[$i].title)</a>
                            </div>
                        </div>
                    </div>
"@
                }
                else {
                    $counter ++
                }
            }

            $html += @"
                        </div>
                    </div>
                </div>
                <!-- Bootstrap JS -->
                <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
            </body>
            </html>
"@

            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Exporting results.."
            $html | Out-File $ExportPath

        }
        catch {
            Write-Host "[$(Get-Date -Format s)] $functionName : Error at line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    end {
        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : End Function.."
    } 
}

#####################################################################################
#                                   COVID-19                                        #
#####################################################################################

function Get-CovidData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [Parameter(Mandatory=$true)]
        [string]$CountryUrl,

        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )

    begin {
        $functionName = $MyInvocation.MyCommand.Name

        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Begin Function.."

        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) :  Building HTML.."

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
                            <a class="nav-link" href="index.html">UK</a>
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

            # instantiate class
            $covid = [UrlResponse]::new()
            $covidResponse = $covid.GetResponse($Url)

            $covidResponse.results | ConvertTo-Json | Out-File -FilePath "$FilePath\covid-results.json"

            $responsesCovid = Get-Content "$FilePath\covid-results.json" -Raw | ConvertFrom-Json

            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Creating App contents and building Covid App page.."

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
                    Do not meet others, even friends or family.
                    You can spread the virus even if you don’t have symptoms.
                </p>
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
            $covidUK = $covid.GetResponse($CountryUrl)

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

            $html | Out-File "$FilePath\covid-19.html"
        }
        catch {
            Write-Host "[$(Get-Date -Format s)] $functionName : Error at line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    end {
        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : End Function.."
    } 

    
}

# run function
$UK = @{
    ApiKey = (Import-Clixml .\Key.clixml).GetNetworkCredential().Password
    Url = 'http://newsapi.org/v2/top-headlines?country=gb'
    ExportPath = ".\index.html"
    Country = "UK"
    ReferenceName = "INDIA"
    ReferenceLink = "india.html"
    Verbose = $true
}

$INDIA = @{
    ApiKey = (Import-Clixml .\Key.clixml).GetNetworkCredential().Password
    Url = 'http://newsapi.org/v2/top-headlines?country=in'
    ExportPath = ".\india.html"
    Country = "INDIA"
    ReferenceName = "UK"
    ReferenceLink = "index.html"
    Verbose = $true
}

$CovidData = @{
    Url = "https://thevirustracker.com/free-api?global=stats"
    CountryUrl = "https://thevirustracker.com/free-api?countryTimeline=GB"
    FilePath = ".\"
    Verbose = $true
}

Read-News @UK
Read-News @INDIA
Get-CovidData @CovidData
Invoke-Item $UK.ExportPath
