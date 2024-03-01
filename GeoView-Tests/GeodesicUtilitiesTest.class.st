"
A GeodesicUtilitiesTest is a test class for testing the behavior of GeodesicUtilities
"
Class {
	#name : #GeodesicUtilitiesTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-MapProjection'
}

{ #category : #tests }
GeodesicUtilitiesTest >> testCheckAngleIsBetweenTwoOthers [

	| result |
	result := GeodesicUtilities checkAngle: 0 isBetween: 355 degreesToRadians and: 5 degreesToRadians.
	self assert: result equals: true.
	result := GeodesicUtilities checkAngle: 14 degreesToRadians isBetween: 340 degreesToRadians and: 15 degreesToRadians.
	self assert: result equals: true.
	result := GeodesicUtilities checkAngle: 341 degreesToRadians isBetween: 340 degreesToRadians and: 15 degreesToRadians.
	self assert: result equals: true.
	result := GeodesicUtilities checkAngle: 15 degreesToRadians isBetween: 340 degreesToRadians and: 15 degreesToRadians.
	self assert: result equals: true.
	result := GeodesicUtilities checkAngle: 340 degreesToRadians isBetween: 340 degreesToRadians and: 15 degreesToRadians.
	self assert: result equals: true.
	result := GeodesicUtilities checkAngle: 16 degreesToRadians isBetween: 340 degreesToRadians and: 15 degreesToRadians.
	self assert: result equals: false.
	
	result := GeodesicUtilities checkAngle: 55 degreesToRadians isBetween: 15 degreesToRadians and: 91 degreesToRadians.
	self assert: result equals: true.
	result := GeodesicUtilities checkAngle: 155 degreesToRadians isBetween: 15 degreesToRadians and: 91 degreesToRadians.
	self assert: result equals: false.
	result := GeodesicUtilities checkAngle: 155 degreesToRadians isBetween: 91 degreesToRadians and: 180 degreesToRadians.
	self assert: result equals: true.
	
	result := GeodesicUtilities checkAngle: 180 degreesToRadians isBetween: 175 degreesToRadians and: 180 degreesToRadians.
	self assert: result equals: true.
	result := GeodesicUtilities checkAngle: -40 degreesToRadians isBetween: 225 degreesToRadians and: 321 degreesToRadians.
	self assert: result equals: true.
	result := GeodesicUtilities checkAngle: 345 degreesToRadians isBetween: 215 degreesToRadians and: 321 degreesToRadians.
	self assert: result equals: false.
	
	result := GeodesicUtilities checkAngle: -45 degreesToRadians isBetween: 26.21 degreesToRadians and: 89.969 degreesToRadians.
	self assert: result equals: false.
]

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
	
	headingInDegree := 45.

	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: true.
	
	originPointAbsCoord latitudeInDegrees: 48.29603.
	
	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: true.
	
	headingInDegree := -45.
	
	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: false.

	headingInDegree := 90.
	
	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: true.
	
	originPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.34 longitudeInDegrees: -4.62.
	headingInDegree := 225.
	
	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: true.
	
	headingInDegree := 180.
	
	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: true.
	
	originPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.01 longitudeInDegrees: -4.62.
	headingInDegree := 45.
	
	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: false.
	
	

]

{ #category : #tests }
GeodesicUtilitiesTest >> testIsAzimuthTowardsRectangleArea [

	| originPointAbsCoord isAzTowardsArea listPointsArea headingInDegree|
	
	originPointAbsCoord := AbsoluteCoordinates latitudeInDegrees: 48.20146040354154 longitudeInDegrees: -4.492.
	
	listPointsArea := OrderedCollection new.
	listPointsArea add: (AbsoluteCoordinates latitudeInDegrees: 48.20998 longitudeInDegrees: -4.493).
	listPointsArea add: (AbsoluteCoordinates latitudeInDegrees: 48.20998 longitudeInDegrees: -4.491).
	listPointsArea add: (AbsoluteCoordinates latitudeInDegrees: 48.208 longitudeInDegrees: -4.491).
	listPointsArea add: (AbsoluteCoordinates latitudeInDegrees: 48.208 longitudeInDegrees: -4.493).
	
	headingInDegree := 0.

	isAzTowardsArea := GeodesicUtilities isAzimuthTowardsAreaFrom: originPointAbsCoord azimuth: headingInDegree area: listPointsArea.
	
	self assert: isAzTowardsArea equals: true.
	
]
