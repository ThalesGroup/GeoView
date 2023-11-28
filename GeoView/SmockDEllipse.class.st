"
I am a Display Ellipse.
I am used to display an ellipse on a geo view.
"
Class {
	#name : #SmockDEllipse,
	#superclass : #SmockDLeafShape,
	#instVars : [
		'radius1',
		'radius2',
		'orientation'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
SmockDEllipse >> copy [
	| copy |
	copy := super copy.
	copy radius1: self radius1.
	copy radius2: self radius2.
	copy orientation: self orientation.
	^copy
]

{ #category : #'initialize-release' }
SmockDEllipse >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
SmockDEllipse >> orientation [
	^ orientation
]

{ #category : #accessing }
SmockDEllipse >> orientation: anObject [
	orientation := anObject
]

{ #category : #accessing }
SmockDEllipse >> radius1 [
	^ radius1
]

{ #category : #accessing }
SmockDEllipse >> radius1: anObject [
	radius1 := anObject
]

{ #category : #accessing }
SmockDEllipse >> radius2 [
	^ radius2
]

{ #category : #accessing }
SmockDEllipse >> radius2: anObject [
	radius2 := anObject
]
