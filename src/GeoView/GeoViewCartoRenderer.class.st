Class {
	#name : #GeoViewCartoRenderer,
	#superclass : #RSAthensRenderer,
	#instVars : [
		'callback'
	],
	#category : #'GeoView-Layers'
}

{ #category : #accessing }
GeoViewCartoRenderer >> callback [

	^callback
]

{ #category : #accessing }
GeoViewCartoRenderer >> callback: aBloc [

	callback := aBloc
]

{ #category : #'as yet unclassified' }
GeoViewCartoRenderer >> createFuture: osm key: key [
	^ [ self downloadTile: osm key: key ] future
		onSuccessDo: [ :tile | 
			osm semaphore critical: [ 
				Transcript show: 'fin chargement tuile:';show: key asString;cr.
				osm tiles at: key put: tile ].
			osm signalUpdate.
			self callback ifNotNil: [:e |e value]];
		yourself
]

{ #category : #loading }
GeoViewCartoRenderer >> downloadTile: osm key: key [

	| filename prefixType|
	
	Transcript show: 'downloadTile:';show: key asString;cr.
	prefixType := 'r'.

	filename := (FileLocator imageDirectory / 'map') asFileReference.
	filename exists ifFalse:[^nil].

	filename := filename / prefixType.
	filename := filename / key third asString.
	filename := filename / key first asString.
	filename := filename / (key second asString , '.png').

	filename parent asFileReference ensureCreateDirectory.
	filename exists ifTrue: [^ImageReadWriter formFromStream: filename binaryReadStream ].
	^nil
]
