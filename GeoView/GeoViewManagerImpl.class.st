"
I am the generic GeoviewManager implementation.
"
Class {
	#name : #GeoViewManagerImpl,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'GeoViewManager + GeoViewManagerGeoObjectsServices + GeoViewManagerParameters + GeoViewManagerGeoObjectsParameters + GeoViewManagerServices + GeoViewPickingServices + GeoViewManagerLayerServices + SmockSelectionManagerEvents',
	#classTraits : 'GeoViewManager classTrait + GeoViewManagerGeoObjectsServices classTrait + GeoViewManagerParameters classTrait + GeoViewManagerGeoObjectsParameters classTrait + GeoViewManagerServices classTrait + GeoViewPickingServices classTrait + GeoViewManagerLayerServices classTrait + SmockSelectionManagerEvents classTrait',
	#instVars : [
		'view',
		'geoCenter',
		'scaleInMeters',
		'minScaleInMeters',
		'maxScaleInMeters',
		'scaleFactor',
		'geoObjectsIndexAccessor',
		'eventStrategyStack'
	],
	#category : #'GeoView-Core-Impl'
}

{ #category : #'aggregated components' }
GeoViewManagerImpl >> activateComponents [
	MolComponentManager default homeServices activateComponent: MapProjectionManagerImpl named: self componentName.
	MolComponentManager default homeServices activateComponent: GeoSymbologyProvider named: self componentName.
	(MolComponentManager default homeServices isWaitingForActivation: SmockSelectionManagerImpl named: self componentName) ifTrue:[
		MolComponentManager default homeServices activateComponent: SmockSelectionManagerImpl named: self componentName.
	].
]

{ #category : #'event strategy' }
GeoViewManagerImpl >> addEventBehavior: aGeoViewEventBehavior [

	aGeoViewEventBehavior ifNil:[^self].
	aGeoViewEventBehavior geoViewManager: self.
	eventStrategyStack add: aGeoViewEventBehavior.
]

{ #category : #'event strategy' }
GeoViewManagerImpl >> addEventBehaviorAtFirst: aGeoViewEventBehavior [

	aGeoViewEventBehavior ifNil:[^self].
	aGeoViewEventBehavior geoViewManager: self.
	eventStrategyStack addFirst: aGeoViewEventBehavior.
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> addGeoObject: aGeoObject [
	self
		assert: [ aGeoObject isNotNil ]
		description: [ '[GeoView] GeoObject should be not nil.' . ^self].
	self view addGeoObject: aGeoObject
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> addGeoObjects: aGeoObjectList [
	(aGeoObjectList isNil or:[aGeoObjectList isEmpty]) ifTrue:[^self].
	self view addGeoObjects: aGeoObjectList
]

{ #category : #'services - layer creation' }
GeoViewManagerImpl >> addLayer: aLayer [
	"(aLayer class traitComposition allTraits includes: GeoViewLayer) ifFalse:[^nil]."
	self flag:'PLA : regarder les traits dans lheritage pour être sûr que cest une layer'.
	aLayer layerName ifNil:[^nil].
	
	aLayer mapProjection: self getMapProjectionManagerServicesProvider getProjection.
	aLayer symbologyProvider: self getGeoSymbologyManagerServicesProvider.
	aLayer isGeoObjectLayer ifTrue:[
		aLayer processDataChangedCallback: [ :l | self receiveLayerUpdateFrom: l	]. 
	].
	self view addLayer: aLayer.
	
	self getGeoViewManagerLayerEventsNotifier layerAdded: aLayer layerName view: self componentName.
	^aLayer
]

{ #category : #'projection center' }
GeoViewManagerImpl >> centerOnPoint: aGlobalPoint [
	"Center the map on a global point"
	| absoluteCoordinates |
	absoluteCoordinates := self getAbsoluteCoordinatesFromGlobalPoint: aGlobalPoint.
	self setGeoCenter: absoluteCoordinates.
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentActivate [
	self activateComponents.
	self getSmockSelectionManagerEventsSubscriber subscribe: self.
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentInitialize [

	self forServices: MapProjectionManagerServices useProvider: self componentName.
	self forServices: GeoSymbologyManagerServices useProvider: self componentName.
	self forServices: SmockSelectionManagerServices useProvider: self componentName.

	self initializeComponents.
	self createView.
	self initializeView.
	self initializeEventStrategyStack.
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentPassivate [
	self getSmockSelectionManagerEventsSubscriber unsubscribe: self.
	self passivateComponents.
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentRemove [
	self deleteEventBehaviors.
	self removeComponents.
	
]

{ #category : #private }
GeoViewManagerImpl >> correctedScale: aNumberInMeters [
"Enlarge view on Mercator projection near the poles : used for decrease zoom effect when projection changes"
	self getMapProjectionManagerServicesProvider getProjection key = #MercatorProjection
		ifTrue: [ | angle latitudeMaxAngle |
			latitudeMaxAngle := 89 * (Float pi / 180).
			angle := self getGeoCenter latitudeInRadians. 
			angle abs > latitudeMaxAngle ifTrue: [ angle := latitudeMaxAngle ]. 
			^ aNumberInMeters / angle cos ]
		ifFalse: [ ^ aNumberInMeters ]
]

{ #category : #'services - layer creation' }
GeoViewManagerImpl >> createAndAddGeoObjectLayer: aKey [
	"add a layer to the geoplot"

	| existingLayer layer |
	aKey ifNil:[ SmockNoIdError signal: 'Cannot add layer with nil key.'. ^ nil ].
	
	existingLayer := self getLayer: aKey.
	existingLayer ifNotNil:[ SmockDuplicateIdError signal: 'Cannot add layer with already existing key.'. ^ nil ].
		
	layer := self createGeoObjectLayer: aKey.
	^self addLayer: layer
]

{ #category : #'layer creation' }
GeoViewManagerImpl >> createGeoObjectLayer: aKey [
	self subclassResponsibility 
]

{ #category : #initialization }
GeoViewManagerImpl >> createView [
	self subclassResponsibility 
]

{ #category : #'events handling' }
GeoViewManagerImpl >> cursorPositionChanged: anAssociation [

	self getGeoViewManagerCursorEventsNotifier cursor: anAssociation key positionChanged: anAssociation value view: self componentName
]

{ #category : #'services - layer deletion' }
GeoViewManagerImpl >> deleteAllLayers [
	| layers |
	layers := self view getLayers.
	layers do:[ :l | (self view deleteLayer: l) ifNotNil:[ self getGeoViewManagerLayerEventsNotifier layerDeleted: l layerName view: self componentName ]].
	^layers
]

{ #category : #'event strategy' }
GeoViewManagerImpl >> deleteEventBehavior: aGeoViewEventBehavior [

	aGeoViewEventBehavior ifNil:[^self].
	(aGeoViewEventBehavior geoViewManager == self) ifFalse:[^self].
	aGeoViewEventBehavior geoViewManager: nil.
	eventStrategyStack remove: aGeoViewEventBehavior ifAbsent:[nil].
]

{ #category : #'event strategy' }
GeoViewManagerImpl >> deleteEventBehaviors [

	| stack |
	stack := eventStrategyStack copy.
	eventStrategyStack removeAll.
	stack do:[ :e | e geoViewManager: nil ].
]

{ #category : #'services - layer deletion' }
GeoViewManagerImpl >> deleteLayer: aKey [
	| layer |
	aKey ifNil:[^nil].
	layer := self getLayer: aKey.
	layer ifNil:[^nil].
	layer := self view deleteLayer: layer.
	layer ifNotNil:[self getGeoViewManagerLayerEventsNotifier layerDeleted: aKey view: self componentName].
	^layer
]

{ #category : #'events handling' }
GeoViewManagerImpl >> dispatchEvent: anEngineEvent [
	"Transfert event in input strategy stack to each behavior processors"

	eventStrategyStack ifNil: [ ^ self ].
	eventStrategyStack do: [ :s | | result |
		result := (s receiveEvent: anEngineEvent). 
		"Result should be nil or self, but if the result is a true boolean the event is consume and the stack is stopped"
		result = true ifTrue:[ ^self ].
	]
]

{ #category : #private }
GeoViewManagerImpl >> evaluateScale: aNumberInMeters [
	aNumberInMeters < self minScaleInMeters ifTrue: [ ^ self minScaleInMeters ].
	aNumberInMeters > self maxScaleInMeters ifTrue: [ ^ self maxScaleInMeters ].
	^ aNumberInMeters
]

{ #category : #accessing }
GeoViewManagerImpl >> geoCenter [
	geoCenter ifNil: [ geoCenter := AbsoluteCoordinates zero ].
	^ geoCenter 
]

{ #category : #accessing }
GeoViewManagerImpl >> geoCenter: anAbsoluteCoordinates [
	geoCenter := anAbsoluteCoordinates
]

{ #category : #accessing }
GeoViewManagerImpl >> geoObjectsIndexAccessor [
	^ geoObjectsIndexAccessor
]

{ #category : #accessing }
GeoViewManagerImpl >> geoObjectsIndexAccessor: anObject [
	geoObjectsIndexAccessor := anObject
]

{ #category : #'event strategy' }
GeoViewManagerImpl >> getEventBehaviors [

	^eventStrategyStack copy
]

{ #category : #'layer accessing' }
GeoViewManagerImpl >> getGeoCenter [
	^ self geoCenter
]

{ #category : #'component accessing' }
GeoViewManagerImpl >> getGeoSymbologyManagerServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := GeoSymbologyManagerServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: GeoSymbologyManagerServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'component accessing' }
GeoViewManagerImpl >> getGeoViewManagerCursorEventsNotifier [
	^self eventsNotifiers at: GeoViewManagerCursorEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: GeoViewManagerCursorEvents name: nil].
]

{ #category : #'component accessing' }
GeoViewManagerImpl >> getGeoViewManagerEventsNotifier [
	^self eventsNotifiers at: GeoViewManagerEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: GeoViewManagerEvents name: nil].
]

{ #category : #'component accessing' }
GeoViewManagerImpl >> getGeoViewManagerLayerEventsNotifier [
	^self eventsNotifiers at: GeoViewManagerLayerEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: GeoViewManagerLayerEvents name: nil].
]

{ #category : #'services - layer accessing' }
GeoViewManagerImpl >> getLayer: aKey [
	| layer |
	layer := self view getLayers detect:[ :l | l layerName = aKey ] ifNone:[nil].
	^layer
]

{ #category : #'services - layer accessing' }
GeoViewManagerImpl >> getLayers [
	^self view getLayers
]

{ #category : #'component accessing' }
GeoViewManagerImpl >> getMapProjectionManagerServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := MapProjectionManagerServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: MapProjectionManagerServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #scale }
GeoViewManagerImpl >> getScaleFactor [
	^self scaleFactor 
]

{ #category : #scale }
GeoViewManagerImpl >> getScaleInMeters [

	^ self scaleInMeters 
]

{ #category : #'component accessing' }
GeoViewManagerImpl >> getSmockSelectionManagerEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := SmockSelectionManagerEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: SmockSelectionManagerEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
GeoViewManagerImpl >> getSmockSelectionManagerServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := SmockSelectionManagerServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: SmockSelectionManagerServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #accessing }
GeoViewManagerImpl >> getView [
	^self view 
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> initializeComponents [

	self initializeProjectionManager.
	self initializeSymbologyManager.
	self initializeSelectionManager.
]

{ #category : #'events handling' }
GeoViewManagerImpl >> initializeEventStrategyStack [
	"Define a stack a event processing : strategy"

	eventStrategyStack := OrderedCollection new.
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> initializeProjectionManager [

	MolComponentManager default deploymentServices deployComponentImplementation: MapProjectionManagerImpl.
	MolComponentManager default homeServices instantiateComponent: MapProjectionManagerImpl named: self componentName
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> initializeSelectionManager [

	MolComponentManager default deploymentServices deployComponentImplementation: SmockSelectionManagerImpl.
	MolComponentManager default homeServices instantiateComponent: SmockSelectionManagerImpl named: self componentName
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> initializeSymbologyManager [

	MolComponentManager default deploymentServices deployComponentImplementation: GeoSymbologyProvider.
	MolComponentManager default homeServices instantiateComponent: GeoSymbologyProvider named: self componentName
]

{ #category : #initialization }
GeoViewManagerImpl >> initializeView [
	self setGeoCenter: AbsoluteCoordinates zero.
	self minScaleInMeters: 1852.0.
	self maxScaleInMeters: 1.5171584e7.
	self setScaleInMeters: 1.4816e7.
]

{ #category : #accessing }
GeoViewManagerImpl >> maxScaleInMeters [
	^ maxScaleInMeters
]

{ #category : #accessing }
GeoViewManagerImpl >> maxScaleInMeters: anObject [
	maxScaleInMeters := anObject.
]

{ #category : #accessing }
GeoViewManagerImpl >> minScaleInMeters [
	^ minScaleInMeters
]

{ #category : #accessing }
GeoViewManagerImpl >> minScaleInMeters: anObject [
	minScaleInMeters := anObject.
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> passivateComponents [
	MolComponentManager default homeServices passivateComponent: MapProjectionManagerImpl named: self componentName.
	MolComponentManager default homeServices passivateComponent: GeoSymbologyProvider named: self componentName.
	(MolComponentManager default homeServices instanceOf: SmockSelectionManagerImpl named: self componentName) ifNotNil:[
		MolComponentManager default homeServices passivateComponent: SmockSelectionManagerImpl named: self componentName.
	].
]

{ #category : #'services - picking' }
GeoViewManagerImpl >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"Return all geo objects under aPoint with a radius in pixels"
	| pickingResult absoluteCoordinates |
	aGlobalPoint ifNil: [ ^ nil ].
	absoluteCoordinates := self getAbsoluteCoordinatesFromGlobalPoint: aGlobalPoint.
	
	"create picking result"
	pickingResult := GeoViewPickingResult new
		date: Date today;
		time: Time now;
		globalPoint: aGlobalPoint copy;
		cartesianCoordinates: (self getMapProjectionManagerServicesProvider getProjection projLatLonToCart: absoluteCoordinates);
		absoluteCoordinates: absoluteCoordinates;
		radiusInPixels: aRadiusInPixels;
		yourself.

	^ pickingResult 
]

{ #category : #private }
GeoViewManagerImpl >> receiveLayerUpdateFrom: aLayer [

	self getGeoViewManagerLayerEventsNotifier layerUpdated: (aLayer layerName) view: (self componentName).
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> removeComponents [
	MolComponentManager default homeServices removeComponent: MapProjectionManagerImpl named: self componentName.
	MolComponentManager default homeServices removeComponent: GeoSymbologyProvider named: self componentName.
	(MolComponentManager default homeServices instanceOf: SmockSelectionManagerImpl named: self componentName) ifNotNil:[
		MolComponentManager default homeServices removeComponent: SmockSelectionManagerImpl named: self componentName.
	].
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> removeGeoObject: aGeoObject [
	self view removeGeoObject: aGeoObject
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> removeGeoObjects: aGeoObjectList [
	self view removeGeoObjects: aGeoObjectList
]

{ #category : #scale }
GeoViewManagerImpl >> scaleDown [
	self flag: 'PLA : faire un fonctionnement par pallier'.
	self setScaleInMeters: self scaleInMeters * self scaleFactor
]

{ #category : #accessing }
GeoViewManagerImpl >> scaleFactor [
	scaleFactor isNil ifTrue:[scaleFactor := 2].
	^ scaleFactor
]

{ #category : #accessing }
GeoViewManagerImpl >> scaleFactor: anObject [
	scaleFactor := anObject
]

{ #category : #accessing }
GeoViewManagerImpl >> scaleInMeters [
	^ scaleInMeters
]

{ #category : #accessing }
GeoViewManagerImpl >> scaleInMeters: anObject [
	scaleInMeters := anObject
]

{ #category : #scale }
GeoViewManagerImpl >> scaleUp [
	self flag:'PLA : faire un fonctionnement par pallier'.
	self setScaleInMeters: self scaleInMeters / self scaleFactor
]

{ #category : #'events - selection manager' }
GeoViewManagerImpl >> selectedKeysHasChanged: aCollection [
	self view selectedGeoObjectKeys: aCollection.
]

{ #category : #'events - selection manager' }
GeoViewManagerImpl >> selectionCleared [
	self selectedKeysHasChanged: OrderedCollection new
]

{ #category : #'event strategy' }
GeoViewManagerImpl >> setEventBehaviors: anEventBehaviorList [

	self deleteEventBehaviors.
	anEventBehaviorList do:[ :e | self addEventBehavior: e ].
]

{ #category : #'projection center' }
GeoViewManagerImpl >> setGeoCenter: anAbsoluteCoordinates [
	self geoCenter: anAbsoluteCoordinates copy.
]

{ #category : #initialization }
GeoViewManagerImpl >> setGeoObjectsIndexAccessor: aSymbol [
	self geoObjectsIndexAccessor: aSymbol.
]

{ #category : #scale }
GeoViewManagerImpl >> setScaleFactor: aNumber [
	^self scaleFactor: aNumber
]

{ #category : #scale }
GeoViewManagerImpl >> setScaleInMeters: aNumber [
	| scale |
	scale := self evaluateScale: aNumber.
	"scale := self correctedScale: aNumber."
	self scaleInMeters: scale.
]

{ #category : #'selection manager' }
GeoViewManagerImpl >> setSmockSelectionManager: aSmockSelectionManager [
	"Set a selection manager to manage the selection"
	| component |
	(aSmockSelectionManager isNil or:[(aSmockSelectionManager isComponent not) or:[aSmockSelectionManager componentName isNil]]) ifTrue:[^ self].
	
	"Check if the internal component is already initialized or activated and remove it"
	component := (MolComponentManager default homeServices instanceOf: SmockSelectionManagerImpl named: self componentName).
	component ifNotNil:[MolComponentManager default homeServices removeComponent: SmockSelectionManagerImpl named: self componentName].
	
	"Affect the new component"
	self forServices: SmockSelectionManagerServices useProvider: aSmockSelectionManager componentName.
	
	
	
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> updateGeoObject: aGeoObject [
	self view updateGeoObject: aGeoObject
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> updateGeoObjects: aGeoObjectList [
	self view updateGeoObjects: aGeoObjectList
]

{ #category : #accessing }
GeoViewManagerImpl >> view [
	^ view
]

{ #category : #accessing }
GeoViewManagerImpl >> view: anObject [
	view := anObject
]
