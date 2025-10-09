Class {
	#name : #GeoViewLayerLeaveMaximumDisplayedObjectsEvent,
	#superclass : #GeoViewLayerEvent,
	#category : #'GeoView-Events'
}

{ #category : #sending }
GeoViewLayerLeaveMaximumDisplayedObjectsEvent >> sendTo: anObject [

	anObject geoViewLayerReachMaximumDisplayedObjectsEvent: self
]
