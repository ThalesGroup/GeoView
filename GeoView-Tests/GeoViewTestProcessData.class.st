"
Process Data for GFLModel Tests
"
Class {
	#name : #GeoViewTestProcessData,
	#superclass : #SmockProcessData,
	#category : #'GeoView-Tests-Utils'
}

{ #category : #processing }
GeoViewTestProcessData >> processCreatedData: aKey incoming: aSourceData with: aProducedData context: aContext [
	^aSourceData data
]

{ #category : #processing }
GeoViewTestProcessData >> processDeletedData: aKey incoming: aSourceData with: aProducedData context: aContext [
	^nil
]

{ #category : #processing }
GeoViewTestProcessData >> processUpdatedData: aKey incoming: aSourceData with: aProducedData context: aContext [
	^aSourceData data
]
