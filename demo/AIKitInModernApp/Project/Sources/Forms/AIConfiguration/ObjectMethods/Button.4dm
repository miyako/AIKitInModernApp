Case of 
	: (Form:C1466.provider="")
		ALERT:C41("Please fill the mandatory fields")
	: (Form:C1466.apiKey="")
		ALERT:C41("Please fill the mandatory fields")
	Else 
		// DIALOG(*) does not wait for the window to close: save here, then close
		var $aiconfig : cs:C1710.AIConfig
		var $success : Boolean
		$aiconfig:=cs:C1710.AIConfig.me
		Use ($aiconfig)
			$aiconfig.provider:=Form:C1466.provider
			$aiconfig.apiKey:=Form:C1466.apiKey
			$aiconfig.baseURL:=Form:C1466.baseURL
			$aiconfig.defaultModel:=Form:C1466.defaultModel
			$aiconfig.visionModel:=Form:C1466.visionModel
			$aiconfig.maxTokens:=Form:C1466.maxTokens
			$aiconfig.temperature:=Form:C1466.temperature
			$success:=$aiconfig._saveToConfigFile()
		End use 
		If ($success)
			ALERT:C41("Configuration updated successfully")
		End if 
		ACCEPT:C269
End case 
