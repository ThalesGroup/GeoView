"
I am Geoplot layer.
"
Trait {
	#name : #GeoViewLayer,
	#category : #'GeoView-View & Layer'
}

{ #category : #testing }
GeoViewLayer >> isGeoObjectLayer [
	^false
]

{ #category : #testing }
GeoViewLayer >> isSelectionLayer [
	^false
]

{ #category : #accessing }
GeoViewLayer >> layerName [
	self explicitRequirement
]

{ #category : #testing }
GeoViewLayer >> mapProjection: aProjection [
	self explicitRequirement
]

{ #category : #testing }
GeoViewLayer >> symbologyProvider: aSymbologyProvider [
	self explicitRequirement
]

{ #category : #private }
GeoViewLayer >> updateModelToView [
	self explicitRequirement
]
