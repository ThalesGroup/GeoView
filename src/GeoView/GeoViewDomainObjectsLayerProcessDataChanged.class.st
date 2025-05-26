Class {
	#name : #GeoViewDomainObjectsLayerProcessDataChanged,
	#superclass : #GeoViewLayerEvent,
	#category : #'GeoView-Events'
}

{ #category : #sending }
GeoViewDomainObjectsLayerProcessDataChanged >> sendTo: anObject [

	anObject geoViewDomainObjectsLayerProcessDataChanged: self
]
