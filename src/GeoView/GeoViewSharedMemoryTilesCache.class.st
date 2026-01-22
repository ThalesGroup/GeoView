Class {
	#name : #GeoViewSharedMemoryTilesCache,
	#superclass : #GeoViewTilesCache,
	#instVars : [
		'mutex',
		'tilesByLevel',
		'maxTilesPerLevel'
	],
	#category : #'GeoView-Map'
}

{ #category : #initialization }
GeoViewSharedMemoryTilesCache >> initialize [

	super initialize.
	mutex := Monitor new.
	maxTilesPerLevel := 1000.
	tilesByLevel := Dictionary new
]

{ #category : #accessing }
GeoViewSharedMemoryTilesCache >> maxTilesPerLevel [

	^ maxTilesPerLevel
]

{ #category : #accessing }
GeoViewSharedMemoryTilesCache >> maxTilesPerLevel: anObject [

	maxTilesPerLevel := anObject
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

	tile ifNil: [ ^ self ].

	self mutex critical: [
			| cachedLevelTilesDictionay |
			cachedLevelTilesDictionay := self tilesByLevel
				                             at: aZoomLevel
				                             ifAbsentPut: [
				                             Dictionary new: self maxTilesPerLevel ].

			cachedLevelTilesDictionay keys size >= self maxTilesPerLevel
				ifTrue: [ "cache is full, remove first key (basic FIFO)"
						cachedLevelTilesDictionay removeKey:
							cachedLevelTilesDictionay keys first ].

			cachedLevelTilesDictionay
				at: anXCoordinate @ anYCoordinate
				put: tile ]
]

{ #category : #'api - cache' }
GeoViewSharedMemoryTilesCache >> tileAtLevel: aZoomLevel x: anXCoordinate y: anYCoordinate [

	| coord tile |
	coord := anXCoordinate @ anYCoordinate.
	self mutex critical: [
			tile := self tilesByLevel
				        at: aZoomLevel
				        ifPresent: [ :cachedLevelTilesDictionay |
					        cachedLevelTilesDictionay at: coord ifAbsent: [ nil ] ]
				        ifAbsent: [ nil ] ].

	^ tile
]

{ #category : #accessing }
GeoViewSharedMemoryTilesCache >> tilesByLevel [

	^ tilesByLevel
]

{ #category : #accessing }
GeoViewSharedMemoryTilesCache >> tilesByLevel: anObject [

	tilesByLevel := anObject
]
