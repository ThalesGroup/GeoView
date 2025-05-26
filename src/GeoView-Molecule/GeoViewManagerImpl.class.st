"
I am the generic GeoviewManager implementation.
"
Class {
	#name : #GeoViewManagerImpl,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'GeoViewManager + GeoViewManagerObjectsServices + GeoViewManagerParameters + GeoViewManagerServices + GeoViewManagerPickingServices + SmockSelectionManagerEvents + SmockSymbologyManagerEvents',
	#classTraits : 'GeoViewManager classTrait + GeoViewManagerObjectsServices classTrait + GeoViewManagerParameters classTrait + GeoViewManagerServices classTrait + GeoViewManagerPickingServices classTrait + SmockSelectionManagerEvents classTrait + SmockSymbologyManagerEvents classTrait',
	#instVars : [
		'view'
	],
	#category : #'GeoView-Molecule-Impl'
}

{ #category : #'aggregated components' }
GeoViewManagerImpl >> activateComponents [

	(MolComponentManager default homeServices
		 isWaitingForActivation: SmockSymbologyManagerImpl
		 named: self componentName) ifTrue: [
		SmockSymbologyManagerImpl activate: self componentName ].

	(MolComponentManager default homeServices
		 isWaitingForActivation: SmockSelectionManagerImpl
		 named: self componentName) ifTrue: [
		SmockSelectionManagerImpl activate: self componentName ]
]

{ #category : #'services - layer' }
GeoViewManagerImpl >> addLayer: aLayer [

	aLayer name ifNil: [ ^ nil ].
	self configureLayer: aLayer.
	self view addLayer: aLayer
]

{ #category : #'services - object' }
GeoViewManagerImpl >> addObject: aGeoObject [

	self view addObject: aGeoObject
]

{ #category : #'services - object' }
GeoViewManagerImpl >> addObjects: aGeoObjectList [

	self view addObjects: aGeoObjectList
]

{ #category : #services }
GeoViewManagerImpl >> centerOnPoint: aGlobalPoint [
	"Center the map on a global point"

	| absoluteCoordinates |
	absoluteCoordinates := self getAbsoluteCoordinatesFromGlobalPoint: aGlobalPoint.
	self setGeoCenter: absoluteCoordinates
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentActivate [

	super componentActivate.

	self activateComponents.
	self getSmockSelectionManagerEventsSubscriber subscribe: self.
	self getSmockSymbologyManagerEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentInitialize [

	super componentInitialize.
	
	self initializeSelectionManager.
	self initializeSymbologyManager.
	
	self createView
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentPassivate [

	self getSmockSymbologyManagerEventsSubscriber unsubscribe: self.
	self getSmockSelectionManagerEventsSubscriber unsubscribe: self.
	self passivateComponents.
	
	super componentPassivate
]

{ #category : #'life cycle' }
GeoViewManagerImpl >> componentRemove [

	self removeComponents.

	super componentRemove
]

{ #category : #private }
GeoViewManagerImpl >> configureLayer: aLayer [

	aLayer symbologyProvider: self getSmockSymbologyManagerServicesProvider.
]

{ #category : #'services - layer' }
GeoViewManagerImpl >> createAndAddDomainObjectsLayer: aKey [

	| layer |
	layer := self createDomainObjectsLayer: aKey.
	layer ifNil:[ ^ nil ].
	
	self addLayer: layer.
	^ layer
]

{ #category : #'private - layer' }
GeoViewManagerImpl >> createDomainObjectsLayer: aName [

	| layer |
	layer := GeoViewDomainObjectsLayer new.
	layer name: aName.
	^ layer
]

{ #category : #initialization }
GeoViewManagerImpl >> createView [

	self subclassResponsibility
]

{ #category : #services }
GeoViewManagerImpl >> getAbsoluteCoordinatesFromGlobalPoint: aGlobalPoint [

	^ self getView absoluteCoordinatesFromGlobalPoint: aGlobalPoint 
]

{ #category : #services }
GeoViewManagerImpl >> getAbsoluteCoordinatesFromLocalPoint: aLocalPoint [

	^ self getView absoluteCoordinatesFromLocalPoint: aLocalPoint
]

{ #category : #'parameters - graphic projection' }
GeoViewManagerImpl >> getDisplayToGraphicProjection [

	^ self getView displayToGraphicProjection
]

{ #category : #services }
GeoViewManagerImpl >> getGeoCenter [ 

	^ self getView geoCenter 
]

{ #category : #'component accessing' }
GeoViewManagerImpl >> getGeoViewManagerCursorEventsNotifier [
	^self eventsNotifiers at: GeoViewManagerCursorEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: GeoViewManagerCursorEvents name: nil].
]

{ #category : #'component accessing' }
GeoViewManagerImpl >> getGeoViewManagerEventsNotifier [
	^self eventsNotifiers at: GeoViewManagerEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: GeoViewManagerEvents name: nil].
]

{ #category : #services }
GeoViewManagerImpl >> getGlobalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [

	^ self getView globalPointFromAbsoluteCoordinates: anAbsoluteCoordinates 
]

{ #category : #services }
GeoViewManagerImpl >> getGlobalPointFromLocalPoint: aLocalPoint [

	^ self getView globalPointFromLocalPoint: aLocalPoint 
]

{ #category : #'services - layer' }
GeoViewManagerImpl >> getLayer: aKey [

	^ self view getLayer: aKey
]

{ #category : #'services - layer' }
GeoViewManagerImpl >> getLayers [

	^ self view getLayers
]

{ #category : #services }
GeoViewManagerImpl >> getLocalPointFromAbsoluteCoordinates: anAbsoluteCoordinates [

	^ self getView localPointFromAbsoluteCoordinates: anAbsoluteCoordinates 
]

{ #category : #services }
GeoViewManagerImpl >> getLocalPointFromGlobalPoint: aGlobalPoint [

	^ self getView localPointFromGlobalPoint: aGlobalPoint 
]

{ #category : #'services - map projection' }
GeoViewManagerImpl >> getMapProjection [

	^ self view mapProjection 
]

{ #category : #'parameters - objects' }
GeoViewManagerImpl >> getObjectIndexAccessor [

	^ self view objectIndexAccessor 
]

{ #category : #services }
GeoViewManagerImpl >> getScaleFactor [

	^ self view scaleFactor 
]

{ #category : #services }
GeoViewManagerImpl >> getScaleInMeters [

	^ self view scaleInMeters 
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
GeoViewManagerImpl >> getSmockSymbologyManagerEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := SmockSymbologyManagerEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: SmockSymbologyManagerEvents named: eventsSymbol ]. 
	^eventsSubscriber
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

{ #category : #'parameters - view infos' }
GeoViewManagerImpl >> getViewInfos [

	^ self view viewInfos
]

{ #category : #'services - object' }
GeoViewManagerImpl >> haveObjectIndex: anIndex [

	^ self view haveObjectIndex: anIndex
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> initializeSelectionManager [
	"If a selection manager not exists, instanciate one"

	(MolUtils allComponentInstancesOfType: SmockSelectionManager)
		ifEmpty: [
			SmockSelectionManagerImpl deploy.
			SmockSelectionManagerImpl instantiate: self componentName.
			self setSelectionManagerName: self componentName ]
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> initializeSymbologyManager [
	"If a symbology manager not exists, instanciate one"

	(MolUtils allComponentInstancesOfType: SmockSymbologyManager)
		ifEmpty: [
			SmockSymbologyManagerImpl deploy.
			SmockSymbologyManagerImpl instantiate: self componentName.
			self setSymbologyManagerName: self componentName ]
]

{ #category : #'private - events' }
GeoViewManagerImpl >> layerAdded: anEvent [

	self getGeoViewManagerEventsNotifier geoViewLayerAdded: anEvent layerName in: self componentName
]

{ #category : #'private - events' }
GeoViewManagerImpl >> layerHasBeenUpdated: anEvent [

	self getGeoViewManagerEventsNotifier geoViewLayerUpdated: anEvent layerName in: self componentName.
]

{ #category : #'private - events' }
GeoViewManagerImpl >> layerRemoved: anEvent [

	self getGeoViewManagerEventsNotifier geoViewLayerRemoved: anEvent layerName in: self componentName
]

{ #category : #'private - events' }
GeoViewManagerImpl >> mapProjectionHasChanged: anEvent [

	self getGeoViewManagerEventsNotifier mapProjectionHasChanged: anEvent projection in: self componentName
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

	(MolComponentManager default homeServices
		 instanceOf: SmockSymbologyManagerImpl
		 named: self componentName) ifNotNil: [
		SmockSymbologyManagerImpl passivate: self componentName ].
	
	(MolComponentManager default homeServices
		 instanceOf: SmockSelectionManagerImpl
		 named: self componentName) ifNotNil: [
		SmockSelectionManagerImpl passivate: self componentName ]
]

{ #category : #'services - picking' }
GeoViewManagerImpl >> pickAt: aGlobalPoint [
	"Return all objects under a global point"

	^ self view pickAt: aGlobalPoint
]

{ #category : #'services - picking' }
GeoViewManagerImpl >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"Return all objects under a global point inside a radius in pixels"
	
	^ self view pickAt: aGlobalPoint radius: aRadiusInPixels
]

{ #category : #'services - layer' }
GeoViewManagerImpl >> removeAllLayers [

	| layers |
	layers := self view removeAllLayers.
	layers do: [ :l | self unconfigureLayer: l ].
	^ layers
]

{ #category : #'aggregated components' }
GeoViewManagerImpl >> removeComponents [

	(MolComponentManager default homeServices
		 instanceOf: SmockSymbologyManagerImpl
		 named: self componentName) ifNotNil: [
		SmockSymbologyManagerImpl remove: self componentName ].
	
	(MolComponentManager default homeServices
		 instanceOf: SmockSelectionManagerImpl
		 named: self componentName) ifNotNil: [
		SmockSelectionManagerImpl remove: self componentName ]
]

{ #category : #'services - layer' }
GeoViewManagerImpl >> removeLayer: aKey [

	| layer |
	aKey ifNil: [ ^ nil ].
	layer := (self getLayer: aKey) ifNil: [ ^ nil ].
	self view removeLayer: layer.
	self unconfigureLayer: layer.
	
	^ layer
]

{ #category : #'services - object' }
GeoViewManagerImpl >> removeObject: aGeoObject [

	self view removeObject: aGeoObject
]

{ #category : #'services - object' }
GeoViewManagerImpl >> removeObjects: aGeoObjectList [

	self view removeObjects: aGeoObjectList
]

{ #category : #services }
GeoViewManagerImpl >> scaleDown [
	
	self view scaleDown
]

{ #category : #services }
GeoViewManagerImpl >> scaleUp [
	
	self view scaleUp
]

{ #category : #'events - selection manager' }
GeoViewManagerImpl >> selectionHasChanged: aSmockSelection [

	self view selectedObjectIndexes: aSmockSelection keys
]

{ #category : #'parameters - graphic projection' }
GeoViewManagerImpl >> setDisplayToGraphicProjection: aGeoView2DProjection [

	self getView displayToGraphicProjection: aGeoView2DProjection
]

{ #category : #services }
GeoViewManagerImpl >> setGeoCenter: anAbsoluteCoordinates [

	self view geoCenter: anAbsoluteCoordinates
]

{ #category : #'services - map projection' }
GeoViewManagerImpl >> setMapProjection: aMapProjection [

	self view mapProjection: aMapProjection
]

{ #category : #'parameters - objects' }
GeoViewManagerImpl >> setObjectIndexAccessor: aSymbol [

	self getView objectIndexAccessor: aSymbol 
]

{ #category : #services }
GeoViewManagerImpl >> setScaleFactor: aNumber [

	self view scaleFactor: aNumber
]

{ #category : #services }
GeoViewManagerImpl >> setScaleInMeters: aNumber [

	self view scaleInMeters: aNumber
]

{ #category : #'parameters - selection manager' }
GeoViewManagerImpl >> setSelectionManagerName: aComponentName [
	"Setup a selection manager"

	self
		forServices: SmockSelectionManagerServices
		useProvider: aComponentName.
		
	self
		forEvents: SmockSelectionManagerEvents
		useProducer: aComponentName
]

{ #category : #'parameters - selection manager' }
GeoViewManagerImpl >> setSymbologyManagerName: aComponentName [
	"Setup a symbology manager"

	self
		forServices: SmockSymbologyManagerServices
		useProvider: aComponentName.
		
	self
		forEvents: SmockSymbologyManagerEvents
		useProducer: aComponentName
]

{ #category : #'parameters - view infos' }
GeoViewManagerImpl >> setViewInfos: aGeoViewInfos [

	self view viewInfos: aGeoViewInfos 
]

{ #category : #'private - selection' }
GeoViewManagerImpl >> strategyRequestAddSelection: anObjectIndexesList [

	anObjectIndexesList isEmpty ifTrue:[ ^ self ].
	self getSmockSelectionManagerServicesProvider addSelectedKeys: anObjectIndexesList
]

{ #category : #'private - selection' }
GeoViewManagerImpl >> strategyRequestClearSelection [

	self getSmockSelectionManagerServicesProvider clearSelection
]

{ #category : #'private - selection' }
GeoViewManagerImpl >> strategyRequestRemoveSelection: anObjectIndexesList [

	anObjectIndexesList isEmpty ifTrue:[ ^ self ].
	self getSmockSelectionManagerServicesProvider removeSelectedKeys: anObjectIndexesList
]

{ #category : #'private - selection' }
GeoViewManagerImpl >> strategyRequestSetSelection: anObjectIndexesList [

	self getSmockSelectionManagerServicesProvider setSelectedKeys: anObjectIndexesList
]

{ #category : #'events - symbology manager' }
GeoViewManagerImpl >> symbologyHasChanged: aSymbologyKey [
	"update all symbols - need to update all DCompositeShapes"

	self view updateModel: GeoViewSymbologyChanges new
]

{ #category : #private }
GeoViewManagerImpl >> unconfigureLayer: aLayer [

	aLayer symbologyProvider: nil
]

{ #category : #'services - object' }
GeoViewManagerImpl >> updateObject: aGeoObject [

	self view updateObject: aGeoObject
]

{ #category : #'services - object' }
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
