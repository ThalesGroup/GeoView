Class {
	#name : #GeoViewTestWidget,
	#superclass : #Object,
	#traits : 'TGeoViewWidget',
	#classTraits : 'TGeoViewWidget classTrait',
	#instVars : [
		'layers'
	],
	#category : #'GeoView-Tests-Utils'
}

{ #category : #'API -- layers management' }
GeoViewTestWidget >> addLayer: aLayer [
	self layers add: aLayer
]

{ #category : #'as yet unclassified' }
GeoViewTestWidget >> addObjects: aGeoObjectList [
	"do nothing : only for testing"
]

{ #category : #accessing }
GeoViewTestWidget >> getBounds [
	^0@0 extent: 0@0
]

{ #category : #'API -- layers management' }
GeoViewTestWidget >> getLayers [
	^self layers
]

{ #category : #accessing }
GeoViewTestWidget >> layers [

	^ layers ifNil: [ layers := OrderedCollection new ]
]

{ #category : #accessing }
GeoViewTestWidget >> layers: anObject [
	layers := anObject
]

{ #category : #'API -- layers management' }
GeoViewTestWidget >> removeLayer: aLayer [
	self layers remove: aLayer
]
