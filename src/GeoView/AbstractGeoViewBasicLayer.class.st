Class {
	#name : #AbstractGeoViewBasicLayer,
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
AbstractGeoViewBasicLayer class >> isAbstract [ 

	^ self == AbstractGeoViewBasicLayer 
]

{ #category : #'API -- projection' }
AbstractGeoViewBasicLayer >> graphicProjection [

	^ graphicProjection
]

{ #category : #'API -- projection' }
AbstractGeoViewBasicLayer >> graphicProjection: aGraphicProjection [

	graphicProjection := aGraphicProjection 
]

{ #category : #'API -- projection' }
AbstractGeoViewBasicLayer >> mapProjection [

	^ mapProjection
]

{ #category : #'API -- projection' }
AbstractGeoViewBasicLayer >> mapProjection: aMapProjection [

	mapProjection := aMapProjection 
]

{ #category : #'API -- picking' }
AbstractGeoViewBasicLayer >> populatePickingResult: aPickingResult [ 

	"do nothing"
]

{ #category : #'API -- symbology' }
AbstractGeoViewBasicLayer >> symbologyProvider [

	^ symbologyProvider
]

{ #category : #'API -- symbology' }
AbstractGeoViewBasicLayer >> symbologyProvider: aSymbologyProvider [

	symbologyProvider := aSymbologyProvider 
]

{ #category : #private }
AbstractGeoViewBasicLayer >> updateModel: aContext [

	"do nothing"
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewBasicLayer >> viewInfos [

	^ viewInfos
]

{ #category : #'API -- graphic properties' }
AbstractGeoViewBasicLayer >> viewInfos: aViewInfos [

	viewInfos := aViewInfos
]
