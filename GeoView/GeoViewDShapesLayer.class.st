Class {
	#name : #GeoViewDShapesLayer,
	#superclass : #AbstractGeoViewGraphicModelLayer,
	#instVars : [
		'dShapeList'
	],
	#category : #'GeoView-Layers'
}

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> addDShape: aDShape [
	
	(self dShapeList includesKey: (aDShape key)) ifTrue:[ ^ self ].
	self dShapeList at: aDShape key put: aDShape.
	super addDShape: aDShape.
	self sortDatas.
]

{ #category : #accessing }
GeoViewDShapesLayer >> dShapeList [

	^ dShapeList
]

{ #category : #initialization }
GeoViewDShapesLayer >> initialize [

	super initialize.
	self initializeDShapeList.
]

{ #category : #accessing }
GeoViewDShapesLayer >> initializeDShapeList [

	dShapeList := Dictionary new
]

{ #category : #'API -- projection' }
GeoViewDShapesLayer >> mapProjection [

	"do nothing"
]

{ #category : #'API -- projection' }
GeoViewDShapesLayer >> mapProjection: aMapProjection [

	"do nothing"
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> removeDShape: aDShape [
	
	(self dShapeList includesKey: (aDShape key)) ifFalse:[ ^ self ].
	self dShapeList removeKey: aDShape key.
	super removeDShape: aDShape.
	self sortDatas.
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> updateDShape: aDShape [
	
	(self dShapeList includesKey: (aDShape key)) ifFalse:[ ^ self ].
	self dShapeList at: aDShape key put: aDShape.
	super updateDShape: aDShape.
	self sortDatas.
]

{ #category : #private }
GeoViewDShapesLayer >> updateModel [

	self dShapeList valuesDo: [ :dShape | self updateGraphicModelWith: dShape ]
]
