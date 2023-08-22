"
I am a root DisplayShape.
I am used to convert a geographical coordinate data to a user coordinates graphic data.
"
Class {
	#name : #DShape,
	#superclass : #Object,
	#instVars : [
		'key',
		'coordinates',
		'isVisible',
		'drawMode',
		'displayMask',
		'displayOffset'
	],
	#category : #'GeoView-DShape'
}

{ #category : #accessing }
DShape class >> key: aKey [
	| dShape |
	dShape := self new.
	dShape key: aKey.
	^ dShape
]

{ #category : #accessing }
DShape >> = aDShape [ 
	"compare each values of the DShape"
	self key ~= aDShape key ifTrue:[^false].
	self coordinates ~= aDShape coordinates ifTrue:[^false].
	self isVisible ~= aDShape isVisible ifTrue:[^false].
	self displayMask ~= aDShape displayMask ifTrue:[^false].
	self displayOffset ~= aDShape displayOffset ifTrue:[^false].
	
	^true
]

{ #category : #accessing }
DShape >> coordinates [
	^ coordinates
]

{ #category : #accessing }
DShape >> coordinates: anObject [
	coordinates := anObject
]

{ #category : #copying }
DShape >> copy [
	| copy |
	copy := self class new.
	copy key: self key copy.		
	copy coordinates: self coordinates copy.
	copy  isVisible: self isVisible.
	copy displayMask: self displayMask copy.
	copy displayOffset: self displayOffset copy.
	^copy
]

{ #category : #accessing }
DShape >> displayMask [
	^ displayMask
]

{ #category : #accessing }
DShape >> displayMask: anObject [
	displayMask := anObject
]

{ #category : #accessing }
DShape >> displayOffset [
	^ displayOffset
]

{ #category : #accessing }
DShape >> displayOffset: anObject [
	displayOffset := anObject
]

{ #category : #'initialize-release' }
DShape >> initialize [
	super initialize.
]

{ #category : #accessing }
DShape >> isComposite [
	^false
]

{ #category : #accessing }
DShape >> isLeaf [
	^ false 
]

{ #category : #accessing }
DShape >> isVisible [
	isVisible ifNil:[isVisible := true].
	^ isVisible
]

{ #category : #accessing }
DShape >> isVisible: anObject [
	isVisible := anObject
]

{ #category : #accessing }
DShape >> key [
	^ key
]

{ #category : #accessing }
DShape >> key: anObject [
	key := anObject
]
