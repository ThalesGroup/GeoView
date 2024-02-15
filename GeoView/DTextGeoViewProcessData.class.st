Class {
	#name : #DTextGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewProcessData,
	#category : #'GeoView-GShape-ProcessData'
}

{ #category : #private }
DTextGeoViewProcessData >> computePositionFor: aDShape context: aContext [
	"Return a pixel position from an axis coordinates, ignore z axis"

	| position |
	position := super computePositionFor: aDShape context: aContext.
	
	aDShape coordinatesDeviceOffset ifNotNil: [ :offset |
		position := (position ifNil:[ 0@0 ]) + offset.
	].
	
	^ position
]

{ #category : #private }
DTextGeoViewProcessData >> createGShape2D [ 

	^ SmockGText2D new
]

{ #category : #processing }
DTextGeoViewProcessData >> processUpdatedData: aKey incoming: aDText with: aGText2D context: aContext [
	
	super processUpdatedData: aKey incoming: aDText with: aGText2D context: aContext.
	
	aGText2D text: aDText text.
	aGText2D smockFont: aDText smockFont.
	aGText2D xAlign: aDText xAlign.
	aGText2D yAlign: aDText yAlign.
		
	^ aGText2D 
]
