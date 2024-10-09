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

	"color mask property"
	(aDImage fillStyle notNil and:[ aDImage fillStyle isColor ]) ifTrue: [ 
		aGBitmap2D colorMask: aDImage fillStyle paint.
	] ifFalse:[
		aGBitmap2D colorMask: nil.
	].

	"transformations from expected trigonometric degrees to trigonometric degrees"
	aGBitmap2D rotation: (aDImage orientation % 360).	
		
	"scale"
	aGBitmap2D scale: aDImage scale.

	^ aGBitmap2D 
]
