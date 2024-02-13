"
I am trait for geoplot view
"
Trait {
	#name : #TGeoView,
	#instVars : [
		'geoViewBounds'
	],
	#category : #'GeoView-View'
}

{ #category : #'API -- layers management' }
TGeoView >> addLayer: aLayer [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoView >> addObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoView >> addObjects: aGeoObjectList [
	self explicitRequirement
]

{ #category : #'API -- size' }
TGeoView >> getBounds [
	self explicitRequirement
]

{ #category : #'API -- layers management' }
TGeoView >> getLayer: aKey [
	self explicitRequirement
]

{ #category : #'API -- layers management' }
TGeoView >> getLayers [
	self explicitRequirement
]

{ #category : #'API -- layers management' }
TGeoView >> removeLayer: aLayer [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoView >> removeObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoView >> removeObjects: aGeoObjectList [
	self explicitRequirement
]

{ #category : #'API -- selection' }
TGeoView >> selectedObjectIndexes: aCollection [
	self explicitRequirement
]

{ #category : #'API -- drawing' }
TGeoView >> updateGraphicModel [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoView >> updateObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'API -- objects management' }
TGeoView >> updateObjects: aGeoObjectList [
	self explicitRequirement
]
