Class {
	#name : #GeoViewTest,
	#superclass : #Object,
	#traits : 'GeoView',
	#classTraits : 'GeoView classTrait',
	#instVars : [
		'layers'
	],
	#category : #'GeoView-Tests-Utils'
}

{ #category : #layers }
GeoViewTest >> addLayer: aLayer [
	self layers add: aLayer
]

{ #category : #'geobjects aur' }
GeoViewTest >> addObjects: aGeoObjectList [
	"do nothing : only for testing"
]

{ #category : #layers }
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

{ #category : #layers }
GeoViewTest >> removeLayer: aLayer [
	self layers remove: aLayer
]
