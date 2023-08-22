Class {
	#name : #DPolygonBlocProcessData,
	#superclass : #DLeafShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DPolygonBlocProcessData >> processCreatedData: aKey incoming: aDPolygon with: aBlElement context: aContext [
	| blPolygon blElement points |
	blElement := aBlElement ifNil:[BlElement new].
	
	super processCreatedData: aKey incoming: aDPolygon with: blElement context: aContext.
	
	points := (aDPolygon points collect: [ :p | self processor projection projCartToPixel: p ]) asOrderedCollection.
	points first = points last ifFalse: [ points add: points first ].
	blPolygon := BlPolygonGeometry vertices: points.
	blElement size: points max. " - points min)."
	blElement geometry: blPolygon.

	^blElement
]

{ #category : #processing }
DPolygonBlocProcessData >> processUpdatedData: aKey incoming: aDPolygon with: aBlElement context: aContext [
	| blPolygon points |
	super processUpdatedData: aKey incoming: aDPolygon with: aBlElement context: aContext.
	
	blPolygon := aBlElement geometry.
	points := (aDPolygon points collect: [ :p | self processor projection projCartToPixel: p ]) asOrderedCollection.
	points first = points last ifFalse: [ points add: points first ].

	blPolygon vertices: points.
	"aBlElement size: (points max - points min)."
	aBlElement size: points max.

	^aBlElement
]
