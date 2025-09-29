"
Test suite with a simulation of a Bloc rendering task
"
Class {
	#name : #GeoViewElementTest,
	#superclass : #TestCase,
	#instVars : [
		'geoView',
		'spacePulseTask'
	],
	#category : #'GeoView-Tests-Core'
}

{ #category : #private }
GeoViewElementTest >> createGeoViewElement [

	geoView := GeoViewElement new
]

{ #category : #private }
GeoViewElementTest >> createRandomPositionGeoCircles: aQuantity color: aColor radius: aRadiusInMeters [

	| list random |
	list := OrderedCollection new.
	random := Random new.

	1 to: aQuantity do: [ :i |
		| object |
		object := GeoCircle new.
		object key: i.
		object fillStyle: aColor asSmockFillStyle.
		object absoluteCoordinates: AbsoluteCoordinates random.
		object radiusInMeters: aRadiusInMeters.
		list add: object ].

	^ list
]

{ #category : #private }
GeoViewElementTest >> createTask: aBlockClosure delay: aDelay [

	| serv index |
	index := (Random new next * 10000) rounded.
	serv := TKTParameterizableService new
		        step: aBlockClosure;
		        name: 'GeoView test task - ', index printString;
		        stepDelay: aDelay;
		        yourself.

	^ serv
]

{ #category : #private }
GeoViewElementTest >> geoViewSize [

	^ 1000 @ 1000
]

{ #category : #running }
GeoViewElementTest >> setUp [

	| container space |
	super setUp.
	self createGeoViewElement.
	geoView constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	container := BlElement new.
	container extent: self geoViewSize.
	container addChild: geoView.

	space := BlSpace new.
	space host: BlHeadlessHost new.
	space root addChild: container.
	container forceLayout.

	"simulation a rendering thread"
	spacePulseTask := self
		                  createTask: [ space pulse ]
		                  delay: 16.67 milliSeconds.
	spacePulseTask start
]

{ #category : #private }
GeoViewElementTest >> stimulateGeoCirclesIn: aList geoView: aGeoView fromIndex: anIndex [
	"at each step create / update and delete some GeoObjects"

	| random color radiusInM createList updateList removeList newIndex maxRadiusInM maxNbOfCircles unchangeList |
	createList := OrderedCollection new.
	updateList := OrderedCollection new.
	unchangeList := OrderedCollection new.
	removeList := OrderedCollection new.
	random := Random new.
	color := Color random.
	maxRadiusInM := 300000.
	maxNbOfCircles := 10000.
	radiusInM := random next * maxRadiusInM.
	newIndex := anIndex.

	aList do: [ :circle |
		| next |
		"first randomize update / deletion"
		next := random next.
		next <= 0.1
			ifTrue: [ "update the object"
				circle fillStyle: color asSmockFillStyle.
				circle radiusInMeters: radiusInM.
				updateList add: circle ]
			ifFalse: [
				next >= 0.9
					ifTrue: [ "remove the object" removeList add: circle ]
					ifFalse: [ "do nothing ;-)" unchangeList add: circle ] ] ].

	color := Color random.
	radiusInM := random next * maxRadiusInM.

	"create objects when removed, to have between one and 1000"
	(removeList isNotEmpty and: [ aList size < maxNbOfCircles ]) ifTrue:[
		(self createRandomPositionGeoCircles: ((random next * 100) asInteger) color: color radius: radiusInM) do:[ :e |
			newIndex := newIndex + 1.
			e key: newIndex.
			createList add: e.
		].
	].

	"update geoview"
	aGeoView updateObjects: updateList.
	aGeoView removeObjects: removeList.
	aGeoView addObjects: createList.

	aList removeAll.
	aList addAll: unchangeList;	addAll: updateList; addAll: createList.
		
	^ newIndex
]

{ #category : #running }
GeoViewElementTest >> tearDown [

	spacePulseTask stop.
	geoView := nil.
	super tearDown
]

{ #category : #tests }
GeoViewElementTest >> testAbsoluteCoordinatesFromGlobalPoint [

	| abs center |
	center := geoView extent / 2.
	abs := geoView absoluteCoordinatesFromGlobalPoint: center.
	self assert: abs latitudeInDegrees equals: 0.
	self assert: abs longitudeInDegrees equals: 0.

	geoView geoCenter: AbsoluteCoordinates frBrest.
	abs := geoView absoluteCoordinatesFromGlobalPoint: center.
	self
		assert: abs latitudeInDegrees rounded
		equals: AbsoluteCoordinates frBrest latitudeInDegrees rounded.
	self
		assert: abs longitudeInDegrees rounded
		equals: AbsoluteCoordinates frBrest longitudeInDegrees rounded
]

{ #category : #tests }
GeoViewElementTest >> testAbsoluteCoordinatesFromGlobalPoint2 [

	| abs |
	"Center should be zero"
	abs := geoView absoluteCoordinatesFromGlobalPoint: geoView extent / 2.
	self assert: abs latitudeInDegrees equals: 0.
	self assert: abs longitudeInDegrees equals: 0.

	"at the top left corner"
	abs := geoView absoluteCoordinatesFromGlobalPoint: 0 @ 0.
	self assert: abs latitudeInDegrees > 0.
	self assert: abs longitudeInDegrees < 0.

	"at the bottom right"
	abs := geoView absoluteCoordinatesFromGlobalPoint: geoView extent.
	self assert: abs latitudeInDegrees < 0.
	self assert: abs longitudeInDegrees > 0
]

{ #category : #tests }
GeoViewElementTest >> testCreateAndRemoveObjectOnHiddenLayer [
	
	| index list updateTask layer uiTask |
	self timeLimit: 10 seconds.
	
	layer := GeoViewUtils createGeoObjectsLayer: #layer.
	layer isVisible: false.
	geoView addLayer: layer.
	
	index := 5000.
	list := self createRandomPositionGeoCircles: index color: Color random radius: 100000.
	geoView addObjects: list.
	
	self assert: layer displayModel getDatas size equals: index.
	self assert: layer graphicModel getDatas size equals: index.
	self assert: layer dShapesWaitingToBeUpdated size equals: 0.
	
	"stimulate datas"
	updateTask := (self createTask: [ | newIndex |
		newIndex := self stimulateGeoCirclesIn: list geoView: geoView fromIndex: index.
		index := newIndex. 	
	] delay: 30 milliSeconds) start; yourself.

	"stimulate user interaction by updating the model"
	uiTask := (self createTask: [
		geoView updateModel: GeoViewProjectionChanges new.
	] delay: 5 milliSeconds) start; yourself.

	"waiting here to simulate user interaction a lot of time and stop tasks"
	4 seconds wait.
	updateTask kill.
	uiTask stop.
	spacePulseTask stop.
	2 seconds wait.
	
	self assert: layer dShapesWaitingToBeUpdated notEmpty.
	geoView removeObjects: list.
		
	"test to compare list model and graphic model"
	self assert: (layer displayModel getDatas size) equals: 0.
	self assert: (layer graphicModel getDatas size) equals: 0.
	self assert: layer dShapesWaitingToBeUpdated size equals: 0.
]

{ #category : #tests }
GeoViewElementTest >> testCreateUpdateRemoveObjects [
	"Create a lot of objects and stimulate them, control the state of the model"
	
	| index list updateTask layer uiTask |
	self timeLimit: 10 seconds.
	
	layer := GeoViewUtils createGeoObjectsLayer: #layer.
	geoView addLayer: layer.
	
	index := 5000.
	list := self createRandomPositionGeoCircles: index color: Color random radius: 100000.
	geoView addObjects: list.
	
	self assert: (layer displayModel getDatas size) equals: index.
	self assert: (layer graphicModel getDatas size) equals: index.
	self assert: layer dShapesWaitingToBeUpdated size equals: 0.
	
	"stimulate datas"
	updateTask := (self createTask: [ | newIndex |
		newIndex := self stimulateGeoCirclesIn: list geoView: geoView fromIndex: index.
		index := newIndex. 	
	] delay: 30 milliSeconds) start; yourself.

	"stimulate user interaction by updating the model"
	uiTask := (self createTask: [
		geoView updateModel: GeoViewProjectionChanges new.
	] delay: 5 milliSeconds) start; yourself.

	"waiting here to simulate user interaction a lot of time"
	4 seconds wait.
	updateTask stop.
	uiTask stop.
	spacePulseTask stop.
	2 seconds wait.
		
	"test to compare list model and graphic model"
	self assert: (layer displayModel getDatas size) equals: (list size).
	self assert: (layer graphicModel getDatas size) equals: (list size).
	self assert: layer dShapesWaitingToBeUpdated size equals: 0.
]

{ #category : #'tests - footnotes' }
GeoViewElementTest >> testFootnotes [

	self assert: geoView footnotes isNil.
	
	geoView footnotes: 'My footnotes'.
	self assert: geoView footnotes equals: 'My footnotes'.
	
	geoView footnotes: nil.
	self assert: geoView footnotes isNil.
]

{ #category : #tests }
GeoViewElementTest >> testInteractionsStrategy [

	self assert: geoView interactionsStrategy class equals: GeoViewInteractionsStrategy
]

{ #category : #tests }
GeoViewElementTest >> testLayerNeedToBeSorted [
	"Test when a added layer that need to be sorted is sorted"

	| layer |
	layer := GeoViewDShapesLayer new name: #test.
	layer needToSortDatas.
	
	geoView addLayer: layer.
	0.2 seconds wait.
	
	self deny: layer isNeedToSortDatas.
	
	layer needToSortDatas.
	0.2 seconds wait.
	
	self deny: layer isNeedToSortDatas.
]

{ #category : #tests }
GeoViewElementTest >> testNewInteractionsStrategy [

	self assert: geoView newInteractionsStrategy class equals: GeoViewInteractionsStrategy.
]

{ #category : #tests }
GeoViewElementTest >> testPickAtGeoOrigin [

	| result |
	result := geoView pickAt: (geoView globalPointFromAbsoluteCoordinates: AbsoluteCoordinates zero).	
	self assert: result class equals: GeoViewPickingResult.
	self assert: (result timestamp <= DateAndTime now).
	self assert: result globalPoint equals: (self geoViewSize / 2).
	self assert: result localPoint equals: (geoView localPointFromGlobalPoint: (self geoViewSize / 2)).
	self assert: result absoluteCoordinates equals: (geoView absoluteCoordinatesFromGlobalPoint: (self geoViewSize / 2)).
	self assert: (result cartesianCoordinates xInMeters closeTo: 0 precision: 1e-8).
	self assert: (result cartesianCoordinates yInMeters closeTo: 0 precision: 1e-8).
	self assert: result radiusInPixels equals: 0.
	
	self assert: result isEmpty.
]

{ #category : #tests }
GeoViewElementTest >> testRemoveInteractionsStrategy [

	geoView removeInteractionsStrategy.
	self assert: geoView interactionsStrategy isNil
]

{ #category : #tests }
GeoViewElementTest >> testSetInteractionsStrategy [

	geoView setInteractionsStrategy: nil.
	self assert: geoView interactionsStrategy isNil
]
