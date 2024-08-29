Trait {
	#name : #TGeoViewHaveMapProjection,
	#category : #'GeoView-Core'
}

{ #category : #'API -- map projection' }
TGeoViewHaveMapProjection >> mapProjection [
	"Return the map projection of the object: Mercator, etc."

	self explicitRequirement
]

{ #category : #'API -- map projection' }
TGeoViewHaveMapProjection >> mapProjection: aMapProjection [
	"Setup the map projection of the object: Mercator, etc."

	self explicitRequirement
]
