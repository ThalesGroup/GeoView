Class {
	#name : #GeoViewGeoObjectsLayer,
	#superclass : #GeoViewLayer,
	#traits : 'TGeoViewHandleProcessDatas + TGeoViewHandleObjects',
	#classTraits : 'TGeoViewHandleProcessDatas classTrait + TGeoViewHandleObjects classTrait',
	#instVars : [
		'graphicModel',
		'displayModel',
		'sortedDatas',
		'graphicalOrderSortBlock'
	],
	#category : #'GeoView-Core'
}

{ #category : #'API -- objects management' }
GeoViewGeoObjectsLayer >> addObject: anObject [

	| dObject |
	dObject := self displayModel created: anObject.

	"convert dShape to gShape"
	dObject ifNotNil: [ 
		self graphicModel created: dObject 
	]
]

{ #category : #'API -- objects management' }
GeoViewGeoObjectsLayer >> addObjects: anObjectList [

	anObjectList do: [ :e | self addObject: e ]
]

{ #category : #accessing }
GeoViewGeoObjectsLayer >> displayModel [

	^ displayModel 
]

{ #category : #accessing }
GeoViewGeoObjectsLayer >> displayModel: anObject [

	displayModel := anObject
]

{ #category : #accessing }
GeoViewGeoObjectsLayer >> graphicModel [

	^ graphicModel
]

{ #category : #accessing }
GeoViewGeoObjectsLayer >> graphicModel: anObject [

	graphicModel := anObject
]

{ #category : #'API -- drawing' }
GeoViewGeoObjectsLayer >> graphicalOrderSortBlock [
	"Setup a sort block to change the order of graphic element stack"

	^ graphicalOrderSortBlock ifNil: [
		  graphicalOrderSortBlock := [ :gShapeA :gShapeB |
		                             (gShapeA isPropertyExists: #selected)
			                             not ] ]
]

{ #category : #'API -- drawing' }
GeoViewGeoObjectsLayer >> graphicalOrderSortBlock: aBlockClosure [
	"Setup a sort block to change the order of graphic element stack"
	
	graphicalOrderSortBlock := aBlockClosure.
	sortedDatas ifNotNil:[ :e | 
		e sortBlock: self graphicalOrderSortBlock. 
		self sortDatas 
	]
]

{ #category : #testing }
GeoViewGeoObjectsLayer >> haveGeoObjects [

	^ true
]

{ #category : #'API -- objects management' }
GeoViewGeoObjectsLayer >> haveObjectIndex: anIndex [

	^ self displayModel haveDataIndex: anIndex
]

{ #category : #initialize }
GeoViewGeoObjectsLayer >> initialize [

	super initialize.
	self initializeUserToDisplayModel.
	self initializeDisplayToGraphicModel.
	self initializeSortedDatas.
]

{ #category : #initialize }
GeoViewGeoObjectsLayer >> initializeDisplayToGraphicModel [

	self graphicModel: GeoViewModel new
]

{ #category : #initialize }
GeoViewGeoObjectsLayer >> initializeSortedDatas [
	
	sortedDatas := SortedCollection new: self graphicModel capacity.
	
	"Sort by selected state"
	sortedDatas sortBlock: self graphicalOrderSortBlock
]

{ #category : #initialize }
GeoViewGeoObjectsLayer >> initializeUserToDisplayModel [

	self displayModel: GeoViewModel new
]

{ #category : #accessing }
GeoViewGeoObjectsLayer >> projection: aMapProjection [
	"Setup the map projection of the layer: Mercator, etc."
	
	self deprecated: 'not used internaly'.
	self displayModel projection: aMapProjection
]

{ #category : #'API -- objects management' }
GeoViewGeoObjectsLayer >> removeObject: anObject [

	| dObject |
	dObject := self displayModel deleted: anObject.

	"remve gShape"
	dObject ifNotNil: [ 
		self graphicModel deleted: dObject.
	]
]

{ #category : #'API -- objects management' }
GeoViewGeoObjectsLayer >> removeObjects: anObjectList [

	anObjectList do: [ :e | self removeObject: e ]
]

{ #category : #'API -- process datas' }
GeoViewGeoObjectsLayer >> setDefaultProcessData: aDataProcessor [

	self displayModel defaultProcessData: aDataProcessor.
	self processDatasChanged
]

{ #category : #'API -- process datas' }
GeoViewGeoObjectsLayer >> setProcessData: aProcessData for: anUserObjectClass [

	| dModel |
	dModel := self displayModel.
	dModel setProcessData: aProcessData for: anUserObjectClass.
	self processDatasChanged
]

{ #category : #initialize }
GeoViewGeoObjectsLayer >> sortDatas [

	sortedDatas removeAll.
	sortedDatas addAll: self graphicModel getDatas
]

{ #category : #'API -- symbology' }
GeoViewGeoObjectsLayer >> symbologyProvider: aSymbologyProvider [
	
	self graphicModel symbologyProvider: aSymbologyProvider
]

{ #category : #'API -- drawing' }
GeoViewGeoObjectsLayer >> updateGraphicModel [
	"Update the graphic model with the Display model"
	
	| model |
	model := self displayModel.
	model datas valuesDo:[ :dShape | self graphicModel updated: dShape ].
]

{ #category : #'API -- objects management' }
GeoViewGeoObjectsLayer >> updateObject: anObject [

	| dObject |
	dObject := self displayModel updated: anObject.

	"update gShape with dShape"
	dObject ifNotNil: [ 
		self graphicModel updated: dObject
	].
]

{ #category : #'API -- objects management' }
GeoViewGeoObjectsLayer >> updateObjects: anObjectList [

	anObjectList do: [ :e | self updateObject: e ]
]

{ #category : #private }
GeoViewGeoObjectsLayer >> updateState: aStateSymbol withIndexes: aKeyList [

	| dModel dObjectList |
	dModel := self displayModel.
	
	"Update the state"
	dObjectList := dModel updateState: aStateSymbol withIndexes: aKeyList.
	
	"Update the graphic model to considere the updated state"
	dObjectList do:[ :dObject | self graphicModel updated: dObject ].
]
