Class {
	#name : #GeoPositionHoverExampleProcessData,
	#superclass : #GeoPositionProcessData,
	#category : #'GeoView-Examples-Utils'
}

{ #category : #processing }
GeoPositionHoverExampleProcessData >> processCreatedData: aKey incoming: aGeoPosition with: aDCompositeShape context: aContext [

	| dLabel dCompositeShape |
	dCompositeShape := super processCreatedData: aKey incoming: aGeoPosition with: aDCompositeShape context: aContext.
	
	dLabel := dCompositeShape getChild: #text.
	dLabel smockFont fontSize: 20.
	
	"setup the label visibility to false by default"
	dLabel isVisible: false.
	
	^ dCompositeShape
]

{ #category : #processing }
GeoPositionHoverExampleProcessData >> processStateChanged: aKey state: aState value: aValueOrNil with: aDShape context: aContext [

	| dCompositeShape dLabel |
	dCompositeShape := super processStateChanged: aKey state: aState value: aValueOrNil with: aDShape context: aContext.

	"process hover state"
	aState = #hover ifTrue:[ | isHover |
		
		isHover := aValueOrNil ifNil:[ false ].
		
		dLabel := dCompositeShape getChild: #text.
		"change label visibility"
		dLabel isVisible: isHover.
		dCompositeShape updateChild: dLabel.
		
		dCompositeShape zIndex: (isHover ifTrue:[ 100 ]). "have a high zIndex to be placed on top"
	].

	^ aDShape
]
