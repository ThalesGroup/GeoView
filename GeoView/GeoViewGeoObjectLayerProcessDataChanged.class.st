Class {
	#name : #GeoViewGeoObjectLayerProcessDataChanged,
	#superclass : #GeoViewLayerEvent,
	#category : #'GeoView-Events'
}

{ #category : #sending }
GeoViewGeoObjectLayerProcessDataChanged >> sendTo: anObject [

	anObject geoViewProcessDataChanged: self
]
