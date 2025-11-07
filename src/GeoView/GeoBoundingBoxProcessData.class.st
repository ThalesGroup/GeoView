Class {
	#name : #GeoBoundingBoxProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #computing }
GeoBoundingBoxProcessData >> computePosition: aKey incoming: aGeoObject with: aDShape context: aContext [
	"Position makes no sense for a GeoBoundingBox"

	^ aDShape
]

{ #category : #dShape }
GeoBoundingBoxProcessData >> createDShapeInstance [

	^ SmockDPolygon new
]

{ #category : #processing }
GeoBoundingBoxProcessData >> processCreatedData: aKey incoming: aGeoBoundingBox with: aDPolygon context: aContext [
	| dPolygon |
	
	dPolygon := aDPolygon.
	dPolygon := super processCreatedData: aKey incoming: aGeoBoundingBox with: dPolygon context: aContext.
	
	self processUpdatedData: aKey incoming: aGeoBoundingBox with: dPolygon context: aContext.
	
	^dPolygon
]

{ #category : #processing }
GeoBoundingBoxProcessData >> processUpdatedData: aKey incoming: aGeoBoundingBox with: aDPolygon context: aContext [
	| dPolygon points |
	
	dPolygon := aDPolygon.
	super processUpdatedData: aKey incoming: aGeoBoundingBox with: aDPolygon context: aContext.
	
	points := OrderedCollection new.
	points add: (self processor projection projLatLonToCart: aGeoBoundingBox topLeftAbsoluteCoordinates).
	points add: (self processor projection projLatLonToCart: aGeoBoundingBox topRightAbsoluteCoordinates).
	points add: (self processor projection projLatLonToCart: aGeoBoundingBox bottomRightAbsoluteCoordinates).
	points add: (self processor projection projLatLonToCart: aGeoBoundingBox bottomLeftAbsoluteCoordinates).
	dPolygon points: points.
	
	^dPolygon
]
