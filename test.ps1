#!/usr/bin/env pwsh
# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

$ErrorActionPreference = 'Continue'
$WarningPreference = 'Continue'
$InformationPreference = 'Continue'
$VerbosePreference = 'Continue'

trap
{
	throw $PSItem
}

Remove-Item *.log -Force

Invoke-Command -ScriptBlock {
	Write-Output 'write to the output'
	Write-Error 'write to error' 2>&1
	Write-Information 'write information'
	Write-Verbose 'write verbose information to the pipeline with a unique record type in order to identify it and filter'
	Write-Warning 'this is your final warning'
} *>&1 | Invoke-PipelineBroadcast -ScriptBlock (
	{
		Write-Output > stdout.log
	},{
		Where-Object { $_ -is [System.Management.Automation.ErrorRecord] } *> stderr.log
	},{
		Where-Object { $_ -is [System.Management.Automation.InformationRecord] } *> information.log
	},{
		Where-Object { $_ -is [System.Management.Automation.WarningRecord] } *> warning.log
	},{
		Where-Object { $_ -is [System.Management.Automation.VerboseRecord] } *> verbose.log 
	}
) -ArgumentList ((0),(0),(0),(0),(0))
