"
I am a Display Leaf Shape.
I display a final graphic element.
"
Class {
	#name : #DLeafShape,
	#superclass : #DShape,
	#instVars : [
		'fillColor',
		'strokeColor',
		'strokeWidth',
		'strokePattern'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
DLeafShape >> = aDLeafShape [ 
	"compare each values of the DLeafShape"
	super = aDLeafShape ifFalse:[^false].
	self drawMode ~= aDLeafShape drawMode ifTrue:[^false].
	self fillColor ~= aDLeafShape fillColor ifTrue:[^false].
	self strokeColor ~= aDLeafShape strokeColor ifTrue:[^false].
	self strokeWidth ~= aDLeafShape strokeWidth ifTrue:[^false].
	self strokePattern ~= aDLeafShape strokePattern ifTrue:[^false].
	
	^true
]

{ #category : #copying }
DLeafShape >> copy [
	| copy |
	copy := super copy.
	copy drawMode: self drawMode.
	copy fillColor: self fillColor copy.
	copy strokeColor: self strokeColor copy.
	copy strokeWidth: self strokeWidth.
	copy strokePattern: self strokePattern copy.
	^copy
]

{ #category : #accessing }
DLeafShape >> drawMode [
	drawMode ifNil: [ ^ #device ].
	^ drawMode
]

{ #category : #accessing }
DLeafShape >> drawMode: anObject [
	drawMode := anObject
]

{ #category : #accessing }
DLeafShape >> fillColor [
	^ fillColor
]

{ #category : #accessing }
DLeafShape >> fillColor: anObject [
	fillColor := anObject
]

{ #category : #'draw mode' }
DLeafShape >> isDrawModeDevice [
	^self drawMode = #device
]

{ #category : #'draw mode' }
DLeafShape >> isDrawModeUser [
	^self drawMode = #user
]

{ #category : #'draw mode' }
DLeafShape >> isDrawModeUserProjected [
	^self drawMode = #userProjected
]

{ #category : #'draw mode' }
DLeafShape >> isLeaf [
	^ true
]

{ #category : #'draw mode' }
DLeafShape >> setDrawModeDevice [
	self drawMode: #device
]

{ #category : #'draw mode' }
DLeafShape >> setDrawModeUser [
	self drawMode: #user
]

{ #category : #'draw mode' }
DLeafShape >> setDrawModeUserProjected [
	self drawMode: #userProjected
]

{ #category : #accessing }
DLeafShape >> strokeColor [
	^ strokeColor
]

{ #category : #accessing }
DLeafShape >> strokeColor: anObject [
	strokeColor := anObject
]

{ #category : #accessing }
DLeafShape >> strokePattern [
	^ strokePattern
]

{ #category : #accessing }
DLeafShape >> strokePattern: anObject [
	strokePattern := anObject
]

{ #category : #accessing }
DLeafShape >> strokeWidth [
	^ strokeWidth
]

{ #category : #accessing }
DLeafShape >> strokeWidth: anObject [
	strokeWidth := anObject
]
