function Get-ScriptPath {
    [CmdletBinding()]
    param (
        [string]
        $Extension = '.ps1'
    )

    Write-Host $MyInvocation.MyCommand.Definition
    # Allow module to inherit '-Verbose' flag.
    if (($PSCmdlet) -and (-not $PSBoundParameters.ContainsKey('Verbose'))) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }

    # Allow module to inherit '-Debug' flag.
    if (($PSCmdlet) -and (-not $PSBoundParameters.ContainsKey('Debug'))) {
        $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
    }
    
    $callstack = Get-PSCallStack

    $i = 0
    $max = 100

    while ($true) {
        if (!$callstack[$i]) {
            Write-Verbose "Cannot detect callstack frame '$i' in 'Get-ScriptPath'."
            return $null
        }

        $path = $callstack[$i].ScriptName

        if ($path) {
            Write-Verbose "Callstack frame '$i': '$path'."
            $ext = [IO.Path]::GetExtension($path)
            if (($ext) -and $ext -eq $Extension) {
                return $path
            }
        }

        $i++

        if ($i -gt $max) {
            Write-Verbose "Exceeded the maximum of '$max' callstack frames in 'Get-ScriptPath'."
            return $null
        }
    }

    return $null
}
