Class {
	#name : #DSymbolGeoViewAeProcessData,
	#superclass : #DLeafShapeGeoViewAeProcessData,
	#category : #'GeoView-Bloc-Alexandrie-GShape-ProcessData'
}

{ #category : #private }
DSymbolGeoViewAeProcessData >> createGShape2D [ 

	^ SmockGBitmap2D new
]

{ #category : #processing }
DSymbolGeoViewAeProcessData >> processUpdatedData: aKey incoming: aDSymbol with: aGBitmap2D context: aContext [

	super processUpdatedData: aKey incoming: aDSymbol with: aGBitmap2D context: aContext.
	
	"Get image (Form) from symbol provider"
	self processor ifNotNil:[ :p | p symbologyProvider ifNotNil:[ :symbologyProvider | | anImage |
		anImage := symbologyProvider getSymbol: aDSymbol symbolKey.
		(anImage ~= aGBitmap2D form) ifTrue:[
			aGBitmap2D form: anImage.
		].
	]].

	"color mask property"
	(aDSymbol fillStyle notNil and:[ aDSymbol fillStyle isColor ]) ifTrue: [ 
		aGBitmap2D colorMask: aDSymbol fillStyle paint.
	] ifFalse:[
		aGBitmap2D colorMask: nil.
	].

	"transformations from expected trigonometric degrees to trigonometric degrees"
	aGBitmap2D rotation: (aDSymbol orientation % 360).	

	^ aGBitmap2D 
]
