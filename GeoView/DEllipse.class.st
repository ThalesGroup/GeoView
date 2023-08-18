"
I am a Display Ellipse.
I am used to display an ellipse on a geo view.
"
Class {
	#name : #DEllipse,
	#superclass : #DLeafShape,
	#instVars : [
		'radius1',
		'radius2',
		'orientation'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
DEllipse >> copy [
	| copy |
	copy := super copy.
	copy radius1: self radius1.
	copy radius2: self radius2.
	copy orientation: self orientation.
	^copy
]

{ #category : #'initialize-release' }
DEllipse >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
DEllipse >> orientation [
	^ orientation
]

{ #category : #accessing }
DEllipse >> orientation: anObject [
	orientation := anObject
]

{ #category : #accessing }
DEllipse >> radius1 [
	^ radius1
]

{ #category : #accessing }
DEllipse >> radius1: anObject [
	radius1 := anObject
]

{ #category : #accessing }
DEllipse >> radius2 [
	^ radius2
]

{ #category : #accessing }
DEllipse >> radius2: anObject [
	radius2 := anObject
]
