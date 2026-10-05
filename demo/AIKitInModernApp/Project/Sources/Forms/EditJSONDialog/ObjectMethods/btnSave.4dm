// Button: Save

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		// Validate and save JSON
		var $newData : Object
		$newData:=JSON Parse:C1218(Form:C1466.editedJSON)
		
		If ($newData=Null:C1517)
			ALERT:C41(Localized string("AlertInvalidJSON"))
		Else 
			// Save to database
			If (Form:C1466.extractedDataEntity#Null:C1517)
				Form:C1466.extractedDataEntity.extractedData:=$newData
				Form:C1466.extractedDataEntity.save()
				
				If (Form:C1466.extractedDataEntity.UUID#"")
					ALERT:C41(Localized string("AlertExtractedDataSaved"))
					OK:=1
					CANCEL:C270
				Else 
					ALERT:C41(Localized string("AlertSaveDataError"))
				End if 
			Else 
				ALERT:C41(Localized string("AlertNoExtractedDataEntity"))
			End if 
		End if 
End case 
