"
I am trait for geoplot view
"
Trait {
	#name : #TGeoViewWidget,
	#instVars : [
		'geoViewBounds'
	],
	#traits : 'TGeoViewHandleObjects + TGeoViewHaveMapProjection',
	#classTraits : 'TGeoViewHandleObjects classTrait + TGeoViewHaveMapProjection classTrait',
	#category : #'GeoView-Core'
}

{ #category : #'API -- layers management' }
TGeoViewWidget >> addLayer: aLayer [
	self explicitRequirement
]

{ #category : #'API -- size' }
TGeoViewWidget >> getBounds [
	self explicitRequirement
]

{ #category : #'API -- layers management' }
TGeoViewWidget >> getLayer: aKey [
	self explicitRequirement
]

{ #category : #'API -- layers management' }
TGeoViewWidget >> getLayers [
	self explicitRequirement
]

{ #category : #'API -- layers management' }
TGeoViewWidget >> removeLayer: aLayer [
	self explicitRequirement
]

{ #category : #'API -- drawing' }
TGeoViewWidget >> requestRepaint [
	self explicitRequirement
]

{ #category : #'API -- selection' }
TGeoViewWidget >> selectedObjectIndexes: aCollection [
	self explicitRequirement
]

{ #category : #'API -- drawing' }
TGeoViewWidget >> updateGraphicModel [
	self explicitRequirement
]
