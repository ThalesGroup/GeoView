Class {
	#name : #GeoTextProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-GeoObjects-ProcessData'
}

{ #category : #processing }
GeoTextProcessData >> processCreatedData: aKey incoming: aGeoText with: aDText context: aContext [
	| dText |
	dText := aDText ifNil:[SmockDText new].
	super processCreatedData: aKey incoming: aGeoText with: dText context: aContext.
	
	self flag:'labordep: use a smockfont from aGeoText'.
	dText smockFont: SmockFont defaultFont.
	
	"dText fontName: aGeoText fontName.
	dText fontSize: aGeoText fontSize.
	dText fontEmphasis: aGeoText fontEmphasis.
	dText fontWeight: aGeoText fontWeight."
	dText text: aGeoText text.
	
	^dText
]

{ #category : #processing }
GeoTextProcessData >> processUpdatedData: aKey incoming: aGeoText with: aDText context: aContext [
	| dText |
	dText := aDText.
	super processUpdatedData: aKey incoming: aGeoText with: dText context: aContext.
	
	dText fontName: aGeoText fontName.
	dText fontSize: aGeoText fontSize.
	dText fontEmphasis: aGeoText fontEmphasis.
	dText fontWeight: aGeoText fontWeight.
	dText text: aGeoText text.
	
	^dText
]
