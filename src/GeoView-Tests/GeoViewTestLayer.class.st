Class {
	#name : #GeoViewTestLayer,
	#superclass : #AbstractGeoViewLayer,
	#instVars : [
		'graphicProjection',
		'mapProjection',
		'viewInfos'
	],
	#category : #'GeoView-Tests-Utils'
}

{ #category : #drawing }
GeoViewTestLayer >> aeDrawOn: aeCanvas [

	"do nothing"
]

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
GeoViewTestLayer >> symbologyProvider [
	"do nothing"
]

{ #category : #'API -- symbology' }
GeoViewTestLayer >> symbologyProvider: aSymbologyProvider [
	"do nothing"
]

{ #category : #accessing }
GeoViewTestLayer >> viewInfos [

	^ viewInfos
]

{ #category : #accessing }
GeoViewTestLayer >> viewInfos: anObject [

	viewInfos := anObject
]
