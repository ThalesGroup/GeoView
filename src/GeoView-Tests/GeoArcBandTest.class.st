"
A GeoArcBandTest is a test class for testing the behavior of GeoArcBand
"
Class {
	#name : #GeoArcBandTest,
	#superclass : #GeoShapeTest,
	#category : #'GeoView-Tests-GeoObjects'
}

{ #category : #'tests - instance' }
GeoArcBandTest >> geoObject1 [

	| object |
	object := super geoObject1.

	^ object
		apertureInRadians: 5;
		orientationInAzimuths: 10;
		radiusInMeters1: 50;
		radiusInMeters2: 500;
		yourself.
]

{ #category : #'tests - instance' }
GeoArcBandTest >> geoObject2 [

	| object |
	object := super geoObject2.

	^ object
		apertureInRadians: 10;
		orientationInAzimuths: 20;
		radiusInMeters1: 100;
		radiusInMeters2: 1000;
		yourself.
]

{ #category : #accessing }
GeoArcBandTest >> geoObjectClass [

	^ GeoArcBand 
]

{ #category : #tests }
GeoArcBandTest >> testCopy [

	| copy |	
	super testCopy.
	copy := geoObject copy.

	self assert: geoObject apertureInRadians equals: copy apertureInRadians.
	self assert: geoObject orientationInAzimuths equals: copy orientationInAzimuths.
	self assert: geoObject radiusInMeters1 equals: copy radiusInMeters1.
	self assert: geoObject radiusInMeters2 equals: copy radiusInMeters2.
]

{ #category : #tests }
GeoArcBandTest >> testUpdateWith [

	| object1 object2 |
	
	super testUpdateWith.
	
	object1 := self geoObject1.
	object2 := self geoObject2.
	
	self assert: object1 apertureInRadians ~= object2 apertureInRadians.
	self assert: object1 orientationInAzimuths ~= object2 orientationInAzimuths.
	self assert: object1 radiusInMeters1 ~= object2 radiusInMeters1.
	self assert: object1 radiusInMeters2 ~= object2 radiusInMeters2.
	
	object1 updateWith: object2.

	self assert: object1 apertureInRadians equals: object2 apertureInRadians.
	self assert: object1 orientationInAzimuths equals: object2 orientationInAzimuths.
	self assert: object1 radiusInMeters1 equals: object2 radiusInMeters1.
	self assert: object1 radiusInMeters2 equals: object2 radiusInMeters2.
]
