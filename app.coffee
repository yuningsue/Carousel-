# Import file "Player" (sizes and positions are scaled 1:2)
sketch = Framer.Importer.load("imported/Player@2x")

sketch.More_On.opacity= 0

sketch.Group_8.onClick (event, layer) ->
	sketch.More_On.animate
		properties:
			opacity: 0.8


# Set-up ScrollComponent
page = new PageComponent
	width: Screen.width, height: Screen.height
	y: 0, scrollVertical: false
	contentInset: {right: 100}

sketch.Group_32.visible = false
sketch.Group_31.visible = false
sketch.Group_3.visible = false

# Array that will store our layers
allIndicators = []	
amount = 3

# Generate card layers
sketch.Cover.superLayer = page.content
sketch.Cover.horizontalPageIndex = 0
sketch.Lyrics.superLayer = page.content
sketch.Lyrics.horizontalPageIndex =1
sketch.Lyrics.opacity = 0
sketch.Info.superLayer=page.content
sketch.Info.horizontalPageIndex = 2
sketch.Info.opacity = 0

for i in [0...amount]
	
	indicator = new Layer 
		backgroundColor: "#222"
		width: 12, height: 12
		x: 28 * i, y: 774
		borderRadius: "50%", opacity: 0.2
		
	# Stay centered regardless of the amount of cards
	indicator.x += (Screen.width / 2) - (12 * amount)
	
	# States
	indicator.states.add(active: {opacity: 1, scale:1.2})
	indicator.states.animationOptions = time: 0.5
	
	# Store indicators in our array
	allIndicators.push(indicator)

# Set indicator for current page
current = page.horizontalPageIndex(page.currentPage)
allIndicators[current].states.switch("active")

# Define custom animation curve for page switches
page.animationOptions = curve: "spring(200,22,0)"

# Update indicators
page.on "change:currentPage", ->
	indicator.states.switch("default") for indicator in allIndicators
	
	current = page.horizontalPageIndex(page.currentPage)
	allIndicators[current].states.switch("active")
            	
	# Animation of pages fading out
	page.previousPage.animate 
		properties: {
			scale: 0.9
			opacity: 0
		}
		curve: "spring", curveOptions: {tension: 100, friction: 50, velocity: 0, tolerance: 1}
	page.currentPage.animate
		properties:
			opacity: 1
			
	page.previousPage.once Events.AnimationEnd, -> this.scale = 1