Class {
	#name : #GeoViewTilesProvider,
	#superclass : #Object,
	#instVars : [
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
GeoViewTilesProvider >> cache: anObject [

	cache := anObject
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

	self initializeCache.
	self haveCopyrightNote: false
]

{ #category : #cache }
GeoViewTilesProvider >> initializeCache [

	| sharedCache |
	self sharedCacheKey ifNil: [ ^ self ].

	sharedCache := self class sharedCacheFor: self.
	sharedCache ifNil: [
			sharedCache := GeoViewSharedMemoryTilesCache new.
			self class installSharedCache: sharedCache for: self ].
	self cache: sharedCache
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
	self cache ifNotNil: [ :e |
			tile := e tileAtLevel: aZoomLevel x: anXCoordinate y: anYCoordinate.
			tile ifNotNil: [ ^ tile ] ].

	tile := self
		        loadTileFor: aZoomLevel
		        x: anXCoordinate
		        y: anYCoordinate.

	self cache ifNotNil: [ :e |
			e
				storeTile: tile
				level: aZoomLevel
				x: anXCoordinate
				y: anYCoordinate ].

	^ tile
]
