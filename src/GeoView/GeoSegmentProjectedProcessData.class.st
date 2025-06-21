"
labordep: this class is POC, need to be refactored with standard processData and setup with isGeoProjectedShape: true/false parameter 
"
Class {
	#name : #GeoSegmentProjectedProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #processing }
GeoSegmentProjectedProcessData >> processCreatedData: aKey incoming: aGeoSegment with: aDPolyline context: aContext [

	| dPolyline distance firstAzimuth from to n step points |
	dPolyline := aDPolyline ifNil: [ SmockDPolyline new ].
	super processCreatedData: aKey incoming: aGeoSegment with: dPolyline context: aContext.

	"reset segment properties because usage of polyline"
	dPolyline coordinates: nil.

	from := aGeoSegment fromAbsolutePosition.
	to := aGeoSegment toAbsolutePosition.
	distance := GeodesicUtils distanceInMetersFrom: from to: to.
	firstAzimuth := GeodesicUtils azimuthInRadiansFrom: from to: to.
	
	
	"echantillonage sur 10 points"
	n := 500.
	step := distance / n.
	points := OrderedCollection new.
	points add: (self processor projection projLatLonToCart: from).
	points addAll: ((1 to: (n - 1)) collect:[ :i |
		self processor projection projLatLonToCart:
		(GeodesicUtils absoluteCoordinatesFrom: from distanceInM: (step * i) azimuthInRadians: firstAzimuth ).
	]).
	points add: (self processor projection projLatLonToCart: to).

	dPolyline points: points.

	^ dPolyline
]

{ #category : #processing }
GeoSegmentProjectedProcessData >> processUpdatedData: aKey incoming: aGeoSegment with: aDPolyline context: aContext [

	| dPolyline |
	dPolyline := aDPolyline.
	super processUpdatedData: aKey incoming: aGeoSegment with: dPolyline context: aContext.
	
	self flag:'labordep: todo'.

	^ dPolyline
]
