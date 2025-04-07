Class {
	#name : #GeoTiledImage,
	#superclass : #Object,
	#instVars : [
		'image',
		'isNoPicture',
		'geoBounds',
		'levelOfDetail',
		'quadKey'
	],
	#category : #'GeoView-Layers'
}

{ #category : #accessing }
GeoTiledImage >> geoBounds [

	^ geoBounds
]

{ #category : #accessing }
GeoTiledImage >> geoBounds: anObject [

	geoBounds := anObject
]

{ #category : #accessing }
GeoTiledImage >> image [

	^ image
]

{ #category : #accessing }
GeoTiledImage >> image: anObject [

	image := anObject
]

{ #category : #accessing }
GeoTiledImage >> isNoPicture [

	^ isNoPicture
]

{ #category : #accessing }
GeoTiledImage >> isNoPicture: anObject [

	isNoPicture := anObject
]

{ #category : #accessing }
GeoTiledImage >> levelOfDetail [

	^ levelOfDetail
]

{ #category : #accessing }
GeoTiledImage >> levelOfDetail: anObject [

	levelOfDetail := anObject
]

{ #category : #accessing }
GeoTiledImage >> quadKey [

	^ quadKey
]

{ #category : #accessing }
GeoTiledImage >> quadKey: anObject [

	quadKey := anObject
]
