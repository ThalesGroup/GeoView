Class {
	#name : #GeoViewTilesProvider,
	#superclass : #Object,
	#instVars : [
		'haveCopyrightNote',
		'defaultCopyrightNote'
	],
	#category : #'GeoView-Map'
}

{ #category : #testing }
GeoViewTilesProvider class >> isAbstract [

	^ self = GeoViewTilesProvider
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
	self haveCopyrightNote: false
]

{ #category : #request }
GeoViewTilesProvider >> tileFor: aZoomLevel x: anXCoordinate y: anYCoordinate [

	self subclassResponsibility 
]
