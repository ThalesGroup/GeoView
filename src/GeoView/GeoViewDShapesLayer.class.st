"
This layer can manage DShapes in a model.
Use this kind of layers for example to decorate a view with some DShape.
"
Class {
	#name : #GeoViewDShapesLayer,
	#superclass : #AbstractGeoViewGraphicModelLayer,
	#instVars : [
		'userModel'
	],
	#category : #'GeoView-Layers'
}

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> addDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	self displayModelMutex critical: [
		(self haveDShapeKey: aDShape key) ifFalse: [
			self userModel at: aDShape key put: aDShape ] ].

	self graphicModelMutex critical: [ super addDShape: aDShape ]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> addDShapes: aDShapeList [

	| toAdd |
	aDShapeList ifNil: [ ^ self ].
	toAdd := OrderedCollection new.

	self displayModelMutex critical: [
		aDShapeList do: [ :e |
			(self haveDShapeKey: e key) ifFalse: [
				self userModel at: e key put: e.
				toAdd add: e ] ] ].

	self graphicModelMutex critical: [ super addDShapes: toAdd ]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> haveDShapeKey: aKey [
	"Warning : call this message only on a user changes critical block"

	aKey ifNil: [ ^ false ].
	^ self userModel includesKey: aKey
]

{ #category : #initialization }
GeoViewDShapesLayer >> initialize [

	super initialize.
	self initializeUserModel.
]

{ #category : #initialization }
GeoViewDShapesLayer >> initializeUserModel [

	userModel := Dictionary new
]

{ #category : #'API -- projection' }
GeoViewDShapesLayer >> mapProjection [

	"do nothing"
]

{ #category : #'API -- projection' }
GeoViewDShapesLayer >> mapProjection: aMapProjection [

	"do nothing"
]

{ #category : #private }
GeoViewDShapesLayer >> populatePickingResult: aPickingResult at: index with: aGShape [
	"Way to detect if the gShape is picked"

	| pickingElement data |
	pickingElement := super populatePickingResult: aPickingResult at: index with: aGShape.
	pickingElement ifNil:[ ^ nil ].
	
	"add dShape"
	self displayModelMutex critical: [ data := self userModel at: index ifAbsent:[ nil ] ].
	pickingElement dShape: data. 
	
 	^ pickingElement 
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> removeDShape: aDShape [

	self displayModelMutex critical: [
		(self haveDShapeKey: aDShape key) ifTrue: [
			self userModel removeKey: aDShape key ] ].

	self graphicModelMutex critical: [ super removeDShape: aDShape ]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> removeDShapes: aDShapeList [

	| toRemove |
	aDShapeList ifNil: [ ^ self ].
	toRemove := OrderedCollection new.

	self displayModelMutex critical: [
		aDShapeList do: [ :e |
			(self haveDShapeKey: e key) ifFalse: [
				self userModel at: e key put: e.
				toRemove add: e ] ] ].

	self graphicModelMutex critical: [ super removeDShapes: toRemove ]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> updateDShape: aDShape [

	self displayModelMutex critical: [
		(self haveDShapeKey: aDShape key) ifTrue: [
			self userModel at: aDShape key put: aDShape ] ].

	self graphicModelMutex critical: [ super updateDShape: aDShape ]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> updateDShapes: aDShapeList [

	| toUpdate |
	aDShapeList ifNil: [ ^ self ].
	toUpdate := OrderedCollection new.

	self displayModelMutex critical: [
		aDShapeList do: [ :e |
			(self haveDShapeKey: e key) ifTrue: [
				self userModel at: e key put: e.
				toUpdate add: e ] ] ].

	self graphicModelMutex critical: [ super updateDShapes: toUpdate ]
]

{ #category : #private }
GeoViewDShapesLayer >> updateModel: aContext [

	| dShapes |
	self displayModelMutex critical: [ | datas |
		
		datas := self userModel.
		
		"In case of projection changes, select only dShapes drawed in user coordinates to update, else select all"
		dShapes := aContext isProjectionChanges ifTrue:[
			datas select: [ :e | e hasUserComputing ].
		] ifFalse:[
			datas collect:[ :e | e isComposite ifTrue:[ e updateChildrenInDepth ]. e ].
		].
	].

	self graphicModelMutex critical:[	
		super updateGraphicModelWithDShapes: dShapes 
	]
]

{ #category : #accessing }
GeoViewDShapesLayer >> userModel [

	^ userModel
]
