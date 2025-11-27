Class {
	#name : #DCompositeShapeGeoViewProcessDataTest,
	#superclass : #DShapeGeoViewProcessDataTest,
	#category : #'GeoView-Tests-ProcessDatas'
}

{ #category : #asserting }
DCompositeShapeGeoViewProcessDataTest >> assertCreatedGShape: aGShape forDShape: aDShape iteration: aNumber [

	super assertCreatedGShape: aGShape forDShape: aDShape iteration: aNumber.
	
	self assert: aGShape isComposite.
]

{ #category : #asserting }
DCompositeShapeGeoViewProcessDataTest >> assertDeletedGShape: aGShape forDShape: aDShape iteration: aNumber [

	super assertDeletedGShape: aGShape forDShape: aDShape iteration: aNumber.
	
	self assert: aGShape isComposite.
	aNumber = 1 ifTrue:[self assert: aGShape isEmpty].
	aNumber = 2 ifTrue:[self assert: aGShape isNotEmpty].
]

{ #category : #asserting }
DCompositeShapeGeoViewProcessDataTest >> assertRecycledGShape: aGShape forDShape: aDShape iteration: aNumber [

	super assertRecycledGShape: aGShape forDShape: aDShape iteration: aNumber.
	
	self assert: aGShape isComposite.
	self assert: aGShape isEmpty.
]

{ #category : #asserting }
DCompositeShapeGeoViewProcessDataTest >> assertUpdatedGShape: aGShape forDShape: aDShape iteration: aNumber [

	super assertUpdatedGShape: aGShape forDShape: aDShape iteration: aNumber.
	
	self assert: aGShape isComposite.
]

{ #category : #running }
DCompositeShapeGeoViewProcessDataTest >> createDShapes [

	^ { "first composite without children"
		  SmockDCompositeShape new.
		
		"second with three children"
		  (SmockDCompositeShape new addChildren: {
				   (SmockDText new key: #text1).
				   (SmockDText new key: #text2).
				   (SmockDText new key: #text3) }) 
		}
]

{ #category : #running }
DCompositeShapeGeoViewProcessDataTest >> processDataClass [ 

	^ DCompositeShapeGeoViewProcessData 
]

{ #category : #running }
DCompositeShapeGeoViewProcessDataTest >> setUpProcessData [ 

	super setUpProcessData.
	processData processor setProcessData: DTextGeoViewProcessData new forClass: SmockDText.
]
