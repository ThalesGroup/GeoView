Class {
	#name : #DRectangleBlocProcessData,
	#superclass : #DLeafShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DRectangleBlocProcessData >> processCreatedData: aKey incoming: aDRectangle with: aBlElement context: aContext [
	| length1 length2 blElement blRectangle |
	blElement := aBlElement ifNil:[BlElement new].
	super processCreatedData: aKey incoming: aDRectangle with: blElement context: aContext.
	
	blRectangle := BlRectangleGeometry new.
	(aDRectangle length1 notNil and:[aDRectangle length2 notNil]) ifTrue:[
		(aDRectangle isDrawModeUser or:[aDRectangle isDrawModeUserProjected]) ifTrue:[
			length1 := aDRectangle length1 * self processor projection metersByPixel.
			length2 := aDRectangle length2 * self processor projection metersByPixel.
		].
		aDRectangle isDrawModeDevice ifTrue:[
			length1 := aDRectangle length1.
			length2 := aDRectangle length2.
		].
		blElement size: (length1 @ length2).
	].
	blElement geometry: blRectangle.
	
	aDRectangle coordinates ifNotNil:[ | position |
		position := self processor projection projCartToPixel: aDRectangle coordinates.
		blElement relocate: position.
	] ifNil:[
		blElement relocate: 0@0.
	].

	^blElement
]

{ #category : #processing }
DRectangleBlocProcessData >> processUpdatedData: aKey incoming: aDRectangle with: aBlElement context: aContext [
	| length1 length2 |
	super processUpdatedData: aKey incoming: aDRectangle with: aBlElement context: aContext.
	
	(aDRectangle length1 notNil and:[aDRectangle length2 notNil]) ifTrue:[
		(aDRectangle isDrawModeUser or:[aDRectangle isDrawModeUserProjected]) ifTrue:[
			length1 := aDRectangle length1 * self processor projection metersByPixel.
			length2 := aDRectangle length2 * self processor projection metersByPixel.
		].
		aDRectangle isDrawModeDevice ifTrue:[
			length1 := aDRectangle length1.
			length2 := aDRectangle length2.
		].
		aBlElement size: (length1 @ length2).
	].
	
	aDRectangle coordinates ifNotNil:[ | position |
		position := self processor projection projCartToPixel: aDRectangle coordinates.
		aBlElement relocate: position.
	] ifNil:[
		aBlElement relocate: 0@0.
	].
	
	^ aBlElement
]
