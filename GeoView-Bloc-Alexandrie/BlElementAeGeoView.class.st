Class {
	#name : #BlElementAeGeoView,
	#superclass : #BlElement,
	#traits : 'TGeoView',
	#classTraits : 'TGeoView classTrait',
	#instVars : [
		'layers'
	],
	#category : #'GeoView-Bloc-Alexandrie'
}

{ #category : #'API -- layers management' }
BlElementAeGeoView >> addLayer: aLayer [
	
	(self layers includes: aLayer) ifTrue: [ ^ self ].
	"aLayer displayModel configure here.
	aLayer graphicModel configure here."
	self configureLayer: aLayer.
	self layers add: aLayer
]

{ #category : #private }
BlElementAeGeoView >> configureLayer: aLayer [
	
	"add alexandrie process datas"
	aLayer graphicModel setProcessData: DCompositeShapeGeoViewAeProcessData new for: SmockDCompositeShape.
	aLayer graphicModel setProcessData: DSymbolGeoViewAeProcessData new for: SmockDSymbol.
	aLayer graphicModel setProcessData: DCircleGeoViewAeProcessData new for: SmockDCircle.
	aLayer graphicModel setProcessData: DTextGeoViewAeProcessData new for: SmockDText.
	"aLayer displayToGraphicModel defaultProcessData: DShapeAeProcessData new."
]

{ #category : #'API -- layers management' }
BlElementAeGeoView >> getLayers [
	
	^ self layers
]

{ #category : #accessing }
BlElementAeGeoView >> layers [

	^ layers ifNil: [ layers := OrderedCollection new ]
]
