extends KinematicBody2D

signal playerTurnFinished

var heroTurn := true
var moveDir = Vector2()
var grid
var foundTarget
var type = 1


var animStart := false
var animDone := false


func _ready():
	grid = get_parent().get_parent()
	set_physics_process(false)
	var turnController = get_tree().get_root().get_node("mainScene/turnController")
	connect("playerTurnFinished", turnController, "turnControl")

func playerTurn():
	set_physics_process(true)

func _physics_process(delta):
	

	if !animStart && !animDone:
		foundTarget = grid.findNpcInRange(self)
	
	if foundTarget == null:
		moveDir = $heroMovement.getMoveDir()
		if moveDir != Vector2.ZERO:		
			if grid.isCellVacent(position, moveDir):
				position = grid.updateChildPos(self)
				set_physics_process(false)
				emit_signal("playerTurnFinished")
	else:
		if !animDone && !animStart:
			transform()
			animStart = true
		elif !animDone:
			pass
		else:
			if grid.isCellVacent(position, foundTarget):
				moveDir = foundTarget
				position = grid.updateChildPos(self)
				#set_physics_process(false)

func transform():
	$transformParticle.emitting = true
	$transformDelay.start()

func _on_transformDelay_timeout():
	if $playerSprite.animation == "hero":
		$playerSprite.play("villain")
		$transformDelay2.start()
	else:
		animDone = true
