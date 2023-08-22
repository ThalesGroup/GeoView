Class {
	#name : #DCircleBlocProcessData,
	#superclass : #DLeafShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DCircleBlocProcessData >> processCreatedData: aKey incoming: aDCircle with: aBlElement context: aContext [
	| blEllipse diameter blElement |
	blElement := aBlElement ifNil:[BlElement new].
	super processCreatedData: aKey incoming: aDCircle with: blElement context: aContext.
	
	blEllipse := BlCircleGeometry new.
	aDCircle radius ifNotNil:[
		(aDCircle isDrawModeUser or:[aDCircle isDrawModeUserProjected]) ifTrue:[
			diameter := aDCircle radius * 2 * self processor projection metersByPixel.
		].
		aDCircle isDrawModeDevice ifTrue:[
			diameter := aDCircle radius * 2.
		].
		blElement size: diameter asPoint.
	].
	blElement geometry: blEllipse.
	
	aDCircle coordinates ifNotNil:[ | position |
		position := self processor projection projCartToPixel: aDCircle coordinates.
		blElement relocate: position.
	] ifNil:[
		blElement relocate: 0@0.
	].

	^blElement
]

{ #category : #processing }
DCircleBlocProcessData >> processUpdatedData: aKey incoming: aDCircle with: aBlElement context: aContext [
	| diameter position |
	super processUpdatedData: aKey incoming: aDCircle with: aBlElement context: aContext.

	aDCircle radius ifNotNil:[
		(aDCircle isDrawModeUser or:[aDCircle isDrawModeUserProjected]) ifTrue:[
			diameter := aDCircle radius * 2 * self processor projection metersByPixel.
		].
		aDCircle isDrawModeDevice ifTrue:[
			diameter := aDCircle radius * 2.
		].
		aBlElement size: diameter asPoint.
	].
	
	aDCircle coordinates ifNotNil:[
		position := self processor projection projCartToPixel: aDCircle coordinates.
		aBlElement relocate: position.
	] ifNil:[
		aBlElement relocate: 0@0.
	].
	
	^aBlElement
]
