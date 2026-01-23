Class {
	#name : #GeoViewMemoryTilesCache,
	#superclass : #GeoViewTilesCache,
	#instVars : [
		'tilesByLevel',
		'maxTilesPerLevel'
	],
	#category : #'GeoView-Map'
}

{ #category : #default }
GeoViewMemoryTilesCache class >> defaultMaxTilesPerLevel [

	^ 1000
]

{ #category : #private }
GeoViewMemoryTilesCache >> cacheTile: tile inLevel: aZoomLevel at: aCoordinate [

	| levelTilesDictionary |
	levelTilesDictionary := self tilesByLevel
		                        at: aZoomLevel
		                        ifAbsentPut: [
		                        Dictionary new: self maxTilesPerLevel ].

	self manageLevelSpace: levelTilesDictionary.
	levelTilesDictionary at: aCoordinate put: tile
]

{ #category : #initialization }
GeoViewMemoryTilesCache >> initialize [

	super initialize.
	tilesByLevel := Dictionary new
]

{ #category : #private }
GeoViewMemoryTilesCache >> manageLevelSpace: aDictionary [
	"When cache is full, remove first key (basic FIFO)"

	| size |
	size := aDictionary keys size.

	"normal control: when size is just equals to the maximum autorized size"
	size = self maxTilesPerLevel
		ifTrue: [ aDictionary removeKey: aDictionary keys first ]
		ifFalse: [ "In this case, maximum size have been reduced size last management"
				size > self maxTilesPerLevel ifTrue: [
						[ aDictionary keys size >= self maxTilesPerLevel ] whileFalse: [
							aDictionary removeKey: aDictionary keys first ] ] ]
]

{ #category : #accessing }
GeoViewMemoryTilesCache >> maxTilesPerLevel [

	^ maxTilesPerLevel ifNil: [
		  maxTilesPerLevel := self class defaultMaxTilesPerLevel ]
]

{ #category : #accessing }
GeoViewMemoryTilesCache >> maxTilesPerLevel: anObject [

	maxTilesPerLevel := anObject.
	maxTilesPerLevel <= 0 ifTrue: [
		maxTilesPerLevel := self class defaultMaxTilesPerLevel ]
]

{ #category : #private }
GeoViewMemoryTilesCache >> retrieveTileFromLevel: aZoomLevel at: aCoordinate [

	^ self tilesByLevel
		  at: aZoomLevel
		  ifPresent: [ :cachedLevelTilesDictionay |
			  cachedLevelTilesDictionay at: aCoordinate ifAbsent: [ nil ] ]
		  ifAbsent: [ nil ]
]

{ #category : #'api - cache' }
GeoViewMemoryTilesCache >> storeTile: tile level: aZoomLevel x: anXCoordinate y: anYCoordinate [

	self
		cacheTile: tile
		inLevel: aZoomLevel
		at: anXCoordinate @ anYCoordinate
]

{ #category : #'api - cache' }
GeoViewMemoryTilesCache >> tileAtLevel: aZoomLevel x: anXCoordinate y: anYCoordinate [

	^ self
		  retrieveTileFromLevel: aZoomLevel
		  at: anXCoordinate @ anYCoordinate
]

{ #category : #accessing }
GeoViewMemoryTilesCache >> tilesByLevel [

	^ tilesByLevel
]

{ #category : #accessing }
GeoViewMemoryTilesCache >> tilesByLevel: anObject [

	tilesByLevel := anObject
]
