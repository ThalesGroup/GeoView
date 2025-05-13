Class {
	#name : #GeoViewMapTilesLayer,
	#superclass : #AbstractGeoViewBasicLayer,
	#instVars : [
		'loadingTilesWorker',
		'buildBufferWorker',
		'isBufferReady',
		'dictTilesByLevel',
		'isComputingTiles',
		'previousCenter',
		'mapMutex',
		'currentGraphicProjection',
		'requestUpdateTilesWorker',
		'previousScale',
		'movingProc',
		'movingOffset',
		'isMovingMap',
		'isScalingMap',
		'scalingProc',
		'prevAltitude',
		'scalingRatio',
		'mapTilesDirectory',
		'allowSlideMoving',
		'surfaceMap',
		'surfaceMapBuffer',
		'mapBackground'
	],
	#category : #'GeoView-Layers'
}

{ #category : #constants }
GeoViewMapTilesLayer class >> colorWithoutTile [

	^Color black 
]

{ #category : #constants }
GeoViewMapTilesLayer class >> prefixType [

	^'r'
]

{ #category : #constants }
GeoViewMapTilesLayer class >> tilesMapDir [

	^'map'
]

{ #category : #private }
GeoViewMapTilesLayer >> addedToSceneGraph [

	super addedToSceneGraph.

	currentGraphicProjection := self graphicProjection copy.
	self initAndStartMapBuilding
]

{ #category : #drawing }
GeoViewMapTilesLayer >> aeDrawOn: aeCanvas [

	| cairoContext surface extent offcenter scale |
	self mapBackground ifNil: [ ^ self ].
	self mapBackground surface ifNil: [ ^ self ].

	self mapMutex critical: [
		self mapBackground ifNotNil: [ :e |
			scale := self mapBackground scale.
			e surface ifNotNil: [ :f |
				surface := f.
				
				offcenter := e offcenter copy.
				surface deviceScale: scale.
				extent := surface extent copy.
				 ] 
		] 
	].

	cairoContext := aeCanvas privateAeCairoContext.
	Transcript show: 'draw offcenter:'; show: offcenter;cr.
	cairoContext sourceSurface: surface x: offcenter x  y: offcenter y.
	cairoContext rectangle: (0 @ 0 extent: extent).

	cairoContext fill
]

{ #category : #accessing }
GeoViewMapTilesLayer >> allowSlideMoving [

	allowSlideMoving ifNil:[ allowSlideMoving := true].
	^allowSlideMoving
]

{ #category : #'API -- parameters' }
GeoViewMapTilesLayer >> allowSlideMoving: aBoolean [
 
	allowSlideMoving := aBoolean
]

{ #category : #accessing }
GeoViewMapTilesLayer >> buildBufferWorker [

	^ buildBufferWorker
]

{ #category : #accessing }
GeoViewMapTilesLayer >> buildBufferWorker: anObject [

	buildBufferWorker := anObject
]

{ #category : #tiles }
GeoViewMapTilesLayer >> buildFilenameForXY: aTileXY zoom: aLevel [

	| filename |

	filename := self mapTilesDirectory asFileReference.
	filename exists ifFalse:[^nil].

	filename := filename / aLevel asString.
	filename := filename / aTileXY x asString.
	filename := filename / (aTileXY y asString , '.png').
	^filename
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> buildVMapLayerTiles: aVMapTilesXY buffer: aLargerVMapTilesXY level: aLevel [
	
	| findAtLeastOneTile vMapServerTiles |
	
	findAtLeastOneTile := false.
	self surfaceMap ifNil:[^findAtLeastOneTile].
	self surfaceMap offcenter: "self mapBackground offcenter" 0@0 "self mapOffcenter".
	"self surfaceMap position: self graphicProjection cartesianCenter."
	self surfaceMap position:  currentGraphicProjection cartesianCenter.
	
	self buildBufferWorker ifNotNil:[
		self stopBufferWorker.
		self isBufferReady: false.
	].
50 milliSeconds wait.

	findAtLeastOneTile := self loadAndRenderTiles: aVMapTilesXY on: self surfaceMap offset: "self mapBackground offcenter negated"  "0@0" "self mapOffcenter" self surfaceMap offcenter  level: aLevel.
	
			"self surfaceMap surface writePngToPathString: 'surface.png'."
	"VMAP Tiles computing completed"
 	self updateMapWith: self surfaceMap.
	
	vMapServerTiles := self dictTilesByLevel at: aLevel ifAbsent:[nil].
	vMapServerTiles ifNotNil:[
		vMapServerTiles keys size > 9000 ifTrue:[ 
			Transcript show: 'Reset dictionary VMapTiles';cr.
			vMapServerTiles := nil.
			self dictTilesByLevel at: aLevel put: vMapServerTiles. 
		]
	].

	self initBuildBufferWorker: aLargerVMapTilesXY level: aLevel.

	^findAtLeastOneTile
]

{ #category : #computing }
GeoViewMapTilesLayer >> clip: num min: min max: max [

	^(num max: min) min: max
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> computeGraphicBoundsForTile: aGeoFormTile level: aLevel [

	| centerPixel vMapTileCenter diffXY diffPixel origin corner graphicBounds |
	
	aGeoFormTile isNoPicture ifTrue:[
		centerPixel := self graphicProjection projCartToPixel: self graphicProjection cartesianCenter.
		vMapTileCenter := self getTileXYFromGeoPoint: centerPixel level: aLevel.
		diffXY := aGeoFormTile tileXY - vMapTileCenter.
		diffPixel := diffXY * (256@256).
		origin := (centerPixel) + diffPixel.
		corner := origin + (256@256).
	] ifFalse:[
		origin := self getGraphicPositionFromGeoPosition: aGeoFormTile geoBounds origin.
		corner := self getGraphicPositionFromGeoPosition: aGeoFormTile geoBounds corner.
	].
	graphicBounds := origin floor corner: corner floor.
	aGeoFormTile graphicBounds: graphicBounds
]

{ #category : #accessing }
GeoViewMapTilesLayer >> dictTilesByLevel [

	dictTilesByLevel ifNil:[ dictTilesByLevel := Dictionary new].
	^dictTilesByLevel
]

{ #category : #accessing }
GeoViewMapTilesLayer >> dictTilesByLevel: aDictionary [

	dictTilesByLevel := aDictionary
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> doBuildBufferThread: aLargerVMapTilesXY level: aLevel [

	| findAtLeastOneTile |
	self isBufferReady: false.

	findAtLeastOneTile := self loadAndRenderTiles: aLargerVMapTilesXY on: self surfaceMapBuffer offset: "512@512" self mapOffcenter negated level: aLevel.
	findAtLeastOneTile ifFalse:[Transcript show:'buffer vide'. ^self].
	self mapMutex critical: [
		self isBufferReady: true.
		"self surfaceMapBuffer surface writePngToPathString: 'surfaceBuffer.png'."
		self surfaceMap surface: self surfaceMapBuffer surface copy.
		self updateMapWith: self surfaceMap.
		"self sendRepaintRequest"
	]. 

	


]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> doLoadingTilesThread [

	| centerPixel level tilesXY tilesXYBuffer findAtLeastOneTile realLevel|

	self scalingProc ifNotNil:[ self scalingProc isActive ifTrue:[^self]].
	self previousCenter: currentGraphicProjection cartesianCenter.
	self previousScale: currentGraphicProjection altitudeInMeters.
	"self surfaceMap offcenter: self mapOffcenter."
	
	self isComputingTiles: true.

	centerPixel := self getCenterInGeoPoint.
	level := (self getTilesLevelForCurrentResolution) key.
	
	tilesXY := self getTilesXYFor: centerPixel level: level.
	tilesXYBuffer := self getTilesXYForBuffer: centerPixel level: level.
	tilesXYBuffer addAllFirst: tilesXY.

	
	findAtLeastOneTile := self buildVMapLayerTiles:  tilesXY buffer: tilesXYBuffer level: level.
	
	realLevel := level copy.
	[findAtLeastOneTile or:[(realLevel - level) > 3]] whileFalse:[
		level := level -1.
		
		tilesXY := self getTilesXYFor: centerPixel level: level.
		tilesXYBuffer := self getTilesXYForBuffer: centerPixel level: level.
		
		findAtLeastOneTile := self buildVMapLayerTiles:  tilesXY buffer: tilesXYBuffer level: level.
	].
	
]

{ #category : #accessing }
GeoViewMapTilesLayer >> getCenterInGeoPoint [

	| center centerGeoPoint |
	center := self graphicProjection cartesianCenter.
	centerGeoPoint := self mapProjection projCartToLatLon: center.
	
	^centerGeoPoint longitudeInDegrees@centerGeoPoint latitudeInDegrees
	

	
]

{ #category : #accessing }
GeoViewMapTilesLayer >> getCenterInPixel [

	| center centerPixel |
	center := self graphicProjection cartesianCenter.
	centerPixel := self graphicProjection projCartToPixel: center.
	
	^centerPixel
	

	
]

{ #category : #tiles }
GeoViewMapTilesLayer >> getGeoBoundsFromTileXY: aPt level: aLevel [

	| pt1 pt2 |
	pt1 := self getPixelXYFromTileXY: aPt.
	pt2 := pt1 + (256 @ 256).
	pt1 := self getGeoPointFromPixelXY: pt1 level: aLevel.
	pt2 := self getGeoPointFromPixelXY: pt2 level: aLevel.
	^pt1  corner: pt2
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> getGeoImageAtTileXY: axyPoint level: aLevel [

	| geoBounds img isNoPicture geoImage|
	img := self getImageInCacheFromTileXY: axyPoint level: aLevel.

	isNoPicture := false.
	geoBounds := self getGeoBoundsFromTileXY: axyPoint level: aLevel.
	img ifNil:[ isNoPicture := true].
	geoImage := GeoImage new. 
	geoImage position: geoBounds center.
	geoImage isNoPicture: isNoPicture.
	geoImage geoBounds: geoBounds.
	geoImage tileXY: axyPoint.
	geoImage pngReference: img.
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
	pt3 := pt1 + (256 @ 256).
	pt2 := pt1 + (256 @ 0).
	pt4 := pt1 + (0 @ 256).
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
	
	pos := self graphicProjection projCartToPixel: cartCoord.
	
	pos := pos + self viewInfos origin.
	
	^pos
]

{ #category : #tiles }
GeoViewMapTilesLayer >> getImageInCacheFromTileXY: aPt level: aLevel [

	| tileXY position filename geoBounds|
	geoBounds := (self getGeoBoundsFromTileXY: aPt level: aLevel).
	position :=  (geoBounds topLeft + geoBounds bottomRight) / 2.0.
	tileXY := self tileNumberForLat: position y long: position x  zoom: aLevel.
	filename := self buildFilenameForXY: tileXY zoom: aLevel.
	filename ifNil:[^nil].
	filename parent asFileReference ensureCreateDirectory.
	filename exists ifTrue: [^filename].
	^nil
]

{ #category : #level }
GeoViewMapTilesLayer >> getPixelXYFromGeoPoint: aGeoPoint level: aLevel [

	| lat lon pt |
	lat := aGeoPoint y.
	lon := aGeoPoint x.
	pt := 0 @ 0.
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
	pt setX: (aTilePt x * 256) setY: (aTilePt y * 256).
	^pt
]

{ #category : #computing }
GeoViewMapTilesLayer >> getTileSurfaceFromGeoImage: aGeoImageTile [

	| tileSurface context|
	aGeoImageTile pngReference ifNil:[
		tileSurface := AeCairoImageSurface extent: 256@256.
		context := tileSurface newContext.
		context sourceColor: self class colorWithoutTile ;paint
	] ifNotNil:[
		tileSurface := AeCairoImageSurface newFromPngFileAt: aGeoImageTile pngReference
	].
	^tileSurface
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
	pt setX: ((aPixelPt x / 256) asInteger) setY: ((aPixelPt y / 256) asInteger).
	^pt
	
]

{ #category : #level }
GeoViewMapTilesLayer >> getTilesLevelForCurrentResolution [

	| tile points pt2 pt3 h current  center tileHeight centerPixels|
	
	tileHeight := 128.
	center := self graphicProjection cartesianCenter.
	centerPixels := self graphicProjection projCartToPixel: center.
	
	(18 to: 1 by: -1) detect: 
			[:i |
			tile := self getTileXYFromGeoPoint: centerPixels level: i.
			points := self getGeoRectanglePointsFromTileXY: tile level: i.
			points := points collect: [:pt | self getGraphicPositionFromGeoPosition: pt].
			pt2 := points at: 2.
			pt3 := points at: 3.
			h := (pt2 - pt3) r.
			current := i -> h.
			h >= tileHeight
				ifTrue: [true]
				ifFalse: [false]] ifNone:[ 0 -> tileHeight].
	^current
	
]

{ #category : #tiles }
GeoViewMapTilesLayer >> getTilesXYFor: aCenter level: aLevel [
	
	| vMapTilesXY tileQt squareSize vMapTileCenter diff pos maxTiles |	

	vMapTilesXY := OrderedCollection new.
	vMapTileCenter := self getTileXYFromGeoPoint: aCenter level: aLevel.

	"Compute nb of tiles (rows and columns) + 2@2 => add 2 tiles on each side"
	tileQt := ((self graphicProjection extentInPixels extent / 256) + (2@2)) rounded.

	"compute size of the square containing these tiles, and define order to start on center and go to the side on a spiral"
	squareSize := (tileQt x) max: (tileQt y).

	vMapTilesXY add: vMapTileCenter.
	pos := vMapTileCenter copy.
	1 to: squareSize do:[:i |
		i even ifFalse:[
			1 to: i do:[:j |
				pos := pos +  (1@0).
				vMapTilesXY add: pos
			].
			1 to: i do:[:j |
				pos := pos +  (0@1).
				vMapTilesXY add: pos
			]
		] ifTrue:[
			1 to:i  do:[:j |
				pos := pos +  ((1 negated)@0).
				vMapTilesXY add: pos
			].
			1 to: i  do:[:j |
				pos := pos +  (0@(1 negated)).
				vMapTilesXY add: pos
			]
		].
	].
	squareSize even ifTrue:[
		1 to: squareSize do:[:j |
			pos := pos +  (1@0).
			vMapTilesXY add: pos
		]
	] ifFalse:[
		1 to: squareSize  do:[:j |
			pos := pos +  ((1 negated)@0).
			vMapTilesXY add: pos
		].
	].

	"Add sides"
	diff := (tileQt x) - (tileQt y).
	diff abs > 1 ifTrue:[
		diff > 0 ifTrue:[
			0 to: diff do:[:i | 
				0 to: squareSize do:[:j | 
					vMapTilesXY add:  pos +  (i@j).
					vMapTilesXY add:  pos + ((squareSize negated)@0) +  ((i negated)@j).
				].
			] 
		] ifFalse:[
			diff := diff negated.
			0 to: diff do:[:i | 
				0 to: squareSize do:[:j | 
					vMapTilesXY add:  pos +  (j@i).
					vMapTilesXY add:  pos + ((squareSize negated)@0) +  (j@(i negated)).
				].

			] 
		]
	].

	maxTiles := 2 raisedTo: aLevel.

	vMapTilesXY := vMapTilesXY select:[:t | (t x >= 0) and:[(t y >= 0) and:[ (t x < maxTiles) and:[ t y < maxTiles]]]].

	^vMapTilesXY
]

{ #category : #tiles }
GeoViewMapTilesLayer >> getTilesXYForBuffer: aCenter level: aLevel [
	
	| vMapTilesXYBuffer tileQt  vMapTileCenter x y maxTiles |	

	vMapTilesXYBuffer := OrderedCollection new.
	vMapTileCenter := self getTileXYFromGeoPoint: aCenter level: aLevel.

	tileQt := (((self graphicProjection extentInPixels extent / 256) / 2) + (2@2)) rounded.

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
GeoViewMapTilesLayer >> initAndStartMapBuilding [

	self stopWorkers.
	
	self scalingProc ifNotNil:[ self scalingProc isActive ifTrue:[^self]].

	self mapMutex critical:[
		self initSurfaceMap: currentGraphicProjection extentInPixels extent + (1024 @ 1024).
		self initSurfaceMapBuffer: currentGraphicProjection extentInPixels extent + (1024 @ 1024).
	].

	"self updateMapWith: self surfaceMap."

	self loadingTilesWorker: ([ self doLoadingTilesThread ]
			 forkAt: Processor systemBackgroundPriority
			 named: 'Map tiles loading')
]

{ #category : #private }
GeoViewMapTilesLayer >> initBuildBufferWorker: aLargerVMapTilesXY level: aLevel [

	self stopBufferWorker.

	self buildBufferWorker:
		([ self doBuildBufferThread: aLargerVMapTilesXY level: aLevel ]
			 forkAt: Processor systemBackgroundPriority
			 named: 'Map buffer builder')
]

{ #category : #private }
GeoViewMapTilesLayer >> initSurfaceMap: anExtent [

	| geoSurface |
	(self surfaceMap notNil and: [
		 self surfaceMap surface extent = anExtent ]) ifTrue: [ ^ self ].

	geoSurface := GeoSurface new.
	geoSurface surface: (AeCairoImageSurface extent: anExtent).
	geoSurface offcenter: self mapOffcenter.
	self surfaceMap: geoSurface
]

{ #category : #private }
GeoViewMapTilesLayer >> initSurfaceMapBuffer: anExtent [

	| geoSurface |
	(self surfaceMapBuffer notNil and: [
		 self surfaceMapBuffer surface extent = anExtent ]) ifTrue: [
		^ self ].

	geoSurface := GeoSurface new.
	geoSurface surface: (AeCairoImageSurface extent: anExtent).
	geoSurface offcenter: (-512)@(-512).
	geoSurface isBuffer: true.
	self surfaceMapBuffer: geoSurface
]

{ #category : #accessing }
GeoViewMapTilesLayer >> isBufferReady [

	isBufferReady ifNil:[ isBufferReady := false].
	^isBufferReady
]

{ #category : #accessing }
GeoViewMapTilesLayer >> isBufferReady: aBoolean [

	isBufferReady := aBoolean
]

{ #category : #accessing }
GeoViewMapTilesLayer >> isComputingTiles [

	isComputingTiles ifNil:[ isComputingTiles := false].
	^isComputingTiles
]

{ #category : #accessing }
GeoViewMapTilesLayer >> isComputingTiles: aBoolean [

	isComputingTiles := aBoolean
]

{ #category : #accessing }
GeoViewMapTilesLayer >> isMovingMap [

	isMovingMap ifNil:[isMovingMap := false].
	^isMovingMap
]

{ #category : #accessing }
GeoViewMapTilesLayer >> isMovingMap: aBoolean [

	isMovingMap := aBoolean 
]

{ #category : #accessing }
GeoViewMapTilesLayer >> isScalingMap [

	isScalingMap ifNil:[isScalingMap := false].
	^isScalingMap
]

{ #category : #accessing }
GeoViewMapTilesLayer >> isScalingMap: aBoolean [

	isScalingMap := aBoolean 
]

{ #category : #private }
GeoViewMapTilesLayer >> launchRequestUpdateTilesWorker [

	self requestUpdateTilesWorker ifNotNil:[ self requestUpdateTilesWorker terminate. self requestUpdateTilesWorker: nil].
	self requestUpdateTilesWorker: ([500 milliSeconds wait. self initAndStartMapBuilding ]  forkAt: Processor systemBackgroundPriority
			 named: 'Update tiles after delay')

]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> loadAndRenderTiles: aListTilesXY on: aSurface offset: anOffset level: aLevel [

	| index t geoTile  findAtLeastOneTile vMapServerTiles nbTiles tilesXY context|
	
	index := 1.
	findAtLeastOneTile := false.
	aSurface isBuffer ifFalse:[
		context := aSurface surface newContext.
		context sourceColor: self class colorWithoutTile;paint.
	].

	vMapServerTiles := self dictTilesByLevel at: aLevel ifAbsent:[nil].
	vMapServerTiles ifNil: [vMapServerTiles := Dictionary new: 10000].
	tilesXY := aListTilesXY copy.
	nbTiles := tilesXY size.

	"Required to display first tiles correctlty"
	50 milliSeconds wait.

	[index <= nbTiles and: [ self isComputingTiles]]
		whileTrue: 
			[| tKey isValidTile |
			tKey := tilesXY at: index.
			index := index + 1.
						
			[ t := vMapServerTiles at: tKey ifAbsentPut: [geoTile := self getGeoImageAtTileXY: tKey level: aLevel. geoTile].

				self computeGraphicBoundsForTile: t level: aLevel.
				self offcenterGeoPngTile: t offset: anOffset level: aLevel.
				isValidTile := t isNoPicture not and:[ (t graphicBounds origin <= currentGraphicProjection extentInPixels extent) and:[t graphicBounds origin >= currentGraphicProjection extentInPixels origin]].
				findAtLeastOneTile := findAtLeastOneTile or:[ isValidTile ].
				
				self renderTileImage: t on: aSurface surface.
					"aSurface isBuffer ifFalse:[ self updateMapWith: aSurface]."
			] on:[ Exception ] do:[:ex |
					Transcript show: 'Error on VMapTiles computing :';show: ex printString;cr.
					(Delay forMilliseconds: 1000) wait.
					ex restart]
					
	].
	self dictTilesByLevel at: aLevel put: vMapServerTiles.

	^findAtLeastOneTile

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

	^(-512)@(-512)
]

{ #category : #computing }
GeoViewMapTilesLayer >> mapSize: aLevel [

	^(256 bitShift: aLevel) asInteger
]

{ #category : #accessing }
GeoViewMapTilesLayer >> mapTilesDirectory [

	mapTilesDirectory ifNil:[ mapTilesDirectory := (FileLocator imageDirectory / self class tilesMapDir / self class prefixType )].
	^mapTilesDirectory
]

{ #category : #'API -- parameters' }
GeoViewMapTilesLayer >> mapTilesDirectory: aPath [

	mapTilesDirectory := aPath 
]

{ #category : #private }
GeoViewMapTilesLayer >> moveMapBackground [

	| previousPixel proc|

	self movingProc ifNotNil:[ self movingProc isTerminated ifFalse:[ self movingProc terminate] ].
	self movingOffset: 0@0.

	proc := [
		self previousCenter ifNil:[self previousCenter: currentGraphicProjection cartesianCenter copy]. 
		[self isMovingMap or:[self movingOffset r > 1 ]] whileTrue: [
			previousPixel := currentGraphicProjection projCartToPixel: self previousCenter.
	
			self isMovingMap ifTrue:[ self movingOffset: (previousPixel - self getCenterInPixel) copy].
			
			self previousCenter: currentGraphicProjection cartesianCenter copy.
			self mapMutex critical: [
				self mapBackground offcenter: self mapBackground offcenter + self movingOffset.
				self sendRepaintRequest 
			].
			self allowSlideMoving ifTrue:[ self movingOffset: self movingOffset * 0.8 ] ifFalse:[ self movingOffset: 0@0].
		
			50 milliSeconds wait.
			self isMovingMap: false.
		].
		self movingProc: nil.
	].

	self movingProc: (proc forkAt: Processor userSchedulingPriority).

	

]

{ #category : #accessing }
GeoViewMapTilesLayer >> movingOffset [

	^movingOffset
]

{ #category : #accessing }
GeoViewMapTilesLayer >> movingOffset: aPoint [

	movingOffset := aPoint 
]

{ #category : #accessing }
GeoViewMapTilesLayer >> movingProc [

	^movingProc
]

{ #category : #accessing }
GeoViewMapTilesLayer >> movingProc: aProc [

	movingProc := aProc 
]

{ #category : #private }
GeoViewMapTilesLayer >> needToMoveMap: aContext [

	| previousPixel  currentPixel centerOffsetPixel |
	previousPixel := 0@0.
	self isMovingMap: false.
	currentGraphicProjection ifNil:[ ^ self ].
	self previousCenter ifNil:[^self].
	
	previousPixel := currentGraphicProjection projCartToPixel: self previousCenter.
	
	currentPixel := currentGraphicProjection projCartToPixel: (currentGraphicProjection cartesianCenter).
	currentPixel ifNil:[ currentPixel := 0@0 ].
	centerOffsetPixel := (previousPixel - currentPixel) abs.
	
	(aContext isScaleChanged or:[aContext isResolutionChanged]) ifTrue:[ ^self].
	
	(aContext isCenterChanged and:[ centerOffsetPixel r <= 256 ]) ifTrue:[
		self isMovingMap: true.
	].
]

{ #category : #private }
GeoViewMapTilesLayer >> needToRecomputeMap: aContext [

	| previousPixel  currentPixel centerOffsetPixel |
	previousPixel := 0@0.
	(self isScalingMap and:[aContext scaleCenterPoint notNil ]) ifTrue:[^false].
	(self scalingProc notNil and: [self scalingProc isActive ])ifTrue:[^false].
	currentGraphicProjection ifNil:[ ^ true ].
	self previousCenter ifNil:[^true].
	
	previousPixel := currentGraphicProjection projCartToPixel: self surfaceMap position.
	currentPixel := currentGraphicProjection projCartToPixel: (currentGraphicProjection cartesianCenter).
	currentPixel ifNil:[ currentPixel := 0@0 ].
	centerOffsetPixel := (previousPixel - currentPixel) abs.

	"Ignore others processing when only center changed"
	aContext isMapProjectionChange ifFalse:[
		aContext isExtentChanged ifFalse:[
				aContext isResolutionChanged ifFalse:[
						aContext isScaleChanged ifFalse:[ 
							(aContext isCenterChanged and:[ centerOffsetPixel r <= 256 ]) ifTrue:[
								^ false
							] 
						].
					].
			].	
	].

	^ true
]

{ #category : #private }
GeoViewMapTilesLayer >> needToScaleMap: aContext [

	(aContext isScaleChanged or:[aContext isResolutionChanged]) ifFalse: [^self].
	self isScalingMap: aContext scaleCenterPoint notNil.
	aContext scaleCenterPoint ifNil:[ self launchRequestUpdateTilesWorker].
	
]

{ #category : #tiles }
GeoViewMapTilesLayer >> offcenterGeoPngTile: aTile offset: anOffset level: aLevel [

	| origin corner center modelCenter|
	
	aTile graphicBounds ifNil:[
		self computeGraphicBoundsForTile: aTile level: aLevel
	].
	origin := aTile graphicBounds origin.
	corner := aTile graphicBounds corner.
	
	center := (origin + corner) /2.
	 
	modelCenter := self getCenterInPixel.
	aTile offcenter: ((center - modelCenter + anOffset) floor)
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
	geoCenter := self graphicProjection cartesianCenter asPoint.
	pixel := ((point x @ point y negated) - (geoCenter x @ geoCenter y negated))
		* aMetersByPixel
		+ self graphicProjection offsetInPixels.

	^ pixel
]

{ #category : #private }
GeoViewMapTilesLayer >> removedFromSceneGraph [

	super removedFromSceneGraph.
	self stopWorkers
]

{ #category : #rendering }
GeoViewMapTilesLayer >> renderSurface: aSurface on: aTargetSurface scale: aXYScale centeredAt: aPoint tile: aGeoImageTile [
	
	| offset targetContext|
	
	targetContext := aTargetSurface newContext.
	targetContext sourceColor: Color red.
	targetContext translateBy: aPoint.
	targetContext scaleBy: aXYScale.
	offset := 0@0 - (128@128).
	targetContext translateBy: offset.
	targetContext sourceSurface: aSurface x: 0 y: 0.
	targetContext paint.

	
]

{ #category : #rendering }
GeoViewMapTilesLayer >> renderTileImage: aGeoImageTile on: aSurface [

	|origin corner scale center centerPixel tileSurface|
	
	aGeoImageTile graphicBounds ifNil:[
		origin := self getGraphicPositionFromGeoPosition: aGeoImageTile geoBounds origin.
		corner := self getGraphicPositionFromGeoPosition: aGeoImageTile geoBounds corner
	] ifNotNil:[
		origin := aGeoImageTile graphicBounds origin.
		corner := aGeoImageTile graphicBounds corner
	].

	scale := (corner y - origin y) / 256.
	"Slightly increase size of tiles to avoid space between tiles"
	scale := scale + ((0.005 * scale) max: 0.01).
	
	center := self graphicProjection cartesianCenter.
	centerPixel := self graphicProjection projCartToPixel: center.
	
	aGeoImageTile offcenter ifNotNil:[ centerPixel := centerPixel + aGeoImageTile offcenter].
	
	tileSurface := self getTileSurfaceFromGeoImage: aGeoImageTile.
	self renderSurface: tileSurface on: aSurface scale: scale@scale centeredAt: centerPixel tile: aGeoImageTile
	



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
GeoViewMapTilesLayer >> resetMapSurface: aSurface [

	| context |
	aSurface isBuffer ifFalse:[
		context := aSurface surface newContext.
		context sourceColor: self class colorWithoutTile;paint
	].

]

{ #category : #private }
GeoViewMapTilesLayer >> scaleMapBackground: aContext [

	|  proc ratio step scaleCenter scaleCenterAbs  offsetCenter positionPixel prevPositionPixel |
	
	step := 0.1.

	self isScalingMap ifFalse:[^self].
		
	aContext scaleCenterPoint ifNil:[^self]. 
	scaleCenterAbs := aContext scaleCenterPoint copy.
	scaleCenterAbs ifNil:[^self].
	self scalingProc ifNotNil:[ self scalingProc isTerminated ifFalse:[ self scalingProc terminate]. self scalingProc: nil].
	self scalingRatio ifNil:[ self scalingRatio: 0 ].
	"self mapBackground  ifNotNil:[ self mapBackground offcenter: self mapOffcenter ]."

	proc := [
		self previousScale ifNil:[self previousScale: currentGraphicProjection altitudeInMeters copy]. 
		[self mapBackground notNil and:[self isScalingMap or:[self scalingRatio abs >= (step/2) ]]] whileTrue: [ 
			| scale | 
			
			self isScalingMap ifTrue:[ 
				ratio := currentGraphicProjection altitudeInMeters / self previousScale.
	
				ratio > 1 ifTrue:[
					ratio <= 2 ifTrue:[ self scalingRatio: 1 - ratio ].
				] ifFalse:[
					ratio >= 0.5 ifTrue:[self scalingRatio: (1/ratio) - 1].
				].
			] ifFalse: [ self launchRequestUpdateTilesWorker].
			
			
			
				scale := self scalingRatio > 0 ifTrue:[
					1 /  (2 - self scalingRatio)
				] ifFalse:[
					self scalingRatio + 2
				].
				
				scaleCenter := self mapProjection projLatLonToCart: scaleCenterAbs .
				prevPositionPixel := (self projCartToPixel: scaleCenter metersByPixel: self graphicProjection metersByPixel) copy.
				positionPixel := ((self projCartToPixel: scaleCenter metersByPixel: self graphicProjection metersByPixel ) * scale )copy.

				offsetCenter :=  (self mapOffcenter + (positionPixel - prevPositionPixel)) / scale.
			self mapMutex critical: [
				self mapBackground scale: (scale@scale).
				self mapBackground offcenter: offsetCenter.
				self sendRepaintRequest 
			].
			self scalingRatio > 0 ifTrue:[
				self scalingRatio: ((self scalingRatio - step) max: 0).
			] ifFalse:[
				self scalingRatio: ((self scalingRatio + step) min: 0).
			].
	
			150 milliSeconds wait.
			self isScalingMap: false.
		].
		self scalingProc:nil.
		"self mapMutex critical: [
			self mapBackground offcenter: self mapOffcenter 
		]"
		"self updateMapWith: self surfaceMap.
		self resetMapSurface: self surfaceMap"
	].

	self scalingProc: (proc forkAt: Processor userSchedulingPriority).

	

]

{ #category : #accessing }
GeoViewMapTilesLayer >> scalingProc [

	^scalingProc
]

{ #category : #accessing }
GeoViewMapTilesLayer >> scalingProc: aProc [

	scalingProc := aProc 
]

{ #category : #accessing }
GeoViewMapTilesLayer >> scalingRatio [

	^scalingRatio

	
]

{ #category : #accessing }
GeoViewMapTilesLayer >> scalingRatio: aRatio [

	scalingRatio := aRatio

	
]

{ #category : #computing }
GeoViewMapTilesLayer >> sinLatitude: aLatitude [

	^(aLatitude * (Float pi / 180)) sin
]

{ #category : #private }
GeoViewMapTilesLayer >> stopBufferWorker [

	self buildBufferWorker ifNotNil:[
		self buildBufferWorker isTerminated ifFalse:[ self buildBufferWorker terminate].
	].

	self buildBufferWorker: nil.

]

{ #category : #private }
GeoViewMapTilesLayer >> stopTilesWorker [

	self loadingTilesWorker ifNotNil:[
		self loadingTilesWorker isTerminated ifFalse:[ self loadingTilesWorker terminate]
	].

	self loadingTilesWorker: nil.
]

{ #category : #private }
GeoViewMapTilesLayer >> stopWorkers [

	self stopTilesWorker.
	self stopBufferWorker
]

{ #category : #accessing }
GeoViewMapTilesLayer >> surfaceMap [

	^ surfaceMap
]

{ #category : #accessing }
GeoViewMapTilesLayer >> surfaceMap: aCairoSurface [

	surfaceMap := aCairoSurface
]

{ #category : #accessing }
GeoViewMapTilesLayer >> surfaceMapBuffer [

	^ surfaceMapBuffer
]

{ #category : #accessing }
GeoViewMapTilesLayer >> surfaceMapBuffer: aCairoSurface [

	surfaceMapBuffer := aCairoSurface
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

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> updateMapWith: aGeoSurface [

	aGeoSurface ifNil: [ ^ self ].

	self isScalingMap ifTrue:[^self].
	self scalingProc ifNotNil:[ self scalingProc isActive ifTrue:[^self]].
	self movingProc ifNotNil:[ self movingProc isActive ifTrue:[^self]].

	self mapMutex critical: [
		self mapBackground: aGeoSurface.
		aGeoSurface isBuffer ifTrue:[
			self mapBackground offcenter: self mapOffcenter.

		] ifFalse:[
			self mapBackground offcenter: self mapOffcenter
		].
	Transcript show: 'isBufferReady:';show: self isBufferReady;cr.
	
	
		self mapBackground scale: 1 @ 1.
		self mapBackground position: currentGraphicProjection cartesianCenter.
		self sendRepaintRequest

	]
]

{ #category : #private }
GeoViewMapTilesLayer >> updateModel: aContext [

	| needToReComputeMap |
	super updateModel: aContext.
	self graphicProjection ifNil: [ ^ self ].
	currentGraphicProjection := self graphicProjection copy.

	self requestUpdateTilesWorker ifNotNil:[ self requestUpdateTilesWorker terminate. self requestUpdateTilesWorker: nil].

	self needToMoveMap: aContext.
	self needToScaleMap: aContext.
	needToReComputeMap := self needToRecomputeMap: aContext.
	self moveMapBackground.
	self scaleMapBackground: aContext.
	needToReComputeMap ifFalse: [ ^self].
	self isMovingMap ifFalse:[
		self initAndStartMapBuilding
	] ifTrue: [ self launchRequestUpdateTilesWorker. ]
	
]
