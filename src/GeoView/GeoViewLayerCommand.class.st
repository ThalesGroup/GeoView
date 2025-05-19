Class {
	#name : #GeoViewLayerCommand,
	#superclass : #GeoViewCommand,
	#instVars : [
		'layer'
	],
	#category : #'GeoView-Core'
}

{ #category : #accessing }
GeoViewLayerCommand >> layer [

	^ layer
]

{ #category : #accessing }
GeoViewLayerCommand >> layer: anObject [

	layer := anObject
]
