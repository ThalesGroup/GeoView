Class {
	#name : #DCircleGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
DCircleGeoViewProcessData >> createGShape2D [ 

	^ SmockGCircle2D new
]

{ #category : #processing }
DCircleGeoViewProcessData >> processUpdatedData: aKey incoming: aDCircle with: aGCircle2D context: aContext [

	| radius |
	super processUpdatedData: aKey incoming: aDCircle with: aGCircle2D context: aContext.
	aDCircle radius ifNil:[ ^ aGCircle2D ].
	
	aDCircle isDrawModeDevice ifTrue:[ 
		radius := aDCircle radius 
	] ifFalse: [ 
		aDCircle isDrawModeUser ifTrue:[
			radius := aDCircle radius * self processor projection metersByPixel.
		].
	].

	aGCircle2D radius: radius.
	
	^ aGCircle2D 
]
