Class {
	#name : #GeoViewObjectSelectionChanged,
	#superclass : #GeoViewObjectSelectionEvent,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #sending }
GeoViewObjectSelectionChanged >> sendTo: anObject [

	anObject geoViewObjectSelectionChanged: self
]
