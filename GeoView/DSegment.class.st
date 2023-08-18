"
I am a Display Segment.
I am used to display a segment on a geo view.
"
Class {
	#name : #DSegment,
	#superclass : #DLeafShape,
	#instVars : [
		'coordinates2'
	],
	#category : #'GeoView-DShape'
}

{ #category : #accessing }
DSegment >> coordinates2 [
	^ coordinates2
]

{ #category : #accessing }
DSegment >> coordinates2: anObject [
	coordinates2 := anObject
]

{ #category : #copying }
DSegment >> copy [
	| copy |
	copy := super copy.
	copy coordinates2: self coordinates2 copy.
	^copy
]

{ #category : #'initialize-release' }
DSegment >> initialize [
	super initialize.
	drawMode := #user.
]
