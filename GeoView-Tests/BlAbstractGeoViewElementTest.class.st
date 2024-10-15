"
A BlAbstractGeoViewElementTest is a test class for testing the behavior of BlAbstractGeoViewElement
"
Class {
	#name : #BlAbstractGeoViewElementTest,
	#superclass : #TestCase,
	#instVars : [
		'geoView'
	],
	#category : #'GeoView-Tests-Cases'
}

{ #category : #private }
BlAbstractGeoViewElementTest >> createGeoViewElement [

	geoView := GeoViewAbstractElement new.
]

{ #category : #accessing }
BlAbstractGeoViewElementTest >> geoViewSize [

	^ 100@100
]

{ #category : #running }
BlAbstractGeoViewElementTest >> setUp [

	| container aSpace |
	super setUp.
	self createGeoViewElement.
	geoView constraintsDo: [ :c | c horizontal matchParent. c vertical matchParent ].
	container := BlElement new.
	container size: self geoViewSize.
	container addChild: geoView.
	
	aSpace := BlSpace new.
	aSpace host: BlHeadlessHost new.
	aSpace root addChild: container.
	container forceLayout.
	aSpace pulse.
]

{ #category : #running }
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
BlAbstractGeoViewElementTest >> testAddGeoViewGeoObjectsLayer [

	| layer |
	layer := GeoViewDomainObjectsLayer new name: #test.
	geoView addLayer: layer.
	
	self assert: (geoView getLayer: #test) equals: layer.
	self assert: (layer graphicModel getProcessDataForClass: SmockDCompositeShape) class equals: DCompositeShapeGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDSymbol) class equals: DSymbolGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDImage) class equals: DImageGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDCircle) class equals: DCircleGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDText) class equals: DTextGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDPolygon) class equals: DPolygonGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDPolyline) class equals: DPolylineGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDSegment) class equals: DSegmentGeoViewProcessData.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testAddLayer [

	| layer |
	layer := GeoViewTestLayer new name: #test.
	geoView addLayer: layer.
	
	self assert: (geoView getLayer: #test) equals: layer.
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
	layer := GeoViewDomainObjectsLayer new name: #myLayer.
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
	self assert: geoView viewInfos class equals: GeoViewInfos.
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
BlAbstractGeoViewElementTest >> testPickAt [

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
BlAbstractGeoViewElementTest >> testPickAtGeoOrigin [

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
BlAbstractGeoViewElementTest >> testPickAtNil [

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
BlAbstractGeoViewElementTest >> testPickAtRadius [

	| result |
	result := geoView pickAt: 0@0 radius: 10.
	self assert: result radiusInPixels equals: 10.
	
	self assert: result isEmpty.
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
