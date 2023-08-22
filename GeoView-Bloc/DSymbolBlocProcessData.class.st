"
Convert a DSymbol to a Bloc Image using SymbolProvider.
"
Class {
	#name : #DSymbolBlocProcessData,
	#superclass : #DLeafShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DSymbolBlocProcessData >> processCreatedData: aKey incoming: aDSymbol with: aBlElement context: aContext [
	| blImageBackground position blElement |
	blElement := aBlElement ifNil:[BlElement new].
	super processCreatedData: aKey incoming: aDSymbol with: blElement context: aContext.
	
	blImageBackground := BlImageBackground new.
	
	"Get image (Form) from symbol provider"
	aDSymbol symbolKey ifNotNil:[
		self processor symbologyProvider ifNotNil:[ :symbologyProvider | | anImage |
			anImage := symbologyProvider getSymbol: aDSymbol symbolKey.
			anImage ifNotNil:[ :img |
				blImageBackground image: anImage.
			].
		].
	].
	
	blElement background: blImageBackground.
	
	aDSymbol coordinates ifNotNil:[
		position := self processor projection projCartToPixel: aDSymbol coordinates.
		"position := (position x - ((blImageBackground image width) / 2))  @ (position y - ((blImageBackground image height) / 2))."
		blElement relocate: position.
	] ifNil:[
		blElement relocate: 0@0.
	].

	aDSymbol orientation ifNotNil:[
		blElement transformation rotateBy: aDSymbol orientation; apply.
	].

	^blElement
]

{ #category : #processing }
DSymbolBlocProcessData >> processUpdatedData: aKey incoming: aDSymbol with: aBlElement context: aContext [
	| position blImageBackground |
	super processUpdatedData: aKey incoming: aDSymbol with: aBlElement context: aContext.
	
	blImageBackground := aBlElement background.
	
	"Get image (Form) from symbol provider"
	self processor symbologyProvider ifNotNil:[ :symbologyProvider | | anImage |
		anImage := symbologyProvider getSymbol: aDSymbol symbolKey.
		(anImage ~= blImageBackground image) ifTrue:[
			blImageBackground := BlImageBackground new.
			blImageBackground image: anImage.
			aBlElement background: blImageBackground.
		].
	].
	
	aDSymbol coordinates ifNotNil:[
		position := self processor projection projCartToPixel: aDSymbol coordinates.
		position := (position x - ((blImageBackground image width) / 2))  @ (position y - ((blImageBackground image height) / 2)).
		aBlElement relocate: position.
	] ifNil:[
		aBlElement relocate: 0@0.
	].

	aDSymbol orientation ifNotNil:[
				aBlElement transform rotateBy:aDSymbol orientation"; translateBy: (BlVector x:25  y:25  z:0)"; apply.
	].
	"aBlElement relocate: (((blImageBackground image width) / 2.0) negated @((blImageBackground image height) / 2.0) negated)."
	^aBlElement
]
