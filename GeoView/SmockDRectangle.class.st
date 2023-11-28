"
I am a Display Rectangle.
I am used to display a rectangle on a geo view.
"
Class {
	#name : #SmockDRectangle,
	#superclass : #SmockDLeafShape,
	#instVars : [
		'length1',
		'length2',
		'orientation'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
SmockDRectangle >> copy [
	| copy |
	copy := super copy.
	copy length1: self length1.
	copy length2: self length2.
	copy orientation: self orientation.
	^copy
]

{ #category : #'initialize-release' }
SmockDRectangle >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
SmockDRectangle >> length1 [
	^ length1
]

{ #category : #accessing }
SmockDRectangle >> length1: anObject [
	length1 := anObject
]

{ #category : #accessing }
SmockDRectangle >> length2 [
	^ length2
]

{ #category : #accessing }
SmockDRectangle >> length2: anObject [
	length2 := anObject
]

{ #category : #accessing }
SmockDRectangle >> orientation [
	^ orientation
]

{ #category : #accessing }
SmockDRectangle >> orientation: anObject [
	orientation := anObject
]
