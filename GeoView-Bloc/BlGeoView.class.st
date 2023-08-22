"
I am the Geoplot Bloc view.
"
Class {
	#name : #BlGeoView,
	#superclass : #BlElement,
	#traits : 'GeoView',
	#classTraits : 'GeoView classTrait',
	#instVars : [
		'displayToGraphicProjection',
		'layers',
		'selectedGeoObjectKeys'
	],
	#category : #'GeoView-Bloc-Core-Impl'
}

{ #category : #'geobjects aur' }
BlGeoView >> addGeoObject: aGeoObject [
	self getLayers do:[ :l | l isGeoObjectLayer ifTrue:[l addGeoObject: aGeoObject ]].
]

{ #category : #'geobjects aur' }
BlGeoView >> addGeoObjects: aGeoObjectList [
	self getLayers do:[ :l | l isGeoObjectLayer ifTrue:[l addGeoObjects: aGeoObjectList ]].
]

{ #category : #layers }
BlGeoView >> addLayer: aLayer [
	self assert: [ aLayer isNotNil ] description: [ '[GeoplotView] Layer cannot be nil'. ^nil ].
	aLayer graphicProjectionModel projection: self displayToGraphicProjection.
	self addChild: aLayer.
	
	"Store layer"
	layers add: aLayer.
	
	^aLayer
]

{ #category : #layers }
BlGeoView >> deleteLayer: aLayer [
	self assert: [ aLayer isNotNil ] description: [ '[GeoplotView] Layer cannot be nil'. ^nil ].
	self removeChild: aLayer.
	self flag:'PLA : nettoyer proprement'.
	aLayer graphicProjectionModel projection: nil.
	aLayer graphicProjectionModel: nil.
	
	"Unstore layer"
	layers remove: aLayer.
	
	^aLayer
]

{ #category : #'view projection' }
BlGeoView >> displayToGraphicProjection [
	^ displayToGraphicProjection
]

{ #category : #'view projection' }
BlGeoView >> displayToGraphicProjection: aDisplayToGraphicProjection [
	displayToGraphicProjection := aDisplayToGraphicProjection
]

{ #category : #layers }
BlGeoView >> getLayers [
	"Return all BlElement corresponding to a GeoViewLayer"
	^ layers copy
]

{ #category : #size }
BlGeoView >> getViewSize [
	^ self extent
]

{ #category : #initialization }
BlGeoView >> initialize [
	super initialize.
	layers := OrderedCollection new.
	self initializeDisplayToGraphicProjection.

]

{ #category : #'view projection' }
BlGeoView >> initializeDisplayToGraphicProjection [
	self displayToGraphicProjection: GeoView2DProjection new
]

{ #category : #'geobjects aur' }
BlGeoView >> removeGeoObject: aGeoObject [
	self getLayers do:[ :l | l isGeoObjectLayer ifTrue:[l removeGeoObject: aGeoObject ]].
]

{ #category : #'geobjects aur' }
BlGeoView >> removeGeoObjects: aGeoObjectList [
	self getLayers do:[ :l | l isGeoObjectLayer ifTrue:[l removeGeoObjects: aGeoObjectList ]].
]

{ #category : #selection }
BlGeoView >> selectedGeoObjectDShapeDictionary [
	| dictionary |
	dictionary := Dictionary new.
	self getLayers do:[ :layer |
		layer isSelectionLayer ifFalse:[
			layer displayProjectionModel datas keysAndValuesDo: [ :geoObjectKey :dShape |
				(selectedGeoObjectKeys includes: geoObjectKey) ifTrue:[ dictionary at: geoObjectKey put: dShape ].
			].
		].
	].
	^dictionary
]

{ #category : #selection }
BlGeoView >> selectedGeoObjectKeys: aCollection [
	| dictionary |
	selectedGeoObjectKeys := aCollection. 
	dictionary := self selectedGeoObjectDShapeDictionary.
	
	"Send the dictionary to all selection layers"
	self getLayers	do:[ :layer |
		layer isSelectionLayer ifTrue:[ layer selectedDShapes: dictionary ].		 
	].
]

{ #category : #size }
BlGeoView >> setViewSize: aPoint [
	"call super method, because Bloc already manage a resize"
	super size: aPoint.

	"update all layers size"
	self getLayers do: [ :l | l size: aPoint ].
	"configure view projection"
	self displayToGraphicProjection offsetInPIxels: aPoint / 2.
	self displayToGraphicProjection updateResolution: aPoint.
	
	self updateModelToView.
]

{ #category : #size }
BlGeoView >> size: anExtent [
	"size configuration from Bloc (i.e. a Layout strategy), redirect to setViewSize:"
	self setViewSize: anExtent
]

{ #category : #'geobjects aur' }
BlGeoView >> updateGeoObject: aGeoObject [
	self getLayers do:[ :l | l isGeoObjectLayer ifTrue:[l updateGeoObject: aGeoObject ]].
	self flag:'PLA : provisoire traitement par lot ci-dessous'.
	self updateSelectedGeoObjectKeys.
]

{ #category : #'geobjects aur' }
BlGeoView >> updateGeoObjects: aGeoObjectList [
	self getLayers do:[ :l | l isGeoObjectLayer ifTrue:[l updateGeoObjects: aGeoObjectList ]].
	self updateSelectedGeoObjectKeys.
]

{ #category : #private }
BlGeoView >> updateModelToView [
	"Update the view with the Display model"
	self getLayers do: [ :l | l updateModelToView ].
]

{ #category : #selection }
BlGeoView >> updateSelectedGeoObjectKeys [
	| dictionary |
	self flag:'PLA : pas top ici car il faudrait juste mettre a jour les objets qui ont bougés, donc partir de geoObjectUpdated:'.
	(selectedGeoObjectKeys isNil or:[selectedGeoObjectKeys isEmpty]) ifTrue:[^self].
	
	dictionary := self selectedGeoObjectDShapeDictionary.
	
	"Send the dictionary to all selection layers"
	self getLayers	do:[ :layer |
		layer isSelectionLayer ifTrue:[ layer updateSelectedDShapes: dictionary ].		 
	].
]
