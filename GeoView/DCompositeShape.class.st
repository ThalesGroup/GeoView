"
I am a Display Composite Shape.
I manage a group of DShape to compose the view like a Tree Model.
"
Class {
	#name : #DCompositeShape,
	#superclass : #DShape,
	#instVars : [
		'dShapeList',
		'toUpdateDShapeList',
		'toDeleteDShapeList',
		'hasUserDrawModeDShape'
	],
	#category : #'GeoView-DShape'
}

{ #category : #children }
DCompositeShape >> addDShape: aDShape [
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
DCompositeShape >> clearToDeleteDShapeList [
	self toDeleteDShapeList removeAll.
]

{ #category : #accessing }
DCompositeShape >> clearToUpdateDShapeList [
	self toUpdateDShapeList removeAll.
]

{ #category : #copying }
DCompositeShape >> copy [
	| copy |
	copy := super copy.
	copy dShapeList: (self dShapeList collect:[ :s | s copy]).
	copy toUpdateDShapeList: (self toUpdateDShapeList collect:[ :s | s copy]).
	copy toDeleteDShapeList: (self toDeleteDShapeList collect:[ :s | s copy]).
	^copy
]

{ #category : #accessing }
DCompositeShape >> dShapeList [
	dShapeList ifNil:[dShapeList := OrderedCollection new].
	^ dShapeList
]

{ #category : #accessing }
DCompositeShape >> dShapeList: anObject [
	dShapeList := anObject
]

{ #category : #children }
DCompositeShape >> deleteDShape: aDShape [
	((self includesDShape: aDShape) and:[(self toDeleteDShapeList  includes: aDShape) not]) ifTrue:[
		self toDeleteDShapeList add: aDShape.
	].
]

{ #category : #children }
DCompositeShape >> getDShape: aKey [
	"Get a DShape on the shape list"
	aKey ifNil:[^nil].
	^self dShapeList detect:[ :d | d key = aKey ] ifNone:[nil]
]

{ #category : #accessing }
DCompositeShape >> hasUserDrawModeDShape [
	hasUserDrawModeDShape ifNil:[hasUserDrawModeDShape := false].
	^hasUserDrawModeDShape
]

{ #category : #accessing }
DCompositeShape >> hasUserDrawModeDShape: aBoolean [
	hasUserDrawModeDShape := aBoolean
]

{ #category : #children }
DCompositeShape >> includesDShape: aDShape [
	aDShape ifNil:[^false].
	^self dShapeList includes: aDShape
]

{ #category : #children }
DCompositeShape >> includesDShapeKey: aKey [
	^(self getDShape: aKey) notNil
]

{ #category : #'initialize-release' }
DCompositeShape >> initialize [
	super initialize.
]

{ #category : #accessing }
DCompositeShape >> isComposite [
	^true
]

{ #category : #accessing }
DCompositeShape >> toDeleteDShapeList [
	toDeleteDShapeList ifNil:[toDeleteDShapeList := OrderedCollection new].
	^ toDeleteDShapeList
]

{ #category : #accessing }
DCompositeShape >> toDeleteDShapeList: anObject [
	 toDeleteDShapeList := anObject
]

{ #category : #accessing }
DCompositeShape >> toUpdateDShapeList [
	toUpdateDShapeList ifNil:[toUpdateDShapeList := OrderedCollection new].
	^ toUpdateDShapeList
]

{ #category : #accessing }
DCompositeShape >> toUpdateDShapeList: anObject [
	toUpdateDShapeList := anObject
]

{ #category : #children }
DCompositeShape >> updateDShape: aDShape [
	((self includesDShape: aDShape) and:[(self toUpdateDShapeList includes: aDShape) not]) ifTrue:[
		self toUpdateDShapeList add: aDShape.
	].
]
