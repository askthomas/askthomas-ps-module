Function New-Password{

	<#
	.SYNOPSIS
		Generates Password
	
	.Example
		New-Password -Characters ABCDEF123456789 -Length 23
		
	.Example
		New-Password
		
	.Example
		2 | New-Password
	#>
	
	[CmdletBinding()]
	
	param( 
	[Parameter(ValueFromPipeline=$true,Mandatory=$false,Position=0)]
	[int] $Length = 20,
	
	[Parameter(ValueFromPipeline=$false,Mandatory=$false)]
	[string] $Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!##!#?"
	)
	
	BEGIN{}
	PROCESS{
		$bytes = new-object "System.Byte[]" $Length
		$rnd = new-object System.Security.Cryptography.RNGCryptoServiceProvider
		$rnd.GetBytes($bytes)
		$result = ""
		for( $i=0; $i -lt $Length; $i++ )
            {
                $result += $Characters[ $bytes[$i] % $Characters.Length ]	
            }
		write-host $result "(Also in Clipboard)"
        $result | clip
	}
	END{}
}
