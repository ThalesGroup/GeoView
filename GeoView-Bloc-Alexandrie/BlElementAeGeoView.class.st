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

{ #category : #'API -- objects management' }
BlElementAeGeoView >> addObject: anUserObject [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e addObject: anUserObject ].
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlElementAeGeoView >> addObjects: anUserObjectList [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e addObjects: anUserObjectList ].
		self requestRepaint ]
]

{ #category : #drawing }
BlElementAeGeoView >> aeDrawOn: aeCanvas [
	"drawing native bloc elements"

	super aeDrawOn: aeCanvas.
	self layers do: [ :l | l aeDrawOn: aeCanvas ]
]

{ #category : #private }
BlElementAeGeoView >> configureLayer: aLayer [
	
	"Setup the 2D projection of the layer"
	aLayer graphicModel projection: self displayToGraphicProjection.
	
	"add alexandrie process datas"
	aLayer graphicModel setProcessData: DCompositeShapeGeoViewProcessData new for: SmockDCompositeShape.
	aLayer graphicModel setProcessData: DSymbolGeoViewProcessData new for: SmockDSymbol.
	aLayer graphicModel setProcessData: DCircleGeoViewProcessData new for: SmockDCircle.
	aLayer graphicModel setProcessData: DTextGeoViewProcessData new for: SmockDText.
	aLayer graphicModel setProcessData: DPolygonGeoViewProcessData new for: SmockDPolygon.
	aLayer graphicModel setProcessData: DPolylineGeoViewProcessData new for: SmockDPolyline.

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

{ #category : #private }
BlElementAeGeoView >> enqueueBlockAsTask: aBlockClosure [

	| task |
	task := BlTaskAction new.
	task action: aBlockClosure.
	self enqueueTask: task
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

{ #category : #'API -- objects management' }
BlElementAeGeoView >> haveObjectIndex: anIndex [
	"Pay attention before using it because graphical model is out of sync real user model due to usage of BlTask (asynchronous)"

	^ self layers anySatisfy: [ :l | l haveObjectIndex: anIndex ]
]

{ #category : #accessing }
BlElementAeGeoView >> layers [

	^ layers ifNil: [ layers := OrderedCollection new ]
]

{ #category : #'API -- objects management' }
BlElementAeGeoView >> removeObject: anUserObject [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e removeObject: anUserObject ].
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlElementAeGeoView >> removeObjects: anUserObjectList [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e removeObjects: anUserObjectList ].
		self requestRepaint ]
]

{ #category : #private }
BlElementAeGeoView >> requestRepaint [

	self layers do:[ :l | l sortDatas ].
	self invalidate.
]

{ #category : #'API -- selection' }
BlElementAeGeoView >> selectedObjectIndexes: anIndexList [

	self enqueueBlockAsTask: [
		self layers do: [ :l | l updateState: #selected withIndexes: anIndexList ].
		self requestRepaint ]
]

{ #category : #'API -- drawing' }
BlElementAeGeoView >> updateGraphicModel [
	"Update the graphic model with the Display model"

	self enqueueBlockAsTask: [
		self layers do: [ :e | e updateGraphicModel ].
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlElementAeGeoView >> updateObject: anUserObject [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e updateObject: anUserObject ].
		self requestRepaint ]
]

{ #category : #'API -- objects management' }
BlElementAeGeoView >> updateObjects: anUserObjectList [

	self enqueueBlockAsTask: [
		self layers do: [ :e | e updateObjects: anUserObjectList ].
		self requestRepaint ]
]

{ #category : #private }
BlElementAeGeoView >> updateState: aStateSymbol withIndexes: aKeyList [
	
	self enqueueBlockAsTask: [ 
		self layers do: [ :l | l updateState: aStateSymbol withIndexes: aKeyList ].
		self requestRepaint
	]
]
