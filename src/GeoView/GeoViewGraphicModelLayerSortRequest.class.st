Class {
	#name : #GeoViewGraphicModelLayerSortRequest,
	#superclass : #GeoViewLayerEvent,
	#instVars : [
		'layer'
	],
	#category : #'GeoView-Events'
}

{ #category : #accessing }
GeoViewGraphicModelLayerSortRequest >> layer [

	^ layer
]

{ #category : #accessing }
GeoViewGraphicModelLayerSortRequest >> layer: anObject [

	layer := anObject
]

{ #category : #sending }
GeoViewGraphicModelLayerSortRequest >> sendTo: anObject [

	anObject geoViewGraphicModelLayerNeedToBeSorted: self
]
