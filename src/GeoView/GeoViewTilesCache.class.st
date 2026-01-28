Class {
	#name : #GeoViewTilesCache,
	#superclass : #Object,
	#category : #'GeoView-Map'
}

{ #category : #testing }
GeoViewTilesCache class >> isAbstract [

	^ self == GeoViewTilesCache
]

{ #category : #'api - cache' }
GeoViewTilesCache >> storeTile: tile level: aZoomLevel x: anXCoordinate y: anYCoordinate [

	self subclassResponsibility 
]

{ #category : #'api - cache' }
GeoViewTilesCache >> tileAtLevel: aZoomLevel x: anXCoordinate y: anYCoordinate [

	self subclassResponsibility 
]
