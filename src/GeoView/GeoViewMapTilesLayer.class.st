Class {
	#name : #GeoViewMapTilesLayer,
	#superclass : #AbstractGeoViewBasicLayer,
	#instVars : [
		'loadingTilesWorker',
		'dictTilesByLevel',
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
		'scalingRatio',
		'allowSlideMoving',
		'surfaceMap',
		'mapBackground',
		'tilesProvider',
		'isDisplayTilesProviderNote',
		'tilesProviderNoteGText',
		'loadingBufferWorker'
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

{ #category : #private }
GeoViewMapTilesLayer >> addedToSceneGraph [

	super addedToSceneGraph.

	currentGraphicProjection := self graphicProjection copy.
	self initAndStartMapBuilding
]

{ #category : #drawing }
GeoViewMapTilesLayer >> aeDrawOn: aeCanvas [

	| cairoContext surface extent offcenter scale gText |
	self mapBackground ifNil: [ ^ self ].
	self mapBackground surface ifNil: [ ^ self ].

	self flag:'TODO pla: map mutex is used in tiles computation and rendering: this is a problem and why osm is not speed - need to refactor before'.
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
	cairoContext sourceSurface: surface x: offcenter x  y: offcenter y.
	cairoContext rectangle: (0 @ 0 extent: extent).
	cairoContext fill. 
	
	self flag:'pla: need to display this text on top of the view (not only in the layer) because it can be hidden by on top objects'.
	self isDisplayTilesProviderNote ifFalse:[ ^ self ].
	gText := self tilesProviderNoteGText2D ifNil:[ ^ self ].
	gText position: (self viewInfos extent) - (15@15).
	gText setRight.
	gText aeDrawOn: aeCanvas.
	
	
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

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> buildVMapLayerTiles: aVMapTilesXY buffer: aLargerVMapTilesXY level: aLevel [
	
	| findAtLeastOneTile vMapServerTiles context |
	
	findAtLeastOneTile := false.
	self surfaceMap ifNil:[^findAtLeastOneTile].
	self surfaceMap offcenter: self mapOffcenter.
	self surfaceMap position: currentGraphicProjection cartesianCenter.

	context := self surfaceMap surface newContext"; paint".
"	context sourceColor: self class colorWithoutTile; paint."

	findAtLeastOneTile := self loadAndRenderTiles: aVMapTilesXY on: self surfaceMap offset: self mapOffcenter negated level: aLevel.
	
	"VMAP Tiles computing completed"
 	self updateMapBackground.
	
	self loadingBufferWorker: ([
		self loadAndRenderTiles: aLargerVMapTilesXY on: self surfaceMap offset: self mapOffcenter negated level: aLevel.
	
		 self updateMapBackground.
	
		vMapServerTiles := self dictTilesByLevel at: aLevel ifAbsent:[nil].
		vMapServerTiles ifNotNil:[
			vMapServerTiles keys size > 9000 ifTrue:[ 
				Transcript show: 'Reset dictionary VMapTiles';cr.
				vMapServerTiles := nil.
				self dictTilesByLevel at: aLevel put: vMapServerTiles. 
			]
		]
	] forkAt: Processor systemBackgroundPriority named: 'Map buffer loading').

	^findAtLeastOneTile
]

{ #category : #computing }
GeoViewMapTilesLayer >> clip: num min: min max: max [

	^(num max: min) min: max
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> computeGraphicBoundsForTile: aGeoFormTile level: aLevel [

	| centerPixel vMapTileCenter diffXY diffPixel origin corner graphicBounds centerGeoPoint|
	
	aGeoFormTile isNoPicture ifTrue:[
		centerPixel := self getCenterInPixel.
		centerGeoPoint := self getCenterInGeoPoint.
		vMapTileCenter := self getTileXYFromGeoPoint: centerGeoPoint level: aLevel.
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
GeoViewMapTilesLayer >> doLoadingTilesThread [

	| centerGeoPoint level tilesXY tilesXYBuffer findAtLeastOneTile realLevel|

	self previousCenter: currentGraphicProjection cartesianCenter.
	self previousScale: currentGraphicProjection altitudeInMeters copy.
	self surfaceMap offcenter: self mapOffcenter.
	self surfaceMap scale: 1@1.

	centerGeoPoint := self getCenterInGeoPoint.
	level := (self getTilesLevelForCurrentResolution) key copy.
	
	tilesXY := (self getTilesXYFor: centerGeoPoint level: level) copy.
	tilesXYBuffer := (self getTilesXYForBuffer: centerGeoPoint level: level) copy.
	
	findAtLeastOneTile := self buildVMapLayerTiles:  tilesXY buffer: tilesXYBuffer level: level.
	
	realLevel := level copy.
	[findAtLeastOneTile or:[(realLevel - level) > 3]] whileFalse:[
		level := level -1.
		
		tilesXY := self getTilesXYFor: centerGeoPoint level: level.
		tilesXYBuffer := self getTilesXYForBuffer: centerGeoPoint level: level.
		
		findAtLeastOneTile := self buildVMapLayerTiles:  tilesXY buffer: tilesXYBuffer level: level.
	].
	
]

{ #category : #accessing }
GeoViewMapTilesLayer >> getCenterInGeoPoint [

	| center centerGeoPoint |
	center := currentGraphicProjection cartesianCenter.
	centerGeoPoint := self mapProjection projCartToLatLon: center.
	
	^centerGeoPoint longitudeInDegrees@centerGeoPoint latitudeInDegrees
	

	
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
	pt2 := pt1 + (256 @ 256).
	pt1 := self getGeoPointFromPixelXY: pt1 level: aLevel.
	pt2 := self getGeoPointFromPixelXY: pt2 level: aLevel.
	^pt1  corner: pt2
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> getGeoImageAtTileXY: axyPoint level: aLevel [

	| geoBounds img isNoPicture geoImage|
	
	self tilesProvider ifNil: [ ^ nil ].
	self flag:'pla: mettre un controle derreur reseau (si offline par exemple)'.
	img := self tilesProvider tileFor: aLevel x: axyPoint x y: axyPoint y.
	
	"img := self useLocalTilesDirectory ifTrue:[
		self getImageInCacheFromTileXY: axyPoint level: aLevel
	] ifFalse:[
		self downloadImageFromTileXY:  axyPoint level: aLevel
	]."

	isNoPicture := false.
	geoBounds := self getGeoBoundsFromTileXY: axyPoint level: aLevel.
	img ifNil:[ isNoPicture := true].
	
	geoImage := GeoMapTile new. 
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
	
	pos := currentGraphicProjection projCartToPixel: cartCoord.
	
	pos := pos + self viewInfos origin.
	
	^pos
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
	pt setX: (aTilePt x * 256) setY: (aTilePt y * 256).
	^pt
]

{ #category : #computing }
GeoViewMapTilesLayer >> getTileSurfaceFromGeoImage: aGeoImageTile [

	| tileSurface context|
	aGeoImageTile pngReference ifNil:[
		tileSurface := AeCairoImageSurface extent: 256@256.
		context := tileSurface newContext.
		"context sourceColor: self class colorWithoutTile ;paint"
	] ifNotNil:[
		tileSurface := aGeoImageTile pngReference isForm ifTrue:[ AeCairoImageSurface fromForm: aGeoImageTile pngReference]  ifFalse:[ AeCairoImageSurface newFromPngFileAt: aGeoImageTile pngReference]
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

	| tile points pt2 pt3 h current tileHeight centerGeoPoint|
	
	tileHeight := 128.
	centerGeoPoint := self getCenterInGeoPoint.
	(18 to: 1 by: -1) detect: 
			[:i |
			tile := self getTileXYFromGeoPoint: centerGeoPoint level: i.
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
	tileQt := ((currentGraphicProjection extentInPixels extent / 256) + (2@2)) rounded.

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

	tileQt := (((currentGraphicProjection extentInPixels extent / 256) / 2) + (2@2)) rounded.

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

	self stopTilesWorker.

	self mapMutex critical: [
		self initSurfaceMap:
			currentGraphicProjection extentInPixels extent + (1024 @ 1024) ].

	self loadingTilesWorker: ([ self doLoadingTilesThread ]
			 forkAt: Processor userBackgroundPriority
			 named: 'Map tiles loading')
]

{ #category : #private }
GeoViewMapTilesLayer >> initSurfaceMap: anExtent [

	| geoSurface |

	geoSurface := GeoMapSurface new.
	geoSurface surface: (AeCairoImageSurface extent: anExtent).
	geoSurface offcenter: self mapOffcenter.
	self surfaceMap: geoSurface
]

{ #category : #initialization }
GeoViewMapTilesLayer >> initialize [

	| font |
	super initialize.

	self tilesProvider: GeoViewOpenStreetMapTilesProvider new.

	"init note text"
	font := SmockFont named: 'Source code pro'.
	font
		fontSize: 18;
		fontSlant: #italic.

	tilesProviderNoteGText := SmockGText2D new.
	tilesProviderNoteGText
		smockFont: font nearestFont;
		fillStyle: (SmockFillStyle paint: Color black);
		setBottomRight 
]

{ #category : #'API -- parameters' }
GeoViewMapTilesLayer >> isDisplayTilesProviderNote [

	^ isDisplayTilesProviderNote ifNil: [ isDisplayTilesProviderNote := true ]
]

{ #category : #'API -- parameters' }
GeoViewMapTilesLayer >> isDisplayTilesProviderNote: anObject [

	isDisplayTilesProviderNote := anObject
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
	self requestUpdateTilesWorker: ([100 milliSeconds wait. self initAndStartMapBuilding ]  forkAt: Processor systemBackgroundPriority
			 named: 'Update tiles after delay')

]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> loadAndRenderTiles: aListTilesXY on: aSurface offset: anOffset level: aLevel [

	| index t geoTile  findAtLeastOneTile vMapServerTiles nbTiles tilesXY |
	
	index := 1.
	findAtLeastOneTile := false.

	vMapServerTiles := self dictTilesByLevel at: aLevel ifAbsent:[nil].
	vMapServerTiles ifNotNil:[ vMapServerTiles := vMapServerTiles copy] ifNil: [vMapServerTiles := Dictionary new: 10000].
	tilesXY := aListTilesXY copy.
	nbTiles := tilesXY size.

	[index <= nbTiles]
		whileTrue: 
			[| tKey isValidTile |
			tKey := tilesXY at: index.
			index := index + 1.
						
			[ t := vMapServerTiles at: tKey ifAbsentPut: [geoTile := self getGeoImageAtTileXY: tKey level: aLevel. geoTile].

				self computeGraphicBoundsForTile: t level: aLevel.
				self offcenterGeoPngTile: t offset: anOffset level: aLevel.
				isValidTile := t isNoPicture not.
				findAtLeastOneTile := findAtLeastOneTile or:[ isValidTile ].
				
				self renderTileImage: t on: aSurface surface.
				self updateMapBackground
			] on:[ Exception ] do:[:ex |
					Transcript show: 'Error on VMapTiles computing :';show: ex printString;cr.
					(Delay forMilliseconds: 1000) wait.
					ex restart]
					
	].
	self dictTilesByLevel at: aLevel put: vMapServerTiles.

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

{ #category : #private }
GeoViewMapTilesLayer >> moveMapBackground [

	| previousPixel proc|

	self movingProc ifNotNil:[ self movingProc isTerminated ifFalse:[ self movingProc terminate ] ].
	self movingOffset: 0@0.
	self mapBackground ifNil:[ ^self].

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
	(self scalingProc notNil and: [self scalingProc isActive ])ifTrue:[^false].
	currentGraphicProjection ifNil:[ ^ true ].
	self previousCenter ifNil:[^true].
	self surfaceMap position ifNil:[^true].
	
	previousPixel := currentGraphicProjection projCartToPixel: self surfaceMap position.
	currentPixel := currentGraphicProjection projCartToPixel: (currentGraphicProjection cartesianCenter).
	currentPixel ifNil:[ currentPixel := 0@0 ].
	centerOffsetPixel := (previousPixel - currentPixel) abs.

	"Ignore others processing when only center changed"
	aContext isMapProjectionChange ifFalse:[
		aContext isExtentChanged ifFalse:[
				aContext isResolutionChanged ifFalse:[
						aContext isScaleChanged ifFalse:[ 
							(aContext isCenterChanged and:[ centerOffsetPixel r <= 128 ]) ifTrue:[
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
	self isScalingMap: true.
	self launchRequestUpdateTilesWorker.
	
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
	
	center := currentGraphicProjection cartesianCenter.
	centerPixel := currentGraphicProjection projCartToPixel: center.
	
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
GeoViewMapTilesLayer >> resetMapSurface [

	| context |
	context := self surfaceMap surface newContext.
	"context sourceColor: self class colorWithoutTile;paint."
]

{ #category : #private }
GeoViewMapTilesLayer >> scaleMapBackground: aContext [

	"|  proc ratio step scaleCenter scaleCenterAbs  offsetCenter positionPixel prevPositionPixel index |
	
	step := 0.1.
	index := 1.
	self isScalingMap ifFalse:[^self].
		
	scaleCenterAbs := aContext scaleCenterPoint copy.
	scaleCenterAbs ifNil:[^self].
	self scalingProc ifNotNil:[ self scalingProc isTerminated ifFalse:[ self scalingProc terminate]. self scalingProc: nil].
	self scalingRatio ifNil:[ self scalingRatio: 0 ].
	self mapBackground  ifNotNil:[ 
		self mapMutex critical:[
			self mapBackground offcenter: self mapOffcenter
		]
	].

	proc := [
		self previousScale ifNil:[self previousScale: currentGraphicProjection altitudeInMeters copy]. 
		[self mapBackground notNil and:[self isScalingMap or:[index < 10 ]]] whileTrue: [ 
			| scale | 
			
			self isScalingMap ifTrue:[ 
				ratio := currentGraphicProjection altitudeInMeters / self previousScale.
				index := 1.
			
				self scalingRatio: (ratio - self mapBackground scale x ) * step.
				ratio = 1 ifTrue:[
					self scalingRatio: 0.
					index := 10.
				].
			] ifFalse: [ 
				index := index +1.
				self launchRequestUpdateTilesWorker
			].

			scale := self mapBackground scale x + self scalingRatio.
				
			scaleCenter := self mapProjection projLatLonToCart: scaleCenterAbs .
			prevPositionPixel := (self projCartToPixel: scaleCenter metersByPixel: currentGraphicProjection metersByPixel) copy.
			positionPixel := ((self projCartToPixel: scaleCenter metersByPixel: currentGraphicProjection metersByPixel ) * scale )copy.

			offsetCenter :=  (self mapOffcenter + (positionPixel - prevPositionPixel)) / scale.
				
			self previousCenter: currentGraphicProjection cartesianCenter copy.
			self mapMutex critical: [
				self mapBackground scale: (scale@scale).
				self mapBackground offcenter: offsetCenter.
				self sendRepaintRequest 
			].
	
			50 milliSeconds wait.
			self isScalingMap: false.
		].
		self scalingProc:nil.
		index := 1.
	].

	self scalingProc: (proc forkAt: Processor userSchedulingPriority).
"
	

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
GeoViewMapTilesLayer >> stopTilesWorker [

	self loadingTilesWorker ifNotNil:[
		self loadingTilesWorker isTerminated ifFalse:[ self loadingTilesWorker terminate. self resetMapSurface]
	].

	self loadingTilesWorker: nil.
	
	self loadingBufferWorker ifNotNil:[
		self loadingBufferWorker isTerminated ifFalse:[ self loadingBufferWorker terminate]
	].

	self loadingBufferWorker: nil.
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
GeoViewMapTilesLayer >> tilesProvider [

	^ tilesProvider
]

{ #category : #'API -- tiles' }
GeoViewMapTilesLayer >> tilesProvider: anObject [

	tilesProvider := anObject
]

{ #category : #private }
GeoViewMapTilesLayer >> tilesProviderNoteGText2D [
	"return the default provider note if concerned, in a long time this methods can return a dynamic note depending of the displayed content. the note can change depending level or if a several data provider are mixed in same time"

	self tilesProvider ifNil: [ ^ nil ].
	self tilesProvider haveCopyrightNote ifTrue: [
		^ tilesProviderNoteGText text:
			  self tilesProvider defaultCopyrightNote ].

	^ nil
]

{ #category : #'loading and updating' }
GeoViewMapTilesLayer >> updateMapBackground [ 

	self surfaceMap ifNil: [ ^ self ].

	self mapMutex critical: [
		self mapBackground: self surfaceMap.
		self mapBackground offcenter: self mapOffcenter.
		self mapBackground scale: 1 @ 1.
		self mapBackground position: currentGraphicProjection cartesianCenter.
		self sendRepaintRequest
	]
]

{ #category : #private }
GeoViewMapTilesLayer >> updateModel: aContext [

	super updateModel: aContext.
	self graphicProjection ifNil: [ ^ self ].
	currentGraphicProjection := self graphicProjection copy.
aContext isCenterChanged ifTrue:[ self stopTilesWorker ].
	self requestUpdateTilesWorker ifNotNil:[ self requestUpdateTilesWorker terminate. self requestUpdateTilesWorker: nil].


	self initAndStartMapBuilding.
	"self needToMoveMap: aContext.
	self needToScaleMap: aContext.
	needToReComputeMap := self needToRecomputeMap: aContext.
	self moveMapBackground.
	self scaleMapBackground: aContext.
	needToReComputeMap ifFalse: [ ^self].
	self launchRequestUpdateTilesWorker."
	
]
