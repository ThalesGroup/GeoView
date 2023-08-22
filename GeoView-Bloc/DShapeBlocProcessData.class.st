Class {
	#name : #DShapeBlocProcessData,
	#superclass : #GeoProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #processing }
DShapeBlocProcessData >> processCreatedData: aKey incoming: aDShape with: aBlElement context: aContext [

	(aBlElement isNil or:[aDShape isNil]) ifTrue:[^nil].
	aBlElement id: (aKey asString).
	aBlElement visibility: (aDShape isVisible ifTrue:[BlVisibility visible] ifFalse:[BlVisibility hidden]).

	^aBlElement
]

{ #category : #processing }
DShapeBlocProcessData >> processDeletedData: aKey incoming: aDShape with: aBlElement context: aContext [
	
	^aBlElement
]

{ #category : #processing }
DShapeBlocProcessData >> processUpdatedData: aKey incoming: aDShape with: aBlElement context: aContext [

	(aBlElement isNil or:[aDShape isNil]) ifTrue:[^nil].
	aBlElement visibility: (aDShape isVisible ifTrue:[BlVisibility visible] ifFalse:[BlVisibility hidden]).

	^aBlElement
]
