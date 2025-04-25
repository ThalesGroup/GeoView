Class {
	#name : #GeoViewCartoTilesLayer,
	#superclass : #AbstractGeoViewBasicLayer,
	#instVars : [
		'loadingTilesWorker',
		'buildBufferWorker',
		'isBufferReady',
		'dictTilesByLevel',
		'isComputingTiles',
		'surfaceCarto',
		'surfaceCartoBuffer',
		'previousCenter',
		'mapMutex',
		'cartoBackground',
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
		'allowSmallMovingWithoutRedraw',
		'mapTilesDirectory',
		'allowSlideMoving'
	],
	#category : #'GeoView-Layers'
}

{ #category : #constants }
GeoViewCartoTilesLayer class >> colorWithoutTile [

	^Color black 
]

{ #category : #constants }
GeoViewCartoTilesLayer class >> prefixType [

	^'r'
]

{ #category : #constants }
GeoViewCartoTilesLayer class >> tilesMapDir [

	^'map'
]

{ #category : #private }
GeoViewCartoTilesLayer >> addedToSceneGraph [

	super addedToSceneGraph.

	currentGraphicProjection := self graphicProjection copy.
	self initAndStartCartoBuilding
]

{ #category : #drawing }
GeoViewCartoTilesLayer >> aeDrawOn: aeCanvas [

	| cairoContext surface extent offcenter scale |
	self cartoBackground ifNil: [ ^ self ].
	self cartoBackground surface ifNil: [ ^ self ].

	self mapMutex critical: [
		self cartoBackground ifNotNil: [ :e |
			scale := self cartoBackground scale.
			e surface ifNotNil: [ :f |
				surface := f.
				
				offcenter := e offcenter copy "* scale".
				surface deviceScale: scale.
				extent := surface extent copy.
				 ] 
		] 
	].

	cairoContext := aeCanvas privateAeCairoContext.
	
	
	cairoContext sourceSurface: surface x: offcenter x  y: offcenter y.
	cairoContext rectangle: (0 @ 0 extent: extent "* scale").
	"cairoContext scaleBy: scale."

	cairoContext fill
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> allowSlideMoving [

	allowSlideMoving ifNil:[ allowSlideMoving := true].
	^allowSlideMoving
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> allowSlideMoving: aBoolean [
 
	allowSlideMoving := aBoolean
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> allowSmallMovingWithoutRedraw [

	allowSmallMovingWithoutRedraw ifNil:[ allowSmallMovingWithoutRedraw := true].
	^allowSmallMovingWithoutRedraw
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> allowSmallMovingWithoutRedraw: aBoolean [
 
	allowSmallMovingWithoutRedraw := aBoolean
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> buildBufferWorker [

	^ buildBufferWorker
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> buildBufferWorker: anObject [

	buildBufferWorker := anObject
]

{ #category : #tiles }
GeoViewCartoTilesLayer >> buildFilenameForXY: aTileXY zoom: aLevel [

	| filename |

	filename := self mapTilesDirectory asFileReference.
	filename exists ifFalse:[^nil].

	filename := filename / aLevel asString.
	filename := filename / aTileXY x asString.
	filename := filename / (aTileXY y asString , '.png').
	^filename
]

{ #category : #'loading and updating' }
GeoViewCartoTilesLayer >> buildVMapLayerTiles: aVMapTilesXY buffer: aLargerVMapTilesXY level: aLevel [
	
	| findAtLeastOneTile vMapServerTiles |
	
	findAtLeastOneTile := false.
	self surfaceCarto ifNil:[^findAtLeastOneTile].
	self surfaceCarto offcenter: self cartoOffcenter.
	self surfaceCarto position: self graphicProjection cartesianCenter.
	
	self buildBufferWorker ifNotNil:[
		self stopBufferWorker.
		self isBufferReady: false.
	].

	findAtLeastOneTile := self loadAndRenderTiles: aVMapTilesXY on: self surfaceCarto offset: self cartoOffcenter negated level: aLevel.
	
	"VMAP Tiles computing completed"
 	self updateMapWith: self surfaceCarto.
	
	vMapServerTiles := self dictTilesByLevel at: aLevel ifAbsent:[nil].
	vMapServerTiles ifNotNil:[
		vMapServerTiles keys size > 9000 ifTrue:[ 
			Transcript show: '[TilesMap] Reset dictionary VMapTiles';cr.
			vMapServerTiles := nil.
			self dictTilesByLevel at: aLevel put: vMapServerTiles. 
		]
	].

	self initBuildBufferWorker: aLargerVMapTilesXY level: aLevel.

	^findAtLeastOneTile
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> cartoBackground [

	^ cartoBackground
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> cartoBackground: anObject [

	^ cartoBackground := anObject
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> cartoOffcenter [

	"^0@0"
	^(-512)@(-512)
]

{ #category : #computing }
GeoViewCartoTilesLayer >> clip: num min: min max: max [

	^(num max: min) min: max
]

{ #category : #'loading and updating' }
GeoViewCartoTilesLayer >> computeGraphicBoundsForTile: aGeoFormTile level: aLevel [

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
GeoViewCartoTilesLayer >> dictTilesByLevel [

	dictTilesByLevel ifNil:[ dictTilesByLevel := Dictionary new].
	^dictTilesByLevel
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> dictTilesByLevel: aDictionary [

	dictTilesByLevel := aDictionary
]

{ #category : #'loading and updating' }
GeoViewCartoTilesLayer >> doBuildBufferThread: aLargerVMapTilesXY level: aLevel [

	self isBufferReady: false.
	"self renderGeoSurface: self surfaceCarto surface on: self surfaceCartoBuffer surface offset: 0@0 scale: self surfaceCarto scale."
	"self surfaceCarto surface writePngTo: ('./testSurface.png' asFileReference)."
	"	self surfaceCartoBuffer surface writePngTo: ('./testBuffer.png' asFileReference)."
	self loadAndRenderTiles: aLargerVMapTilesXY on: self surfaceCartoBuffer offset: 512@512 "((-256)@(-256))""(((256@256) * self surfaceCartoBuffer scale) floor)" level: aLevel.
		self mapMutex critical: [
	self surfaceCarto surface: self surfaceCartoBuffer surface.
	"self surfaceCarto offcenter: self surfaceCartoBuffer offcenter.
	self surfaceCarto position: self surfaceCartoBuffer position."
	self sendRepaintRequest]. 
	
	"self renderGeoSurface: self surfaceCartoBuffer surface on: self surfaceCarto surface offset: 0@0 scale: self surfaceCartoBuffer scale.
	self updateMapWith: self surfaceCarto. "
	"Transcript show: 'buffer ready';cr."
	"self sendRepaintRequest."
	"self surfaceCartoBuffer surface writePngTo: ('./testBuffer2.png' asFileReference)."
	"self surfaceCartoBuffer surface writePngToPathString: 'testSurfaceCartoBuffer.png'."
	self isBufferReady: true.
]

{ #category : #'loading and updating' }
GeoViewCartoTilesLayer >> doLoadingTilesThread [

	| centerPixel level tilesXY tilesXYBuffer findAtLeastOneTile realLevel|

	self scalingProc ifNotNil:[ self scalingProc isActive ifTrue:[^self]].
	self previousCenter: currentGraphicProjection cartesianCenter.
	self previousScale: currentGraphicProjection altitudeInMeters.
	self surfaceCarto offcenter: self cartoOffcenter.
	
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
GeoViewCartoTilesLayer >> getCenterInGeoPoint [

	| center centerGeoPoint |
	center := self graphicProjection cartesianCenter.
	centerGeoPoint := self mapProjection projCartToLatLon: center.
	
	^centerGeoPoint longitudeInDegrees@centerGeoPoint latitudeInDegrees
	

	
]

{ #category : #private }
GeoViewCartoTilesLayer >> getCenterInLatLon [

	| center centerGeoPoint |
	center := self graphicProjection cartesianCenter.
	centerGeoPoint := self mapProjection projCartToLatLon: center.
	
	^centerGeoPoint latitudeInDegrees@centerGeoPoint longitudeInDegrees
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> getCenterInPixel [

	| center centerPixel |
	center := self graphicProjection cartesianCenter.
	centerPixel := self graphicProjection projCartToPixel: center.
	
	^centerPixel
	

	
]

{ #category : #tiles }
GeoViewCartoTilesLayer >> getGeoBoundsFromTileXY: aPt level: aLevel [

	| pt1 pt2 |
	pt1 := self getPixelXYFromTileXY: aPt.
	pt2 := pt1 + (256 @ 256).
	pt1 := self getGeoPointFromPixelXY: pt1 level: aLevel.
	pt2 := self getGeoPointFromPixelXY: pt2 level: aLevel.
	^pt1  corner: pt2
]

{ #category : #'loading and updating' }
GeoViewCartoTilesLayer >> getGeoImageAtTileXY: axyPoint level: aLevel [

	| tm pngRefTile isNoPicture geoImage|
	tm := self getTiledImageFromTileXY: axyPoint level: aLevel.
	pngRefTile := tm image.
	isNoPicture := false.
	
	pngRefTile ifNil:[ isNoPicture := true].
	geoImage := GeoImage new. 
	geoImage position: tm geoBounds center.
	geoImage isNoPicture: isNoPicture.
	geoImage geoBounds: tm geoBounds.
	geoImage tileXY: tm quadKey.
	geoImage pngReference: pngRefTile.
	geoImage level: aLevel.
	^geoImage

	
]

{ #category : #level }
GeoViewCartoTilesLayer >> getGeoPointFromPixelXY: aPt level: aLevel [
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
GeoViewCartoTilesLayer >> getGeoRectanglePointsFromTileXY: aPt level: aLevel [

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
GeoViewCartoTilesLayer >> getGraphicPositionFromGeoPosition: aGeoPoint [
	
	| absCoord cartCoord pos|
	absCoord := AbsoluteCoordinates latitudeInDegrees: aGeoPoint y longitudeInDegrees: aGeoPoint x. 
	cartCoord := self mapProjection projLatLonToCart: absCoord.
	
	pos := self graphicProjection projCartToPixel: cartCoord.
	
	"pos := pos - self getCenterInPixel.
	pos := pos * self graphicProjection metersByPixel.
	pos setX: pos x setY: pos y negated."
	pos := pos + self viewInfos origin.
	
	^pos
]

{ #category : #tiles }
GeoViewCartoTilesLayer >> getImageInCacheFromTileXY: aPt level: aLevel [

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
GeoViewCartoTilesLayer >> getPixelXYFromGeoPoint: aGeoPoint level: aLevel [

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
GeoViewCartoTilesLayer >> getPixelXYFromTileXY: aTilePt [

	| pt |
	pt := 0 @ 0.
	pt setX: (aTilePt x * 256) setY: (aTilePt y * 256).
	^pt
]

{ #category : #computing }
GeoViewCartoTilesLayer >> getTileSurfaceFromGeoImage: aGeoImageTile [

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
GeoViewCartoTilesLayer >> getTileXYFromGeoPoint: aGeoPoint level: aLevel [

	| pt |
	pt := self getPixelXYFromGeoPoint: aGeoPoint level: aLevel.
	pt := self getTileXYFromPixelXY: pt.
	^pt

	
]

{ #category : #level }
GeoViewCartoTilesLayer >> getTileXYFromPixelXY: aPixelPt [

	| pt |
	pt := 0 @ 0.
	pt setX: ((aPixelPt x / 256) asInteger) setY: ((aPixelPt y / 256) asInteger).
	^pt
	
]

{ #category : #tiles }
GeoViewCartoTilesLayer >> getTiledImageFromTileXY: aPt level: aLevel [

	| tileXY img ti |
	
	tileXY := aPt.
	ti := GeoTiledImage new.
	img := self getImageInCacheFromTileXY: aPt level: aLevel.
	img ifNil:[
		ti isNoPicture: true
	] ifNotNil:[
		ti isNoPicture: false.
		ti image: img
	].
	ti quadKey: tileXY.
	ti levelOfDetail: aLevel.
	ti geoBounds: (self getGeoBoundsFromTileXY: tileXY level: aLevel).

	^ti
]

{ #category : #level }
GeoViewCartoTilesLayer >> getTilesLevelForCurrentResolution [

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
GeoViewCartoTilesLayer >> getTilesXYFor: aCenter level: aLevel [
	
	| vMapTilesXY tileQt squareSize vMapTileCenter diff pos maxTiles |	

	vMapTilesXY := OrderedCollection new.
	vMapTileCenter := self getTileXYFromGeoPoint: aCenter level: aLevel.

	"On calcul le nombre de tuile en ligne et en colonne + 2@2 => on ajoute deux tuiles de marge de chaque côtés"
	tileQt := ((self graphicProjection extentInPixels extent / 256) + (2@2)) rounded.

	"on calcule la taille du carré défini par toutes ces tuiles, pour renvoyer un ordre en escargot afin d'afficher d'abord la première tuile au centre puis tout autour en spirale"
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

	"Complément sur les bords"
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

	vMapTilesXY := vMapTilesXY select:[:t | (t x >= 0 and:[t y >= 0]) and:[ t x < maxTiles and:[ t y < maxTiles]]].

	^vMapTilesXY
]

{ #category : #tiles }
GeoViewCartoTilesLayer >> getTilesXYForBuffer: aCenter level: aLevel [
	
	| vMapTilesXYBuffer tileQt  vMapTileCenter x y maxTiles |	

	vMapTilesXYBuffer := OrderedCollection new.
	vMapTileCenter := self getTileXYFromGeoPoint: aCenter level: aLevel.

	tileQt := (((self graphicProjection extentInPixels extent / 256) / 2) + (2@2)) rounded.

	x := tileQt x + 1.
	y := tileQt y + 1.

	0 to: y do:[:j |
		"Bordure à gauche"	
		vMapTilesXYBuffer add: vMapTileCenter  + ((x negated)@j).
		j=0 ifFalse:[ vMapTilesXYBuffer add: vMapTileCenter  + ((x negated)@(j negated))].

		"Bordure à droite"	
		vMapTilesXYBuffer add: vMapTileCenter  + (x@j).
		j=0 ifFalse:[ vMapTilesXYBuffer add: vMapTileCenter  + (x@(j negated))].
	].

	0 to: x do:[:i |
		"Bordure en haut "	
		vMapTilesXYBuffer add: vMapTileCenter  + (i@(y negated)).
		i=0 ifFalse:[ vMapTilesXYBuffer add: vMapTileCenter  + ((i negated)@(y negated))].

		"Bordure en bas"	
		vMapTilesXYBuffer add: vMapTileCenter  + (i@y).
		i=0 ifFalse:[ vMapTilesXYBuffer add: vMapTileCenter  + ((i negated)@y)].
	].


	maxTiles := 2 raisedTo: aLevel.

	vMapTilesXYBuffer := vMapTilesXYBuffer select:[:t | (t x >= 0 and:[t y >= 0]) and:[ t x < maxTiles and:[ t y < maxTiles]]].

	^vMapTilesXYBuffer
]

{ #category : #private }
GeoViewCartoTilesLayer >> initAndStartCartoBuilding [

	self stopWorkers.
	
		self scalingProc ifNotNil:[ self scalingProc isActive ifTrue:[^self]].

	self mapMutex critical:[
		self initSurfaceCarto: currentGraphicProjection extentInPixels extent + (1024 @ 1024).
		self initSurfaceCartoBuffer: currentGraphicProjection extentInPixels extent + (1024 @ 1024).
	].

	self updateMapWith: self surfaceCarto.

	self loadingTilesWorker: ([ self doLoadingTilesThread ]
			 forkAt: Processor systemBackgroundPriority
			 named: 'Map tiles loading')
]

{ #category : #private }
GeoViewCartoTilesLayer >> initBuildBufferWorker: aLargerVMapTilesXY level: aLevel [

	self stopBufferWorker.

	self buildBufferWorker:
		([ self doBuildBufferThread: aLargerVMapTilesXY level: aLevel ]
			 forkAt: Processor systemBackgroundPriority
			 named: 'Map buffer builder')
]

{ #category : #private }
GeoViewCartoTilesLayer >> initSurfaceCarto: anExtent [

	| geoSurface |
	(self surfaceCarto notNil and: [
		 self surfaceCarto surface extent = anExtent ]) ifTrue: [ ^ self ].

	geoSurface := GeoSurface new.
	geoSurface surface: (AeCairoImageSurface extent: anExtent).
	geoSurface offcenter: self cartoOffcenter.
	self surfaceCarto: geoSurface
]

{ #category : #private }
GeoViewCartoTilesLayer >> initSurfaceCartoBuffer: anExtent [

	| geoSurface |
	(self surfaceCartoBuffer notNil and: [
		 self surfaceCartoBuffer surface extent = anExtent ]) ifTrue: [
		^ self ].

	geoSurface := GeoSurface new.
	geoSurface surface: (AeCairoImageSurface extent: anExtent).
	geoSurface offcenter: (-512)@(-512).
	geoSurface isBuffer: true.
	self surfaceCartoBuffer: geoSurface
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> isBufferReady [

	isBufferReady ifNil:[ isBufferReady := false].
	^isBufferReady
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> isBufferReady: aBoolean [

	isBufferReady := aBoolean
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> isComputingTiles [

	isComputingTiles ifNil:[ isComputingTiles := false].
	^isComputingTiles
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> isComputingTiles: aBoolean [

	isComputingTiles := aBoolean
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> isMovingMap [

	isMovingMap ifNil:[isMovingMap := false].
	^isMovingMap
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> isMovingMap: aBoolean [

	isMovingMap := aBoolean 
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> isScalingMap [

	isScalingMap ifNil:[isScalingMap := false].
	^isScalingMap
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> isScalingMap: aBoolean [

	isScalingMap := aBoolean 
]

{ #category : #private }
GeoViewCartoTilesLayer >> launchRequestUpdateTilesWorker [

	self requestUpdateTilesWorker ifNotNil:[ self requestUpdateTilesWorker terminate. self requestUpdateTilesWorker: nil].
	self requestUpdateTilesWorker: ([500 milliSeconds wait. self initAndStartCartoBuilding ]  forkAt: Processor systemBackgroundPriority
			 named: 'Update tiles after delay')

]

{ #category : #'loading and updating' }
GeoViewCartoTilesLayer >> loadAndRenderTiles: aListTilesXY on: aSurface offset: anOffset level: aLevel [

	| index t geoTile  findAtLeastOneTile vMapServerTiles nbTiles tilesXY context|
	
	index := 1.
	findAtLeastOneTile := false.
	aSurface isBuffer ifFalse:[
		context := aSurface surface newContext.
		context sourceColor: self class colorWithoutTile;paint
	].

	vMapServerTiles := self dictTilesByLevel at: aLevel ifAbsent:[nil].
	vMapServerTiles ifNil: [vMapServerTiles := Dictionary new: 10000].
	tilesXY := aListTilesXY copy.
	nbTiles := tilesXY size.

	self flag: 'TODO: Enlever ce delai (qui permet affichage des premieres tuiles)'.
	50 milliSeconds wait.

	[index <= nbTiles and: [ self isComputingTiles]]
		whileTrue: 
			[| tKey isValidTile |
			tKey := tilesXY at: index.
			index := index + 1.
						
				[t := vMapServerTiles at: tKey
								ifAbsentPut: 
									[geoTile := self 
												getGeoImageAtTileXY: tKey
												level: aLevel.
									geoTile].

					self computeGraphicBoundsForTile: t level: aLevel.
					self offcenterGeoPngTile: t offset: anOffset level: aLevel.
					isValidTile := t isNoPicture not and:[ (t graphicBounds origin <= currentGraphicProjection extentInPixels extent) and:[t graphicBounds origin >= currentGraphicProjection extentInPixels origin]].
					findAtLeastOneTile := findAtLeastOneTile or:[ isValidTile ].
				
					self renderTileImage: t on: aSurface surface.
					aSurface isBuffer ifFalse:[ self updateMapWith: aSurface].
				] on:[ Exception ] do:[:ex |
					Transcript show: '[TacplotView] Error on VMapTiles computing :';show: ex printString;cr.
					(Delay forMilliseconds: 1000) wait.
					ex restart]
					
			].
	self dictTilesByLevel at: aLevel put: vMapServerTiles.

	^findAtLeastOneTile

]

{ #category : #accessing }
GeoViewCartoTilesLayer >> loadingTilesWorker [

	^ loadingTilesWorker
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> loadingTilesWorker: anObject [

	loadingTilesWorker := anObject
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> mapMutex [

	mapMutex ifNil: [ mapMutex := Monitor new ].
	^ mapMutex
]

{ #category : #computing }
GeoViewCartoTilesLayer >> mapSize: aLevel [

	^(256 bitShift: aLevel) asInteger
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> mapTilesDirectory [

	mapTilesDirectory ifNil:[ mapTilesDirectory := (FileLocator imageDirectory / self class tilesMapDir / self class prefixType )].
	^mapTilesDirectory
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> mapTilesDirectory: aPath [

	mapTilesDirectory := aPath 
]

{ #category : #private }
GeoViewCartoTilesLayer >> moveCartoBackground [

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
				self cartoBackground offcenter: self cartoBackground offcenter + self movingOffset.
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
GeoViewCartoTilesLayer >> movingOffset [

	^movingOffset
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> movingOffset: aPoint [

	movingOffset := aPoint 
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> movingProc [

	^movingProc
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> movingProc: aProc [

	movingProc := aProc 
]

{ #category : #private }
GeoViewCartoTilesLayer >> needToMoveCarto: aContext [

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
GeoViewCartoTilesLayer >> needToRecomputeCarto: aContext [

	| previousPixel  currentPixel centerOffsetPixel |
	previousPixel := 0@0.
	(self isScalingMap and:[aContext scaleCenterPoint notNil ]) ifTrue:[^false].
	(self scalingProc notNil and: [self scalingProc isActive ])ifTrue:[^false].
	currentGraphicProjection ifNil:[ ^ true ].
	self previousCenter ifNil:[^true].
	
	previousPixel := currentGraphicProjection projCartToPixel: self surfaceCarto position.
	currentPixel := currentGraphicProjection projCartToPixel: (currentGraphicProjection cartesianCenter).
	currentPixel ifNil:[ currentPixel := 0@0 ].
	centerOffsetPixel := (previousPixel - currentPixel) abs.

	"Ignore others processing when only center changed"
	aContext isMapProjectionChange ifFalse:[
		aContext isExtentChanged ifFalse:[
				aContext isResolutionChanged ifFalse:[
						aContext isScaleChanged ifFalse:[ 
							(aContext isCenterChanged and:[ centerOffsetPixel r <= 256 ]) ifTrue:[
								self allowSmallMovingWithoutRedraw ifFalse:[^true].
								^ false
							] 
						].
					].
			].	
	].

	^ true
]

{ #category : #private }
GeoViewCartoTilesLayer >> needToScaleCarto: aContext [

	(aContext isScaleChanged or:[aContext isResolutionChanged]) ifTrue:[
		self isScalingMap: aContext scaleCenterPoint notNil.
		aContext scaleCenterPoint ifNil:[ self launchRequestUpdateTilesWorker].
	]
]

{ #category : #tiles }
GeoViewCartoTilesLayer >> offcenterGeoPngTile: aTile offset: anOffset level: aLevel [

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
GeoViewCartoTilesLayer >> previousCenter [

	^previousCenter

	
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> previousCenter: aCartesianCenter [

	previousCenter := aCartesianCenter

	
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> previousScale [

	^previousScale

	
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> previousScale: aScaleInMeters [

	previousScale := aScaleInMeters

	
]

{ #category : #private }
GeoViewCartoTilesLayer >> projCartToPixel: aCartesianCoordinates metersByPixel: aMetersByPixel [

	| point pixel geoCenter |
	point := aCartesianCoordinates asPoint.
	geoCenter := self graphicProjection cartesianCenter asPoint.
	pixel := ((point x @ point y negated) - (geoCenter x @ geoCenter y negated))
		* aMetersByPixel
		+ self graphicProjection offsetInPixels.

	^ pixel
]

{ #category : #private }
GeoViewCartoTilesLayer >> removedFromSceneGraph [

	super removedFromSceneGraph.
	self stopWorkers
]

{ #category : #rendering }
GeoViewCartoTilesLayer >> renderGeoSurface: aSourceGeoSurface on: aTargetGeoSurface offset: anOffset [

	^self renderGeoSurface: aSourceGeoSurface on: aTargetGeoSurface offset: anOffset scale: 1@1


]

{ #category : #rendering }
GeoViewCartoTilesLayer >> renderGeoSurface: aSourceGeoSurface on: aTargetGeoSurface offset: anOffset scale: aScale [
	
	| centerPoint offset|
	
	offset := anOffset ifNil:[0@0] ifNotNil:[anOffset].

	centerPoint := self graphicProjection projCartToPixel: self graphicProjection cartesianCenter.
	centerPoint := "centerPoint +"(128@128)+ offset + (256@256).
	
	self renderSurface: aSourceGeoSurface on: aTargetGeoSurface scale: aScale centeredAt: centerPoint

	

]

{ #category : #rendering }
GeoViewCartoTilesLayer >> renderSurface: aSurface on: aTargetSurface scale: aXYScale centeredAt: aPoint [
	
	| offset targetContext|
	
	targetContext := aTargetSurface newContext.
	targetContext sourceColor: Color red.
	targetContext translateBy: aPoint.
	targetContext scaleBy: aXYScale.
	offset := 0@0 - (128@128).
	targetContext translateBy: offset.
	targetContext sourceSurface: aSurface x: 0 y: 0.
	targetContext paint.
	
	"targetContext sourceColor: Color green;
		rectangle: (0@0 extent: 256 asPoint);
		stroke.
		
	targetContext sourceColor: Color green;
		fontSize: 40;
		translateBy: 128@128;
		showText: '';
		stroke.
_"
	
]

{ #category : #rendering }
GeoViewCartoTilesLayer >> renderSurface: aSurface on: aTargetSurface scale: aXYScale centeredAt: aPoint tile: aGeoImageTile [
	
	| offset targetContext|
	
	targetContext := aTargetSurface newContext.
	targetContext sourceColor: Color red.
	targetContext translateBy: aPoint.
	targetContext scaleBy: aXYScale.
	offset := 0@0 - (128@128).
	targetContext translateBy: offset.
	targetContext sourceSurface: aSurface x: 0 y: 0.
	targetContext paint.
	
	"POUR DEBUG"
	"targetContext sourceColor: Color green;
		rectangle: (0@0 extent: 256 asPoint);
		stroke.
		
	targetContext sourceColor: Color green;
		fontSize: 30;
		translateBy: 10@128;
		showText: aGeoImageTile tileXY asString, '-', aGeoImageTile level asString;
		stroke."

	
]

{ #category : #rendering }
GeoViewCartoTilesLayer >> renderTileImage: aGeoImageTile on: aSurface [

	|origin corner scale center centerPixel tileSurface|
	
	aGeoImageTile graphicBounds ifNil:[
		origin := self getGraphicPositionFromGeoPosition: aGeoImageTile geoBounds origin.
		corner := self getGraphicPositionFromGeoPosition: aGeoImageTile geoBounds corner
	] ifNotNil:[
		origin := aGeoImageTile graphicBounds origin.
		corner := aGeoImageTile graphicBounds corner
	].

	scale := (corner y - origin y) / 256.
	"Ce facteur sert à agrandir légèrement les tuiles pour gérer l'inter-tuile et éviter d'avoir des lignes noires entre les tuiles"
	scale := scale + ((0.005 * scale) max: 0.01).
	
	center := self graphicProjection cartesianCenter.
	centerPixel := self graphicProjection projCartToPixel: center.
	
	aGeoImageTile offcenter ifNotNil:[ centerPixel := centerPixel + aGeoImageTile offcenter].
	
	tileSurface := self getTileSurfaceFromGeoImage: aGeoImageTile.
	self renderSurface: tileSurface on: aSurface scale: scale@scale centeredAt: centerPixel tile: aGeoImageTile
	



]

{ #category : #accessing }
GeoViewCartoTilesLayer >> requestUpdateTilesWorker [

	^ requestUpdateTilesWorker
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> requestUpdateTilesWorker: anObject [

	requestUpdateTilesWorker := anObject
]

{ #category : #private }
GeoViewCartoTilesLayer >> scaleCartoBackground: aContext [

	|  proc ratio step scaleCenter scaleCenterAbs  offsetCenter positionPixel prevPositionPixel |
	
	step := 0.1.

	self isScalingMap ifFalse:[^self].
		
	aContext scaleCenterPoint ifNil:[^self]. 
	scaleCenterAbs := aContext scaleCenterPoint copy.
	scaleCenterAbs ifNil:[^self].
	self scalingProc ifNotNil:[ self scalingProc isTerminated ifFalse:[ self scalingProc terminate]. self scalingProc: nil].
	self scalingRatio ifNil:[ self scalingRatio: 0 ].
	self cartoBackground  ifNotNil:[ self cartoBackground offcenter: self cartoOffcenter ].

	proc := [
		self previousScale ifNil:[self previousScale: currentGraphicProjection altitudeInMeters copy]. 
		[self cartoBackground notNil and:[self isScalingMap or:[self scalingRatio abs >= (step/2) ]]] whileTrue: [ 
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

				offsetCenter :=  (self cartoOffcenter + (positionPixel - prevPositionPixel)) / scale.
			self mapMutex critical: [
				self cartoBackground scale: (scale@scale).
				self cartoBackground offcenter: offsetCenter.
				self sendRepaintRequest 
			].
			self scalingRatio > 0 ifTrue:[
				self scalingRatio: ((self scalingRatio - step) max: 0).
			] ifFalse:[
				self scalingRatio: ((self scalingRatio + step) min: 0).
			].
	
			50 milliSeconds wait.
			self isScalingMap: false.
		].
		self scalingProc:nil.
	].

	self scalingProc: (proc forkAt: 50"Processor userSchedulingPriority").

	

]

{ #category : #private }
GeoViewCartoTilesLayer >> scaleView [

	| ratio |
	self previousScale ifNotNil: [
		ratio := currentGraphicProjection altitudeInMeters / self previousScale.
		ratio = 1 ifFalse: [
			Transcript show: 'ratio scale:';show: ratio ;cr.
			self mapMutex critical: [ self cartoBackground scale: ratio@ratio. self sendRepaintRequest ]
		]
	].
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> scalingProc [

	^scalingProc
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> scalingProc: aProc [

	scalingProc := aProc 
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> scalingRatio [

	^scalingRatio

	
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> scalingRatio: aRatio [

	scalingRatio := aRatio

	
]

{ #category : #parameters }
GeoViewCartoTilesLayer >> setAllowSlideMoving: aBoolean [
 
	self allowSlideMoving: aBoolean
]

{ #category : #parameters }
GeoViewCartoTilesLayer >> setAllowSmallMovingWithoutRedraw: aBoolean [
 
	self allowSmallMovingWithoutRedraw: aBoolean
]

{ #category : #parameters }
GeoViewCartoTilesLayer >> setMapTilesDirectory: aPath [

	self mapTilesDirectory: aPath
]

{ #category : #scale }
GeoViewCartoTilesLayer >> setScaleFormCarto: aScale [

	self surfaceCarto scale: aScale@aScale 
]

{ #category : #scale }
GeoViewCartoTilesLayer >> setScaleFormCartoBuffer: aScale [

	self surfaceCartoBuffer scale: aScale@aScale 
]

{ #category : #computing }
GeoViewCartoTilesLayer >> sinLatitude: aLatitude [

	^(aLatitude * (Float pi / 180)) sin
]

{ #category : #private }
GeoViewCartoTilesLayer >> stopBufferWorker [

	self buildBufferWorker ifNotNil:[
		self buildBufferWorker isTerminated ifFalse:[ self buildBufferWorker terminate].
	].

	self buildBufferWorker: nil.

]

{ #category : #private }
GeoViewCartoTilesLayer >> stopTilesWorker [

	self loadingTilesWorker ifNotNil:[
		self loadingTilesWorker isTerminated ifFalse:[ self loadingTilesWorker terminate]
	].

	self loadingTilesWorker: nil.
]

{ #category : #private }
GeoViewCartoTilesLayer >> stopWorkers [

	self stopTilesWorker.
	self stopBufferWorker
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> surfaceCarto [

	^ surfaceCarto
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> surfaceCarto: aCairoSurface [

	surfaceCarto := aCairoSurface
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> surfaceCartoBuffer [

	^ surfaceCartoBuffer
]

{ #category : #accessing }
GeoViewCartoTilesLayer >> surfaceCartoBuffer: aCairoSurface [

	surfaceCartoBuffer := aCairoSurface
]

{ #category : #tiles }
GeoViewCartoTilesLayer >> tileNumberForLat: aLat long: aLong zoom: aZoomLevel [
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
GeoViewCartoTilesLayer >> updateMapWith: aGeoImage [

	aGeoImage ifNil: [ ^ self ].

	self scalingProc ifNotNil:[ self scalingProc isActive ifTrue:[^self]].

	self mapMutex critical: [
		self cartoBackground: aGeoImage.
		self cartoBackground offcenter: self cartoOffcenter.
		self cartoBackground scale: 1 @ 1.
		self cartoBackground position: currentGraphicProjection cartesianCenter.
		self sendRepaintRequest 
	]
]

{ #category : #private }
GeoViewCartoTilesLayer >> updateModel: aContext [

	| needToReComputeCarto |
	super updateModel: aContext.
	self graphicProjection ifNil: [ ^ self ].
	currentGraphicProjection := self graphicProjection copy.

	self requestUpdateTilesWorker ifNotNil:[ self requestUpdateTilesWorker terminate. self requestUpdateTilesWorker: nil].

	self needToMoveCarto: aContext.
	self needToScaleCarto: aContext.
	needToReComputeCarto := self needToRecomputeCarto: aContext.
	self moveCartoBackground.
	self scaleCartoBackground: aContext.
	needToReComputeCarto ifFalse: [ ^self].
	self isMovingMap ifFalse:[
		self initAndStartCartoBuilding
	] ifTrue: [ self launchRequestUpdateTilesWorker ]
	
]
