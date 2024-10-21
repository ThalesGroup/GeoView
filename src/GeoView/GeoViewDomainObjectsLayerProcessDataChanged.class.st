Class {
	#name : #GeoViewDomainObjectsLayerProcessDataChanged,
	#superclass : #GeoViewLayerEvent,
	#category : #'GeoView-Events'
}

{ #category : #sending }
GeoViewDomainObjectsLayerProcessDataChanged >> sendTo: anObject [

	anObject geoViewLayerProcessDataChanged: self
]
