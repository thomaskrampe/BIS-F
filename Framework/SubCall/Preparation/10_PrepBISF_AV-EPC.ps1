<#
    .SYNOPSIS
        Prepare Microsoft Security Client for Image Management
	.Description
      	reconfigure the AMicrosoft Security Client
    .EXAMPLE
    .Inputs
    .Outputs
    .NOTES
		Author: Matthias Schlimm
      	Company: Login Consultants Germany GmbH
		
		History
      	Last Change: 25.03.20142 MS: Script created
		Last Change: 01.04.2014 MS: change Console message
		Last Change: 12.05.2014 MS: Change Fullscan from Windows Defender directory to '$MSC_path\...'
		Last Change: 13.05.2014 MS: Add Silentswitch -AVFullScan (YES|NO) 
		Last Change: 11.06.2014 MS: Syntax error to start silent pattern update and fullscan, fix read variable LIC_BISF_CLI_AV
		Last Change: 13.08.2014 MS: remove $logfile = Set-logFile, it would be used in the 10_XX_LIB_Config.ps1 Script only
		Last Change: 20.02.2015 MS: add progressbar during fullscan
		Last Change: 30.09.2015 MS: rewritten script with standard .SYNOPSIS, use central BISF function to configure service
		Last Change: 06.03.2017 MS: Bugfix read Variable $varCLI = ...
	.Link
#>

Begin {
	$PSScriptFullName = $MyInvocation.MyCommand.Path
	$PSScriptRoot = Split-Path -Parent $PSScriptFullName
	$PSScriptName = [System.IO.Path]::GetFileName($PSScriptFullName)
	$product = "Microsoft Security Client"
	$MSC_path = "C:\Program Files\$product"
}

Process {
		function MSCrun
		{
	
			Write-BISFLog -Msg "Update VirusSignatures"
			& "$MSC_path\MpCMDrun.exe" -SignatureUpdate
        
			Write-BISFLog -Msg "Check Silentswitch..."
			$varCLI = $LIC_BISF_CLI_AV
		
			IF (($varCLI -eq "YES") -or ($varCLI -eq "NO")) {
				Write-BISFLog -Msg "Silentswitch would be set to $varCLI"
			} ELSE {
           		Write-BISFLog -Msg "Silentswitch not defined, show MessageBox"
				$MPFullScan = Show-MessageBox -Msg "Would you like to to run a Full Scan ? " -Title "Microsoft Security Client" -YesNo -Question
        		Write-BISFLog -Msg "$MPFullScan would be choosen [YES = Running Full Scan] [NO = No scan would be performed]"
			}
        
			if (($MPFullScan -eq "YES" ) -or ($varCLI -eq "YES")) {
				Write-BISFLog -Msg "Running Fullscan... please Wait"
				start-process -FilePath "$MSC_path\MpCMDrun.exe" -ArgumentList "-scan -scantype 2"
				Show-ProgressBar -CheckProcess "MpCMDrun" -ActivityText "$Product is scanning the system...please wait"		
			} ELSE {
				Write-BISFLog -Msg "No Full Scan would be performed"
			}
		}


    

	####################################################################
	####### end functions #####
	####################################################################

	#### Main Program
	IF (Test-Path ("$MSC_path\MpCMDRun.exe") -PathType Leaf )
	{
		Write-BISFLog -Msg "$Product installed" -ShowConsole -Color Cyan
		MSCrun
	} ELSE {
		Write-BISFLog -Msg "$Product not installed" 
	}

}

End {
	Add-BISFFinishLine
}


