Class {
	#name : #GeoViewLayerEvent,
	#superclass : #GeoViewEvent,
	#instVars : [
		'layerName'
	],
	#category : #'GeoView-Events'
}

{ #category : #'as yet unclassified' }
GeoViewLayerEvent >> layerName [

	^ layerName
]

{ #category : #'as yet unclassified' }
GeoViewLayerEvent >> layerName: anObject [

	layerName := anObject
]
