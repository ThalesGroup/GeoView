Class {
	#name : #GeoViewProjectionUtils,
	#superclass : #Object,
	#category : #'GeoView-Projections'
}

{ #category : #utilities }
GeoViewProjectionUtils class >> findMostLimitAbsoluteCoordinatesBetween: aStartAbsoluteCoordinates and: anEndAbsoluteCoordinates mapProjection: aMapProjection geodesicFormulas: aGeodesicFormulas [
	"Important: suppose than the two coordinates are side by side of the map projection, if not sure check it before with the map projection"
	"process by dichotomy to find points" "use vincenty by default - after use the geodesic formulas class"
	| precision firstSide lastSide a b distance formulas |
	
	formulas := aGeodesicFormulas ifNil:[ GeodesicVincentyFormulas new ].
	
	"labordep: precision in meters, may be this will be nice to setup it?"
	precision := 1000. 
	
	firstSide := aMapProjection sideOfAbsoluteCoordinates: aStartAbsoluteCoordinates.
	lastSide := aMapProjection sideOfAbsoluteCoordinates: anEndAbsoluteCoordinates.
	
	"check if need to compute"
	firstSide = lastSide ifTrue:[ ^ nil ].
	a := aStartAbsoluteCoordinates. b := anEndAbsoluteCoordinates.
	distance := formulas distanceInMetersFrom: a to: b.
	[distance > precision] whileTrue: [ | middle middleSide |
		
		middle := formulas absoluteCoordinatesAlongGeodesicFrom: a to: b atFraction: 0.5.
		middleSide := aMapProjection sideOfAbsoluteCoordinates: middle.
		middleSide = firstSide ifTrue: [ a := middle ] ifFalse: [ b := middle ]. 
		
		distance := formulas distanceInMetersFrom: a to: b.
	].

	^ a

	
	
]

{ #category : #utilities }
GeoViewProjectionUtils class >> findSideBySideAbsoluteCoordinatesBetween: aStartAbsoluteCoordinates and: anEndAbsoluteCoordinates mapProjection: aMapProjection geodesicFormulas: aGeodesicFormulas [
	"Important: suppose than the two coordinates are side by side of the map projection, if not sure check it before with the map projection"
	"process by dichotomy to find points"
	
	| last first and |
	last := self findMostLimitAbsoluteCoordinatesBetween: aStartAbsoluteCoordinates and: anEndAbsoluteCoordinates mapProjection: aMapProjection geodesicFormulas: aGeodesicFormulas.
	"if last is nil points are out of projection or not valid"
	and := last ifNil:[ aStartAbsoluteCoordinates ].
	
	first := self findMostLimitAbsoluteCoordinatesBetween: anEndAbsoluteCoordinates and: and mapProjection: aMapProjection geodesicFormulas: aGeodesicFormulas.
	
	^ last -> first
]

{ #category : #utilities }
GeoViewProjectionUtils class >> projectedCartesianRadiusFromCenter: anAbsoluteCoordinates radiusInMeters: aDistanceInM azimuthInDegrees: anAzimuthInDegrees projection: aMapProjection [
	"Estimates the projected radius in cartesian coordinates by projecting two geographic points—one at the center and one at a given distance and azimuth—into Cartesian coordinates, then measuring their planar distance. Approximative but sufficiant for basic shape projections"

	| cartesianCoordinates1 tangentAbsolutePosition cartesianCoordinates2 cartesianRadius |

	self flag:'labordep: check projection limits before calculating'.
	(aMapProjection isAbsoluteCoordinatesOutsideProjectionLimit: anAbsoluteCoordinates) ifTrue:[
		^ nil
	].
	
	cartesianCoordinates1 := aMapProjection projLatLonToCart: anAbsoluteCoordinates.
		
	tangentAbsolutePosition := GeodesicApproximativeFormulas new
		         absoluteCoordinatesFrom: anAbsoluteCoordinates
		         distanceInMeters: aDistanceInM
		         azimuthInRadians: (anAzimuthInDegrees degreesToRadians).
		
	(aMapProjection isAbsoluteCoordinatesOutsideProjectionLimit: tangentAbsolutePosition) ifTrue:[
		^ nil
	].
		
	cartesianCoordinates2 := aMapProjection projLatLonToCart: tangentAbsolutePosition.

	cartesianRadius := (cartesianCoordinates1 asPoint - cartesianCoordinates2 asPoint) r abs.

	^ cartesianRadius
]

{ #category : #'see class side' }
GeoViewProjectionUtils >> seeClassSide [ 
]
