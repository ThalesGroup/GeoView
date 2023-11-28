"
I am a Display Polygon.
I am used to display a polygon on a geo view.
"
Class {
	#name : #SmockDPolygon,
	#superclass : #SmockDLeafShape,
	#instVars : [
		'points'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
SmockDPolygon >> copy [
	| copy |
	copy := super copy.
	copy points: (self points collect:[ :p | p copy]).
	^copy
]

{ #category : #'initialize-release' }
SmockDPolygon >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
SmockDPolygon >> points [
	points isNil ifTrue:[points := OrderedCollection new].
	^ points
]

{ #category : #accessing }
SmockDPolygon >> points: anObject [
	points := anObject
]
