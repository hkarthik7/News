function Read-News {

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

    .PARAMETER ExportPath
    Provide the path of file to save the results.

    .PARAMETER Country
    Provide the Country name for title.

    .PARAMETER ReferenceName
    Provide the Reference file name.

    .PARAMETER ReferenceLink
    Provide the Reference file link.

    .PARAMETER LogPath
    Provide the path to save log results.

    .EXAMPLE
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

    Read-News @UK


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
    harish.karthic     2.1	        19/04/2020		Added logging functionality
    harish.karthic     2.2	        20/04/2020		Created as a new module
    harish.karthic     2.3	        25/04/2020		Bug fix and alternate image url
    harish.karthic     2.4	        26/04/2020		Minor tweak
    harish.karthic     2.5	        26/04/2020		Change in title
    harish.karthic     2.6	        27/04/2020		Added code to open news in new tab
#>

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
        [string]$ReferenceLink,

        [Parameter(Mandatory=$true)]
        [string]$LogPath
    )

    begin {
        $functionName = $MyInvocation.MyCommand.Name
        $LogFile = $LogPath + "\Read-News_$(Get-Date -Format ddMMyyyy).log"

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
            <title>$($Country) NEWS</title>
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
                    <a class="nav-link" href="$($ReferenceLink)">$($ReferenceName)</a>
                    <a class="nav-link" href="../covid-19.html">COVID-19</a>
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
            "[$(Get-Date -Format s)] : $($functionName) : Getting News from News API.." | Out-File $LogFile -Append

            # Get url response
            $response = Get-Response -ApiKey $ApiKey -Uri $Url -LogFile $LogFile -Verbose

            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Creating App contents and building News App.."
            "[$(Get-Date -Format s)] : $($functionName) : Creating App contents and building News App.."  | Out-File $LogFile -Append

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
                                <a href="$($response.articles[$i].url)" class="card-link" target="_blank">$($response.articles[$i].title)</a>
                            </div>
                        </div>
                    </div>
"@
                }
                else {
                    $urlToImage = "https://cms-assets.tutsplus.com/uploads/users/2273/posts/34547/image/Dard-Ornaments.jpg"
                    $html += @"
                    <div class="col mb-4">
                        <div class="card" style="width: 18rem;">
                            <img src="$($urlToImage)" class="card-img-top" alt="image">
                            <div class="card-body">
                                <a href="$($response.articles[$i].url)" class="card-link" target="_blank">$($response.articles[$i].title)</a>
                            </div>
                        </div>
                    </div>
"@
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
            "[$(Get-Date -Format s)] : $($functionName) : Exporting results.." | Out-File $LogFile -Append

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
Export-ModuleMember -Function Read-News
# SIG # Begin signature block
# MIIFwgYJKoZIhvcNAQcCoIIFszCCBa8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUevN1sOVGbqXCa21aVZoxQbd9
# eh6gggNLMIIDRzCCAjOgAwIBAgIQDp2TmZ27p7RI1Rz3x2O1GTAJBgUrDgMCHQUA
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
# MAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFBD5xMuj3AuYfcMNljcIU4aB
# xBMgMA0GCSqGSIb3DQEBAQUABIIBAAT1SKppLH/lFml17YHP2dvJML1EEXCrf3vi
# s0+ZzuBM67q6qqzHc+3vNNTDpR9LZlGRp+oOY9pgk4nm0oJ0ncTvwEu/BSGyuxhA
# KKPZo38yLh+YHvhg7qxmfT2eREUqF3EkMrxvDq/8gcNFQ7Oy5h6a/NeyA5scMxqg
# nqH4gHUdm2LNdeWRDfpSxphZgg3ULEZ2tre+OtpdNOaBcYOlYUYjCRw3mp5tqa57
# W2r9PL8rQFOwJixpPh5Xt3UROtSbc2SUnnjxCB6407BjkgRCJmU7i8mELZHfxWfT
# /KlvxmqhQ12ufXnvvPIUt/gpf6WpKc+nigenx7++CgutCJlgLpM=
# SIG # End signature block
