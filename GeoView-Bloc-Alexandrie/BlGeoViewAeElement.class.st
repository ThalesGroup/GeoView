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
				pickingElement layerName: l name.
				pickingElement layerLevel: nil. self flag:'labordep: put the level of the layer'.
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
