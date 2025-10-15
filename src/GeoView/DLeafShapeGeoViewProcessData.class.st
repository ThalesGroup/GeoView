Class {
	#name : #DLeafShapeGeoViewProcessData,
	#superclass : #DShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #accessing }
DLeafShapeGeoViewProcessData class >> isAbstract [ 

	^ self == DLeafShapeGeoViewProcessData
]

{ #category : #private }
DLeafShapeGeoViewProcessData >> createGShape2D [

	^ self subclassResponsibility 
]

{ #category : #processing }
DLeafShapeGeoViewProcessData >> processCreatedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	| gShape2D |
	gShape2D := aGShape2D ifNil: [ self createGShape2D ].
	
	super processCreatedData: aKey incoming: aDShape with: gShape2D context: aContext.

	^ self processUpdatedData: aKey incoming: aDShape with: gShape2D context: aContext
]

{ #category : #processing }
DLeafShapeGeoViewProcessData >> processUpdatedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	super processUpdatedData: aKey incoming: aDShape with: aGShape2D context: aContext.
	
	aGShape2D fillStyle: aDShape fillStyle.
	aGShape2D strokeStyle: aDShape strokeStyle.
	
	^ aGShape2D 
]
