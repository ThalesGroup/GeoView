"
I am trait for geoplot view
"
Trait {
	#name : #TGeoViewWidget,
	#instVars : [
		'geoCenter',
		'scaleFactor',
		'maxScaleInMeters',
		'minScaleInMeters',
		'scaleInMeters',
		'objectIndexAccessor'
	],
	#traits : 'TGeoViewHandleObjects',
	#classTraits : 'TGeoViewHandleObjects classTrait',
	#category : #'GeoView-Core'
}

{ #category : #'API -- coordinates transformations' }
TGeoViewWidget >> absoluteCoordinatesFromGlobalPoint: aGlobalPoint [

	| localPoint |
	localPoint := self localPointFromGlobalPoint: aGlobalPoint.
	^ self absoluteCoordinatesFromLocalPoint: localPoint
]

{ #category : #'API -- coordinates transformations' }
TGeoViewWidget >> absoluteCoordinatesFromLocalPoint: aLocalPoint [

	self explicitRequirement 
]

{ #category : #'API -- layers management' }
TGeoViewWidget >> addLayer: aLayer [

	self explicitRequirement
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> centerOnGlobalPoint: aGlobalPoint [
	"Center the map on a global point"
	| absoluteCoordinates |
	absoluteCoordinates := self absoluteCoordinatesFromGlobalPoint: aGlobalPoint.
	self geoCenter: absoluteCoordinates.
]

{ #category : #private }
TGeoViewWidget >> evaluateScale: aNumberInMeters [

	aNumberInMeters < self minScaleInMeters ifTrue: [ ^ self minScaleInMeters ].
	aNumberInMeters > self maxScaleInMeters ifTrue: [ ^ self maxScaleInMeters ].
	^ aNumberInMeters
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> geoCenter [

	geoCenter ifNil: [ geoCenter := AbsoluteCoordinates zero ].
	^ geoCenter
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> geoCenter: anAbsoluteCoordinates [

	geoCenter := anAbsoluteCoordinates copy
]

{ #category : #'API -- layers management' }
TGeoViewWidget >> getLayer: aKey [

	| layer |
	layer := self view getLayers
		         detect: [ :l | l name = aKey ]
		         ifNone: [ nil ].
	^ layer
]

{ #category : #'API -- layers management' }
TGeoViewWidget >> getLayers [

	self explicitRequirement
]

{ #category : #'API -- coordinates transformations' }
TGeoViewWidget >> globalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [

	| localPoint |
	localPoint := self localPointFromAbsoluteCoordinates:
		              anAbsoluteCoordinates.
	^ self globalPointFromLocalPoint: localPoint
]

{ #category : #'API -- coordinates transformations' }
TGeoViewWidget >> globalPointFromLocalPoint: aLocalPoint [

	self explicitRequirement 
]

{ #category : #'API -- coordinates transformations' }
TGeoViewWidget >> localPointFromAbsoluteCoordinates: anAbsoluteCoordinates [

	self explicitRequirement 
]

{ #category : #'API -- coordinates transformations' }
TGeoViewWidget >> localPointFromGlobalPoint: aGlobalPoint [

	self explicitRequirement 
]

{ #category : #'API -- map projection' }
TGeoViewWidget >> mapProjection [
	"Return the map projection of the object: Mercator, etc."

	self explicitRequirement
]

{ #category : #'API -- map projection' }
TGeoViewWidget >> mapProjection: aMapProjection [
	"Setup the map projection of the object: Mercator, etc."

	self explicitRequirement
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> maxScaleInMeters [

	^ maxScaleInMeters ifNil: [ maxScaleInMeters := 1.5171584e7 ]
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> maxScaleInMeters: anObject [

	maxScaleInMeters := anObject
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> minScaleInMeters [

	^ minScaleInMeters ifNil: [ minScaleInMeters := 1852.0 ]
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> minScaleInMeters: anObject [

	minScaleInMeters := anObject
]

{ #category : #'API -- objects parameters' }
TGeoViewWidget >> objectIndexAccessor [

	^ objectIndexAccessor ifNil: [ objectIndexAccessor := #key ]
]

{ #category : #'API -- objects parameters' }
TGeoViewWidget >> objectIndexAccessor: aSymbol [

	objectIndexAccessor := aSymbol
]

{ #category : #'API -- picking' }
TGeoViewWidget >> pickAt: aGlobalPoint [
	"Return all objects under a global point"

	^ self pickAt: aGlobalPoint radius: 0
]

{ #category : #'API -- picking' }
TGeoViewWidget >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"Return all objects under a global point inside a radius in pixels"

	| pickingResult localPoint absoluteCoordinates radius |
	absoluteCoordinates := (self absoluteCoordinatesFromGlobalPoint: aGlobalPoint) ifNil:[ ^ nil ].
	localPoint := (self localPointFromGlobalPoint: aGlobalPoint) ifNil:[ ^ nil ].
	radius := aRadiusInPixels ifNil:[ 0 ].

	"create picking result"
	pickingResult := GeoViewPickingResult new
		timestamp: DateAndTime now;
		globalPoint: aGlobalPoint;
		localPoint: localPoint;
		cartesianCoordinates: (self mapProjection projLatLonToCart: absoluteCoordinates);
		absoluteCoordinates: absoluteCoordinates;
		radiusInPixels: radius;
		yourself.

	^ pickingResult 
]

{ #category : #'API -- layers management' }
TGeoViewWidget >> removeAllLayers [

	| layers |
	layers := self view getLayers.
	layers copy do: [ :l | self removeLayer: l ].
	^ layers
]

{ #category : #'API -- layers management' }
TGeoViewWidget >> removeLayer: aLayer [

	self explicitRequirement
]

{ #category : #'API -- drawing' }
TGeoViewWidget >> requestRepaint [
	self explicitRequirement
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> scaleDown [

	self scaleInMeters: self scaleInMeters * self scaleFactor
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> scaleFactor [

	^ scaleFactor ifNil: [ scaleFactor := 2 ]
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> scaleFactor: aNumber [

	scaleFactor := aNumber
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> scaleInMeters [

	^ scaleInMeters ifNil: [ scaleInMeters := 1.4816e7 ]
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> scaleInMeters: aNumber [

	| scale |
	scale := self evaluateScale: aNumber.
	scaleInMeters := scale
]

{ #category : #'API -- scale and center' }
TGeoViewWidget >> scaleUp [

	self scaleInMeters: self scaleInMeters / self scaleFactor
]

{ #category : #'API -- selection' }
TGeoViewWidget >> selectedObjectIndexes: aCollection [
	self explicitRequirement
]

{ #category : #'API -- drawing' }
TGeoViewWidget >> updateGraphicModel [
	self explicitRequirement
]
