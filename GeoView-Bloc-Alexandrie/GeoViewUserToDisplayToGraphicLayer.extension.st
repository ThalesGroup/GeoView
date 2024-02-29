Extension { #name : #GeoViewUserToDisplayToGraphicLayer }

{ #category : #'*GeoView-Bloc-Alexandrie' }
GeoViewUserToDisplayToGraphicLayer >> aeDrawOn: aeCanvas [
	
	self isVisible ifFalse: [ ^ self ].
	sortedDatas ifNil:[ ^ self ].
	
	self flag: 'Patch to wait correction on issue #9'.
	sortedDatas copy do: [ :e | e ifNotNil:[:el | el aeDrawOn: aeCanvas ]]
]
