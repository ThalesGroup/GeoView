Extension { #name : #GeoViewDShapesLayer }

{ #category : #'*GeoView-Bloc-Alexandrie' }
GeoViewDShapesLayer >> aeDrawOn: aeCanvas [

	self isVisible ifFalse: [ ^ self ].
	sortedDatas ifNil: [ ^ self ].
	
	sortedDatas do: [ :e | e aeDrawOn: aeCanvas ]
]
