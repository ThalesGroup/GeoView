Class {
	#name : #GeoViewNASABlueMarbleTilesProviderTest,
	#superclass : #GeoViewTilesProviderTest,
	#category : #'GeoView-Tests-Map'
}

{ #category : #tests }
GeoViewNASABlueMarbleTilesProviderTest >> testDefaultCopyrightNote [

	self assert: provider defaultCopyrightNote notNil
]

{ #category : #tests }
GeoViewNASABlueMarbleTilesProviderTest >> testHaveCopyrightNote [

	self assert: provider haveCopyrightNote 
]

{ #category : #initialization }
GeoViewNASABlueMarbleTilesProviderTest >> tilesProviderClass [

	^ GeoViewNASABlueMarbleTilesProvider
]
