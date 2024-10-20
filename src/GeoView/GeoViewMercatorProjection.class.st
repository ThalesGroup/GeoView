"
I am a Mercator projection. It is a cylindrical map projection.
"
Class {
	#name : #GeoViewMercatorProjection,
	#superclass : #Object,
	#traits : 'TGeoViewMapProjection',
	#classTraits : 'TGeoViewMapProjection classTrait',
	#category : #'GeoView-Projections'
}

{ #category : #accessing }
GeoViewMercatorProjection >> key [
	^#GeoViewMercatorProjection
]

{ #category : #accessing }
GeoViewMercatorProjection >> projCartToLatLon: aCartesianCoordinates [

	| lat lon |
	lat := (2 * (aCartesianCoordinates yInMeters / WGS84 semiMinorAxisInMeters) exp arcTan) 
		- (Float pi / 2).
	lon := aCartesianCoordinates xInMeters / WGS84 semiMajorAxisInMeters.
	
	^ AbsoluteCoordinates
		latitudeInRadians: lat
		longitudeInRadians: lon 
		altitudeInMeters: aCartesianCoordinates zInMeters
]

{ #category : #accessing }
GeoViewMercatorProjection >> projLatLonToCart: anAbsoluteCoordinates [

	| x y |
	(anAbsoluteCoordinates isEmpty or:[anAbsoluteCoordinates isValid not]) ifTrue:[^nil].
	x := anAbsoluteCoordinates longitudeInRadians 
		* WGS84 semiMajorAxisInMeters.
	y := ((anAbsoluteCoordinates latitudeInRadians / 2) + (Float pi / 4)) tan ln 
		* WGS84 semiMinorAxisInMeters.
	
	^ CartesianCoordinates new
		xInMeters: x;
		yInMeters: y;
		zInMeters: anAbsoluteCoordinates altitudeInMeters.
]
