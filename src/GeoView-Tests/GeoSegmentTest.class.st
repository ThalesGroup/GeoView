"
A GeoSegmentTest is a test class for testing the behavior of GeoSegment
"
Class {
	#name : #GeoSegmentTest,
	#superclass : #TestCase,
	#instVars : [
		'geoObject'
	],
	#category : #'GeoView-Tests-GeoObjects'
}

{ #category : #running }
GeoSegmentTest >> geoSegment1 [

	^ GeoSegment new
		isVisible: true;
		key: #segment1;
		fillStyle: Color black asSmockFillStyle;
		strokeStyle: (Color red asSmockStrokeStyle width: 1);
		fromAbsolutePosition: AbsoluteCoordinates zero;
		toAbsolutePosition: (1@1) asAbsoluteCoordinates;
		yourself.
]

{ #category : #running }
GeoSegmentTest >> geoSegment2 [

	^ GeoSegment new
		isVisible: true;
		key: #segment2;
		fillStyle: Color black asSmockFillStyle;
		strokeStyle: (Color red asSmockStrokeStyle width: 1);
		fromAbsolutePosition: (1@1) asAbsoluteCoordinates ;
		toAbsolutePosition: (2@2) asAbsoluteCoordinates;
		yourself.
]

{ #category : #running }
GeoSegmentTest >> setUp [
	super setUp.

	geoObject := GeoSegment new.
]

{ #category : #running }
GeoSegmentTest >> testCopy [

	| geoSegment geoSegmentCopy |
	geoSegment := self geoSegment1.
	geoSegmentCopy := geoSegment copy.
		
	self assert: geoSegment fromAbsolutePosition equals: geoSegmentCopy fromAbsolutePosition.
	self assert: geoSegment toAbsolutePosition equals: geoSegmentCopy toAbsolutePosition.
]

{ #category : #running }
GeoSegmentTest >> testFromAbsolutePosition [

	self assert: geoObject fromAbsolutePosition isNil.
	
	geoObject fromAbsolutePosition: AbsoluteCoordinates zero.
	self assert: geoObject fromAbsolutePosition equals: AbsoluteCoordinates zero.
]

{ #category : #running }
GeoSegmentTest >> testToAbsolutePosition [

	self assert: geoObject toAbsolutePosition isNil.
	
	geoObject toAbsolutePosition: AbsoluteCoordinates zero.
	self assert: geoObject toAbsolutePosition equals: AbsoluteCoordinates zero.
]

{ #category : #running }
GeoSegmentTest >> testUpdateWith [

	| geoSegment1 geoSegment2 |
	geoSegment1 := self geoSegment1.
	geoSegment2 := self geoSegment2.
		
	self deny: geoSegment1 fromAbsolutePosition equals: geoSegment2 fromAbsolutePosition.
	self deny: geoSegment1 toAbsolutePosition equals: geoSegment2 toAbsolutePosition.
	
	geoSegment1 updateWith: geoSegment2.
	
	self assert: geoSegment1 fromAbsolutePosition equals: geoSegment2 fromAbsolutePosition.
	self assert: geoSegment1 toAbsolutePosition equals: geoSegment2 toAbsolutePosition.
]
