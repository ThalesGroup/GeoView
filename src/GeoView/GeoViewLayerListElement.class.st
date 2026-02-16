"
This element is dedicated to contains layers to draw
"
Class {
	#name : #GeoViewLayerListElement,
	#superclass : #BlElement,
	#instVars : [
		'layers'
	],
	#category : #'GeoView-Layers'
}

{ #category : #drawing }
GeoViewLayerListElement >> aeDrawOn: aeCanvas [
	"Drawing geo layers using Alexandrie canvas"

	self layers ifNil: [ ^ self ].
	self layers
		select: [ :l | l isVisible ]
		thenDo: [ :l | l aeDrawOn: aeCanvas ]
]

{ #category : #accessing }
GeoViewLayerListElement >> layers [

	^ layers
]

{ #category : #accessing }
GeoViewLayerListElement >> layers: anObject [

	layers := anObject
]
