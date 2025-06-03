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
	aGBitmap2D scale: aDImage scale.

	aDImage isDrawModeUser ifTrue:[ 
		aGBitmap2D form ifNotNil:[
			aGBitmap2D scale: (aGBitmap2D form extent x * self processor projection metersByPixel ) asPoint.
		].
	].

	^ aGBitmap2D 
]
