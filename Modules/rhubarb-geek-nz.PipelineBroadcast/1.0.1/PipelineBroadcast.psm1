# Copyright (c) 2023 Roger Brown.
# Licensed under the MIT License.

function Invoke-PipelineBroadcast
{
    [CmdletBinding()]
	param(
		[Parameter(Mandatory)][ScriptBlock[]]$ScriptBlock,
		[Parameter(Mandatory=$False)][Object[][]]$ArgumentList=$null,
		[Parameter(Mandatory,ValueFromPipeline)][Object]$InputObject
	)
	Begin {
		$i = $ScriptBlock.Count
		$pipes = New-Object System.Management.Automation.SteppablePipeline[] $i
		$internal = [System.Management.Automation.CommandOrigin]::Internal
		while ($i--)
		{
			if ($ArgumentList)
			{
				$pipes[$i] = $ScriptBlock[$i].GetSteppablePipeline($internal,$ArgumentList[$i])
			}
			else
			{
				$pipes[$i] = $ScriptBlock[$i].GetSteppablePipeline($internal)
			}
		}
		foreach ($pipe in $pipes)
		{
			$pipe.Begin($True)
		}
	}
	Process {
		foreach ($pipe in $pipes)
		{
			$pipe.Process($InputObject)
		}
	}
	End {
		foreach ($pipe in $pipes)
		{
			$pipe.End()
		}
	}
}

Export-ModuleMember -Function Invoke-PipelineBroadcast
