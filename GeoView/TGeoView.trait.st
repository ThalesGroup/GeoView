"
I am trait for geoplot view
"
Trait {
	#name : #TGeoView,
	#instVars : [
		'geoViewBounds'
	],
	#traits : 'TGeoViewHandleObjects',
	#classTraits : 'TGeoViewHandleObjects classTrait',
	#category : #'GeoView-View'
}

{ #category : #'API -- layers management' }
TGeoView >> addLayer: aLayer [
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

{ #category : #'API -- drawing' }
TGeoView >> requestRepaint [
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
