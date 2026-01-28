Class {
	#name : #GeoViewFileSystemTilesCache,
	#superclass : #GeoViewTilesCache,
	#instVars : [
		'directory',
		'mutex'
	],
	#category : #'GeoView-Map'
}

{ #category : #default }
GeoViewFileSystemTilesCache class >> defaultCacheRoot [

	^ FileLocator cache / 'geoview'
]

{ #category : #testing }
GeoViewFileSystemTilesCache class >> isAbstract [

	^ self == GeoViewFileSystemTilesCache
]

{ #category : #private }
GeoViewFileSystemTilesCache >> buildTileFilenameLevel: aZoomLevel x: anXCoordinate y: anYCoordinate [

	^ self directory / aZoomLevel printString / anXCoordinate printString
	  / (anYCoordinate printString , self tileExtension)
]

{ #category : #private }
GeoViewFileSystemTilesCache >> canStoreTile: aForm level: aZoomLevel x: anXCoordinate y: anYCoordinate [

	aForm width ifNil: [ ^ false ].
	aForm height ifNil: [ ^ false ].

	^ true
]

{ #category : #private }
GeoViewFileSystemTilesCache >> createImageFileFor: aForm fileNamed: aFilename [

	self subclassResponsibility 
]

{ #category : #'api - cache' }
GeoViewFileSystemTilesCache >> directory [

	^ directory
]

{ #category : #'api - cache' }
GeoViewFileSystemTilesCache >> directory: aDirectoryFileReference [

	directory := aDirectoryFileReference
]

{ #category : #initialization }
GeoViewFileSystemTilesCache >> initialize [

	super initialize.
	"use a mutex to not read and write the same file at the same time, not a big problem to have only one mutex for all files because this cache is just used a first time to load on the memory. if needed try to create a mutex by file or use a shared read/write file mecanism"
	mutex := Monitor new
]

{ #category : #accessing }
GeoViewFileSystemTilesCache >> mutex [

	^ mutex
]

{ #category : #accessing }
GeoViewFileSystemTilesCache >> mutex: anObject [

	mutex := anObject
]

{ #category : #accessing }
GeoViewFileSystemTilesCache >> storeTile: aForm level: aZoomLevel x: anXCoordinate y: anYCoordinate [

	| filename parent |
	(self canStoreTile: aForm level: aZoomLevel x: anXCoordinate y: anYCoordinate) ifFalse: [ ^ self ].

	filename := self
		            buildTileFilenameLevel: aZoomLevel
		            x: anXCoordinate
		            y: anYCoordinate.
		
	parent := filename parent.

	self mutex critical: [
			parent ensureCreateDirectory.
			self writeForm: aForm fileNamed: filename ]
]

{ #category : #'api - cache' }
GeoViewFileSystemTilesCache >> tileAtLevel: aZoomLevel x: anXCoordinate y: anYCoordinate [

	| filename form |
	filename := self
		            buildTileFilenameLevel: aZoomLevel
		            x: anXCoordinate
		            y: anYCoordinate.

	self mutex critical: [
			[
				filename exists ifTrue: [
					form := ImageReadWriter formFromFileNamed: filename ] ]
				on: Error
				do: [ :err | "Image can corrupted, remove it an return nil. Another error should raise but will be more clear to analyse (file already open for example)"
					filename delete ] ].

	^ form
]

{ #category : #accessing }
GeoViewFileSystemTilesCache >> tileExtension [

	self subclassResponsibility 
]

{ #category : #private }
GeoViewFileSystemTilesCache >> writeForm: aForm fileNamed: aFilename [
	"Use an atomic write to secure thread terminaison"

	| tempFilename |
	tempFilename := aFilename parent / (aFilename basename , '.tmp').
	"if the temp filename exists, a cache is already create it, some files can be here in case of brutal terminate"
	tempFilename exists ifTrue: [ "try to remove the file before caching"
			[ tempFilename delete ]
				on: Error
				do: [ :error | ^ nil ] ].

	self createImageFileFor: aForm fileNamed: tempFilename.

	"cannot store an existing file"
	aFilename exists ifTrue: [ ^ self ].
	tempFilename moveTo: aFilename
]
