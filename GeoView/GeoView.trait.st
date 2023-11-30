"
I am trait for geoplot view
"
Trait {
	#name : #GeoView,
	#category : #'GeoView-View & Layer'
}

{ #category : #'geobjects aur' }
GeoView >> addGeoObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
GeoView >> addGeoObjects: aGeoObjectList [
	self explicitRequirement
]

{ #category : #layers }
GeoView >> addLayer: aLayer [
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

{ #category : #'geobjects aur' }
GeoView >> removeGeoObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
GeoView >> removeGeoObjects: aGeoObjectList [
	self explicitRequirement
]

{ #category : #layers }
GeoView >> removeLayer: aLayer [
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

{ #category : #'geobjects aur' }
GeoView >> updateGeoObject: aGeoObject [
	self explicitRequirement
]

{ #category : #'geobjects aur' }
GeoView >> updateGeoObjects: aGeoObjectList [
	self explicitRequirement
]

{ #category : #private }
GeoView >> updateModelToView [
	self explicitRequirement
]
