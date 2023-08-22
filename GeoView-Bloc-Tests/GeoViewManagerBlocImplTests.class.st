Class {
	#name : #GeoViewManagerBlocImplTests,
	#superclass : #TestCase,
	#instVars : [
		'geoViewManagerName',
		'geoViewManager'
	],
	#category : #'GeoView-Bloc-Tests-Cases - GeoViewManager'
}

{ #category : #running }
GeoViewManagerBlocImplTests >> setUp [
	super setUp.
	geoViewManagerName := #myGeoViewManager.
	MolComponentManager cleanUp.
	MolComponentManager default deploymentServices deployComponentImplementation: GeoViewManagerBlocImpl.
	geoViewManager := MolComponentManager default homeServices instanciateComponent: GeoViewManagerBlocImpl named: geoViewManagerName.
	MolComponentManager default homeServices activateComponent: GeoViewManagerBlocImpl named: geoViewManagerName.
]

{ #category : #running }
GeoViewManagerBlocImplTests >> tearDown [
	super tearDown.
	MolComponentManager default homeServices passivateComponent: GeoViewManagerBlocImpl named: geoViewManagerName.
	MolComponentManager default homeServices removeComponent: GeoViewManagerBlocImpl named: geoViewManagerName.
	geoViewManager := nil.
	geoViewManagerName := nil.
	MolComponentManager default deploymentServices undeployComponentImplementation: GeoViewManagerBlocImpl.
	MolComponentManager cleanUp.
]

{ #category : #tests }
GeoViewManagerBlocImplTests >> testAURGeoObject [
	| geoObject layer1 layer2 layer3 |
	layer1 := BlGeoViewLayer new layerName: #layer1.
	layer2 := BlGeoViewObjectLayer new layerName: #layer2.
	layer3 := BlGeoViewObjectLayer new layerName: #layer3.
	layer2 setProcessData: GeoCircleProcessData new for: GeoCircle.
	layer3 setProcessData: GeoCircleProcessData new for: GeoCircle.
	geoViewManager addLayer: layer1.
	geoViewManager addLayer: layer2.
	geoViewManager addLayer: layer3.
	
	geoObject := GeoCircle new key: 1.
	geoViewManager addGeoObject: geoObject.
	self assert: layer1 displayProjectionModel datas size equals: 0.
	self assert: layer2 displayProjectionModel datas size equals: 1.
	self assert: layer3 displayProjectionModel datas size equals: 1.
	
	geoViewManager updateGeoObject: geoObject.
	self assert: layer1 displayProjectionModel datas size equals: 0.
	self assert: layer2 displayProjectionModel datas size equals: 1.
	self assert: layer3 displayProjectionModel datas size equals: 1.
	
	geoViewManager removeGeoObject: geoObject.
	self assert: layer1 displayProjectionModel datas size equals: 0.
	self assert: layer2 displayProjectionModel datas size equals: 0.
	self assert: layer3 displayProjectionModel datas size equals: 0.
]

{ #category : #tests }
GeoViewManagerBlocImplTests >> testAURGeoObjects [
	| layer1 layer2 layer3 geoObjects |
	layer1 := BlGeoViewLayer new layerName: #layer1.
	layer2 := BlGeoViewObjectLayer new layerName: #layer2.
	layer3 := BlGeoViewObjectLayer new layerName: #layer3.
	layer2 setProcessData: GeoCircleProcessData new for: GeoCircle.
	layer3 setProcessData: GeoCircleProcessData new for: GeoCircle.
	geoViewManager addLayer: layer1.
	geoViewManager addLayer: layer2.
	geoViewManager addLayer: layer3.
	
	geoObjects := OrderedCollection new.
	1 to: 100 do:[ :i | geoObjects add: (GeoCircle new key: i) ].
	geoViewManager addGeoObjects: geoObjects.
	self assert: layer1 displayProjectionModel datas size equals: 0.
	self assert: layer2 displayProjectionModel datas size equals: 100.
	self assert: layer3 displayProjectionModel datas size equals: 100.
	
	geoViewManager updateGeoObjects: geoObjects.
	self assert: layer1 displayProjectionModel datas size equals: 0.
	self assert: layer2 displayProjectionModel datas size equals: 100.
	self assert: layer3 displayProjectionModel datas size equals: 100.
	
	geoViewManager removeGeoObjects: geoObjects.
	self assert: layer1 displayProjectionModel datas size equals: 0.
	self assert: layer2 displayProjectionModel datas size equals: 0.
	self assert: layer3 displayProjectionModel datas size equals: 0.
]

{ #category : #tests }
GeoViewManagerBlocImplTests >> testAddGeoObjectAndAddAnotherLayer [
	| geoObject layer1 layer2 |
	layer1 := BlGeoViewObjectLayer new layerName: #layer1.
	layer1 setProcessData: GeoCircleProcessData new for: GeoCircle.
	geoViewManager addLayer: layer1.
	layer2 := BlGeoViewObjectLayer new layerName: #layer2.
	layer2 setProcessData: GeoCircleProcessData new for: GeoCircle.
	geoObject := GeoCircle new key: 1.
	geoViewManager addGeoObject: geoObject.
	self assert: layer1 displayProjectionModel datas size equals: 1.
	self assert: layer1 graphicProjectionModel datas size equals: 1.
	self assert: layer2 displayProjectionModel datas size equals: 0.
	self assert: layer2 graphicProjectionModel datas size equals: 0.
	
	geoViewManager addLayer: layer2.
	self assert: layer1 displayProjectionModel datas size equals: 1.
	self assert: layer1 graphicProjectionModel datas size equals: 1.
	self assert: layer2 displayProjectionModel datas size equals: 0.
	self assert: layer2 graphicProjectionModel datas size equals: 0.
	
	geoViewManager addGeoObject: geoObject.
	self assert: layer1 displayProjectionModel datas size equals: 1.
	self assert: layer1 graphicProjectionModel datas size equals: 1.
	self assert: layer2 displayProjectionModel datas size equals: 1.
	self assert: layer2 graphicProjectionModel datas size equals: 1.
]

{ #category : #tests }
GeoViewManagerBlocImplTests >> testAddGeoObjectAndAddAnotherLayerAndAddAnotherProcessData [
	| geoObject layer1 layer2 |
	layer1 := BlGeoViewObjectLayer new layerName: #layer1.
	layer1 setProcessData: GeoCircleProcessData new for: GeoCircle.
	geoViewManager addLayer: layer1.
	layer2 := BlGeoViewObjectLayer new layerName: #layer2.
	geoObject := GeoCircle new key: 1.
	geoViewManager addGeoObject: geoObject.
	self assert: layer1 displayProjectionModel datas size equals: 1.
	self assert: layer1 graphicProjectionModel datas size equals: 1.
	self assert: layer2 displayProjectionModel datas size equals: 0.
	self assert: layer2 graphicProjectionModel datas size equals: 0.
	
	geoViewManager addLayer: layer2.
	self assert: layer1 displayProjectionModel datas size equals: 1.
	self assert: layer1 graphicProjectionModel datas size equals: 1.
	self assert: layer2 displayProjectionModel datas size equals: 0.
	self assert: layer2 graphicProjectionModel datas size equals: 0.
	
	geoViewManager addGeoObject: geoObject.
	self assert: layer1 displayProjectionModel datas size equals: 1.
	self assert: layer1 graphicProjectionModel datas size equals: 1.
	self assert: layer2 displayProjectionModel datas size equals: 0.
	self assert: layer2 graphicProjectionModel datas size equals: 0.
	
	layer2 setProcessData: GeoCircleProcessData new for: GeoCircle.
	self assert: layer1 displayProjectionModel datas size equals: 1.
	self assert: layer1 graphicProjectionModel datas size equals: 1.
	self assert: layer2 displayProjectionModel datas size equals: 0.
	self assert: layer2 graphicProjectionModel datas size equals: 0.
	
	geoViewManager addGeoObject: geoObject.
	self assert: layer1 displayProjectionModel datas size equals: 1.
	self assert: layer1 graphicProjectionModel datas size equals: 1.
	self assert: layer2 displayProjectionModel datas size equals: 1.
	self assert: layer2 graphicProjectionModel datas size equals: 1.
]

{ #category : #tests }
GeoViewManagerBlocImplTests >> testCreateAndAddGeoObjectLayer [
	| layer |
	layer := geoViewManager createAndAddGeoObjectLayer: nil.
	self assert: layer isNil.
	layer := geoViewManager createAndAddGeoObjectLayer: #layerA.
	self assert: layer notNil.
]

{ #category : #tests }
GeoViewManagerBlocImplTests >> testGeoObjectsServices [
	| geoObject |
	geoObject := GeoObject new.
	geoViewManager addGeoObject: geoObject.
	geoViewManager updateGeoObject: geoObject.
	geoViewManager removeGeoObject: geoObject.
	geoViewManager addGeoObjects: (OrderedCollection with: geoObject).
	geoViewManager updateGeoObjects: (OrderedCollection with: geoObject).
	geoViewManager removeGeoObjects: (OrderedCollection with: geoObject).
]

{ #category : #tests }
GeoViewManagerBlocImplTests >> testLayerConfiguration [
	| layer |
	layer := BlGeoViewObjectLayer new layerName: #layer1.
	geoViewManager addLayer: layer.
	
	self assert: layer processDataChangedCallback notNil.
	self assert: layer displayProjectionModel projection notNil.
	self assert: layer graphicProjectionModel symbologyProvider notNil.
	
]

{ #category : #tests }
GeoViewManagerBlocImplTests >> testLayerEvents [
	| geoViewUser layer |
	MolComponentManager default deploymentServices deployComponentImplementation: GeoViewUserTestImpl.
	geoViewUser := MolComponentManager default homeServices instanciateComponent: GeoViewUserTestImpl.
	geoViewUser forEvents: GeoViewManagerLayerEvents useProducer: geoViewManagerName.
	MolComponentManager default homeServices activateComponent: GeoViewUserTestImpl.
	geoViewUser getGeoViewManagerLayerEventsSubscriber subscribe: geoViewUser.
	
	self assert: (geoViewUser receivedGeoViewLayerEvents includesKey: #layerAddedEvent) equals: false.
	self assert: (geoViewUser receivedGeoViewLayerEvents includesKey: #layerUpdatedEvent) equals: false.
	self assert: (geoViewUser receivedGeoViewLayerEvents includesKey: #layerDeletedEvent) equals: false.
	
	layer := BlGeoViewObjectLayer new layerName: #layer1.
	layer setProcessData: GeoProcessData new for: GeoObject.
	geoViewManager addLayer: layer.
	self assert: (geoViewUser receivedGeoViewLayerEvents at: #layerAddedEvent) equals: #layer1 -> geoViewManagerName.
	self assert: (geoViewUser receivedGeoViewLayerEvents includesKey: #layerUpdatedEvent) equals: false.
	self assert: (geoViewUser receivedGeoViewLayerEvents includesKey: #layerDeletedEvent) equals: false.
	
	layer setProcessData: GeoCircleProcessData new for: GeoCircle.
	self assert: (geoViewUser receivedGeoViewLayerEvents at: #layerAddedEvent) equals: #layer1 -> geoViewManagerName.
	self assert: (geoViewUser receivedGeoViewLayerEvents at: #layerUpdatedEvent) equals: #layer1 -> geoViewManagerName.
	self assert: (geoViewUser receivedGeoViewLayerEvents includesKey: #layerDeletedEvent) equals: false.
	geoViewUser receivedGeoViewLayerEvents removeKey: #layerUpdatedEvent.
	
	layer deleteProcessDataFor: GeoCircle.
	self assert: (geoViewUser receivedGeoViewLayerEvents at: #layerAddedEvent) equals: #layer1 -> geoViewManagerName.
	self assert: (geoViewUser receivedGeoViewLayerEvents at: #layerUpdatedEvent) equals: #layer1 -> geoViewManagerName.
	self assert: (geoViewUser receivedGeoViewLayerEvents includesKey: #layerDeletedEvent) equals: false.
	
	geoViewManager deleteLayer: #layer1.
	self assert: (geoViewUser receivedGeoViewLayerEvents at: #layerAddedEvent) equals: #layer1 -> geoViewManagerName.
	self assert: (geoViewUser receivedGeoViewLayerEvents at: #layerUpdatedEvent) equals: #layer1 -> geoViewManagerName.
	self assert: (geoViewUser receivedGeoViewLayerEvents at: #layerDeletedEvent) equals: #layer1 -> geoViewManagerName.
	
	geoViewUser getGeoViewManagerLayerEventsSubscriber unsubscribe: geoViewUser.
	MolComponentManager default homeServices passivateComponent: GeoViewUserTestImpl.
	MolComponentManager default homeServices removeComponent: GeoViewUserTestImpl.
	MolComponentManager default deploymentServices undeployComponentImplementation: GeoViewUserTestImpl.
]

{ #category : #tests }
GeoViewManagerBlocImplTests >> testLayerServices [
	| layer |
	geoViewManager addLayer: (BlGeoViewLayer new layerName: #layer1).
	self assert: geoViewManager getLayers size equals: 1.
	
	layer := geoViewManager getLayer: #layer1.
	self assert: layer notNil.
	
	geoViewManager deleteLayer: #layer1.
	self assert: geoViewManager getLayers isEmpty.
	
	geoViewManager addLayer: (BlGeoViewLayer new layerName: #layer1).
	self assert: geoViewManager getLayers size equals: 1.
	
	geoViewManager deleteAllLayers.
	self assert: geoViewManager getLayers isEmpty.
]

{ #category : #tests }
GeoViewManagerBlocImplTests >> testLayerServicesWithoutLayers [
	| layer |
	self assert: geoViewManager getLayers isEmpty.
	layer := geoViewManager getLayer: #nonExistingLayer.
	self assert: layer isNil.
	
	geoViewManager deleteLayer: #nonExistingLayer.
	self assert: geoViewManager getLayers isEmpty.
	
	geoViewManager deleteAllLayers.
	self assert: geoViewManager getLayers isEmpty.
]
