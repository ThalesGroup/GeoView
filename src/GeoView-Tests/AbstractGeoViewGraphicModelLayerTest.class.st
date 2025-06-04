"
An AbstractGeoViewGraphicModelLayerTest is a test class for testing the behavior of AbstractGeoViewGraphicModelLayer
"
Class {
	#name : #AbstractGeoViewGraphicModelLayerTest,
	#superclass : #TestCase,
	#instVars : [
		'layer'
	],
	#category : #'GeoView-Tests-Core'
}

{ #category : #running }
AbstractGeoViewGraphicModelLayerTest >> setUp [
	super setUp.

	layer := AbstractGeoViewGraphicModelLayer new
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testDisplayFilter [

	| filter |
	self assert: layer displayFilter isNil.

	filter := SmockAttributesDisplayFilter new.
	layer displayFilter: filter.
	self assert: layer displayFilter equals: filter
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
AbstractGeoViewGraphicModelLayerTest >> testIsGShapeFiltered [

	| gShape |
	gShape := SmockGShape2D new.
	self deny: (layer isGShapeFiltered: gShape). "no layer filter: not filtered"
	
	gShape displayMask: (SmockAttributesDisplayFilter new addAttribute: #typeA) mask.
	self deny: (layer isGShapeFiltered: gShape). "dShape display mask but no layer filter: not filtered"
	
	layer displayFilter: (SmockAttributesDisplayFilter new addAttribute: #typeA; addAttribute: #typeB).
	self deny: (layer isGShapeFiltered: gShape). "not filtered because same attributes"
	
	gShape displayMask: nil.
	self assert: (layer isGShapeFiltered: gShape). "filtered because display mask is nil and layer filter not nil"
	
	gShape displayMask: (layer displayFilter maskForAttribute: nil).
	self assert: (layer isGShapeFiltered: gShape). "filtered because display mask is 0"
	
	gShape displayMask: (layer displayFilter maskForAttribute: #typeA).
	self deny: (layer isGShapeFiltered: gShape). "not filtered because display attribute includes"
	
	gShape displayMask: (layer displayFilter maskForAttributes: #(#typeA #typeB)).
	self deny: (layer isGShapeFiltered: gShape). "not filtered because display attribute includes"
	
	gShape displayMask: (layer displayFilter maskForAttributes: #typeC).
	self assert: (layer isGShapeFiltered: gShape). "filtered because display attribute is not includes"
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testIsGShapeUnfiltered [

	| gShape |
	gShape := SmockGShape2D new.
	self assert: (layer isGShapeUnfiltered: gShape). "no layer filter: not filtered"
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
