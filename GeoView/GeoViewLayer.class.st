Class {
	#name : #GeoViewLayer,
	#superclass : #AbstractGeoViewLayer,
	#instVars : [
		'symbologyProvider',
		'mapProjection',
		'graphicProjection'
	],
	#category : #'GeoView-Core'
}

{ #category : #'API -- projection' }
GeoViewLayer >> graphicProjection [

	^ graphicProjection
]

{ #category : #'API -- projection' }
GeoViewLayer >> graphicProjection: aGraphicProjection [

	graphicProjection := aGraphicProjection 
]

{ #category : #'API -- projection' }
GeoViewLayer >> mapProjection [

	^ mapProjection
]

{ #category : #'API -- projection' }
GeoViewLayer >> mapProjection: aMapProjection [

	mapProjection := aMapProjection 
]

{ #category : #'API -- picking' }
GeoViewLayer >> populatePickingResult: aPickingResult [ 

	"do nothing"
]

{ #category : #'API -- symbology' }
GeoViewLayer >> symbologyProvider: aSymbologyProvider [

	symbologyProvider := aSymbologyProvider 
]

{ #category : #'API -- drawing' }
GeoViewLayer >> updateGraphicModel [

	"do nothing"
]
