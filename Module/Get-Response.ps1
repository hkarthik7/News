Function Get-Response {
    <#
        .SYNOPSIS
        Url response script for getting respone from an api or url.

        .DESCRIPTION
        Url response script for getting respone from an api or url.

        .PARAMETER ApiKey
        Provide the API key if applicable. 

        NOTE: if API key is not available web scrapping can be done and the class UrlResponse returns the 
        response data of passed in url.

        .PARAMETER Uri
        Provide the Url to retrieve response.

        .EXAMPLE
        Get-Response -Uri "https://www.google.com"

        .NOTES
        Author             Version		 Date			Notes
        ----------------------------------------------------------------------
        harish.karthic     1.0	        20/04/2020		Initial script
        harish.karthic     1.1	        20/04/2020		Minor bug fix

    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string] $ApiKey,

        [Parameter(Mandatory=$true)]
        [string] $Uri,

        [Parameter(Mandatory=$true)]
        [string] $LogFile
    )

    begin {
        # initialise function variable
        $functionName = $MyInvocation.MyCommand.Name

        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Begin Function.."
        "[$(Get-Date -Format s)] : $($functionName) : Begin Function.." | Out-File $LogFile -Append
    }

    process {
        try {
            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Getting response for given url $($Uri).."
            "[$(Get-Date -Format s)] : $($functionName) : Getting response for given url $($Uri).." | Out-File $LogFile -Append

            if (!($PSBoundParameters.ContainsKey('ApiKey'))) {

                $response = Invoke-RestMethod -Uri $Uri

            } else {

                $headers = @{
                    Authorization = $ApiKey
                }

                $response = Invoke-RestMethod -Uri $Uri -Headers $headers
            }
            
        }
        catch {
            Write-Host "[$(Get-Date -Format s)] $functionName : Error at line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" -ForegroundColor Red
            "[$(Get-Date -Format s)] $functionName : Error at line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" | Out-File $LogFile -Append
        }
    }

    end {
        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : End Function.."
        "[$(Get-Date -Format s)] : $($functionName) : End Function.." | Out-File $LogFile -Append

        return $response
    }
}
Export-ModuleMember -Function Get-Response

# SIG # Begin signature block
# MIIFwgYJKoZIhvcNAQcCoIIFszCCBa8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUyPVOmfdoWnwmtWf6e+nYVB77
# Tj+gggNLMIIDRzCCAjOgAwIBAgIQDp2TmZ27p7RI1Rz3x2O1GTAJBgUrDgMCHQUA
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
# MAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFNLiClOlDTR7z80eTFZ1qBAo
# j8yrMA0GCSqGSIb3DQEBAQUABIIBAIwOBwo9rXXMdQ+e8cqLD/6A7C2FaYS5Q45X
# XNsrMYybqTLCAhPNBkHmX+a6vDf+bYyLhSO6OyzyQ6O4J+N1gOKlinG9rjBHFSLq
# j3f5vKKZC7X65/U+vsRhVbuO2IbWC1v82JrKfcdn/aDJNCry9wgcQC40rP1T+s/p
# fjZrPATMktMa3+EfG/zztK3iIHuHJSTQdURXlOHNCdlGXrmMRKXmHa0Z8hmAnp0X
# 3r21/FFCrei1faS4Ju4RUOj8cg0j5i8AGVTxLK1Jxe8GRRIUqkVP2fqLhYnL7Ubu
# tKPcBoHWWq2URx7R5dvRptIOantPLv5NXIz8EZo9wx19dKHOiFw=
# SIG # End signature block
