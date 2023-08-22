Class {
	#name : #DPolylineBlocProcessData,
	#superclass : #DLeafShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DPolylineBlocProcessData >> processCreatedData: aKey incoming: aDPolyline with: aBlElement context: aContext [
	| blPolyline blElement points |
	blElement := aBlElement ifNil:[BlElement new].
	super processCreatedData: aKey incoming: aDPolyline with: blElement context: aContext.
	
	points := (aDPolyline points collect: [ :p | self processor projection projCartToPixel: p ]) asOrderedCollection.
	blPolyline := BlPolylineGeometry vertices: points.
	blElement size: points max.
	blElement geometry: blPolyline.
	blElement outskirts: BlOutskirts centered.

	^blElement
]

{ #category : #processing }
DPolylineBlocProcessData >> processUpdatedData: aKey incoming: aDPolyline with: aBlElement context: aContext [
	| blPolyline points |
	super processUpdatedData: aKey incoming: aDPolyline with: aBlElement context: aContext.

	blPolyline := aBlElement geometry.
	points := (aDPolyline points collect: [ :p | self processor projection projCartToPixel: p ]) asOrderedCollection.
	blPolyline vertices: points.
	aBlElement size: points max.
		
	^aBlElement
]
