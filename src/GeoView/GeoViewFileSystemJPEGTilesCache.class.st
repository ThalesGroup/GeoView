Class {
	#name : #GeoViewFileSystemJPEGTilesCache,
	#superclass : #GeoViewFileSystemTilesCache,
	#category : #'GeoView-Map'
}

{ #category : #private }
GeoViewFileSystemJPEGTilesCache >> createImageFileFor: aForm fileNamed: aFilename [

	aForm writeJPEGfileNamed: aFilename
]

{ #category : #accessing }
GeoViewFileSystemJPEGTilesCache >> tileExtension [

	^ '.jpg'
]
