"
A BlAbstractGeoViewElementTest is a test class for testing the behavior of BlAbstractGeoViewElement
"
Class {
	#name : #BlAbstractGeoViewElementTest,
	#superclass : #TestCase,
	#instVars : [
		'geoView'
	],
	#category : #'GeoView-Bloc-Tests-Core'
}

{ #category : #tests }
BlAbstractGeoViewElementTest >> setUp [

	| container |
	super setUp.
	geoView := BlAbstractGeoViewElement new.
	geoView constraintsDo: [ :c | c horizontal matchParent. c vertical matchParent ].
	container := BlElement new.
	container size: 100@100.
	container addChild: geoView.
	
	geoView requestLayout.
	container forceLayout.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> tearDown [

	geoView := nil.
	super tearDown.
	
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testAbsoluteCoordinatesFromGlobalPoint [

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
BlAbstractGeoViewElementTest >> testAbsoluteCoordinatesFromGlobalPoint2 [

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
BlAbstractGeoViewElementTest >> testAddLayer [

	| layer |
	layer := GeoViewTestLayer new.
	geoView addLayer: layer.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testDisplayToGraphicProjection [

	| projection |
	projection := GeoView2DProjection new.
	self deny: geoView displayToGraphicProjection identicalTo: projection.
	
	geoView displayToGraphicProjection: projection.
	self assert: geoView displayToGraphicProjection identicalTo: projection.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testGeoCenter [

	geoView geoCenter: AbsoluteCoordinates frBrest.

	self assert: geoView geoCenter equals: AbsoluteCoordinates frBrest.
	self deny: geoView displayToGraphicProjection cartesianCenter equals: CartesianCoordinates zero.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testGeoViewLayerProcessDataChanged [

	| tag layer |
	"initialize geoview and event handler"
	tag := false.	
	geoView addEventHandlerOn: GeoViewGeoObjectLayerProcessDataChanged do: [ :e | tag := true ].
	self deny: tag.
	
	"create and add the layer"
	layer := GeoViewGeoObjectsLayer new name: #myLayer.
	geoView addLayer: layer.
	self deny: tag.
	
	"change layer process datas"
	layer setProcessData: GeoCircleProcessData forClass: GeoCircle.
	
	self assert: tag.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testGetLayer [

	self assert: (geoView getLayer: #test) isNil.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testGetLayers [

	self assert: geoView getLayers isEmpty.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testInitialize [

	self assert: geoView size equals: 100@100.
	self assert: geoView mapProjection class equals: GeoViewMercatorProjection.
	self assert: geoView displayToGraphicProjection class equals: GeoView2DProjection.
	self assert: geoView geoCenter equals: AbsoluteCoordinates zero.
	self assert: geoView displayToGraphicProjection cartesianCenter equals: CartesianCoordinates zero.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testInteractionsStrategy [

	self assert: geoView interactionsStrategy class equals: GeoViewDefaultInteractionsStrategy
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testNewInteractionsStrategy [

	self assert: geoView newInteractionsStrategy class equals: GeoViewDefaultInteractionsStrategy.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testObjectIndexAccessor [

	self assert: geoView objectIndexAccessor equals: #key.
	
	geoView objectIndexAccessor: #id.
	self assert: geoView objectIndexAccessor equals: #id.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testRemoveInteractionsStrategy [

	geoView removeInteractionsStrategy.
	self assert: geoView interactionsStrategy isNil
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testSetInteractionsStrategy [

	geoView setInteractionsStrategy: nil.
	self assert: geoView interactionsStrategy isNil
]
