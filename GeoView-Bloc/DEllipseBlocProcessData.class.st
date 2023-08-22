Class {
	#name : #DEllipseBlocProcessData,
	#superclass : #DLeafShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DEllipseBlocProcessData >> processCreatedData: aKey incoming: aDEllipse with: aBlElement context: aContext [
	| blEllipse diameter1 diameter2 position blElement |
	blElement := aBlElement ifNil:[BlElement new].
	super processCreatedData: aKey incoming: aDEllipse with: blElement context: aContext.
	
	diameter1 := aDEllipse radius1 * 2 * self processor projection metersByPixel.
	diameter2 := aDEllipse radius2 * 2 * self processor projection metersByPixel.
	blEllipse := BlEllipseGeometry new extent: diameter1 @ diameter2.
	blElement size: diameter1 @ diameter2.
	blElement geometry: blEllipse.
	
	aDEllipse coordinates isNil ifFalse:[
		position := self processor projection projCartToPixel: aDEllipse coordinates.
		blElement relocate: position.
	].

	^blElement
]

{ #category : #processing }
DEllipseBlocProcessData >> processUpdatedData: aKey incoming: aDEllipse with: aBlElement context: aContext [
	| blEllipse position diameter1 diameter2 |
	super processUpdatedData: aKey incoming: aDEllipse with: aBlElement context: aContext.
	
	diameter1 := aDEllipse radius1 * 2.
	diameter2 := aDEllipse radius2 * 2.
	blEllipse := aBlElement geometry.
	aBlElement size: diameter1 @ diameter2.
	blEllipse extent: diameter1 @ diameter2.
	
	aDEllipse coordinates isNil ifFalse:[
		position := self processor projection projCartToPixel: aDEllipse coordinates.
		aBlElement relocate: position.
	] ifTrue:[
		aBlElement relocate: 0@0.
	].
	
	^aBlElement
]
