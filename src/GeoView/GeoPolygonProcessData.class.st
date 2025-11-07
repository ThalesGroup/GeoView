Class {
	#name : #GeoPolygonProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #computing }
GeoPolygonProcessData >> computePosition: aKey incoming: aGeoObject with: aDShape context: aContext [
	"Position makes no sense for a Geo polygon"

	^ aDShape
]

{ #category : #dShape }
GeoPolygonProcessData >> createDShapeInstance [

	^ SmockDPolygon new
]

{ #category : #processing }
GeoPolygonProcessData >> processCreatedData: aKey incoming: aGeoPolygon with: aDPolygon context: aContext [
	| dPolygon |
	
	dPolygon := aDPolygon.
	dPolygon := super processCreatedData: aKey incoming: aGeoPolygon with: dPolygon context: aContext.
	dPolygon := super processUpdatedData: aKey incoming: aGeoPolygon with: aDPolygon context: aContext.
	
	^dPolygon
]

{ #category : #processing }
GeoPolygonProcessData >> processUpdatedData: aKey incoming: aGeoPolygon with: aDPolygon context: aContext [
	| points |
	super processUpdatedData: aKey incoming: aGeoPolygon with: aDPolygon context: aContext.
	
	points := aGeoPolygon absolutePositions
	          collect: [ :e |
	          self processor projection projLatLonToCart: e ]
	          thenReject: [ :pt | "some points should be nil in case of projection limits"
		          pt isNil ].
	
	aDPolygon points: points.

	^ aDPolygon
]
