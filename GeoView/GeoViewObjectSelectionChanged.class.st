Class {
	#name : #GeoViewObjectSelectionChanged,
	#superclass : #GeoViewObjectSelectionEvent,
	#category : #'GeoView-Events'
}

{ #category : #sending }
GeoViewObjectSelectionChanged >> sendTo: anObject [

	anObject geoViewObjectSelectionChanged: self
]
