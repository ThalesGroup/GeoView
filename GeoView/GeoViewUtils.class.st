Class {
	#name : #GeoViewUtils,
	#superclass : #Object,
	#category : #'GeoView-Utils'
}

{ #category : #'layer creation' }
GeoViewUtils class >> createGeoObjectsLayer: aName [
	"Create a layer to display GeoObjects"

	| layer |
	layer := GeoViewUserToDisplayToGraphicLayer new layerName: aName.

	layer setProcessData: GeoCircleProcessData new for: GeoCircle.
	layer setProcessData: GeoEllipseProcessData new for: GeoEllipse.
	layer setProcessData: GeoPolygonProcessData new for: GeoPolygon.
	layer setProcessData: GeoPolylineProcessData new for: GeoPolyline.
	layer setProcessData: GeoRectangleProcessData new for: GeoRectangle.
	layer setProcessData: GeoArcBandProcessData new for: GeoArcBand.
	layer setProcessData: GeoTextProcessData new for: GeoText.

	^ layer
]
