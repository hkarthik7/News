<#
.SYNOPSIS
This is designed to extract UK(GB) latest news from News API and create a mobile friendly app for displaying latest
UK news.

.DESCRIPTION
This script extracts latest UK News from News API and creates app only using PowerShell and HTML fragments.

.NOTES
Author: Harish Karthic
Date: 10/04/2020
Version: v1.0
Comments: Intial Script for UK News App
#>

class UrlResponse {

    [string] $ApiKey
    [string] $FilePath
    [string] $Uri

    [string] ToString() {
        return ("{0}|{1}|{2}" -f $this.ApiKey, $this.FilePath, $this.Uri)
    }

    [PSCustomObject] GetRespose([string] $Url, [string] $UrlApiKey) {
        $headers = @{
            Authorization = $UrlApiKey
        }

        return Invoke-RestMethod -Uri $Url -Headers $headers
    }

}

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
            $response = $news.GetRespose($Url, $ApiKey)

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

# run function
$UK = @{
    ApiKey = (Import-Clixml .\Api-key.clixml).GetNetworkCredential().Password
    Url = 'http://newsapi.org/v2/top-headlines?country=gb'
    ExportPath = ".\index.html"
    Country = "UK"
    ReferenceName = "INDIA"
    ReferenceLink = "india.html"
    Verbose = $true
}

$INDIA = @{
    ApiKey = (Import-Clixml .\Api-key.clixml).GetNetworkCredential().Password
    Url = 'http://newsapi.org/v2/top-headlines?country=in'
    ExportPath = ".\india.html"
    Country = "INDIA"
    ReferenceName = "UK"
    ReferenceLink = "index.html"
    Verbose = $true
}

Read-News @UK
Read-News @INDIA

Invoke-Item $UK.ExportPath