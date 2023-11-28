"
I am a Display Circle.
I am used to display a Circle on a geo view.
"
Class {
	#name : #SmockDCircle,
	#superclass : #SmockDLeafShape,
	#instVars : [
		'radius'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
SmockDCircle >> copy [
	| copy |
	copy := super copy.
	copy radius: self radius.
	^copy
]

{ #category : #accessing }
SmockDCircle >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
SmockDCircle >> radius [
	^ radius
]

{ #category : #accessing }
SmockDCircle >> radius: anObject [
	radius := anObject
]
