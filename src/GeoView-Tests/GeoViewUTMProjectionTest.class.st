"
An UTMProjectionTest is a test class for testing the behavior of UTMProjection
"
Class {
	#name : #GeoViewUTMProjectionTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Projections'
}

{ #category : #'tests-accessing' }
GeoViewUTMProjectionTest >> testProjLatLonToCart [
"https://fr.wikipedia.org/wiki/Transverse_universelle_de_Mercator"

	| lat lon e n absoluteCoordinates cartesianCoordinates projection |
	lat := 45 + (9/60) asFloat + (33/3600) asFloat.
	lon := 5 + (50/60) asFloat + (51/3600) asFloat.
	absoluteCoordinates := AbsoluteCoordinates latitudeInDegrees: lat longitudeInDegrees: lon.
	e := 723.80393e3.
	n := 5004.57704e3.
	
	projection := GeoViewUTMProjection new parallel: 3 degreesToRadians.
	cartesianCoordinates := projection projLatLonToCart: absoluteCoordinates. 
	"Precision at centimeter"
	self assert: (cartesianCoordinates xInMeters closeTo: e precision: 1e-2).
	self assert: (cartesianCoordinates yInMeters closeTo: n precision: 1e-2).
]
