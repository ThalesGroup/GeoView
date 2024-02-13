Class {
	#name : #GeoViewTest,
	#superclass : #Object,
	#traits : 'TGeoView',
	#classTraits : 'TGeoView classTrait',
	#instVars : [
		'layers'
	],
	#category : #'GeoView-Tests-Utils'
}

{ #category : #'API -- layers management' }
GeoViewTest >> addLayer: aLayer [
	self layers add: aLayer
]

{ #category : #'as yet unclassified' }
GeoViewTest >> addObjects: aGeoObjectList [
	"do nothing : only for testing"
]

{ #category : #accessing }
GeoViewTest >> getBounds [
	^0@0 extent: 0@0
]

{ #category : #'API -- layers management' }
GeoViewTest >> getLayers [
	^self layers
]

{ #category : #accessing }
GeoViewTest >> layers [

	^ layers ifNil: [ layers := OrderedCollection new ]
]

{ #category : #accessing }
GeoViewTest >> layers: anObject [
	layers := anObject
]

{ #category : #'API -- layers management' }
GeoViewTest >> removeLayer: aLayer [
	self layers remove: aLayer
]
