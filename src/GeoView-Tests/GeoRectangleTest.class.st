"
A GeoRectangleTest is a test class for testing the behavior of GeoRectangle
"
Class {
	#name : #GeoRectangleTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-GeoObjects'
}

{ #category : #'tests - instance' }
GeoRectangleTest >> geoRectangle1 [

	^ GeoRectangle new
		absoluteCoordinates: AbsoluteCoordinates zero;
		isVisible: true;
		key: #rectangle1;
		fillStyle: Color black asSmockFillStyle;
		strokeStyle: (Color red asSmockStrokeStyle width: 1);
		lengthInMeters1: 15;
		lengthInMeters2: 100;
		yourself.
]

{ #category : #'tests - instance' }
GeoRectangleTest >> geoRectangle2 [

	^ GeoRectangle new
		absoluteCoordinates: (AbsoluteCoordinates latitudeInRadians: 0.5 longitudeInRadians: 0.5);
		isVisible: false;
		key: #rectangle2;
		fillStyle: Color black asSmockFillStyle;
		strokeStyle: (Color red asSmockStrokeStyle width: 2);
		lengthInMeters1: 50;
		lengthInMeters2: 200;
		yourself.
]

{ #category : #tests }
GeoRectangleTest >> testCopy [

	| geoRectangle geoRectangleCopy |
	geoRectangle := self geoRectangle1.
	geoRectangleCopy := geoRectangle copy.
	
	self assert: geoRectangle lengthInMeters1 equals: geoRectangleCopy lengthInMeters1.
	self assert: geoRectangle lengthInMeters2 equals: geoRectangleCopy lengthInMeters2.
]

{ #category : #tests }
GeoRectangleTest >> testUpdateWith [

	| geoRectangle1 geoRectangle2 |
	geoRectangle1 := self geoRectangle1.
	geoRectangle2 := self geoRectangle2.
	
	self assert: geoRectangle1 lengthInMeters1 ~= geoRectangle2 lengthInMeters1.
	self assert: geoRectangle1 lengthInMeters2 ~= geoRectangle2 lengthInMeters2.
	
	geoRectangle1 updateWith: geoRectangle2.
	
	self assert: geoRectangle1 lengthInMeters1 equals: geoRectangle2 lengthInMeters1.
	self assert: geoRectangle1 lengthInMeters2 equals: geoRectangle2 lengthInMeters2.
]
