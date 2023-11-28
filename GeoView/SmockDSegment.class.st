"
I am a Display Segment.
I am used to display a segment on a geo view.
"
Class {
	#name : #SmockDSegment,
	#superclass : #SmockDLeafShape,
	#instVars : [
		'coordinates2'
	],
	#category : #'GeoView-DShape'
}

{ #category : #accessing }
SmockDSegment >> coordinates2 [
	^ coordinates2
]

{ #category : #accessing }
SmockDSegment >> coordinates2: anObject [
	coordinates2 := anObject
]

{ #category : #copying }
SmockDSegment >> copy [
	| copy |
	copy := super copy.
	copy coordinates2: self coordinates2 copy.
	^copy
]

{ #category : #'initialize-release' }
SmockDSegment >> initialize [
	super initialize.
	drawMode := #user.
]
