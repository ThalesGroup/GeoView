"
I am a Display Polyline.
I am used to display a polyline on geo view.
"
Class {
	#name : #SmockDPolyline,
	#superclass : #SmockDLeafShape,
	#instVars : [
		'points'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
SmockDPolyline >> copy [
	| copy |
	copy := super copy.
	copy points: (self points collect:[ :p | p copy]).
	^copy
]

{ #category : #'initialize-release' }
SmockDPolyline >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
SmockDPolyline >> points [
	points isNil ifTrue:[points := OrderedCollection new].
	^ points
]

{ #category : #accessing }
SmockDPolyline >> points: anObject [
	points := anObject
]
