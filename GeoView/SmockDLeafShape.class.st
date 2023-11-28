"
I am a Display Leaf Shape.
I display a final graphic element.
"
Class {
	#name : #SmockDLeafShape,
	#superclass : #SmockDShape,
	#instVars : [
		'fillColor',
		'strokeColor',
		'strokeWidth',
		'strokePattern'
	],
	#category : #'GeoView-DShape'
}

{ #category : #copying }
SmockDLeafShape >> = aDLeafShape [ 
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
SmockDLeafShape >> copy [
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
SmockDLeafShape >> drawMode [
	drawMode ifNil: [ ^ #device ].
	^ drawMode
]

{ #category : #accessing }
SmockDLeafShape >> drawMode: anObject [
	drawMode := anObject
]

{ #category : #accessing }
SmockDLeafShape >> fillColor [
	^ fillColor
]

{ #category : #accessing }
SmockDLeafShape >> fillColor: anObject [
	fillColor := anObject
]

{ #category : #'draw mode' }
SmockDLeafShape >> isDrawModeDevice [
	^self drawMode = #device
]

{ #category : #'draw mode' }
SmockDLeafShape >> isDrawModeUser [
	^self drawMode = #user
]

{ #category : #'draw mode' }
SmockDLeafShape >> isDrawModeUserProjected [
	^self drawMode = #userProjected
]

{ #category : #'draw mode' }
SmockDLeafShape >> isLeaf [
	^ true
]

{ #category : #'draw mode' }
SmockDLeafShape >> setDrawModeDevice [
	self drawMode: #device
]

{ #category : #'draw mode' }
SmockDLeafShape >> setDrawModeUser [
	self drawMode: #user
]

{ #category : #'draw mode' }
SmockDLeafShape >> setDrawModeUserProjected [
	self drawMode: #userProjected
]

{ #category : #accessing }
SmockDLeafShape >> strokeColor [
	^ strokeColor
]

{ #category : #accessing }
SmockDLeafShape >> strokeColor: anObject [
	strokeColor := anObject
]

{ #category : #accessing }
SmockDLeafShape >> strokePattern [
	^ strokePattern
]

{ #category : #accessing }
SmockDLeafShape >> strokePattern: anObject [
	strokePattern := anObject
]

{ #category : #accessing }
SmockDLeafShape >> strokeWidth [
	^ strokeWidth
]

{ #category : #accessing }
SmockDLeafShape >> strokeWidth: anObject [
	strokeWidth := anObject
]
