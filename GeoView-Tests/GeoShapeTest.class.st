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
		fillStyle: Color black asSmockFillStyle;
		strokeStyle: (Color red asSmockStrokeStyle width: 1; dashes: #(1 1));
		yourself.
]

{ #category : #'tests - instance' }
GeoShapeTest >> geoShape2 [

	^ GeoShape new
		absoluteCoordinates: (AbsoluteCoordinates latitudeInRadians: 0.5 longitudeInRadians: 0.5);
		isVisible: false;
		key: #shape2;
		fillStyle: Color white asSmockFillStyle;
		strokeStyle: (Color blue asSmockStrokeStyle width: 2; dashes: #(5 5));
		yourself.
]

{ #category : #tests }
GeoShapeTest >> testCopy [

	| geoShape geoShapeCopy |
	geoShape := self geoShape1.
	geoShapeCopy := geoShape copy.
	
	self assert: geoShape fillStyle equals: geoShapeCopy fillStyle.
	self assert: geoShape fillStyle ~~ geoShapeCopy fillStyle.
	self assert: geoShape strokeStyle equals: geoShapeCopy strokeStyle.
	self assert: geoShape strokeStyle ~~ geoShapeCopy strokeStyle.

	
	
]

{ #category : #tests }
GeoShapeTest >> testUpdateWith [

	| geoShape1 geoShape2 |
	geoShape1 := self geoShape1.
	geoShape2 := self geoShape2.
	
	geoShape1 updateWith: geoShape2.
	
	self assert: geoShape1 fillStyle equals: geoShape2 fillStyle.
	self assert: geoShape1 fillStyle ~~ geoShape2 fillStyle.
	self assert: geoShape1 strokeStyle equals: geoShape2 strokeStyle.
	self assert: geoShape1 strokeStyle ~~ geoShape2 strokeStyle.
]
