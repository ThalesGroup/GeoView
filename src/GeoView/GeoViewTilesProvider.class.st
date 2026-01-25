Class {
	#name : #GeoViewTilesProvider,
	#superclass : #Object,
	#instVars : [
		'isCachingTiles',
		'cache',
		'haveCopyrightNote',
		'defaultCopyrightNote'
	],
	#classInstVars : [
		'caches'
	],
	#category : #'GeoView-Map'
}

{ #category : #'private - cache' }
GeoViewTilesProvider class >> allCaches [

	<script: 'self allCaches inspect'>
	^ self allSubclasses collect: [ :c | c caches ]
]

{ #category : #'private - cache' }
GeoViewTilesProvider class >> caches [

	caches ifNil: [ caches := Dictionary new ].
	^ caches
]

{ #category : #'private - cache' }
GeoViewTilesProvider class >> cleanAllCaches [

	<script>
	self allSubclassesDo: [ :c | c cleanCaches ]
]

{ #category : #'private - cache' }
GeoViewTilesProvider class >> cleanCaches [

	caches := nil
]

{ #category : #cleanup }
GeoViewTilesProvider class >> cleanUp [

	super cleanUp.
	self cleanAllCaches
]

{ #category : #'private - cache' }
GeoViewTilesProvider class >> getCache: aKey [

	^ self caches at: aKey ifAbsent: [ nil ]
]

{ #category : #'private - cache' }
GeoViewTilesProvider class >> installSharedCache: aSharedCache for: aTileProvider [

	self caches at: aTileProvider sharedCacheKey put: aSharedCache
]

{ #category : #testing }
GeoViewTilesProvider class >> isAbstract [

	^ self == GeoViewTilesProvider
]

{ #category : #cache }
GeoViewTilesProvider class >> sharedCacheFor: aTileProvider [

	^ self getCache: aTileProvider sharedCacheKey
]

{ #category : #accessing }
GeoViewTilesProvider >> cache [

	^ cache
]

{ #category : #accessing }
GeoViewTilesProvider >> cache: aGeoViewTilesCache [

	cache := aGeoViewTilesCache
]

{ #category : #'private - cache' }
GeoViewTilesProvider >> changeCache [
	"need to change the cache because of provider settings changes"

	self cache: nil.
	self isCachingTiles ifFalse: [ ^ self ].
	self initializeCache
]

{ #category : #'private - cache' }
GeoViewTilesProvider >> createCache [

	self subclassResponsibility 
]

{ #category : #accessing }
GeoViewTilesProvider >> defaultCopyrightNote [

	^ defaultCopyrightNote
]

{ #category : #accessing }
GeoViewTilesProvider >> defaultCopyrightNote: anObject [

	defaultCopyrightNote := anObject
]

{ #category : #accessing }
GeoViewTilesProvider >> haveCopyrightNote [

	^ haveCopyrightNote
]

{ #category : #accessing }
GeoViewTilesProvider >> haveCopyrightNote: anObject [

	haveCopyrightNote := anObject
]

{ #category : #initialization }
GeoViewTilesProvider >> initialize [

	super initialize.

	self isCachingTiles ifTrue: [ self initializeCache ].
	self haveCopyrightNote: false
]

{ #category : #initialization }
GeoViewTilesProvider >> initializeCache [

	| sharedCache |
	sharedCache := self class sharedCacheFor: self.
	sharedCache ifNil: [
			sharedCache := self createCache.
			sharedCache ifNotNil: [
				self class installSharedCache: sharedCache for: self ] ].

	self cache: sharedCache
]

{ #category : #cache }
GeoViewTilesProvider >> isCachingTiles [

	^ isCachingTiles ifNil: [ isCachingTiles := true ]
]

{ #category : #cache }
GeoViewTilesProvider >> isCachingTiles: aBoolean [

	isCachingTiles ~= aBoolean ifFalse: [ ^ self ].
	isCachingTiles := aBoolean.
	self changeCache
]

{ #category : #private }
GeoViewTilesProvider >> loadTileFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	self subclassResponsibility
]

{ #category : #cache }
GeoViewTilesProvider >> sharedCacheKey [

	self subclassResponsibility 
]

{ #category : #request }
GeoViewTilesProvider >> tileFor: aZoomLevel x: anXCoordinate y: anYCoordinate [
	"first check in cache"

	| tile |
	self isCachingTiles ifTrue: [
			tile := self cache
				        tileAtLevel: aZoomLevel
				        x: anXCoordinate
				        y: anYCoordinate.
			tile ifNotNil: [ ^ tile ] ].

	tile := self
		        loadTileFor: aZoomLevel
		        x: anXCoordinate
		        y: anYCoordinate.
	tile ifNil: [ ^ tile ].

	self isCachingTiles ifTrue: [
			self cache
				storeTile: tile
				level: aZoomLevel
				x: anXCoordinate
				y: anYCoordinate ].

	^ tile
]
