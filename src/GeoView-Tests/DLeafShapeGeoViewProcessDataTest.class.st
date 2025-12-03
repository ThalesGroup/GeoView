Class {
	#name : #DLeafShapeGeoViewProcessDataTest,
	#superclass : #DShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #testing }
DLeafShapeGeoViewProcessDataTest class >> isAbstract [ 

	^ self == DLeafShapeGeoViewProcessDataTest
]

{ #category : #asserting }
DLeafShapeGeoViewProcessDataTest >> assertCreatedGShape: aGShape forDShape: aDShape iteration: aNumber [

	super assertCreatedGShape: aGShape forDShape: aDShape iteration: aNumber.
	
	self assert: aGShape isLeaf.
]

{ #category : #asserting }
DLeafShapeGeoViewProcessDataTest >> assertDeletedGShape: aGShape forDShape: aDShape iteration: aNumber [

	super assertDeletedGShape: aGShape forDShape: aDShape iteration: aNumber.
	
	self assert: aGShape isLeaf.
]

{ #category : #asserting }
DLeafShapeGeoViewProcessDataTest >> assertRecycledGShape: aGShape forDShape: aDShape iteration: aNumber [

	super assertRecycledGShape: aGShape forDShape: aDShape iteration: aNumber.
	
	self assert: aGShape isLeaf.
]

{ #category : #asserting }
DLeafShapeGeoViewProcessDataTest >> assertUpdatedGShape: aGShape forDShape: aDShape iteration: aNumber [

	super assertUpdatedGShape: aGShape forDShape: aDShape iteration: aNumber.
	
	self assert: aGShape isLeaf.
]
