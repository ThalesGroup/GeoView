"
A GeoArcBandTest is a test class for testing the behavior of GeoArcBand
"
Class {
	#name : #GeoArcBandTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - GeoObject'
}

{ #category : #'tests-updating' }
GeoArcBandTest >> geoArcBand1 [

	^ GeoArcBand  new
		absoluteCoordinates: AbsoluteCoordinates zero;
		isVisible: true;
		key: #arcband1;
		fillColor: Color black;
		strokeColor: Color red;
		strokePattern: nil;
		strokeWidth: 1;
		apertureInRadians: 5;
		orientationInAzimuths: 10;
		radiusInMeters1: 50;
		radiusInMeters2: 500;
		yourself.
]

{ #category : #'tests-updating' }
GeoArcBandTest >> geoArcBand2 [

	^ GeoArcBand  new
		absoluteCoordinates: AbsoluteCoordinates zero;
		isVisible: true;
		key: #arcband2;
		fillColor: Color black;
		strokeColor: Color red;
		strokePattern: nil;
		strokeWidth: 1;
		apertureInRadians: 10;
		orientationInAzimuths: 20;
		radiusInMeters1: 100;
		radiusInMeters2: 1000;
		yourself.
]

{ #category : #'tests-updating' }
GeoArcBandTest >> testCopy [
	| geoArcBand geoArcBandCopy |
	geoArcBand := self geoArcBand1.
	geoArcBandCopy := geoArcBand copy.

	self assert: geoArcBand apertureInRadians equals: geoArcBandCopy apertureInRadians.
	self assert: geoArcBand orientationInAzimuths equals: geoArcBandCopy orientationInAzimuths.
	self assert: geoArcBand radiusInMeters1 equals: geoArcBandCopy radiusInMeters1.
	self assert: geoArcBand radiusInMeters2 equals: geoArcBandCopy radiusInMeters2.
]

{ #category : #'tests-updating' }
GeoArcBandTest >> testUpdateWith [

	| geoArcBand1 geoArcBand2 |
	geoArcBand1 := self geoArcBand1.
	geoArcBand2 := self geoArcBand2.
	
	self assert: geoArcBand1 apertureInRadians ~= geoArcBand2 apertureInRadians.
	self assert: geoArcBand1 orientationInAzimuths ~= geoArcBand2 orientationInAzimuths.
	self assert: geoArcBand1 radiusInMeters1 ~= geoArcBand2 radiusInMeters1.
	self assert: geoArcBand1 radiusInMeters2 ~= geoArcBand2 radiusInMeters2.
	
	geoArcBand1 updateWith: geoArcBand2.

	self assert: geoArcBand1 apertureInRadians equals: geoArcBand2 apertureInRadians.
	self assert: geoArcBand1 orientationInAzimuths equals: geoArcBand2 orientationInAzimuths.
	self assert: geoArcBand1 radiusInMeters1 equals: geoArcBand2 radiusInMeters1.
	self assert: geoArcBand1 radiusInMeters2 equals: geoArcBand2 radiusInMeters2.
]
