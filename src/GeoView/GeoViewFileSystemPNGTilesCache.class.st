Class {
	#name : #GeoViewFileSystemPNGTilesCache,
	#superclass : #GeoViewFileSystemTilesCache,
	#category : #'GeoView-Map'
}

{ #category : #private }
GeoViewFileSystemPNGTilesCache >> createImageFileFor: aForm fileNamed: aFilename [

	aForm writePNGFileNamed: aFilename
]

{ #category : #accessing }
GeoViewFileSystemPNGTilesCache >> tileExtension [

	^ '.png'
]
