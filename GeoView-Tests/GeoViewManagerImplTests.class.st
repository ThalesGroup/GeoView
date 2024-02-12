Class {
	#name : #GeoViewManagerImplTests,
	#superclass : #TestCase,
	#instVars : [
		'geoViewManagerName',
		'geoViewManager'
	],
	#category : #'GeoView-Tests-Cases - GeoViewManager'
}

{ #category : #running }
GeoViewManagerImplTests >> setUp [

	super setUp.
	geoViewManagerName := #myGeoViewManager.
	MolComponentManager cleanUp.
	MolComponentManager default deploymentServices deployComponentImplementation: GeoViewManagerTestImpl.
	geoViewManager := MolComponentManager default homeServices instantiateComponent: GeoViewManagerTestImpl named: geoViewManagerName.
	MolComponentManager default homeServices activateComponent: GeoViewManagerTestImpl named: geoViewManagerName
]

{ #category : #running }
GeoViewManagerImplTests >> tearDown [
	super tearDown.
	MolComponentManager default homeServices passivateComponent: GeoViewManagerTestImpl named: geoViewManagerName.
	MolComponentManager default homeServices removeComponent: GeoViewManagerTestImpl named: geoViewManagerName.
	geoViewManager := nil.
	geoViewManagerName := nil.
	MolComponentManager default deploymentServices undeployComponentImplementation: GeoViewManagerTestImpl.
	MolComponentManager cleanUp.
]

{ #category : #tests }
GeoViewManagerImplTests >> testAggregatedComponentsStart [

	self assert: geoViewManager getMapProjectionManagerServicesProvider isNotFoundServices equals: false.
	self assert: geoViewManager getSmockSymbologyManagerServicesProvider isNotFoundServices equals: false.
	self assert: geoViewManager getSmockSelectionManagerServicesProvider isNotFoundServices equals: false.
]

{ #category : #tests }
GeoViewManagerImplTests >> testCreateAndAddGeoObjectLayer [
	"Warning : default implementation of GeoViewManager is an abtract engine implementation, all created objets are nil"
	| layer error |
	error := nil.
	
	[layer := geoViewManager createAndAddLayer: nil] 
		on: Error do: [ :e | error := e ].
	self assert: error class equals: SmockNoIdError.
	
	layer := geoViewManager createAndAddLayer: #layerA.
	self assert: layer isNil.
]

{ #category : #tests }
GeoViewManagerImplTests >> testLayerServices [
	| layer |
	geoViewManager addLayer: (GeoViewTestLayer new layerName: #layer1).
	self assert: geoViewManager getLayers size equals: 1.
	
	layer := geoViewManager getLayer: #layer1.
	self assert: layer notNil.
	
	geoViewManager removeLayer: #layer1.
	self assert: geoViewManager getLayers isEmpty.
	
	geoViewManager addLayer: (GeoViewTestLayer new layerName: #layer1).
	self assert: geoViewManager getLayers size equals: 1.
	
	geoViewManager removeAllLayers.
	self assert: geoViewManager getLayers isEmpty.
]

{ #category : #tests }
GeoViewManagerImplTests >> testLayerServicesWithoutLayers [
	| layer |
	self assert: geoViewManager getLayers isEmpty.
	layer := geoViewManager getLayer: #nonExistingLayer.
	self assert: layer isNil.
	
	geoViewManager removeLayer: #nonExistingLayer.
	self assert: geoViewManager getLayers isEmpty.
	
	geoViewManager removeAllLayers.
	self assert: geoViewManager getLayers isEmpty.
]
