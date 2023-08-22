"
GFLModel data for testing GFLModel
"
Class {
	#name : #GeoViewTestData,
	#superclass : #Object,
	#instVars : [
		'id',
		'data'
	],
	#category : #'GeoView-Tests-Utils'
}

{ #category : #accessing }
GeoViewTestData class >> id: anObject data: aData [
	| model |
	model := self new.
	model id: anObject.
	model data: aData.
	^model
]

{ #category : #accessing }
GeoViewTestData >> data [
	^data
]

{ #category : #accessing }
GeoViewTestData >> data: anObject [
	data := anObject
]

{ #category : #accessing }
GeoViewTestData >> id [
	^id
]

{ #category : #accessing }
GeoViewTestData >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GeoViewTestData >> key [
	^self id
]
