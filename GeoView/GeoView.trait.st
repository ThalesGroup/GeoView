"
I am trait for geoplot view
"
Trait {
	#name : #GeoView,
	#category : #'GeoView-View & Layer'
}

{ #category : #layers }
GeoView >> addLayer: aLayer [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
GeoView >> addObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
GeoView >> addObjects: aGeoObjectList [
	self explicitRequirement
]

{ #category : #layers }
GeoView >> getLayers [
	self explicitRequirement
]

{ #category : #accessing }
GeoView >> getViewSize [
	self explicitRequirement
]

{ #category : #layers }
GeoView >> removeLayer: aLayer [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
GeoView >> removeObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
GeoView >> removeObjects: aGeoObjectList [
	self explicitRequirement
]

{ #category : #selection }
GeoView >> selectedGeoObjectKeys: aCollection [
	self explicitRequirement
]

{ #category : #accessing }
GeoView >> setViewSize: aPoint [
	self explicitRequirement
]

{ #category : #private }
GeoView >> updateGraphicModel [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
GeoView >> updateObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
GeoView >> updateObjects: aGeoObjectList [
	self explicitRequirement
]
