Class {
	#name : #GeoViewObjectSelectionRemoved,
	#superclass : #GeoViewObjectSelectionEvent,
	#category : #'GeoView-Events'
}

{ #category : #sending }
GeoViewObjectSelectionRemoved >> sendTo: anObject [

	anObject geoViewObjectSelectionAdded: self
]
