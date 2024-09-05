Class {
	#name : #GeoViewObjectSelectionRemoved,
	#superclass : #GeoViewObjectSelectionEvent,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #sending }
GeoViewObjectSelectionRemoved >> sendTo: anObject [

	anObject geoViewObjectSelectionAdded: self
]
