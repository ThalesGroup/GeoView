Class {
	#name : #GeoViewManagerImplTest,
	#superclass : #TestCase,
	#instVars : [
		'geoViewManager',
		'geoViewUser'
	],
	#category : #'GeoView-Molecule-Tests-Cases'
}

{ #category : #testing }
GeoViewManagerImplTest class >> isAbstract [ 

	^ self == GeoViewManagerImplTest 
]

{ #category : #setup }
GeoViewManagerImplTest >> componentImplClass [

	self subclassResponsibility 
]

{ #category : #running }
GeoViewManagerImplTest >> setUp [

	super setUp.

	MolComponentManager cleanUp.

	geoViewManager := self componentImplClass start.
	geoViewUser := GeoViewManagerTestUserImpl start
]

{ #category : #running }
GeoViewManagerImplTest >> tearDown [

	self componentImplClass stop.
	geoViewManager := nil.
	
	geoViewUser stop.
	geoViewUser := nil.

	MolComponentManager cleanUp.

	super tearDown
]

{ #category : #tests }
GeoViewManagerImplTest >> testAddLayerAfterIndex [

	| layerA layerB layerC |

	layerA := geoViewManager createAndAddDomainObjectsLayer: #layerA.
	self assert: layerA notNil.

	layerB := geoViewManager createDomainObjectsLayer: #layerB.
	self assert: layerB notNil.
	geoViewManager addLayer: layerB.
	
	self assert: (geoViewManager getLayers first) name equals: #layerA.
	self assert: (geoViewManager getLayers last) name equals: #layerB.

	layerC := geoViewManager createDomainObjectsLayer: #layerC.
	self assert: layerC notNil.
	geoViewManager addLayer: layerC afterIndex: 1.

	self assert: (geoViewManager getLayers first) name equals: #layerA.
	self assert: (geoViewManager getLayers at: 2) name equals: #layerC.
	self assert: (geoViewManager getLayers last) name equals: #layerB
]

{ #category : #tests }
GeoViewManagerImplTest >> testAggregatedComponentsStart [

	self assert: geoViewManager getSmockSymbologyManagerServicesProvider isNotFoundServices equals: false.
	self assert: geoViewManager getSmockSelectionManagerServicesProvider isNotFoundServices equals: false.
]

{ #category : #tests }
GeoViewManagerImplTest >> testCreateAndAddGeoObjectsLayer [
	"Warning : default implementation of GeoViewManager is an abtract engine implementation, all created objets are nil"

	| layer |
	layer := geoViewManager createAndAddDomainObjectsLayer: #layerA.
	self assert: layer notNil.
]

{ #category : #tests }
GeoViewManagerImplTest >> testGetGeoCenter [

	self
		assert: geoViewManager getGeoCenter class
		equals: AbsoluteCoordinates
]

{ #category : #tests }
GeoViewManagerImplTest >> testGetScale [

	self assert: geoViewManager getScale isNumber
]

{ #category : #tests }
GeoViewManagerImplTest >> testLayerServices [
	| layer |
	geoViewManager addLayer: (GeoViewTestLayer new name: #layer1).
	self assert: geoViewManager getLayers size equals: 1.
	
	layer := geoViewManager getLayer: #layer1.
	self assert: layer notNil.
	
	geoViewManager removeLayer: #layer1.
	self assert: geoViewManager getLayers isEmpty.
	
	geoViewManager addLayer: (GeoViewTestLayer new name: #layer1).
	self assert: geoViewManager getLayers size equals: 1.
	
	geoViewManager removeAllLayers.
	self assert: geoViewManager getLayers isEmpty.
]

{ #category : #tests }
GeoViewManagerImplTest >> testLayerServicesWithoutLayers [
	| layer |
	self assert: geoViewManager getLayers isEmpty.
	layer := geoViewManager getLayer: #nonExistingLayer.
	self assert: layer isNil.
	
	geoViewManager removeLayer: #nonExistingLayer.
	self assert: geoViewManager getLayers isEmpty.
	
	geoViewManager removeAllLayers.
	self assert: geoViewManager getLayers isEmpty.
]

{ #category : #tests }
GeoViewManagerImplTest >> testSetGeoCenter [

	self
		deny: geoViewManager getGeoCenter
		equals: AbsoluteCoordinates frBrest.

	self assert: geoViewUser center isNil.

	geoViewManager setGeoCenter: AbsoluteCoordinates frBrest.
	self
		assert: geoViewManager getGeoCenter
		equals: AbsoluteCoordinates frBrest.

	self
		assert: geoViewUser center
		equals: AbsoluteCoordinates frBrest -> geoViewManager componentName
]

{ #category : #tests }
GeoViewManagerImplTest >> testSetScale [

	self
		deny: geoViewManager getScale
		equals: 1000.

	self assert: geoViewUser scale isNil.

	geoViewManager setScale: 1000.
	self
		assert: geoViewManager getScale
		equals: 1000.

	self
		assert: geoViewUser scale
		equals: 1000 -> geoViewManager componentName
]
