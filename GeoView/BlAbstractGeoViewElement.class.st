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
		'viewInfos',
		'interactionsStrategy'
	],
	#category : #'GeoView-Bloc'
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

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveGeoObjects ifTrue:[ e addObject: anUserObject ] ].
		self internalSortDatas ]
]

{ #category : #'API -- objects management' }
BlAbstractGeoViewElement >> addObjects: anUserObjectList [

	(anUserObjectList isNil or: [ anUserObjectList isEmpty ]) ifTrue: [ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveGeoObjects ifTrue:[ e addObjects: anUserObjectList ] ].
		self internalSortDatas ]
]

{ #category : #private }
BlAbstractGeoViewElement >> configureGraphicModelForLayer: aLayer [
	
	| graphicModel |
	graphicModel := aLayer graphicModel.
	
	"add Alexandrie process datas if not already here"	
	(graphicModel getProcessDataForClass: SmockDCompositeShape) ifNil:[
		graphicModel setProcessData: DCompositeShapeGeoViewProcessData new forClass: SmockDCompositeShape.
	].
	(graphicModel getProcessDataForClass: SmockDSymbol) ifNil:[
		graphicModel setProcessData: DSymbolGeoViewProcessData new forClass: SmockDSymbol.
	].
	(graphicModel getProcessDataForClass: SmockDCircle) ifNil:[
		graphicModel setProcessData: DCircleGeoViewProcessData new forClass: SmockDCircle.
	].
	(graphicModel getProcessDataForClass: SmockDText) ifNil:[
		graphicModel setProcessData: DTextGeoViewProcessData new forClass: SmockDText.
	].
	(graphicModel getProcessDataForClass: SmockDPolygon) ifNil:[
		graphicModel setProcessData: DPolygonGeoViewProcessData new forClass: SmockDPolygon.
	].
	(graphicModel getProcessDataForClass: SmockDPolyline) ifNil:[
		graphicModel setProcessData: DPolylineGeoViewProcessData new forClass: SmockDPolyline.
	].
	(graphicModel getProcessDataForClass: SmockDSegment) ifNil:[
		graphicModel setProcessData: DSegmentGeoViewProcessData new forClass: SmockDSegment.
	].

	"specify default process data"
	"aLayer displayToGraphicModel defaultProcessData: DShapeAeProcessData new."
]

{ #category : #private }
BlAbstractGeoViewElement >> configureLayer: aLayer [
	
	aLayer viewInfos: self viewInfos.
	
	"Setup the map projection (from a cartographic point of view) of the layer"
	aLayer mapProjection: self mapProjection.
	
	"Setup the graphic projection (from a device point of view) of the layer"
	aLayer graphicProjection: self displayToGraphicProjection.
	aLayer announcer when: GeoViewLayerRepaintRequest send: #layerNeedToBeRepaint: to: self.

	aLayer haveGraphicModel ifFalse:[ ^ self ].
	self configureGraphicModelForLayer: aLayer.	

	aLayer haveGeoObjects ifFalse:[ ^ self ].
	aLayer displayModel indexAccessor: self objectIndexAccessor.
	aLayer announcer when: GeoViewGeoObjectLayerProcessDataChanged send: #layerProcessDataChanged: to: self
]

{ #category : #'private - picking' }
BlAbstractGeoViewElement >> createPickingResultAt: aGlobalPoint [

	| pickingResult absoluteCoordinates localPoint |
	pickingResult := GeoViewPickingResult new
		                 timestamp: DateAndTime now;
		                 yourself.

	aGlobalPoint ifNil:[ ^ pickingResult ].
	absoluteCoordinates := (self absoluteCoordinatesFromGlobalPoint: aGlobalPoint) ifNil:[ ^ pickingResult ].
	localPoint := (self localPointFromGlobalPoint: aGlobalPoint) ifNil:[ ^ pickingResult ].
	
	pickingResult 
		globalPoint: aGlobalPoint;
		localPoint: localPoint;
		absoluteCoordinates: absoluteCoordinates;
		cartesianCoordinates: (self mapProjection projLatLonToCart: absoluteCoordinates).
	
	^ pickingResult
]

{ #category : #accessing }
BlAbstractGeoViewElement >> displayToGraphicProjection [

	^ displayToGraphicProjection
]

{ #category : #accessing }
BlAbstractGeoViewElement >> displayToGraphicProjection: aGeoView2DProjection [

	displayToGraphicProjection := aGeoView2DProjection.
	displayToGraphicProjection ifNil: [ ^ self ].
	
	"change projection to layers"
	self layers do:[ :l | l graphicProjection: displayToGraphicProjection ].
	
	self updateDisplayToGraphicProjection
]

{ #category : #'private - picking' }
BlAbstractGeoViewElement >> doPicking: aPickingResult [
	"Collect all picked elements"

	self getLayers do: [ :l | l isVisible ifTrue: [ l populatePickingResult: aPickingResult ] ]
]

{ #category : #private }
BlAbstractGeoViewElement >> enqueueBlockAsTaskAndRequestRepaint: aBlockClosure [

	| task |
	task := BlTaskAction new.
	task action: aBlockClosure.
	self enqueueTask: task.
	
	task := BlTaskAction new.
	task action: [ self requestRepaint ].
	self enqueueTask: task
]

{ #category : #'API -- scale and center' }
BlAbstractGeoViewElement >> geoCenter: anAbsoluteCoordinates [

	| cartesianCoordinates geoViewEvent |
	
	geoCenter = anAbsoluteCoordinates ifTrue:[ ^ self ].
	
	geoCenter := anAbsoluteCoordinates copy.

	cartesianCoordinates := self mapProjection projLatLonToCart: geoCenter.
	self displayToGraphicProjection cartesianCenter: cartesianCoordinates.
	self updateModel.

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

{ #category : #'API -- dshapes' }
BlAbstractGeoViewElement >> haveObjectIndex: anIndex [
	"Pay attention before using it because graphical model is out of sync real user model due to usage of BlTask (asynchronous)"

	anIndex ifNil:[ ^ nil ].

	^ self layers anySatisfy: [ :e | e haveGeoObjects ifTrue:[ e haveObjectIndex: anIndex ] ]
]

{ #category : #initialization }
BlAbstractGeoViewElement >> initialize [

	super initialize.
	
	self mapProjection: GeoViewMercatorProjection new.
	self displayToGraphicProjection: GeoView2DProjection new.
	self background: Color black.
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

{ #category : #initialization }
BlAbstractGeoViewElement >> initializeViewInfos [

	| vi |
	vi := GeoViewInfos new.
	self viewInfos: vi
]

{ #category : #'strategy management' }
BlAbstractGeoViewElement >> interactionsStrategy [

	^ interactionsStrategy
]

{ #category : #private }
BlAbstractGeoViewElement >> internalSortDatas [

	self isMarkedForSortDatas ifTrue: [ ^ self ].
	isMarkedForSortDatas := true.
	self layers do: [ :l | l haveGraphicModel ifTrue: [ l sortDatas ] ]
]

{ #category : #accessing }
BlAbstractGeoViewElement >> isMarkedForSortDatas [

	^ isMarkedForSortDatas ifNil: [ isMarkedForSortDatas := false ]
]

{ #category : #private }
BlAbstractGeoViewElement >> layerNeedToBeRepaint: anEvent [

	self requestRepaint 
]

{ #category : #private }
BlAbstractGeoViewElement >> layerProcessDataChanged: anEvent [

	"Send scale event"
	| geoViewEvent |
	geoViewEvent := GeoViewGeoObjectLayerProcessDataChanged new.
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
	self updateModel.
	
	"Send map projection changed event"
	geoViewEvent := GeoViewMapProjectionChangedEvent new.
	geoViewEvent projection: aMapProjection.
	self dispatchEvent: geoViewEvent
]

{ #category : #'strategy management' }
BlAbstractGeoViewElement >> newInteractionsStrategy [

	^ GeoViewDefaultInteractionsStrategy new
]

{ #category : #'API -- picking' }
BlAbstractGeoViewElement >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"Return all objects under a global point inside a radius in pixels"

	| pickingResult |
	pickingResult := self createPickingResultAt: aGlobalPoint.
	self preConfigurePickingResult: pickingResult radius: aRadiusInPixels.
	self doPicking: pickingResult.
	self postConfigurePickingResult: pickingResult radius: aRadiusInPixels.

	^ pickingResult
]

{ #category : #'private - picking' }
BlAbstractGeoViewElement >> postConfigurePickingResult: aPickingResult radius: aRadiusInPixels [
	"do nothing"
]

{ #category : #'private - picking' }
BlAbstractGeoViewElement >> preConfigurePickingResult: aPickingResult radius: aRadiusInPixels [
	"do nothing"

	| radius |
	radius := aRadiusInPixels ifNil: [ 0 ].
	aPickingResult radiusInPixels: radius
]

{ #category : #private }
BlAbstractGeoViewElement >> processExtentChangedEvent: anEvent [

	self updateViewInfos.
	self updateDisplayToGraphicProjection
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
	(self layers includes: aLayer) ifFalse: [ ^ self ].
	self unconfigureLayer: aLayer.
	self layers remove: aLayer.
	
	"Send layer added event"
	geoViewEvent := GeoViewLayerRemovedEvent new.
	geoViewEvent layerName: aLayer name.
	self dispatchEvent: geoViewEvent
]

{ #category : #'API -- dshapes' }
BlAbstractGeoViewElement >> removeObject: anUserObject [

	anUserObject ifNil:[ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveGeoObjects ifTrue:[ e removeObject: anUserObject ] ].
		self internalSortDatas ]
]

{ #category : #'API -- dshapes' }
BlAbstractGeoViewElement >> removeObjects: anUserObjectList [

	anUserObjectList ifNil:[ ^ self ].
	anUserObjectList ifEmpty:[ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveGeoObjects ifTrue:[ e removeObjects: anUserObjectList ] ].
		self internalSortDatas ]
]

{ #category : #private }
BlAbstractGeoViewElement >> requestRepaint [

	self invalidate.
]

{ #category : #'API -- scale and center' }
BlAbstractGeoViewElement >> scaleInMeters: aNumber [

	| scale geoViewEvent |
	scale := self evaluateScale: aNumber.
	scaleInMeters := scale.
	
	self displayToGraphicProjection altitudeInMeters: self scaleInMeters.
	self displayToGraphicProjection updateResolution: self extent.
	self updateModel.
	
	"Send scale event"
	geoViewEvent := GeoViewScaleChangedEvent new.
	geoViewEvent scaleInMeters: self scaleInMeters.
	self dispatchEvent: geoViewEvent.
]

{ #category : #'API -- selection' }
BlAbstractGeoViewElement >> selectedObjectIndexes: anIndexList [

	anIndexList ifNil:[ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :l | l haveGeoObjects ifTrue:[ l updateState: #selected withIndexes: anIndexList ] ].
		self internalSortDatas ]
]

{ #category : #'strategy management' }
BlAbstractGeoViewElement >> setInteractionsStrategy: aBlEventListener [

	self removeInteractionsStrategy.

	aBlEventListener ifNil:[ ^ self ].
	interactionsStrategy := aBlEventListener.
	self addEventHandler: aBlEventListener.
]

{ #category : #private }
BlAbstractGeoViewElement >> sortDatas [

	self internalSortDatas.
	self requestRepaint.
]

{ #category : #private }
BlAbstractGeoViewElement >> unconfigureGraphicModelForLayer: aLayer [
	
	| graphicModel |
	graphicModel := aLayer graphicModel.
	graphicModel removeAllProcessData.
]

{ #category : #private }
BlAbstractGeoViewElement >> unconfigureLayer: aLayer [
	
	aLayer viewInfos: nil.
	aLayer mapProjection: nil.
	aLayer graphicProjection: nil.
	aLayer announcer unsubscribe: self.

	aLayer haveGraphicModel ifFalse:[ ^ self ].
	self unconfigureGraphicModelForLayer: aLayer.	

	aLayer haveGeoObjects ifFalse:[ ^ self ].
	aLayer displayModel indexAccessor: nil.
]

{ #category : #private }
BlAbstractGeoViewElement >> updateDisplayToGraphicProjection [

	| extent |
	extent := self viewInfos extent.
	displayToGraphicProjection offsetInPixels: extent / 2.
	displayToGraphicProjection updateResolution: extent.
	self updateModel
]

{ #category : #private }
BlAbstractGeoViewElement >> updateModel [

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :l | l updateModel ] ].
	
]

{ #category : #'API -- dshapes' }
BlAbstractGeoViewElement >> updateObject: anUserObject [

	anUserObject ifNil:[ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveGeoObjects ifTrue:[ e updateObject: anUserObject ] ].
		self internalSortDatas ]
]

{ #category : #'API -- dshapes' }
BlAbstractGeoViewElement >> updateObjects: anUserObjectList [

	anUserObjectList ifNil:[ ^ self ].
	anUserObjectList ifEmpty:[ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveGeoObjects ifTrue:[ e updateObjects: anUserObjectList ] ].
		self internalSortDatas ]
]

{ #category : #private }
BlAbstractGeoViewElement >> updateState: aStateSymbol withIndexes: aKeyList [
	
	self enqueueBlockAsTaskAndRequestRepaint: [ 
		self layers do: [ :l | l haveGeoObjects ifTrue:[ l updateState: aStateSymbol withIndexes: aKeyList ] ].
		self internalSortDatas
	]
]

{ #category : #private }
BlAbstractGeoViewElement >> updateViewInfos [

	self viewInfos origin: self position copy.
	self viewInfos extent: self extent copy.
	self viewInfos update.
]

{ #category : #'API -- view infos' }
BlAbstractGeoViewElement >> viewInfos [

	viewInfos ifNil:[ self initializeViewInfos ].
	^ viewInfos
]

{ #category : #'API -- view infos' }
BlAbstractGeoViewElement >> viewInfos: aViewInfos [

	aViewInfos ifNil: [ ^ self ].
	viewInfos := aViewInfos.
	self updateViewInfos.
	self getLayers do: [ :l | l viewInfos: viewInfos ].
]
