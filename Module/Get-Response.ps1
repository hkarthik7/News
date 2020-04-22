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