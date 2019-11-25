extends Node2D

enum ButtonVisuals {StaticOff, On, DynamicOff}

export(bool) var staticSwitch = false #If true, requires permanent force to be triggered
export(NodePath) var connectedNodeInstance = null 

var triggered = false
var targetRef = null

func _ready():
	assert(connectedNodeInstance != null)
	targetRef = get_node(connectedNodeInstance)
	
	if staticSwitch:
		_switchVisualState(ButtonVisuals.StaticOff)
	else:
		_switchVisualState(ButtonVisuals.DynamicOff)


func _switchVisualState(to):
	match to:
		ButtonVisuals.StaticOff: 
			$Button.frame = 0
			$Indicator.frame = 2
			$Light2D.show()
			$Light2D.color = Color(255, 0, 0)
		ButtonVisuals.On: 
			$Button.frame = 1
			$Indicator.frame = 1
			$Light2D.show()
			$Light2D.color = Color(0, 255, 0)
		_: #ButtonVisuals.DynamicOff:
			$Button.frame = 0
			$Indicator.frame = 0
			$Light2D.hide()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		triggered = true
		_switchVisualState(ButtonVisuals.On)
		targetRef.activate()

		$SndStaticButton.play()

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		if not staticSwitch:
			triggered = false
			_switchVisualState(ButtonVisuals.DynamicOff)
			targetRef.deactivate()
