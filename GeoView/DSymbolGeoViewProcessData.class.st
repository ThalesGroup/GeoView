Class {
	#name : #DSymbolGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
DSymbolGeoViewProcessData >> createGShape2D [ 

	^ SmockGBitmap2D new
]

{ #category : #processing }
DSymbolGeoViewProcessData >> processUpdatedData: aKey incoming: aDSymbol with: aGBitmap2D context: aContext [

	super processUpdatedData: aKey incoming: aDSymbol with: aGBitmap2D context: aContext.
	
	"Get image (Form) from symbol provider"
	self processor ifNotNil:[ :p | p symbologyProvider ifNotNil:[ :symbologyProvider | | anImage |
		anImage := symbologyProvider getSymbol: aDSymbol symbolKey.
		(anImage ~= aGBitmap2D form) ifTrue:[
			aGBitmap2D form: anImage.
		].
	]].

	"fill style property"
	aGBitmap2D fillStyle: aDSymbol fillStyle.

	"transformations from expected trigonometric degrees to trigonometric degrees"
	aGBitmap2D rotation: (aDSymbol orientation % 360).	

	^ aGBitmap2D 
]
