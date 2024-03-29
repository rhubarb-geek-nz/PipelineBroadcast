#!/usr/bin/env pwsh
# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

trap
{
	throw $PSItem
}

Remove-Item *.log -Force

$logRules = (
	( 'all.log', { $True } ),
	( 'information.log', { $_ -is [System.Management.Automation.InformationRecord] } ),
	( 'warning.log', { $_ -is [System.Management.Automation.WarningRecord] } ),
	( 'debug.log', { $_ -is [System.Management.Automation.DebugRecord] } ),
	( 'verbose.log', { $_ -is [System.Management.Automation.VerboseRecord] } )
)

Invoke-Command -ScriptBlock {
	$VerbosePreference = 'Continue'
	$DebugPreference = 'Continue'
	Write-Output 'write to the output'
	Write-Error 'write to error'
	Write-Information 'write information'
	Write-Debug 'write debug'
	Write-Verbose 'write verbose information to the pipeline with a unique record type in order to identify it and filter'
	Write-Warning 'this is your final warning'
} *>&1 2>error.log | Invoke-PipelineBroadcast -ScriptBlock ((,{
	param([string]$file,[ScriptBlock]$rule)
	Where-Object -FilterScript $rule > $file
})*$logRules.Count) -ArgumentList $logRules
