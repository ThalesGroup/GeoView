"
A BlAbstractGeoViewElementTest is a test class for testing the behavior of BlAbstractGeoViewElement
"
Class {
	#name : #GeoViewAbstractElementTest,
	#superclass : #TestCase,
	#instVars : [
		'geoView'
	],
	#category : #'GeoView-Tests-Core'
}

{ #category : #private }
GeoViewAbstractElementTest >> createGeoViewElement [

	geoView := GeoViewAbstractElement new
]

{ #category : #accessing }
GeoViewAbstractElementTest >> geoViewSize [

	^ 100 @ 100
]

{ #category : #running }
GeoViewAbstractElementTest >> setUp [

	| container aSpace |
	super setUp.
	self createGeoViewElement.
	geoView constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	container := BlElement new.
	container extent: self geoViewSize.
	container addChild: geoView.

	aSpace := BlSpace new.
	aSpace host: BlHeadlessHost new.
	aSpace root addChild: container.
	container forceLayout.
	aSpace pulse
]

{ #category : #running }
GeoViewAbstractElementTest >> tearDown [

	geoView := nil.
	super tearDown
]

{ #category : #tests }
GeoViewAbstractElementTest >> testAbsoluteCoordinatesFromGlobalPoint [

	| abs center |
	center := geoView size / 2.
	abs := geoView absoluteCoordinatesFromGlobalPoint: center.
	self assert: abs latitudeInDegrees equals: 0.
	self assert: abs longitudeInDegrees equals: 0.
	
	geoView geoCenter: AbsoluteCoordinates frBrest.
	abs := geoView absoluteCoordinatesFromGlobalPoint: center.
	self assert: abs latitudeInDegrees rounded equals: AbsoluteCoordinates frBrest latitudeInDegrees rounded.
	self assert: abs longitudeInDegrees rounded equals: AbsoluteCoordinates frBrest longitudeInDegrees rounded.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testAbsoluteCoordinatesFromGlobalPoint2 [

	| abs |
	"Center should be zero"
	abs := geoView absoluteCoordinatesFromGlobalPoint: (geoView size / 2).
	self assert: abs latitudeInDegrees equals: 0.
	self assert: abs longitudeInDegrees equals: 0.
	
	"at the top left corner"
	abs := geoView absoluteCoordinatesFromGlobalPoint: 0@0.
	self assert: abs latitudeInDegrees > 0.
	self assert: abs longitudeInDegrees < 0.
	
	"at the bottom right"
	abs := geoView absoluteCoordinatesFromGlobalPoint: (geoView size).
	self assert: abs latitudeInDegrees < 0.
	self assert: abs longitudeInDegrees > 0.
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

	self assert: geoView size equals: 100@100.
	self assert: geoView mapProjection class equals: GeoViewMercatorProjection.
	self assert: geoView displayToGraphicProjection class equals: GeoView2DProjection.
	self assert: geoView geoCenter equals: AbsoluteCoordinates zero.
	self assert: geoView displayToGraphicProjection cartesianCenter equals: CartesianCoordinates zero.
	self assert: geoView viewInfos class equals: GeoViewInfos.
]

{ #category : #tests }
GeoViewAbstractElementTest >> testInteractionsStrategy [

	self assert: geoView interactionsStrategy class equals: GeoViewInteractionsStrategy
]

{ #category : #tests }
GeoViewAbstractElementTest >> testNewInteractionsStrategy [

	self assert: geoView newInteractionsStrategy class equals: GeoViewInteractionsStrategy.
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
GeoViewAbstractElementTest >> testPickAtGeoOrigin [

	| result |
	result := geoView pickAt: (geoView globalPointFromAbsoluteCoordinates: AbsoluteCoordinates zero).	
	self assert: result class equals: GeoViewPickingResult.
	self assert: (result timestamp <= DateAndTime now).
	self assert: result globalPoint equals: (self geoViewSize / 2).
	self assert: result localPoint equals: (geoView localPointFromGlobalPoint: (self geoViewSize / 2)).
	self assert: result absoluteCoordinates equals: (geoView absoluteCoordinatesFromGlobalPoint: (self geoViewSize / 2)).
	self assert: (result cartesianCoordinates xInMeters closeTo: 0 precision: 1e-8).
	self assert: (result cartesianCoordinates yInMeters closeTo: 0 precision: 1e-8).
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
GeoViewAbstractElementTest >> testRemoveInteractionsStrategy [

	geoView removeInteractionsStrategy.
	self assert: geoView interactionsStrategy isNil
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
GeoViewAbstractElementTest >> testSetInteractionsStrategy [

	geoView setInteractionsStrategy: nil.
	self assert: geoView interactionsStrategy isNil
]
