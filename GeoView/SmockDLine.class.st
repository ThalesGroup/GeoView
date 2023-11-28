"
I am a Display Line.
I am used to display a line on a geo view.
"
Class {
	#name : #SmockDLine,
	#superclass : #SmockDLeafShape,
	#instVars : [
		'orientation'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
SmockDLine >> copy [
	| copy |
	copy := super copy.
	copy orientation: self orientation.
	^copy
]

{ #category : #'initialize-release' }
SmockDLine >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
SmockDLine >> orientation [
	^ orientation
]

{ #category : #accessing }
SmockDLine >> orientation: anObject [
	orientation := anObject
]
