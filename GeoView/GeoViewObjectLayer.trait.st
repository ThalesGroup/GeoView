Trait {
	#name : #GeoViewObjectLayer,
	#instVars : [
		'processDataChangedBlock'
	],
	#category : #'GeoView-View & Layer'
}

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

{ #category : #'process data' }
GeoViewObjectLayer >> removeProcessDataFor: aGeoObjectClass [
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

{ #category : #private }
GeoViewObjectLayer >> whenProcessDatasChangedDo: aBlock [

	processDataChangedBlock := aBlock
]
