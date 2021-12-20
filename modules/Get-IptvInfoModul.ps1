<#
.SYNOPSIS
    Gets info about IPTV
.DESCRIPTION
    Gets info about IPTV if active and expire date and more.
.EXAMPLE
    Get-IptvInfo -url "http://line.iptv.com" -user 12345678 -pass qwerty 
#>
Function Convert-FromUnixDate ($UnixDate) {
    [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($UnixDate))
}
function Get-IptvInfo {
    [CmdletBinding()]
    param (
       
        # Parameter for Tenant Name E.g. "visolit.onmicrosoft.com"
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $url = "line.serveraccess.eu",

        # Paramater for Application Id
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $user = "219155aa9",

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $password,

        [Parameter(Mandatory = $false)]
        [ValidateSet('series','live','movie','all')]
        [string]
        $info

    )

    # Fetch info from IPTV status URL
    $uri = "http://$($url):8000/panel_api.php?username=$($user)&password=$($password)"
    $tvstatus  = Invoke-WebRequest -Uri $uri
    $json = $tvstatus.Content
    $Jsonarray = $json | ConvertFrom-Json
    $createDate = Convert-FromUnixDate $Jsonarray.user_info.created_at
    $createDate = $createDate.ToString("yyyy-MM-dd") 
    $expDate = Convert-FromUnixDate $Jsonarray.user_info.exp_date
    $expDate = $expDate.ToString("yyyy-MM-dd") 
    #$categories = $Jsonarray.categories
    $cat_live = $Jsonarray.categories.live
    $cat_series = $Jsonarray.categories.series
    $cat_movie = $Jsonarray.categories.movie

    # Write Info
    Write-Host "Url ..................: $($url)"
    Write-Host "User .................: $($user)"
    Write-Host "Password .............: $($password)"
    Write-Host " "
    Write-Host "Expire date ..........: $($expDate)"
    Write-Host "Status ...............: $($Jsonarray.user_info.status)"
    Write-Host "Max Connections ......: $($Jsonarray.user_info.max_connections)"
    Write-Host "Active Connections ...: $($Jsonarray.user_info.active_cons)"
    Write-Host " "
    Write-Host "Live Categories ......: $($cat_live.Count) "
    Write-Host "Series Categories ....: $($cat_series.Count)"
    Write-Host "Movie Categories .....: $($cat_movie.Count)" 
    Write-Host " "
    Write-Verbose "Server URL ...........: $($Jsonarray.server_info.url)"
    Write-Verbose "Server Port ..........: $($Jsonarray.server_info.port)"
    Write-Verbose "Server SSL ...........: $($Jsonarray.server_info.https_port)"
    Write-Verbose "Protocol .............: $($Jsonarray.server_info.server_protocol)"
    Write-Verbose " "
   
    # Extra info about Categoris
    if ($info) {
        switch ($info) {
            "series"    { 
                Write-Host "Series"
                $Jsonarray.categories.series 
            }
            "live"      { 
                Write-Host "Live"
                $Jsonarray.categories.live 
            }
            "movie"     { 
                Write-Host "Movie"
                $Jsonarray.categories.movie 
            }
            "All"       { 
                Write-Host "All"
                $Jsonarray.categories.live
                $Jsonarray.categories.series
                $Jsonarray.categories.movie
             }
            
            Default {}
        }

    }
}


