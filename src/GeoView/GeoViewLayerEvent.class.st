Class {
	#name : #GeoViewLayerEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'layerName'
	],
	#category : #'GeoView-Events'
}

{ #category : #accessing }
GeoViewLayerEvent >> layerName [

	^ layerName 
]

{ #category : #accessing }
GeoViewLayerEvent >> layerName: anObject [

	layerName := anObject
]
