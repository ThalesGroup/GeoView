Class {
	#name : #GeoViewObjectSelectionEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'objectIndexesList'
	],
	#category : #'GeoView-Bloc-Events'
}

{ #category : #'as yet unclassified' }
GeoViewObjectSelectionEvent >> objectIndexesList [

	^ objectIndexesList ifNil: [ objectIndexesList := OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
GeoViewObjectSelectionEvent >> objectIndexesList: aList [

	objectIndexesList := aList
]

{ #category : #sending }
GeoViewObjectSelectionEvent >> sendTo: anObject [

	anObject geoViewObjectSelectionChanged: self
]
