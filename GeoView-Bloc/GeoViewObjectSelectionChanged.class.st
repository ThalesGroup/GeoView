Class {
	#name : #GeoViewObjectSelectionChanged,
	#superclass : #GeoViewEvent,
	#instVars : [
		'objectList'
	],
	#category : #'GeoView-Bloc-Events'
}

{ #category : #accessing }
GeoViewObjectSelectionChanged >> objectList [

	^ objectList ifNil: [ objectList := OrderedCollection new ]
]

{ #category : #accessing }
GeoViewObjectSelectionChanged >> objectList: anObject [

	objectList := anObject
]

{ #category : #sending }
GeoViewObjectSelectionChanged >> sendTo: anObject [

	anObject geoViewObjectSelectionChanged: self
]
