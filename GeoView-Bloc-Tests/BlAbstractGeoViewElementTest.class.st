"
A BlAbstractGeoViewElementTest is a test class for testing the behavior of BlAbstractGeoViewElement
"
Class {
	#name : #BlAbstractGeoViewElementTest,
	#superclass : #TestCase,
	#category : #'GeoView-Bloc-Tests-Core'
}

{ #category : #tests }
BlAbstractGeoViewElementTest >> testAddLayer [

	| element layer |
	element := BlAbstractGeoViewElement new.
	layer := GeoViewTestLayer new.
	element addLayer: layer.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testGeoViewLayerProcessDataChanged [

	| element tag layer |
	"initialize geoview and event handler"
	element := BlAbstractGeoViewElement new.
	tag := false.	
	element addEventHandlerOn: GeoViewLayerProcessDataChanged do: [ :e | tag := true ].
	self deny: tag.
	
	"create and add the layer"
	layer := GeoViewGeoObjectsLayer new name: #myLayer.
	element addLayer: layer.
	self deny: tag.
	
	"change layer process datas"
	layer setProcessData: GeoCircleProcessData for: GeoCircle.
	
	self assert: tag.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testGetLayer [

	| element |
	element := BlAbstractGeoViewElement new.
	self assert: (element getLayer: #test) isNil.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testGetLayers [

	| element |
	element := BlAbstractGeoViewElement new.
	self assert: element getLayers isEmpty.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testInteractionsStrategy [

	| element |
	element := BlAbstractGeoViewElement new.
	self assert: element interactionsStrategy class equals: GeoViewDefaultInteractionsStrategy
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testNewInteractionsStrategy [

	| element |
	element := BlAbstractGeoViewElement new.
	self assert: element newInteractionsStrategy class equals: GeoViewDefaultInteractionsStrategy.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testObjectIndexAccessor [

	| element |
	element := BlAbstractGeoViewElement new.
	self assert: element objectIndexAccessor equals: #key.
	
	element objectIndexAccessor: #id.
	self assert: element objectIndexAccessor equals: #id.
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testRemoveInteractionsStrategy [

	| element |
	element := BlAbstractGeoViewElement new.
	element removeInteractionsStrategy.
	self assert: element interactionsStrategy isNil
]

{ #category : #tests }
BlAbstractGeoViewElementTest >> testSetInteractionsStrategy [

	| element |
	element := BlAbstractGeoViewElement new.
	element setInteractionsStrategy: nil.
	self assert: element interactionsStrategy isNil
]
