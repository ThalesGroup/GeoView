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

{ #category : #'geobjects aur' }
GeoViewTest >> addObjects: aGeoObjectList [
	"do nothing : only for testing"
]

{ #category : #'API -- layers management' }
GeoViewTest >> getLayers [
	^self layers
]

{ #category : #accessing }
GeoViewTest >> getViewSize [
	^0@0
]

{ #category : #accessing }
GeoViewTest >> layers [
	layers isNil ifTrue:[layers := OrderedCollection new].
	^ layers
]

{ #category : #accessing }
GeoViewTest >> layers: anObject [
	layers := anObject
]

{ #category : #'API -- layers management' }
GeoViewTest >> removeLayer: aLayer [
	self layers remove: aLayer
]
