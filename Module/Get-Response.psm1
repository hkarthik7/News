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

Function Get-Response {
    param(
        [string] $ApiKey,
        [string] $Uri
    )

    if($ApiKey) {
        $headers = @{
            Authorization = $UrlApiKey
        }

        $response = Invoke-RestMethod -Uri $Uri -Headers $headers
    }

    else {
        $response = Invoke-RestMethod -Uri $Uri
    }
    return $response
}
#EOF