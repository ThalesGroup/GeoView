"
I am the Geoplot Bloc layer.
"
Class {
	#name : #BlGeoViewObjectLayer,
	#superclass : #BlGeoViewLayer,
	#traits : 'GeoViewObjectLayer',
	#classTraits : 'GeoViewObjectLayer classTrait',
	#instVars : [
		'processDataChangedCallback'
	],
	#category : #'GeoView-Bloc-Core-Impl'
}

{ #category : #'geobjects aur' }
BlGeoViewObjectLayer >> addGeoObject: aGeoObject [
	| dObject blElement |
	dObject := self displayProjectionModel created: aGeoObject.
	dObject ifNotNil:[
		"convert dShape to BlElement"
		blElement := self graphicProjectionModel created: dObject.
		blElement ifNotNil:[self addChild: blElement].
	].
]

{ #category : #'geobjects aur' }
BlGeoViewObjectLayer >> addGeoObjects: aGeoObjectList [
	aGeoObjectList do:[ :e | self addGeoObject:  e].
]

{ #category : #'process data' }
BlGeoViewObjectLayer >> deleteProcessDataFor: aGeoObjectClass [
	| dModel result |
	dModel := self displayProjectionModel.
	result := dModel deleteProcessDataFor: aGeoObjectClass.
	self notifyProcessDataChanged.
	^result
]

{ #category : #'process data' }
BlGeoViewObjectLayer >> getAllProcessData [
	| dModel |
	dModel := self displayProjectionModel.
	^dModel getAllProcessData
]

{ #category : #'process data' }
BlGeoViewObjectLayer >> getProcessDataFor: aGeoObjectClass [
	| dModel |
	dModel := self displayProjectionModel.
	^dModel getProcessDataFor: aGeoObjectClass
]

{ #category : #accessing }
BlGeoViewObjectLayer >> layerName [
	^layerName 
]

{ #category : #private }
BlGeoViewObjectLayer >> notifyProcessDataChanged [
	"notification callback"
	self processDataChangedCallback ifNotNil:[ :e | e value: self].
	self changed: #processDataChanged with: self.
]

{ #category : #accessing }
BlGeoViewObjectLayer >> processDataChangedCallback [
	^processDataChangedCallback
]

{ #category : #accessing }
BlGeoViewObjectLayer >> processDataChangedCallback: aCallbackBlock [
	processDataChangedCallback := aCallbackBlock
]

{ #category : #'geobjects aur' }
BlGeoViewObjectLayer >> removeGeoObject: aGeoObject [
	| dShape blElement |
	dShape := self displayProjectionModel deleted: aGeoObject.
	dShape ifNotNil:[
		"convert dShape to BlElement"
		blElement := self graphicProjectionModel deleted: dShape.
		blElement ifNotNil:[self removeChild: blElement].
	].
]

{ #category : #'geobjects aur' }
BlGeoViewObjectLayer >> removeGeoObjects: aGeoObjectList [
	aGeoObjectList do:[ :e | self removeGeoObject:  e].
]

{ #category : #'process data' }
BlGeoViewObjectLayer >> setDefaultProcessData: aDataProcessor [
	| dModel result |
	dModel := self displayProjectionModel.
	result := dModel defaultProcessData: aDataProcessor.
	self notifyProcessDataChanged.
	^result
]

{ #category : #'process data' }
BlGeoViewObjectLayer >> setProcessData: aProcessData for: aGeoObjectClass [
	| dModel |
	dModel := self displayProjectionModel.
	dModel setProcessData: aProcessData for: aGeoObjectClass.
	self notifyProcessDataChanged.
]

{ #category : #'geobjects aur' }
BlGeoViewObjectLayer >> updateGeoObject: aGeoObject [
	| dShape |
	dShape := self displayProjectionModel updated: aGeoObject.
	dShape ifNotNil:[
		"convert dShape to BlElement"
		self graphicProjectionModel updated: dShape.
	].
]

{ #category : #'geobjects aur' }
BlGeoViewObjectLayer >> updateGeoObjects: aGeoObjectList [
	aGeoObjectList do:[ :e | self updateGeoObject:  e].
]

{ #category : #private }
BlGeoViewObjectLayer >> updateModelToView [
	"Update the layer from his Display Model"
	| model |
	super updateModelToView.
	model := self displayProjectionModel.
	model datas valuesDo:[ :dShape | self graphicProjectionModel updated: dShape ].
]
