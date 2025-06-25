Class {
	#name : #GeoPositionProcessData,
	#superclass : #GeoObjectProcessData,
	#category : #'GeoView-Business - GeoObjects'
}

{ #category : #processing }
GeoPositionProcessData >> processCreatedData: aKey incoming: aGeoPosition with: aDCompositeShape context: aContext [

	| dCompositeShape dImage dLabel |
	dCompositeShape := aDCompositeShape ifNil:[SmockDCompositeShape new].
	super processCreatedData: aKey incoming: aGeoPosition with: dCompositeShape context: aContext.

	"create image"
	dImage := SmockDImage key: #image.
	dImage image: aGeoPosition image.
	dCompositeShape addChild: dImage.

	"create label"
	dLabel := SmockDText key: #text.
	dLabel fillColor: Color white.
	dLabel smockFont: SmockFont defaultFont.
	dLabel text: aGeoPosition text.
	dLabel setTopCenter.
	dLabel coordinatesDeviceOffset: 0 @ -30.
	dCompositeShape addChild: dLabel.
	
	^ dCompositeShape
]

{ #category : #processing }
GeoPositionProcessData >> processUpdatedData: aKey incoming: aGeoPosition with: aDCompositeShape context: aContext [
	
	super processUpdatedData: aKey incoming: aGeoPosition with: aDCompositeShape context: aContext.
	
	(aDCompositeShape getChild: #image) ifNotNil:[ :e |
		e image ~= aGeoPosition image ifTrue:[
			e image: aGeoPosition image.
			aDCompositeShape updateChild: e.
		].
	].

	(aDCompositeShape getChild: #text) ifNotNil:[ :e |
		e text ~= aGeoPosition text ifTrue:[
			e text: aGeoPosition text.
			aDCompositeShape updateChild: e.
		].
	].
	
	^ aDCompositeShape
]
