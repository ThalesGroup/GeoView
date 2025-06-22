Class {
	#name : #GeoViewProjectionUtils,
	#superclass : #Object,
	#category : #'GeoView-Projections'
}

{ #category : #utilities }
GeoViewProjectionUtils class >> findMostLimitAbsoluteCoordinatesBetween: aStartAbsoluteCoordinates and: anEndAbsoluteCoordinates mapProjection: aMapProjection geodesicFormulas: aGeodesicFormulas [
	"Important: suppose than the two coordinates are side by side of the map projection, if not sure check it before with the map projection"
	"process by dichotomy to find points" "use vincenty by default for the POC - after use the geodesic formulas class"
	| precision firstSide lastSide a b distance |
	precision := 1000. "precision en mètres, faudrait peut être le paramétrer?"
	
	firstSide := aMapProjection sideOfAbsoluteCoordinates: aStartAbsoluteCoordinates.
	lastSide := aMapProjection sideOfAbsoluteCoordinates: anEndAbsoluteCoordinates.
	"check if need to compute"
	firstSide = lastSide ifTrue:[ ^ nil ].
	a := aStartAbsoluteCoordinates. b := anEndAbsoluteCoordinates.
	distance := GeodesicUtils distanceInMetersFrom: a to: b.
	[distance > precision] whileTrue: [ | middle middleSide |
		
		middle := GeodesicUtils absoluteCoordinatesAlongGeodesicFrom: a to: b atFraction: 0.5.
		middleSide := aMapProjection sideOfAbsoluteCoordinates: middle.
		middleSide = firstSide ifTrue: [ a := middle ] ifFalse: [ b := middle ]. 
		
		distance := GeodesicUtils distanceInMetersFrom: a to: b.
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

{ #category : #'see class side' }
GeoViewProjectionUtils >> seeClassSide [ 
]
