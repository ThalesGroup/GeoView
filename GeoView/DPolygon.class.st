"
I am a Display Polygon.
I am used to display a polygon on a geo view.
"
Class {
	#name : #DPolygon,
	#superclass : #DLeafShape,
	#instVars : [
		'points'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
DPolygon >> copy [
	| copy |
	copy := super copy.
	copy points: (self points collect:[ :p | p copy]).
	^copy
]

{ #category : #'initialize-release' }
DPolygon >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
DPolygon >> points [
	points isNil ifTrue:[points := OrderedCollection new].
	^ points
]

{ #category : #accessing }
DPolygon >> points: anObject [
	points := anObject
]
