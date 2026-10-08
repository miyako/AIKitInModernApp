//%attributes = {}
// ----------------------------------------------------
// Method: ShowDocumentManager
// Description
//     Open the document manager form in the application process,
//     or bring its window to the front if it is already open
//
// Parameters
//    $params - passed by CALL WORKER to open the window
// ----------------------------------------------------

#DECLARE($params : Object)

var $windowTitle : Text
var $window : Integer
$windowTitle:=Localized string("DocMgr_WindowTitle")

If (Count parameters=0)
	
	ARRAY LONGINT($windows; 0)
	WINDOW LIST($windows)
	
	var $i : Integer
	For ($i; 1; Size of array($windows))
		$window:=$windows{$i}
		If (Window process($window)=1) && (Get window title($window)=$windowTitle)
			var $x; $y; $bottom; $right : Integer
			GET WINDOW RECT($x; $y; $bottom; $right; $window)
			CALL FORM($window; Formula(SET WINDOW RECT($x; $y; $bottom; $right; $window)))
			return 
		End if 
	End for 
	
	CALL WORKER:C1389(1; Current method name; {})
	
Else 
	
	SET MENU BAR(1)
	
	$window:=Open form window:C675("DocumentManager"; Plain form window; Horizontally centered; Vertically centered)
	SET WINDOW TITLE:C213($windowTitle; $window)
	DIALOG:C40("DocumentManager"; *)
	
End if 
