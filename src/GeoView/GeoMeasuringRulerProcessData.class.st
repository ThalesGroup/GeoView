Class {
	#name : #GeoMeasuringRulerProcessData,
	#superclass : #GeoToolProcessData,
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #processing }
GeoMeasuringRulerProcessData >> populateDShape: aDCompositeShape [
	
	"label to display cursor informations"
	| label polylinesDash polylinesBackground |
	label := SmockDText key: #label.
	label zIndex: 10; isTranslatedByParent: false; fillColor: Color blue; smockFont: (SmockFont defaultFont fontSize: 20).
	aDCompositeShape addChild: label.	

	"lines to display projected measured distance"
	polylinesDash := SmockDMultiPolylines key: #polylinesDash.
	polylinesDash strokeStyle: (Color white asSmockStrokeStyle width: 6; dashes: #(6 6)).
	aDCompositeShape addChild: polylinesDash.

	polylinesBackground := SmockDMultiPolylines key: #polylinesBackground.
	polylinesBackground strokeStyle: (Color black asSmockStrokeStyle width: 8).
	aDCompositeShape addChild: polylinesBackground
]

{ #category : #processing }
GeoMeasuringRulerProcessData >> processCreatedData: aKey incoming: aGeoMeasuringRuler with: aDShape context: aContext [

	| dShape |
	dShape := aDShape ifNil: [ SmockDCompositeShape new ].

	super
		processCreatedData: aKey
		incoming: aGeoMeasuringRuler
		with: dShape
		context: aContext.
	
	self populateDShape: dShape.

	"reuse process updated"
	self
		processUpdatedData: aKey
		incoming: aGeoMeasuringRuler
		with: dShape
		context: aContext.

	^ dShape
]

{ #category : #processing }
GeoMeasuringRulerProcessData >> processUpdatedData: aKey incoming: aGeoMeasuringRuler with: aDShape context: aContext [

	| dShape label polylinesDash text polylinesBackground labelPos |
	dShape := aDShape.

	super processUpdatedData: aKey incoming: aGeoMeasuringRuler with: dShape context: aContext.

	label := aDShape getChild: #label.
	polylinesDash := aDShape getChild: #polylinesDash.
	polylinesBackground := aDShape getChild: #polylinesBackground.

	(aGeoMeasuringRuler fromAbsoluteCoordinates isNil 
		or:[aGeoMeasuringRuler toAbsoluteCoordinates isNil]) ifTrue:[
		
		dShape isVisible: false.
			
	] ifFalse:[ | distance list |
	
		dShape isVisible: true.
	
		"Display measurement"
		distance := self geodesicFormulas distanceInMetersFrom: aGeoMeasuringRuler fromAbsoluteCoordinates to: aGeoMeasuringRuler toAbsoluteCoordinates.
		distance ifNil:[ distance := '--' ] ifNotNil:[ :e | distance := e rounded ].
		text := distance asString, 'm'.
		label text ~= text ifTrue:[ label text: text. dShape updateChild: label ].
		
		"Move label"
		labelPos := self geodesicFormulas absoluteCoordinatesAlongGeodesicFrom: aGeoMeasuringRuler fromAbsoluteCoordinates to: aGeoMeasuringRuler toAbsoluteCoordinates atFraction: 0.5.
		labelPos := self processor projection projLatLonToCart: labelPos.
		label coordinates ~= labelPos ifTrue:[ label coordinates: labelPos. dShape updateChild: label ].
		
		"Update the ruler"
		list := self projectGeodesicFrom: aGeoMeasuringRuler fromAbsoluteCoordinates to: aGeoMeasuringRuler toAbsoluteCoordinates.
		
		polylinesDash removePolylines; addPolylines: list.
		dShape updateChild: polylinesDash.
		
		polylinesBackground removePolylines; addPolylines: list.
		dShape updateChild: polylinesBackground.
	
	].

	^ dShape
]
