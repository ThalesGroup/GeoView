Class {
	#name : #GeoViewObjectSelectionCleared,
	#superclass : #GeoViewObjectSelectionEvent,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #sending }
GeoViewObjectSelectionCleared >> sendTo: anObject [

	anObject geoViewObjectSelectionCleared: self
]
