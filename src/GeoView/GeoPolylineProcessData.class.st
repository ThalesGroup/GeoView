Class {
	#name : #GeoPolylineProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #computing }
GeoPolylineProcessData >> computePosition: aKey incoming: aGeoObject with: aDShape context: aContext [
	"Position makes no sense for a Geo polyline"

	^ aDShape
]

{ #category : #dShape }
GeoPolylineProcessData >> createDShapeInstance [

	^ SmockDPolyline new
]

{ #category : #processing }
GeoPolylineProcessData >> processCreatedData: aKey incoming: aGeoPolyline with: aDPolyline context: aContext [
	| dPolyline |
	
	dPolyline := aDPolyline.
	dPolyline := super processCreatedData: aKey incoming: aGeoPolyline with: dPolyline context: aContext.
	dPolyline := self processUpdatedData: aKey incoming: aGeoPolyline with: dPolyline context: aContext.
	
	^dPolyline
]

{ #category : #processing }
GeoPolylineProcessData >> processUpdatedData: aKey incoming: aGeoPolyline with: aDPolyline context: aContext [
	| points |
	super processUpdatedData: aKey incoming: aGeoPolyline with: aDPolyline context: aContext.
	
	points := aGeoPolyline absolutePositions
	          collect: [ :e |
	          self processor projection projLatLonToCart: e ]
	          thenReject: [ :pt | "some points should be nil in case of projection limits"
		          pt isNil ].
	
	aDPolyline points: points.

	^ aDPolyline
]
