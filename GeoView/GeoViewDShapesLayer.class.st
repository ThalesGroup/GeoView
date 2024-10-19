"
This layer can manage DShapes in a model.
Use this kind of layers for example to decorate a view with some DShape.
"
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

	(self dShapeList includesKey: aDShape key) ifTrue: [ ^ self ].
	self dShapeList at: aDShape key put: aDShape.
	super addDShape: aDShape
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

{ #category : #initialization }
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

	(self dShapeList includesKey: aDShape key) ifFalse: [ ^ self ].
	self dShapeList removeKey: aDShape key.
	super removeDShape: aDShape
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> updateDShape: aDShape [

	(self dShapeList includesKey: aDShape key) ifFalse: [ ^ self ].
	self dShapeList at: aDShape key put: aDShape.
	super updateDShape: aDShape
]

{ #category : #private }
GeoViewDShapesLayer >> updateModel: aContext [

	self dShapeList valuesDo: [ :dShape |
		self updateGraphicModelWith: dShape ]
]
