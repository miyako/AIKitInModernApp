var $config : cs:C1710.AIConfig
$config:=cs:C1710.AIConfig.me

// The API key is read from Project/Sources/AIProviders.json
If ($config.apiKey="")
	ShowAIConfiguration
Else 
	ShowDocumentManager
End if 
