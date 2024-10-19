"
A GeoObjectTest is a test class for testing the behavior of GeoObject
"
Class {
	#name : #GeoObjectTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - GeoObjects'
}

{ #category : #'tests - instance' }
GeoObjectTest >> geoObject1 [

	^GeoObject new
		absoluteCoordinates: AbsoluteCoordinates zero;
		key: #geoObject1;
		yourself.
]

{ #category : #'tests - instance' }
GeoObjectTest >> geoObject2 [

	^GeoObject new
		absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 0.2  longitudeInDegrees: 0.2);
		key: #geoObject2;
		isVisible: false;
		yourself.
]

{ #category : #tests }
GeoObjectTest >> testCopy [
	| geoObject geoObjectCopy |
	geoObject := self geoObject1.
	geoObjectCopy := geoObject copy.
	
	self assert: geoObject ~= geoObjectCopy.
	self assert: geoObject ~~ geoObjectCopy.
	self assert: geoObject key equals: geoObjectCopy key.
	self assert: geoObject absoluteCoordinates equals: geoObjectCopy absoluteCoordinates.
	self assert: geoObject absoluteCoordinates ~~ geoObjectCopy absoluteCoordinates.
	self assert: geoObject isVisible equals: geoObjectCopy isVisible
]

{ #category : #tests }
GeoObjectTest >> testUpdateWith [
	| geoObject1 geoObject2 |
	geoObject1 := self geoObject1.
	geoObject2 := self geoObject2.
	
	self assert: geoObject1 key equals: #geoObject1.
	self assert: geoObject2 key equals: #geoObject2.
	self assert: geoObject1 absoluteCoordinates ~= geoObject2 absoluteCoordinates.
	self assert: geoObject1 isVisible ~= geoObject2 isVisible.
	
	geoObject1 updateWith: geoObject2.
	
	self assert: geoObject1 key equals: #geoObject1.
	self assert: geoObject2 key equals: #geoObject2.
	self assert: geoObject1 absoluteCoordinates equals: geoObject2 absoluteCoordinates.
	self assert: geoObject1 isVisible equals: geoObject2 isVisible.
	
]
