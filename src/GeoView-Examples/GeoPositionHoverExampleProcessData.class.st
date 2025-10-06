Class {
	#name : #GeoPositionHoverExampleProcessData,
	#superclass : #GeoPositionProcessData,
	#category : #'GeoView-Examples-Utils'
}

{ #category : #processing }
GeoPositionHoverExampleProcessData >> processCreatedData: aKey incoming: aGeoPosition with: aDCompositeShape context: aContext [

	| dLabel dCompositeShape |
	dCompositeShape := super processCreatedData: aKey incoming: aGeoPosition with: aDCompositeShape context: aContext.
	
	"initialize default property value"
	dCompositeShape setProperty: #hover value: false. 

	"setup the label visibility to false"
	dLabel := dCompositeShape getChild: #text.
	dLabel smockFont fontSize: 20.
	dLabel isVisible: false.
	
	^ dCompositeShape
]

{ #category : #processing }
GeoPositionHoverExampleProcessData >> processStateChanged: aKey state: aState value: aValueOrNil with: aDShape context: aContext [

	| dCompositeShape dLabel |
	dCompositeShape := super processStateChanged: aKey state: aState value: aValueOrNil with: aDShape context: aContext.

	"process hover state"
	aState = #hover ifTrue:[
		dCompositeShape setProperty: aState value: (aValueOrNil ifNil:[ false ]). 
		dLabel := dCompositeShape getChild: #text.
		"setup the label visibility"
		dLabel isVisible: (dCompositeShape getProperty: aState).
		dCompositeShape updateChild: dLabel.
		aValueOrNil traceCr.
	].

	^ aDShape
]
