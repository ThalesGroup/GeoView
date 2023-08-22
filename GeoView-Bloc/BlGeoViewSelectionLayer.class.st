Class {
	#name : #BlGeoViewSelectionLayer,
	#superclass : #BlGeoViewLayer,
	#traits : 'GeoViewSelectionLayer',
	#classTraits : 'GeoViewSelectionLayer classTrait',
	#instVars : [
		'selectionColor'
	],
	#category : #'GeoView-Bloc-Core-Impl'
}

{ #category : #private }
BlGeoViewSelectionLayer >> clearGeoObjectsSelection [

	self displayProjectionModel datas copy keysAndValuesDo:[ :geoObjectKey :dSelectionShape | | blElement |
		self displayProjectionModel datas removeKey: geoObjectKey ifAbsent:[nil].		
		"convert dShape to BlElement"
		blElement := self graphicProjectionModel deleted: dSelectionShape.
		blElement ifNotNil:[self removeChild: blElement].
	].
]

{ #category : #accessing }
BlGeoViewSelectionLayer >> selectedDShapes: aDictionary [
	
	| selectionDShape |
	(aDictionary isNil or:[aDictionary isDictionary not]) ifTrue:[^ self].
	self clearGeoObjectsSelection.
	aDictionary isEmpty ifTrue:[^ self]. 
	
	aDictionary keysAndValuesDo: [ :geoObjectKey :dShape | | blElement |
		selectionDShape := DRectangle new.
		selectionDShape key: geoObjectKey.
		selectionDShape coordinates: dShape coordinates copy.
		selectionDShape length1: 30; length2: 30; strokeColor: self selectionColor; strokeWidth: 2; setDrawModeDevice.
		self displayProjectionModel datas at: geoObjectKey put: selectionDShape.

		"convert dShape to BlElement"
		blElement := self graphicProjectionModel created: selectionDShape.
		blElement ifNotNil:[self addChild: blElement].
	].
]

{ #category : #accessing }
BlGeoViewSelectionLayer >> selectionColor [
	^ selectionColor ifNil:[Color green]
]

{ #category : #accessing }
BlGeoViewSelectionLayer >> selectionColor: anObject [
	selectionColor := anObject
]

{ #category : #accessing }
BlGeoViewSelectionLayer >> updateModelToView [
	"Update the layer from his Display Model"
	| model |
	super updateModelToView.
	model := self displayProjectionModel.
	model datas valuesDo:[ :dShape | self graphicProjectionModel updated: dShape ].
]

{ #category : #accessing }
BlGeoViewSelectionLayer >> updateSelectedDShapes: aDictionary [
	self flag:'PLA : API en cours de construction'.
	
	aDictionary keysAndValuesDo: [ :geoObjectKey :dShape | | selectionDShape |
		selectionDShape := self displayProjectionModel datas at: geoObjectKey ifAbsent:["Pas normal" nil].
		selectionDShape ifNotNil:[
			"Update position"
			selectionDShape coordinates: dShape coordinates copy.
		].
	].

	self updateModelToView.
]
