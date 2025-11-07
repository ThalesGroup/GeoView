"
A GeoViewUtilsTest is a test class for testing the behavior of GeoViewUtils
"
Class {
	#name : #GeoViewUtilsTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Core'
}

{ #category : #tests }
GeoViewUtilsTest >> testCreateGeoObjectsLayer [

	| layer |
	layer := GeoViewUtils createGeoObjectsLayer: #myLayer.
	self assert: layer name equals: #myLayer.
	self assert: layer class equals: GeoViewDomainObjectsLayer.
	self assert: (layer getProcessDataForClass: GeoBoundingBox) class equals: GeoBoundingBoxProcessData.
	self assert: (layer getProcessDataForClass: GeoCircle) class equals: GeoCircleProcessData.
	self assert: (layer getProcessDataForClass: GeoEllipse) class equals: GeoEllipseProcessData.
	self assert: (layer getProcessDataForClass: GeoSegment) class equals: GeoSegmentProcessData.
	self assert: (layer getProcessDataForClass: GeoPolygon) class equals: GeoPolygonProcessData.
	self assert: (layer getProcessDataForClass: GeoPolyline) class equals: GeoPolylineProcessData.
	self assert: (layer getProcessDataForClass: GeoRectangle) class equals: GeoRectangleProcessData.
	self assert: (layer getProcessDataForClass: GeoArcBand) class equals: GeoArcBandProcessData.
	self assert: (layer getProcessDataForClass: GeoPosition) class equals: GeoPositionProcessData.
]

{ #category : #tests }
GeoViewUtilsTest >> testCreateGeoView [

	| view |
	view := GeoViewUtils createGeoView.
	self assert: (view isKindOf: GeoViewElement).
]

{ #category : #tests }
GeoViewUtilsTest >> testCreateGeoViewForGeoObjects [

	| view |
	view := GeoViewUtils createGeoViewForGeoObjects.
	self assert: (view isKindOf: GeoViewElement).
	self assert: ((view getLayer: #GeoObjectsLayer) isKindOf: GeoViewDomainObjectsLayer).
	self assert: view getLayers size equals: 1
]
