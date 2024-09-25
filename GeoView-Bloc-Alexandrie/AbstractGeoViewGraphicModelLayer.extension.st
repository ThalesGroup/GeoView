Extension { #name : #AbstractGeoViewGraphicModelLayer }

{ #category : #'*GeoView-Bloc-Alexandrie' }
AbstractGeoViewGraphicModelLayer >> aeDrawOn: aeCanvas [

	self isVisible ifFalse: [ ^ self ].
	sortedDatas ifNil: [ ^ self ].
	
	sortedDatas do: [ :e | e aeDrawOn: aeCanvas ]
]
