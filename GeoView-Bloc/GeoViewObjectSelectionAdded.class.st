Class {
	#name : #GeoViewObjectSelectionAdded,
	#superclass : #GeoViewObjectSelectionEvent,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #sending }
GeoViewObjectSelectionAdded >> sendTo: anObject [

	anObject geoViewObjectSelectionAdded: self
]
