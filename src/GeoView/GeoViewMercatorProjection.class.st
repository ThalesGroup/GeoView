"
I am a Mercator projection (EPSG:3395). 
It is a cylindrical map projection.
"
Class {
	#name : #GeoViewMercatorProjection,
	#superclass : #Object,
	#traits : 'TGeoViewMapProjection',
	#classTraits : 'TGeoViewMapProjection classTrait',
	#category : #'GeoView-Projections'
}

{ #category : #accessing }
GeoViewMercatorProjection >> epsgCode [
	"EPSG:3395 World Mercator (ellipsoidal earth)"

	^ 3395
]

{ #category : #testing }
GeoViewMercatorProjection >> geodesicCrossesValidDomainFrom: aFromAbsoluteCoordinates to: aToAbsoluteCoordinates [
	"return a boolean if a segment between two points need to be cut, used in case of changement of the projection side"
	
	| lat1 lon1 lat2 lon2 deltaLon crossesLonCut crossesLatCut |
	(aFromAbsoluteCoordinates isValid not or:[aToAbsoluteCoordinates isValid not]) ifTrue:[ ^ true ].
	
	lat1 := aFromAbsoluteCoordinates latitudeInDegrees.
	lon1 := aFromAbsoluteCoordinates longitudeInDegrees.
	lat2 := aToAbsoluteCoordinates latitudeInDegrees.
	lon2 := aToAbsoluteCoordinates longitudeInDegrees.
	
	deltaLon := (lon1 - lon2) abs.
	crossesLonCut := deltaLon > 180.
	crossesLatCut := ((lat1 < self latitudeMin) or:[ lat1 > self latitudeMax ]) or:[ 
	                  (lat2 < self latitudeMin) or:[ lat2 > self latitudeMax ] ].
	
	^ crossesLonCut or:[ crossesLatCut ] 
]

{ #category : #testing }
GeoViewMercatorProjection >> isAbsoluteCoordinatesOutsideProjectionLimit: anAbsoluteCoordinates [
	"Sometimes coordinates can be correct from a geographic point of view but outside of the map projection"

	| side |
	side := self sideOfAbsoluteCoordinates: anAbsoluteCoordinates.
	^ {
		  GeoViewMapProjectionSide outOfProjection.
		  GeoViewMapProjectionSide outsideLatitudeLimitBottom.
		  GeoViewMapProjectionSide outsideLatitudeLimitTop } includes: side
]

{ #category : #accessing }
GeoViewMercatorProjection >> key [

	^ #GeoViewMercatorProjection
]

{ #category : #accessing }
GeoViewMercatorProjection >> latitudeMax [
	"World between 80°S and 84°N"

	^ 84
]

{ #category : #accessing }
GeoViewMercatorProjection >> latitudeMin [
	"World between 80°S and 84°N"

	^ -80
]

{ #category : #accessing }
GeoViewMercatorProjection >> name [

	^ 'Mercator'
]

{ #category : #projection }
GeoViewMercatorProjection >> projCartToLatLon: aCartesianCoordinates [
	"Inverse ellipsoidal Mercator (EPSG:3395)"
	| a e lat lon ts sinLat factor |

	a := WGS84 semiMajorAxisInMeters.
	e := WGS84 eccentricity.

	lon := aCartesianCoordinates xInMeters / a.
	ts := ((aCartesianCoordinates yInMeters / a) negated) exp.

	"Initial approximation"
	lat := (Float pi / 2) - (2 * (ts arcTan)).

	6 timesRepeat: [
		sinLat := lat sin.

		factor := ts * (
			(((1 + (e * sinLat)) / (1 - (e * sinLat))) ln * (e / 2)) exp
		).

		lat := (Float pi / 2) - (2 * (factor arcTan))
	].

	^ AbsoluteCoordinates
		latitudeInRadians: lat
		longitudeInRadians: lon
		altitudeInMeters: aCartesianCoordinates zInMeters

]

{ #category : #projection }
GeoViewMercatorProjection >> projLatLonToCart: anAbsoluteCoordinates [
	"Project using ellipsoidal Mercator (EPSG:3395)"

	| x y lat e sinLat |
	(anAbsoluteCoordinates isEmpty or: [
		 anAbsoluteCoordinates isValid not ]) ifTrue: [ ^ nil ].

	lat := anAbsoluteCoordinates latitudeInRadians.
	e := WGS84 eccentricity.
	sinLat := lat sin.

	x := anAbsoluteCoordinates longitudeInRadians
	     * WGS84 semiMajorAxisInMeters.

	"Ellipsoidal Mercator formula"
	y := WGS84 semiMajorAxisInMeters
	     * ((Float pi / 4 + (lat / 2)) tan ln
		      - (e / 2 * (1 - (e * sinLat) / (1 + (e * sinLat))) ln)).

	^ CartesianCoordinates new
		  xInMeters: x;
		  yInMeters: y;
		  zInMeters: anAbsoluteCoordinates altitudeInMeters
]

{ #category : #testing }
GeoViewMercatorProjection >> sideOfAbsoluteCoordinates: anAbsolutePosition [
	"Return the projection side of the coordinates. Return leftOfZeroMeridian by default in case of zero longitude."

	| lat lon |
	anAbsolutePosition isValid ifFalse: [
		^ GeoViewMapProjectionSide outOfProjection ].
	
	lat := anAbsolutePosition latitudeInDegrees.
	lon := anAbsolutePosition longitudeInDegrees.

	"Test if the point is outside latitude limit"
	lat > self latitudeMax ifTrue: [
		^ GeoViewMapProjectionSide outsideLatitudeLimitTop ].
	lat < self latitudeMin ifTrue: [
		^ GeoViewMapProjectionSide outsideLatitudeLimitBottom ].

	"Test if the side of the point according to the zero meridian"
	lon > 0 ifTrue: [ ^ GeoViewMapProjectionSide rightOfZeroMeridian ].
	
	^ GeoViewMapProjectionSide leftOfZeroMeridian
]
