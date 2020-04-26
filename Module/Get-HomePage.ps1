function Get-HomePage {

    <#
    .SYNOPSIS
    This script is to display the home page of The Daily News.

    .DESCRIPTION
    This script is to display the home page of The Daily News with countries listed.

    .PARAMETER Url
    Provide the url of country to get the news.

    .PARAMETER ApiKey
    Provide the ApiKey to retrieve response.

    .PARAMETER Name
    Provide the reference name. In this case it is Home.

    .PARAMETER FileName
    Provide the reference file name. In this cas it is index.html.

    .PARAMETER CountryCodes
    Provide the country codes.

    .PARAMETER CountryNames
    Provide the country names.

    .PARAMETER FilePath
    Provide the path of all possible countries html page.

    .PARAMETER ExportPath
    Provide the path to save report.

    .PARAMETER LogPath
    Provide the path to save log files.

    .EXAMPLE
    $homePage = @{
        ApiKey = "ApiKey"
        Url = "url"
        Name = "Home"
        FileName = "index.html"
        CountryCodes = "gb", "in"
        CountryNames = "Unitd Kingdom", "India"
        FilePath = "C:\Path\To\File"
        ExportPath = "C:\Path\To\Save\File"
        LogPath = "C:\Path\To\Save\Log\File"
        Verbose = $true
    }

    Get-HomePage @homePage

    .NOTES
    Author             Version		 Date			Notes
    ----------------------------------------------------------------------
    harish.karthic     1.0	        26/04/2020		Initial script
    harish.karthic     1.1	        26/04/2020		Change in title

#>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [Parameter(Mandatory=$true)]
        [string]$ApiKey,

        [Parameter(Mandatory=$true)]
        [string]$Name,

        [Parameter(Mandatory=$true)]
        [string]$FileName,

        [Parameter(Mandatory=$true)]
        [string[]]$CountryCodes,

        [Parameter(Mandatory=$true)]
        [string[]]$CountryNames,

        [Parameter(Mandatory=$true)]
        [string]$FilePath,

        [Parameter(Mandatory=$true)]
        [string]$ExportPath,

        [Parameter(Mandatory=$true)]
        [string]$LogPath
    )
    
    begin {
        $functionName = $MyInvocation.MyCommand.Name
        $LogFile = $LogPath + "\Homepage_$(Get-Date -Format ddMMyyyy).log"

        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Begin Function.."
        "[$(Get-Date -Format s)] : $($functionName) : Begin Function.." | Out-File $LogFile -Append

        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Building HTML.."
        "[$(Get-Date -Format s)] : $($functionName) :  Building HTML.." | Out-File $LogFile -Append

        #region generate HTML static page
        $html = @"
        <!DOCTYPE html>
        <html lang="en">
            <head>
                <!-- Bootstrap meta tag -->
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>THE DAILY NEWS</title>
                <link rel="icon" type="image/png" href="https://images.squarespace-cdn.com/content/v1/59d5623537c5817ce09196bf/1508964400127-ULPDNY4QJ0LER0CCNPTL/ke17ZwdGBToddI8pDm48kAg3YtiXGb9Y30HSwlFqSWBZw-zPPgdn4jUwVcJE1ZvWhcwhEtWJXoshNdA9f1qD7dso8WS9HrXe-DDzLfr_qHkbriZg0Iu-s4mCjNkVmIrbmHWNG1OBCSefqzw2QRxcVQ/favicon.png">

                <!-- Bootstrap CSS -->
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
            </head>
            <body>
                <nav class="navbar navbar-expand-lg text-white navbar-dark bg-dark">
                    <a class="navbar-brand">
                        <img src="https://images.squarespace-cdn.com/content/v1/59d5623537c5817ce09196bf/1508964400127-ULPDNY4QJ0LER0CCNPTL/ke17ZwdGBToddI8pDm48kAg3YtiXGb9Y30HSwlFqSWBZw-zPPgdn4jUwVcJE1ZvWhcwhEtWJXoshNdA9f1qD7dso8WS9HrXe-DDzLfr_qHkbriZg0Iu-s4mCjNkVmIrbmHWNG1OBCSefqzw2QRxcVQ/favicon.png" width="30" height="30" class="d-inline-block align-top" alt="News">
                        THE DAILY NEWS
                    </a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
                        <div class="navbar-nav">
                            <a class="nav-link" href="$($FileName)">$($Name)</a>
                            <a class="nav-link" href="covid-19.html">COVID-19</a>
                        </div>
                    </div>
                </nav>
                <br>
                <div class="container">
                    <h3 class="display-4" style="text-align: center;">THE DAILY NEWS</h3>
                </div>
                <br>
                <div class="container">
                    <p class="lead">HEADLINES TODAY...</p>
                    <ul class="list-unstyled">
"@
    }

    process {
        try {

            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Building Homepage.."
            "[$(Get-Date -Format s)] : $($functionName) :  Building Homepage.." | Out-File $LogFile -Append

            for ($i = 0; $i -lt $CountryCodes.Count; $i++) {

                $html += @"
                <li class="media">
                    <img src="https://www.countryflags.io/$($CountryCodes[$i])/flat/64.png" class="mr-3" alt="$($CountryCodes[$i])">
                    <div class="media-body">
                    <h5 class="mt-0 mb-1"><a href="$($FilePath)\$($CountryCodes[$i]).html">$($CountryNames[$i])</a></h5>
                        $((Get-Response -ApiKey $ApiKey -Uri $Url.Replace("@countryName", $($CountryCodes[$i])) -LogFile $LogFile).articles.title[0])
                    </div>
                </li>
"@
            }
            
            $html += @"
                        </ul>
                    </div>
                </div>
                    <!-- Bootstrap JS -->
                    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
                    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
                    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
                </body>
            </html>
"@
            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Exporting Results.."
            "[$(Get-Date -Format s)] : $($functionName) :  Exporting Results.." | Out-File $LogFile -Append

            $html | Out-File $ExportPath
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
Export-ModuleMember -Function Get-HomePage
