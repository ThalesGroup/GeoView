Class {
	#name : #DImageBlocProcessData,
	#superclass : #DShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DImageBlocProcessData >> processCreatedData: aKey incoming: aDImage with: aBlElement context: aContext [
	| blImageBackground position blElement |
	blElement := aBlElement ifNil:[BlElement new].
	super processCreatedData: aKey incoming: aDImage with: blElement context: aContext.
	blImageBackground := BlImageBackground image: aDImage image.
	blElement background: blImageBackground.
	
	aDImage coordinates isNil ifFalse:[
		position := self processor projection projCartToPixel: aDImage coordinates.
		position := (position x + ((aDImage image width) / 2))  @ (position y - ((aDImage image height) / 2)).
		blElement relocate: position.
	].

	^blElement
]

{ #category : #processing }
DImageBlocProcessData >> processUpdatedData: aKey incoming: aDImage with: aBlElement context: aContext [
	| position |
	super processUpdatedData: aKey incoming: aDImage with: aBlElement context: aContext.
	
	aBlElement background image: aDImage image.
	
	aDImage coordinates isNil ifFalse:[
		position := self processor projection projCartToPixel: aDImage coordinates.
		aBlElement relocate: position.
	] ifTrue:[
		aBlElement relocate: 0@0.
	].
	
	^aBlElement
]
