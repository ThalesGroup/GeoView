Class {
	#name : #GeoViewLayerAddedEvent,
	#superclass : #GeoViewLayerEvent,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #sending }
GeoViewLayerAddedEvent >> sendTo: anObject [

	anObject geoViewLayerAddedEvent: self
]
