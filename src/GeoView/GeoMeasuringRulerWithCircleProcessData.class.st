Class {
	#name : #GeoMeasuringRulerWithCircleProcessData,
	#superclass : #GeoMeasuringRulerProcessData,
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #processing }
GeoMeasuringRulerWithCircleProcessData >> populateDShape: aDCompositeShape [
	
	| circle |
	super populateDShape: aDCompositeShape.
	
	"Add a projected circle"
	circle := SmockDMultiPolylines key: #circle.
	circle strokeStyle: (Color white asSmockStrokeStyle width: 3).
	circle effect: (SmockDuplicateEffect new strokeColor: (Color black); strokeWidth: 8; yourself).
	aDCompositeShape addChild: circle.
]

{ #category : #processing }
GeoMeasuringRulerWithCircleProcessData >> processUpdatedData: aKey incoming: aGeoMeasuringRuler with: aDShape context: aContext [

	| dShape circle list radius |

	dShape := super processUpdatedData: aKey incoming: aGeoMeasuringRuler with: aDShape context: aContext.
	
	(aGeoMeasuringRuler fromAbsoluteCoordinates isNil 
		or:[aGeoMeasuringRuler toAbsoluteCoordinates isNil]) ifTrue:[ ^ dShape ].
		
	circle := dShape getChild: #circle.	
		
	"Update the circle"
	radius := self geodesicFormulas distanceInMetersFrom: aGeoMeasuringRuler fromAbsoluteCoordinates to: aGeoMeasuringRuler toAbsoluteCoordinates.
	list := self projectCircle: aGeoMeasuringRuler fromAbsoluteCoordinates radiusInMeters: radius.
	circle removePolylines; addPolylines: list.
	dShape updateChild: circle.
	
	^ dShape
]
