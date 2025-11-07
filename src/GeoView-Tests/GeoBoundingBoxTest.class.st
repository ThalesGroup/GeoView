Class {
	#name : #GeoBoundingBoxTest,
	#superclass : #GeoShapeTest,
	#category : #'GeoView-Tests-GeoObjects'
}

{ #category : #'tests - instance' }
GeoBoundingBoxTest >> geoObject1 [

	| object |
	object := super geoObject1.

	^ object
		topLeftAbsoluteCoordinates: AbsoluteCoordinates frBrest;
		bottomRightAbsoluteCoordinates: AbsoluteCoordinates frNevers;
		yourself.
]

{ #category : #'tests - instance' }
GeoBoundingBoxTest >> geoObject2 [

	| object |
	object := super geoObject2.

	^ object
		topLeftAbsoluteCoordinates: AbsoluteCoordinates frParis;
		bottomRightAbsoluteCoordinates: AbsoluteCoordinates frLyon;
		yourself.
]

{ #category : #accessing }
GeoBoundingBoxTest >> geoObjectClass [

	^ GeoBoundingBox 
]

{ #category : #tests }
GeoBoundingBoxTest >> testAbsoluteCoordinates [
	"absolute coordinates is a read-only accessor"
	
	self assert: geoObject absoluteCoordinates isNil.
	
	geoObject absoluteCoordinates: AbsoluteCoordinates zero.
	self assert: geoObject absoluteCoordinates isNil.
	
]

{ #category : #tests }
GeoBoundingBoxTest >> testCopy [

	| copy |	
	super testCopy.
	copy := geoObject copy.

	self assert: geoObject topLatitudeInDegrees equals: copy topLatitudeInDegrees.
	self assert: geoObject rightLongitudeInDegrees equals: copy rightLongitudeInDegrees.
	self assert: geoObject bottomLatitudeInDegrees equals: copy bottomLatitudeInDegrees.
	self assert: geoObject leftLongitudeInDegrees equals: copy leftLongitudeInDegrees.
]

{ #category : #tests }
GeoBoundingBoxTest >> testUpdateWith [
	| object1 object2 |
	
	super testUpdateWith.
	
	object1 := self geoObject1.
	object2 := self geoObject2.
		
	self assert: object1 topLatitudeInDegrees ~= object2 topLatitudeInDegrees.
	self assert: object1 rightLongitudeInDegrees ~= object2 rightLongitudeInDegrees.
	self assert: object1 bottomLatitudeInDegrees ~= object2 bottomLatitudeInDegrees.
	self assert: object1 leftLongitudeInDegrees ~= object2 leftLongitudeInDegrees.
		
	object1 updateWith: object2.

	self assert: object1 topLatitudeInDegrees equals: object2 topLatitudeInDegrees.
	self assert: object1 rightLongitudeInDegrees equals: object2 rightLongitudeInDegrees.
	self assert: object1 bottomLatitudeInDegrees equals: object2 bottomLatitudeInDegrees.
	self assert: object1 leftLongitudeInDegrees equals: object2 leftLongitudeInDegrees.
]
