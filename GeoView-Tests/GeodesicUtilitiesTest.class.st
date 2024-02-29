"
A GeodesicUtilitiesTest is a test class for testing the behavior of GeodesicUtilities
"
Class {
	#name : #GeodesicUtilitiesTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-MapProjection'
}

{ #category : #tests }
GeodesicUtilitiesTest >> testConvertGeodesicToAzimuthInRadiansFromTwoPoints [

	| originPointAbsCoord endPointAbsCoord azRad|
	
	originPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.28275 longitudeInDegrees: -4.70553.
	endPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.32676 longitudeInDegrees: -4.68284.

	azRad := GeodesicUtilities 	convertGeodesicToAzimuthInRadiansFrom: originPointAbsCoord to: endPointAbsCoord.
		
	self assert: (azRad radiansToDegrees closeTo: 18.9726921431 precision: 1e-10) equals: true.
	
	endPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.29603 longitudeInDegrees: -4.62295.

	azRad := GeodesicUtilities convertGeodesicToAzimuthInRadiansFrom: originPointAbsCoord to: endPointAbsCoord.
		
	self assert: (azRad radiansToDegrees closeTo: 76.42078534394 precision: 1e-10) equals: true. 
]

{ #category : #tests }
GeodesicUtilitiesTest >> testConvertGeodesicToDistanceFromTwoPoints [

	| originPointAbsCoord endPointAbsCoord distanceInM|
	
	originPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.28275 longitudeInDegrees: -4.70553.
	endPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.32676 longitudeInDegrees: -4.68284.

	distanceInM := GeodesicUtilities 	convertGeodesicToDistanceInMeterFrom: originPointAbsCoord to: endPointAbsCoord.
	
	self assert: (distanceInM closeTo: 5175.1422410892 precision: 1e-8) equals: true.
	
	endPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.29603 longitudeInDegrees: -4.62295.

	distanceInM := GeodesicUtilities convertGeodesicToDistanceInMeterFrom: originPointAbsCoord to: endPointAbsCoord.
		
	self assert: (distanceInM  closeTo: 6303.42663738019 precision: 1e-8) equals: true. 
]

{ #category : #tests }
GeodesicUtilitiesTest >> testIsAzimuthTowardsArea [

	| originPointAbsCoord isAzTowardsArea listPointsArea headingInDegree|
	
	originPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.28275 longitudeInDegrees: -4.70553.
	
	listPointsArea := OrderedCollection new.
	listPointsArea add: (AbsoluteCoordinates latitudeInDegrees: 48.32676 longitudeInDegrees: -4.68284).
	listPointsArea add: (AbsoluteCoordinates latitudeInDegrees: 48.33995 longitudeInDegrees: -4.65976).
	listPointsArea add: (AbsoluteCoordinates latitudeInDegrees: 48.3117 longitudeInDegrees: -4.60466).
	listPointsArea add: (AbsoluteCoordinates latitudeInDegrees: 48.29603 longitudeInDegrees: -4.62295).
	
	"headingInDegree := 45.

	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: true.
	
	originPointAbsCoord latitudeInDegrees: 48.29603.
	
	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: true.
	
	headingInDegree := -45.
	
	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: false."
		originPointAbsCoord latitudeInDegrees: 48.29603.
	headingInDegree := 90.
	
	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: true.
	
	

]
