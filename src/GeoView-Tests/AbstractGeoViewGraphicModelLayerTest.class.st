"
An AbstractGeoViewGraphicModelLayerTest is a test class for testing the behavior of AbstractGeoViewGraphicModelLayer
"
Class {
	#name : #AbstractGeoViewGraphicModelLayerTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - Core'
}

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testInitialize [

	| layer |
	layer := AbstractGeoViewGraphicModelLayer new.
	self assert: (layer graphicModel isKindOf: GeoViewModel).
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testInitializeGraphicModel [

	| layer |
	layer := AbstractGeoViewGraphicModelLayer new.
	
	"Test process data creation"
	self assert: (layer graphicModel getProcessDataForClass: SmockDCompositeShape) class equals: DCompositeShapeGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDSymbol) class equals: DSymbolGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDImage) class equals: DImageGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDCircle) class equals: DCircleGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDText) class equals: DTextGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDPolygon) class equals: DPolygonGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDPolyline) class equals: DPolylineGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDSegment) class equals: DSegmentGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDSector) class equals: DSectorGeoViewProcessData.
	
	"Test model initialization"
	self assert: (layer graphicModel projection isKindOf: GeoView2DProjection).
]
