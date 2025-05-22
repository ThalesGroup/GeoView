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

	self userDataChangesMutex critical: [
		(self haveDShapeKey: aDShape key) ifFalse: [
			self userModel at: aDShape key put: aDShape.
			super addDShape: aDShape ] ]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> addDShapes: aDShapeList [

	| toAdd |
	aDShapeList ifNil: [ ^ self ].

	self userDataChangesMutex critical: [
		toAdd := OrderedCollection new.
		aDShapeList do: [ :e |
			(self haveDShapeKey: e key) ifFalse: [
				self userModel at: e key put: e.
				toAdd add: e ] ].
		super addDShapes: toAdd ]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> haveDShapeKey: aKey [
	"Warning : call this message only on a user changes critical block"

	aKey ifNil: [ ^ self ].
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
	self userDataChangesMutex critical: [ data := self userModel at: index ifAbsent:[ nil ] ].
	pickingElement dShape: data. 
	
 	^ pickingElement 
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> removeDShape: aDShape [

	self userDataChangesMutex critical: [
		(self haveDShapeKey: aDShape key) ifTrue: [
			self userModel removeKey: aDShape key.
			super removeDShape: aDShape ] ]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> removeDShapes: aDShapeList [

	| toRemove |
	aDShapeList ifNil: [ ^ self ].

	self userDataChangesMutex critical: [
		toRemove := OrderedCollection new.
		aDShapeList do: [ :e |
			(self haveDShapeKey: e key) ifFalse: [
				self userModel at: e key put: e.
				toRemove add: e ] ].
		super removeDShapes: toRemove ]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> updateDShape: aDShape [

	self userDataChangesMutex critical: [
		(self haveDShapeKey: aDShape key) ifTrue: [
			self userModel at: aDShape key put: aDShape.
			super updateDShape: aDShape ] ]
]

{ #category : #'API -- DShapes' }
GeoViewDShapesLayer >> updateDShapes: aDShapeList [

	| toUpdate |
	aDShapeList ifNil: [ ^ self ].

	self userDataChangesMutex critical: [
		toUpdate := OrderedCollection new.
		aDShapeList do: [ :e |
			(self haveDShapeKey: e key) ifTrue: [
				self userModel at: e key put: e.
				toUpdate add: e ] ].
		super updateDShapes: toUpdate ]
]

{ #category : #private }
GeoViewDShapesLayer >> updateDShapesInternally: aDShapeList [

	| toUpdate |
	aDShapeList ifNil: [ ^ self ].

	self userDataChangesMutex critical: [
		toUpdate := OrderedCollection new.
		aDShapeList do: [ :e |
			(self haveDShapeKey: e key) ifTrue: [
				self userModel at: e key put: e.
				toUpdate add: e ] ].
		super updateDShapesInternally: toUpdate ]
]

{ #category : #private }
GeoViewDShapesLayer >> updateModel: aContext [

	| dShapes |
	self userDataChangesMutex critical: [ | datas |
		
		datas := self userModel.
		
		"In case of projection changes, select only dShapes drawed in user coordinates to update, else select all"
		dShapes := aContext isProjectionChanges ifTrue:[
			datas select: [ :e | e hasUserComputing ].
		] ifFalse:[
			datas copy
		].

		super updateDShapesInternally: dShapes ]
]

{ #category : #accessing }
GeoViewDShapesLayer >> userModel [

	^ userModel
]
