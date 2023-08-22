"
I am a Display Rectangle.
I am used to display a rectangle on a geo view.
"
Class {
	#name : #DRectangle,
	#superclass : #DLeafShape,
	#instVars : [
		'length1',
		'length2',
		'orientation'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
DRectangle >> copy [
	| copy |
	copy := super copy.
	copy length1: self length1.
	copy length2: self length2.
	copy orientation: self orientation.
	^copy
]

{ #category : #'initialize-release' }
DRectangle >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
DRectangle >> length1 [
	^ length1
]

{ #category : #accessing }
DRectangle >> length1: anObject [
	length1 := anObject
]

{ #category : #accessing }
DRectangle >> length2 [
	^ length2
]

{ #category : #accessing }
DRectangle >> length2: anObject [
	length2 := anObject
]

{ #category : #accessing }
DRectangle >> orientation [
	^ orientation
]

{ #category : #accessing }
DRectangle >> orientation: anObject [
	orientation := anObject
]
