Class {
	#name : #GeoViewUserToDisplayToGraphicLayer,
	#superclass : #Object,
	#traits : 'TGeoViewLayer',
	#classTraits : 'TGeoViewLayer classTrait',
	#instVars : [
		'graphicModel',
		'displayModel',
		'sortedDatas',
		'graphicalOrderSortBlock'
	],
	#category : #'GeoView-View'
}

{ #category : #'as yet unclassified' }
GeoViewUserToDisplayToGraphicLayer >> addObject: anObject [

	| dObject |
	dObject := self displayModel created: anObject.

	"convert dShape to gShape"
	dObject ifNotNil: [ 
		self graphicModel created: dObject 
	]
]

{ #category : #'as yet unclassified' }
GeoViewUserToDisplayToGraphicLayer >> addObjects: anObjectList [

	anObjectList do: [ :e | self addObject: e ]
]

{ #category : #accessing }
GeoViewUserToDisplayToGraphicLayer >> displayModel [

	^ displayModel 
]

{ #category : #accessing }
GeoViewUserToDisplayToGraphicLayer >> displayModel: anObject [

	displayModel := anObject
]

{ #category : #accessing }
GeoViewUserToDisplayToGraphicLayer >> graphicModel [

	^ graphicModel
]

{ #category : #accessing }
GeoViewUserToDisplayToGraphicLayer >> graphicModel: anObject [

	graphicModel := anObject
]

{ #category : #'API -- drawing' }
GeoViewUserToDisplayToGraphicLayer >> graphicalOrderSortBlock [
	"Setup a sort block to change the order of graphic element stack"

	^ graphicalOrderSortBlock ifNil: [
		  graphicalOrderSortBlock := [ :gShapeA :gShapeB |
		                             (gShapeA isPropertyExists: #selected)
			                             not ] ]
]

{ #category : #'API -- drawing' }
GeoViewUserToDisplayToGraphicLayer >> graphicalOrderSortBlock: aBlockClosure [
	"Setup a sort block to change the order of graphic element stack"
	
	graphicalOrderSortBlock := aBlockClosure.
	sortedDatas ifNotNil:[ :e | 
		e sortBlock: self graphicalOrderSortBlock. 
		self sortDatas 
	]
]

{ #category : #'API -- objects management' }
GeoViewUserToDisplayToGraphicLayer >> haveObjectIndex: anIndex [

	^ self displayModel haveDataIndex: anIndex
]

{ #category : #initialize }
GeoViewUserToDisplayToGraphicLayer >> initialize [

	super initialize.
	self initializeUserToDisplayModel.
	self initializeDisplayToGraphicModel.
	self initializeSortedDatas.
]

{ #category : #initialize }
GeoViewUserToDisplayToGraphicLayer >> initializeDisplayToGraphicModel [

	self graphicModel: GeoViewModel new
]

{ #category : #initialize }
GeoViewUserToDisplayToGraphicLayer >> initializeSortedDatas [
	
	sortedDatas := SortedCollection new: self graphicModel capacity.
	
	"Sort by selected state"
	sortedDatas sortBlock: self graphicalOrderSortBlock
]

{ #category : #initialize }
GeoViewUserToDisplayToGraphicLayer >> initializeUserToDisplayModel [

	self displayModel: GeoViewModel new
]

{ #category : #accessing }
GeoViewUserToDisplayToGraphicLayer >> projection: aMapProjection [
	"Setup the map projection of the layer: Mercator, etc."
	
	self displayModel projection: aMapProjection
]

{ #category : #'as yet unclassified' }
GeoViewUserToDisplayToGraphicLayer >> removeObject: anObject [

	| dObject |
	dObject := self displayModel deleted: anObject.

	"remve gShape"
	dObject ifNotNil: [ 
		self graphicModel deleted: dObject.
	]
]

{ #category : #'as yet unclassified' }
GeoViewUserToDisplayToGraphicLayer >> removeObjects: anObjectList [

	anObjectList do: [ :e | self removeObject: e ]
]

{ #category : #'API -- process datas' }
GeoViewUserToDisplayToGraphicLayer >> setDefaultProcessData: aDataProcessor [

	self displayModel defaultProcessData: aDataProcessor.
	self processDatasChanged
]

{ #category : #'API -- process datas' }
GeoViewUserToDisplayToGraphicLayer >> setProcessData: aProcessData for: anUserObjectClass [

	| dModel |
	dModel := self displayModel.
	dModel setProcessData: aProcessData for: anUserObjectClass.
	self processDatasChanged
]

{ #category : #initialize }
GeoViewUserToDisplayToGraphicLayer >> sortDatas [

	sortedDatas removeAll.
	sortedDatas addAll: self graphicModel getDatas
]

{ #category : #accessing }
GeoViewUserToDisplayToGraphicLayer >> symbologyProvider: aSymbologyProvider [
	
	self graphicModel symbologyProvider: aSymbologyProvider
]

{ #category : #'API -- drawing' }
GeoViewUserToDisplayToGraphicLayer >> updateGraphicModel [
	"Update the graphic model with the Display model"
	
	| model |
	model := self displayModel.
	model datas valuesDo:[ :dShape | self graphicModel updated: dShape ].
]

{ #category : #'as yet unclassified' }
GeoViewUserToDisplayToGraphicLayer >> updateObject: anObject [

	| dObject |
	dObject := self displayModel updated: anObject.

	"update gShape with dShape"
	dObject ifNotNil: [ 
		self graphicModel updated: dObject
	].
]

{ #category : #'as yet unclassified' }
GeoViewUserToDisplayToGraphicLayer >> updateObjects: anObjectList [

	anObjectList do: [ :e | self updateObject: e ]
]

{ #category : #private }
GeoViewUserToDisplayToGraphicLayer >> updateState: aStateSymbol withIndexes: aKeyList [

	| dModel dObjectList |
	dModel := self displayModel.
	
	"Update the state"
	dObjectList := dModel updateState: aStateSymbol withIndexes: aKeyList.
	
	"Update the graphic model to considere the updated state"
	dObjectList do:[ :dObject | self graphicModel updated: dObject ].
]
