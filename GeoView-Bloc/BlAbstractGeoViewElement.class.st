"
I am an abstract BlElement which contains GeoViewWidget behavior. Not possible to use directly, to use a GeoViewWidget select a subclass element with the targeted backend.
"
Class {
	#name : #BlAbstractGeoViewElement,
	#superclass : #BlElement,
	#traits : 'TGeoViewWidget',
	#classTraits : 'TGeoViewWidget classTrait',
	#instVars : [
		'layers',
		'displayToGraphicProjection',
		'isMarkedForSortDatas',
		'mapProjection'
	],
	#category : #'GeoView-Bloc-Core'
}

{ #category : #'API -- coordinates transformations' }
BlAbstractGeoViewElement >> absoluteCoordinatesFromLocalPoint: aLocalPoint [

	| cartesianCoordinates absoluteCoordinates projection |
	projection := self mapProjection.
	projection ifNil: [ ^ nil ].

	cartesianCoordinates := self displayToGraphicProjection
		                        projPixelToCart: aLocalPoint.
	absoluteCoordinates := projection projCartToLatLon:
		                       cartesianCoordinates.
	^ absoluteCoordinates
]

{ #category : #'API -- layers management' }
BlAbstractGeoViewElement >> addLayer: aLayer [
	
	(self layers includes: aLayer) ifTrue: [ ^ self ].
	self configureLayer: aLayer.
	self layers add: aLayer
]

{ #category : #'API -- objects management' }
BlAbstractGeoViewElement >> addObject: anUserObject [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e addObject: anUserObject ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlAbstractGeoViewElement >> addObjects: anUserObjectList [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e addObjects: anUserObjectList ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #private }
BlAbstractGeoViewElement >> configureLayer: aLayer [
	
	"Setup the map projection (from a cartographic point of view) of the layer"
	aLayer displayModel projection: self mapProjection.
	
	"Setup the graphic projection (from a device point of view) of the layer"
	aLayer graphicModel projection: self displayToGraphicProjection.
	
	"add Alexandrie process datas"
	aLayer graphicModel setProcessData: DCompositeShapeGeoViewProcessData new for: SmockDCompositeShape.
	aLayer graphicModel setProcessData: DSymbolGeoViewProcessData new for: SmockDSymbol.
	aLayer graphicModel setProcessData: DCircleGeoViewProcessData new for: SmockDCircle.
	aLayer graphicModel setProcessData: DTextGeoViewProcessData new for: SmockDText.
	aLayer graphicModel setProcessData: DPolygonGeoViewProcessData new for: SmockDPolygon.
	aLayer graphicModel setProcessData: DPolylineGeoViewProcessData new for: SmockDPolyline.

	"specify default process data"
	"aLayer displayToGraphicModel defaultProcessData: DShapeAeProcessData new."
	
	self flag:'supprimer et mettre un event'.
	aLayer whenProcessDatasChangedDo: [ :e | self layerHasBeenUpdated: e ].
]

{ #category : #accessing }
BlAbstractGeoViewElement >> displayToGraphicProjection [

	^ displayToGraphicProjection
]

{ #category : #accessing }
BlAbstractGeoViewElement >> displayToGraphicProjection: anObject [

	| extent |
	displayToGraphicProjection := anObject.
	displayToGraphicProjection ifNil: [ ^ self ].
	
	extent := self getBounds extent.
	displayToGraphicProjection offsetInPixels: extent / 2.
	displayToGraphicProjection updateResolution: extent.
	self updateGraphicModel
]

{ #category : #private }
BlAbstractGeoViewElement >> enqueueBlockAsTask: aBlockClosure [

	| task |
	task := BlTaskAction new.
	task action: aBlockClosure.
	self enqueueTask: task
]

{ #category : #'API -- size' }
BlAbstractGeoViewElement >> getBounds [

	^ self bounds
]

{ #category : #'API -- size' }
BlAbstractGeoViewElement >> getExtent [
	
	^ self extent
]

{ #category : #'API -- layers management' }
BlAbstractGeoViewElement >> getLayer: aKey [
	self explicitRequirement
]

{ #category : #'API -- layers management' }
BlAbstractGeoViewElement >> getLayers [
	
	^ self layers
]

{ #category : #'API -- coordinates transformations' }
BlAbstractGeoViewElement >> globalPointFromLocalPoint: aLocalPoint [

	aLocalPoint ifNil: [ ^ nil ].
	^ self localPointToGlobal: aLocalPoint
]

{ #category : #'API -- objects management' }
BlAbstractGeoViewElement >> haveObjectIndex: anIndex [
	"Pay attention before using it because graphical model is out of sync real user model due to usage of BlTask (asynchronous)"

	^ self layers anySatisfy: [ :l | l haveObjectIndex: anIndex ]
]

{ #category : #initialization }
BlAbstractGeoViewElement >> initialize [

	super initialize.

	self mapProjection: GeoViewMercatorProjection new.
	self background: Color black.
	self displayToGraphicProjection: GeoView2DProjection new.
	self initializeEventHandlers.
]

{ #category : #initialization }
BlAbstractGeoViewElement >> initializeEventHandlers [

	self addEventHandler: (BlEventHandler
			 on: BlElementExtentChangedEvent
			 do: [ :e | self processExtentChangedEvent: e ])
]

{ #category : #accessing }
BlAbstractGeoViewElement >> isMarkedForSortDatas [

	^ isMarkedForSortDatas ifNil: [ isMarkedForSortDatas := false ]
]

{ #category : #private }
BlAbstractGeoViewElement >> layerHasBeenUpdated: aLayer [

	
]

{ #category : #accessing }
BlAbstractGeoViewElement >> layers [

	^ layers ifNil: [ layers := OrderedCollection new ]
]

{ #category : #'API -- coordinates transformations' }
BlAbstractGeoViewElement >> localPointFromAbsoluteCoordinates: anAbsoluteCoordinates [

	| projection |
	projection := self mapProjection.
	projection ifNil: [ ^ nil ].

	^ self displayToGraphicProjection projCartToPixel:
		  (projection projLatLonToCart: anAbsoluteCoordinates)
]

{ #category : #'API -- coordinates transformations' }
BlAbstractGeoViewElement >> localPointFromGlobalPoint: aGlobalPoint [

	^ self globalPointToLocal: aGlobalPoint
]

{ #category : #'API -- map projection' }
BlAbstractGeoViewElement >> mapProjection [
	"Return the map projection of the object: Mercator, etc."

	^ mapProjection
]

{ #category : #'API -- map projection' }
BlAbstractGeoViewElement >> mapProjection: aMapProjection [
	"Setup the map projection of the object: Mercator, etc."

	mapProjection := aMapProjection
]

{ #category : #private }
BlAbstractGeoViewElement >> processExtentChangedEvent: anEvent [

	| extent |
	extent := anEvent source extent ifNil:[ ^ self ].
	
	"configure view projection"
	self displayToGraphicProjection offsetInPixels: extent / 2.
	self displayToGraphicProjection updateResolution: extent.

	self updateGraphicModel
]

{ #category : #'API -- layers management' }
BlAbstractGeoViewElement >> removeLayer: aLayer [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
BlAbstractGeoViewElement >> removeObject: anUserObject [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e removeObject: anUserObject ].
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlAbstractGeoViewElement >> removeObjects: anUserObjectList [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e removeObjects: anUserObjectList ].
		self requestRepaint ]
]

{ #category : #private }
BlAbstractGeoViewElement >> requestRepaint [

	self invalidate.
]

{ #category : #private }
BlAbstractGeoViewElement >> requestSortDatas [

	isMarkedForSortDatas := true.
]

{ #category : #'API -- selection' }
BlAbstractGeoViewElement >> selectedObjectIndexes: anIndexList [

	self enqueueBlockAsTask: [
		self layers do: [ :l | l updateState: #selected withIndexes: anIndexList ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #'API -- drawing' }
BlAbstractGeoViewElement >> updateGraphicModel [
	"Update the graphic model with the Display model"

	self enqueueBlockAsTask: [
		self layers do: [ :e | e updateGraphicModel ].
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlAbstractGeoViewElement >> updateObject: anUserObject [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e updateObject: anUserObject ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlAbstractGeoViewElement >> updateObjects: anUserObjectList [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e updateObjects: anUserObjectList ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #private }
BlAbstractGeoViewElement >> updateState: aStateSymbol withIndexes: aKeyList [
	
	self enqueueBlockAsTask: [ 
		self layers do: [ :l | l updateState: aStateSymbol withIndexes: aKeyList ].
		self requestSortDatas.
		self requestRepaint
	]
]
