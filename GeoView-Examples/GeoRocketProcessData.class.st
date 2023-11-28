Class {
	#name : #GeoRocketProcessData,
	#superclass : #GeoObjectProcessData,
	#category : #'GeoView-Examples'
}

{ #category : #processing }
GeoRocketProcessData >> processCreatedData: aKey incoming: aGeoRocket with: aDCompositeShape context: aContext [
	| dCompositeShape dCircle dLabel |
	dCompositeShape := aDCompositeShape ifNil:[SmockDCompositeShape new].
	super processCreatedData: aKey incoming: aGeoRocket with: dCompositeShape context: aContext.
	dCompositeShape key: aKey.
	
	"create a symbol as a circle"
	dCircle := SmockDCircle new.
	dCircle key: #symbol.
	dCircle radius: 1000000.
	dCircle fillColor: Color black.
	dCompositeShape addDShape: dCircle.
	
	"create a label"
	dLabel := SmockDText new.
	dLabel key: #label.
	dLabel fillColor: Color black.
	dLabel fontSize: 11.
	dLabel text: 'Rocket A'.
	dCompositeShape addDShape: dLabel.
	
	^dCompositeShape
]

{ #category : #processing }
GeoRocketProcessData >> processDeletedData: aKey incoming: aGeoRocket with: aDCompositeShape context: aContext [
	^aDCompositeShape
]

{ #category : #processing }
GeoRocketProcessData >> processUpdatedData: aKey incoming: aGeoRocket with: aDCompositeShape context: aContext [
	| dCompositeShape dCircle dLabel |
	dCompositeShape := aDCompositeShape.
	super processUpdatedData: aKey incoming: aGeoRocket with: dCompositeShape context: aContext.
	
	"update symbol"
	dCircle := dCompositeShape getDShape: #symbol.
	dCircle radius: 1000000.
	dCircle fillColor: Color random.
	dCompositeShape updateDShape: dCircle.
	
	"update label"
	dLabel := dCompositeShape getDShape: #label.
	dLabel text: 'Rocket A'.
	dCompositeShape updateDShape: dLabel.
	
	^dCompositeShape
]
