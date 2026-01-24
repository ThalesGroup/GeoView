Class {
	#name : #GeoViewFileSystemPNGTilesCache,
	#superclass : #GeoViewFileSystemTilesCache,
	#category : #'GeoView-Map'
}

{ #category : #private }
GeoViewFileSystemPNGTilesCache >> buildTileFilenameLevel: aZoomLevel x: anXCoordinate y: anYCoordinate [

	^ self directory / aZoomLevel printString / anXCoordinate printString
	  / (anYCoordinate printString , '.png')
]

{ #category : #private }
GeoViewFileSystemPNGTilesCache >> writeForm: aForm fileNamed: aFilename [
	"Use an atomic write to secure thread terminaison"

	| tempFilename |
	tempFilename := aFilename parent / (aFilename basename , '.tmp').
	"if the temp filename exists, a cache is already create it, some files can be here in case of brutal terminate"
	tempFilename exists ifTrue:[ 
		"try to remove the file before caching"
		[ tempFilename delete ] on: Error do:[ :error | ^ nil ].	
	].
	
	aForm writePNGFileNamed: tempFilename.
	
	"cannot store an existing file"
	aFilename exists ifTrue:[ ^ self ].
	tempFilename moveTo: aFilename
]
