extends Spatial

#1 meter = 0.01 units

##Flags, you can play with them
#When enabled, the structure of the buildings is drawn
var drawStructure = false

#When enabled, palms, antennas and some other details are added
var drawDetails = true

#Building color
var buildingColor = Color(1, 1, 1, 0.3)

#Building siluete color
var silueteColor = Color(1, 1, 1)

#Slab color
var slabColor = Color(1, 1, 1)

#Slab siluete color
var slabSilueteColor = Color(0, 0, 0)

##Resources for details
var palm = preload("res://resources/palm.res")
var tree = preload("res://resources/tree.res")

##Counters
#Details
var palmCount = 0
var treeCount = 0

#Buildings
var blockyBuildingCount = 0
var houseCount = 0
var piramidalBuildingCount = 0
var residentialBuildingsCount = 0

#Actual code
func _ready():

	#The initial seed
	#rand_seed(42)
	randomize()
	
	#Trials
	for i in range(100):
		for j in range(100):
			var toggle = randi() % 3
			if toggle == 0:
				addPiramidalBuilding(9 - j*4, 0, 9 - i*4, 1, 1)
			elif toggle == 1:
				addBlockyBuilding(9 - j*4, 0, 9 - i*4, 1, 1)
			elif toggle == 2:
				addResidentialBuildings(9 - j*4, 0, 9 - i*4, 1, 1, 0.80, 1.40)
#
#	addHouse(0, 0, 0, 1, 0.5)
#
#	for i in range(10):
#		for j in range(10):
#			addBlockyBuilding(9 - j*4, 0, 9 - i*4, 1, 1)
#	addBlockyBuilding(0, 0, 0, 1, 1)
#	addPiramidalBuilding(0, 0, 4, 1, 1)
#	addPiramidalBuilding(0, 0, 0, 1, 1)
#	get_tree().call_group(0,"blocky0","set_rotation", Vector3(0, PI/2, 0))
#	addResidentialBuildings(0, 0, 8, 1, 1, 0.80, 1.40)
#	get_node("blocky0").set_rotation(Vector3(0, PI/3, 0))

#Appends a cube to an existing Surfacetool
func addCubeMesh(x, y, z, dx, dy, dz, color, surface, blendMode = "sub"):
	
	#This allows to use RGB colors instead of images. Spooner is a genius!
	var material = FixedMaterial.new()
	material.set_fixed_flag(FixedMaterial.FLAG_USE_COLOR_ARRAY, true)
	
	#Allow transparency
	material.set_fixed_flag(FixedMaterial.FLAG_USE_ALPHA, true)
	surface.set_material(material)
	
	#This is the central point in the base of the cube
	var base = Vector3(x, y + dy, z)
	
	##Corners of the cube
	var corners = []
	
	#Top
	corners.push_back(base + Vector3(-dx,  dy, -dz))
	corners.push_back(base + Vector3( dx,  dy, -dz))
	corners.push_back(base + Vector3( dx,  dy,  dz))
	corners.push_back(base + Vector3(-dx,  dy,  dz))
	
	#Bottom
	corners.push_back(base + Vector3(-dx, -dy, -dz))
	corners.push_back(base + Vector3( dx, -dy, -dz))
	corners.push_back(base + Vector3( dx, -dy,  dz))
	corners.push_back(base + Vector3(-dx, -dy,  dz))
	
	#Color red
	surface.add_color(color)

	##Adding the corners in order, calculated by hand
	#Top
	surface.add_normal(Vector3(0, 1, 0))
	surface.add_vertex(corners[0])
	surface.add_vertex(corners[1])
	surface.add_vertex(corners[2])
	surface.add_vertex(corners[2])
	surface.add_vertex(corners[3])
	surface.add_vertex(corners[0])
	
	#One side
	surface.add_vertex(corners[0])
	surface.add_vertex(corners[4])
	surface.add_vertex(corners[5])
	surface.add_vertex(corners[5])
	surface.add_vertex(corners[1])
	surface.add_vertex(corners[0])

	#Other side
	surface.add_vertex(corners[6])
	surface.add_vertex(corners[2])
	surface.add_vertex(corners[1])
	surface.add_vertex(corners[1])
	surface.add_vertex(corners[5])
	surface.add_vertex(corners[6])

	#Other side
	surface.add_vertex(corners[3])
	surface.add_vertex(corners[2])
	surface.add_vertex(corners[6])
	surface.add_vertex(corners[6])
	surface.add_vertex(corners[7])
	surface.add_vertex(corners[3])

	#Other side
	surface.add_vertex(corners[0])
	surface.add_vertex(corners[3])
	surface.add_vertex(corners[7])
	surface.add_vertex(corners[7])
	surface.add_vertex(corners[4])
	surface.add_vertex(corners[0])
	
	#Bottom
	surface.add_vertex(corners[6])
	surface.add_vertex(corners[5])
	surface.add_vertex(corners[7])
	surface.add_vertex(corners[5])
	surface.add_vertex(corners[4])
	surface.add_vertex(corners[7])

#Appends a siluete on an existing surface SurfaceTool
func addSiluete(x, y, z, dx, dy, dz, color, surface):
	
	#This allows to use RGB colors instead of images
	var material = FixedMaterial.new()
	material.set_fixed_flag(FixedMaterial.FLAG_USE_COLOR_ARRAY, true)
	surface.set_material(material)
	
	#This is the central point in the base of the cube
	var base = Vector3(x, y + dy, z)
	
	##Corners of the cube
	var corners = []
	
	#Top
	corners.push_back(base + Vector3(-dx,  dy, -dz))
	corners.push_back(base + Vector3( dx,  dy, -dz))
	corners.push_back(base + Vector3( dx,  dy,  dz))
	corners.push_back(base + Vector3(-dx,  dy,  dz))
	
	#Bottom
	corners.push_back(base + Vector3(-dx, -dy, -dz))
	corners.push_back(base + Vector3( dx, -dy, -dz))
	corners.push_back(base + Vector3( dx, -dy,  dz))
	corners.push_back(base + Vector3(-dx, -dy,  dz))
	
	#Color
	surface.add_color(color)
	surface.add_normal(Vector3(0, 1, 0))

	##Joining all vertex
	surface.add_vertex(corners[0])
	surface.add_vertex(corners[1])
	
	surface.add_vertex(corners[1])
	surface.add_vertex(corners[2])
	
	surface.add_vertex(corners[2])
	surface.add_vertex(corners[3])
	
	surface.add_vertex(corners[3])
	surface.add_vertex(corners[0])
	
	surface.add_vertex(corners[0])
	surface.add_vertex(corners[4])
	
	surface.add_vertex(corners[4])
	surface.add_vertex(corners[5])
	
	surface.add_vertex(corners[5])
	surface.add_vertex(corners[1])
	
	surface.add_vertex(corners[5])
	surface.add_vertex(corners[6])
	
	surface.add_vertex(corners[6])
	surface.add_vertex(corners[2])
	
	surface.add_vertex(corners[6])
	surface.add_vertex(corners[7])
	
	surface.add_vertex(corners[3])
	surface.add_vertex(corners[7])
	
	surface.add_vertex(corners[7])
	surface.add_vertex(corners[4])

#This adds the cubes of the buildings, this kinda works as an alias for addCube but I can add slabs here
func addTower(x, y, z, dx, dy, dz, buildingSurface, silueteSurface, useAlpha = true):

	#I have to draw them 0.005 more in the y axis to avoid collision with the floor
	y += 0.005

	if not drawStructure:
	
		addCubeMesh(x, y, z, dx, dy, dz, buildingColor, buildingSurface)
		addSiluete(x, y, z, dx, dy, dz, silueteColor, silueteSurface)
		
	else:
		#Add a big transparent cube and then the structure
		addCubeMesh(x, y, z, dx, dy, dz, buildingColor, buildingSurface)
		addSiluete(x, y, z, dx, dy, dz, silueteColor, silueteSurface)
		
		#The slabs
		var heightLeft = dy * 2
		var accumHeight = 0

		while(heightLeft > 0.03):

			addCubeMesh(x, y + 0.03/2 + accumHeight, z, dx, 0.003, dz, slabColor, buildingSurface)
			addSiluete(x, y + 0.03/2 + accumHeight, z, dx, 0.003, dz, slabSilueteColor, silueteSurface)

			heightLeft -= 0.03
			accumHeight += 0.03

		addCubeMesh(x, y + dy*2.0, z, dx, 0.003, dz, slabColor, buildingSurface)
		addSiluete(x, y + dy*2.0, z, dx, 0.003, dz, slabSilueteColor, silueteSurface)


#Adds a blocky building in x, y, z on an area of size*size
func addBlockyBuilding(x, y, z, dx, dz):

	var buildingName = "blocky" + str(blockyBuildingCount)
	
	#The surfacetool that will be used to generate the whole building
	var surface = SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	#The surfacetool that will be used to generate the siluete of the building
	var surface_siluete = SurfaceTool.new()
	surface_siluete.begin(Mesh.PRIMITIVE_LINES)
	
	#Create a node building that will hold the mesh
	var node = MeshInstance.new()
	node.set_name(buildingName)
	add_child(node)
	
	#Floor
	addCubeMesh(x, y, z, dx, 0.005, dz, buildingColor, surface)
	addSiluete(x, y, z, dx, 0.005, dz, silueteColor, surface_siluete)
	
	##First block
	#Base
	var dxBase = rand_range(0.4 * dx, 0.6 * dx)
	var dzBase = rand_range(0.4 * dz, 0.6 * dz)
	
	#Offset from the middle
	var xOffset = rand_range(0, 0.4 * dx)
	var zOffset = rand_range(0, 0.4 * dz)
	
	#Height
	var maxHeight = 0
	
	if randi() % 2 == 0:
		maxHeight = min(dxBase, dzBase) * 5
		
	else:
		maxHeight = max(dxBase, dzBase) * 5

	#This will set if the building has 4, 3 or one tower
	var shape = randi() % 10
	var xLocal = x + xOffset
	var zLocal = z + zOffset
	
	if shape == 0 or shape == 1: #20% of 4 towers
		
		addTower(xLocal + dxBase/2, y, zLocal + dzBase/2, dxBase/2, maxHeight, dzBase/2, surface, surface_siluete)

		var h = rand_range(0.7 * maxHeight, 0.9 * maxHeight)
		addTower(xLocal + dxBase/2, y, zLocal - dzBase/2, dxBase/2, h, dzBase/2, surface, surface_siluete)

		h = rand_range(0.7 * h, 0.9 * h)
		addTower(xLocal - dxBase/2, y, zLocal + dzBase/2, dxBase/2, h, dzBase/2, surface, surface_siluete)

		h = rand_range(0.7 * h, 0.9 * h)
		addTower(xLocal - dxBase/2, y, zLocal - dzBase/2, dxBase/2, h, dzBase/2, surface, surface_siluete)
	
	elif shape == 2: #10% of 3 towers
	
		addTower(xLocal + dxBase/2, y, zLocal + dzBase/2, dxBase/2, maxHeight, dzBase/2, surface, surface_siluete)
		
		var h = rand_range(0.7 * maxHeight, 0.9 * maxHeight)
		addTower(xLocal + dxBase/2, y, zLocal - dzBase/2, dxBase/2, h, dzBase/2, surface, surface_siluete)

		h = rand_range(0.7 * h, 0.9 * h)
		addTower(xLocal - dxBase/2, y, zLocal + dzBase/2, dxBase/2, h, dzBase/2, surface, surface_siluete)

	else: #70% of regular building
	
		addTower(x + xOffset, y, z + zOffset, dxBase, maxHeight, dzBase, surface, surface_siluete)
	
	if drawDetails:
		
		#Palms or trees
		var type = randi() % 2
		var both = randi() % 10
	
		if type == 0 or both == 0:
			##Add palms
			var palmNumber = randi() % 7
			
			for i in range(palmNumber):
			
				#Corner of the building + offset
				var xLocal = x + xOffset - dxBase - 0.05
				var zLocal = z + zOffset - dzBase - 0.05
						
				xLocal -= rand_range(0.01, xOffset*2)
				zLocal -= rand_range(0.01, zOffset*2)
				
				#Add it to the scene
				var p = palm.instance()
				var palmName = "p" + str(palmCount)
				palmCount += 1
				p.set_name(palmName)
	
				#Move, and make sure it is above the ground
				p.set_translation(Vector3(xLocal, 0.01, zLocal))
				
				#Resize
				var scale = p.get_scale()
				var modifier = rand_range(1, 3)
				p.set_scale(scale / modifier)
				
				#Rotate
				p.set_rotation(Vector3(PI/2, 0, rand_range(0, PI)))
				
				#Add it
				get_node(buildingName).add_child(p)
		
		elif type == 1 or both == 0:
		
			##Add trees
			var treeNumber = randi() % 3
			
			#Hide leaves?
			var leaves = randi() % 5
			
			for i in range(treeNumber):
			
				#Corner of the building + offset
				var xLocal = x + xOffset - dxBase - 0.05
				var zLocal = z + zOffset - dzBase - 0.05
						
				xLocal -= rand_range(0.01, xOffset*2)
				zLocal -= rand_range(0.01, zOffset*2)
				
				#Add it to the scene
				var t = tree.instance()
				var treeName = "t" + str(treeCount)
				treeCount += 1
				t.set_name(treeName)
				
				#Remove leaves 20% of the times
				if leaves == 0:
						t.get_child(1).set("geometry/visible", false)
	
				#Move, and make sure it is above the ground
				t.set_translation(Vector3(xLocal, 0.01, zLocal))
				
				#Resize
				var scale = t.get_scale()
				var modifier = rand_range(2, 4)
				t.set_scale(scale * modifier)
				
				#Rotate
				t.set_rotation(Vector3(0, rand_range(0, PI), 0))
				
				#Add it
				get_node(buildingName).add_child(t)
	
	blockyBuildingCount += 1
	
	#Set the created mesh to the node
	node.set_mesh(surface.commit())
	
	#Create the node that will hold the siluete of the building
	var c = MeshInstance.new()
	c.set_mesh(surface_siluete.commit())
	node.add_child(c)

#Adds a piramidal building in x, y, z on an area of size*size
func addPiramidalBuilding(x, y, z, dx, dz):

	var buildingName = "piramidal" + str(houseCount)

	#The surfacetool that will be used to generate the whole building
	var surface = SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	#The surfacetool that will be used to generate the siluete of the building
	var surface_siluete = SurfaceTool.new()
	surface_siluete.begin(Mesh.PRIMITIVE_LINES)
	
	#Create a node building that will hold the mesh
	var node = MeshInstance.new()
	node.set_name(buildingName)
	add_child(node)
	
	#Floor
	addCubeMesh(x, y, z, dx, 0.005, dz, buildingColor, surface)
	addSiluete(x, y, z, dx, 0.005, dz, silueteColor, surface_siluete)
	
	##Bottom block
	#Base
	var dxBase = rand_range(0.4 * dx, 0.6 * dx)
	var dzBase = rand_range(0.4 * dz, 0.6 * dz)
	
	#Offset from the middle
	var xOffset = rand_range(0, 0.4 * dx)
	var zOffset = rand_range(0, 0.4 * dz)
	
	#Height
	var maxHeight = 0
	
	if randi() % 2 == 0:
		maxHeight = min(dxBase, dzBase) * 5
		
	else:
		maxHeight = max(dxBase, dzBase) * 5
		
	#How many blocks
	var blocks = int(rand_range(3, 6))
	
	#Set the heights
	var heights = []
	
	for i in range(blocks):
		maxHeight /= 2
		heights.push_back(maxHeight)
	
	#Build the blocks
	var yPos = 0
	for i in range(blocks):
	
		addTower(x + xOffset, yPos, z + zOffset, dxBase, heights[i], dzBase, surface, surface_siluete)
		
		yPos += 2 * heights[i]
		dxBase *= rand_range(0.6, 0.8)
		dzBase *= rand_range(0.6, 0.8)
		
	##Add benches
	#if drawDetails:
	#Set the created mesh to the node
	node.set_mesh(surface.commit())
	
	#Create the node that will hold the siluete of the building
	var c = MeshInstance.new()
	c.set_mesh(surface_siluete.commit())
	node.add_child(c)

#Adds residential buildings in x, y, z on an area of size * size with height between minHeight and maxHeight
func addResidentialBuildings(x, y, z, dx, dz, minHeight, maxHeight):

	var buildingName = "bunch" + str(residentialBuildingsCount)

	#The surfacetool that will be used to generate the whole building
	var surface = SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	#The surfacetool that will be used to generate the siluete of the building
	var surface_siluete = SurfaceTool.new()
	surface_siluete.begin(Mesh.PRIMITIVE_LINES)
	
	#Create a node building that will hold the mesh
	var node = MeshInstance.new()
	node.set_name(buildingName)
	add_child(node)
	
	#Floor
	addCubeMesh(x, y, z, dx, 0.005, dz, buildingColor, surface)
	addSiluete(x, y, z, dx, 0.005, dz, silueteColor, surface_siluete)
	
	##Add row of buildings in Z axis
	#Widths
	var widths = []
	var widthLeft = dz
	
	while(widthLeft > 0.30):
		var w = rand_range(0.20, 0.28)
		widths.push_back(w)
		widthLeft -= w
	
	#Add the rest
	widths.push_back(widthLeft)
	
	#Create the blocks
	var acumWidth = 0
	for width in widths:
	
		var localDy = rand_range(minHeight, maxHeight)
		addTower(x + dx - 0.2 * dx, y, z + dz - width - acumWidth, 0.2 * dx, localDy, width, surface, surface_siluete)
		acumWidth += width * 2
	
	##Add row of buildings in the other side of the Z axis
	#Widths
	var widths = []
	var widthLeft = dz
	
	while(widthLeft > 0.30):
		var w = rand_range(0.20, 0.28)
		widths.push_back(w)
		widthLeft -= w
	
	#Add the rest
	widths.push_back(widthLeft)

	#Create the blocks
	var acumWidth = 0
	for width in widths:
		
		var localDy = rand_range(minHeight, maxHeight)
		addTower(x - dx + 0.2 * dx, y, z + dz - width - acumWidth, 0.2 * dx, localDy, width, surface, surface_siluete)
		acumWidth += width * 2
		
	##Add row of buildings in the X axis
	#Widths
	var widths = []
	var widthLeft = dx - dx * 0.4
	
	while(widthLeft > 0.30):
		var w = rand_range(0.18, 0.23)
		widths.push_back(w)
		widthLeft -= w
	
	#Add the rest
	widths.push_back(widthLeft)

	#Create the blocks
	var acumWidth = 0
	for width in widths:
	
		var localDy = rand_range(minHeight, maxHeight)
		addTower(x + dx - width - 0.4 * dx - acumWidth, y, z + dz - 0.2 * dz, width, localDy, 0.2 * dz, surface, surface_siluete)
		acumWidth += width * 2

	##Add the other row of buildings in the X axis
	#Widths
	var widths = []
	var widthLeft = dx - dx * 0.4
	
	while(widthLeft > 0.30):
		var w = rand_range(0.18, 0.23)
		widths.push_back(w)
		widthLeft -= w
	
	#Add the rest
	widths.push_back(widthLeft)

	#Create the blocks
	var acumWidth = 0
	for width in widths:
	
		var localDy = rand_range(minHeight, maxHeight)
		addTower(x + dx - width - 0.4 * dx - acumWidth, y, z - dz + 0.2 * dz, width, localDy, 0.2 * dz, surface, surface_siluete)
		acumWidth += width * 2
		
	residentialBuildingsCount += 1
	
	#Set the created mesh to the node
	node.set_mesh(surface.commit())
	
	#Create the node that will hold the siluete of the building
	var c = MeshInstance.new()
	c.set_mesh(surface_siluete.commit())
	node.add_child(c)
	
#Adds a house in x, y, z on an area of size*size
func addHouse(x, y, z, dx, dz):

	var buildingName = "house" + str(houseCount)

	#Create a node building that will contain all blocks
	var node = Spatial.new()
	node.set_name(buildingName)
	add_child(node)
	
	#Floor
	addCube(x, y, z, dx, 0.005, dz, buildingName, false)
	
	##First block
	#Base
	var dxBase = 0.10#rand_range(0.4 * dx, 0.7 * dx)
	var dzBase = 0.10#rand_range(0.4 * dz, 0.7 * dz)
	
	#Offset from the middle
	var xOffset = rand_range(0, 0.4 * dx)
	var zOffset = rand_range(0, 0.4 * dz)
	
	addCube(x + xOffset, y, z + zOffset, dxBase, 0.06, dzBase, buildingName, drawStructure)
	
	houseCount += 1