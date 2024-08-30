Class {
	#name : #GeoViewTestLayer,
	#superclass : #Object,
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

{ #category : #'API -- symbology' }
GeoViewTestLayer >> symbologyProvider: aSymbologyProvider [
	"do nothing"
]
