Class {
	#name : #GeoViewFileSystemTilesCache,
	#superclass : #GeoViewTilesCache,
	#instVars : [
		'directory'
	],
	#category : #'GeoView-Map'
}

{ #category : #default }
GeoViewFileSystemTilesCache class >> defaultDirectoryRoot [

	^ FileSystem workingDirectory / 'geoview-cache'
]

{ #category : #accessing }
GeoViewFileSystemTilesCache >> directory [

	^ directory
]

{ #category : #accessing }
GeoViewFileSystemTilesCache >> directory: aDirectoryFileReference [

	directory := aDirectoryFileReference
]
