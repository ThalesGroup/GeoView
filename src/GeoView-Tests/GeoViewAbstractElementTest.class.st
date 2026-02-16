"
A BlAbstractGeoViewElementTest is a test class for testing the behavior of BlAbstractGeoViewElement
"
Class {
	#name : #GeoViewAbstractElementTest,
	#superclass : #TestCase,
	#instVars : [
		'geoView',
		'space'
	],
	#category : #'GeoView-Tests-Core'
}

{ #category : #testing }
GeoViewAbstractElementTest class >> isAbstract [ 

	^ self == GeoViewAbstractElementTest
]

{ #category : #private }
GeoViewAbstractElementTest >> createGeoViewElement [

	self subclassResponsibility 
]

{ #category : #accessing }
GeoViewAbstractElementTest >> geoViewSize [

	^ 1000 @ 1000
]

{ #category : #running }
GeoViewAbstractElementTest >> setUp [

	| container |
	super setUp.
	
	self createGeoViewElement.
	geoView constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	container := BlElement new.
	container extent: self geoViewSize.
	container addChild: geoView.

	space := BlSpace new.
	space host: BlHeadlessHost new.
	space root addChild: container.
	container forceLayout.
	space pulse
]

{ #category : #tests }
GeoViewAbstractElementTest >> testAddGeoViewGeoObjectsLayer [

	| layer |
	layer := GeoViewDomainObjectsLayer new name: #test.
	geoView addLayer: layer.
	self assert: (geoView getLayer: #test) equals: layer
]

{ #category : #tests }
GeoViewAbstractElementTest >> testAddLayer [

	| layer |
	layer := GeoViewTestLayer new name: #test.
	geoView addLayer: layer.
	
	self assert: (geoView getLayer: #test) equals: layer.
]

{ #category : #'tests - filters' }
GeoViewAbstractElementTest >> testApplyDisplayFilterToAllLayers [
	
	| filter |
	filter := SmockAttributesDisplayFilter new.
	geoView applyDisplayFilterToAllLayers: filter.
	self assert: geoView displayFilter isNil
]

{ #category : #'tests - states' }
GeoViewAbstractElementTest >> testClearSelectedObjectIndexes [

	geoView addLayer: GeoViewDomainObjectsLayer new.
	geoView addObject: (GeoObject key: 1).
	geoView addObject: (GeoObject key: 2).
	geoView selectedObjectIndexes: #( 1 ).
	
	geoView clearSelectedObjectIndexes.
	self assert: (geoView getLayers first displayModel getStateValue: GeoViewAbstractElement selectedState for: 1) isNil.
	self assert: (geoView getLayers first displayModel getStateValue: GeoViewAbstractElement selectedState for: 2) isNil.
]

{ #category : #'tests - states' }
GeoViewAbstractElementTest >> testClearStateObjectIndexes [

	geoView addLayer: GeoViewDomainObjectsLayer new.
	geoView addObject: (GeoObject key: 1).
	geoView addObject: (GeoObject key: 2).
	geoView updateState: #testState withObjectIndexes: #( 1 2 ).

	geoView clearStateObjectIndexes: #testState.
	self assert: (geoView getLayers first displayModel getStateValue: #testState for: 1) isNil.
	self assert: (geoView getLayers first displayModel getStateValue: #testState for: 2) isNil.
]

{ #category : #'tests - filters' }
GeoViewAbstractElementTest >> testDisplayFilter [
	
	| filter |
	filter := SmockAttributesDisplayFilter new.
	geoView displayFilter: filter.
	self assert: geoView displayFilter equals: filter. 
	
	geoView addLayer: GeoViewDomainObjectsLayer new.
	self assert: geoView displayFilter equals: filter. 
	
]

{ #category : #tests }
GeoViewAbstractElementTest >> testDisplayToGraphicProjection [

	| projection |
	projection := GeoView2DProjection new.
	self deny: geoView displayToGraphicProjection identicalTo: projection.
	
	geoView displayToGraphicProjection: projection.
	self assert: geoView displayToGraphicProjection identicalTo: projection.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testGeoCenter [

	geoView geoCenter: AbsoluteCoordinates frBrest.

	self assert: geoView geoCenter equals: AbsoluteCoordinates frBrest.
	self deny: geoView displayToGraphicProjection cartesianCenter equals: CartesianCoordinates zero.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testGeoViewLayerProcessDataChanged [

	| tag layer |
	"initialize geoview and event handler"
	tag := false.	
	geoView addEventHandlerOn: GeoViewDomainObjectsLayerProcessDataChanged do: [ :e | tag := true ].
	self deny: tag.
	
	"create and add the layer"
	layer := GeoViewDomainObjectsLayer new name: #myLayer.
	geoView addLayer: layer.
	self deny: tag.
	
	"change layer process datas"
	layer setProcessData: GeoCircleProcessData forClass: GeoCircle.
	
	self assert: tag.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testGetLayer [

	self assert: (geoView getLayer: #test) isNil.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testGetLayers [

	self assert: geoView getLayers isEmpty.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testInitialize [

	self assert: geoView extent equals: 1000 @ 1000.
	self
		assert: geoView mapProjection class
		equals: GeoViewWebMercatorProjection.
	self
		assert: geoView displayToGraphicProjection class
		equals: GeoView2DProjection.
	self assert: geoView geoCenter equals: AbsoluteCoordinates zero.
	self
		assert: geoView displayToGraphicProjection cartesianCenter
		equals: CartesianCoordinates zero.
	self assert: geoView viewInfos class equals: SmockViewInfos
]

{ #category : #tests }
GeoViewAbstractElementTest >> testMaxScale [

	self assert: geoView maxScale equals: 100000000.
	
	geoView maxScale: 10000000.
	self assert: geoView maxScale equals: 10000000.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testMinScale [

	self assert: geoView minScale equals: 100.
	
	geoView minScale: 500.
	self assert: geoView minScale equals: 500.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testNormalizeScale [

	"Min"
	self assert: (geoView normalizeScale: geoView minScale) equals: (geoView minScale).
	self assert: (geoView normalizeScale: 100) equals: 100.
	self assert: (geoView normalizeScale: 1) equals: 100.
	
	"Max"
	self assert: (geoView normalizeScale: geoView maxScale) equals: (geoView maxScale).
	self assert: (geoView normalizeScale: 100000000) equals: 100000000.
	self assert: (geoView normalizeScale: 1000000000) equals: 100000000.
	
	"Middle"
	self assert: (geoView normalizeScale: 10000) equals: 10000.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testObjectIndexAccessor [

	self assert: geoView objectIndexAccessor equals: #key.
	
	geoView objectIndexAccessor: #id.
	self assert: geoView objectIndexAccessor equals: #id.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testPickAt [

	| result |
	result := geoView pickAt: 0@0.
	self assert: result class equals: GeoViewPickingResult.
	self assert: (result timestamp <= DateAndTime now).
	self assert: result globalPoint equals: 0@0.
	self assert: result localPoint equals: (geoView localPointFromGlobalPoint: 0@0).
	self assert: result absoluteCoordinates equals: (geoView absoluteCoordinatesFromGlobalPoint: 0@0).
	self assert: result cartesianCoordinates equals: (geoView mapProjection projLatLonToCart: result absoluteCoordinates).
	self assert: result radiusInPixels equals: 0.
	
	self assert: result isEmpty.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testPickAtNil [

	| result |
	result := geoView pickAt: nil.
	self assert: result class equals: GeoViewPickingResult.
	self assert: (result timestamp <= DateAndTime now).
	self assert: result globalPoint isNil.
	self assert: result localPoint isNil.
	self assert: result absoluteCoordinates isNil.
	self assert: result cartesianCoordinates isNil.
	self assert: result radiusInPixels equals: 0.
	
	self assert: result isEmpty.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testPickAtRadius [

	| result |
	result := geoView pickAt: 0@0 radius: 10.
	self assert: result radiusInPixels equals: 10.
	
	self assert: result isEmpty.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testRemoveAllLayers [

	geoView addLayer: (GeoViewTestLayer new name: #test).
	geoView addLayer: (GeoViewTestLayer new name: #test2).
	geoView addLayer: (GeoViewTestLayer new name: #test3).

	self assert: geoView getLayers size equals: 3.
	self assert: (geoView getLayer: #test) notNil.
	self assert: (geoView getLayer: #test2) notNil.
	self assert: (geoView getLayer: #test3) notNil.

	geoView removeAllLayers.
	self assert: geoView getLayers size equals: 0.
	self assert: (geoView getLayer: #test) isNil.
	self assert: (geoView getLayer: #test2) isNil.
	self assert: (geoView getLayer: #test3) isNil.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testRemoveLayer [

	| layer |
	layer := GeoViewTestLayer new name: #test.
	geoView addLayer: layer.
	geoView removeLayer: layer.

	self assert: geoView getLayers size equals: 0.
	self assert: (geoView getLayer: #test) isNil
]

{ #category : #tests }
GeoViewAbstractElementTest >> testScale [

	self assert: geoView scale equals: geoView defaultScale.
	
	geoView scale: 100000.
	self assert: geoView scale equals: 100000
]

{ #category : #tests }
GeoViewAbstractElementTest >> testScaleDown [
	
	geoView scaleDown.
	self assert: geoView scale equals: (geoView defaultScale * geoView scaleFactor).
]

{ #category : #tests }
GeoViewAbstractElementTest >> testScaleFactor [

	self assert: geoView scaleFactor equals: 1.5.
	
	geoView scaleFactor: 2.
	self assert: geoView scaleFactor equals: 2
]

{ #category : #tests }
GeoViewAbstractElementTest >> testScaleRangeSetup [
	"Create a new view, setup the scale range and check the model"
		
	| maxScale minScale |
	maxScale := 10000.
	minScale := 1000.
		
	geoView maxScale: maxScale.
	geoView minScale: minScale.

	self assert: geoView scale equals: maxScale.
	
	"Force out of range scale"
	geoView scale: 100000.
	self assert: geoView scale equals: maxScale.
	
	geoView scale: 10.
	self assert: geoView scale equals: minScale.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testScaleUp [
	
	geoView scaleUp.
	self assert: geoView scale equals: (geoView defaultScale / geoView scaleFactor).
]

{ #category : #'tests - states' }
GeoViewAbstractElementTest >> testSelectedObjectIndexes [

	geoView addLayer: GeoViewDomainObjectsLayer new.
	geoView addObject: (GeoObject key: 1).
	geoView addObject: (GeoObject key: 2).
	self assert: (geoView getLayers first displayModel getStateValue: GeoViewAbstractElement selectedState for: 1) isNil.
	self assert: (geoView getLayers first displayModel getStateValue: GeoViewAbstractElement selectedState for: 2) isNil.

	geoView selectedObjectIndexes: #( 1 ).
	self assert: (geoView getLayers first displayModel getStateValue: GeoViewAbstractElement selectedState for: 1).
	self assert: (geoView getLayers first displayModel getStateValue: GeoViewAbstractElement selectedState for: 2) isNil.
	
	geoView selectedObjectIndexes: #( 1 2 ).
	self assert: (geoView getLayers first displayModel getStateValue: GeoViewAbstractElement selectedState for: 1).
	self assert: (geoView getLayers first displayModel getStateValue: GeoViewAbstractElement selectedState for: 2).
	
	geoView selectedObjectIndexes: #( ).
	self assert: (geoView getLayers first displayModel getStateValue: GeoViewAbstractElement selectedState for: 1) isNil.
	self assert: (geoView getLayers first displayModel getStateValue: GeoViewAbstractElement selectedState for: 2) isNil.
]

{ #category : #'tests - states' }
GeoViewAbstractElementTest >> testUpdateStateWithObjectIndexes [

	geoView addLayer: GeoViewDomainObjectsLayer new.
	geoView addObject: (GeoObject key: 1).
	geoView addObject: (GeoObject key: 2).
	self assert: (geoView getLayers first displayModel getStateValue: #testState for: 1) isNil.
	self assert: (geoView getLayers first displayModel getStateValue: #testState for: 2) isNil.

	geoView updateState: #testState withObjectIndexes: #( 1 ).
	self assert: (geoView getLayers first displayModel getStateValue: #testState for: 1).
	self assert: (geoView getLayers first displayModel getStateValue: #testState for: 2) isNil.
	
	geoView updateState: #testState withObjectIndexes: #( 1 2 ).
	self assert: (geoView getLayers first displayModel getStateValue: #testState for: 1).
	self assert: (geoView getLayers first displayModel getStateValue: #testState for: 2).
	
	geoView updateState: #testState withObjectIndexes: #( ).
	self assert: (geoView getLayers first displayModel getStateValue: #testState for: 1) isNil.
	self assert: (geoView getLayers first displayModel getStateValue: #testState for: 2) isNil.
]
