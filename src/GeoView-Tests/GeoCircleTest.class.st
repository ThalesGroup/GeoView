"
A GeoCircleTest is a test class for testing the behavior of GeoCircle
"
Class {
	#name : #GeoCircleTest,
	#superclass : #GeoShapeTest,
	#category : #'GeoView-Tests-GeoObjects'
}

{ #category : #'tests - instance' }
GeoCircleTest >> geoObject1 [

	| object |
	object := super geoObject1.

	^ object
		radiusInMeters: 5;
		yourself.
]

{ #category : #'tests - instance' }
GeoCircleTest >> geoObject2 [

	| object |
	object := super geoObject2.

	^ object
		radiusInMeters: 10;
		yourself.
]

{ #category : #accessing }
GeoCircleTest >> geoObjectClass [

	^ GeoCircle 
]

{ #category : #tests }
GeoCircleTest >> testCopy [

	| copy |	
	super testCopy.
	copy := geoObject copy.
		
	self assert: geoObject radiusInMeters equals: copy radiusInMeters
]

{ #category : #tests }
GeoCircleTest >> testUpdateWith [
	| object1 object2 |
	
	super testUpdateWith.
	
	object1 := self geoObject1.
	object2 := self geoObject2.
		
	self assert: object1 radiusInMeters ~= object2 radiusInMeters.
	
	object1 updateWith: object2.

	self assert: object1 radiusInMeters equals: object2 radiusInMeters.
]
