"
I am a Display Line.
I am used to display a line on a geo view.
"
Class {
	#name : #DLine,
	#superclass : #DLeafShape,
	#instVars : [
		'orientation'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
DLine >> copy [
	| copy |
	copy := super copy.
	copy orientation: self orientation.
	^copy
]

{ #category : #'initialize-release' }
DLine >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
DLine >> orientation [
	^ orientation
]

{ #category : #accessing }
DLine >> orientation: anObject [
	orientation := anObject
]
