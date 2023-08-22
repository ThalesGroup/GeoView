Class {
	#name : #DPolygonsBlocProcessData,
	#superclass : #DLeafShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DPolygonsBlocProcessData >> processCreatedData: aKey incoming: aDPolygons with: aBlElement context: aContext [
	| blPolygons blElement listOfpoints maxsize |
	blElement := aBlElement ifNil:[BlElement new].
	blElement relocate: 0@0.
	super processCreatedData: aKey incoming: aDPolygons with: blElement context: aContext.
	
	listOfpoints := aDPolygons points collect:
	[ :listElt | 
		listElt collect: [ :e | self processor projection projCartToPixel: e].
	].	
	"Close polygons if needed"
	maxsize := listOfpoints first max.
	listOfpoints do: [ :listElt | 
		listElt 	 first = listElt  last ifFalse: [ listElt  add: listElt  first ].
		maxsize := maxsize max: (listElt max).
	].

	blPolygons := BlMultiPolygonGeometry polygons: listOfpoints.

	blElement size: maxsize.
	blElement geometry: blPolygons.

	^blElement
]

{ #category : #processing }
DPolygonsBlocProcessData >> processUpdatedData: aKey incoming: aDPolygons with: aBlElement context: aContext [
	| blPolygons listOfpoints maxsize|
	super processUpdatedData: aKey incoming: aDPolygons with: aBlElement context: aContext.
	
	listOfpoints := aDPolygons points collect: [ :listElt | 
		listElt collect: [ :e | self processor projection projCartToPixel: e].
	].	
	"Close polygons if needed"
	maxsize := listOfpoints first max.
	listOfpoints do: [ :listElt | 
		listElt first = listElt last ifFalse: [ listElt add: (listElt first) ].
		maxsize := maxsize max: (listElt max).
	].

	blPolygons := aBlElement geometry.
	blPolygons polygons: listOfpoints.
	aBlElement size: maxsize.

	^aBlElement
]
