Class {
	#name : #GeoShapeLabeledProcessData,
	#superclass : #GeoObjectProcessData,
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #processing }
GeoShapeLabeledProcessData >> processCreatedData: aKey incoming: aGeoShape with: aDCompositeShape context: aContext [
	| dCompositeShape dLabel |
	dCompositeShape := aDCompositeShape ifNil:[SmockDCompositeShape new].
	super processCreatedData: aKey incoming: aGeoShape with: dCompositeShape context: aContext.

	"create a label"
	dLabel := SmockDText key: #label.
	dLabel fillColor: Color white.
	dLabel smockFont: SmockFont defaultFont.
	dLabel text: aGeoShape printString.
	dLabel coordinatesDeviceOffset: -30 @ -30.
	dCompositeShape addChild: dLabel.

	^ dCompositeShape
]

{ #category : #processing }
GeoShapeLabeledProcessData >> processUpdatedData: aKey incoming: aGeoShape with: aDCompositeShape context: aContext [
	| dCompositeShape |
	dCompositeShape := aDCompositeShape.
	super processUpdatedData: aKey incoming: aGeoShape with: dCompositeShape context: aContext.
		
	(aDCompositeShape getChild: #geoShape) ifNotNil: [ :e |
		e fillStyle: aGeoShape fillStyle copy.
		e strokeStyle: aGeoShape strokeStyle copy.	
	].
	
	^ dCompositeShape
]
