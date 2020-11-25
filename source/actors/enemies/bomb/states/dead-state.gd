extends EnemyState



func initialize(argument):
	enemy.get_node("Hurtbox").disabled = true
	enemy.get_node("Hitbox/Shape").disabled = true
	enemy.get_node("ShotHitbox/Shape").disabled = true
	
	var level = get_tree().get_nodes_in_group("level")[0]
	var explosion = enemy.explosion.instance()
	explosion.position = level.to_local(enemy.global_position)
	level.add_child(explosion)
	
	enemy.queue_free()


