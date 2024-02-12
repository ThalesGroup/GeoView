Class {
	#name : #GeoViewTestLayer,
	#superclass : #Object,
	#traits : 'TGeoViewLayer',
	#classTraits : 'TGeoViewLayer classTrait',
	#instVars : [
		'layerName'
	],
	#category : #'GeoView-Tests-Utils'
}

{ #category : #accessing }
GeoViewTestLayer >> layerName [
	^layerName
]

{ #category : #accessing }
GeoViewTestLayer >> layerName: aName [
	layerName := aName
]

{ #category : #testing }
GeoViewTestLayer >> mapProjection: aProjection [
	"do nothing"
]

{ #category : #testing }
GeoViewTestLayer >> symbologyProvider: aSymbologyProvider [
	"do nothing"
]
