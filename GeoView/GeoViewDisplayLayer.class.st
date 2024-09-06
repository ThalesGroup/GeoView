Class {
	#name : #GeoViewDisplayLayer,
	#superclass : #AbstractGeoViewLayer,
	#instVars : [
		'symbologyProvider',
		'mapProjection',
		'graphicProjection'
	],
	#category : #'GeoView-Core'
}

{ #category : #'API -- projection' }
GeoViewDisplayLayer >> graphicProjection [

	^ graphicProjection
]

{ #category : #'API -- projection' }
GeoViewDisplayLayer >> graphicProjection: aGraphicProjection [

	graphicProjection := aGraphicProjection 
]

{ #category : #'API -- projection' }
GeoViewDisplayLayer >> mapProjection [

	^ mapProjection
]

{ #category : #'API -- projection' }
GeoViewDisplayLayer >> mapProjection: aMapProjection [

	mapProjection := aMapProjection 
]

{ #category : #'API -- picking' }
GeoViewDisplayLayer >> populatePickingResult: aPickingResult [ 

	"do nothing"
]

{ #category : #'API -- symbology' }
GeoViewDisplayLayer >> symbologyProvider: aSymbologyProvider [

	symbologyProvider := aSymbologyProvider 
]

{ #category : #'API -- drawing' }
GeoViewDisplayLayer >> updateGraphicModel [

	"do nothing"
]
