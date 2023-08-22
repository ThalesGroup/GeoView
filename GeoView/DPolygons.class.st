Class {
	#name : #DPolygons,
	#superclass : #DLeafShape,
	#instVars : [
		'points'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
DPolygons >> copy [
	| copy |
	copy := super copy.
	copy points: (self points collect:[ :p | p copy]).
	^copy
]

{ #category : #'initialize-release' }
DPolygons >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
DPolygons >> points [
	points isNil ifTrue:[points := OrderedCollection new].
	^ points
]

{ #category : #accessing }
DPolygons >> points: anObject [
	points := anObject
]
