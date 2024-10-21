"
I am a BlElement which display a GeoViewWidget using Alexandrie backend drawing.
"
Class {
	#name : #GeoViewAeElement,
	#superclass : #GeoViewAbstractElement,
	#category : #'GeoView-Core'
}

{ #category : #drawing }
GeoViewAeElement >> aeDrawOn: aeCanvas [
	"drawing native bloc elements"

	super aeDrawOn: aeCanvas.
	self layers do: [ :l | l isVisible ifTrue: [ l aeDrawOn: aeCanvas ] ]
]
