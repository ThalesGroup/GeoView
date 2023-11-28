"
I am a Display Composite Shape.
I manage a group of DShape to compose the view like a Tree Model.
"
Class {
	#name : #SmockDCompositeShape,
	#superclass : #SmockDShape,
	#instVars : [
		'dShapeList',
		'toUpdateDShapeList',
		'toDeleteDShapeList',
		'hasUserDrawModeDShape'
	],
	#category : #'GeoView-DShape'
}

{ #category : #children }
SmockDCompositeShape >> addDShape: aDShape [
	(self includesDShape: aDShape) ifFalse:[
		self flag:'PLA : provisoire, lorsque la ou les DShape filles changent de mode de dessin la variable nest pas encore mise a jour'.
		aDShape isLeaf ifTrue:[
			aDShape isDrawModeUser ifTrue:[self hasUserDrawModeDShape: true].
		] ifFalse:[
			(aDShape isComposite and:[aDShape hasUserDrawModeDShape]) ifTrue:[self hasUserDrawModeDShape: true].
		].
		self dShapeList add: aDShape.
	].
]

{ #category : #accessing }
SmockDCompositeShape >> clearToDeleteDShapeList [
	self toDeleteDShapeList removeAll.
]

{ #category : #accessing }
SmockDCompositeShape >> clearToUpdateDShapeList [
	self toUpdateDShapeList removeAll.
]

{ #category : #copying }
SmockDCompositeShape >> copy [
	| copy |
	copy := super copy.
	copy dShapeList: (self dShapeList collect:[ :s | s copy]).
	copy toUpdateDShapeList: (self toUpdateDShapeList collect:[ :s | s copy]).
	copy toDeleteDShapeList: (self toDeleteDShapeList collect:[ :s | s copy]).
	^copy
]

{ #category : #accessing }
SmockDCompositeShape >> dShapeList [
	dShapeList ifNil:[dShapeList := OrderedCollection new].
	^ dShapeList
]

{ #category : #accessing }
SmockDCompositeShape >> dShapeList: anObject [
	dShapeList := anObject
]

{ #category : #children }
SmockDCompositeShape >> deleteDShape: aDShape [
	((self includesDShape: aDShape) and:[(self toDeleteDShapeList  includes: aDShape) not]) ifTrue:[
		self toDeleteDShapeList add: aDShape.
	].
]

{ #category : #children }
SmockDCompositeShape >> getDShape: aKey [
	"Get a DShape on the shape list"
	aKey ifNil:[^nil].
	^self dShapeList detect:[ :d | d key = aKey ] ifNone:[nil]
]

{ #category : #accessing }
SmockDCompositeShape >> hasUserDrawModeDShape [
	hasUserDrawModeDShape ifNil:[hasUserDrawModeDShape := false].
	^hasUserDrawModeDShape
]

{ #category : #accessing }
SmockDCompositeShape >> hasUserDrawModeDShape: aBoolean [
	hasUserDrawModeDShape := aBoolean
]

{ #category : #children }
SmockDCompositeShape >> includesDShape: aDShape [
	aDShape ifNil:[^false].
	^self dShapeList includes: aDShape
]

{ #category : #children }
SmockDCompositeShape >> includesDShapeKey: aKey [
	^(self getDShape: aKey) notNil
]

{ #category : #'initialize-release' }
SmockDCompositeShape >> initialize [
	super initialize.
]

{ #category : #accessing }
SmockDCompositeShape >> isComposite [
	^true
]

{ #category : #accessing }
SmockDCompositeShape >> toDeleteDShapeList [
	toDeleteDShapeList ifNil:[toDeleteDShapeList := OrderedCollection new].
	^ toDeleteDShapeList
]

{ #category : #accessing }
SmockDCompositeShape >> toDeleteDShapeList: anObject [
	 toDeleteDShapeList := anObject
]

{ #category : #accessing }
SmockDCompositeShape >> toUpdateDShapeList [
	toUpdateDShapeList ifNil:[toUpdateDShapeList := OrderedCollection new].
	^ toUpdateDShapeList
]

{ #category : #accessing }
SmockDCompositeShape >> toUpdateDShapeList: anObject [
	toUpdateDShapeList := anObject
]

{ #category : #children }
SmockDCompositeShape >> updateDShape: aDShape [
	((self includesDShape: aDShape) and:[(self toUpdateDShapeList includes: aDShape) not]) ifTrue:[
		self toUpdateDShapeList add: aDShape.
	].
]
