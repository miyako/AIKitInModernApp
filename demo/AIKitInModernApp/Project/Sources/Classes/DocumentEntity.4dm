// ----------------------------------------------------
// Class: DocumentEntity
// Description
//      statusLabel: the stored status code (Uploaded, Processing, Processed, Error)
//      in the UI language, for display. Code compares the stored status.
// ----------------------------------------------------

Class extends Entity

Function get statusLabel() : Text
	return Localized string("Status_"+This:C1470.status)
	
Function orderBy statusLabel($event : Object) : Text
	return "status "+$event.operator
	
