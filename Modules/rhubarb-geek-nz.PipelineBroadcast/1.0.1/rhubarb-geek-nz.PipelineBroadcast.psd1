@{
	RootModule = 'PipelineBroadcast.psm1'
	ModuleVersion = '1.0.1'
	GUID = '0f99b59f-ac94-4043-83db-64b1a71c871f'
	Author = 'Roger Brown'
	CompanyName = 'rhubarb-geek-nz'
	Copyright = '2024'
	Description = 'Write pipeline to multiple scripts'
	FunctionsToExport = @('Invoke-PipelineBroadcast')
	CmdletsToExport = @()
	VariablesToExport = '*'
	AliasesToExport = @()
	PrivateData = @{
		PSData = @{
			ProjectUri = 'https://github.com/rhubarb-geek-nz/PipelineBroadcast'
		}
	}
}
