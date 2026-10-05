Case of 
	: (Form:C1466.defaultModel="")
		ALERT:C41("Please fill the mandatory fields")
	Else 
		// DIALOG(*) does not wait for the window to close: save here, then close
		// The API key is not saved here: it is set in Project/Sources/AIProviders.json
		var $aiconfig : cs:C1710.AIConfig
		var $success : Boolean
		$aiconfig:=cs:C1710.AIConfig.me
		Use ($aiconfig)
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
