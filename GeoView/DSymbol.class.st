"
I am a Display Symbol.
I am used to display a Image (using SymbolProvider and a key) on a geo view.
"
Class {
	#name : #DSymbol,
	#superclass : #DLeafShape,
	#instVars : [
		'symbolKey',
		'orientation'
	],
	#category : #'GeoView-DShape'
}

{ #category : #accessing }
DSymbol >> = aDSymbol [ 
	"compare each values of the aDSymbol"
	super = aDSymbol ifFalse:[^false].
	self symbolKey ~= aDSymbol symbolKey ifTrue:[^false].
	self orientation ~= aDSymbol orientation ifTrue:[^false].
	^true
]

{ #category : #accessing }
DSymbol >> copy [
	| copy |
	copy := super copy.
	copy symbolKey: self symbolKey.
	copy orientation: self orientation.
	^copy
]

{ #category : #accessing }
DSymbol >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
DSymbol >> orientation [
	^ orientation
]

{ #category : #accessing }
DSymbol >> orientation: anObject [
	orientation := anObject
]

{ #category : #accessing }
DSymbol >> symbolKey [
	^ symbolKey
]

{ #category : #accessing }
DSymbol >> symbolKey: anObject [
	symbolKey := anObject
]
