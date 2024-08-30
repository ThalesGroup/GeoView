Class {
	#name : #GeoViewLayerProcessDataChanged,
	#superclass : #GeoViewLayerEvent,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #sending }
GeoViewLayerProcessDataChanged >> sendTo: anObject [

	anObject geoViewProcessDataChanged: self
]
