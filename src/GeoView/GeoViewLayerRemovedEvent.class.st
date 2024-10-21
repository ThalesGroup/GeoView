Class {
	#name : #GeoViewLayerRemovedEvent,
	#superclass : #GeoViewLayerEvent,
	#category : #'GeoView-Events'
}

{ #category : #sending }
GeoViewLayerRemovedEvent >> sendTo: anObject [

	anObject geoViewLayerRemovedEvent: self
]
