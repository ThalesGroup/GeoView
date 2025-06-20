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
	distance := GeodesicUtilities convertGeodesicToDistanceInMeterFrom: from to: to.
	firstAzimuth := GeodesicUtilities convertGeodesicToAzimuthInRadiansFrom: from to: to.
	
	"echantillonage sur 10 points"
	n := 10.
	step := distance / n.
	points := (0 to: n) collect:[ :i |
		self processor projection projLatLonToCart:
		(GeodesicUtilities destinationFrom: from distance: (step * i) azimuth: firstAzimuth ).
	].

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
