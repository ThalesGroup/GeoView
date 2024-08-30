"
A BlAbstractGeoViewElementTest is a test class for testing the behavior of BlAbstractGeoViewElement
"
Class {
	#name : #BlAbstractGeoViewElementTest,
	#superclass : #TestCase,
	#category : #'GeoView-Bloc-Tests-Core'
}

{ #category : #tests }
BlAbstractGeoViewElementTest >> testInteractionsStrategy [

	| element |
	element := BlAbstractGeoViewElement new.
	self assert: element interactionsStrategy class equals: GeoViewDefaultInteractionsStrategy
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testNewInteractionsStrategy [

	| element |
	element := BlAbstractGeoViewElement new.
	self assert: element newInteractionsStrategy class equals: GeoViewDefaultInteractionsStrategy.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testRemoveInteractionsStrategy [

	| element |
	element := BlAbstractGeoViewElement new.
	element removeInteractionsStrategy.
	self assert: element interactionsStrategy isNil
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testSetInteractionsStrategy [

	| element |
	element := BlAbstractGeoViewElement new.
	element setInteractionsStrategy: nil.
	self assert: element interactionsStrategy isNil
]
