Class {
	#name : #GeoViewMemoryTilesCache,
	#superclass : #GeoViewTilesCache,
	#instVars : [
		'tilesByLevel',
		'maxTilesLimitPerLevel'
	],
	#category : #'GeoView-Map'
}

{ #category : #private }
GeoViewMemoryTilesCache >> cacheTile: tile inLevel: aZoomLevel at: aCoordinate [

	| levelTilesDictionary |
	levelTilesDictionary := self tilesByLevel
		                        at: aZoomLevel
		                        ifAbsentPut: [
		                        Dictionary new:
			                        (self maxTilesForLevel: aZoomLevel) ].

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
	size = self maxTilesLimitPerLevel
		ifTrue: [ aDictionary removeKey: aDictionary keys first ]
		ifFalse: [ "In this case, maximum size have been reduced size last management"
				size > self maxTilesLimitPerLevel ifTrue: [
						[ aDictionary keys size >= self maxTilesLimitPerLevel ] whileFalse: [
							aDictionary removeKey: aDictionary keys first ] ] ]
]

{ #category : #private }
GeoViewMemoryTilesCache >> maxTilesForLevel: aLevel [

	| theoreticalMax |
	theoreticalMax := 4 raisedTo: aLevel.
	^ theoreticalMax min: self maxTilesLimitPerLevel
]

{ #category : #'api - cache' }
GeoViewMemoryTilesCache >> maxTilesLimitPerLevel [

	^ maxTilesLimitPerLevel ifNil: [ maxTilesLimitPerLevel := 8192 ]
]

{ #category : #'api - cache' }
GeoViewMemoryTilesCache >> maxTilesLimitPerLevel: anInteger [

	maxTilesLimitPerLevel := anInteger
]

{ #category : #'api - cache' }
GeoViewMemoryTilesCache >> nbTiles [
	"Return the number of tile in cache"

	| nb |
	nb := 0.
	self tilesByLevel valuesDo: [ :dict | nb := nb + dict keys size ].

	^ nb
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
