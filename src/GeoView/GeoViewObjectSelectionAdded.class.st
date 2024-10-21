Class {
	#name : #GeoViewObjectSelectionAdded,
	#superclass : #GeoViewObjectSelectionEvent,
	#category : #'GeoView-Events'
}

{ #category : #sending }
GeoViewObjectSelectionAdded >> sendTo: anObject [

	anObject geoViewObjectSelectionAdded: self
]
