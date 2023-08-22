Class {
	#name : #DCompositeShapeBlocProcessData,
	#superclass : #DShapeBlocProcessData,
	#category : #'GeoView-Bloc-DShape-ProcessData'
}

{ #category : #private }
DCompositeShapeBlocProcessData >> createAndAddChildFromDShape: aDShape in: aBlElement [
	"cannot add no keyed dShape"
	| processData blChild |
	aDShape key ifNotNil:[
		processData := self processor getProcessDataFor: aDShape class.
		self processor isRecyclingActive ifTrue:[
			blChild := self processor destockRecycledDataFor: aDShape class.
		].
		blChild := processData processCreatedData: aDShape key incoming: aDShape with: blChild context: nil.
		blChild ifNotNil:[
			aBlElement addChild: blChild as: (aDShape key asString).
		].
	].
]

{ #category : #private }
DCompositeShapeBlocProcessData >> deleteChild: aBlChild fromDShape: aDShape in: aBlElement [
	"cannot remove no keyed dShape"
	| processData blChild |
	aDShape key ifNotNil:[
		processData := self processor getProcessDataFor: aDShape class.
		blChild := processData processDeletedData: aDShape key incoming: aDShape with: aBlChild context: nil.
		blChild ifNotNil:[
			aBlElement removeChildNamed: (aDShape key asString).
			self processor isRecyclingActive ifTrue:[self processor stockRecycledData: blChild for: aDShape class].
		].
	].
]

{ #category : #processing }
DCompositeShapeBlocProcessData >> processCreatedData: aKey incoming: aDCompositeShape with: aBlElement context: aContext [
	| blCompositeShape |

	blCompositeShape := aBlElement ifNil:[BlElement new 	].
	blCompositeShape relocate: 0@0.

	super processCreatedData: aKey incoming: aDCompositeShape with: blCompositeShape context: aContext.
	
	aDCompositeShape dShapeList do:[ :dShape |
		dShape coordinates: aDCompositeShape coordinates.
		self createAndAddChildFromDShape: dShape in: blCompositeShape.
	].
	^blCompositeShape 
]

{ #category : #processing }
DCompositeShapeBlocProcessData >> processUpdatedData: aKey incoming: aDCompositeShape with: aBlElement context: aContext [

	super processUpdatedData: aKey incoming: aDCompositeShape with: aBlElement context: aContext.

	aBlElement relocate: 0@0.
	aBlElement size: aBlElement parent size.
	
	"new children was added"
	aDCompositeShape dShapeList size > aBlElement children size ifTrue:[
		aDCompositeShape dShapeList do:[ :dShape | | blChild |
			"cannot manage no keyed dShape"
			dShape key ifNotNil:[
				blChild := aBlElement childNamed: dShape key.
				blChild ifNil:[
					"add the new dShape"
					self createAndAddChildFromDShape: dShape in: aBlElement.
				].
			].
		].
	].

	"check for updated children"
	aDCompositeShape toUpdateDShapeList do:[ :dShape | | processData blChild |
		"cannot manage no keyed dShape"
		dShape key ifNotNil:[
			blChild := aBlElement childNamed: (dShape key asString).
			blChild ifNotNil:[
				processData := self processor getProcessDataFor: dShape class.
				dShape coordinates: aDCompositeShape coordinates.
				processData processUpdatedData: dShape key incoming: dShape with: blChild context: nil.
			].
		].
	].

	aDCompositeShape clearToUpdateDShapeList.
	"check for deleted children"
	aDCompositeShape toDeleteDShapeList do:[ :dShape | | blChild |
		"cannot manage no keyed dShape"
		dShape key ifNotNil:[
			blChild := aBlElement childNamed: (dShape key asString).
			blChild ifNil:[
				"add the new dShape"
				self deleteChild: blChild fromDShape: dShape in: aBlElement.
			].
		].
	].

	aDCompositeShape clearToDeleteDShapeList.

	self flag:'PLA : déplacer ce code dans un pipeline de mise à jour graphique au changement de projection et pas sur maj des objets'.
	aDCompositeShape hasUserDrawModeDShape ifTrue:[
		aDCompositeShape dShapeList do:[ :dShape | | processData blChild |
			"cannot manage no keyed dShape"
			dShape key ifNotNil:[ 
				blChild := aBlElement childNamed: (dShape key asString).
				blChild ifNotNil:[
					processData := self processor getProcessDataFor: dShape class.
					dShape coordinates: aDCompositeShape coordinates.
					processData processUpdatedData: dShape key incoming: dShape with: blChild context: nil.
				].
			].			
		].	
	].

	^aBlElement
]
