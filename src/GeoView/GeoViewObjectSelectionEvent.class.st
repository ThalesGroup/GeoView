Class {
	#name : #GeoViewObjectSelectionEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'objectIndexesList'
	],
	#category : #'GeoView-Events'
}

{ #category : #accessing }
GeoViewObjectSelectionEvent >> objectIndexesList [

	^ objectIndexesList ifNil: [ objectIndexesList := OrderedCollection new ]
]

{ #category : #accessing }
GeoViewObjectSelectionEvent >> objectIndexesList: aList [

	objectIndexesList := aList
]
