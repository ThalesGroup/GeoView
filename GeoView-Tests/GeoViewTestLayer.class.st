Class {
	#name : #GeoViewTestLayer,
	#superclass : #AbstractGeoViewLayer,
	#instVars : [
		'graphicProjection',
		'mapProjection'
	],
	#category : #'GeoView-Tests-Utils'
}

{ #category : #'API -- projection' }
GeoViewTestLayer >> graphicProjection [

	^ graphicProjection
]

{ #category : #'API -- projection' }
GeoViewTestLayer >> graphicProjection: aGraphicProjection [

	graphicProjection := aGraphicProjection 
]

{ #category : #'API -- projection' }
GeoViewTestLayer >> mapProjection [

	^ mapProjection
]

{ #category : #'API -- projection' }
GeoViewTestLayer >> mapProjection: aMapProjection [

	mapProjection := aMapProjection 
]

{ #category : #'API -- symbology' }
GeoViewTestLayer >> symbologyProvider: aSymbologyProvider [
	"do nothing"
]
