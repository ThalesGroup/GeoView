"
I am a BlElement which display a GeoViewWidget using Alexandrie backend drawing.
"
Class {
	#name : #BlGeoViewAeElement,
	#superclass : #BlAbstractGeoViewElement,
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
