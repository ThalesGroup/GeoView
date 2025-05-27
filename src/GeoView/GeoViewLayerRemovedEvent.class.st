Class {
	#name : #GeoViewLayerRemovedEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'layerName'
	],
	#category : #'GeoView-Events'
}

{ #category : #accessing }
GeoViewLayerRemovedEvent >> layerName [

	^ layerName
]

{ #category : #accessing }
GeoViewLayerRemovedEvent >> layerName: anObject [

	layerName := anObject
]

{ #category : #sending }
GeoViewLayerRemovedEvent >> sendTo: anObject [

	anObject geoViewLayerRemovedEvent: self
]
