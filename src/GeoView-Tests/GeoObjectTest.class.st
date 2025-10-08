"
A GeoObjectTest is a test class for testing the behavior of GeoObject
"
Class {
	#name : #GeoObjectTest,
	#superclass : #TestCase,
	#instVars : [
		'geoObject'
	],
	#category : #'GeoView-Tests-GeoObjects'
}

{ #category : #testing }
GeoObjectTest class >> isAbstract [ 

	^ self == GeoObjectTest 
]

{ #category : #'tests - instance' }
GeoObjectTest >> geoObject1 [

	^self geoObjectClass new
		absoluteCoordinates: AbsoluteCoordinates zero;
		key: #geoObject1;
		yourself.
]

{ #category : #'tests - instance' }
GeoObjectTest >> geoObject2 [

	^self geoObjectClass new
		absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 0.2  longitudeInDegrees: 0.2);
		key: #geoObject2;
		isVisible: false;
		yourself.
]

{ #category : #accessing }
GeoObjectTest >> geoObjectClass [

	^ self subclassResponsibility 
]

{ #category : #running }
GeoObjectTest >> setUp [

	super setUp.

	geoObject := self geoObjectClass new
]

{ #category : #tests }
GeoObjectTest >> testCopy [

	| copy |
	copy := geoObject copy.
	
	self assert: geoObject ~= copy.
	self assert: geoObject ~~ copy.
	self assert: geoObject key equals: copy key.
	self assert: copy absoluteCoordinates isNil.
	self assert: geoObject isVisible equals: copy isVisible
]

{ #category : #tests }
GeoObjectTest >> testCopyGeoObject1 [

	| copy |
	copy := self geoObject1 copy.
	
	self assert: self geoObject1 ~= copy.
	self assert: self geoObject1 ~~ copy.
	self assert: self geoObject1 key equals: copy key.
	self assert: self geoObject1 absoluteCoordinates equals: copy absoluteCoordinates.
	self assert: self geoObject1 absoluteCoordinates ~~ copy absoluteCoordinates.
	self assert: self geoObject1 isVisible equals: copy isVisible
]

{ #category : #tests }
GeoObjectTest >> testCopyGeoObject2 [

	| copy |
	copy := self geoObject2 copy.
	
	self assert: self geoObject2 ~= copy.
	self assert: self geoObject2 ~~ copy.
	self assert: self geoObject2 key equals: copy key.
	self assert: self geoObject2 absoluteCoordinates equals: copy absoluteCoordinates.
	self assert: self geoObject2 absoluteCoordinates ~~ copy absoluteCoordinates.
	self assert: self geoObject2 isVisible equals: copy isVisible
]

{ #category : #tests }
GeoObjectTest >> testUpdateWith [
	| object1 object2 |
	
	object1 := self geoObject1.
	object2 := self geoObject2.
	
	self assert: object1 key equals: #geoObject1.
	self assert: object2 key equals: #geoObject2.
	self assert: object1 absoluteCoordinates ~= object2 absoluteCoordinates.
	self assert: object1 isVisible ~= object2 isVisible.
	
	object1 updateWith: object2.
	
	self assert: object1 key equals: #geoObject1.
	self assert: object2 key equals: #geoObject2.
	self assert: object1 absoluteCoordinates equals: object2 absoluteCoordinates.
	self assert: object1 isVisible equals: object2 isVisible.
	
]
