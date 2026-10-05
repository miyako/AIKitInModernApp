//%attributes = {}
// ----------------------------------------------------
// Method: ShowAIConfiguration
// Description
//      Display the AI Configuration form in the application process,
//      or bring its window to the front if it is already open.
//      The Save button writes the model settings back (see ObjectMethods/Button.4dm).
//      The API key is read-only here: it is set in Project/Sources/AIProviders.json.
//
// Parameters
//    $params - passed by CALL WORKER to open the window
// ----------------------------------------------------

#DECLARE($params : Object)

var $windowTitle : Text
var $window : Integer
$windowTitle:="AI Configuration"

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
	
	var $aiconfig : cs:C1710.AIConfig
	var $tempConfig : Object
	var $apiKeyStatus : Text
	$aiconfig:=cs:C1710.AIConfig.me
	
	// Re-read the settings: AIProviders.json may have been edited since startup
	Use ($aiconfig)
		$aiconfig.loadConfiguration()
	End use 
	
	If ($aiconfig.apiKey="")
		$apiKeyStatus:="Not set: edit Project/Sources/AIProviders.json"
	Else 
		$apiKeyStatus:="Set in Project/Sources/AIProviders.json"
	End if 
	
	$tempConfig:={\
		provider: $aiconfig.provider; \
		apiKeyStatus: $apiKeyStatus; \
		baseURL: $aiconfig.baseURL; \
		defaultModel: $aiconfig.defaultModel; \
		visionModel: $aiconfig.visionModel; \
		maxTokens: $aiconfig.maxTokens; \
		temperature: $aiconfig.temperature}
	
	$window:=Open form window:C675("AIConfiguration"; Plain form window; Horizontally centered; Vertically centered)
	SET WINDOW TITLE:C213($windowTitle; $window)
	DIALOG:C40("AIConfiguration"; $tempConfig; *)
	
End if 
