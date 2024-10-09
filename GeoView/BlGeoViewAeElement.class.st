"
I am a BlElement which display a GeoViewWidget using Alexandrie backend drawing.
"
Class {
	#name : #BlGeoViewAeElement,
	#superclass : #BlAbstractGeoViewElement,
	#instVars : [
		'inputContext'
	],
	#category : #'GeoView-Bloc'
}

{ #category : #drawing }
BlGeoViewAeElement >> aeDrawOn: aeCanvas [
	"drawing native bloc elements"

	super aeDrawOn: aeCanvas.

	self layers do: [ :l | l isVisible ifTrue: [ l aeDrawOn: aeCanvas ] ].

	isMarkedForSortDatas := false
]

{ #category : #'private - picking' }
BlGeoViewAeElement >> postConfigurePickingResult: aPickingResult radius: aRadius [

	super postConfigurePickingResult: aPickingResult radius: aRadius.

	aPickingResult applyOrder: [ :a :b | a distanceInPixels < b distanceInPixels ].
]

{ #category : #'private - picking' }
BlGeoViewAeElement >> preConfigurePickingResult: aPickingResult radius: aRadius [
	
	super preConfigurePickingResult: aPickingResult radius: aRadius.
	
	aPickingResult distanceBlock: [ :gShape :point | gShape distanceTo: point ]
]
