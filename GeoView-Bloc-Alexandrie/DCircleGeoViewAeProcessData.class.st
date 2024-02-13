Class {
	#name : #DCircleGeoViewAeProcessData,
	#superclass : #DLeafShapeGeoViewAeProcessData,
	#category : #'GeoView-Bloc-Alexandrie-GShape-ProcessData'
}

{ #category : #private }
DCircleGeoViewAeProcessData >> createGShape2D [ 

	^ SmockGCircle2D new
]

{ #category : #private }
DCircleGeoViewAeProcessData >> processUpdatedData: aKey incoming: aDCircle with: aGCircle2D context: aContext [

	| radius |
	super processUpdatedData: aKey incoming: aDCircle with: aGCircle2D context: aContext.
	aDCircle radius ifNil:[ ^ aGCircle2D ].
	
	aDCircle isDrawModeDevice ifTrue:[ 
		radius := aDCircle radius 
	] ifFalse: [ 
		( aDCircle isDrawModeUser or:[ aDCircle isDrawModeUserProjected ] ) ifTrue:[
			radius := aDCircle radius * self processor projection metersByPixel.
		].
	].

	aGCircle2D radius: radius.
	
	^ aGCircle2D 
]
