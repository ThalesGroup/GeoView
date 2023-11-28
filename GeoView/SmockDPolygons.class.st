Class {
	#name : #SmockDPolygons,
	#superclass : #SmockDLeafShape,
	#instVars : [
		'points'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
SmockDPolygons >> copy [
	| copy |
	copy := super copy.
	copy points: (self points collect:[ :p | p copy]).
	^copy
]

{ #category : #'initialize-release' }
SmockDPolygons >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
SmockDPolygons >> points [
	points isNil ifTrue:[points := OrderedCollection new].
	^ points
]

{ #category : #accessing }
SmockDPolygons >> points: anObject [
	points := anObject
]
