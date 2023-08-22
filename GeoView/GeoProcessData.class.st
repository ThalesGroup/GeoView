"
I am a Data processor.
"
Class {
	#name : #GeoProcessData,
	#superclass : #Object,
	#instVars : [
		'properties',
		'processor'
	],
	#category : #'GeoView-Model'
}

{ #category : #accessing }
GeoProcessData class >> processor: aProcessor [

	| processData |
	processData := self new.
	processData processor: aProcessor.
	^processData
]

{ #category : #properties }
GeoProcessData >> getProperty: aKey [
	^ self properties at: aKey ifAbsent: [ nil ]
]

{ #category : #properties }
GeoProcessData >> isPropertyExist: aKey [
	^ self properties includesKey: aKey
]

{ #category : #processing }
GeoProcessData >> processCreatedData: aKey incoming: aSourceData with: aProducedData context: aContext [
	self subclassResponsibility
]

{ #category : #processing }
GeoProcessData >> processDeletedData: aKey incoming: aSourceData with: aProducedData context: aContext [
	self subclassResponsibility
]

{ #category : #processing }
GeoProcessData >> processUpdatedData: aKey incoming: aSourceData with: aProducedData context: aContext [
	self subclassResponsibility 
]

{ #category : #accessing }
GeoProcessData >> processor [
	^ processor
]

{ #category : #accessing }
GeoProcessData >> processor: anObject [
	processor := anObject
]

{ #category : #properties }
GeoProcessData >> properties [
	properties isNil
		ifTrue: [ properties := Dictionary new ].
	^ properties
]

{ #category : #properties }
GeoProcessData >> properties: anObject [
	properties := anObject
]

{ #category : #properties }
GeoProcessData >> removeProperty: aKey [
	self properties removeKey: aKey ifAbsent: [ nil ]
]

{ #category : #properties }
GeoProcessData >> setProperty: aKey value: aValue [
	self properties at: aKey put: aValue
]
