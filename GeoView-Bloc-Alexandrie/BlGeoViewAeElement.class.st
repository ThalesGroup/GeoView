"
I am a BlElement which display a GeoViewWidget using Alexandrie backend drawing.
"
Class {
	#name : #BlGeoViewAeElement,
	#superclass : #BlAbstractGeoViewElement,
	#instVars : [
		'inputContext'
	],
	#category : #'GeoView-Bloc-Alexandrie-Core'
}

{ #category : #drawing }
BlGeoViewAeElement >> aeDrawOn: aeCanvas [
	"drawing native bloc elements"

	| sort |
	super aeDrawOn: aeCanvas.
	
	sort := self isMarkedForSortDatas.
	self layers do: [ :l |
		sort ifTrue: [ l sortDatas ].
		l aeDrawOn: aeCanvas ].

	isMarkedForSortDatas := false
]

{ #category : #private }
BlGeoViewAeElement >> dispatchUIEvent: aSmockEventWrapper [
	"Transfert event in input strategy stack to each behavior processors"

	inputContext ifNil: [ ^ self ].
	inputContext handleEvent: aSmockEventWrapper
]

{ #category : #'API -- scale and center' }
BlGeoViewAeElement >> geoCenter: anAbsoluteCoordinates [

	| cartesianCoordinates |
	super geoCenter: anAbsoluteCoordinates.
	cartesianCoordinates := self mapProjection projLatLonToCart: self geoCenter.
	
	self displayToGraphicProjection cartesianCenter: cartesianCoordinates.
	self updateGraphicModel.
]

{ #category : #private }
BlGeoViewAeElement >> handleUIEvent: anEvent [

	| wrapper |
	wrapper := SmockEventWrapper wrap: anEvent.
	self dispatchUIEvent: wrapper.
]

{ #category : #initialization }
BlGeoViewAeElement >> initialize [

	super initialize.
	
	self initializeInputContext.
]

{ #category : #initialization }
BlGeoViewAeElement >> initializeEventHandlers [

	super initializeEventHandlers.

	self addEventHandler: (BlEventHandler
			 on: BlUIEvent
			 do: [ :e | self handleUIEvent: e ]).
	
	
]

{ #category : #initialization }
BlGeoViewAeElement >> initializeInputContext [

	inputContext := SmockInputContext new.
	inputContext controller: self.
	
	inputContext addStrategy: GeoViewNavigationBlocStrategy new.
	inputContext addStrategy: GeoViewCursorInformationBlocStrategy new.
]

{ #category : #'API -- picking' }
BlGeoViewAeElement >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"prepare the picking result"

	| pickingResult distanceBlock radius |
	pickingResult := (super pickAt: aGlobalPoint radius: aRadiusInPixels) ifNil:[ ^ nil ].

	"labordep: prepare to be setup with others blocks"
	distanceBlock := [ :gShape :point | gShape distanceTo: point ].
	radius := aRadiusInPixels ifNil:[ 0 ].

	"Collect all picked elements"
	self getLayers do:[ :l | 
		l graphicModel datas keysAndValuesDo:[ :key :gShape | | distanceInPixels pickingElement |
			
			"Way to detect if the gShape is picked"
			distanceInPixels := distanceBlock value: gShape value: pickingResult localPoint.
			distanceInPixels <= radius ifTrue:[

				"Store the element into the result"				
				pickingElement := GeoViewPickingElement new.
				pickingElement layerName: l layerName.
				pickingElement layerLevel: nil. self flag:'labordep: mettre le level'.
				pickingElement distanceInPixels: distanceInPixels.
				pickingElement objectKey: key.
				pickingElement dShape: (l displayModel getData: key).
				pickingElement gShape: gShape.
				
				pickingResult addPickingElement: pickingElement.
				
			].			
		].
	].

	pickingResult applyOrder: [ :a :b | a distanceInPixels < b distanceInPixels ].
	^ pickingResult
]

{ #category : #'API -- scale and center' }
BlGeoViewAeElement >> scaleInMeters: aNumber [

	super scaleInMeters: aNumber.
	self displayToGraphicProjection altitudeInMeters: self scaleInMeters.
	self displayToGraphicProjection updateResolution: self getBounds extent.
	self updateGraphicModel
]
