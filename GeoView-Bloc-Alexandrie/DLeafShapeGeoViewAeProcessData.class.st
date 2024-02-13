Class {
	#name : #DLeafShapeGeoViewAeProcessData,
	#superclass : #DShapeGeoViewAeProcessData,
	#category : #'GeoView-Bloc-Alexandrie-GShape-ProcessData'
}

{ #category : #accessing }
DLeafShapeGeoViewAeProcessData class >> isAbstract [ 

	^ self = DLeafShapeGeoViewAeProcessData
]

{ #category : #private }
DLeafShapeGeoViewAeProcessData >> createGShape2D [

	^ self subclassResponsibility 
]

{ #category : #processing }
DLeafShapeGeoViewAeProcessData >> processCreatedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	| gShape2D |
	gShape2D := aGShape2D ifNil: [ self createGShape2D ].
	gShape2D id: aKey.
	
	super processCreatedData: aKey incoming: aDShape with: gShape2D context: aContext.
	^ self processUpdatedData: aKey incoming: aDShape with: gShape2D context: aContext
]

{ #category : #processing }
DLeafShapeGeoViewAeProcessData >> processUpdatedData: aKey incoming: aDShape with: aGShape2D context: aContext [

	super processUpdatedData: aKey incoming: aDShape with: aGShape2D context: aContext.
	
	aGShape2D fillStyle: aDShape fillStyle.
	aGShape2D strokeStyle: aDShape strokeStyle.
]
