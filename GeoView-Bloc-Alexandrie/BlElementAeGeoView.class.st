Class {
	#name : #BlElementAeGeoView,
	#superclass : #BlElement,
	#traits : 'TGeoView',
	#classTraits : 'TGeoView classTrait',
	#instVars : [
		'layers',
		'displayToGraphicProjection'
	],
	#category : #'GeoView-Bloc-Alexandrie-Core'
}

{ #category : #'API -- layers management' }
BlElementAeGeoView >> addLayer: aLayer [
	
	(self layers includes: aLayer) ifTrue: [ ^ self ].
	self configureLayer: aLayer.
	self layers add: aLayer
]

{ #category : #'as yet unclassified' }
BlElementAeGeoView >> addObject: anUserObject [
	
	self layers do: [ :e | e addObject: anUserObject ].
	self requestRepaint
]

{ #category : #'as yet unclassified' }
BlElementAeGeoView >> addObjects: anUserObjectList [

	self layers do: [ :e | e addObjects: anUserObjectList ].
	self requestRepaint
]

{ #category : #drawing }
BlElementAeGeoView >> aeDrawOn: aeCanvas [

	"drawing native bloc elements"
	super aeDrawOn: aeCanvas.
	
	self layers do:[ :l | l aeDrawOn: aeCanvas ].
]

{ #category : #private }
BlElementAeGeoView >> configureLayer: aLayer [
	
	"Setup the 2D projection of the layer"
	aLayer graphicModel projection: self displayToGraphicProjection.
	
	"add alexandrie process datas"
	aLayer graphicModel setProcessData: DCompositeShapeGeoViewAeProcessData new for: SmockDCompositeShape.
	aLayer graphicModel setProcessData: DSymbolGeoViewAeProcessData new for: SmockDSymbol.
	aLayer graphicModel setProcessData: DCircleGeoViewAeProcessData new for: SmockDCircle.
	aLayer graphicModel setProcessData: DTextGeoViewAeProcessData new for: SmockDText.
	aLayer graphicModel setProcessData: DPolygonGeoViewAeProcessData new for: SmockDPolygon.
	"aLayer displayToGraphicModel defaultProcessData: DShapeAeProcessData new."
]

{ #category : #accessing }
BlElementAeGeoView >> displayToGraphicProjection [

	^ displayToGraphicProjection
]

{ #category : #accessing }
BlElementAeGeoView >> displayToGraphicProjection: anObject [

	displayToGraphicProjection := anObject
]

{ #category : #'API -- size' }
BlElementAeGeoView >> getBounds [

	^ self bounds
]

{ #category : #'API -- size' }
BlElementAeGeoView >> getExtent [
	
	^ self extent
]

{ #category : #'API -- layers management' }
BlElementAeGeoView >> getLayers [
	
	^ self layers
]

{ #category : #accessing }
BlElementAeGeoView >> layers [

	^ layers ifNil: [ layers := OrderedCollection new ]
]

{ #category : #'as yet unclassified' }
BlElementAeGeoView >> removeObject: anUserObject [
	
	self layers do: [ :e | e removeObject: anUserObject ].
	self requestRepaint
]

{ #category : #'as yet unclassified' }
BlElementAeGeoView >> removeObjects: anUserObjectList [
	
	self layers do: [ :e | e removeObjects: anUserObjectList ].
	self requestRepaint
]

{ #category : #private }
BlElementAeGeoView >> requestRepaint [

	self layers ifEmpty: [ ^ self ].
	self layers do:[ :l | l sortDatas ].
	self invalidate.
]

{ #category : #'API -- selection' }
BlElementAeGeoView >> selectedObjectIndexes: anIndexList [
	
	self layers do: [ :l | l updateState: #selected withIndexes: anIndexList ].
	self requestRepaint
]

{ #category : #'API -- drawing' }
BlElementAeGeoView >> updateGraphicModel [
	"Update the graphic model with the Display model"

	self layers do: [ :e | e updateGraphicModel ].
	self requestRepaint
]

{ #category : #'as yet unclassified' }
BlElementAeGeoView >> updateObject: anUserObject [
	
	self layers do: [ :e | e updateObject: anUserObject ].
	self requestRepaint
]

{ #category : #'as yet unclassified' }
BlElementAeGeoView >> updateObjects: anUserObjectList [
	
	self layers do: [ :e | e updateObjects: anUserObjectList ].
	self requestRepaint
]

{ #category : #private }
BlElementAeGeoView >> updateState: aStateSymbol withIndexes: aKeyList [
	
	self layers do: [ :l | l updateState: aStateSymbol withIndexes: aKeyList ].
	self requestRepaint
]
