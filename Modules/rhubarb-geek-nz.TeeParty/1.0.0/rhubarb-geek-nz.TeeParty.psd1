@{
	RootModule = 'TeeParty.psm1'
	ModuleVersion = '1.0.0'
	GUID = '91080922-70d2-42e5-b38b-5d532498d14e'
	Author = 'Roger Brown'
	CompanyName = 'rhubarb-geek-nz'
	Copyright = 'Copyright © 2024 Roger Brown'
	Description = 'Tee-Party alias'
	FunctionsToExport = @()
	CmdletsToExport = @()
	VariablesToExport = '*'
	AliasesToExport = @('Tee-Party')
	RequiredModules = @(
		@{
			ModuleName = 'rhubarb-geek-nz.PipelineBroadcast'
			ModuleVersion = '1.1.2'
			GUID = '0f99b59f-ac94-4043-83db-64b1a71c871f'
		}
	)
	PrivateData = @{
		PSData = @{
			ProjectUri = 'https://github.com/rhubarb-geek-nz/PipelineBroadcast'
		}
	}
}
