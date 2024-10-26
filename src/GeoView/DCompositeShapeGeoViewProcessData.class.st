Class {
	#name : #DCompositeShapeGeoViewProcessData,
	#superclass : #DShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #processing }
DCompositeShapeGeoViewProcessData >> createAndAddGChildFrom: aDShape inGComposite: aGComposite2D [

	| processData gShape2D |
	
	"Not add no keyed dShape"
	aDShape key ifNil:[ ^ self ].
	self processor ifNil:[ ^ self ].
	
	processData := (self processor getProcessDataFor: aDShape) ifNil:[ ^ self ].
	self processor isRecyclingActive ifTrue:[
		gShape2D := self processor destockRecycledDataFor: aDShape class.
	].

	gShape2D := processData processCreatedData: aDShape key incoming: aDShape with: gShape2D context: nil.
	gShape2D ifNotNil:[
		aGComposite2D addChild: gShape2D.
	].
	
]

{ #category : #processing }
DCompositeShapeGeoViewProcessData >> processCreatedData: aKey incoming: aDComposite with: aGComposite2D context: aContext [

	| gComposite2D |
	gComposite2D := aGComposite2D 
		ifNil: [ SmockGCompositeShape2D id: aKey ] 
		ifNotNil:[ :e | e removeChildren ].
	
	super processCreatedData: aKey incoming: aDComposite with: gComposite2D context: aContext.
	
	"Sort the list before create GShape to manage zOrder"
	aDComposite sortChildrenBy: [ :a :b | a zIndex < b zIndex ]. 
	
	aDComposite dShapeList do:[ :dShape |
		self createAndAddGChildFrom: dShape inGComposite: gComposite2D.
	].

	^ self processUpdatedData: aKey incoming: aDComposite with: gComposite2D context: aContext
]

{ #category : #processing }
DCompositeShapeGeoViewProcessData >> processUpdatedData: aKey incoming: aDComposite with: aGComposite2D context: aContext [

	super processUpdatedData: aKey incoming: aDComposite with: aGComposite2D context: aContext.
	
	self flag:'laborde: same principle between others view, factorize + tests'.
	
	"new children was added"
	aDComposite numberOfChildren > aGComposite2D numberOfChildren ifTrue:[
		
		"Sort the list before create GShape to manage zOrder"
		aDComposite sortChildrenBy: [ :a :b | a zIndex < b zIndex ]. 
		
		aDComposite dShapeList do:[ :dShape | | gChild |
			"cannot manage no keyed dShape"
			dShape key ifNotNil:[
				gChild := aGComposite2D getChild: dShape key.
				gChild ifNil:[ self createAndAddGChildFrom: dShape inGComposite: aGComposite2D ].
			].
		].
	].
	
	aDComposite hasDirtyChildren ifTrue:[ 

		"Sort the list before updated GShape to manage zOrder"
		aDComposite sortChildrenBy: [ :a :b | a zIndex < b zIndex ].

		"check for updated children"
		aDComposite toUpdateDShapeList do:[ :dShape | | processData gChild |
			"cannot manage no keyed dShape"
			dShape key ifNotNil:[
				gChild := aGComposite2D getChild: dShape key.
				gChild ifNotNil:[
					processData := self processor getProcessDataFor: dShape.
					processData processUpdatedData: dShape key incoming: dShape with: gChild context: aContext.
				].
			].
		].
	
		"check for remove children"
		aDComposite toDeleteDShapeList do:[ :dShape | | gChild |
			"cannot manage no keyed dShape"
			dShape key ifNotNil:[
				gChild := aGComposite2D getChild: dShape key.
				gChild ifNil:[
					"add the new dShape"
					self removeGChild: gChild createdFrom: dShape offGComposite: aGComposite2D.
				].
			].
		].
	
		aDComposite clearChangedDShapeLists.
		aDComposite updateModelWithChildren.
	].
	
	self flag:'labordep : déplacer ce code dans un pipeline de mise à jour graphique au changement de projection et pas sur maj des objets'.
	aDComposite hasDrawModeUserChildren ifTrue:[
		aDComposite dShapeList do:[ :dShape | | processData blChild |
			"cannot manage no keyed dShape"
			dShape key ifNotNil:[ 
				blChild := aGComposite2D getChild: dShape key.
				blChild ifNotNil:[
					processData := self processor getProcessDataFor: dShape.
					processData processUpdatedData: dShape key incoming: dShape with: blChild context: nil.
				].
			].			
		].	
	].
	
	^ aGComposite2D 
]

{ #category : #processing }
DCompositeShapeGeoViewProcessData >> removeGChild: aGShape2D createdFrom: aDShape offGComposite: aGComposite2D [

	| processData gChild |

	"Not remove no keyed dShape"
	aDShape key ifNil:[ ^ self ].

	processData := self processor getProcessDataFor: aDShape.
	gChild := processData processDeletedData: aDShape key incoming: aDShape with: aGShape2D context: nil.
	gChild ifNotNil:[
		aGComposite2D removeChild: aDShape key.
		self processor isRecyclingActive ifTrue:[self processor stockRecycledData: gChild for: aDShape class].
	].
]
