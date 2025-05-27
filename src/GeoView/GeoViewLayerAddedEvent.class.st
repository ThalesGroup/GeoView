Class {
	#name : #GeoViewLayerAddedEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'layerName'
	],
	#category : #'GeoView-Events'
}

{ #category : #accessing }
GeoViewLayerAddedEvent >> layerName [

	^ layerName
]

{ #category : #accessing }
GeoViewLayerAddedEvent >> layerName: anObject [

	layerName := anObject
]

{ #category : #sending }
GeoViewLayerAddedEvent >> sendTo: anObject [

	anObject geoViewLayerAddedEvent: self
]
