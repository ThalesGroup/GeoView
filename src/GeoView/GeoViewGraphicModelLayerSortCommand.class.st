Class {
	#name : #GeoViewGraphicModelLayerSortCommand,
	#superclass : #GeoViewLayerCommand,
	#category : #'GeoView-Core'
}

{ #category : #applying }
GeoViewGraphicModelLayerSortCommand >> applyOn: aGeoViewAbstractElement [

	self layer ifNil: [ ^ self ].
	self layer sortDatas
]
