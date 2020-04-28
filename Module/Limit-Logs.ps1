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

                if ($days -le $RetentionPeriod) {

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