"
I am a Display Polyline.
I am used to display a polyline on geo view.
"
Class {
	#name : #DPolyline,
	#superclass : #DLeafShape,
	#instVars : [
		'points'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
DPolyline >> copy [
	| copy |
	copy := super copy.
	copy points: (self points collect:[ :p | p copy]).
	^copy
]

{ #category : #'initialize-release' }
DPolyline >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
DPolyline >> points [
	points isNil ifTrue:[points := OrderedCollection new].
	^ points
]

{ #category : #accessing }
DPolyline >> points: anObject [
	points := anObject
]
