Trait {
	#name : #GeoViewSelectionLayer,
	#category : #'GeoView-View & Layer'
}

{ #category : #accessing }
GeoViewSelectionLayer >> isSelectionLayer [
	^true
]

{ #category : #accessing }
GeoViewSelectionLayer >> selectedDShapes: aDictionary [
	self explicitRequirement
]

{ #category : #accessing }
GeoViewSelectionLayer >> selectedGeoObjectKeys: aCollection [
	self deprecated:''
	self explicitRequirement
]
