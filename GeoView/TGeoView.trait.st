"
I am trait for geoplot view
"
Trait {
	#name : #TGeoView,
	#instVars : [
		'geoViewBounds'
	],
	#category : #'GeoView-View & Layer'
}

{ #category : #'API -- layers management' }
TGeoView >> addLayer: aLayer [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
TGeoView >> addObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
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

{ #category : #accessing }
TGeoView >> getViewSize [
	self explicitRequirement
]

{ #category : #'API -- layers management' }
TGeoView >> removeLayer: aLayer [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
TGeoView >> removeObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
TGeoView >> removeObjects: aGeoObjectList [
	self explicitRequirement
]

{ #category : #selection }
TGeoView >> selectedGeoObjectKeys: aCollection [
	self explicitRequirement
]

{ #category : #'API -- size' }
TGeoView >> setBoundsFrom: aFromPoint to: aToPoint [

	| newBounds |
	newBounds := aFromPoint extent: aToPoint.
	newBounds = geoViewBounds ifTrue:[ ^ self ].
	
	geoViewBounds := newBounds.
	"TODO : self updateProjection"

	self updateGraphicModel
]

{ #category : #accessing }
TGeoView >> setViewSize: aPoint [
	self explicitRequirement
]

{ #category : #'API -- drawing' }
TGeoView >> updateGraphicModel [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
TGeoView >> updateObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
TGeoView >> updateObjects: aGeoObjectList [
	self explicitRequirement
]
