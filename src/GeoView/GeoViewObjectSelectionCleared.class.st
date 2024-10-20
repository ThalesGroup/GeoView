Class {
	#name : #GeoViewObjectSelectionCleared,
	#superclass : #GeoViewObjectSelectionEvent,
	#category : #'GeoView-Events'
}

{ #category : #sending }
GeoViewObjectSelectionCleared >> sendTo: anObject [

	anObject geoViewObjectSelectionCleared: self
]
