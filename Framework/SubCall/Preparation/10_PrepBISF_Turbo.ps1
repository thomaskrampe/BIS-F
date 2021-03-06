<#
    .SYNOPSIS
        Prepare Turbo.net Applications for Image Management
	.Description
      	update the turbo subscription
    .EXAMPLE
    .Inputs
    .Outputs
    .NOTES
		Author: Matthias Schlimm
      	Company: Login Consultants Germany GmbH
		
      	History
		Last Change: 17.03.2016 MS: Script created
		Last Change: 06.03.2017 MS: Bugfix read Variable $varCLI = ...
		Last Change: 
		Last Change: 
	.Link
#>

Begin {

	####################################################################
	# define environment
	$PSScriptFullName = $MyInvocation.MyCommand.Path
	$PSScriptRoot = Split-Path -Parent $PSScriptFullName
	$PSScriptName = [System.IO.Path]::GetFileName($PSScriptFullName)

	#product specified
	$Product = "Turbo.net"
	$ProductInstPath = "$ProgramFilesx86\Spoon\Cmd\Turbo.exe"
	
}

Process {
####################################################################
####### functions #####
####################################################################

function Set-TurboSupscriptionUpdate
    {
		Write-BISFLog -Msg "Check Silentswitch..."
	    $varCLITB = $LIC_BISF_CLI_TB
	    IF (($varCLITB -eq "YES") -or ($varCLITB -eq "NO")) 
	    {
		    Write-BISFLog -Msg "Silentswitch would be set to $varCLITB"
	    } ELSE {
       	    Write-BISFLog -Msg "Silentswitch not defined, show MessageBox"
		    $MPTB = Show-BISFMessageBox -Msg "Would you like to Update Turbo.net Supscription on System Startup ?" -Title "$Product" -YesNo -Question
    	    Write-BISFLog -Msg "$MPTB was selected [YES = Update Turbo.net Supscription] [NO = Do not run Turbo.net]"
	    }
        
		if (($MPTB -eq "YES" ) -or ($varCLITB -eq "YES"))
	    {
		    Write-BISFLog -Msg "The Turbo.net Supscription Update would be run on system startup" -ShowConsole -Color DarkCyan -SubMsg
            $answerTB = "YES"		    
	    } ELSE {
		    Write-BISFLog -Msg "The Turbo.net Supscription Update would NOT be run on system startup"
            $answerTB = "NO"
	    }
        

        IF (($answerTB -eq "YES") -or ($answerTB -eq "NO"))
        {
            Write-BISFLog -Msg "set your Turbo.net answer to the registry $hklm_software_LIC_CTX_BISF_SCRIPTS, Name LIC_BISF_TurboRun, value $answerTB"
            Set-ItemProperty -Path $hklm_software_LIC_CTX_BISF_SCRIPTS -Name "LIC_BISF_TurboRun" -value "$answerTB" -Force
        }
	}

    
   
	
    
    
####################################################################
####### end functions #####
####################################################################

#### Main Program

	IF (Test-Path ("$ProductInstPath") -PathType Leaf) 

	{
		Write-BISFLog -Msg "Product $Product installed" -ShowConsole -Color Cyan
        Set-TurboSupscriptionUpdate
		
	} ELSE {
		Write-BISFLog -Msg "Product $Product not installed"
	}
}

End {
	Add-BISFFinishLine
}


