<#
    .SYNOPSIS
        Personalize SCOM Client for Image Managemement Software
	.Description
      	
    .EXAMPLE
    .Inputs
    .Outputs
    .NOTES
		Author: Matthias Schlimm
      	Company: Login Consultants Germany GmbH
		
		History
      	Last Change: 17.11.2014 MS: Script created for OpsMagr2k7
		Last Change: 06.10.2015 MS: rewritten script with standard .SYNOPSIS, use central BISF function to configure service
		Last Change: 04.03.2016 MS: fixed issue SCOM service would be start on every Image Mode if installed
	.Link
#>

Begin{
	$OpsStateDir = "$PVSDiskDrive\OpsStateDir"
	$servicename = "HealthService"
	$Product = "Microsoft SCOM Agent"
	$script_path = $MyInvocation.MyCommand.Path
	$script_dir = Split-Path -Parent $script_path
	$script_name = [System.IO.Path]::GetFileName($script_path)
}

Process {
	$svc = Test-BISFService -ServiceName "$servicename" -ProductName "$Product"
	IF ($svc)
	{
		IF ($ImageSW -eq $true)
		{
			If (!(Test-Path -Path $OpsStateDir))
        	{
            	Write-BISFLog -Msg "Create Directory $OpsStateDir"
            	New-Item -path "$OpsStateDir" -ItemType Directory -Force
        	}
		}
	Invoke-BISFService -ServiceName "$servicename" -Action Start
	}
}

End {
	Add-BISFFinishLine
}
