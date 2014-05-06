﻿import UnityEngine

class Globals(MonoBehaviour):
	static public speed as int = 1
	static public money as single = 300
	static public tower as int = 0
	public cannon as GameObject
	public sam as GameObject
	public wall as GameObject
	public static final HEIGHT = 50
	public static final WIDTH = 50
	public static grid = matrix(bool, WIDTH*2, HEIGHT*2)
	
	private previous_speed as int
	private towers = ("Cannon", "SAM", "Wall")
	private speeds = ("||", "1", "2", "3", "4", "5")
	private hide = false
	private building as bool
	
	def Start():
		for i in range(WIDTH*2) :
			for j in range(HEIGHT*2) :
				grid[i, j]=true
		for i in range(WIDTH-5, WIDTH+6) :
			for j in range(HEIGHT-5, HEIGHT+6) :
				grid[i, j]=false
		for i in range(HEIGHT*2) :
			grid[0, i] = false
			grid[WIDTH*2-1, i] = false
	
	def Update():
		if Input.GetMouseButtonDown(1):
			building=true
		elif Input.GetMouseButtonUp(1):
			building=false
		elif building :
			build(WIDTH*Input.mousePosition.x/Screen.width*2-WIDTH, HEIGHT*Input.mousePosition.y/Screen.height*2-HEIGHT)
		if Input.GetKeyDown(KeyCode.Space) :
			if speed == 0 :
				speed = previous_speed
			else :
				previous_speed = speed
				speed = 0
		Time.timeScale=speed
		money += Time.deltaTime

	def OnGUI():
		hide = GUI.Toggle(Rect(20, 30, 180, 20), hide, "Hide Menu")
		if hide :
			GUI.Box(Rect(10, 20, 100, 40), "")
			return
		GUI.Box(Rect(10, 10, 200, 300), "Menu")
		speed = GUI.Toolbar(Rect(20, 70, 180, 20), speed, speeds)
		if GUI.Button(Rect(20, 110, 180, 20), "Next Wave " + Mathf.Floor(Spawn.timer)):
			Spawn.timer=0
		GUI.TextField(Rect(20, 140, 180, 20), "Money: " + Mathf.Floor(money))
		GUI.TextField(Rect(20, 170, 180, 20), "Wave: " + Spawn.wave)
		tower = GUI.SelectionGrid(Rect(20, 230, 180, 40), tower, towers, 2)
		GUI.TextField(Rect(20, 280, 180, 20), "Right click to build")

	def build(x as int, y as int) :
		return if x+WIDTH<0 or x>=WIDTH or y+HEIGHT<0 or y>=HEIGHT
		if grid[x+WIDTH, y+HEIGHT] :
			if towers[tower] == "Cannon" and money >= 100 :
				Instantiate(cannon, Vector3(x, 0, y), Quaternion(0, 0, 0, 0))
				money -= 100
			elif towers[tower] == "SAM" and money >= 150 :
				Instantiate(sam, Vector3(x, 0, y), Quaternion(0, 0, 0, 0))
				money -= 150
			elif towers[tower] == "Wall" and money >= 5 :
				Instantiate(wall, Vector3(x, 0, y), Quaternion(0, 0, 0, 0))
				money -= 5
			grid[x+WIDTH, y+HEIGHT] = false

	static def delete(target as GameObject):
		if target :
			pos_x, pos_y = target.transform.position.x+WIDTH, target.transform.position.z+HEIGHT
			grid[pos_x, pos_y] = true
			Destroy(target)