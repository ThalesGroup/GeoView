"
A GeoEllipseTest is a test class for testing the behavior of GeoEllipse
"
Class {
	#name : #GeoEllipseTest,
	#superclass : #GeoShapeTest,
	#category : #'GeoView-Tests-GeoObjects'
}

{ #category : #'tests - instance' }
GeoEllipseTest >> geoObject1 [

	| object |
	object := super geoObject1.

	^ object
		radiusInMeters1: 5;
		radiusInMeters2: 10;
		yourself.
]

{ #category : #'tests - instance' }
GeoEllipseTest >> geoObject2 [

	| object |
	object := super geoObject2.

	^ object
		radiusInMeters1: 10;
		radiusInMeters2: 20;
		yourself.
]

{ #category : #accessing }
GeoEllipseTest >> geoObjectClass [

	^ GeoEllipse 
]

{ #category : #tests }
GeoEllipseTest >> testCopy [

	| copy |	
	super testCopy.
	copy := geoObject copy.
		
	self assert: geoObject radiusInMeters1 equals: copy radiusInMeters1.
	self assert: geoObject radiusInMeters2 equals: copy radiusInMeters2.
]

{ #category : #tests }
GeoEllipseTest >> testUpdateWith [
	| object1 object2 |
	
	super testUpdateWith.
	
	object1 := self geoObject1.
	object2 := self geoObject2.
	
	self assert: object1 radiusInMeters1 ~= object2 radiusInMeters1.
	self assert: object1 radiusInMeters2 ~= object2 radiusInMeters2.
	
	object1 updateWith: object2.

	self assert: object1 radiusInMeters1 equals: object2 radiusInMeters1.
	self assert: object1 radiusInMeters2 equals: object2 radiusInMeters2.
]
