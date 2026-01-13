"
I am a Web Mercator projection (EPSG:3857), also known as Pseudo-Mercator or Spherical Mercator.
This is the projection used by most web mapping services (Google Maps, OpenStreetMap, Bing Maps, etc.).

Unlike the standard Mercator projection (EPSG:3395) which uses an ellipsoidal earth model, Web Mercator uses a spherical earth model for simplicity and performance, making it easier to tile and cache map images. The practical difference is small for most applications.

The valid latitude range is approximately ±85.05112878° due to the spherical model.
"
Class {
	#name : #GeoViewWebMercatorProjection,
	#superclass : #GeoViewMercatorProjection,
	#category : #'GeoView-Projections'
}

{ #category : #accessing }
GeoViewWebMercatorProjection >> epsgCode [
	"Return the EPSG code identifying the projection coordinate reference system"

	^ 3857
]

{ #category : #accessing }
GeoViewWebMercatorProjection >> key [

	^ #GeoViewWebMercatorProjection
]

{ #category : #accessing }
GeoViewWebMercatorProjection >> latitudeLimit [
	"Web Mercator latitude limit in degrees =~ 85.06 degress"
	"((Float pi exp - Float pi negated exp) / 2) arcTan radiansToDegrees "

	^ 85.06
]

{ #category : #accessing }
GeoViewWebMercatorProjection >> latitudeMax [

	^ self latitudeLimit
]

{ #category : #accessing }
GeoViewWebMercatorProjection >> latitudeMin [

	^ self latitudeLimit negated
]

{ #category : #accessing }
GeoViewWebMercatorProjection >> name [

	^ 'Web Mercator'
]

{ #category : #projection }
GeoViewWebMercatorProjection >> projCartToLatLon: aCartesianCoordinates [

	| lat lon |
	(aCartesianCoordinates isEmpty or: [
		 aCartesianCoordinates isValid not ]) ifTrue: [ ^ nil ].
	
	lon := aCartesianCoordinates xInMeters / WGS84 semiMajorAxisInMeters.

	lat := Float pi / 2 - (2 * (aCartesianCoordinates yInMeters / WGS84 semiMajorAxisInMeters) negated exp arcTan).

	^ AbsoluteCoordinates
		  latitudeInRadians: lat
		  longitudeInRadians: lon
		  altitudeInMeters: aCartesianCoordinates zInMeters
]

{ #category : #projection }
GeoViewWebMercatorProjection >> projLatLonToCart: anAbsoluteCoordinates [
	"Project latitude/longitude to Web Mercator Cartesian coordinates using spherical formulas"

	| x y lat |
	(anAbsoluteCoordinates isEmpty or: [
		 anAbsoluteCoordinates isValid not ]) ifTrue: [ ^ nil ].

	lat := anAbsoluteCoordinates latitudeInRadians.
	x := anAbsoluteCoordinates longitudeInRadians * WGS84 semiMajorAxisInMeters.

	y := (Float pi / 4 + (lat / 2)) tan ln * WGS84 semiMajorAxisInMeters.

	^ CartesianCoordinates new
		  xInMeters: x;
		  yInMeters: y;
		  zInMeters: anAbsoluteCoordinates altitudeInMeters
]
