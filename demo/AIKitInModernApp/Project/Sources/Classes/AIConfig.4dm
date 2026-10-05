// ----------------------------------------------------
// Method: AIConfig Class
// Description
//         Manage AI configuration
//         - API key and endpoint: 4D AIKit provider settings,
//           Project/Sources/AIProviders.json (never committed; copy
//           AIProviders.example.json, or use the AI page of the Settings in 4D 21 R3+)
//         - Models and generation parameters: aiconfig.json in the database folder
//
// ----------------------------------------------------

property apiKey : Text
property provider : Text
property baseURL : Text
property defaultModel : Text
property visionModel : Text
property maxTokens : Integer
property temperature : Real

shared singleton Class constructor()
	This:C1470.loadConfiguration()
	
Function loadConfiguration()
	var $provider : Object
	var $config : Object
	
	$provider:=This:C1470._loadProviderSettings()
	
	// No API key: On Startup opens the AI Configuration dialog
	If ($provider#Null:C1517)
		This:C1470.provider:=$provider.name
		This:C1470.apiKey:=$provider.apiKey
		This:C1470.baseURL:=$provider.baseURL
	Else 
		This:C1470.provider:=""
		This:C1470.apiKey:=""
		This:C1470.baseURL:=""
	End if 
	
	This:C1470.defaultModel:="gpt-4o-mini"
	This:C1470.visionModel:="gpt-4o"
	This:C1470.maxTokens:=2500
	This:C1470.temperature:=0.3
	
	$config:=This:C1470._loadFromConfigFile()
	
	If ($config#Null:C1517)
		If (String:C10($config.models.default)#"")
			This:C1470.defaultModel:=$config.models.default
		End if 
		If (String:C10($config.models.vision)#"")
			This:C1470.visionModel:=$config.models.vision
		End if 
		If ($config.generation.maxTokens#Null:C1517)
			This:C1470.maxTokens:=$config.generation.maxTokens
		End if 
		If ($config.generation.temperature#Null:C1517)
			This:C1470.temperature:=$config.generation.temperature
		End if 
	End if 
	
Function getClient()->$client : cs:C1710.AIKit.OpenAI
	If (This:C1470.baseURL#"")
		$client:=cs:C1710.AIKit.OpenAI.new({apiKey: This:C1470.apiKey; baseURL: This:C1470.baseURL})
	Else 
		$client:=cs:C1710.AIKit.OpenAI.new(This:C1470.apiKey)
	End if 
	
	return $client
	
	// Reads Project/Sources/AIProviders.json, the 4D AIKit provider settings file.
	// Uses the provider whose baseURL is api.openai.com, otherwise the first provider that has an apiKey.
Function _loadProviderSettings()->$provider : Object
	var $file : 4D:C1709.File
	var $settings : Object
	var $name : Text
	var $entry : Object
	
	$file:=File:C1566("/SOURCES/AIProviders.json")
	
	If (Not:C34($file.exists))
		return Null:C1517
	End if 
	
	Try
		$settings:=JSON Parse:C1218($file.getText())
	Catch
		$settings:=Null:C1517
	End try
	
	If ($settings=Null:C1517) || ($settings.providers=Null:C1517)
		return Null:C1517
	End if 
	
	For each ($name; $settings.providers)
		$entry:=$settings.providers[$name]
		If (String:C10($entry.apiKey)#"")
			If ($provider=Null:C1517) || (Position:C15("api.openai.com"; String:C10($entry.baseURL))>0)
				$provider:={name: $name; apiKey: String:C10($entry.apiKey); baseURL: String:C10($entry.baseURL)}
			End if 
		End if 
	End for each 
	
	return $provider
	
	// Saves models and generation parameters only: the API key stays in AIProviders.json
Function _saveToConfigFile()->$success : Boolean
	var $config : Object
	var $file : 4D:C1709.File
	var $json : Text
	
	$config:={}
	$config.models:={}
	$config.models.default:=This:C1470.defaultModel
	$config.models.vision:=This:C1470.visionModel
	
	$config.generation:={}
	$config.generation.maxTokens:=This:C1470.maxTokens
	$config.generation.temperature:=This:C1470.temperature
	
	$file:=Folder:C1567(fk database folder:K87:14).file("aiconfig.json")
	
	$json:=JSON Stringify:C1217($config; *)
	
	Try
		$file.setText($json)
		$success:=True:C214
	Catch
		$success:=False:C215
	End try
	
	return $success
	
	
Function _loadFromConfigFile()->$config : Object
	var $file : 4D:C1709.File
	var $json : Text
	
	$file:=Folder:C1567(fk database folder:K87:14).file("aiconfig.json")
	
	If (Not:C34($file.exists))
		return Null:C1517
	End if 
	
	Try
		$json:=$file.getText()
		$config:=JSON Parse:C1218($json)
	Catch
		$config:=Null:C1517
	End try
	
	return $config
	
	
