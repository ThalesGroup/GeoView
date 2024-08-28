"
I am the generic GeoviewManager implementation.
"
Class {
	#name : #GeoViewManagerImpl,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'GeoViewManager + GeoViewManagerObjectsServices + GeoViewManagerParameters + GeoViewManagerGeoObjectsParameters + GeoViewManagerServices + GeoViewManagerPickingServices + GeoViewManagerLayerServices + SmockSelectionManagerEvents',
	#classTraits : 'GeoViewManager classTrait + GeoViewManagerObjectsServices classTrait + GeoViewManagerParameters classTrait + GeoViewManagerGeoObjectsParameters classTrait + GeoViewManagerServices classTrait + GeoViewManagerPickingServices classTrait + GeoViewManagerLayerServices classTrait + SmockSelectionManagerEvents classTrait',
	#instVars : [
		'view',
		'geoCenter',
		'scaleInMeters',
		'minScaleInMeters',
		'maxScaleInMeters',
		'scaleFactor',
		'inputContext',
		'objectIndexAccessor'
	],
	#category : #'GeoView-Molecule'
}

{ #category : #'aggregated components' }
GeoViewManagerImpl >> activateComponents [

	MapProjectionManagerImpl activate: self componentName.
	(MolComponentManager default homeServices isWaitingForActivation: SmockSymbologyProvider named: self componentName) ifTrue:[
		SmockSymbologyProvider activate: self componentName.
	].
	(MolComponentManager default homeServices isWaitingForActivation: SmockSelectionManagerImpl named: self componentName) ifTrue:[
		SmockSelectionManagerImpl activate: self componentName.
	].
]

{ #category : #'services - layer creation' }
GeoViewManagerImpl >> addLayer: aLayer [
	"(aLayer class traitComposition allTraits includes: GeoViewLayer) ifFalse:[^nil]."
	self flag:'labordep : regarder les traits dans lheritage pour être sûr que cest une layer ?'.
	aLayer layerName ifNil:[^nil].
	
	aLayer projection: self getMapProjectionManagerServicesProvider getProjection.
	aLayer symbologyProvider: self getSmockSymbologyManagerServicesProvider.
	aLayer whenProcessDatasChangedDo: [ :l | self layerHasBeenUpdated: l	]. 
	self view addLayer: aLayer.
	
	self getGeoViewManagerLayerEventsNotifier geoViewLayerAdded: aLayer layerName in: self componentName
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> addObject: aGeoObject [

	self view addObject: aGeoObject
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> addObjects: aGeoObjectList [

	(aGeoObjectList isNil or: [ aGeoObjectList isEmpty ]) ifTrue: [ ^ self ].
	self view addObjects: aGeoObjectList
]

{ #category : #services }
GeoViewManagerImpl >> centerOnPoint: aGlobalPoint [
	"Center the map on a global point"
	| absoluteCoordinates |
	absoluteCoordinates := self getAbsoluteCoordinatesFromGlobalPoint: aGlobalPoint.
	self setGeoCenter: absoluteCoordinates.
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentActivate [

	self activateComponents.
	self getSmockSelectionManagerEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentInitialize [

	super componentInitialize.

	self forServices: MapProjectionManagerServices useProvider: self componentName.

	self initializeProjectionManager.
	self initializeSelectionManager.
	self initializeSymbologyManager.
	
	self createView.
	self initializeInputContext.
	self initializeView.
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentPassivate [

	self getSmockSelectionManagerEventsSubscriber unsubscribe: self.
	self passivateComponents
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentRemove [

	self removeComponents
]

{ #category : #private }
GeoViewManagerImpl >> correctedScale: aNumberInMeters [
"Enlarge view on Mercator projection near the poles : used for decrease zoom effect when projection changes"
	self getMapProjectionManagerServicesProvider getProjection key = #GeoViewMercatorProjection
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
	self deprecated:'use createAndAddLayer:'.
	aKey ifNil:[ SmockNoIdError signal: 'Cannot add layer with nil key.'. ^ nil ].
	
	existingLayer := self getLayer: aKey.
	existingLayer ifNotNil:[ SmockDuplicateIdError signal: 'Cannot add layer with already existing key.'. ^ nil ].
		
	layer := self createLayer: aKey.
	^self addLayer: layer
]

{ #category : #'services - layer creation' }
GeoViewManagerImpl >> createAndAddLayer: aKey [

	| layer |
	layer := self createLayer: aKey.
	layer ifNil:[ ^ nil ].
	
	self addLayer: layer.
	^ layer
]

{ #category : #'layer creation' }
GeoViewManagerImpl >> createLayer: aKey [
	self subclassResponsibility 
]

{ #category : #initialization }
GeoViewManagerImpl >> createView [
	self subclassResponsibility 
]

{ #category : #'private - events' }
GeoViewManagerImpl >> dispatchUIEvent: aSmockEventWrapper [
	"Transfert event in input strategy stack to each behavior processors"

	inputContext ifNil: [ ^ self ].
	inputContext handleEvent: aSmockEventWrapper
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

{ #category : #'layer accessing' }
GeoViewManagerImpl >> getGeoCenter [
	^ self geoCenter
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
	layer := self view getLayers
		         detect: [ :l | l layerName = aKey ]
		         ifNone: [ nil ].
	^ layer
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

{ #category : #'parameters - objects' }
GeoViewManagerImpl >> getObjectIndexAccessor [

	^ objectIndexAccessor ifNil:[ objectIndexAccessor := #key ]
]

{ #category : #services }
GeoViewManagerImpl >> getScaleFactor [
	^self scaleFactor 
]

{ #category : #services }
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

{ #category : #'component accessing' }
GeoViewManagerImpl >> getSmockSymbologyManagerServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := SmockSymbologyManagerServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: SmockSymbologyManagerServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #services }
GeoViewManagerImpl >> getView [

	^ self view
]

{ #category : #'private - events' }
GeoViewManagerImpl >> handleUIEvent: anEvent [

	| wrapper |
	wrapper := SmockEventWrapper wrap: anEvent.
	self dispatchUIEvent: wrapper.
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> haveObjectIndex: anIndex [

	^ self view haveObjectIndex: anIndex
]

{ #category : #initialization }
GeoViewManagerImpl >> initializeInputContext [

	inputContext := SmockInputContext new.
	inputContext controller: self.
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> initializeProjectionManager [

	MolComponentManager default deploymentServices deployComponentImplementation: MapProjectionManagerImpl.
	MolComponentManager default homeServices instantiateComponent: MapProjectionManagerImpl named: self componentName
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> initializeSelectionManager [

	(MolUtils isInstantiateComponentOf: SmockSelectionManagerImpl named: self componentName) ifFalse:[
		SmockSelectionManagerImpl deploy.
		SmockSelectionManagerImpl instantiate: self componentName
	].

	self setSelectionManagerName: self componentName.
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> initializeSymbologyManager [

	(MolUtils isInstantiateComponentOf: SmockSymbologyProvider named: self componentName) ifFalse:[
		SmockSymbologyProvider deploy.
		SmockSymbologyProvider instantiate: self componentName.
	].
	
	self setSymbologyManagerName: self componentName.
]

{ #category : #initialization }
GeoViewManagerImpl >> initializeView [

	self setGeoCenter: AbsoluteCoordinates zero.
	self minScaleInMeters: 1852.0.
	self maxScaleInMeters: 1.5171584e7.
	self setScaleInMeters: 1.4816e7.
]

{ #category : #'private - events' }
GeoViewManagerImpl >> layerHasBeenUpdated: aLayer [

	self getGeoViewManagerLayerEventsNotifier geoViewLayerUpdated: (aLayer layerName) in: (self componentName).
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

{ #category : #'private - events' }
GeoViewManagerImpl >> mouseCursorCoordinatesChanged: anAbsoluteCoordinates [

	| cursor |
	cursor := SmockCursor new.
	cursor key: #mouse.
	cursor coordinates: anAbsoluteCoordinates.
	cursor source: (self class componentType -> self componentName).
	
	self getGeoViewManagerCursorEventsNotifier cursorHasChanged: cursor
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> passivateComponents [

	MapProjectionManagerImpl passivate: self componentName.	
	(MolComponentManager default homeServices instanceOf: SmockSymbologyProvider named: self componentName) ifNotNil:[
		SmockSymbologyProvider passivate: self componentName.
	].
	(MolComponentManager default homeServices instanceOf: SmockSelectionManagerImpl named: self componentName) ifNotNil:[
		SmockSelectionManagerImpl passivate: self componentName.
	].
]

{ #category : #'services - picking' }
GeoViewManagerImpl >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"Return all geo objects under aPoint with a radius in pixels"
	
	| pickingResult absoluteCoordinates localPoint radius |
	absoluteCoordinates := (self getAbsoluteCoordinatesFromGlobalPoint: aGlobalPoint) ifNil:[ ^ nil ].
	localPoint := (self getLocalPointFromGlobalPoint: aGlobalPoint) ifNil:[ ^ nil ].
	radius := aRadiusInPixels ifNil:[ 0 ].
	
	"create picking result"
	pickingResult := GeoViewPickingResult new
		timestamp: DateAndTime now;
		globalPoint: aGlobalPoint;
		localPoint: localPoint;
		cartesianCoordinates: (self getMapProjectionManagerServicesProvider getProjection projLatLonToCart: absoluteCoordinates);
		absoluteCoordinates: absoluteCoordinates;
		radiusInPixels: radius;
		yourself.

	^ pickingResult 
]

{ #category : #'services - layer deletion' }
GeoViewManagerImpl >> removeAllLayers [
	| layers |
	layers := self view getLayers.
	layers do:[ :l | (self view removeLayer: l) ifNotNil:[ self getGeoViewManagerLayerEventsNotifier geoViewLayerRemoved: l layerName in: self componentName ]].
	^layers
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> removeComponents [

	MapProjectionManagerImpl remove: self componentName.
	(MolComponentManager default homeServices instanceOf: SmockSymbologyProvider named: self componentName) ifNotNil:[
		SmockSymbologyProvider remove: self componentName.
	].
	(MolComponentManager default homeServices instanceOf: SmockSelectionManagerImpl named: self componentName) ifNotNil:[
		SmockSelectionManagerImpl remove: self componentName.
	].
]

{ #category : #'services - layer deletion' }
GeoViewManagerImpl >> removeLayer: aKey [
	| layer |
	aKey ifNil:[^nil].
	layer := self getLayer: aKey.
	layer ifNil:[^nil].
	layer := self view removeLayer: layer.
	layer ifNotNil:[self getGeoViewManagerLayerEventsNotifier geoViewLayerRemoved: aKey in: self componentName].
	^layer
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> removeObject: aGeoObject [

	self view removeObject: aGeoObject
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> removeObjects: aGeoObjectList [

	self view removeObjects: aGeoObjectList
]

{ #category : #services }
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

{ #category : #services }
GeoViewManagerImpl >> scaleUp [
	self flag:'PLA : faire un fonctionnement par pallier'.
	self setScaleInMeters: self scaleInMeters / self scaleFactor
]

{ #category : #'events - selection manager' }
GeoViewManagerImpl >> selectedKeysHasChanged: aSmockSelection [

	self view selectedObjectIndexes: aSmockSelection keys
]

{ #category : #'events - selection manager' }
GeoViewManagerImpl >> selectionCleared [

	self view selectedObjectIndexes: OrderedCollection new
]

{ #category : #services }
GeoViewManagerImpl >> setGeoCenter: anAbsoluteCoordinates [

	self geoCenter: anAbsoluteCoordinates copy
]

{ #category : #'parameters - objects' }
GeoViewManagerImpl >> setObjectIndexAccessor: aSymbol [

	objectIndexAccessor = aSymbol ifTrue:[ ^ self ].
	objectIndexAccessor := aSymbol.
	self flag:'labordep : update the model when changed ?'.
]

{ #category : #services }
GeoViewManagerImpl >> setScaleFactor: aNumber [

	self scaleFactor: aNumber
]

{ #category : #services }
GeoViewManagerImpl >> setScaleInMeters: aNumber [
	| scale |
	scale := self evaluateScale: aNumber.
	"scale := self correctedScale: aNumber."
	self scaleInMeters: scale.
]

{ #category : #'parameters - selection manager' }
GeoViewManagerImpl >> setSelectionManager: aSmockSelectionManager [
	"Set a selection manager to manage the selection"
	| component |
	
	self deprecated:'not use, use setSelectionManagerName: aComponentName'.
	self flag:'labordep: ecrire setSelectionManagerName: et cabler proprement avec la mécanique molecule'.
	(aSmockSelectionManager isNil or:[(aSmockSelectionManager isComponent not) or:[aSmockSelectionManager componentName isNil]]) ifTrue:[^ self].
	
	"Check if the internal component is already initialized or activated and remove it"
	component := (MolComponentManager default homeServices instanceOf: SmockSelectionManagerImpl named: self componentName).
	component ifNotNil:[MolComponentManager default homeServices removeComponent: SmockSelectionManagerImpl named: self componentName].
	
	"Affect the new component"
	self forServices: SmockSelectionManagerServices useProvider: aSmockSelectionManager componentName.
	
	
	
]

{ #category : #'parameters - selection manager' }
GeoViewManagerImpl >> setSelectionManagerName: aComponentName [
	"Setup a selection manager"
	
	self forServices: SmockSelectionManagerServices useProvider: aComponentName.
	self forEvents: SmockSelectionManagerEvents useProducer: aComponentName.
	
	self flag:'labordep: faire une mise à jour de la selection si changement de selection manager et stopper le composant précédent si démarré'.
]

{ #category : #'parameters - selection manager' }
GeoViewManagerImpl >> setSymbologyManagerName: aComponentName [
	"Setup a symbology manager"
	
	self forServices: SmockSymbologyManagerServices useProvider: aComponentName.
	self forEvents: SmockSymbologyManagerEvents useProducer: aComponentName.
	
	self flag:'labordep: faire une mise à jour de la vue si changement de symbology manager et stopper le composant précédent si démarré'.
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> updateObject: aGeoObject [

	self view updateObject: aGeoObject
]

{ #category : #'geobjects aur' }
GeoViewManagerImpl >> updateObjects: aGeoObjectList [

	self view updateObjects: aGeoObjectList
]

{ #category : #accessing }
GeoViewManagerImpl >> view [
	^ view
]

{ #category : #accessing }
GeoViewManagerImpl >> view: anObject [
	view := anObject
]
