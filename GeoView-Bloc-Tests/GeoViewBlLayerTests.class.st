Class {
	#name : #GeoViewBlLayerTests,
	#superclass : #TestCase,
	#category : #'GeoView-Bloc-Tests-Cases - View and Layer'
}

{ #category : #tests }
GeoViewBlLayerTests >> testBlGeoViewLayer [
	| layer |
	layer := BlGeoViewLayer new.
	self assert: layer layerName isNil.
	self assert: layer isGeoObjectLayer equals: false.
	self assert: layer displayProjectionModel class equals: GeoViewProjectionModel.
	self assert: layer graphicProjectionModel class equals: GeoViewProjectionModel.
	
	layer layerName: #layer.
	self assert: layer layerName equals: #layer.
	
	layer mapProjection: MercatorProjection new.
	self assert: layer displayProjectionModel projection class equals: MercatorProjection.
	
	layer symbologyProvider: GeoSymbologyProvider new.
	self assert: layer graphicProjectionModel symbologyProvider class equals: GeoSymbologyProvider.
]

{ #category : #tests }
GeoViewBlLayerTests >> testBlGeoViewLayerProcessData [
	| layer flag |
	layer := BlGeoViewObjectLayer new.
	flag := false.
	layer processDataChangedCallback:[ :l | flag := true ].
	self assert: layer getAllProcessData size equals: 0.
	
	layer setProcessData: GeoCircleProcessData new for: GeoCircle.
	self assert: (layer getProcessDataFor: GeoCircle) class equals: GeoCircleProcessData.
	self assert: layer getAllProcessData size equals: 1.
	self assert: flag equals: true.
	flag := false.
	
	layer deleteProcessDataFor: GeoCircle.
	self assert: (layer getProcessDataFor: GeoCircle) isNil.
	self assert: layer getAllProcessData size equals: 0.
	self assert: flag equals: true.
	flag := false.
	
	layer setDefaultProcessData: GeoCircleProcessData.
	self assert: (layer getProcessDataFor: GeoCircle) isNil.
	self assert: layer getAllProcessData size equals: 0.
	self assert: flag equals: true.
	
]

{ #category : #tests }
GeoViewBlLayerTests >> testBlGeoViewObjectLayer [
	| layer |
	layer := BlGeoViewObjectLayer new.
	self assert: layer isGeoObjectLayer equals: true. 
	self assert: layer processDataChangedCallback isNil.
]
