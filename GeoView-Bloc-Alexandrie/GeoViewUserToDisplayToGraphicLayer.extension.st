Extension { #name : #GeoViewUserToDisplayToGraphicLayer }

{ #category : #'*GeoView-Bloc-Alexandrie' }
GeoViewUserToDisplayToGraphicLayer >> aeDrawOn: aeCanvas [

	self isVisible ifFalse: [ ^ self ].
	sortedDatas ifNil: [ ^ self ].
	
	sortedDatas do: [ :e | e aeDrawOn: aeCanvas ]
]
