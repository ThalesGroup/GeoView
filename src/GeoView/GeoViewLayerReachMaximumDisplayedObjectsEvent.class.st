Class {
	#name : #GeoViewLayerReachMaximumDisplayedObjectsEvent,
	#superclass : #GeoViewLayerEvent,
	#category : #'GeoView-Events'
}

{ #category : #sending }
GeoViewLayerReachMaximumDisplayedObjectsEvent >> sendTo: anObject [

	anObject geoViewLayerReachMaximumDisplayedObjectsEvent: self
]
