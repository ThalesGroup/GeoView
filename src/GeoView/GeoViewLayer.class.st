Class {
	#name : #GeoViewLayer,
	#superclass : #AbstractGeoViewLayer,
	#instVars : [
		'symbologyProvider',
		'mapProjection',
		'graphicProjection',
		'viewInfos'
	],
	#category : #'GeoView-Layers'
}

{ #category : #testing }
GeoViewLayer class >> isAbstract [ 

	^ self == GeoViewLayer 
]

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

{ #category : #private }
GeoViewLayer >> updateModel: aContext [

	"do nothing"
]

{ #category : #'API -- graphic properties' }
GeoViewLayer >> viewInfos [

	^ viewInfos
]

{ #category : #'API -- graphic properties' }
GeoViewLayer >> viewInfos: aViewInfos [

	viewInfos := aViewInfos
]
