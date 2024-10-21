Class {
	#name : #GeoViewLayerAddedEvent,
	#superclass : #GeoViewLayerEvent,
	#category : #'GeoView-Events'
}

{ #category : #sending }
GeoViewLayerAddedEvent >> sendTo: anObject [

	anObject geoViewLayerAddedEvent: self
]
