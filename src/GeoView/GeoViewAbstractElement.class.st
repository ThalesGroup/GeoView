"
I am an abstract BlElement which contains GeoViewWidget behavior. Not possible to use directly, to use a GeoViewWidget select a subclass element with the targeted backend.
"
Class {
	#name : #GeoViewAbstractElement,
	#superclass : #BlElement,
	#instVars : [
		'geoCenter',
		'scaleFactor',
		'objectIndexAccessor',
		'layers',
		'displayToGraphicProjection',
		'mapProjection',
		'viewInfos',
		'displayFilter',
		'scale',
		'maxScale',
		'minScale'
	],
	#category : #'GeoView-Core'
}

{ #category : #testing }
GeoViewAbstractElement class >> isAbstract [

	^ self == GeoViewAbstractElement
]

{ #category : #enumerating }
GeoViewAbstractElement class >> selectedState [

	^ #selected
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

	self addLayer: aLayer afterIndex: nil
]

{ #category : #'API -- layers management' }
GeoViewAbstractElement >> addLayer: aLayer afterIndex: anIndex [
	"Add a layer to a specific index. Littles indexes are displayed before highest indexes"

	| event |
	(self layers includes: aLayer) ifTrue: [ ^ self ].
	self configureLayer: aLayer.

	(anIndex isNil or:[ (anIndex < 0 or:[ anIndex > self layers size ]) ])
		ifTrue: [ self layers add: aLayer ]
		ifFalse: [ self layers add: aLayer afterIndex: anIndex ].

	self isAttachedToSceneGraph ifTrue: [ aLayer addedToSceneGraph ].	

	"Send layer added event"
	event := GeoViewLayerAddedEvent new.
	event layerName: aLayer name.
	self dispatchEvent: event.
	
]

{ #category : #'API -- layers management' }
GeoViewAbstractElement >> addLayer: aLayer beforeIndex: anIndex [
	"Add a layer to a specific index. Littles indexes are displayed before highest indexes"

	self addLayer: aLayer afterIndex: (anIndex - 1)
]

{ #category : #'API -- layers management' }
GeoViewAbstractElement >> addLayerAtFirst: aLayer [

	self addLayer: aLayer afterIndex: 0
]

{ #category : #'API -- layers management' }
GeoViewAbstractElement >> addLayerAtLast: aLayer [

	self addLayer: aLayer
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

{ #category : #'API -- filters' }
GeoViewAbstractElement >> applyDisplayFilterToAllLayers: aDisplayFilter [

	self layers
		select: [ :l | l haveGraphicModel ]
		thenDo: [ :l | l displayFilter: aDisplayFilter ]
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> centerOnGlobalPoint: aGlobalPoint [
	"Center the map on a global point"

	| absoluteCoordinates |
	absoluteCoordinates := self absoluteCoordinatesFromGlobalPoint: aGlobalPoint.
	self geoCenter: absoluteCoordinates
]

{ #category : #'API -- states' }
GeoViewAbstractElement >> clearSelectedObjectIndexes [

	self selectedObjectIndexes: #(  )
]

{ #category : #'API -- states' }
GeoViewAbstractElement >> clearStateObjectIndexes: aStateSymbol [

	self updateState: aStateSymbol withObjectIndexes: #(  )
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
	"Setup the display filter"
	aLayer displayFilter: self displayFilter.
	"Setup sort mecanism and check if the layer need to be sorted"
	aLayer announcer when: GeoViewGraphicModelLayerSortRequest send: #layerNeedToBeSorted: to: self.
	aLayer isNeedToSortDatas ifTrue:[ aLayer sendSortRequest ].

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

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> defaultScale [
	"Default scale is 1:10 000 000"

	^ 10000000
]

{ #category : #'API -- filters' }
GeoViewAbstractElement >> displayFilter [

	^ displayFilter
]

{ #category : #'API -- filters' }
GeoViewAbstractElement >> displayFilter: aDisplayFilter [
	"setup a general display filter for all layers"

	displayFilter := aDisplayFilter.
	self applyDisplayFilterToAllLayers: displayFilter
]

{ #category : #accessing }
GeoViewAbstractElement >> displayToGraphicProjection [

	^ displayToGraphicProjection
]

{ #category : #accessing }
GeoViewAbstractElement >> displayToGraphicProjection: aGeoView2DProjection [

	displayToGraphicProjection := aGeoView2DProjection.
	displayToGraphicProjection ifNil: [ ^ self ].

	"inject the projection to all layers"
	self layers do:[ :l | l graphicProjection: displayToGraphicProjection ].
	
	self updateDisplayToGraphicProjection
]

{ #category : #'private - picking' }
GeoViewAbstractElement >> doPicking: aPickingResult [
	"Collect all picked elements"

	self getLayers do: [ :l | l isVisible ifTrue: [ l populatePickingResult: aPickingResult ] ]
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> geoCenter [

	^ geoCenter ifNil: [ geoCenter := AbsoluteCoordinates zero ]
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

{ #category : #'API -- layers management' }
GeoViewAbstractElement >> hasLayer [

	^ self layers notEmpty
]

{ #category : #'API -- objects management' }
GeoViewAbstractElement >> haveObjectIndex: anIndex [
	
	anIndex ifNil:[ ^ nil ].

	^ self layers anySatisfy: [ :e | e haveDomainObjects ifTrue:[ e haveObjectIndex: anIndex ] ]
]

{ #category : #initialization }
GeoViewAbstractElement >> initialize [

	super initialize.
	
	"Initialize default projection systems"
	self mapProjection: GeoViewMercatorProjection new.
	self displayToGraphicProjection: GeoView2DProjection new.
	self scale: self defaultScale
]

{ #category : #initialization }
GeoViewAbstractElement >> initializeViewInfos [

	self viewInfos: GeoViewInfos new
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
		self requestRepaint
	].

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
GeoViewAbstractElement >> maxScale [
	"Default maximum scale is 1:100 000 000"

	^ maxScale ifNil: [ maxScale := 100000000 ]
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> maxScale: aNumber [

	maxScale := aNumber
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> maxScaleInMeters [

	self 
		deprecated:'Use generic message' 
		transformWith: '`@receiver maxScaleInMeters' -> '`@receiver maxScale'.

	^ self maxScale
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> maxScaleInMeters: aNumber [

	self 
		deprecated:'Use generic message' 
		transformWith: '`@receiver maxScaleInMeters: `@aNumber' -> '`@receiver maxScale: `@aNumber'.

	self maxScale: aNumber
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> minScale [
	"Default minimum scale is 1:100"

	^ minScale ifNil: [ minScale := 100 ]
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> minScale: aNumber [

	minScale := aNumber
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> minScaleInMeters [
	
	self 
		deprecated:'Use generic message' 
		transformWith: '`@receiver minScaleInMeters' -> '`@receiver minScale'.

	^ self minScale
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> minScaleInMeters: aNumber [

	self 
		deprecated:'Use generic message' 
		transformWith: '`@receiver minScaleInMeters: `@aNumber' -> '`@receiver minScale: `@aNumber'.

	self minScale: aNumber
]

{ #category : #private }
GeoViewAbstractElement >> normalizeScale: aNumberInMeters [

	aNumberInMeters < self minScale ifTrue: [ ^ self minScale ].
	aNumberInMeters > self maxScale ifTrue: [ ^ self maxScale ].
	^ aNumberInMeters
]

{ #category : #'API -- objects management' }
GeoViewAbstractElement >> objectIndexAccessor [

	^ objectIndexAccessor ifNil: [ objectIndexAccessor := #key ]
]

{ #category : #'API -- objects management' }
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

	self invalidate
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scale [

	^ scale
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scale: aNumber [

	| newScale geoViewEvent |
	newScale := self normalizeScale: aNumber.
	
	scale = newScale ifTrue:[ ^ self ].
	scale := newScale.
	
	self updateDisplayToGraphicProjection.
	
	"Send scale event"
	geoViewEvent := GeoViewScaleChangedEvent new.
	geoViewEvent scale: self scale.
	self dispatchEvent: geoViewEvent.
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleDown [

	self scale: (self scale * self scaleFactor)
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleFactor [
	"The scale factor is the multiplicator / diviser for default zoom up/down"

	(scaleFactor = 0 or: [ scaleFactor isNil ]) ifTrue: [
		scaleFactor := 1.5 ].
	^ scaleFactor
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleFactor: aNumber [

	scaleFactor := aNumber
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleInMeters [

	self 
		deprecated:'Use generic message' 
		transformWith: '`@receiver scaleInMeters' -> '`@receiver scale'.

	^ self scale
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleInMeters: aNumber [

	self 
		deprecated:'Use generic message' 
		transformWith: '`@receiver scaleInMeters: `@aNumber' -> '`@receiver scale: `@aNumber'.
		
	self scale: aNumber
]

{ #category : #'API -- scale and center' }
GeoViewAbstractElement >> scaleUp [

	self scale: (self scale / self scaleFactor)
]

{ #category : #'API -- states' }
GeoViewAbstractElement >> selectedObjectIndexes: anIndexList [

	self updateState: self class selectedState withObjectIndexes: anIndexList
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

	| extent offset changes |
	"cannot update when scale is not defined, initialize it before"
	self scale ifNil:[ ^ self ].
	extent := self viewInfos extent.
	extent = (0@0) ifTrue:[ ^ self ]. 
	offset := extent / 2.

	changes := GeoViewProjectionChanges new.

	self displayToGraphicProjection offsetInPixels ~= offset ifTrue:[
		self displayToGraphicProjection offsetInPixels: offset.
		changes isExtentChanged: true.
	].
	
	"Check if need to update the scale of the graphic projection when scale are differents"
	self scale ~= self displayToGraphicProjection scale ifTrue:[
		self displayToGraphicProjection scale: self scale.
		self displayToGraphicProjection updateResolution: extent.	
		changes isScaleChanged: true.
	].

	( changes isExtentChanged or:[ changes isScaleChanged ]) ifFalse:[ ^ self ].	
	self updateModel: changes
]

{ #category : #private }
GeoViewAbstractElement >> updateModel: aContext [

	aContext ifNil:[ ^ self ].
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

{ #category : #'API -- states' }
GeoViewAbstractElement >> updateState: aStateSymbol withObjectIndexes: aKeyList [

	aKeyList ifNil: [ ^ self ].
	aStateSymbol ifNil: [ ^ self ].

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
