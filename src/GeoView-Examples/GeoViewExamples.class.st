Class {
	#name : #GeoViewExamples,
	#superclass : #Object,
	#category : #'GeoView-Examples'
}

{ #category : #private }
GeoViewExamples class >> createAndStartTask: aBlockClosure [

	^ (self createTask: aBlockClosure)
		  start;
		  yourself
]

{ #category : #private }
GeoViewExamples class >> createGeoCircles: aQuantity [

	| list random nb |
	list := OrderedCollection new.
	random := Random new.
	nb := aQuantity.
	
	1 to: nb do:[ :i | | object |
		object := GeoCircle new.
		object key: i.
		object fillStyle: (Color random asSmockFillStyle).
		object strokeStyle: (Color random asSmockStrokeStyle).
		object absoluteCoordinates: AbsoluteCoordinates random.
		object radiusInMeters: (random next * 100000).
		list add: object.
	].

	^ list
]

{ #category : #private }
GeoViewExamples class >> createGeoEllipses: aQuantity [

	| list random nb |
	list := OrderedCollection new.
	random := Random new.
	nb := aQuantity.
	
	1 to: nb do:[ :i | | object |
		object := GeoEllipse new.
		object key: i.
		object fillStyle: (Color random asSmockFillStyle).
		object strokeStyle: (Color random asSmockStrokeStyle).
		object absoluteCoordinates: AbsoluteCoordinates random.
		object radiusInMeters1: (random next * 100000).
		object radiusInMeters2: (random next * 100000).
		object orientationInAzimuths: ((random next * 360) \\ 360).
		list add: object.
	].

	^ list
]

{ #category : #private }
GeoViewExamples class >> createGeoObjects [

	^ self createGeoCircles: 1000
]

{ #category : #private }
GeoViewExamples class >> createRandomPositionGeoCircles: aQuantity color: aColor radius: aRadiusInMeters [

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
GeoViewExamples class >> createTask: aBlockClosure [

	| serv index |
	index := (Random new next * 10000) rounded.
	serv := TKTParameterizableService new
		        step: aBlockClosure;
		        name: 'GeoView examples task - ', index printString;
		        stepDelay: 1 second;
		        yourself.

	^ serv
]

{ #category : #'examples - GeoObjects' }
GeoViewExamples class >> exampleGeoCircle [

	| element circle |
	element := GeoViewUtils createGeoViewForGeoObjects.

	"create sample datas"
	circle := (GeoCircle key: 1)
		          radiusInMeters: 1000000;
		          strokeStyle: Color white asSmockStrokeStyle;
		          absoluteCoordinates: AbsoluteCoordinates zero.
	element addObject: circle.

	^ self openViewInWindow: element
]

{ #category : #'examples - GeoObjects' }
GeoViewExamples class >> exampleGeoCircles [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent a static (no updates) geographical view with a lot of data."
	
	| element objects |
	element := GeoViewUtils createGeoViewForGeoObjects.
	
	"create sample datas"
	objects := self createGeoCircles: 1000.
	element addObjects: objects.

	"Example of event handler behavior on geoView domain event"
	element addEventHandlerOn: GeoViewCursorCoordinatesChangedEvent do: [ :event |
		event absoluteCoordinates printString traceCr.
	].

	"Example of custom EventHandler, here a logger"
	element addEventHandler: (GeoViewEventLogger new).

	^ self openViewInWindow: element
]

{ #category : #'examples - GeoObjects' }
GeoViewExamples class >> exampleGeoCirclesAddedOneByOne [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent a static (no updates) geographical view with a lot of data."
	
	| element objects |
	element := GeoViewUtils createGeoViewForGeoObjects.
	
	"create sample datas one by one (not optimal but usefull for testing performances)"
	objects := self createGeoCircles: 1000.
	objects do: [ :e | element addObject: e ].

	"Example of event handler behavior on geoView domain event"
	element addEventHandlerOn: GeoViewCursorCoordinatesChangedEvent do: [ :event |
		event absoluteCoordinates printString traceCr.
	].

	"Example of custom EventHandler, here a logger"
	element addEventHandler: (GeoViewEventLogger new).

	^ self openViewInWindow: element
]

{ #category : #'examples - GeoObjects' }
GeoViewExamples class >> exampleGeoEllipse [

	| element ellipse |
	element := GeoViewUtils createGeoViewForGeoObjects.

	"create sample datas"
	ellipse := (GeoEllipse key: 1)
		          radiusInMeters1: 2000000;
		          radiusInMeters2: 1000000;
					 orientationInAzimuths: 45;
		          strokeStyle: Color white asSmockStrokeStyle;
		          absoluteCoordinates: AbsoluteCoordinates zero.
	element addObject: ellipse.

	^ self openViewInWindow: element
]

{ #category : #'examples - GeoObjects' }
GeoViewExamples class >> exampleGeoEllipses [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent a static (no updates) geographical view with a lot of data."
	
	| element objects |
	element := GeoViewUtils createGeoViewForGeoObjects.
	
	"create sample datas"
	objects := self createGeoEllipses: 1000.
	element addObjects: objects.

	^ self openViewInWindow: element
]

{ #category : #'examples - GeoObjects' }
GeoViewExamples class >> exampleGeoPositions [
	
	| geoView city |
	geoView := GeoViewUtils createGeoViewForGeoObjects.
	geoView addLayerAtFirst: (GeoViewMapTilesLayer newWithGoogle).
	geoView id: #geoView.
	
	city := GeoPosition key: 1.
	city text: 'Brest'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frBrest).
	geoView addObject: city.
	
	city := GeoPosition key: 2.
	city text: 'Nevers'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frNevers).
	geoView addObject: city.

	city := GeoPosition key: 3.
	city text: 'Bordeaux'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frBordeaux).
	geoView addObject: city.
	
	city := GeoPosition key: 4.
	city text: 'Marseille'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frMarseille).
	geoView addObject: city.
	
	city := GeoPosition key: 5.
	city text: 'Lyon'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frLyon).
	geoView addObject: city.
	
	city := GeoPosition key: 6.
	city text: 'Saint Renan'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frStRenan).
	geoView addObject: city.
	
	city := GeoPosition key: 7.
	city text: 'Paris'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frParis).
	geoView addObject: city.
	
	city := GeoPosition key: 8.
	city text: 'Elancourt'; image: (self iconNamed: #pharo); absoluteCoordinates: (AbsoluteCoordinates frElancourt).
	geoView addObject: city.
	
	^ self openViewInWindow: geoView
]

{ #category : #'examples - tiles provider' }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerUsingGoogleHybrid [
	"This example show a map layer (assuming an internet connection to default url of google"
	
	| element layer |
	element := GeoViewAeElement new.
	
	element maxScaleInMeters: element maxScaleInMeters * 8.
	
	"add carto layer"
	layer := GeoViewMapTilesLayer newWithGoogle name: 'Tiles Layer'.
	layer tilesProvider beHybridType.
	element addLayer: layer.

	^ self openViewInWindow: element
	
]

{ #category : #'examples - tiles provider' }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerUsingGoogleRoadmap [
	"This example show a map layer (assuming an internet connection to default url of google"
	
	| element layer |
	element := GeoViewAeElement new.
	
	element maxScaleInMeters: element maxScaleInMeters * 8.
	
	"add carto layer"
	layer := GeoViewMapTilesLayer newWithGoogle name: 'Tiles Layer'.
	layer tilesProvider beRoadmapType.
	element addLayer: layer.

	^ self openViewInWindow: element
	
]

{ #category : #'examples - tiles provider' }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerUsingGoogleRoadsOnly [
	"This example show a map layer (assuming an internet connection to default url of google"
	
	| element layer |
	element := GeoViewAeElement new.
	
	element maxScaleInMeters: element maxScaleInMeters * 8.
	
	"add carto layer"
	layer := GeoViewMapTilesLayer newWithGoogle name: 'Tiles Layer'.
	layer tilesProvider beRoadsOnlyType.
	element addLayer: layer.

	^ self openViewInWindow: element
	
]

{ #category : #'examples - tiles provider' }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerUsingGoogleSatellite [
	"This example show a map layer (assuming an internet connection to default url of google"
	
	| element layer |
	element := GeoViewAeElement new.
	
	element maxScaleInMeters: element maxScaleInMeters * 8.
	
	"add carto layer"
	layer := GeoViewMapTilesLayer newWithGoogle name: 'Tiles Layer'.
	element addLayer: layer.

	^ self openViewInWindow: element
	
]

{ #category : #'examples - tiles provider' }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerUsingGoogleTerrain [
	"This example show a map layer (assuming an internet connection to default url of google"
	
	| element layer |
	element := GeoViewAeElement new.
	
	element maxScaleInMeters: element maxScaleInMeters * 8.
	
	"add carto layer"
	layer := GeoViewMapTilesLayer newWithGoogle name: 'Tiles Layer'.
	layer tilesProvider beTerrainType.
	element addLayer: layer.

	^ self openViewInWindow: element
	
]

{ #category : #'examples - tiles provider' }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerUsingGoogleTerrainOnly [
	"This example show a map layer (assuming an internet connection to default url of google"
	
	| element layer |
	element := GeoViewAeElement new.
	
	element maxScaleInMeters: element maxScaleInMeters * 8.
	
	"add carto layer"
	layer := GeoViewMapTilesLayer newWithGoogle name: 'Tiles Layer'.
	layer tilesProvider beTerrainOnlyType.
	element addLayer: layer.

	^ self openViewInWindow: element
	
]

{ #category : #'examples - tiles provider' }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerUsingLocal [
	"This example show a map layer (assuming there are tiles on default tiles directory (/map/r)"
	
	| element layer |
	element := GeoViewAeElement new.
	
	element maxScaleInMeters: element maxScaleInMeters * 8.
	
	"add carto layer"
	layer := GeoViewMapTilesLayer newWithLocalDirectory name: 'Tiles Layer'.
	element addLayer: layer.

	^ self openViewInWindow: element
	
]

{ #category : #'examples - tiles provider' }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerUsingOSM [
	"This example show a map layer (assuming an internet connection to default url open street map"
	
	| element layer |
	element := GeoViewAeElement new.
	
	element maxScaleInMeters: element maxScaleInMeters * 8.
	
	"add carto layer"
	layer := GeoViewMapTilesLayer new name: 'Tiles Layer'.
	element addLayer: layer.

	^ self openViewInWindow: element
	
]

{ #category : #examples }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerWithUpdateCenter [
	"This example show a map layer with update of map center every seconds (during 30s)"
	
	| element layer newCenter space circle|
	element := GeoViewUtils createGeoViewForGeoObjects.
	
	element maxScaleInMeters: element maxScaleInMeters * 8.
	element scaleInMeters: 150000.
	
	"add carto layer"
	layer := GeoViewMapTilesLayer newWithLocalDirectory.
	layer name: 'SampleCartoLayer'.
	layer allowSlideMoving: false.
	element addLayerAtFirst: layer.
	
	circle := GeoCircle new key: 1; radiusInMeters: 2000; fillStyle: (Color red asSmockStrokeStyle); absoluteCoordinates: AbsoluteCoordinates frBrest.
	element addObject: circle.

	space := self openViewInWindow: element.

	4 seconds wait.
	newCenter := AbsoluteCoordinates frBrest copy.
	[ (1 to: 30) do:[:i | 1 seconds wait.
		newCenter := AbsoluteCoordinates latitudeInDegrees: (newCenter latitudeInDegrees + 0.05)  longitudeInDegrees: (newCenter longitudeInDegrees + 0.05).
		element geoCenter: newCenter.
		circle absoluteCoordinates:newCenter.
		element updateObjects: (OrderedCollection with: circle).
		]
	] forkAt: Processor userBackgroundPriority 
	
]

{ #category : #'examples - data' }
GeoViewExamples class >> exampleLargestCitiesOfTheWorld [

	| geoView nb |
	geoView := GeoViewUtils createGeoViewForGeoObjects.
	geoView addLayerAtFirst: (GeoViewMapTilesLayer newWithGoogle).

	"add largest cities with the same icon"
	nb := 1.
	geoView addObjects: (self largest50Cities collect:[ :e | e key: nb; image: (self iconNamed: #info). nb := nb + 1 ]).

	^ self openViewInWindow: geoView
]

{ #category : #examples }
GeoViewExamples class >> exampleWithDShapesLayer [
	
	| element layer circle1 circle2 segment1 segment2 |
	element := GeoViewAeElement new.
	layer := GeoViewDShapesLayer new name: #shapes. 
	element addLayer: layer.
	
	"User circle (not projected)"
	circle1 := (SmockDCircle key: #circle1) coordinates: (element mapProjection projLatLonToCart: AbsoluteCoordinates zero); radius: 1000000; strokeColor: Color green; strokeWidth: 2.
	layer addDShape: circle1.

	"Device circle"
	circle2 := (SmockDCircle key: #circle2) coordinates: 100@100; radius: 100; strokeColor: Color yellow; strokeWidth: 2; setDrawModeDevice.
	layer addDShape: circle2.

	"User segment"
	segment1 := (SmockDSegment key: #segment1) coordinates: (element mapProjection projLatLonToCart: AbsoluteCoordinates frParis); coordinates2: (element mapProjection projLatLonToCart: AbsoluteCoordinates frBrest); strokeColor: Color green; strokeWidth: 2.
	layer addDShape: segment1.
	
	"Device segment"
	segment2 := (SmockDSegment key: #segment2) coordinates: 150@150; coordinates2: 250@250; strokeColor: Color yellow; strokeWidth: 2; setDrawModeDevice.
	layer addDShape: segment2.

	^ self openViewInWindow: element
]

{ #category : #examples }
GeoViewExamples class >> exampleWithGeoLabeledCircle [
	
	| element circle |
	element := GeoViewUtils createGeoViewForGeoObjects.
	
	"change the default processData of the GeoObject layer to render GeoCircle by a different way"
	(element getLayer: #GeoObjectsLayer) setProcessData: GeoLabeledCircleProcessData new forClass: GeoCircle. 
	
	"create sample datas"
	circle := GeoCircle new key: 1; radiusInMeters: 1000000; strokeStyle: (Color white asSmockStrokeStyle); absoluteCoordinates: AbsoluteCoordinates zero.
	element addObject: circle.

	^ self openViewInWindow: element
]

{ #category : #'examples - updates' }
GeoViewExamples class >> exampleWithGeoObjectsParallelsUpdates [
	"This example show how GeoView can be used by multiples processes which update the model"

	| element space task1 list list1 list2 list3 list4 list5 task2 task3 task4 task5 |
	element := GeoViewUtils createGeoViewForGeoObjects.
	space := self openViewInWindow: element.

	"initial object list"
	list := self createRandomPositionGeoCircles: 5000 color: Color random radius: 100000.
	element addObjects: list.	

	list1 := list copyFrom: 1 to: 1000.
	list2 := list copyFrom: 1001 to: 2000.
	list3 := list copyFrom: 2001 to: 3000.
	list4 := list copyFrom: 3001 to: 4000.
	list5 := list copyFrom: 4001 to: 5000.

	"Objet update thread"
	task1 := (self createAndStartTask: [
		self updateGeoCirclesIn: list1 geoView: element.
	]) stepDelay: 30 milliSecond.

	task2 := (self createAndStartTask: [
		self updateGeoCirclesIn: list2 geoView: element.
	]) stepDelay: 30 milliSecond.

	task3 := (self createAndStartTask: [
		self updateGeoCirclesIn: list3 geoView: element.
	]) stepDelay: 30 milliSecond.

	task4 := (self createAndStartTask: [
		self updateGeoCirclesIn: list4 geoView: element.
	]) stepDelay: 30 milliSecond.

	task5 := (self createAndStartTask: [
		self updateGeoCirclesIn: list5 geoView: element.
	]) stepDelay: 30 milliSecond.

	"Stop thread when window is closed"
	space addEventHandler: (BlEventHandler
			 on: BlSpaceCloseRequest
			 do: [ :event | task1 kill. task2 kill. task3 kill. task4 kill. task5 kill ]).

	^ space
]

{ #category : #'examples - updates' }
GeoViewExamples class >> exampleWithGeoObjectsStimulation [
	"This example use ready-to-use geo-object classes (GeoObject and processData) with creation, update and deletion"

	| element space task list index |
	element := GeoViewUtils createGeoViewForGeoObjects.
	space := self openViewInWindow: element.

	"initial object list"
	index := 5000.
	list := self createRandomPositionGeoCircles: index color: Color random radius: 100000.
	element addObjects: list.

	"Objet update thread"
	task := self createAndStartTask: [ | newIndex |
		newIndex := self stimulateGeoCirclesIn: list geoView: element fromIndex: index.
		index := newIndex. 
	].
	task stepDelay: 30 milliSecond.

	"Stop thread when window is closed"
	space addEventHandler: (BlEventHandler
			 on: BlSpaceCloseRequest
			 do: [ :event | task kill ]).

	^ space
]

{ #category : #'examples - updates' }
GeoViewExamples class >> exampleWithGeoObjectsUpdated [
	"This example use ready-to-use geo-object classes (GeoObject and processData) to represent updated geographical view with a lot of data."

	| element objects space task |
	element := GeoViewUtils createGeoViewForGeoObjectsWithOSM.

	"create sample datas"
	objects := self createGeoObjects.
	element addObjects: objects.
	space := self openViewInWindow: element.

	"Objet update thread"
	task := self createAndStartTask: [
		        | random |
		        random := Random new.
		        objects do: [ :o | o radiusInMeters: random next * 200000].
			        element updateObjects: objects ].
	task stepDelay: 1 second.

	"Stop thread when window is closed"
	space addEventHandler: (BlEventHandler
			 on: BlSpaceCloseRequest
			 do: [ :event | task kill ]).

	^ space
]

{ #category : #private }
GeoViewExamples class >> openViewInWindow: aGeoViewElement [
	"open the view in a window"

	| space |
	aGeoViewElement constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].
	space := aGeoViewElement openInSpace.
	space title: 'GeoView example'.

	^ space
]

{ #category : #private }
GeoViewExamples class >> stimulateGeoCirclesIn: aList geoView: aGeoView fromIndex: anIndex [
    "At each step, create / update and delete some GeoObjects, 
    but ensure that the total number of objects never decreases."

    | random color radiusInM createList updateList removeList newIndex 
      maxRadiusInM unchangeList nbToCreate |

    createList := OrderedCollection new.
    updateList := OrderedCollection new.
    unchangeList := OrderedCollection new.
    removeList := OrderedCollection new.
    random := Random new.
    color := Color random.
    maxRadiusInM := 300000.
    radiusInM := random next * maxRadiusInM.
    newIndex := anIndex.

    aList do: [ :circle |
        | next |
        "First, randomize update / deletion"
        next := random next.
        next <= 0.1
            ifTrue: [ 
                "Update the object"
                circle fillStyle: color asSmockFillStyle.
                circle radiusInMeters: radiusInM.
                updateList add: circle ]
            ifFalse: [
                next >= 0.9
                    ifTrue: [ 
                        "Remove the object"
                        removeList add: circle ]
                    ifFalse: [ 
                        "Do nothing"
                        unchangeList add: circle ] ] ].

    color := Color random.
    radiusInM := random next * maxRadiusInM.

    "Create at least as many new objects as were removed, 
    without exceeding the max number of circles"
    nbToCreate := removeList size.
    (nbToCreate > 0) ifTrue: [
        (self createRandomPositionGeoCircles: nbToCreate color: color radius: radiusInM) do: [ :e |
            newIndex := newIndex + 1.
            e key: newIndex.
            createList add: e.
        ].
    ].

    "Update the geo view"
    aGeoView updateObjects: updateList.
    aGeoView removeObjects: removeList.
    aGeoView addObjects: createList.

    "Rebuild aList to maintain consistency"
    aList removeAll.
    aList addAll: unchangeList;
          addAll: updateList;
          addAll: createList.

    ^ newIndex

]

{ #category : #private }
GeoViewExamples class >> updateGeoCirclesIn: aList geoView: aGeoView [
	"At each step, update all GeoObjects"

	| random color radiusInM updateList maxRadiusInM |
	random := Random new.
	color := Color random.
	maxRadiusInM := 300000.
	radiusInM := random next * maxRadiusInM.
	updateList := OrderedCollection new.
	color := Color random.
	radiusInM := random next * maxRadiusInM.

	updateList := aList collect: [ :circle | "Update the object"
		              circle fillStyle: color asSmockFillStyle.
		              circle radiusInMeters: radiusInM.
		              circle ].

	"Update the geo view"
	aGeoView updateObjects: updateList
]

{ #category : #'see class side' }
GeoViewExamples >> seeClassSide [ 
]
