Class {
	#name : #DImageGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
DImageGeoViewProcessData >> createGShape2D [ 

	^ SmockGBitmap2D new
]

{ #category : #processing }
DImageGeoViewProcessData >> processUpdatedData: aKey incoming: aDImage with: aGBitmap2D context: aContext [

	super processUpdatedData: aKey incoming: aDImage with: aGBitmap2D context: aContext.

	"image content"
	aGBitmap2D form: aDImage image.
	aGBitmap2D fillStyle: aDImage fillStyle.

	"transformations from expected trigonometric degrees to trigonometric degrees"
	aGBitmap2D rotation: (aDImage orientation % 360).	

	aDImage isDrawModeUser ifTrue:[ | extent projectedExtent newScale metersByPixel |
		"Draw mode user, compute the scale to corresponding to the projection and use the DImage scale to adapt the final real scale. By default, with a 1@1 scale, one pixel = one meter"
		aGBitmap2D form ifNil:[ ^ aGBitmap2D ].

		extent := aGBitmap2D form extent.
		(extent x = 0 or:[extent y = 0]) ifTrue:[ ^ aGBitmap2D ].
		
		metersByPixel := self processor projection metersByPixel.
		metersByPixel = 0 ifTrue:[ ^ aGBitmap2D ].
		projectedExtent := extent * metersByPixel.
		
		"Compute the scale, use DImage scale to setup the real scale"
		newScale := (projectedExtent / extent) * (aDImage scale).
		
		"use scale x to build final scale, because a bitmap is a matrix of squared pixels"
		aGBitmap2D scale: (newScale x asPoint). 
		
	] ifFalse:[
		"Draw mode device, set the image scale directly"
		aGBitmap2D scale: aDImage scale.
	].

	^ aGBitmap2D 
]
