"
I am an abstract BlElement which contains GeoViewWidget behavior. Not possible to use directly, to use a GeoViewWidget select a subclass element with the targeted backend.
"
Class {
	#name : #GeoViewAbstractElement,
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
GeoViewAbstractElement class >> isAbstract [

	^ self = GeoViewAbstractElement
]

{ #category : #'API -- coordinates transformations' }
GeoViewAbstractElement >> absoluteCoordinatesFromLocalPoint: aLocalPoint [

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
GeoViewAbstractElement >> addLayer: aLayer [

	| event |
	(self layers includes: aLayer) ifTrue: [ ^ self ].
	self configureLayer: aLayer.
	self layers add: aLayer.

	"Send layer added event"
	event := GeoViewLayerAddedEvent new.
	event layerName: aLayer name.
	self dispatchEvent: event
]

{ #category : #'API -- objects management' }
GeoViewAbstractElement >> addObject: anUserObject [

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveDomainObjects ifTrue:[ e addObject: anUserObject ] ].
		self internalSortDatas ]
]

{ #category : #'API -- objects management' }
GeoViewAbstractElement >> addObjects: anUserObjectList [

	(anUserObjectList isNil or: [ anUserObjectList isEmpty ]) ifTrue: [ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveDomainObjects ifTrue:[ e addObjects: anUserObjectList ] ].
		self internalSortDatas ]
]

{ #category : #private }
GeoViewAbstractElement >> configureLayer: aLayer [
	
	aLayer viewInfos: self viewInfos.
	
	"Setup the map projection (from a cartographic point of view) of the layer"
	aLayer mapProjection: self mapProjection.
	
	"Setup the graphic projection (from a device point of view) of the layer"
	aLayer graphicProjection: self displayToGraphicProjection.
	
	aLayer announcer when: GeoViewLayerRepaintRequest send: #layerNeedToBeRepaint: to: self.

	aLayer haveDomainObjects ifFalse:[ ^ self ].
	aLayer displayModel indexAccessor: self objectIndexAccessor.
	aLayer announcer when: GeoViewDomainObjectsLayerProcessDataChanged send: #layerProcessDataChanged: to: self
]

{ #category : #'private - picking' }
GeoViewAbstractElement >> createPickingResultAt: aGlobalPoint [

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
GeoViewAbstractElement >> displayToGraphicProjection [

	^ displayToGraphicProjection
]

{ #category : #accessing }
GeoViewAbstractElement >> displayToGraphicProjection: aGeoView2DProjection [

	displayToGraphicProjection := aGeoView2DProjection.
	displayToGraphicProjection ifNil: [ ^ self ].
	
	"change projection to layers"
	self layers do:[ :l | l graphicProjection: displayToGraphicProjection ].
	
	self updateDisplayToGraphicProjection
]

{ #category : #'private - picking' }
GeoViewAbstractElement >> doPicking: aPickingResult [
	"Collect all picked elements"

	self getLayers do: [ :l | l isVisible ifTrue: [ l populatePickingResult: aPickingResult ] ]
]

{ #category : #private }
GeoViewAbstractElement >> enqueueBlockAsTaskAndRequestRepaint: aBlockClosure [

	| task |
	task := BlTaskAction new.
	task action: aBlockClosure.
	self enqueueTask: task.
	
	task := BlTaskAction new.
	task action: [ self requestRepaint ].
	self enqueueTask: task
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> geoCenter: anAbsoluteCoordinates [

	| cartesianCoordinates geoViewEvent |
	
	geoCenter = anAbsoluteCoordinates ifTrue:[ ^ self ].
	
	geoCenter := anAbsoluteCoordinates copy.

	cartesianCoordinates := self mapProjection projLatLonToCart: geoCenter.
	self displayToGraphicProjection cartesianCenter: cartesianCoordinates.
	self updateModel: ((GeoViewProjectionChanges new) isCenterChanged: true).

	"Send center event"
	geoViewEvent := GeoViewCenterChangedEvent new.
	geoViewEvent absoluteCoordinates: anAbsoluteCoordinates.
	self dispatchEvent: geoViewEvent
]

{ #category : #'API -- layers management' }
GeoViewAbstractElement >> getLayers [
	
	^ self layers
]

{ #category : #'API -- coordinates transformations' }
GeoViewAbstractElement >> globalPointFromLocalPoint: aLocalPoint [

	aLocalPoint ifNil: [ ^ nil ].
	^ self localPointToGlobal: aLocalPoint
]

{ #category : #'API -- dshapes' }
GeoViewAbstractElement >> haveObjectIndex: anIndex [
	"Pay attention before using it because graphical model is out of sync real user model due to usage of BlTask (asynchronous)"

	anIndex ifNil:[ ^ nil ].

	^ self layers anySatisfy: [ :e | e haveDomainObjects ifTrue:[ e haveObjectIndex: anIndex ] ]
]

{ #category : #initialization }
GeoViewAbstractElement >> initialize [

	super initialize.
	
	self mapProjection: GeoViewMercatorProjection new.
	self displayToGraphicProjection: GeoView2DProjection new.
	self background: Color black.
	self initializeEventHandlers.
]

{ #category : #initialization }
GeoViewAbstractElement >> initializeEventHandlers [

	"Add listeners to process Bloc UI events interactions"
	self setInteractionsStrategy: self newInteractionsStrategy.

	"Add listener to compute things when extents changed"
	self addEventHandler: (BlEventHandler
			 on: BlElementExtentChangedEvent
			 do: [ :e | self processExtentChangedEvent: e ])
]

{ #category : #initialization }
GeoViewAbstractElement >> initializeViewInfos [

	self viewInfos: GeoViewInfos new
]

{ #category : #'strategy management' }
GeoViewAbstractElement >> interactionsStrategy [

	^ interactionsStrategy
]

{ #category : #private }
GeoViewAbstractElement >> internalSortDatas [

	self isMarkedForSortDatas ifTrue: [ ^ self ].
	isMarkedForSortDatas := true.
	self layers do: [ :l | l haveGraphicModel ifTrue: [ l sortDatas ] ]
]

{ #category : #accessing }
GeoViewAbstractElement >> isMarkedForSortDatas [

	^ isMarkedForSortDatas ifNil: [ isMarkedForSortDatas := false ]
]

{ #category : #'private - events' }
GeoViewAbstractElement >> layerNeedToBeRepaint: anEvent [

	self requestRepaint 
]

{ #category : #'private - events' }
GeoViewAbstractElement >> layerProcessDataChanged: anEvent [

	"Send scale event"
	| event |
	event := GeoViewDomainObjectsLayerProcessDataChanged new.
	event layerName: anEvent layerName.
	self dispatchEvent: event
]

{ #category : #accessing }
GeoViewAbstractElement >> layers [

	^ layers ifNil: [ layers := OrderedCollection new ]
]

{ #category : #'API -- coordinates transformations' }
GeoViewAbstractElement >> localPointFromAbsoluteCoordinates: anAbsoluteCoordinates [

	| projection |
	projection := self mapProjection.
	projection ifNil: [ ^ nil ].

	^ self displayToGraphicProjection projCartToPixel:
		  (projection projLatLonToCart: anAbsoluteCoordinates)
]

{ #category : #'API -- coordinates transformations' }
GeoViewAbstractElement >> localPointFromGlobalPoint: aGlobalPoint [

	^ self globalPointToLocal: aGlobalPoint
]

{ #category : #'API -- map projection' }
GeoViewAbstractElement >> mapProjection [
	"Return the map projection of the object: Mercator, etc."

	^ mapProjection
]

{ #category : #'API -- map projection' }
GeoViewAbstractElement >> mapProjection: aMapProjection [
	"Setup the map projection of the object: Mercator, etc."

	| geoViewEvent |
	aMapProjection ~= mapProjection ifFalse:[ ^ self ].
	mapProjection := aMapProjection copy.
	
	self getLayers do:[ :l | l displayModel projection: self mapProjection ].
	self updateModel: ((GeoViewProjectionChanges new) isMapProjectionChange: true).
	
	"Send map projection changed event"
	geoViewEvent := GeoViewMapProjectionChangedEvent new.
	geoViewEvent projection: aMapProjection.
	self dispatchEvent: geoViewEvent
]

{ #category : #'strategy management' }
GeoViewAbstractElement >> newInteractionsStrategy [

	^ GeoViewDefaultInteractionsStrategy new
]

{ #category : #'API -- picking' }
GeoViewAbstractElement >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"Return all objects under a global point inside a radius in pixels"

	| pickingResult |
	pickingResult := self createPickingResultAt: aGlobalPoint.
	self preConfigurePickingResult: pickingResult radius: aRadiusInPixels.
	self doPicking: pickingResult.
	self postConfigurePickingResult: pickingResult radius: aRadiusInPixels.

	^ pickingResult
]

{ #category : #'private - picking' }
GeoViewAbstractElement >> postConfigurePickingResult: aPickingResult radius: aRadius [

	aPickingResult applyOrder: [ :a :b | a distanceInPixels < b distanceInPixels ].
]

{ #category : #'private - picking' }
GeoViewAbstractElement >> preConfigurePickingResult: aPickingResult radius: aRadiusInPixels [
	"do nothing"

	| radius |
	radius := aRadiusInPixels ifNil: [ 0 ].
	aPickingResult radiusInPixels: radius.
	
	aPickingResult distanceBlock: [ :gShape :point | gShape distanceTo: point ]
]

{ #category : #'private - events' }
GeoViewAbstractElement >> processExtentChangedEvent: anEvent [

	self updateViewInfos.
	self updateDisplayToGraphicProjection
]

{ #category : #'strategy management' }
GeoViewAbstractElement >> removeInteractionsStrategy [

	interactionsStrategy ifNil:[ ^ self ].
	self removeEventHandler: interactionsStrategy.
	interactionsStrategy := nil.
]

{ #category : #'API -- layers management' }
GeoViewAbstractElement >> removeLayer: aLayer [
	
	| event |
	(self layers includes: aLayer) ifFalse: [ ^ self ].
	self unconfigureLayer: aLayer.
	self layers remove: aLayer.
	
	"Send layer added event"
	event := GeoViewLayerRemovedEvent new.
	event layerName: aLayer name.
	self dispatchEvent: event
]

{ #category : #'API -- dshapes' }
GeoViewAbstractElement >> removeObject: anUserObject [

	anUserObject ifNil:[ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveDomainObjects ifTrue:[ e removeObject: anUserObject ] ].
		self internalSortDatas ]
]

{ #category : #'API -- dshapes' }
GeoViewAbstractElement >> removeObjects: anUserObjectList [

	anUserObjectList ifNil:[ ^ self ].
	anUserObjectList ifEmpty:[ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveDomainObjects ifTrue:[ e removeObjects: anUserObjectList ] ].
		self internalSortDatas ]
]

{ #category : #private }
GeoViewAbstractElement >> requestRepaint [

	self layers ifEmpty: [ ^ self ].
	self invalidate.
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleInMeters: aNumber [

	| scale geoViewEvent |
	scale := self evaluateScale: aNumber.
	scaleInMeters := scale.
	
	self displayToGraphicProjection altitudeInMeters: self scaleInMeters.
	self displayToGraphicProjection updateResolution: self extent.
	self updateModel: ((GeoViewProjectionChanges new) isScaleChanged: true; isResolutionChanged: true).
	
	"Send scale event"
	geoViewEvent := GeoViewScaleChangedEvent new.
	geoViewEvent scaleInMeters: self scaleInMeters.
	self dispatchEvent: geoViewEvent.
]

{ #category : #'API -- selection' }
GeoViewAbstractElement >> selectedObjectIndexes: anIndexList [

	anIndexList ifNil:[ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :l | l haveDomainObjects ifTrue:[ l updateState: #selected withIndexes: anIndexList ] ].
		self internalSortDatas ]
]

{ #category : #'strategy management' }
GeoViewAbstractElement >> setInteractionsStrategy: aBlEventListener [

	self removeInteractionsStrategy.

	aBlEventListener ifNil:[ ^ self ].
	interactionsStrategy := aBlEventListener.
	self addEventHandler: aBlEventListener.
]

{ #category : #private }
GeoViewAbstractElement >> sortDatas [

	self internalSortDatas.
	self requestRepaint.
]

{ #category : #private }
GeoViewAbstractElement >> unconfigureLayer: aLayer [
	
	aLayer viewInfos: nil.
	aLayer mapProjection: nil.
	aLayer graphicProjection: nil.
	aLayer announcer unsubscribe: self.

	aLayer haveDomainObjects ifFalse:[ ^ self ].
	aLayer displayModel indexAccessor: nil.
]

{ #category : #private }
GeoViewAbstractElement >> updateDisplayToGraphicProjection [

	| extent offset |
	extent := self viewInfos extent.
	offset := extent / 2.
	
	(self displayToGraphicProjection offsetInPixels ~= offset or:[(self displayToGraphicProjection haveResolution: extent) not]) ifTrue:[
		self displayToGraphicProjection offsetInPixels: offset.
		self displayToGraphicProjection updateResolution: extent.
		self updateModel: ((GeoViewProjectionChanges new) isExtentChanged: true; isResolutionChanged: true).
	].
]

{ #category : #private }
GeoViewAbstractElement >> updateModel: aContext [

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :l | l updateModel: aContext ] ].
	
]

{ #category : #'API -- dshapes' }
GeoViewAbstractElement >> updateObject: anUserObject [

	anUserObject ifNil:[ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveDomainObjects ifTrue:[ e updateObject: anUserObject ] ].
		self internalSortDatas ]
]

{ #category : #'API -- dshapes' }
GeoViewAbstractElement >> updateObjects: anUserObjectList [

	anUserObjectList ifNil:[ ^ self ].
	anUserObjectList ifEmpty:[ ^ self ].

	self enqueueBlockAsTaskAndRequestRepaint: [
		self layers do: [ :e | e haveDomainObjects ifTrue:[ e updateObjects: anUserObjectList ] ].
		self internalSortDatas ]
]

{ #category : #private }
GeoViewAbstractElement >> updateState: aStateSymbol withIndexes: aKeyList [
	
	self enqueueBlockAsTaskAndRequestRepaint: [ 
		self layers do: [ :l | l haveDomainObjects ifTrue:[ l updateState: aStateSymbol withIndexes: aKeyList ] ].
		self internalSortDatas
	]
]

{ #category : #private }
GeoViewAbstractElement >> updateViewInfos [

	self viewInfos origin: self position copy.
	self viewInfos extent: self extent copy.
	self viewInfos update.
]

{ #category : #'API -- view infos' }
GeoViewAbstractElement >> viewInfos [

	viewInfos ifNil: [ self initializeViewInfos ].
	^ viewInfos
]

{ #category : #'API -- view infos' }
GeoViewAbstractElement >> viewInfos: aViewInfos [

	aViewInfos ifNil: [ ^ self ].
	viewInfos := aViewInfos.
	self updateViewInfos.
	self getLayers do: [ :l | l viewInfos: viewInfos ].
]
