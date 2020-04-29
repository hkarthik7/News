function Limit-Logs {

    <#
    .SYNOPSIS
    Script to delete old log files.

    .DESCRIPTION
    Script to delete old log files.

    .PARAMETER FilePath
    Provide the path of folder to delete files. 

    .PARAMETER RetentionPeriod
    Provide the retention period to delete files.

    .EXAMPLE
    Limit-Files -FilePath C:\Temp -RetentionPeriod 25 -Verbose

    .NOTES
    Author             Version		 Date			Notes
    ----------------------------------------------------------------------
    harish.karthic     1.0	        28/04/2020		Initial script

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath,

        [Parameter(Mandatory=$true)]
        [int]$RetentionPeriod
    )
    
    begin {
        $functionName = $MyInvocation.MyCommand.Name

        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Begin Function.."

        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Validating if given path is present or not.."

        if (-not (Test-Path $FilePath)) {
            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Given Path is not valid.."
            exit
        }
    }

    process {
        try {
            Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Deleting files.."

            $files = Get-ChildItem $FilePath | Select-Object Name, FullName, LastWriteTime

            foreach ($file in $files) {

                $days = ((Get-Date) - $file.LastWriteTime).Days

                if ($days -eq $RetentionPeriod) {

                    Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Deleting $($file.FullName) as it is older than $RetentionPeriod days.."

                    $file.FullName | Remove-Item -Force

                } else {
                    Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : Skipping $($file.FullName) as it is not older than $RetentionPeriod days.."
                }
            }
        }
        catch {
            Write-Host "[$(Get-Date -Format s)] $functionName : Error at line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    end {
        Write-Verbose "[$(Get-Date -Format s)] : $($functionName) : End Function.."
    }
}
Export-ModuleMember -Function Limit-Logs

# SIG # Begin signature block
# MIIFwgYJKoZIhvcNAQcCoIIFszCCBa8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU8R1v0iiKNKh6oDGiNV87EkD8
# JVygggNLMIIDRzCCAjOgAwIBAgIQDp2TmZ27p7RI1Rz3x2O1GTAJBgUrDgMCHQUA
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
# MAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFLQ/JB5WxjrKX4Fx1eK8hner
# WxhDMA0GCSqGSIb3DQEBAQUABIIBADjL877184OS7lz3K4bCK03qg/sEmlLk3Tct
# TPHv/GZlhwhQbXRYlKMBb7wywf3hQgqkHxaW1BON08tvhUdFVDEkK6/Vhyl27lZP
# T12NFZ9lxTblZ1oVWKuNj8QVNxTtP57DHODLSSiLWsiYMUbv3wZ0Trm3K6I0gSsk
# 6Mkymsp+z+4IOch2rTdhngm/d4J5LuhxrxPQg6WauUyoR89HkLnjmTkQvBVfbmcp
# EhJENZJt6BHZhWpKNifAo8UAtopeZgIYDdYzT/WWE9QiJvbuUn4KOnWIaAueYBBj
# xsp6TbwfbJWF5Iq3ELhZFPIkdCS+uMRtRADaKYPHlCPBAkXsCoM=
# SIG # End signature block
