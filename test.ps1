#!/usr/bin/env pwsh
# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

$ErrorActionPreference = 'Continue'
$WarningPreference = 'Continue'
$InformationPreference = 'Continue'
$VerbosePreference = 'Continue'
$DebugPreference = 'Continue'

trap
{
	throw $PSItem
}

Remove-Item *.log -Force

Invoke-Command -ScriptBlock {
	Write-Output 'write to the output'
	Write-Error 'write to error' 2>&1
	Write-Information 'write information'
	Write-Debug 'write debug'
	Write-Verbose 'write verbose information to the pipeline with a unique record type in order to identify it and filter'
	Write-Warning 'this is your final warning'
} *>&1 | Invoke-PipelineBroadcast -ScriptBlock (
	{
		param($file)
		Write-Output > $file
	},{
		param($file)
		Where-Object { $_ -is [System.Management.Automation.ErrorRecord] } *> $file
	},{
		param($file)
		Where-Object { $_ -is [System.Management.Automation.InformationRecord] } *> $file
	},{
		param($file)
		Where-Object { $_ -is [System.Management.Automation.WarningRecord] } *> $file
	},{
		param($file)
		Where-Object { $_ -is [System.Management.Automation.DebugRecord] } *> $file
	},{
		param($file)
		Where-Object { $_ -is [System.Management.Automation.VerboseRecord] } *> $file
	}
) -ArgumentList ('stdout.log','stderr.log','information.log','warning.log','debug.log','verbose.log')
