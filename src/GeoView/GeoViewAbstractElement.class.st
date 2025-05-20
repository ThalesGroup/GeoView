"
I am an abstract BlElement which contains GeoViewWidget behavior. Not possible to use directly, to use a GeoViewWidget select a subclass element with the targeted backend.
"
Class {
	#name : #GeoViewAbstractElement,
	#superclass : #BlElement,
	#instVars : [
		'geoCenter',
		'scaleFactor',
		'maxScaleInMeters',
		'minScaleInMeters',
		'scaleInMeters',
		'objectIndexAccessor',
		'layers',
		'displayToGraphicProjection',
		'mapProjection',
		'viewInfos',
		'interactionsStrategy'
	],
	#category : #'GeoView-Core'
}

{ #category : #testing }
GeoViewAbstractElement class >> isAbstract [

	^ self = GeoViewAbstractElement
]

{ #category : #'API -- coordinates transformations' }
GeoViewAbstractElement >> absoluteCoordinatesFromGlobalPoint: aGlobalPoint [

	| localPoint |
	localPoint := self localPointFromGlobalPoint: aGlobalPoint.
	^ self absoluteCoordinatesFromLocalPoint: localPoint
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
	self isAttachedToSceneGraph ifTrue:[ aLayer addedToSceneGraph ].

	"Send layer added event"
	event := GeoViewLayerAddedEvent new.
	event layerName: aLayer name.
	self dispatchEvent: event
]

{ #category : #'API -- layers management' }
GeoViewAbstractElement >> addLayerAtFirst: aLayer [

	| event |
	self flag:'labordep: need to be factorized'.
	(self layers includes: aLayer) ifTrue: [ ^ self ].
	self configureLayer: aLayer.
	self layers addFirst: aLayer.
	self isAttachedToSceneGraph ifTrue:[ aLayer addedToSceneGraph ].

	"Send layer added event"
	event := GeoViewLayerAddedEvent new.
	event layerName: aLayer name.
	self dispatchEvent: event
]

{ #category : #'API -- layers management' }
GeoViewAbstractElement >> addLayerAtLast: aLayer [

	| event |
	self flag:'labordep: need to be factorized'.
	(self layers includes: aLayer) ifTrue: [ ^ self ].
	self configureLayer: aLayer.
	self layers addLast: aLayer.
	self isAttachedToSceneGraph ifTrue:[ aLayer addedToSceneGraph ].

	"Send layer added event"
	event := GeoViewLayerAddedEvent new.
	event layerName: aLayer name.
	self dispatchEvent: event
]

{ #category : #'API -- objects management' }
GeoViewAbstractElement >> addObject: anUserObject [

	anUserObject ifNil: [ ^ self ].

	self layers do: [ :e |
		e haveDomainObjects ifTrue: [ e addObject: anUserObject ] ]
]

{ #category : #'API -- objects management' }
GeoViewAbstractElement >> addObjects: anUserObjectList [

	(anUserObjectList isNil or: [ anUserObjectList isEmpty ]) ifTrue: [
		^ self ].

	self layers do: [ :e |
		e haveDomainObjects ifTrue: [ e addObjects: anUserObjectList ] ]
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> centerOnGlobalPoint: aGlobalPoint [
	"Center the map on a global point"

	| absoluteCoordinates |
	absoluteCoordinates := self absoluteCoordinatesFromGlobalPoint: aGlobalPoint.
	self geoCenter: absoluteCoordinates
]

{ #category : #private }
GeoViewAbstractElement >> configureLayer: aLayer [
	
	aLayer viewInfos: self viewInfos.
	
	"Setup the map projection (from a cartographic point of view) of the layer"
	aLayer mapProjection: self mapProjection.
	
	"Setup the graphic projection (from a device point of view) of the layer"
	aLayer graphicProjection: self displayToGraphicProjection.
	
	aLayer announcer when: GeoViewLayerRepaintRequest send: #layerNeedToBeRepaint: to: self.

	aLayer haveGraphicModel ifFalse:[ ^ self ].
	aLayer announcer when: GeoViewGraphicModelLayerSortRequest send: #layerNeedToBeSorted: to: self.

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
GeoViewAbstractElement >> evaluateScale: aNumberInMeters [

	aNumberInMeters < self minScaleInMeters ifTrue: [ ^ self minScaleInMeters ].
	aNumberInMeters > self maxScaleInMeters ifTrue: [ ^ self maxScaleInMeters ].
	^ aNumberInMeters 
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> geoCenter [

	geoCenter ifNil: [ geoCenter := AbsoluteCoordinates zero ].
	^ geoCenter
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
GeoViewAbstractElement >> getLayer: aKey [

	| layer |
	layer := self getLayers
		         detect: [ :l | l name = aKey ]
		         ifNone: [ nil ].
	^ layer 
]

{ #category : #'API -- layers management' }
GeoViewAbstractElement >> getLayers [
	
	^ self layers
]

{ #category : #'API -- coordinates transformations' }
GeoViewAbstractElement >> globalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [

	| localPoint |
	localPoint := self localPointFromAbsoluteCoordinates:
		              anAbsoluteCoordinates.
	^ self globalPointFromLocalPoint: localPoint
]

{ #category : #'API -- coordinates transformations' }
GeoViewAbstractElement >> globalPointFromLocalPoint: aLocalPoint [

	aLocalPoint ifNil: [ ^ nil ].
	^ self localPointToGlobal: aLocalPoint
]

{ #category : #'API -- objects management' }
GeoViewAbstractElement >> haveObjectIndex: anIndex [
	
	anIndex ifNil:[ ^ nil ].

	^ self layers anySatisfy: [ :e | e haveDomainObjects ifTrue:[ e haveObjectIndex: anIndex ] ]
]

{ #category : #initialization }
GeoViewAbstractElement >> initialize [

	super initialize.

	self mapProjection: GeoViewMercatorProjection new.
	self displayToGraphicProjection: GeoView2DProjection new.
	self background: Color black.
	self initializeEventHandlers
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

{ #category : #'private - events' }
GeoViewAbstractElement >> layerNeedToBeRepaint: anEvent [

	self requestRepaint 
]

{ #category : #'private - events' }
GeoViewAbstractElement >> layerNeedToBeSorted: anEvent [
	"Create a BlTask to sort the layer"

	| task layer |
	layer := anEvent layer.

	task := BlTaskAction new.
	task action: [
		layer sortDatas.
		self requestRepaint ].

	self enqueueTask: task
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

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> maxScaleInMeters [

	^ maxScaleInMeters ifNil: [ maxScaleInMeters := 1.5171584e7 ]
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> maxScaleInMeters: anObject [

	maxScaleInMeters := anObject
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> minScaleInMeters [

	^ minScaleInMeters ifNil: [ minScaleInMeters := 1852.0 ]
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> minScaleInMeters: anObject [

	minScaleInMeters := anObject
]

{ #category : #'strategy management' }
GeoViewAbstractElement >> newInteractionsStrategy [

	^ GeoViewDefaultInteractionsStrategy new
]

{ #category : #'API -- objects parameters' }
GeoViewAbstractElement >> objectIndexAccessor [

	^ objectIndexAccessor ifNil: [ objectIndexAccessor := #key ]
]

{ #category : #'API -- objects parameters' }
GeoViewAbstractElement >> objectIndexAccessor: aSymbol [

	objectIndexAccessor := aSymbol
]

{ #category : #'hooks - children' }
GeoViewAbstractElement >> onAddedToSceneGraph [

	super onAddedToSceneGraph.

	"send message to all layers"
	self layers do: [ :e | e addedToSceneGraph ]
]

{ #category : #'hooks - children' }
GeoViewAbstractElement >> onRemovedFromSceneGraph [

	super onRemovedFromSceneGraph.
	
	"send message to all layers"
	self layers do: [ :e | e removedFromSceneGraph ]
]

{ #category : #'API -- picking' }
GeoViewAbstractElement >> pickAt: aGlobalPoint [
	"Return all objects under a global point"

	^ self pickAt: aGlobalPoint radius: 0
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
	aPickingResult radiusInPixels: radius
]

{ #category : #'private - events' }
GeoViewAbstractElement >> processExtentChangedEvent: anEvent [

	self updateViewInfos.
	self updateDisplayToGraphicProjection
]

{ #category : #'API -- layers management' }
GeoViewAbstractElement >> removeAllLayers [

	| list |
	list := self getLayers.
	list copy do: [ :l | self removeLayer: l ].
	^ list 
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
	self isAttachedToSceneGraph ifTrue:[ aLayer removedFromSceneGraph ].
	
	"Send layer added event"
	event := GeoViewLayerRemovedEvent new.
	event layerName: aLayer name.
	self dispatchEvent: event
]

{ #category : #'API -- objects management' }
GeoViewAbstractElement >> removeObject: anUserObject [

	anUserObject ifNil: [ ^ self ].

	self layers do: [ :e |
		e haveDomainObjects ifTrue: [ e removeObject: anUserObject ] ]
]

{ #category : #'API -- objects management' }
GeoViewAbstractElement >> removeObjects: anUserObjectList [

	anUserObjectList ifNil: [ ^ self ].
	anUserObjectList ifEmpty: [ ^ self ].

	self layers do: [ :e |
		e haveDomainObjects ifTrue: [ e removeObjects: anUserObjectList ] ]
]

{ #category : #private }
GeoViewAbstractElement >> requestRepaint [

	self layers ifEmpty: [ ^ self ].
	self invalidate.
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleDown [

	self scaleInMeters: self scaleInMeters * self scaleFactor
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleFactor [

	^ scaleFactor ifNil: [ scaleFactor := 2 ]
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleFactor: aNumber [

	scaleFactor := aNumber
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleInMeters [

	^ scaleInMeters ifNil: [ scaleInMeters := 1.4816e7 ]
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

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleUp [

	self scaleInMeters: self scaleInMeters / self scaleFactor
]

{ #category : #'API -- selection' }
GeoViewAbstractElement >> selectedObjectIndexes: anIndexList [

	self updateState: #selected withIndexes: anIndexList
]

{ #category : #'strategy management' }
GeoViewAbstractElement >> setInteractionsStrategy: aBlEventListener [

	self removeInteractionsStrategy.

	aBlEventListener ifNil:[ ^ self ].
	interactionsStrategy := aBlEventListener.
	self addEventHandler: aBlEventListener.
]

{ #category : #private }
GeoViewAbstractElement >> unconfigureLayer: aLayer [

	aLayer viewInfos: nil.
	aLayer mapProjection: nil.
	aLayer graphicProjection: nil.
	aLayer announcer unsubscribe: self.

	aLayer haveDomainObjects ifFalse: [ ^ self ].
	aLayer displayModel indexAccessor: nil
]

{ #category : #private }
GeoViewAbstractElement >> updateDisplayToGraphicProjection [

	| extent offset |
	extent := self viewInfos extent.
	offset := extent / 2.

	(self displayToGraphicProjection offsetInPixels ~= offset or: [
		 (self displayToGraphicProjection haveResolution: extent) not ])
		ifFalse: [ ^ self ].
		
	self displayToGraphicProjection offsetInPixels: offset.
	self displayToGraphicProjection updateResolution: extent.
	self updateModel: (GeoViewProjectionChanges new
			 isExtentChanged: true;
			 isResolutionChanged: true)
]

{ #category : #private }
GeoViewAbstractElement >> updateModel: aContext [

	self layers ifEmpty: [ ^ self ].

	self layers do: [ :l | l updateModel: aContext ]
]

{ #category : #'API -- objects management' }
GeoViewAbstractElement >> updateObject: anUserObject [

	anUserObject ifNil: [ ^ self ].

	self layers do: [ :e |
		e haveDomainObjects ifTrue: [ e updateObject: anUserObject ] ]
]

{ #category : #'API -- objects management' }
GeoViewAbstractElement >> updateObjects: anUserObjectList [

	anUserObjectList ifNil: [ ^ self ].
	anUserObjectList ifEmpty: [ ^ self ].

	self layers do: [ :e |
		e haveDomainObjects ifTrue: [ e updateObjects: anUserObjectList ] ]
]

{ #category : #private }
GeoViewAbstractElement >> updateState: aStateSymbol withIndexes: aKeyList [

	aKeyList ifNil: [ ^ self ].
	aStateSymbol ifNil: [ ^ self ].
	self layers ifEmpty: [ ^ self ].

	self layers do: [ :l |
		l haveDomainObjects ifTrue: [
			l updateState: aStateSymbol withIndexes: aKeyList ] ]
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
	self updateModel: (GeoViewProjectionChanges new).
]
