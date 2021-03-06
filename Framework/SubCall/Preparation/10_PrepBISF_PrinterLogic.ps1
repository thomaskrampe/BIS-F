﻿<#
    .Synopsis
		Prepare PrinterLogic PrinterInstaller 
    .Description
		Delete PrinterLogic PrinterInstaller logfiles on Base Image
    .EXAMPLE
    .Inputs
    .Outputs
    .NOTES
		Author: Matthias Schlimm
		Editor: Matthias Schhlimm
		Company: Login Consultants Germany GmbH

		History
		Last Change: 29.07.2017 MS: Script created
		Last Change: 01.08.2017 JP: Fixed typo on line 36
		Last Change: 
		Last Change: 
	  .Link
#>

Begin{
	$Script_Path = $MyInvocation.MyCommand.Path
	$Script_Dir = Split-Path -Parent $script_path
	$Script_Name = [System.IO.Path]::GetFileName($script_path)
	$Product = "PrinterLogic PrinterInstaller Client Launcher"
	$ServiceName = "PrinterInstallerLauncher"
    $ProductPath = "$env:WinDir\Temp\PPP"
}

Process {
	$Svc = Test-BISFService -ServiceName "$ServiceName" -ProductName "$Product"
	If ($Svc -eq $true)
	{
		Write-BISFLog -Msg "Delete all files in $ProductPath" -ShowConsole -Color DarkCyan -SubMsg
        Remove-Item "$ProductPath\*" -Force -Recurse
	}
}

End {
	Add-BISFFinishLine
}
