Class {
	#name : #DTextBlocProcessData,
	#superclass : #DShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DTextBlocProcessData >> processCreatedData: aKey incoming: aDText with: aBlTextElement context: aContext [
	| textElement |
	textElement := aBlTextElement ifNil:[BlTextElement new].
	super processCreatedData: aKey incoming: aDText with: textElement context: aContext.		
	^self processUpdatedData: aKey incoming: aDText with: textElement context: aContext.

]

{ #category : #processing }
DTextBlocProcessData >> processUpdatedData: aKey incoming: aDText with: aBlTextElement context: aContext [
	| position ropedText |
	super processUpdatedData: aKey incoming: aDText with: aBlTextElement context: aContext.
	
	ropedText := BlRopedText string: (aDText text ifNil:['']).
	ropedText fontSize: aDText fontSize.
	ropedText foreground: aDText fillColor.
	ropedText regular.
	ropedText fontName: 'Monospace'.
	aBlTextElement text: ropedText.

	aDText coordinates ifNotNil:[
		position := self processor projection projCartToPixel: aDText coordinates.
		aDText offsetPx 	ifNotNil: [ aBlTextElement relocate: (position + aDText offsetPx).];
								ifNil: [ aBlTextElement relocate: position ]
	] ifNil:[
		aDText offsetPx 	ifNotNil: [	aBlTextElement relocate: aDText offsetPx.];
								ifNil: [ aBlTextElement relocate: 0@0 ]
	].

	^aBlTextElement
]
