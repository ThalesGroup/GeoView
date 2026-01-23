Class {
	#name : #GeoViewSharedMemoryTilesCache,
	#superclass : #GeoViewMemoryTilesCache,
	#instVars : [
		'mutex'
	],
	#category : #'GeoView-Map'
}

{ #category : #initialization }
GeoViewSharedMemoryTilesCache >> initialize [

	super initialize.
	mutex := Monitor new
]

{ #category : #accessing }
GeoViewSharedMemoryTilesCache >> mutex [

	^ mutex
]

{ #category : #accessing }
GeoViewSharedMemoryTilesCache >> mutex: anObject [

	mutex := anObject
]

{ #category : #'api - cache' }
GeoViewSharedMemoryTilesCache >> storeTile: tile level: aZoomLevel x: anXCoordinate y: anYCoordinate [

	self mutex critical: [
			self
				cacheTile: tile
				inLevel: aZoomLevel
				at: anXCoordinate @ anYCoordinate ]
]

{ #category : #'api - cache' }
GeoViewSharedMemoryTilesCache >> tileAtLevel: aZoomLevel x: anXCoordinate y: anYCoordinate [

	| tile |
	self mutex critical: [
			tile := self
				        retrieveTileFromLevel: aZoomLevel
				        at: anXCoordinate @ anYCoordinate ].

	^ tile
]
