"
A GeoShapeTest is a test class for testing the behavior of GeoShape
"
Class {
	#name : #GeoShapeTest,
	#superclass : #GeoObjectTest,
	#category : #'GeoView-Tests-GeoObjects'
}

{ #category : #testing }
GeoShapeTest class >> isAbstract [ 

	^ self == GeoShapeTest
]

{ #category : #'tests - instance' }
GeoShapeTest >> geoObject1 [

	| object |
	object := super geoObject1.

	^ object
		fillStyle: Color black asSmockFillStyle;
		strokeStyle: (Color red asSmockStrokeStyle width: 1; dashes: #(1 1));
		yourself.
]

{ #category : #'tests - instance' }
GeoShapeTest >> geoObject2 [

	| object |
	object := super geoObject2.

	^ object
		fillStyle: Color white asSmockFillStyle;
		strokeStyle: (Color blue asSmockStrokeStyle width: 2; dashes: #(5 5));
		yourself.
]

{ #category : #tests }
GeoShapeTest >> testCopy [

	| copy |
	super testCopy.
	copy := geoObject copy.

	self assert: copy fillStyle isNil.
	self assert: copy strokeStyle isNil.
]

{ #category : #tests }
GeoShapeTest >> testUpdateWith [

	| object1 object2 |
	
	super testUpdateWith.
	
	object1 := self geoObject1.
	object2 := self geoObject2.
	
	self assert: object1 fillStyle ~= object2 fillStyle.
	self assert: object1 strokeStyle ~= object2 strokeStyle.
	
	object1 updateWith: object2.
	
	self assert: object1 fillStyle equals: object2 fillStyle.
	self assert: object1 fillStyle ~~ object2 fillStyle.
	self assert: object1 strokeStyle equals: object2 strokeStyle.
	self assert: object1 strokeStyle ~~ object2 strokeStyle.
]
