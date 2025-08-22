Class {
	#name : #DEllipseGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
DEllipseGeoViewProcessData >> createGShape2D [ 

	^ SmockGEllipse2D new 
]

{ #category : #processing }
DEllipseGeoViewProcessData >> processUpdatedData: aKey incoming: aDEllipse with: aGEllipse2D context: aContext [

	| radius1 radius2 orientation |
	super processUpdatedData: aKey incoming: aDEllipse with: aGEllipse2D context: aContext. 
	(aDEllipse radius1 isNil or:[aDEllipse radius2 isNil]) ifTrue:[ ^ aGEllipse2D ].
	aDEllipse orientation ifNotNil:[ :e | orientation := e asTrigonometricAngle ].
	
	aDEllipse isDrawModeDevice ifTrue:[ 
		radius1 := aDEllipse radius1.
		radius2 := aDEllipse radius2.
	] ifFalse: [ 
		aDEllipse isDrawModeUser ifTrue:[ | metersByPixel |
			metersByPixel := self processor projection metersByPixel.
			radius1 := aDEllipse radius1 * metersByPixel.
			radius2 := aDEllipse radius2 * metersByPixel.
		].
	].

	aGEllipse2D radius1: radius1.
	aGEllipse2D radius2: radius2.
	aGEllipse2D rotationInDegrees: orientation. 
	
	^ aGEllipse2D 
]
