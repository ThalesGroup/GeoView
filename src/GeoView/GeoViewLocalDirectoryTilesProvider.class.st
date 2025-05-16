Class {
	#name : #GeoViewLocalDirectoryTilesProvider,
	#superclass : #GeoViewTilesProvider,
	#instVars : [
		'tileDirectory'
	],
	#category : #'GeoView-Map'
}

{ #category : #constants }
GeoViewLocalDirectoryTilesProvider class >> defaultDirectory [

	^ FileLocator imageDirectory / 'map' / 'r'
]

{ #category : #initialization }
GeoViewLocalDirectoryTilesProvider >> initialize [ 
	
	super initialize.
]

{ #category : #accessing }
GeoViewLocalDirectoryTilesProvider >> tileDirectory [

	^ tileDirectory ifNil: [
		  tileDirectory := self class defaultDirectory ]
]

{ #category : #accessing }
GeoViewLocalDirectoryTilesProvider >> tileDirectory: anObject [

	tileDirectory := anObject
]

{ #category : #request }
GeoViewLocalDirectoryTilesProvider >> tileFilenameFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	| filename |
	filename := self tileDirectory asFileReference.
	filename exists ifFalse: [ ^ nil ].

	filename := filename / aZoomLevel asString.
	filename := filename / anXCoordinate asString.
	filename := filename / (anYCoordinate asString , '.png').

	^ filename
]

{ #category : #request }
GeoViewLocalDirectoryTilesProvider >> tileFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	| filename |
	filename := self tileFilenameFor: aZoomLevel x: anXCoordinate y: anYCoordinate.
	filename ifNil: [ ^ nil ].
	filename parent asFileReference ensureCreateDirectory.
	filename exists ifTrue: [ ^ filename ].
	^ nil
]
