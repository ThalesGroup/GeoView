"
I am a provisional implementation of a map tiles layer.
I provide basic functionality for displaying tiled map data, but my current implementation has known limitations and will require a complete redesign in a future iteration.
This is a temporary solution - use with the understanding that the API and internal structure will change significantly in future versions.
"
Class {
	#name : #GeoViewMapTilesLayer,
	#superclass : #AbstractGeoViewBasicLayer,
	#instVars : [
		'tileSize',
		'loadingTilesWorker',
		'previousCenter',
		'mapMutex',
		'currentGraphicProjection',
		'requestUpdateTilesWorker',
		'previousScale',
		'surfaceMap',
		'mapBackground',
		'tilesProvider',
		'loadingBufferWorker',
		'doubleBufferedScene',
		'moveMapWorker',
		'resetMapWorker',
		'tileZLevel',
		'localTilesCache'
	],
	#category : #'GeoView-Layers'
}

{ #category : #constructor }
GeoViewMapTilesLayer class >> newWithGoogle [

	| layer |
	layer := self new.
	layer tilesProvider: GeoViewGoogleTilesProvider new.
	^ layer
]

{ #category : #constructor }
GeoViewMapTilesLayer class >> newWithLocalDirectory [

	| layer |
	layer := self new.
	layer tilesProvider: GeoViewLocalDirectoryTilesProvider new.
	^ layer
]

{ #category : #constructor }
GeoViewMapTilesLayer class >> newWithOpenStreetMap [
	"default tiles provider is OSM"

	^ self new
]

{ #category : #drawing }
GeoViewMapTilesLayer >> aeDrawOn: aeCanvas [

	| cairoContext |
	doubleBufferedScene ifNil:[ ^ self ].
	doubleBufferedScene currentBuffer ifNil:[ ^ self ].

	"draw the map with the double buffered stuff"
	cairoContext := aeCanvas privateAeCairoContext.
	doubleBufferedScene currentBuffer content ifNotNil: [ :e |
		cairoContext sourceSurface: e; paint 
	]
	
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> buildVMapLayerTiles: aVMapTilesXY buffer: aLargerVMapTilesXY level: aLevel [

	| findAtLeastOneTile |
	findAtLeastOneTile := false.
	self surfaceMap ifNil: [ ^ findAtLeastOneTile ].
	self surfaceMap offcenter: self mapOffcenter.
	self surfaceMap position: currentGraphicProjection cartesianCenter.

	findAtLeastOneTile := self
		                      loadAndRenderTiles: aVMapTilesXY
		                      on: self surfaceMap
		                      offset: self mapOffcenter negated
		                      level: aLevel.

	"This job load tiles in background"
	self loadingBufferWorker: ([
			 self
				 loadAndRenderTiles: aLargerVMapTilesXY
				 on: self surfaceMap
				 offset: self mapOffcenter negated
				 level: aLevel ]
			 forkAt: Processor userBackgroundPriority
			 named: '[GeoView] Map stroke tiles loading').

	^ findAtLeastOneTile
]

{ #category : #computing }
GeoViewMapTilesLayer >> clip: num min: min max: max [

	^(num max: min) min: max
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> computeGraphicBoundsForTile: aGeoFormTile level: aLevel [

	| centerPixel vMapTileCenter diffXY diffPixel origin corner graphicBounds centerGeoPoint |
	aGeoFormTile isNoPicture
		ifTrue: [
				centerPixel := self getCenterInPixel.
				centerGeoPoint := self getCenterInGeoPoint.
				vMapTileCenter := self getTileXYFromGeoPoint: centerGeoPoint level: aLevel.
				diffXY := aGeoFormTile tileXY - vMapTileCenter.
				diffPixel := diffXY * self defaultTileSize asPoint.
				origin := centerPixel + diffPixel.
				corner := origin + self defaultTileSize asPoint ]
		ifFalse: [
				origin := self getGraphicPositionFromGeoPosition: aGeoFormTile geoBounds origin.
				corner := self getGraphicPositionFromGeoPosition: aGeoFormTile geoBounds corner ].

	(origin isNil or: [ corner isNil ]) ifTrue: [ ^ self ].

	graphicBounds := origin corner: corner.
	aGeoFormTile graphicBounds: graphicBounds
]

{ #category : #'API -- tiles' }
GeoViewMapTilesLayer >> defaultTileSize [

	^ 256
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> doLoadingTilesThread [

	| centerGeoPoint level tilesXY tilesXYBuffer findAtLeastOneTile realLevel|

	self previousScale: currentGraphicProjection scale.
	self surfaceMap offcenter: self mapOffcenter.
	self surfaceMap scale: 1@1.

	centerGeoPoint := self getCenterInGeoPoint.
	level := self tileZLevel.
	
	tilesXY := self getTilesXYFor: centerGeoPoint level: level.
	tilesXYBuffer := self getTilesXYForBuffer: centerGeoPoint level: level.
	
	findAtLeastOneTile := self buildVMapLayerTiles:  tilesXY buffer: tilesXYBuffer level: level.
	
	realLevel := level.
	[findAtLeastOneTile or:[(realLevel - level) > 3]] whileFalse: [

		Processor yield.
		level := level -1.
		
		tilesXY := self getTilesXYFor: centerGeoPoint level: level.
		tilesXYBuffer := self getTilesXYForBuffer: centerGeoPoint level: level.
		
		findAtLeastOneTile := self buildVMapLayerTiles:  tilesXY buffer: tilesXYBuffer level: level.

	].
	
]

{ #category : #'API -- footnotes' }
GeoViewMapTilesLayer >> footnotes [
	"return the default provider note if concerned, in a long time this methods can return a dynamic note depending of the displayed content. the note can change depending level or if a several data provider are mixed in same time"

	self tilesProvider ifNil: [ ^ nil ].
	self tilesProvider haveCopyrightNote ifFalse: [ ^ nil ].

	^ self tilesProvider defaultCopyrightNote
]

{ #category : #accessing }
GeoViewMapTilesLayer >> getCenterInGeoPoint [

	| center centerGeoPoint coords |
	center := currentGraphicProjection cartesianCenter.
	centerGeoPoint := self mapProjection projCartToLatLon: center.
	coords :=  centerGeoPoint asLatLonDegreesPoint.
	^ coords y @ coords x
]

{ #category : #accessing }
GeoViewMapTilesLayer >> getCenterInPixel [

	| center centerPixel |
	center := currentGraphicProjection cartesianCenter.
	centerPixel := currentGraphicProjection projCartToPixel: center.
	
	^centerPixel
	

	
]

{ #category : #tiles }
GeoViewMapTilesLayer >> getGeoBoundsFromTileXY: aPt level: aLevel [

	| pt1 pt2 |
	pt1 := self getPixelXYFromTileXY: aPt.
	pt2 := pt1 + (self defaultTileSize asPoint).
	pt1 := self getGeoPointFromPixelXY: pt1 level: aLevel.
	pt2 := self getGeoPointFromPixelXY: pt2 level: aLevel.
	^pt1  corner: pt2
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> getGeoImageAtTileXY: axyPoint level: aLevel [

	| geoBounds img isNoPicture geoImage|
	
	self tilesProvider ifNil: [ ^ nil ].
	img := self tilesProvider tileFor: aLevel x: axyPoint x y: axyPoint y.
	
	isNoPicture := false.
	geoBounds := self getGeoBoundsFromTileXY: axyPoint level: aLevel.
	img ifNil:[ isNoPicture := true].
	
	geoImage := GeoMapTile new. 
	geoImage position: geoBounds center.
	geoImage isNoPicture: isNoPicture.
	geoImage geoBounds: geoBounds.
	geoImage tileXY: axyPoint.
	geoImage imageReference: img.
	geoImage level: aLevel.
	^geoImage

	
]

{ #category : #level }
GeoViewMapTilesLayer >> getGeoPointFromPixelXY: aPt level: aLevel [
	"self getGeoPointFromPixelXY: 1@1 level: 1"

	| mapSize x y lat lon pi |
	pi := Float pi.
	mapSize := self mapSize: aLevel.
	x := (self clip: aPt x min: 0 max: mapSize - 1) / mapSize - 0.5.
	y := 0.5 - ((self clip: aPt y min: 0 max: mapSize - 1) / mapSize).
	lat := 90 - (360 * (((0 - y) * 2 * pi) exp arcTan / pi)).
	lon := 360 * x.
	^lon  @ lat
	
]

{ #category : #level }
GeoViewMapTilesLayer >> getGeoRectanglePointsFromTileXY: aPt level: aLevel [

	| pt1 pt2 pt3 pt4 |
	
	pt1 := self getPixelXYFromTileXY: aPt.
	pt3 := pt1 + (self defaultTileSize asPoint).
	pt2 := pt1 + (self defaultTileSize @ 0).
	pt4 := pt1 + (0 @ self defaultTileSize).
	pt1 := self getGeoPointFromPixelXY: pt1 level: aLevel.
	pt2 := self getGeoPointFromPixelXY: pt2 level: aLevel.
	pt3 := self getGeoPointFromPixelXY: pt3 level: aLevel.
	pt4 := self getGeoPointFromPixelXY: pt4 level: aLevel.
	
	^Array with: pt1 with: pt2 with: pt3 with: pt4
	
]

{ #category : #computing }
GeoViewMapTilesLayer >> getGraphicPositionFromGeoPosition: aGeoPoint [
	
	| absCoord cartCoord pos|
	absCoord := AbsoluteCoordinates latitudeInDegrees: aGeoPoint y longitudeInDegrees: aGeoPoint x. 
	cartCoord := self mapProjection projLatLonToCart: absCoord.
	
	pos := currentGraphicProjection projCartToPixel: cartCoord.
	^ pos
]

{ #category : #level }
GeoViewMapTilesLayer >> getPixelXYFromGeoPoint: aGeoPoint level: aLevel [

	| lat lon pt |
	lat := aGeoPoint y.
	lon := aGeoPoint x.
	pt := 0 @ 0.
	((self sinLatitude: lat) = 1) ifTrue:[^pt].
	pt setX: ((lon + 180) / 360) setY: (0.5 - (((1 + (self sinLatitude: lat)) / (1 - (self sinLatitude: lat))) ln / (4 * Float pi))).
	pt setX: ((self
				clip: pt x * (self mapSize: aLevel)
				min: 0
				max: (self mapSize: aLevel) - 1) asInteger) setY: ((self
				clip: pt y * (self mapSize: aLevel)
				min: 0
				max: (self mapSize: aLevel) - 1) asInteger).
	^pt

	
]

{ #category : #level }
GeoViewMapTilesLayer >> getPixelXYFromTileXY: aTilePt [

	| pt |
	pt := 0 @ 0.
	pt setX: (aTilePt x * self defaultTileSize) setY: (aTilePt y * self defaultTileSize).
	^pt
]

{ #category : #computing }
GeoViewMapTilesLayer >> getTileSurfaceFromGeoImage: aGeoImageTile [

	| tileSurface context |
	aGeoImageTile imageReference
		ifNil: [
				tileSurface := AeCairoImageSurface extent: self tileSize asPoint.
				context := tileSurface newContext ]
		ifNotNil: [
				| form |
				form := aGeoImageTile imageReference isForm
					        ifTrue: [ aGeoImageTile imageReference ]
					        ifFalse: [
					        ImageReadWriter formFromFileNamed:
						        aGeoImageTile imageReference ].
				tileSurface := AeCairoImageSurface fromForm: form ].
			
	^ tileSurface
]

{ #category : #level }
GeoViewMapTilesLayer >> getTileXYFromGeoPoint: aGeoPoint level: aLevel [

	| pt |
	pt := self getPixelXYFromGeoPoint: aGeoPoint level: aLevel.
	pt := self getTileXYFromPixelXY: pt.
	^pt

	
]

{ #category : #level }
GeoViewMapTilesLayer >> getTileXYFromPixelXY: aPixelPt [

	| pt |
	pt := 0 @ 0.
	pt setX: ((aPixelPt x / self defaultTileSize) asInteger) setY: ((aPixelPt y / self defaultTileSize) asInteger).
	^pt
	
]

{ #category : #level }
GeoViewMapTilesLayer >> getTilesLevelForCurrentResolution [

	| tile points pt2 pt3 h current centerGeoPoint |
	centerGeoPoint := self getCenterInGeoPoint.
	(18 to: 1 by: -1)
		detect: [ :i |
				tile := self getTileXYFromGeoPoint: centerGeoPoint level: i.
				points := self getGeoRectanglePointsFromTileXY: tile level: i.
				points := points collect: [ :pt |
					          self getGraphicPositionFromGeoPosition: pt ].
				pt2 := points at: 2.
				pt3 := points at: 3.

				"points can be nil in case of out of projection"
				(pt2 isNil or: [ pt3 isNil ])
					ifTrue: [ false ]
					ifFalse: [
							h := (pt2 - pt3) r.
							current := i -> h.
							h >= self tileSize
								ifTrue: [ true ]
								ifFalse: [ false ] ] ]
		ifNone: [ 0 -> self tileSize ].
	^ current
]

{ #category : #tiles }
GeoViewMapTilesLayer >> getTilesXYFor: aCenter level: aLevel [

	| vMapTilesXY tileQt squareSize vMapTileCenter diff pos maxTiles minX maxX minY maxY |
	vMapTilesXY := OrderedCollection new.
	vMapTileCenter := self getTileXYFromGeoPoint: aCenter level: aLevel.

	"Compute nb of tiles (rows and columns) + 2@2 => add 2 tiles on each side"
	tileQt := (currentGraphicProjection extentInPixels / self tileSize
	           + self nbTilesRowOnEachSide asPoint) rounded.
	"compute size of the square containing these tiles, and define order to start on center and go to the side on a spiral"
	squareSize := tileQt x max: tileQt y.

	vMapTilesXY add: vMapTileCenter.
	pos := vMapTileCenter copy.
	1 to: squareSize do: [ :i |
		i even
			ifFalse: [
				1 to: i do: [ :j |
					pos := pos + (1 @ 0).
					vMapTilesXY add: pos ].
				1 to: i do: [ :j |
					pos := pos + (0 @ 1).
					vMapTilesXY add: pos ] ]
			ifTrue: [
				1 to: i do: [ :j |
					pos := pos + (1 negated @ 0).
					vMapTilesXY add: pos ].
				1 to: i do: [ :j |
					pos := pos + (0 @ 1 negated).
					vMapTilesXY add: pos ] ] ].
	squareSize even
		ifTrue: [
			1 to: squareSize do: [ :j |
				pos := pos + (1 @ 0).
				vMapTilesXY add: pos ] ]
		ifFalse: [
			1 to: squareSize do: [ :j |
				pos := pos + (1 negated @ 0).
				vMapTilesXY add: pos ] ].

	"Add sides"
	diff := tileQt x - tileQt y.
	diff abs > 1 ifTrue: [
		diff > 0
			ifTrue: [
				0 to: diff do: [ :i |
					0 to: squareSize do: [ :j |
						vMapTilesXY add: pos + (i @ j).
						vMapTilesXY add:
							pos + (squareSize negated @ 0) + (i negated @ j) ] ] ]
			ifFalse: [
				diff := diff negated.
				0 to: diff do: [ :i |
					0 to: squareSize do: [ :j |
						vMapTilesXY add: pos + (j @ i).
						vMapTilesXY add:
							pos + (squareSize negated @ 0) + (j @ i negated) ] ] ] ].

	maxTiles := 2 raisedTo: aLevel.

	"considere real size ot the screen to select only necessary tiles"
	minX := vMapTileCenter x - (tileQt x // 2).
	maxX := vMapTileCenter x + (tileQt x // 2).
	minY := vMapTileCenter y - (tileQt y // 2).
	maxY := vMapTileCenter y + (tileQt y // 2).

	vMapTilesXY := vMapTilesXY select: [ :t |
		               (t x between: minX and: maxX) and: [
			               t y between: minY and: maxY ] ].

	vMapTilesXY := vMapTilesXY select: [ :t |
		               t x >= 0 and: [
			               t y >= 0 and: [
				               t x < maxTiles and: [ t y < maxTiles ] ] ] ].

	^ vMapTilesXY
]

{ #category : #tiles }
GeoViewMapTilesLayer >> getTilesXYForBuffer: aCenter level: aLevel [
	
	| vMapTilesXYBuffer tileQt  vMapTileCenter x y maxTiles |	

	vMapTilesXYBuffer := OrderedCollection new.
	vMapTileCenter := self getTileXYFromGeoPoint: aCenter level: aLevel.

	tileQt := (((currentGraphicProjection extentInPixels / (self defaultTileSize)) / 2) + (2@2)) rounded.

	x := tileQt x + 1.
	y := tileQt y + 1.

	0 to: y do:[:j |
		"Left side"	
		vMapTilesXYBuffer add: vMapTileCenter  + ((x negated)@j).
		j=0 ifFalse:[ vMapTilesXYBuffer add: vMapTileCenter  + ((x negated)@(j negated))].

		"Right side"	
		vMapTilesXYBuffer add: vMapTileCenter  + (x@j).
		j=0 ifFalse:[ vMapTilesXYBuffer add: vMapTileCenter  + (x@(j negated))].
	].

	0 to: x do:[:i |
		"Up side "	
		vMapTilesXYBuffer add: vMapTileCenter  + (i@(y negated)).
		i=0 ifFalse:[ vMapTilesXYBuffer add: vMapTileCenter  + ((i negated)@(y negated))].

		"Down side"	
		vMapTilesXYBuffer add: vMapTileCenter  + (i@y).
		i=0 ifFalse:[ vMapTilesXYBuffer add: vMapTileCenter  + ((i negated)@y)].
	].


	maxTiles := 2 raisedTo: aLevel.

	vMapTilesXYBuffer := vMapTilesXYBuffer select:[:t | (t x >= 0) and:[(t y >= 0) and:[ (t x < maxTiles) and:[ t y < maxTiles]]]].

	^vMapTilesXYBuffer
]

{ #category : #private }
GeoViewMapTilesLayer >> initSurfaceMap: anExtent [

	| geoSurface |

	geoSurface := GeoMapSurface new.
	geoSurface surface: (AeCairoImageSurface extent: anExtent).
	geoSurface offcenter: self mapOffcenter.
	
	self mapMutex critical: [ self surfaceMap: geoSurface ]
]

{ #category : #initialization }
GeoViewMapTilesLayer >> initialize [

	super initialize.
	self initializeDoubleBufferScene.

	self tilesProvider: GeoViewOpenStreetMapTilesProvider new
]

{ #category : #initialization }
GeoViewMapTilesLayer >> initializeDoubleBufferScene [

	doubleBufferedScene := SmockDoubleBufferedScene new
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> loadAndRenderTiles: aListTilesXY on: aSurface offset: anOffset level: aLevel [

	| index findAtLeastOneTile nbTiles tilesXY |
	
	index := 1.
	findAtLeastOneTile := false.

	tilesXY := aListTilesXY copy.
	nbTiles := tilesXY size.

	[index <= nbTiles] whileTrue: [ | tKey isValidTile |
		tKey := tilesXY at: index.
		index := index + 1.
			
		"catch loading tile block to considere error when retreiving tiles (network, disk, etc.)"		
		[ | newTile requestedTile |
			requestedTile := self localTilesCache tileAtLevel: aLevel x: tKey x y: tKey y.
			requestedTile ifNil:[ 
				newTile := self getGeoImageAtTileXY: tKey level: aLevel.
				requestedTile := newTile. 
			].

			self computeGraphicBoundsForTile: requestedTile level: aLevel.
			self offcenterGeoPngTile: requestedTile offset: anOffset level: aLevel.
			isValidTile := requestedTile isNoPicture not.
			findAtLeastOneTile := findAtLeastOneTile or:[ isValidTile ].
			
			self renderTileImage: requestedTile on: aSurface surface.
			
			"store the new tile"
			newTile ifNotNil:[
				self localTilesCache storeTile: requestedTile level: aLevel x: tKey x y: tKey y.
			].

			self updateMapBackground.
			
		] on:[ Exception ] do:[ :ex |
				Transcript show: '[GeoView] Error on Tiles loading :'; show: ex printString; cr.
				(Delay forMilliseconds: 1000) wait.
				ex restart]
				
	].

	^findAtLeastOneTile

]

{ #category : #accessing }
GeoViewMapTilesLayer >> loadingBufferWorker [

	^ loadingBufferWorker
]

{ #category : #accessing }
GeoViewMapTilesLayer >> loadingBufferWorker: anObject [

	loadingBufferWorker := anObject
]

{ #category : #accessing }
GeoViewMapTilesLayer >> loadingTilesWorker [

	^ loadingTilesWorker
]

{ #category : #accessing }
GeoViewMapTilesLayer >> loadingTilesWorker: anObject [

	loadingTilesWorker := anObject
]

{ #category : #accessing }
GeoViewMapTilesLayer >> localTilesCache [

	^ localTilesCache ifNil: [
		  localTilesCache := GeoViewMemoryTilesCache new ]
]

{ #category : #accessing }
GeoViewMapTilesLayer >> mapBackground [

	^ mapBackground
]

{ #category : #accessing }
GeoViewMapTilesLayer >> mapBackground: anObject [

	^ mapBackground := anObject
]

{ #category : #accessing }
GeoViewMapTilesLayer >> mapMutex [

	mapMutex ifNil: [ mapMutex := Monitor new ].
	^ mapMutex
]

{ #category : #accessing }
GeoViewMapTilesLayer >> mapOffcenter [
	"this is the size out the view extent to display border tiles when moved"

	^ self tileSize negated asPoint
]

{ #category : #computing }
GeoViewMapTilesLayer >> mapSize: aLevel [

	^ (self defaultTileSize bitShift: aLevel) asInteger
]

{ #category : #private }
GeoViewMapTilesLayer >> moveMap [

	| center projection pixelCenter surface |
	
	self surfaceMap ifNil:[ ^ self ].
	surface := self surfaceMap surface.
	
	projection := currentGraphicProjection copy.
	center := self previousCenter copy.
	pixelCenter := self getCenterInPixel copy.
	
	moveMapWorker ifNotNil:[ moveMapWorker terminate. moveMapWorker := nil ].
	moveMapWorker := 
	[ 
		self previousCenter: projection cartesianCenter.
		self moveMapBackground: projection previousCenter: center newCenter: pixelCenter previousSurface: surface.	
	] forkAt: Processor userSchedulingPriority named: '[GeoView] Map moving'. 

]

{ #category : #private }
GeoViewMapTilesLayer >> moveMapBackground: aGraphicProjection previousCenter: pCenter newCenter: newCenter previousSurface: aSurface [ 

	| previousPixel offsetPixel nextSurface previousSurface context extent |
	self surfaceMap ifNil:[ ^ self ].

	"translate the map background from previous center to next center"
	previousPixel := aGraphicProjection projCartToPixel: pCenter.
	offsetPixel := (previousPixel - newCenter).
	extent := (aGraphicProjection extentInPixels + (self mapOffcenter negated * 2)).
	
	nextSurface := AeCairoImageSurface extent: extent. 
	context := nextSurface newContext.

	previousSurface := aSurface.
	context sourceSurface: previousSurface x: offsetPixel x y: offsetPixel y; paint.
	
	self surfaceMap surface: nextSurface.
	self surfaceMap position: aGraphicProjection cartesianCenter.

	"send repaint order"
	self updateMapBackground.

]

{ #category : #accessing }
GeoViewMapTilesLayer >> nbTilesRowOnEachSide [
	
	^ 2
]

{ #category : #tiles }
GeoViewMapTilesLayer >> offcenterGeoPngTile: aTile offset: anOffset level: aLevel [

	| origin corner center modelCenter|
	
	"at first, compute the graphic bound if needed"
	aTile graphicBounds ifNil:[
		self computeGraphicBoundsForTile: aTile level: aLevel
	].
	
	"graphic bounds can be nil is case of out of projection"
	aTile graphicBounds ifNil:[ ^ self ].

	origin := aTile graphicBounds origin.
	corner := aTile graphicBounds corner.
	
	center := (origin + corner) /2.
	 
	modelCenter := self getCenterInPixel.
	aTile offcenter: (center - modelCenter + anOffset)
]

{ #category : #accessing }
GeoViewMapTilesLayer >> previousCenter [

	^previousCenter

	
]

{ #category : #accessing }
GeoViewMapTilesLayer >> previousCenter: aCartesianCenter [

	previousCenter := aCartesianCenter

	
]

{ #category : #accessing }
GeoViewMapTilesLayer >> previousScale [

	^previousScale

	
]

{ #category : #accessing }
GeoViewMapTilesLayer >> previousScale: aScaleInMeters [

	previousScale := aScaleInMeters

	
]

{ #category : #private }
GeoViewMapTilesLayer >> projCartToPixel: aCartesianCoordinates metersByPixel: aMetersByPixel [

	| point pixel geoCenter |
	point := aCartesianCoordinates asPoint.
	geoCenter := currentGraphicProjection cartesianCenter asPoint.
	pixel := ((point x @ point y negated) - (geoCenter x @ geoCenter y negated))
		* aMetersByPixel
		+ currentGraphicProjection offsetInPixels.

	^ pixel
]

{ #category : #private }
GeoViewMapTilesLayer >> removedFromSceneGraph [

	super removedFromSceneGraph.
	self stopTilesWorker 
]

{ #category : #rendering }
GeoViewMapTilesLayer >> renderSurface: aSurface on: aTargetSurface scale: aXYScale centeredAt: aPoint tile: aGeoImageTile [
	| targetContext finalPosition halfTile |
	
	targetContext := aTargetSurface newContext.
	targetContext antialias: AeCairoAntialias none.

	"Half tile in SOURCE space"
	halfTile := (self tileSize / 2) asPoint.

	"Translate in SCREEN space"
	finalPosition := aPoint - (halfTile * aXYScale).

	targetContext translateBy: finalPosition.
	targetContext scaleBy: aXYScale.
	targetContext sourceSurface: aSurface x: 0 y: 0.
	targetContext paint.

]

{ #category : #rendering }
GeoViewMapTilesLayer >> renderTileImage: aGeoImageTile on: aSurface [
	| origin corner scale center centerPixel tileSurface width height scaleX scaleY newTileSize |
	
	origin := aGeoImageTile graphicBounds
		ifNil: [ self getGraphicPositionFromGeoPosition: aGeoImageTile geoBounds origin ]
		ifNotNil: [ aGeoImageTile graphicBounds origin ].

	corner := aGeoImageTile graphicBounds
		ifNil: [ self getGraphicPositionFromGeoPosition: aGeoImageTile geoBounds corner ]
		ifNotNil: [ aGeoImageTile graphicBounds corner ].

	"origin and corner can be nil in case of out of projection"
	(origin isNil or:[corner isNil]) ifTrue:[ "cannot render the tile" ^ self ].

	"magic number to remove margin between tiles, waiting for rendering rebuild"
	newTileSize := self defaultTileSize - (self defaultTileSize * 0.0045).

	width := (corner x - origin x) abs.
	height := (corner y - origin y) abs.
	scaleX := width / newTileSize.
	scaleY := height / newTileSize.
	scale := (scaleX @ scaleY).
	center := currentGraphicProjection cartesianCenter.
	centerPixel := currentGraphicProjection projCartToPixel: center.

	aGeoImageTile offcenter ifNotNil: [
		centerPixel := centerPixel + aGeoImageTile offcenter
	].

	tileSurface := self getTileSurfaceFromGeoImage: aGeoImageTile.

	self
		renderSurface: tileSurface
		on: aSurface
		scale: scale
		centeredAt: centerPixel
		tile: aGeoImageTile
]

{ #category : #accessing }
GeoViewMapTilesLayer >> requestUpdateTilesWorker [

	^ requestUpdateTilesWorker
]

{ #category : #accessing }
GeoViewMapTilesLayer >> requestUpdateTilesWorker: anObject [

	requestUpdateTilesWorker := anObject
]

{ #category : #private }
GeoViewMapTilesLayer >> resetMap [

	| projection |
	projection := currentGraphicProjection copy.
	
	resetMapWorker ifNotNil:[  resetMapWorker terminate. resetMapWorker := nil ].
		resetMapWorker := [ 
			self initSurfaceMap: projection extentInPixels + (self mapOffcenter negated).
			self updateMapBackground 
	] forkAt: Processor userSchedulingPriority named: '[GeoView] Reset map background'.	
	
]

{ #category : #private }
GeoViewMapTilesLayer >> restartTilesWorker: aDuration [

	self stopTilesWorker.

	self loadingTilesWorker: ([
		 (aDuration ifNil: [ 20 milliseconds ]) wait.
		 self doLoadingTilesThread ]
			 forkAt: Processor userBackgroundPriority
			 named: '[GeoView] Map tiles loading')
]

{ #category : #computing }
GeoViewMapTilesLayer >> sinLatitude: aLatitude [

	^(aLatitude * (Float pi / 180)) sin
]

{ #category : #private }
GeoViewMapTilesLayer >> stopTilesWorker [

	self loadingTilesWorker ifNotNil: [
		self loadingTilesWorker terminate ].
	self loadingTilesWorker: nil.

	self loadingBufferWorker ifNotNil: [
		self loadingBufferWorker terminate ].
	self loadingBufferWorker: nil
]

{ #category : #accessing }
GeoViewMapTilesLayer >> surfaceMap [

	^ surfaceMap
]

{ #category : #accessing }
GeoViewMapTilesLayer >> surfaceMap: aCairoSurface [

	surfaceMap := aCairoSurface
]

{ #category : #tiles }
GeoViewMapTilesLayer >> tileNumberForLat: aLat long: aLong zoom: aZoomLevel [
	"Mercator
	ref: http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Implementations"
	"(self new tileNumberForLat: 48.4 long: -4.4 zoom: 12) =  (1997 @ 1417)"
	| n radLat xtile ytile pi |
	pi := Float pi. 
	radLat := aLat degreesToRadians.
	n := 2.0 ** aZoomLevel.
	xtile := (aLong + 180.0) / 360.0 * n.
	ytile := (1.0 - ((radLat tan + (1 / radLat cos)) ln / pi)) / 2.0 * n.
	^xtile truncated @ ytile truncated
]

{ #category : #'API -- tiles' }
GeoViewMapTilesLayer >> tileSize [

	^ tileSize ifNil: [ tileSize := self defaultTileSize ]
]

{ #category : #'API -- tiles' }
GeoViewMapTilesLayer >> tileSize: anObject [

	tileSize := anObject
]

{ #category : #accessing }
GeoViewMapTilesLayer >> tileZLevel [

	tileZLevel ifNil: [
		tileZLevel := self getTilesLevelForCurrentResolution key ].

	^ tileZLevel
]

{ #category : #accessing }
GeoViewMapTilesLayer >> tileZLevel: anObject [

	tileZLevel := anObject
]

{ #category : #'API -- tiles' }
GeoViewMapTilesLayer >> tilesProvider [

	^ tilesProvider
]

{ #category : #'API -- tiles' }
GeoViewMapTilesLayer >> tilesProvider: anObject [

	tilesProvider := anObject
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> updateMapBackground [ 

	| offcenter surface cairoSurface nextBufferedCanvas |
	offcenter := self mapOffcenter.
		
	self surfaceMap ifNil: [ ^ self ].
	self surfaceMap surface ifNil:[ ^ self ].
			
	self mapBackground: self surfaceMap.
	self mapBackground offcenter: self mapOffcenter.
	self mapBackground scale: 1 @ 1.
	self mapBackground position: currentGraphicProjection cartesianCenter.
	
	surface := self mapBackground surface.
	
	"prepare new buffer: setup size and draw current buffer on it to conserve current paint"
	cairoSurface := AeCairoImageSurface extent: surface extent.
	doubleBufferedScene nextBuffer content: cairoSurface.
	nextBufferedCanvas := AeCanvas newFor: cairoSurface.
	
	"render the map"
	doubleBufferedScene nextBuffer content ifNotNil:[ :content | | context |
		context := nextBufferedCanvas privateAeCairoContext.
		context sourceSurface: surface x: offcenter x y: offcenter y; paint.
	].

	"swap and notify repaint"
	doubleBufferedScene swap.

	self sendRepaintRequest
]

{ #category : #private }
GeoViewMapTilesLayer >> updateModel: aContext [

	super updateModel: aContext.
	
	self isVisible ifFalse:[ 
		aContext isBeVisibleChanges ifTrue:[ self stopTilesWorker ].	
		^ self ].

	self graphicProjection
		ifNil: [ ^ self ]
		ifNotNil: [ :e | currentGraphicProjection := e copy ].

	aContext isBeVisibleChanges ifTrue:[ self resetMap. self restartTilesWorker: 20 milliSeconds. ].
		
	aContext isProjectionChanges ifFalse: [ ^ self ].
	self updateWhenProjectionChanged: aContext
]

{ #category : #private }
GeoViewMapTilesLayer >> updateWhenProjectionChanged: aContext [

	self stopTilesWorker.

	"for instant, when the scale or view extent change, rebuild the entirely view from scratch - in the futur do a zoom and extent / crop the map background"
	aContext isScaleChanged ifTrue:[ 	self tileZLevel: nil. ].
	
	(aContext isExtentChanged or:[ aContext isScaleChanged ]) ifTrue:[ self resetMap ].
	
	aContext isCenterChanged ifTrue:[ 
			self previousCenter ifNil:[ self previousCenter: currentGraphicProjection cartesianCenter copy ]. 
		self moveMap 
	].

	self restartTilesWorker: 20 milliSeconds.
	
]
