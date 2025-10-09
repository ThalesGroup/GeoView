"
A GeoViewTilesProviderTest is a test class for testing the behavior of GeoViewTilesProvider
"
Class {
	#name : #GeoViewTilesProviderTest,
	#superclass : #TestCase,
	#instVars : [
		'provider'
	],
	#category : #'GeoView-Tests-Map'
}

{ #category : #testing }
GeoViewTilesProviderTest class >> isAbstract [ 

	^ self == GeoViewTilesProviderTest
]

{ #category : #running }
GeoViewTilesProviderTest >> setUp [

	super setUp.
	provider := self tilesProvider
]

{ #category : #tests }
GeoViewTilesProviderTest >> testDefaultCopyrightNote [

	self assert: provider defaultCopyrightNote isNil 
]

{ #category : #tests }
GeoViewTilesProviderTest >> testHaveCopyrightNote [

	self deny: provider haveCopyrightNote 
]

{ #category : #initialization }
GeoViewTilesProviderTest >> tilesProvider [

	self subclassResponsibility 
]
