Class {
	#name : #GeoViewOpenSeaMapSeamarkTilesProvider,
	#superclass : #GeoViewTilesProviderTMS,
	#category : #'GeoView-Map'
}

{ #category : #infos }
GeoViewOpenSeaMapSeamarkTilesProvider class >> attributionText [

	^ '© OpenSeaMap contributors'
]

{ #category : #cache }
GeoViewOpenSeaMapSeamarkTilesProvider class >> defaultSharedCacheKey [

	^ 'OpenSeaMap Seamark'
]

{ #category : #constants }
GeoViewOpenSeaMapSeamarkTilesProvider class >> primaryTileUrl [

	^ 'https://t1.openseamap.org/seamark'
]

{ #category : #initialization }
GeoViewOpenSeaMapSeamarkTilesProvider >> initialize [

	super initialize.
	self haveCopyrightNote: true. 
	self defaultCopyrightNote: self class attributionText.
	self updateUrl
]

{ #category : #update }
GeoViewOpenSeaMapSeamarkTilesProvider >> updateUrl [

	self service url: self serverUrl, '/{z}/{x}/{y}.png'
]
