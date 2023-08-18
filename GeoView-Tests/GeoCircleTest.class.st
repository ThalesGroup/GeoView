"
A GeoCircleTest is a test class for testing the behavior of GeoCircle
"
Class {
	#name : #GeoCircleTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - GeoObject'
}

{ #category : #'tests - instance' }
GeoCircleTest >> geoCircle1 [

	^ GeoCircle new
		absoluteCoordinates: AbsoluteCoordinates zero;
		isVisible: true;
		key: #circle1;
		fillColor: Color black;
		strokeColor: Color red;
		strokePattern: nil;
		strokeWidth: 1;
		radiusInMeters: 5;
		yourself.
]

{ #category : #'tests - instance' }
GeoCircleTest >> geoCircle2 [

	^ GeoCircle new
		absoluteCoordinates: (AbsoluteCoordinates latitudeInRadians: 0.5 longitudeInRadians: 0.5);
		isVisible: false;
		key: #circle2;
		fillColor: Color white;
		strokeColor: Color blue;
		strokePattern: nil;
		strokeWidth: 2;
		radiusInMeters: 10;
		yourself.
]

{ #category : #tests }
GeoCircleTest >> testCopy [
	| geoCircle geoCircleCopy |
	geoCircle := self geoCircle1.
	geoCircleCopy := geoCircle copy.
	
	self assert: geoCircle absoluteCoordinates equals: geoCircleCopy absoluteCoordinates.
	self assert: geoCircle absoluteCoordinates ~~ geoCircleCopy absoluteCoordinates.
	self assert: geoCircle isVisible equals: geoCircleCopy isVisible
]

{ #category : #tests }
GeoCircleTest >> testUpdateWith [
	| geoCircle1 geoCircle2 |
	geoCircle1 := self geoCircle1.
	geoCircle2 := self geoCircle2.
	
	self assert: geoCircle1 radiusInMeters ~= geoCircle2 radiusInMeters.
	
	geoCircle1 updateWith: geoCircle2.

	self assert: geoCircle1 radiusInMeters equals: geoCircle2 radiusInMeters.
]
