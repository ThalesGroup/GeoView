Class {
	#name : #GeoViewUtils,
	#superclass : #Object,
	#category : #'GeoView-Core'
}

{ #category : #'layer creation' }
GeoViewUtils class >> createGeoObjectsLayer: aName [
	"Create a layer to display GeoObjects"

	| layer |
	layer := GeoViewDomainObjectsLayer new name: aName.

	layer setProcessData: GeoCircleProcessData new forClass: GeoCircle.
	layer setProcessData: GeoEllipseProcessData new forClass: GeoEllipse.
	layer setProcessData: GeoSegmentProcessData new forClass: GeoSegment.
	layer setProcessData: GeoPolygonProcessData new forClass: GeoPolygon.
	layer setProcessData: GeoPolylineProcessData new forClass: GeoPolyline.
	layer setProcessData: GeoRectangleProcessData new forClass: GeoRectangle.
	layer setProcessData: GeoArcBandProcessData new forClass: GeoArcBand.
	layer setProcessData: GeoTextProcessData new forClass: GeoText.
	layer setProcessData: GeoPositionProcessData new forClass: GeoPosition.

	^ layer
]

{ #category : #'geoview creation' }
GeoViewUtils class >> createGeoView [

	^ GeoViewAeElement new
]

{ #category : #'geoview creation' }
GeoViewUtils class >> createGeoViewForGeoObjects [

	| element |
	element := self createGeoView.
	element addLayer: (self createGeoObjectsLayer: #GeoObjectsLayer).
	^ element
]

{ #category : #'geoview creation' }
GeoViewUtils class >> createGeoViewForGeoObjectsWithOSM [

	| element |
	element := self createGeoView.
	element addLayer: (GeoViewMapTilesLayer newWithOpenStreetMap name: #OSMTilesLayer).
	element addLayer: (self createGeoObjectsLayer: #GeoObjectsLayer).
	^ element
]

{ #category : #'see class side' }
GeoViewUtils >> seeClassSide [ 
]
