"
ProcessData to convert DPolygon to GPolygon2D
"
Class {
	#name : #DPolygonGeoViewAeProcessData,
	#superclass : #DLeafShapeGeoViewAeProcessData,
	#category : #'GeoView-Bloc-Alexandrie-GShape-ProcessData'
}

{ #category : #private }
DPolygonGeoViewAeProcessData >> createGShape2D [ 

	^ SmockGPolygon2D new
]

{ #category : #private }
DPolygonGeoViewAeProcessData >> processUpdatedData: aKey incoming: aDPolygon with: aGPolygon2D context: aContext [

	| points |
	super processUpdatedData: aKey incoming: aDPolygon with: aGPolygon2D context: aContext.
	(aDPolygon points isNil or:[ aDPolygon points isEmpty]) ifTrue:[ ^ aGPolygon2D ].
	
	aDPolygon isDrawModeDevice ifTrue:[ 
		points := aDPolygon points 
	] ifFalse: [ 
		( aDPolygon isDrawModeUser or:[ aDPolygon isDrawModeUserProjected ] ) ifTrue:[
			points := aDPolygon points collect:[:pt | pt * self processor projection metersByPixel].
		].
	].

	aGPolygon2D points: points.
	
	^ aGPolygon2D 
]
