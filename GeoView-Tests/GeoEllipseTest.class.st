"
A GeoEllipseTest is a test class for testing the behavior of GeoEllipse
"
Class {
	#name : #GeoEllipseTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - GeoObject'
}

{ #category : #'tests - instance' }
GeoEllipseTest >> geoEllipse1 [

	^ GeoEllipse new
		absoluteCoordinates: AbsoluteCoordinates zero;
		isVisible: true;
		key: #circle1;
		fillColor: Color black;
		strokeColor: Color red;
		strokePattern: nil;
		strokeWidth: 1;
		radiusInMeters1: 5;
		radiusInMeters2: 10;
		yourself.
]

{ #category : #'tests - instance' }
GeoEllipseTest >> geoEllipse2 [

	^ GeoEllipse new
		absoluteCoordinates: AbsoluteCoordinates zero;
		isVisible: true;
		key: #circle1;
		fillColor: Color black;
		strokeColor: Color red;
		strokePattern: nil;
		strokeWidth: 1;
		radiusInMeters1: 10;
		radiusInMeters2: 20;
		yourself.
]

{ #category : #'tests-updating' }
GeoEllipseTest >> testCopy [
	| geoEllipse geoEllipseCopy |
	geoEllipse := self geoEllipse1.
	geoEllipseCopy := geoEllipse copy.
		
	self assert: geoEllipse radiusInMeters1 equals: geoEllipseCopy radiusInMeters1.
	self assert: geoEllipse radiusInMeters2 equals: geoEllipseCopy radiusInMeters2.
]

{ #category : #'tests-updating' }
GeoEllipseTest >> testUpdateWith [
	| geoEllipse1 geoEllipse2 |
	geoEllipse1 := self geoEllipse1.
	geoEllipse2 := self geoEllipse2.
	
	self assert: geoEllipse1 radiusInMeters1 ~= geoEllipse2 radiusInMeters1.
	self assert: geoEllipse1 radiusInMeters2 ~= geoEllipse2 radiusInMeters2.
	
	geoEllipse1 updateWith: geoEllipse2.

	self assert: geoEllipse1 radiusInMeters1 equals: geoEllipse2 radiusInMeters1.
	self assert: geoEllipse1 radiusInMeters2 equals: geoEllipse2 radiusInMeters2.
]
