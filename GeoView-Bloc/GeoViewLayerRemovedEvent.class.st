Class {
	#name : #GeoViewLayerRemovedEvent,
	#superclass : #GeoViewLayerEvent,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #sending }
GeoViewLayerRemovedEvent >> sendTo: anObject [

	anObject geoViewLayerRemovedEvent: self
]
