Class {
	#name : #GeoViewExamples,
	#superclass : #Object,
	#category : #'GeoView-Examples-Examples'
}

{ #category : #private }
GeoViewExamples class >> createAndStartTask: aBlockClosure [

	^ (self createTask: aBlockClosure)
		  start;
		  yourself
]

{ #category : #private }
GeoViewExamples class >> createGeoCircles: aQuantity [

	^ self createGeoCircles: aQuantity do: nil
]

{ #category : #private }
GeoViewExamples class >> createGeoCircles: aQuantity do: aBlock [

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
		aBlock ifNotNil: [ :b | b value: object ].
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
GeoViewExamples class >> createGeoPolyline: aQuantity [

	| list random nb |
	list := OrderedCollection new.
	random := Random new.
	nb := aQuantity.
	
	1 to: nb do:[ :i | | object |
		object := GeoPolyline new.
		object key: i.
		object strokeStyle: (Color random asSmockStrokeStyle).
		object absolutePositions: { AbsoluteCoordinates random . AbsoluteCoordinates random . AbsoluteCoordinates random }.
		list add: object.
	].

	^ list
]

{ #category : #private }
GeoViewExamples class >> createGeoSegment: aQuantity [

	| list random nb |
	list := OrderedCollection new.
	random := Random new.
	nb := aQuantity.
	
	1 to: nb do:[ :i | | object |
		object := GeoSegment new.
		object key: i.
		object strokeStyle: (Color random asSmockStrokeStyle).
		object fromAbsolutePosition: AbsoluteCoordinates random.
		object toAbsolutePosition: AbsoluteCoordinates random.
		list add: object.
	].

	^ list
]

{ #category : #private }
GeoViewExamples class >> createGeoViewElement [

	| element |
	element := GeoViewElement new.
	element footnotes: 'github.com/ThalesGroup/GeoView example, MIT licence'.
	^ element
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

{ #category : #private }
GeoViewExamples class >> createTissotIndicatorCircles [
	"create Tissot indicator objects: some circles around the world"
	
	| radiusInM circles i |
	radiusInM := 500000.
	circles := OrderedCollection new.
	
	i := 1.
	-70 to: 70 by: 15 do:[ :lat | 
		-180 to: 180 by: 15 do:[ :lon | 
			circles add: (GeoCircle new key: i;
				absoluteCoordinates: ( lat @ lon ) asAbsoluteCoordinates ;
				fillStyle: (Color green alpha: 0.5) asSmockFillStyle;
				strokeStyle: (Color green asSmockStrokeStyle width: 1);
				radiusInMeters: radiusInM;
				yourself).
			i := i + 1.
		].	
	].

	^ circles
]

{ #category : #'examples - interactions' }
GeoViewExamples class >> exampleCitiesHover [
	"This example show how to implement a mouse hover interaction to do something"

	| geoView nb processData |
	geoView := GeoViewUtils createGeoViewForGeoObjects.
	geoView addLayerAtFirst: (GeoViewMapTilesLayer new).
		
	"Change the process data of GeoPosition to use a custom one which implement an hover state"
	processData := GeoPositionHoverExampleProcessData new textColor: (Color blue).
	geoView getLayers last setProcessData: processData forClass: GeoPosition.
	
	"add a listener to hover with self injection, dirty but simple example with an all in one handler"
	geoView addEventHandler: (GeoViewHoverExampleBlEventHandler new geoView: geoView).
	
	"add cities"
	nb := 1.
	geoView addObjects: (self largest50Cities collect:[ :e | e key: nb; image: (self iconNamed: #remote). nb := nb + 1. e ]).

	^ self openViewInWindow: geoView
]

{ #category : #'examples - interactions' }
GeoViewExamples class >> exampleDisplayCoordinates [
	"This example show how to display a text with geographic mouse coordinates"

	| element latitudeText longitudeText |
	element := GeoViewElement new.
	element addLayer: (GeoViewMapTilesLayer newWithOpenStreetMap name: #OSMTilesLayer).

	"Create a text to display coordinates"
	latitudeText := BlTextElement new
		        constraintsDo: [ :constraints |
				        constraints horizontal fitContent.
				        constraints vertical exact: 15.
				        constraints padding: (BlInsets all: 10.0) ];
		        id: #latitudeText; text: '--' asRopedText;
		        yourself.
	element addChild: latitudeText.
	
	longitudeText := BlTextElement new
		        constraintsDo: [ :constraints |
				        constraints horizontal fitContent.
							constraints vertical exact: 15.
				        constraints position: 0 @ 20.
				        constraints padding: (BlInsets all: 10.0) ];
		        id: #longitudeText; text: '--' asRopedText;
		        yourself.
	element addChild: longitudeText.

	"Listen cursor coordinates change event"
	element
		addEventHandlerOn: GeoViewCursorCoordinatesChangedEvent
		do: [ :event |
				| lat lon string |
				lat := event absoluteCoordinates latitudeInDegrees printString.
				lon := event absoluteCoordinates longitudeInDegrees printString.
				
				string := 'Latitude: ', lat.
				latitudeText text: (BlRopedText new
						 rope: (BlAttributeRope
								  attributes: {
										  (BlFontSizeAttribute new
											   size: 20;
											   yourself).
										  (BlTextBackgroundAttribute new
											   paint: Color black;
											   yourself).
										  (BlTextForegroundAttribute new
											   paint: Color white;
											   yourself) }
								  rope: (BlCollectionRope new
										   collection: string;
										   yourself));
						 yourself).
				latitudeText textChanged.
				
				string := 'Longitude: ', lon.
				longitudeText text: (BlRopedText new
						 rope: (BlAttributeRope
								  attributes: {
										  (BlFontSizeAttribute new
											   size: 20;
											   yourself).
										  (BlTextBackgroundAttribute new
											   paint: Color black;
											   yourself).
										  (BlTextForegroundAttribute new
											   paint: Color white;
											   yourself) }
								  rope: (BlCollectionRope new
										   collection: string;
										   yourself));
						 yourself).
				longitudeText textChanged ].

	^ self openViewInWindow: element
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
GeoViewExamples class >> exampleGeoCirclesProjected [
	"Same example as exampleGeoCircles but with projected circles (due to projection deformation)"
	
	| element objects |
	element := GeoViewUtils createGeoViewForGeoObjects.
	
	(element getLayer: #GeoObjectsLayer) setProcessData: (GeoCircleProjectedProcessData new) forClass: GeoCircle. 
	
	"create sample datas"
	objects := self createGeoCircles: 100 do: [ :e | e radiusInMeters: 1000000 ].
	element addObjects: objects.

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
GeoViewExamples class >> exampleGeoPolylines [
	
	| element objects |
	element := GeoViewUtils createGeoViewForGeoObjects.
		
	"create sample datas"
	objects := self createGeoPolyline: 1000.
	element addObjects: objects.

	^ self openViewInWindow: element
]

{ #category : #'examples - GeoObjects' }
GeoViewExamples class >> exampleGeoPositions [
	
	| geoView city |
	geoView := GeoViewUtils createGeoViewForGeoObjects.
	geoView addLayerAtFirst: (GeoViewMapTilesLayer new).
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

{ #category : #'examples - GeoObjects' }
GeoViewExamples class >> exampleGeoSegments [
	
	| element objects |
	element := GeoViewUtils createGeoViewForGeoObjects.
		
	"create sample datas"
	objects := self createGeoSegment: 200.
	
	element addObjects: objects.

	^ self openViewInWindow: element
]

{ #category : #'examples - GeoObjects' }
GeoViewExamples class >> exampleGeoSegmentsProjected [
	
	| element objects |
	element := GeoViewUtils createGeoViewForGeoObjects.
		
	element getLayers last setProcessData: (GeoSegmentProjectedProcessData new) forClass: GeoSegment.
		
	"create sample datas"
	objects := self createGeoSegment: 200.
	
	element addObjects: objects.

	^ self openViewInWindow: element
]

{ #category : #'examples - tiles provider' }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerUsingGoogleHybrid [
	"This example show a map layer (assuming an internet connection to default url of google"

	| element layer |
	element := GeoViewElement new.

	element maxScale: element maxScale * 8.

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
	element := GeoViewElement new.
	
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
	element := GeoViewElement new.

	element maxScaleInMeters: element maxScale * 8.

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
	element := GeoViewElement new.
	
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
	element := GeoViewElement new.
	
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
	element := GeoViewElement new.
	
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
	element := GeoViewElement new.

	element maxScaleInMeters: element maxScale * 8.

	"add carto layer"
	layer := GeoViewMapTilesLayer newWithLocalDirectory name:
		         'Tiles Layer'.
	element addLayer: layer.

	^ self openViewInWindow: element
]

{ #category : #'examples - tiles provider' }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerUsingOSM [
	"This example show a map layer (assuming an internet connection to default url open street map"

	| element layer |
	element := GeoViewElement new.

	element maxScaleInMeters: element maxScale * 8.

	"add carto layer"
	layer := GeoViewMapTilesLayer new name: 'Tiles Layer'.
	element addLayer: layer.

	^ self openViewInWindow: element
]

{ #category : #'examples - tiles provider' }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerUsingOSMWithSmallTileSize [
	"This example show a map layer (assuming an internet connection to default url open street map"

	| element layer |
	element := GeoViewElement new.

	element maxScaleInMeters: element maxScale * 8.

	"add carto layer"
	layer := GeoViewMapTilesLayer new name: 'Tiles Layer'.
	layer tileSize: 128.
	element addLayer: layer.

	^ self openViewInWindow: element
]

{ #category : #examples }
GeoViewExamples class >> exampleGeoViewWithCartoTilesLayerWithUpdateCenter [
	"This example show a map layer with update of map center every seconds (during 30s)"

	| element layer newCenter space circle |
	element := GeoViewUtils createGeoViewForGeoObjects.

	element maxScale: element maxScale * 8.
	element scale: 150000.

	"add carto layer"
	element addLayerAtFirst: GeoViewMapTilesLayer new.

	circle := GeoCircle new
		          key: 1;
		          radiusInMeters: 2000;
		          fillStyle: Color red asSmockStrokeStyle;
		          absoluteCoordinates: AbsoluteCoordinates frBrest.
	element addObject: circle.
	space := self openViewInWindow: element.

	newCenter := AbsoluteCoordinates frBrest copy.
	[
		(1 to: 30) do: [ :i |
				1 seconds wait.
				newCenter := AbsoluteCoordinates
					             latitudeInDegrees:
					             newCenter latitudeInDegrees + 0.05
					             longitudeInDegrees:
					             newCenter longitudeInDegrees + 0.05.
				element geoCenter: newCenter.
				circle absoluteCoordinates: newCenter.
				element updateObjects: (OrderedCollection with: circle) ] ]
		forkAt: Processor userBackgroundPriority
]

{ #category : #'examples - data' }
GeoViewExamples class >> exampleLargestCitiesOfTheWorld [

	| geoView nb |
	geoView := GeoViewUtils createGeoViewForGeoObjects.
	geoView addLayerAtFirst: (GeoViewMapTilesLayer new).
	"configure process data of GeoPosition objects"
	(geoView getLayers last getProcessDataForClass: GeoPosition) textColor: Color black.
	
	"add largest cities with the same icon"
	nb := 1.
	geoView addObjects: (self largest50Cities collect:[ :e | e key: nb; image: (self iconNamed: #info). nb := nb + 1. e ]).

	^ self openViewInWindow: geoView
]

{ #category : #'examples - data' }
GeoViewExamples class >> exampleLargestCountriesOfTheWorld [

	| geoView nb |
	geoView := GeoViewUtils createGeoViewForGeoObjects.
	geoView addLayerAtFirst: (GeoViewMapTilesLayer new).

	"add largest countries with a gradient circle"
	nb := 1.
	geoView addObjects: (self largest50Countries collect:[ :e | 
		e key: nb.
		e radiusInMeters: e radiusInMeters * 3.
		e fillStyle: (SmockRadialGradientPaint new stops: { (0 -> (Color transparent)) . (0.5 -> (Color black alpha: 0)) . 1 -> (Color cyan) }).
		nb := nb + 1. 
		e 
	]).

	^ self openViewInWindow: geoView
]

{ #category : #'examples - interactions' }
GeoViewExamples class >> exampleMeasuringRuler [
	"This example show how to use a MeasuringRuler with a custom process data"

	| element layer instructionsText |
	element := GeoViewElement new id: #geoView.
	element addLayer: (GeoViewMapTilesLayer newWithOpenStreetMap).
	
	"Create a new layer to display the measure tool"
	layer := GeoViewDomainObjectsLayer new name: #tools.
	layer setProcessData: (GeoMeasuringRulerProcessData new) forClass: GeoMeasuringRuler. 
	element addLayer: layer.
	
	"Create a text to display instructions"
	instructionsText := BlTextElement new
				background: Color white;
				effect: (BlGaussianShadowEffect color: (Color gray alpha: 0.5) width: 10 offset: 0@0);
	        constraintsDo: [ :constraints |
		        constraints horizontal fitContent.
		        constraints vertical exact: 15.
		        constraints padding: (BlInsets all: 10.0) ];
	        id: #instructionsText; text: 'Double click on a position to start a measurement, move the mouse and click another time to stay the ruler.' asRopedText;
	        yourself.
	element addChild: instructionsText.
	
	"create a controller to manager the ruler"
	element addEventHandler: GeoViewMeasuringRulerController new.
	
	^ self openViewInWindow: element
]

{ #category : #'examples - interactions' }
GeoViewExamples class >> exampleMeasuringRulerWithCircle [
	"This example show how to use a MeasuringRuler but with a process data which is display a circle in addition to the ruler"

	| space geoView layer |
	space := self exampleMeasuringRuler.
	
	geoView := space root childWithId: #geoView.
	
	"change process data"
	layer := geoView getLayer: #tools.
	layer setProcessData: (GeoMeasuringRulerWithCircleProcessData new) forClass: GeoMeasuringRuler. 
]

{ #category : #'examples - filters' }
GeoViewExamples class >> exampleObjectsFilterChanged [

	| geoView objects filter colorToAttr processData colors task space |
	geoView := GeoViewUtils createGeoViewForGeoObjects.
	
	filter := SmockAttributesDisplayFilter fromObjects: #(#red #yellow #green).
	filter displayObjectsWithoutAttributes: false.
	geoView displayFilter: filter.
	
	"configure process data to build the filter behavior"
	colorToAttr := Dictionary newFrom: { Color red -> #red . Color yellow -> #yellow . Color green -> #green }.
	processData := (geoView getLayer: #GeoObjectsLayer) getProcessDataForClass: GeoCircle.
	processData displayFilterBlock: [ :k :circle :dShape |  | color |
		color := circle fillStyle paint.
		(colorToAttr includesKey: color) ifTrue: [ 
			dShape displayFilter: (SmockAttributeList fromObject: (colorToAttr at: color) ) 
		].
	].
	
	colors := { Color red . Color blue . Color yellow . Color green . Color brown . Color cyan }.
	
	"create sample datas"
	objects := self createGeoCircles: 5000 do:[ :circle | 
		circle strokeStyle: nil.
		circle fillStyle: (colors atRandom asSmockFillStyle).
	].
	geoView addObjects: objects.
	
	"change the filter in the time, and sometimes remove it"
	task := self createAndStartTask: [
		filter disallowAllAttributes.
		(Random new next > 0.2) ifTrue:[
			filter allowAttribute: ((#(#red #yellow #green) atRandom)).
		] ifFalse:[
			filter allowAllAttributes.
		].
		geoView displayFilter: filter.	
	].
	task stepDelay: 0.5 second.
	
	space := self openViewInWindow: geoView.
	
	"Stop thread when window is closed"
	space addEventHandler: (BlEventHandler
			 on: BlSpaceCloseRequest
			 do: [ :event | task kill ]).
	
	^ space
	
]

{ #category : #'examples - filters' }
GeoViewExamples class >> exampleObjectsFilterOnlyRed [

	| geoView objects filter colorToAttr processData availableColors |
	geoView := GeoViewUtils createGeoViewForGeoObjects.
	
	"set a general filter"
	filter := SmockAttributesDisplayFilter fromObjects: { #red . #unknown }.
	filter disallowAttribute: #unknown. 
 	geoView displayFilter: filter.
	
	"configure process data to build the filter behavior"
	colorToAttr := Dictionary newFrom: { Color red -> #red }.
	processData := (geoView getLayer: #GeoObjectsLayer) getProcessDataForClass: GeoCircle.
	processData displayFilterBlock: [ :k :circle :dShape |  | color |
		color := circle fillStyle paint.
		(colorToAttr includesKey: color) ifTrue: [ 
			dShape displayFilter: (SmockAttributeList fromObject: (colorToAttr at: color) ) 
		] ifFalse:[ 
			dShape displayFilter: (SmockAttributeList fromObject: #unknown ) 
		].
	].
	
	availableColors := { Color red . Color blue . Color yellow . Color green . Color brown . Color cyan }.
	
	"create sample datas"
	objects := self createGeoCircles: 5000 do:[ :circle | 
		circle strokeStyle: nil.
		circle fillStyle: (availableColors atRandom asSmockFillStyle).
	].
	geoView addObjects: objects.
	
	^ self openViewInWindow: geoView
]

{ #category : #'examples - filters' }
GeoViewExamples class >> exampleObjectsFilterOnlyRedAndBig [

	| geoView objects filter processData availableColors |
	geoView := GeoViewUtils createGeoViewForGeoObjects.
	
	"set a general filter"
	filter := SmockAttributesDisplayFilter fromObjects: #(#red #unknown #big #small).
	filter disallowAllAttributes; allowAttributes: #( #red #big ). 
 	geoView displayFilter: filter.
	
	"configure process data to build the filter behavior"
	processData := (geoView getLayer: #GeoObjectsLayer) getProcessDataForClass: GeoCircle.
	processData displayFilterBlock: [ :k :circle :dShape |  | color |
	
		dShape displayFilter: SmockAttributeList new.
	
		"color filter"
		color := circle fillStyle paint.
		(Color red = color) ifTrue: [ 
			dShape displayFilter addAttribute: #red 
		] ifFalse:[ 
			dShape displayFilter addAttribute: #unknown
		].
	
		"size filter"
		circle radiusInMeters > 95000 ifTrue:[
			dShape displayFilter addAttribute: #big.
		] ifFalse:[
			dShape displayFilter addAttribute: #small.
		].
	].
	
	availableColors := { Color red . Color blue . Color yellow . Color green . Color brown . Color cyan }.
	
	"create sample datas"
	objects := self createGeoCircles: 5000 do:[ :circle | 
		circle strokeStyle: nil.
		circle fillStyle: (availableColors atRandom asSmockFillStyle).
	].
	geoView addObjects: objects.
	
	^ self openViewInWindow: geoView
]

{ #category : #'examples - geodesie' }
GeoViewExamples class >> exampleOrthodromicTrajectoriesBetweenParisNewyorkAndSydney [
	
	| element layer segment1 segment2 segment3 |
	element := GeoViewUtils createGeoView.
	element addLayer: GeoViewMapTilesLayer new.
	
	layer := GeoViewDomainObjectsLayer new name: #ProjectedGeoObjectLayer.
	layer setProcessData: (GeoSegmentProjectedProcessData new) forClass: GeoSegment.
	element addLayer: layer.
		
	segment1 := (GeoSegment key: 1) fromAbsolutePosition: AbsoluteCoordinates frParis; toAbsolutePosition: AbsoluteCoordinates usaNewYork.
	segment1 strokeStyle: (Color green asSmockStrokeStyle width: 4).
	element addObject: segment1.
	
	segment2 := (GeoSegment key: 2) fromAbsolutePosition: AbsoluteCoordinates usaNewYork; toAbsolutePosition: AbsoluteCoordinates ausSydney.
	segment2 strokeStyle: (Color green asSmockStrokeStyle width: 4).
	element addObject: segment2.

	segment3 := (GeoSegment key: 3) fromAbsolutePosition: AbsoluteCoordinates ausSydney; toAbsolutePosition: AbsoluteCoordinates frParis.
	segment3 strokeStyle: (Color green asSmockStrokeStyle width: 4).
	element addObject: segment3.

	^ self openViewInWindow: element
]

{ #category : #'examples - geodesie' }
GeoViewExamples class >> exampleOrthodromicTrajectoryTransverseMercatorProjectionFromNewyorkToSydney [
	"this example show a trajectory which exit the mercator projection"
	
	| element layer segment1 |
	element := GeoViewUtils createGeoView.
	element addLayer: GeoViewMapTilesLayer new.
	
	layer := GeoViewDomainObjectsLayer new name: #ProjectedGeoObjectLayer.
	layer setProcessData: (GeoSegmentProjectedProcessData new) forClass: GeoSegment.
	element addLayer: layer.

	segment1 := (GeoSegment key: 1) fromAbsolutePosition: AbsoluteCoordinates usaNewYork; toAbsolutePosition: AbsoluteCoordinates ausSydney.
	segment1 strokeStyle: (Color green asSmockStrokeStyle width: 4).
	element addObject: segment1.

	^ self openViewInWindow: element
]

{ #category : #'examples - geodesie' }
GeoViewExamples class >> exampleOrthonormicVsOrthodromicFromParisToNewyork [
	
	| element layer segment1 |
	element := GeoViewUtils createGeoView.
	element addLayer: GeoViewMapTilesLayer new.
	
	layer := GeoViewDomainObjectsLayer new name: #ProjectedGeoObjectLayer.
	layer setProcessData: (GeoSegmentProjectedProcessData new) forClass: GeoSegment.
	element addLayer: layer.
	
	layer := GeoViewDomainObjectsLayer new name: #ProjectedGeoObjectLayer.
	layer setProcessData: (GeoSegmentProcessData new) forClass: GeoSegment.
	element addLayer: layer.
		
	"create sample datas"
	segment1 := (GeoSegment key: 1) fromAbsolutePosition: AbsoluteCoordinates frParis; toAbsolutePosition: AbsoluteCoordinates usaNewYork.
	segment1 strokeStyle: (Color orange asSmockStrokeStyle width: 4).
	element addObject: segment1.

	^ self openViewInWindow: element
]

{ #category : #'examples - projections' }
GeoViewExamples class >> exampleTissotIndicatorMercator [
	"This example implement the indicator of Tissot (Nicolas August) for a projection, this indicator indicate the level of deformation of the selection projection"
	
	| element objects |
	element := GeoViewUtils createGeoViewForGeoObjects.
	element mapProjection: GeoViewMercatorProjection new. "by default"
	"laborde: better to have a vectorial map to considere the deformation because tiles are not available for all projections"
	
	"create sample datas"
	objects := self createTissotIndicatorCircles.
	element addObjects: objects.

	^ self openViewInWindow: element
	
]

{ #category : #'examples - projections' }
GeoViewExamples class >> exampleTissotIndicatorUTM [
	"This example implement the indicator of Tissot (Nicolas August) for a projection, this indicator indicate the level of deformation of the selection projection"
	
	| element objects |
	
	"warning before opening"
	(UIManager default
		 confirm:
			 'This Tissot indicator example using a not finalized UTM Projection, it can works but without stability.
			Start ?'
		 label: 'GeoView - Work in progress') ifFalse:[ ^ self ].
	
	element := GeoViewUtils createGeoViewForGeoObjects.
	element mapProjection: GeoViewUTMProjection new.
	"laborde: better to have a vectorial map to considere the deformation because tiles are not available for all projections"
	
	"create sample datas"
	objects := self createTissotIndicatorCircles.
	element addObjects: objects.

	^ self openViewInWindow: element
	
]

{ #category : #'examples - dshapeslayer' }
GeoViewExamples class >> exampleWithDShapesLayer [
	
	| element layer circle1 circle2 segment1 segment2 |
	element := GeoViewElement new.
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

{ #category : #'examples - dshapeslayer' }
GeoViewExamples class >> exampleWithDShapesLayerWithDeviceRectanglesResizedOnSizeChanged [
	"In this test, use of a DShapes layer to display rectangles in device coordinates. These rectangle are resize when the window size change."
	
	| element layer rectangle1 rectangle2 rectangle3 |
	element := GeoViewElement new.
	layer := GeoViewDShapesLayer new name: #shapes. 
	element addLayer: layer.
	
	rectangle1 := (SmockDRectangle key: #rectangle1) setDrawModeDevice; coordinates: 10@10; length1: 100; length2: 100; strokeColor: Color yellow; strokeWidth: 4.
	layer addDShape: rectangle1.
	
	rectangle2 := (SmockDRectangle key: #rectangle2) setDrawModeDevice; coordinates: 20@20; length1: 100; length2: 100; strokeColor: Color yellow; strokeWidth: 4.
	layer addDShape: rectangle2.

	element 
		addEventHandlerOn: BlElementExtentChangedEvent
		do: [ :evt | | extent | "update rectangles size"
			extent := evt target extent. 
			
			rectangle1 length1: (extent x - 20); length2: (extent y - 20).
			rectangle2 length1: (extent x - 40); length2: (extent y - 40).
			
			layer updateDShapes: { rectangle1 . rectangle2 }.
		].

	"create a user rectangle : not affected by size changed"
	rectangle3 := (SmockDRectangle key: #rectangle3) coordinates: (element mapProjection projLatLonToCart: AbsoluteCoordinates zero); length1: 1000000; length2: 1000000; strokeColor: Color green; strokeWidth: 2.
	layer addDShape: rectangle3.

	^ self openViewInWindow: element
]

{ #category : #'examples - dshapeslayer' }
GeoViewExamples class >> exampleWithDShapesLayerWithDeviceRectanglesResizedOnSizeChanged2 [
	"Same example that exampleWithDShapesLayerWithDeviceRectanglesResizedOnSizeChanged but with a custom DShape layer"
	
	| element layer rectangle3 |
	element := GeoViewElement new.
	layer := GeoViewDShapesExampleRectangleLayer new name: #shapes. 
	element addLayer: layer.

	"create a user rectangle : not affected by size changed"
	rectangle3 := (SmockDRectangle key: #rectangle3) coordinates: (element mapProjection projLatLonToCart: AbsoluteCoordinates zero); length1: 1000000; length2: 1000000; strokeColor: Color green; strokeWidth: 2.
	layer addDShape: rectangle3.

	^ self openViewInWindow: element
]

{ #category : #'examples - dshapeslayer' }
GeoViewExamples class >> exampleWithDShapesLayerWithOrder [
	
	| element layer circle task circleOnTop space |
	element := GeoViewElement new.
	layer := GeoViewDShapesLayer new name: #shapes. 
	element addLayer: layer.
	
	"User circle (not projected)"
	circle := (SmockDCircle key: #circle1) coordinates: (element mapProjection projLatLonToCart: (AbsoluteCoordinates latitudeInDegrees: 1 longitudeInDegrees: 1)); radius: 1000000; strokeColor: Color green; strokeWidth: 10.
	layer addDShape: circle.
	
	circleOnTop := (SmockDCircle key: #circle2) coordinates: (element mapProjection projLatLonToCart: AbsoluteCoordinates zero); radius: 1000000; strokeColor: Color red; strokeWidth: 10.
	layer addDShape: circleOnTop.
	
	circle := (SmockDCircle key: #circle3) coordinates: (element mapProjection projLatLonToCart: (AbsoluteCoordinates latitudeInDegrees: -1 longitudeInDegrees: -1)); radius: 1000000; strokeColor: Color green; strokeWidth: 10.
	layer addDShape: circle.


	"Objet update thread"
	task := self createAndStartTask: [
		circleOnTop zIndex: (circleOnTop zIndex = 10 ifTrue:[ nil ] ifFalse:[ 10 ]).
		layer updateDShape: circleOnTop.
	].
	task stepDelay: 1 seconds.

	space := self openViewInWindow: element.

	"Stop thread when window is closed"
	space addEventHandler: (BlEventHandler
			 on: BlSpaceCloseRequest
			 do: [ :event | task kill ]).

	
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

{ #category : #'private - datas' }
GeoViewExamples class >> largest50Cities [
	"example: not realistic"

        | positions |
        positions := OrderedCollection new.

        positions add: ((GeoPosition new) text: 'Tokyo'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 35.682839 longitudeInDegrees: 139.759455 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Delhi'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 28.613939 longitudeInDegrees: 77.209021 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Shanghai'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 31.230416 longitudeInDegrees: 121.473701 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'São Paulo'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -23.550520 longitudeInDegrees: -46.633308 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Mexico City'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 19.432608 longitudeInDegrees: -99.133209 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Cairo'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 30.044420 longitudeInDegrees: 31.235712 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Dhaka'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 23.810301 longitudeInDegrees: 90.412521 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Mumbai'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 19.076090 longitudeInDegrees: 72.877426 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Beijing'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 39.904200 longitudeInDegrees: 116.407396 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Oslo'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 59.913868 longitudeInDegrees: 10.752245 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'New York City'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 40.712776 longitudeInDegrees: -74.005974 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Karachi'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 24.860735 longitudeInDegrees: 67.001139 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Chongqing'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 29.563011 longitudeInDegrees: 106.550864 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Istanbul'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 41.008238 longitudeInDegrees: 28.978359 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Buenos Aires'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -34.603684 longitudeInDegrees: -58.381559 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Kolkata'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 22.572646 longitudeInDegrees: 88.363895 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Kuala Lumpur'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 3.139 longitudeInDegrees: 101.6869 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'London'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 51.507351 longitudeInDegrees: -0.127758 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Lagos'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 6.5244 longitudeInDegrees: 3.3792 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Rio de Janeiro'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -22.9068 longitudeInDegrees: -43.1729 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Tianjin'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 39.343357 longitudeInDegrees: 117.361648 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Kinshasa'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -4.4419 longitudeInDegrees: 15.2663 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Guangzhou'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 23.1291 longitudeInDegrees: 113.2644 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Wuhan'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 30.5928 longitudeInDegrees: 114.3055 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Chennai'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 13.0827 longitudeInDegrees: 80.2707 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Lima'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -12.0464 longitudeInDegrees: -77.0428 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Bangkok'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 13.7563 longitudeInDegrees: 100.5018 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Hyderabad'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 17.3850 longitudeInDegrees: 78.4867 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Chengdu'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 30.5728 longitudeInDegrees: 104.0668 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Nanjing'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 32.0603 longitudeInDegrees: 118.7969 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Tehran'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 35.6892 longitudeInDegrees: 51.3890 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Hanoi'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 21.0285 longitudeInDegrees: 105.8542 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Ho Chi Minh City'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 10.7769 longitudeInDegrees: 106.6958 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Hangzhou'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 30.2741 longitudeInDegrees: 120.1551 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Ahmedabad'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 23.0225 longitudeInDegrees: 72.5714 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Bogotá'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 4.6110 longitudeInDegrees: -74.0828 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Johannesburg'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -26.2041 longitudeInDegrees: 28.0473 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Addis Ababa'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 9.03 longitudeInDegrees: 38.74 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Tampa'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 27.9506 longitudeInDegrees: -82.4572 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Atlanta'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 33.7490 longitudeInDegrees: -84.3880 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Los Angeles'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 34.0522 longitudeInDegrees: -118.2437 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Miami'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 25.7617 longitudeInDegrees: -80.1918 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Seattle'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 47.6062 longitudeInDegrees: -122.3321 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Philadelphia'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 39.9526 longitudeInDegrees: -75.1652 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Dallas'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 32.7767 longitudeInDegrees: -96.7970 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Minneapolis'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 44.9794 longitudeInDegrees: -93.2636 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Phoenix'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 33.4484 longitudeInDegrees: -112.0740 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'San Diego'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 32.7157 longitudeInDegrees: -117.1611 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Tucson'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 32.2226 longitudeInDegrees: -110.9747 altitudeInMeters: 0)).
        positions add: ((GeoPosition new) text: 'Charlotte'; absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 35.2271 longitudeInDegrees: -80.8431 altitudeInMeters: 0)).
        
        ^positions
]

{ #category : #'private - datas' }
GeoViewExamples class >> largest50Countries [
	"example: not realistic"

        | positions |
        positions := OrderedCollection new.

        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 39.9042 longitudeInDegrees: 116.4074); radiusInMeters: 1000000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 28.6139 longitudeInDegrees: 77.2090); radiusInMeters: 900000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 38.9072 longitudeInDegrees: -77.0369); radiusInMeters: 800000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -6.2088 longitudeInDegrees: 106.8456); radiusInMeters: 600000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 30.3753 longitudeInDegrees: 69.3451); radiusInMeters: 500000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -14.2350 longitudeInDegrees: -51.9253); radiusInMeters: 400000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 9.0820 longitudeInDegrees: 8.6753); radiusInMeters: 350000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 23.6850 longitudeInDegrees: 90.3563); radiusInMeters: 300000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 55.7558 longitudeInDegrees: 37.6173); radiusInMeters: 250000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 23.6345 longitudeInDegrees: -102.5528); radiusInMeters: 200000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 35.6828 longitudeInDegrees: 139.7595); radiusInMeters: 150000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 9.1450 longitudeInDegrees: 40.4897); radiusInMeters: 140000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 12.8797 longitudeInDegrees: 121.7740); radiusInMeters: 130000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 26.8206 longitudeInDegrees: 30.8025); radiusInMeters: 120000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 14.0583 longitudeInDegrees: 108.2772); radiusInMeters: 110000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -4.0383 longitudeInDegrees: 21.7587); radiusInMeters: 100000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 38.9637 longitudeInDegrees: 35.2433); radiusInMeters: 95000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 32.4279 longitudeInDegrees: 53.6880); radiusInMeters: 90000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 51.1657 longitudeInDegrees: 10.4515); radiusInMeters: 85000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 15.8700 longitudeInDegrees: 100.9925); radiusInMeters: 80000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 55.3781 longitudeInDegrees: -3.4360); radiusInMeters: 75000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 46.6034 longitudeInDegrees: 1.8883); radiusInMeters: 70000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 41.8719 longitudeInDegrees: 12.5674); radiusInMeters: 65000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -6.3690 longitudeInDegrees: 34.8888); radiusInMeters: 60000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -30.5595 longitudeInDegrees: 22.9375); radiusInMeters: 55000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -18.6657 longitudeInDegrees: 35.5296); radiusInMeters: 50000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -1.2864 longitudeInDegrees: 36.8172); radiusInMeters: 40000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 4.5709 longitudeInDegrees: -74.2973); radiusInMeters: 35000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 40.4637 longitudeInDegrees: -3.7492); radiusInMeters: 30000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -38.4161 longitudeInDegrees: -63.6167); radiusInMeters: 25000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 1.3733 longitudeInDegrees: 32.2903); radiusInMeters: 24000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 28.0339 longitudeInDegrees: 1.6596); radiusInMeters: 23000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 12.8628 longitudeInDegrees: 30.2176); radiusInMeters: 22000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 33.2232 longitudeInDegrees: 43.4119); radiusInMeters: 21000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 33.9391 longitudeInDegrees: 67.7099); radiusInMeters: 20000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 51.9194 longitudeInDegrees: 19.1451); radiusInMeters: 19000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 56.1304 longitudeInDegrees: -106.3468); radiusInMeters: 18000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 31.7917 longitudeInDegrees: -7.0926); radiusInMeters: 17000).
        positions add: ((GeoCircle new) absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -6.3690 longitudeInDegrees: 34.8888); radiusInMeters: 16000).

        ^positions
]

{ #category : #private }
GeoViewExamples class >> openViewInWindow: aGeoViewElement [
	"open the view in a window"

	| space |
	
	aGeoViewElement footnotes: 'github.com/ThalesGroup/GeoView example, MIT licence'.
	
	aGeoViewElement constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].
	
	space := aGeoViewElement openInSpace.
	space title: 'GeoView Example'.
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
