"
ProcessData to convert DPolygon to GPolygon2D
"
Class {
	#name : #DPolygonGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewAeProcessData,
	#category : #'GeoView-Bloc-Alexandrie-GShape-ProcessData'
}

{ #category : #private }
DPolygonGeoViewProcessData >> createGShape2D [ 

	^ SmockGPolygon2D new
]

{ #category : #private }
DPolygonGeoViewProcessData >> processUpdatedData: aKey incoming: aDPolygon with: aGPolygon2D context: aContext [

	| points |
	super processUpdatedData: aKey incoming: aDPolygon with: aGPolygon2D context: aContext.
	(aDPolygon points isNil or:[ aDPolygon points isEmpty]) ifTrue:[ ^ aGPolygon2D ].
	
	aDPolygon isDrawModeDevice ifTrue:[ 
		points := aDPolygon points
	] ifFalse: [ 
		( aDPolygon isDrawModeUser or:[ aDPolygon isDrawModeUserProjected ] ) ifTrue:[
			points := aDPolygon points collect:[:pt |
				self processor projection projCartToPixel: pt
			].
		].
	].

	aGPolygon2D points: points.
	
	^ aGPolygon2D 
]
