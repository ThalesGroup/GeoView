Extension { #name : #GeoViewGeoObjectsLayer }

{ #category : #'*GeoView-Bloc-Alexandrie' }
GeoViewGeoObjectsLayer >> aeDrawOn: aeCanvas [

	self isVisible ifFalse: [ ^ self ].
	sortedDatas ifNil: [ ^ self ].
	
	sortedDatas do: [ :e | e aeDrawOn: aeCanvas ]
]
