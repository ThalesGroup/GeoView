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
	self assert: (layer graphicModel getProcessDataForClass: SmockDRectangle) class equals: DRectangleGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDSector) class equals: DSectorGeoViewProcessData.
	self assert: (layer graphicModel getProcessDataForClass: SmockDSegment) class equals: DSegmentGeoViewProcessData.
	
	"Test model initialization"
	self assert: (layer graphicModel projection isKindOf: GeoView2DProjection).
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testIsGShapeDisplayed [

	| gShape |
	gShape := SmockGShape2D new.
	self assert: (layer isGShapeDisplayed: gShape). "no filter: display the object"
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testIsGShapeDisplayedWithAllowedAttributesDisplayFilter [

	| gShape attributes |
	layer displayFilter: (SmockAttributesDisplayFilter fromObjects: { #typeA . #typeB }).
	gShape := SmockGShape2D new.
	attributes := SmockAttributeList fromObjects: { #typeA . #typeB }.
	gShape displayMask: (layer displayFilter maskForAttributes: attributes attributes).
	self assert: (layer isGShapeDisplayed: gShape). "filter and object with an attribute includes in the allowed attributes: display the object"
	
	gShape displayMask: nil.
	self assert: (layer isGShapeDisplayed: gShape). "object without attributes: display the object because by default this layer filter allow display to object without attributes"
	
	gShape displayMask: (layer displayFilter maskForAttribute: nil).
	self deny: (layer isGShapeDisplayed: gShape). "the attribute 'nil' is not includes in the allowed attributes: hide the object"
	
	gShape displayMask: (layer displayFilter maskForAttribute: #typeA).
	self assert: (layer isGShapeDisplayed: gShape). "allowed attribute: display the object"
	
	gShape displayMask: (layer displayFilter maskForAttributes: #(#typeA #typeB)).
	self assert: (layer isGShapeDisplayed: gShape). "allowed attributes: display the object"
	
	gShape displayMask: (layer displayFilter maskForAttributes: #typeC).
	self deny: (layer isGShapeDisplayed: gShape). "attribute not in the allowed list: hide the object"

	"filter setting to hide objects without filter configuration"
	layer displayFilter displayObjectsWithoutAttributes: false.
	gShape displayMask: nil.
	self deny: (layer isGShapeDisplayed: gShape). "object without attributes: hide the object because the filter is not configurated to allow that"

]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testIsGShapeNotDisplayed [

	| gShape |
	gShape := SmockGShape2D new.
	self deny: (layer isGShapeNotDisplayed: gShape). "no layer filter: display the object"
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testIsMaximumDisplayedObjectsReach [

	self deny: layer isMaximumDisplayedObjectsReach.
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testIsNeedToSortDatas [

	self deny: layer isNeedToSortDatas.
	
	layer isNeedToSortDatas: true.
	self assert: layer isNeedToSortDatas.
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testMaximumDisplayedObjects [

	self assert: layer maximumDisplayedObjects isNil.
	
	layer maximumDisplayedObjects: 500.
	self assert: layer maximumDisplayedObjects equals: 500.
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testNeedToSortDatas [

	"test locally"
	layer needToSortDatas.
	self assert: layer isNeedToSortDatas.
	
	layer needToSortDatas.
	self assert: layer isNeedToSortDatas. "already true"
	
	layer sortDatas. "call from the manager"
	self deny: layer isNeedToSortDatas. "now false"
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testReachMaximumDisplayedObjects [

	| objects |
	layer graphicProjection: (GeoView2DProjection new resolution: (10 asPoint)).
	layer maximumDisplayedObjects: 50.
	
	objects := (1 to: 100) collect:[ :e | SmockDCircle new key: e; radius: 10; coordinates: 0@0; fillColor: Color red ].
	
	layer addDShapes: objects.
	layer sortDatas.
	self assert: layer isMaximumDisplayedObjectsReach.
	
	layer removeDShapes: objects.
	layer sortDatas.
	self deny: layer isMaximumDisplayedObjectsReach.
]

{ #category : #tests }
AbstractGeoViewGraphicModelLayerTest >> testSortDatas [
	
	layer sortDatas. "call from the manager"
	self deny: layer isNeedToSortDatas.
]
