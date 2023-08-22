"
I am a Display Circle.
I am used to display a Circle on a geo view.
"
Class {
	#name : #DCircle,
	#superclass : #DLeafShape,
	#instVars : [
		'radius'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
DCircle >> copy [
	| copy |
	copy := super copy.
	copy radius: self radius.
	^copy
]

{ #category : #accessing }
DCircle >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
DCircle >> radius [
	^ radius
]

{ #category : #accessing }
DCircle >> radius: anObject [
	radius := anObject
]
