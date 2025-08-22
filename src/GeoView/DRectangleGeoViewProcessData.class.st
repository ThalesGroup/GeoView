Class {
	#name : #DRectangleGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
DRectangleGeoViewProcessData >> createGShape2D [ 

	^ SmockGRectangle2D new
]

{ #category : #processing }
DRectangleGeoViewProcessData >> processUpdatedData: aKey incoming: aDRectangle with: aGRectangle2D context: aContext [

	| length1 length2 orientation |
	super processUpdatedData: aKey incoming: aDRectangle with: aGRectangle2D context: aContext.
	(aDRectangle length1 isNil or:[aDRectangle length2 isNil]) ifTrue:[ ^ aGRectangle2D ].
	aDRectangle orientation ifNotNil:[ :e | orientation := e asTrigonometricAngle ].
	
	aDRectangle isDrawModeDevice ifTrue:[ 
		length1 := aDRectangle length1.
		length2 := aDRectangle length2.
	] ifFalse: [ 
		aDRectangle isDrawModeUser ifTrue:[
			length1 := aDRectangle length1 * self processor projection metersByPixel.
			length2 := aDRectangle length2 * self processor projection metersByPixel.
		].
	].

	aGRectangle2D length1: length1.
	aGRectangle2D length2: length2.
	aGRectangle2D rotationInDegrees: orientation.
	
	^ aGRectangle2D 
]
