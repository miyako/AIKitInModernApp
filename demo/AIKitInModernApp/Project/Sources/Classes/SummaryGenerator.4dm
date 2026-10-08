// ----------------------------------------------------
// Method: SummaryGenerator
// Description
//      
// ----------------------------------------------------

property config : cs:C1710.AIConfig
property client : cs:C1710.AIKit.OpenAI
property SUMMARY_MAX_TOKENS : Integer
property SUMMARY_TEMPERATURE : Real

Class constructor
	This:C1470.config:=cs:C1710.AIConfig.me
	This:C1470.client:=This:C1470.config.getClient()
	
	// Constants
	This:C1470.SUMMARY_MAX_TOKENS:=800
	This:C1470.SUMMARY_TEMPERATURE:=0.3
	
Function generateSummary($docID : Text; $summaryType : Text)->$summaryID : Text
	var $doc : cs:C1710.DocumentEntity
	var $extData : cs:C1710.ExtractedDataEntity
	var $prompt : Text
	var $result : Object
	
	$summaryID:=""
	
	// Load data
	$doc:=ds:C1482.Document.get($docID)
	$extData:=ds:C1482.ExtractedData.query("documentID = :1"; $docID).first()
	
	// Validate only
	If (Not:C34(This:C1470._validateDocumentData($doc; $extData)))
		return 
	End if 
	
	$prompt:=This:C1470._buildSummaryPrompt($summaryType; $extData)
	$result:=This:C1470._generateWithAI($prompt)
	
	
	If ($result.success)
		$summaryID:=This:C1470._saveSummary($docID; $summaryType; $result.choice.message.content; $result.model)
	End if 
	
	return $summaryID
	
	
	
	// MARK: - Helper Functions
	
Function _validateDocumentData($doc : cs:C1710.DocumentEntity; $extData : cs:C1710.ExtractedDataEntity)->$valid : Boolean
	$valid:=True:C214
	
	If ($doc=Null:C1517)
		ALERT:C41(Localized string("AlertDocumentNotFound"))
		$valid:=False:C215
	End if 
	
	If ($extData=Null:C1517)
		ALERT:C41(Localized string("AlertNoExtractedDataForDocument"))
		$valid:=False:C215
	End if 
	return $valid
	
	
Function _buildSummaryPrompt($summaryType : Text; $extData : cs:C1710.ExtractedDataEntity)->$prompt : Text
	var $context : Text
	
	$context:=_buildDocumentContext($extData)
	
	If ($context="")
		ALERT:C41(Localized string("AlertContextEmpty"))
		return 
	End if 
	
	// English prompt per summary type (XLIFF: Prompt_Summary_<type>) + a line asking for answers in the UI language
	Case of 
		: ($summaryType="Brief") | ($summaryType="Detailed") | ($summaryType="Executive") | ($summaryType="KeyPoints")
			$prompt:=Replace string:C233(Localized string("Prompt_Summary_"+$summaryType); "{context}"; $context)+"\n\n"+Localized string("Prompt_ResponseLanguage")
	End case 
	
	return $prompt
	
	
Function _generateWithAI($prompt : Text)->$result : Object
	var $messages : Collection
	var $params : Object
	
	$messages:=New collection:C1472
	$messages.push(New object:C1471("role"; "system"; "content"; Localized string("Prompt_SystemAnalyst")))
	$messages.push(New object:C1471("role"; "user"; "content"; $prompt))
	
	$params:={\
		model: This:C1470.config.defaultModel; \
		max_tokens: This:C1470.SUMMARY_MAX_TOKENS; \
		temperature: This:C1470.SUMMARY_TEMPERATURE}
	
	//use asynchronous call
	//onResponse: Formula(testAsync($1))
	//$result:=This.client.chat.completions.create($messages; $params)
	$result:=This:C1470.client.chat.completions.create($messages; $params)
	
	
	return $result
	
	
Function _saveSummary($docID : Text; $summaryType : Text; $summaryText : Text; $model : Text)->$summaryID : Text
	var $summary : cs:C1710.SummariesEntity
	
	$summaryID:=""
	
	$summary:=ds:C1482.Summaries.new()
	$summary.documentID:=$docID
	$summary.summaryType:=$summaryType
	$summary.summaryText:=$summaryText
	$summary.generatedDate:=Current date:C33
	$summary.generatedTime:=Current time:C178
	$summary.save()
	
	If ($summary.UUID#"")
		$summaryID:=$summary.UUID
	End if 
	
	return $summaryID
	
	