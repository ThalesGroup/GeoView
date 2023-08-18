"
A GeoShapeTest is a test class for testing the behavior of GeoShape
"
Class {
	#name : #GeoShapeTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - GeoObject'
}

{ #category : #'tests - instance' }
GeoShapeTest >> geoShape1 [

	^ GeoShape new
		absoluteCoordinates: AbsoluteCoordinates zero;
		isVisible: true;
		key: #shape1;
		fillColor: Color black;
		strokeColor: Color red;
		strokePattern: #(1 1);
		strokeWidth: 1;
		yourself.
]

{ #category : #'tests - instance' }
GeoShapeTest >> geoShape2 [

	^ GeoShape new
		absoluteCoordinates: (AbsoluteCoordinates latitudeInRadians: 0.5 longitudeInRadians: 0.5);
		isVisible: false;
		key: #shape2;
		fillColor: Color white;
		strokeColor: Color blue;
		strokePattern: #(5 5);
		strokeWidth: 2;
		yourself.
]

{ #category : #tests }
GeoShapeTest >> testCopy [

	| geoShape geoShapeCopy |
	geoShape := self geoShape1.
	geoShapeCopy := geoShape copy.
	
	self assert: geoShape fillColor equals: geoShapeCopy fillColor.
	self assert: geoShape fillColor ~~ geoShapeCopy fillColor.
	self assert: geoShape strokeColor equals: geoShapeCopy strokeColor.
	self assert: geoShape strokeColor ~~ geoShapeCopy strokeColor.
	self assert: geoShape strokePattern equals: geoShapeCopy strokePattern.
	self assert: geoShape strokePattern ~~ geoShapeCopy strokePattern.
	self assert: geoShape strokeWidth equals: geoShapeCopy strokeWidth.
]

{ #category : #tests }
GeoShapeTest >> testUpdateWith [

	| geoShape1 geoShape2 |
	geoShape1 := self geoShape1.
	geoShape2 := self geoShape2.
	
	geoShape1 updateWith: geoShape2.
	
	self assert: geoShape1 fillColor equals: geoShape2 fillColor.
	self assert: geoShape1 fillColor ~~ geoShape2 fillColor.
	self assert: geoShape1 strokeColor equals: geoShape2 strokeColor.
	self assert: geoShape1 strokeColor ~~ geoShape2 strokeColor.
	self assert: geoShape1 strokePattern equals: geoShape2 strokePattern.
	self assert: geoShape1 strokePattern ~~ geoShape2 strokePattern.
	self assert: geoShape1 strokeWidth equals: geoShape2 strokeWidth.
]
