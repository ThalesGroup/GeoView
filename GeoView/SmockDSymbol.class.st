"
I am a Display Symbol.
I am used to display a Image (using SymbolProvider and a key) on a geo view.
"
Class {
	#name : #SmockDSymbol,
	#superclass : #SmockDLeafShape,
	#instVars : [
		'symbolKey',
		'orientation'
	],
	#category : #'GeoView-DShape'
}

{ #category : #accessing }
SmockDSymbol >> = aDSymbol [ 
	"compare each values of the aDSymbol"
	super = aDSymbol ifFalse:[^false].
	self symbolKey ~= aDSymbol symbolKey ifTrue:[^false].
	self orientation ~= aDSymbol orientation ifTrue:[^false].
	^true
]

{ #category : #accessing }
SmockDSymbol >> copy [
	| copy |
	copy := super copy.
	copy symbolKey: self symbolKey.
	copy orientation: self orientation.
	^copy
]

{ #category : #accessing }
SmockDSymbol >> initialize [
	super initialize.
	drawMode := #user.
]

{ #category : #accessing }
SmockDSymbol >> orientation [
	^ orientation
]

{ #category : #accessing }
SmockDSymbol >> orientation: anObject [
	orientation := anObject
]

{ #category : #accessing }
SmockDSymbol >> symbolKey [
	^ symbolKey
]

{ #category : #accessing }
SmockDSymbol >> symbolKey: anObject [
	symbolKey := anObject
]
