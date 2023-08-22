Class {
	#name : #BlGeoViewLayer,
	#superclass : #BlElement,
	#traits : 'GeoViewLayer',
	#classTraits : 'GeoViewLayer classTrait',
	#instVars : [
		'layerName',
		'displayProjectionModel',
		'graphicProjectionModel'
	],
	#category : #'GeoView-Bloc-Core-Impl'
}

{ #category : #accessing }
BlGeoViewLayer >> displayProjectionModel [
	^ displayProjectionModel
]

{ #category : #accessing }
BlGeoViewLayer >> displayProjectionModel: anObject [
	displayProjectionModel := anObject
]

{ #category : #accessing }
BlGeoViewLayer >> graphicProjectionModel [
	^ graphicProjectionModel
]

{ #category : #accessing }
BlGeoViewLayer >> graphicProjectionModel: anObject [
	graphicProjectionModel := anObject
]

{ #category : #initialization }
BlGeoViewLayer >> initialize [
	super initialize.
	self initializeGraphicProjectionModel.
	self initializeDisplayProjectionModel.
]

{ #category : #initialization }
BlGeoViewLayer >> initializeDisplayProjectionModel [
	self displayProjectionModel: GeoViewProjectionModel new.
]

{ #category : #initialization }
BlGeoViewLayer >> initializeGraphicProjectionModel [
	self graphicProjectionModel: GeoViewProjectionModel new.
	
	"add Bloc process datas"
	self graphicProjectionModel setProcessData: DCompositeShapeBlocProcessData new for: DCompositeShape.
	self graphicProjectionModel setProcessData: DArcBandBlocProcessData new for: DArcBand.
	self graphicProjectionModel setProcessData: DCircleBlocProcessData new for: DCircle.
	self graphicProjectionModel setProcessData: DEllipseBlocProcessData new for: DEllipse.
	self graphicProjectionModel setProcessData: DImageBlocProcessData new for: DImage.
	self graphicProjectionModel setProcessData: DLineBlocProcessData new for: DLine.
	self graphicProjectionModel setProcessData: DPolygonBlocProcessData new for: DPolygon.
	self graphicProjectionModel setProcessData: DPolygonsBlocProcessData new for: DPolygons.
	self graphicProjectionModel setProcessData: DPolylineBlocProcessData new for: DPolyline.
	self graphicProjectionModel setProcessData: DRectangleBlocProcessData new for: DRectangle.
	self graphicProjectionModel setProcessData: DSectorBlocProcessData new for: DSector.
	self graphicProjectionModel setProcessData: DSegmentBlocProcessData new for: DSegment.
	self graphicProjectionModel setProcessData: DSymbolBlocProcessData new for: DSymbol.
	self graphicProjectionModel setProcessData: DTextBlocProcessData new for: DText.
]

{ #category : #accessing }
BlGeoViewLayer >> layerName [
	^layerName 
]

{ #category : #accessing }
BlGeoViewLayer >> layerName: anObject [
	layerName := anObject
]

{ #category : #testing }
BlGeoViewLayer >> mapProjection: aProjection [
	self displayProjectionModel projection: aProjection
]

{ #category : #testing }
BlGeoViewLayer >> symbologyProvider: aSymbologyProvider [
	self graphicProjectionModel symbologyProvider: aSymbologyProvider
]

{ #category : #private }
BlGeoViewLayer >> updateModelToView [
	"do nothing"
]
