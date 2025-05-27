"
An AbstractGeoViewGraphicModelLayerTest is a test class for testing the behavior of AbstractGeoViewGraphicModelLayer
"
Class {
	#name : #AbstractGeoViewGraphicModelLayerTest,
	#superclass : #TestCase,
	#instVars : [
		'layer'
	],
	#category : #'GeoView-Tests-Cases - Core'
}

{ #category : #running }
AbstractGeoViewGraphicModelLayerTest >> setUp [
	super setUp.

	layer := AbstractGeoViewGraphicModelLayer new
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testInitialize [

	self assert: (layer graphicModel isKindOf: GeoViewModel)
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testInitializeGraphicModel [
	
	"Test process data creation"
	self assert: (layer graphicModel getProcessDataForClass: SmockDCompositeShape) class equals: DCompositeShapeGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDSymbol) class equals: DSymbolGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDImage) class equals: DImageGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDCircle) class equals: DCircleGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDEllipse) class equals: DEllipseGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDText) class equals: DTextGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDPolygon) class equals: DPolygonGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDPolyline) class equals: DPolylineGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDSegment) class equals: DSegmentGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDSector) class equals: DSectorGeoViewProcessData.
	
	"Test model initialization"
	self assert: (layer graphicModel projection isKindOf: GeoView2DProjection).
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testIsMaximumDisplayedObjectsReach [

	self deny: layer isMaximumDisplayedObjectsReach.
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testMaximumDisplayedObjects [

	self assert: layer maximumDisplayedObjects isNil.
	
	layer maximumDisplayedObjects: 500.
	self assert: layer maximumDisplayedObjects equals: 500.
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testReachMaximumDisplayedObjects [

	| objects |
	layer maximumDisplayedObjects: 50.
	
	objects := (1 to: 100) collect:[ :e | SmockDCircle new key: e; radius: 10; coordinates: 0@0; fillColor: Color red ].
	
	layer addDShapes: objects.
	layer sortDatas.
	self assert: layer isMaximumDisplayedObjectsReach.
	
	layer removeDShapes: objects.
	layer sortDatas.
	self deny: layer isMaximumDisplayedObjectsReach.
]
