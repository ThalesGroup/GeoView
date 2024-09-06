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

	super aeDrawOn: aeCanvas.

	self layers do: [ :l | l aeDrawOn: aeCanvas ].

	isMarkedForSortDatas := false
]

{ #category : #'API -- picking' }
BlGeoViewAeElement >> pickAt: aGlobalPoint radius: aRadiusInPixels [
	"prepare the picking result"

	| pickingResult |
	pickingResult := (super pickAt: aGlobalPoint radius: aRadiusInPixels) ifNil:[ ^ nil ].

	"labordep: prepare to be setup with others blocks"
	pickingResult distanceBlock: [ :gShape :point | gShape distanceTo: point ].

	"Collect all picked elements"
	self getLayers do:[ :l | l populatePickingResult: pickingResult ].

	pickingResult applyOrder: [ :a :b | a distanceInPixels < b distanceInPixels ].
	
	^ pickingResult
]
