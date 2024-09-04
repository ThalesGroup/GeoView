Class {
	#name : #GeoViewObjectSelectionAdded,
	#superclass : #GeoViewObjectSelectionChanged,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #sending }
GeoViewObjectSelectionAdded >> sendTo: anObject [

	anObject geoViewObjectSelectionAdded: self
]
