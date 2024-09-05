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
		'mapProjection',
		'interactionsStrategy'
	],
	#category : #'GeoView-Bloc-Core'
}

{ #category : #testing }
BlAbstractGeoViewElement class >> isAbstract [

	^ self = BlAbstractGeoViewElement
]

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
	
	| geoViewEvent |
	(self layers includes: aLayer) ifTrue: [ ^ self ].
	self configureLayer: aLayer.
	self layers add: aLayer.
	
	"Send layer added event"
	geoViewEvent := GeoViewLayerAddedEvent new.
	geoViewEvent layerName: aLayer name.
	self dispatchEvent: geoViewEvent
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

	(anUserObjectList isNil or: [ anUserObjectList isEmpty ]) ifTrue: [ ^ self ].

	self enqueueBlockAsTask: [
		self layers do: [ :e | e addObjects: anUserObjectList ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #private }
BlAbstractGeoViewElement >> configureLayer: aLayer [
	
	aLayer haveGeoObjects ifFalse:[ ^ self ].
	
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
	
	"notify when process datas changed internaly"
	aLayer announcer when: GeoViewLayerProcessDataChanged send: #layerProcessDataChanged: to: self.
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
	
	extent := self extent.
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

{ #category : #'API -- scale and center' }
BlAbstractGeoViewElement >> geoCenter: anAbsoluteCoordinates [

	| cartesianCoordinates geoViewEvent |
	geoCenter := anAbsoluteCoordinates copy.

	cartesianCoordinates := self mapProjection projLatLonToCart: self geoCenter.
	self displayToGraphicProjection cartesianCenter: cartesianCoordinates.
	self updateGraphicModel.

	"Send center event"
	geoViewEvent := GeoViewCenterChangedEvent new.
	geoViewEvent absoluteCoordinates: anAbsoluteCoordinates.
	self dispatchEvent: geoViewEvent
]

{ #category : #'API -- layers management' }
BlAbstractGeoViewElement >> getLayer: aKey [

	| layer |
	layer := self getLayers
		         detect: [ :l | l name = aKey ]
		         ifNone: [ nil ].
	^ layer
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

	"Add listeners to process Bloc UI events interactions"
	self setInteractionsStrategy: self newInteractionsStrategy.

	"Add listener to compute things when extents changed"
	self addEventHandler: (BlEventHandler
			 on: BlElementExtentChangedEvent
			 do: [ :e | self processExtentChangedEvent: e ])
]

{ #category : #'strategy management' }
BlAbstractGeoViewElement >> interactionsStrategy [

	^ interactionsStrategy
]

{ #category : #accessing }
BlAbstractGeoViewElement >> isMarkedForSortDatas [

	^ isMarkedForSortDatas ifNil: [ isMarkedForSortDatas := false ]
]

{ #category : #private }
BlAbstractGeoViewElement >> layerProcessDataChanged: anEvent [

	"Send scale event"
	| geoViewEvent |
	geoViewEvent := GeoViewLayerProcessDataChanged new.
	geoViewEvent layerName: anEvent layerName.
	self dispatchEvent: geoViewEvent
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

	| geoViewEvent |
	aMapProjection ~= mapProjection ifFalse:[ ^ self ].
	mapProjection := aMapProjection copy.
	
	self getLayers do:[ :l | l displayModel projection: self mapProjection ].
	self updateGraphicModel.
	
	"Send map projection changed event"
	geoViewEvent := GeoViewMapProjectionChangedEvent new.
	geoViewEvent projection: aMapProjection.
	self dispatchEvent: geoViewEvent
]

{ #category : #'strategy management' }
BlAbstractGeoViewElement >> newInteractionsStrategy [

	^ GeoViewDefaultInteractionsStrategy new
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

{ #category : #'strategy management' }
BlAbstractGeoViewElement >> removeInteractionsStrategy [

	interactionsStrategy ifNil:[ ^ self ].
	self removeEventHandler: interactionsStrategy.
	interactionsStrategy := nil.
]

{ #category : #'API -- layers management' }
BlAbstractGeoViewElement >> removeLayer: aLayer [
	
	| geoViewEvent |
	self flag:'todo'.
	
	"Send layer added event"
	geoViewEvent := GeoViewLayerRemovedEvent new.
	geoViewEvent layerName: aLayer name.
	self dispatchEvent: geoViewEvent
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

{ #category : #'API -- scale and center' }
BlAbstractGeoViewElement >> scaleInMeters: aNumber [

	| scale geoViewEvent |
	scale := self evaluateScale: aNumber.
	scaleInMeters := scale.
	
	self displayToGraphicProjection altitudeInMeters: self scaleInMeters.
	self displayToGraphicProjection updateResolution: self extent.
	self updateGraphicModel.
	
	"Send scale event"
	geoViewEvent := GeoViewScaleChangedEvent new.
	geoViewEvent scaleInMeters: self scaleInMeters.
	self dispatchEvent: geoViewEvent.
]

{ #category : #'API -- selection' }
BlAbstractGeoViewElement >> selectedObjectIndexes: anIndexList [

	self enqueueBlockAsTask: [
		self layers do: [ :l | l updateState: #selected withIndexes: anIndexList ].
		self requestSortDatas.
		self requestRepaint ]
]

{ #category : #'strategy management' }
BlAbstractGeoViewElement >> setInteractionsStrategy: aBlEventListener [

	self removeInteractionsStrategy.

	aBlEventListener ifNil:[ ^ self ].
	interactionsStrategy := aBlEventListener.
	self addEventHandler: aBlEventListener.
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
