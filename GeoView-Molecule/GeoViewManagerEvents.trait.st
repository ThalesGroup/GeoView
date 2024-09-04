"
I am geoplot manager events
"
Trait {
	#name : #GeoViewManagerEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #'GeoView-Molecule'
}

{ #category : #'events - layer' }
GeoViewManagerEvents >> geoViewLayerAdded: aKey in: aGeoViewManagerKey [
]

{ #category : #'events - layer' }
GeoViewManagerEvents >> geoViewLayerRemoved: aKey in: aGeoViewManagerKey [
]

{ #category : #'events - layer' }
GeoViewManagerEvents >> geoViewLayerUpdated: aKey in: aGeoViewManagerKey [
]

{ #category : #'events - map projection' }
GeoViewManagerEvents >> mapProjectionHasChanged: aMapProjection [
]
