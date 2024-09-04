Class {
	#name : #GeoViewObjectSelectionCleared,
	#superclass : #GeoViewEvent,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #sending }
GeoViewObjectSelectionCleared >> sendTo: anObject [

	anObject geoViewObjectSelectionCleared: self
]
