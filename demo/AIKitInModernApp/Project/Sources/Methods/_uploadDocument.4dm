//%attributes = {}
// ----------------------------------------------------
// Method: _uploadDocument
// Description
//      Handles document upload and initial processing
//
// Parameters
//      $filePath - File path of the uploaded document
// ----------------------------------------------------


#DECLARE($filePath : Text)->$docID : Text

var $fileName : Text
var $fileSize : Integer
var $doc : cs:C1710.DocumentEntity
var $valid : Boolean

$docID:=""

// Validate file exists
$valid:=(Test path name:C476($filePath)=Is a document:K24:1)
If (Not:C34($valid))
	ALERT:C41(Replace string:C233(Localized string("AlertFileNotFound"); "{path}"; $filePath))
	return 
End if 

// Get file information
$fileName:=Path to object:C1547($filePath).name
$fileSize:=Get document size:C479($filePath)


// Validate file size (10MB limit for vision processing)
If ($fileSize>=(10*1024*1024))
	ALERT:C41(Localized string("AlertFileTooLarge"))
	return 
End if 

// Create document record
$doc:=ds:C1482.Document.new()
$doc.fileName:=$fileName
$doc.filePath:=$filePath
$doc.uploadDate:=Current date:C33
$doc.uploadTime:=Current time:C178
$doc.fileSize:=$fileSize
$doc.documentType:=Localized string("DocumentType_Unknown")
$doc.status:="Uploaded"
$doc.statusMessage:="Document uploaded successfully"
$doc.createdBy:=Current user:C182
$doc.save()

If ($doc.UUID#"")
	$docID:=$doc.UUID
Else 
	ALERT:C41(Localized string("AlertSaveDocumentFailed"))
End if 

return $docID