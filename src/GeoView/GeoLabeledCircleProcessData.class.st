Class {
	#name : #GeoLabeledCircleProcessData,
	#superclass : #GeoShapeLabeledProcessData,
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #processing }
GeoLabeledCircleProcessData >> processCreatedData: aKey incoming: aGeoCircle with: aDCompositeShape context: aContext [
	| dLeafShape dCompositeShape |
	dCompositeShape := super processCreatedData: aKey incoming: aGeoCircle with: aDCompositeShape context: aContext.
	
	dLeafShape := SmockDCircle key: #geoShape.
	dLeafShape radius: aGeoCircle radiusInMeters.
	dLeafShape fillStyle: aGeoCircle fillStyle copy.
	dLeafShape strokeStyle: aGeoCircle strokeStyle copy.	
	
	dCompositeShape addChild: dLeafShape.
	
	^ dCompositeShape
]

{ #category : #processing }
GeoLabeledCircleProcessData >> processUpdatedData: aKey incoming: aGeoCircle with: aDCompositeShape context: aContext [
	| dCompositeShape |
	dCompositeShape := aDCompositeShape.
	super processUpdatedData: aKey incoming: aGeoCircle with: aDCompositeShape context: aContext.
	
	(dCompositeShape getChild: #geoShape) ifNotNil:[ :e |
		e radius: aGeoCircle radiusInMeters.
		dCompositeShape updateChild: e.
	].
	
	^dCompositeShape
]
