"
ProcessData to convert DPolygon to GPolygon2D
"
Class {
	#name : #DPolygonGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
DPolygonGeoViewProcessData >> createGShape2D [ 

	^ SmockGPolygon2D new
]

{ #category : #processing }
DPolygonGeoViewProcessData >> processUpdatedData: aKey incoming: aDPolygon with: aGPolygon2D context: aContext [

	| points |
	super processUpdatedData: aKey incoming: aDPolygon with: aGPolygon2D context: aContext.
	self flag:'laborde: heu si on met a jour le polygon en lui enlevant les points ben ça passe pas ici !!!, il faut renvoyer la forme vide, et dans tous les processdatas cest comme ça'.
	(aDPolygon points isNil or:[ aDPolygon points isEmpty]) ifTrue:[ ^ aGPolygon2D ].
	
	aDPolygon isDrawModeDevice ifTrue:[ 
		points := aDPolygon points
	] ifFalse: [ 
		aDPolygon isDrawModeUser ifTrue:[
			points := aDPolygon points collect:[:pt |
				self processor projection projCartToPixel: pt
			].
		].
	].

	aGPolygon2D points: points.
	
	^ aGPolygon2D 
]
