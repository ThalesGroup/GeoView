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

	aDShape ifNil:[ ^ self ].
	
	(self haveDShapeKey: aDShape key) ifTrue: [ ^ self ].
	self dShapeList at: aDShape key put: aDShape.
	super addDShape: aDShape
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> addDShapes: aDShapeList [

	| toAdd |
	aDShapeList ifNil:[ ^ self ].
	toAdd := OrderedCollection new.
	aDShapeList do:[ :e |  
		(self haveDShapeKey: e key) ifFalse:[
			self dShapeList at: e key put: e.
			toAdd add: e.
		].
	].
	super addDShapes: toAdd
]

{ #category : #accessing }
GeoViewDShapesLayer >> dShapeList [

	^ dShapeList
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> haveDShapeKey: aKey [

	aKey ifNil: [ ^ self ].
	^ self dShapeList includesKey: aKey
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

	(self haveDShapeKey: aDShape key) ifFalse: [ ^ self ].
	self dShapeList removeKey: aDShape key.
	super removeDShape: aDShape
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> removeDShapes: aDShapeList [

	| toRemove |
	aDShapeList ifNil:[ ^ self ].
	toRemove := OrderedCollection new.
	aDShapeList do:[ :e |  
		(self haveDShapeKey: e key) ifFalse:[
			self dShapeList at: e key put: e.
			toRemove add: e.
		].
	].
	super removeDShapes: toRemove
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> updateDShape: aDShape [

	(self haveDShapeKey: aDShape key) ifFalse: [ ^ self ].
	self dShapeList at: aDShape key put: aDShape.
	super updateDShape: aDShape
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> updateDShapes: aDShapeList [

	| toUpdate |
	aDShapeList ifNil:[ ^ self ].
	toUpdate := OrderedCollection new.
	aDShapeList do:[ :e |  
		(self haveDShapeKey: e key) ifFalse:[
			self dShapeList at: e key put: e.
			toUpdate add: e.
		].
	].
	super updateDShapes: toUpdate
]

{ #category : #private }
GeoViewDShapesLayer >> updateModel: aContext [

	self graphicModelMutex critical: [
		self dShapeList valuesDo: [ :dShape |
			self updateGraphicModelWith: dShape ] ]
]
