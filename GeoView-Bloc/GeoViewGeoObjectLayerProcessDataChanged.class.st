Class {
	#name : #GeoViewGeoObjectLayerProcessDataChanged,
	#superclass : #GeoViewLayerEvent,
	#category : #'GeoView-Bloc-Events'
}

{ #category : #sending }
GeoViewGeoObjectLayerProcessDataChanged >> sendTo: anObject [

	anObject geoViewProcessDataChanged: self
]
