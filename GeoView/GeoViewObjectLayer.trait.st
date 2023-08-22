Trait {
	#name : #GeoViewObjectLayer,
	#category : #'GeoView-View & Layer'
}

{ #category : #'process data' }
GeoViewObjectLayer >> deleteProcessDataFor: aGeoObjectClass [
	self explicitRequirement
]

{ #category : #'process data' }
GeoViewObjectLayer >> getAllProcessData [
	self explicitRequirement
]

{ #category : #'process data' }
GeoViewObjectLayer >> getProcessDataFor: aGeoObjectClass [
	self explicitRequirement
]

{ #category : #testing }
GeoViewObjectLayer >> isGeoObjectLayer [
	^true
]

{ #category : #private }
GeoViewObjectLayer >> processDataChangedCallback: aCallbackBlock [
	self explicitRequirement
]

{ #category : #'process data' }
GeoViewObjectLayer >> setDefaultProcessData: aDataProcessor [
	self explicitRequirement
]

{ #category : #'process data' }
GeoViewObjectLayer >> setProcessData: aProcessData for: aGeoObjectClass [
	self explicitRequirement
	
]
