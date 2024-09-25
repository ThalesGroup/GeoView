Class {
	#name : #AbstractGeoViewDShapesLayer,
	#superclass : #AbstractGeoViewLayer,
	#traits : 'TGeoViewHandleDShapes',
	#classTraits : 'TGeoViewHandleDShapes classTrait',
	#instVars : [
		'sortedDatas',
		'graphicModel',
		'graphicalOrderSortBlock'
	],
	#category : #'GeoView-Core'
}

{ #category : #testing }
AbstractGeoViewDShapesLayer class >> isAbstract [ 

	^ self == AbstractGeoViewDShapesLayer 
]

{ #category : #'API -- DShapes' }
AbstractGeoViewDShapesLayer >> addDShape: aDShape [

	aDShape ifNil:[ ^ self ].

	"convert dShape to gShape"
	self graphicModel created: aDShape
]

{ #category : #'API -- DShapes' }
AbstractGeoViewDShapesLayer >> addDShapes: aDShapeList [

	aDShapeList do: [ :e | self addDShape: e ]
]

{ #category : #accessing }
AbstractGeoViewDShapesLayer >> graphicModel [

	^ graphicModel
]

{ #category : #accessing }
AbstractGeoViewDShapesLayer >> graphicModel: anObject [

	graphicModel := anObject
]

{ #category : #'API -- projection' }
AbstractGeoViewDShapesLayer >> graphicProjection [

	^ self graphicModel projection
]

{ #category : #'API -- projection' }
AbstractGeoViewDShapesLayer >> graphicProjection: aGraphicProjection [

	self graphicModel projection: aGraphicProjection
]

{ #category : #'API -- drawing' }
AbstractGeoViewDShapesLayer >> graphicalOrderSortBlock [
	"Setup a sort block to change the order of graphic element stack"

	^ graphicalOrderSortBlock ifNil: [
		  graphicalOrderSortBlock := [ :gShapeA :gShapeB |
		                             (gShapeA isPropertyExists: #selected)
			                             not ] ]
]

{ #category : #'API -- drawing' }
AbstractGeoViewDShapesLayer >> graphicalOrderSortBlock: aBlockClosure [
	"Setup a sort block to change the order of graphic element stack"
	
	graphicalOrderSortBlock := aBlockClosure.
	sortedDatas ifNotNil:[ :e | 
		e sortBlock: self graphicalOrderSortBlock. 
		self sortDatas 
	]
]

{ #category : #'API -- DShapes' }
AbstractGeoViewDShapesLayer >> haveDShapeKey: aKey [

	^ self graphicModel haveDataIndex: aKey
]

{ #category : #initialization }
AbstractGeoViewDShapesLayer >> initialize [

	super initialize.
	self initializeDisplayToGraphicModel.
	self initializeSortedDatas
]

{ #category : #initialize }
AbstractGeoViewDShapesLayer >> initializeDisplayToGraphicModel [

	self graphicModel: GeoViewModel new
]

{ #category : #initialize }
AbstractGeoViewDShapesLayer >> initializeSortedDatas [
	
	sortedDatas := SortedCollection new: self graphicModel capacity.
	
	"Sort by selected state"
	sortedDatas sortBlock: self graphicalOrderSortBlock
]

{ #category : #'API -- picking' }
AbstractGeoViewDShapesLayer >> populatePickingResult: aPickingResult [

	self graphicModel datas keysAndValuesDo: [ :index :gShape |
		self populatePickingResult: aPickingResult at: index with: gShape ]
]

{ #category : #private }
AbstractGeoViewDShapesLayer >> populatePickingResult: aPickingResult at: index with: aGShape [
	"Way to detect if the gShape is picked"

	| distanceInPixels pickingElement |
	distanceInPixels := aPickingResult distanceBlock value: aGShape value: aPickingResult localPoint.
	(distanceInPixels notNil and: [ distanceInPixels <= aPickingResult radiusInPixels ]) ifFalse: [ ^ nil ].

	"Store the element into the result"
	pickingElement := GeoViewPickingElement new.
	pickingElement layerName: self name.
	pickingElement layerLevel: nil.
	self flag: 'labordep: put the level of the layer'.
	pickingElement distanceInPixels: distanceInPixels.
	pickingElement objectIndex: index.
	pickingElement gShape: aGShape.

	aPickingResult addPickingElement: pickingElement.
	
 	^ pickingElement 
]

{ #category : #'API -- DShapes' }
AbstractGeoViewDShapesLayer >> removeDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	"remove gShape"
	self graphicModel deleted: aDShape
]

{ #category : #'API -- DShapes' }
AbstractGeoViewDShapesLayer >> removeDShapes: aDShapeList [

	aDShapeList do: [ :e | self removeDShape: e ]
]

{ #category : #initialize }
AbstractGeoViewDShapesLayer >> sortDatas [

	sortedDatas removeAll.
	sortedDatas addAll: self graphicModel getDatas
]

{ #category : #'API -- symbology' }
AbstractGeoViewDShapesLayer >> symbologyProvider: aSymbologyProvider [
	
	self graphicModel symbologyProvider: aSymbologyProvider
]

{ #category : #'API -- DShapes' }
AbstractGeoViewDShapesLayer >> updateDShape: aDShape [

	aDShape ifNil: [ ^ self ].

	"update gShape with dShape"
	self graphicModel updated: aDShape
]

{ #category : #'API -- DShapes' }
AbstractGeoViewDShapesLayer >> updateDShapes: aDShapeList [

	aDShapeList do: [ :e | self updateDShape: e ]
]

{ #category : #private }
AbstractGeoViewDShapesLayer >> updateGraphicModelFor: aDShape [
	"Update the graphic model of a DShape"
	
	^ self graphicModel updated: aDShape
]

{ #category : #'API -- projection' }
AbstractGeoViewDShapesLayer >> viewInfos [

	^ self graphicModel viewInfos
]

{ #category : #'API -- projection' }
AbstractGeoViewDShapesLayer >> viewInfos: aViewInfos [

	self graphicModel viewInfos: aViewInfos
]
