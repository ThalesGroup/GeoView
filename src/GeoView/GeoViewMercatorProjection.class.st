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

{ #category : #properties }
GeoViewMercatorProjection class >> k0 [

	^ 0.9996
]

{ #category : #properties }
GeoViewMercatorProjection class >> scaleFactor [

	^ self k0
]

{ #category : #accessing }
GeoViewMercatorProjection >> epsgCode [
	"EPSG:3395 World Mercator (ellipsoidal earth)"

	^ 3395
]

{ #category : #testing }
GeoViewMercatorProjection >> geodesicExitsValidDomainFrom: aFromAbsoluteCoordinates to: aToAbsoluteCoordinates [
	"return a boolean if a segment between two points need to be cut, used in case of changement of the projection side"
	
	| lat1 lon1 lat2 lon2 deltaLon crossesLonCut crossesLatCut |
	(aFromAbsoluteCoordinates isValid not or:[aToAbsoluteCoordinates isValid not]) ifTrue:[ ^ true ].
	
	lat1 := aFromAbsoluteCoordinates latitudeInDegrees.
	lon1 := aFromAbsoluteCoordinates longitudeInDegrees.
	lat2 := aToAbsoluteCoordinates latitudeInDegrees.
	lon2 := aToAbsoluteCoordinates longitudeInDegrees.
	
	deltaLon := (lon1 - lon2) abs.
	crossesLonCut := deltaLon > 180.
	crossesLatCut := (lat1 abs >= self latitudeLimit) or:[ lat2 abs >= self latitudeLimit ].
	^ crossesLonCut or:[ crossesLatCut ] 
]

{ #category : #testing }
GeoViewMercatorProjection >> isAbsoluteCoordinatesOutsideProjectionLimit: anAbsoluteCoordinates [
	"Sometimes coordinates can be correct from a geographic point of view but outside of the map projection"

	| side |
	side := self sideOfAbsoluteCoordinates: anAbsoluteCoordinates.
	^ side = #outOfProjection or: [
		  side = #outsideLatitudeLimitBottom or: [
			  side = #outsideLatitudeLimitTop ] ]
]

{ #category : #accessing }
GeoViewMercatorProjection >> key [

	^ #GeoViewMercatorProjection
]

{ #category : #accessing }
GeoViewMercatorProjection >> latitudeLimit [

	^ 85
]

{ #category : #projection }
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

{ #category : #projection }
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

{ #category : #testing }
GeoViewMercatorProjection >> sideOfAbsoluteCoordinates: anAbsolutePosition [
	"Available side symbols: 
	#outsideLatitudeLimitTop, #outsideLatitudeLimitBottom, #leftOfZeroMeridian, #rightOfZeroMeridian
	and #outOfProjection
	"
	
	| lat lon |
	anAbsolutePosition isValid ifFalse:[ ^ #outOfProjection ].
	lat := anAbsolutePosition latitudeInDegrees.
	lon := anAbsolutePosition longitudeInDegrees.
	
	"Test if the point is outside latitude limit"
	(lat abs) > self latitudeLimit ifTrue:[
		lat > (self latitudeLimit negated) ifTrue:[ ^ #outsideLatitudeLimitBottom ].
		^ #outsideLatitudeLimitTop.
	].

	"Test if the side of the point according to the zero meridian"
	lon > 0 ifTrue:[ ^ #rightOfZeroMeridian ].
	^ #leftOfZeroMeridian
]
