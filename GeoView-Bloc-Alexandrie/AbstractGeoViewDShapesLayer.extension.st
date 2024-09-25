Extension { #name : #AbstractGeoViewDShapesLayer }

{ #category : #'*GeoView-Bloc-Alexandrie' }
AbstractGeoViewDShapesLayer >> aeDrawOn: aeCanvas [

	self isVisible ifFalse: [ ^ self ].
	sortedDatas ifNil: [ ^ self ].
	
	sortedDatas do: [ :e | e aeDrawOn: aeCanvas ]
]
