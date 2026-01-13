"
I am a UTM (Universal Transverse Mercator) projection (EPSG:32601-32660 for northern hemisphere, EPSG:32701-32760 for southern hemisphere).
UTM divides the Earth into 60 zones of 6° longitude each.
Each zone uses a Transverse Mercator projection with specific parameters.
"
Class {
	#name : #GeoViewUTMProjection,
	#superclass : #Object,
	#traits : 'TGeoViewMapProjection',
	#classTraits : 'TGeoViewMapProjection classTrait',
	#instVars : [
		'e',
		'e2',
		'e4',
		'e6',
		'k0',
		'zone',
		'isNorthernHemisphere',
		'ePrime2'
	],
	#category : #'GeoView-Projections'
}

{ #category : #instance }
GeoViewUTMProjection class >> absoluteCoordinates: anAbsoluteCoordinates [
	"Create a UTM projection on the zone corresponding to coordinates"

	| zoneNumber isNorth |
	anAbsoluteCoordinates isValid ifFalse: [ ^ nil ].

	zoneNumber := self zoneNumberFor: anAbsoluteCoordinates longitudeInDegrees.
	isNorth := anAbsoluteCoordinates latitudeInDegrees >= 0.

	^ self zone: zoneNumber north: isNorth
]

{ #category : #instance }
GeoViewUTMProjection class >> zone: aZoneNumber [
	"Create a UTM projection for a specific zone (northern hemisphere by default)"

	^ self zone: aZoneNumber north: true
]

{ #category : #instance }
GeoViewUTMProjection class >> zone: aZoneNumber north: aBoolean [
	"Create a UTM projection for a specific zone and hemisphere"

	^ self new
		  zone: aZoneNumber;
		  isNorthernHemisphere: aBoolean;
		  yourself
]

{ #category : #utils }
GeoViewUTMProjection class >> zoneNumberFor: aLongitudeInDegrees [

	^ (aLongitudeInDegrees + 180 / 6) floor + 1
]

{ #category : #accessing }
GeoViewUTMProjection >> centralMeridian [

	^ (zone - 1) * 6 - 180 + 3
]

{ #category : #constants }
GeoViewUTMProjection >> e [
	"First eccentricity"

	^ e
]

{ #category : #constants }
GeoViewUTMProjection >> e2 [
	"First eccentricity squared"

	^ e2
]

{ #category : #constants }
GeoViewUTMProjection >> e4 [
	"First eccentricity to the power 4"

	^ e4
]

{ #category : #constants }
GeoViewUTMProjection >> e6 [
	"First eccentricity to the power 6"

	^ e6
]

{ #category : #constants }
GeoViewUTMProjection >> ePrime2 [
	"Second eccentricity squared: e'² = e² / (1 - e²)"

	^ ePrime2
]

{ #category : #accessing }
GeoViewUTMProjection >> epsgCode [
	"Return EPSG code for this UTM zone"
	
	self isNorthernHemisphere
		ifTrue: [ ^ 32600 + zone ]  "EPSG:32601-32660 for northern hemisphere"
		ifFalse: [ ^ 32700 + zone ] "EPSG:32701-32760 for southern hemisphere"
]

{ #category : #constants }
GeoViewUTMProjection >> falseEastingInMeters [

	^ 500000	
]

{ #category : #constants }
GeoViewUTMProjection >> falseNorthingInMeters [

	^ self isNorthernHemisphere
		  ifTrue: [ 0 ]
		  ifFalse: [ 10000000 ]
]

{ #category : #testing }
GeoViewUTMProjection >> geodesicCrossesValidDomainFrom: aFromAbsoluteCoordinates to: aToAbsoluteCoordinates [
	"Check if geodesic crosses zone boundary or latitude limit"
	
	| fromZone toZone lat1 lat2 |
	(aFromAbsoluteCoordinates isValid not or: [aToAbsoluteCoordinates isValid not]) 
		ifTrue: [ ^ true ].
	
	fromZone := self class zoneNumberFor: aFromAbsoluteCoordinates longitudeInDegrees.
	toZone := self class zoneNumberFor: aToAbsoluteCoordinates longitudeInDegrees.
	
	"Check if crosses zone boundary"
	fromZone ~= toZone ifTrue: [ ^ true ].
	
	"Check latitude limits"
	lat1 := aFromAbsoluteCoordinates latitudeInDegrees abs.
	lat2 := aToAbsoluteCoordinates latitudeInDegrees abs.
	
	^ (lat1 > 84 or: [ lat2 > 84 ])
]

{ #category : #initialization }
GeoViewUTMProjection >> initialize [

	super initialize.
	
	zone := 31. "Default to zone 31 (Western Europe)"
	isNorthernHemisphere := true. 
	
	"Constants"
	k0 := 0.9996.
	
	e := WGS84 eccentricity. 
	e2 := WGS84 eccentricitySquared.
	e4 := e2 squared.
	e6 := e2 * e4.
	ePrime2 := e2 / (1 - e2)
]

{ #category : #testing }
GeoViewUTMProjection >> isAbsoluteCoordinatesOutsideProjectionLimit: anAbsoluteCoordinates [
	"Check if coordinates are outside UTM valid range"

	| lat |
	anAbsoluteCoordinates isValid ifFalse: [ ^ true ].

	lat := anAbsoluteCoordinates latitudeInDegrees abs.
	lat > 84 ifTrue: [ ^ true ].

	^ false
]

{ #category : #accessing }
GeoViewUTMProjection >> isNorthernHemisphere [

	^ isNorthernHemisphere
]

{ #category : #accessing }
GeoViewUTMProjection >> isNorthernHemisphere: aBoolean [

	isNorthernHemisphere := aBoolean
]

{ #category : #constants }
GeoViewUTMProjection >> k0 [ 
	"Scale factor at central meridian"
	
	^ k0
]

{ #category : #accessing }
GeoViewUTMProjection >> key [

	^ #GeoViewUTMProjection
]

{ #category : #private }
GeoViewUTMProjection >> meridianArc: aLatitudeInRadians [
	"Calculate meridian arc length"

	| a n n2 n3 n4 n5 A B C D E lat2 lat4 lat6 lat8 |
	a := WGS84 semiMajorAxisInMeters.
	n := WGS84 flattening / (2 - WGS84 flattening).
	n2 := n * n.
	n3 := n2 * n.
	n4 := n3 * n.
	n5 := n4 * n.

	A := a / (1 + n) * (1 + (n2 / 4) + (n4 / 64)).

	lat2 := 2 * aLatitudeInRadians.
	lat4 := 4 * aLatitudeInRadians.
	lat6 := 6 * aLatitudeInRadians.
	lat8 := 8 * aLatitudeInRadians.

	B := 3 * n / 2 - (27 * n3 / 32) + (269 * n5 / 512).
	C := 21 * n2 / 16 - (55 * n4 / 32).
	D := 151 * n3 / 96 - (417 * n5 / 128).
	E := 1097 * n4 / 512.

	^ A * (aLatitudeInRadians - (B * lat2 sin) + (C * lat4 sin)
		   - (D * lat6 sin) + (E * lat8 sin))
]

{ #category : #accessing }
GeoViewUTMProjection >> name [

	^ 'Universal Transverse Mercator'
]

{ #category : #projection }
GeoViewUTMProjection >> projCartToLatLon: aCartesianCoordinates [
	"Convert UTM coordinates to latitude/longitude"
	
	| x y M mu phi1 e1 e12 e13 e14 C1 C2 C3 C4 N1 T1 R1 D D2 D3 D4 D5 D6 lat lon |
	(aCartesianCoordinates isEmpty or: [
		 aCartesianCoordinates isValid not ]) ifTrue: [ ^ nil ].
	
	x := aCartesianCoordinates xInMeters - self falseEastingInMeters.
	y := aCartesianCoordinates yInMeters - self falseNorthingInMeters.
	
	M := y / self k0.
	mu := M / (WGS84 semiMajorAxisInMeters * (1 - (self e2 / 4) - (3 * self e4 / 64) - (5 * self e6 / 256))).
	
	e1 := (1 - ((1 - self e2) sqrt)) / (1 + ((1 - self e2) sqrt)).
	e12 := e1 * e1.
	e13 := e12 * e1.
	e14 := e13 * e1.
	
	C1 := 3 * e1 / 2 - (27 * e13 / 32).
	C2 := 21 * e12 / 16 - (55 * e14 / 32).
	C3 := 151 * e13 / 96.
	C4 := 1097 * e14 / 512.
	
	phi1 := mu + (C1 * (2 * mu) sin) + (C2 * (4 * mu) sin) + (C3 * (6 * mu) sin) + (C4 * (8 * mu) sin).
	
	N1 := WGS84 semiMajorAxisInMeters / ((1 - (self e2 * phi1 sin squared)) sqrt).
	T1 := phi1 tan squared.
	R1 := WGS84 semiMajorAxisInMeters * (1 - self e2) / ((1 - (self e2 * phi1 sin squared)) raisedTo: 1.5).
	D := x / (N1 * self k0).
	D2 := D * D.
	D3 := D2 * D.
	D4 := D3 * D.
	D5 := D4 * D.
	D6 := D5 * D.
	
	lat := phi1 - ((N1 * phi1 tan / R1) * 
		(D2 / 2 - 
		((5 + (3 * T1) + (10 * self e2 * phi1 cos squared) - (4 * self e2 * phi1 cos squared squared) - (9 * self e2)) * D4 / 24) +
		((61 + (90 * T1) + (298 * self e2 * phi1 cos squared) + (45 * T1 squared) - (252 * self e2) - (3 * self e2 * phi1 cos squared squared)) * D6 / 720))).
	
	lon := self centralMeridian degreesToRadians + 
		((D - ((1 + (2 * T1) + (self e2 * phi1 cos squared)) * D3 / 6) +
		((5 - (2 * self e2 * phi1 cos squared) + (28 * T1) - (3 * self e2 * phi1 cos squared squared) + (8 * self e2) + (24 * T1 squared)) * D5 / 120)) / phi1 cos).
	
	^ AbsoluteCoordinates latitudeInRadians: lat longitudeInRadians: lon altitudeInMeters: aCartesianCoordinates zInMeters
]

{ #category : #projection }
GeoViewUTMProjection >> projLatLonToCart: anAbsoluteCoordinates [
	"Convert latitude/longitude to UTM coordinates"
	
	| lat lon lambda N T C A M x y |
	
	(anAbsoluteCoordinates isEmpty or: [anAbsoluteCoordinates isValid not]) 
		ifTrue: [ ^ nil ].
	
	"UTM is not valid near poles (beyond ±84°)"
	(self isAbsoluteCoordinatesOutsideProjectionLimit: anAbsoluteCoordinates)
		ifTrue: [ ^ nil ].
	
	lat := anAbsoluteCoordinates latitudeInRadians.
	lon := anAbsoluteCoordinates longitudeInRadians.
	lambda := lon - self centralMeridian degreesToRadians.
	
	N := WGS84 semiMajorAxisInMeters / ((1 - (self e2 * lat sin squared)) sqrt).
	T := lat tan squared.
	C := self ePrime2 * lat cos squared.
	A := lambda * lat cos.
	
	M := self meridianArc: lat.
	
	x := self k0 * N * (A + 
		((1 - T + C) * A * A * A / 6) +
		((5 - (18 * T) + (T * T) + (72 * C) - (58 * self e2)) * A * A * A * A * A / 120)).
	
	y := self k0 * (M + (N * lat tan * (
		(A * A / 2) +
		((5 - T + (9 * C) + (4 * C * C)) * A * A * A * A / 24) +
		((61 - (58 * T) + (T * T) + (600 * C) - (330 * self e2)) * A * A * A * A * A * A / 720)))).
	
	^ CartesianCoordinates xInMeters: x + self falseEastingInMeters yInMeters: y + self falseNorthingInMeters zInMeters: anAbsoluteCoordinates altitudeInMeters
]

{ #category : #testing }
GeoViewUTMProjection >> sideOfAbsoluteCoordinates: anAbsolutePosition [
	"Return the position relative to this UTM zone"

	| coordZone lat |
	anAbsolutePosition isValid ifFalse: [ ^ GeoViewMapProjectionSide outOfProjection ].

	lat := anAbsolutePosition latitudeInDegrees.

	"Check latitude limits"
	lat abs > 84 ifTrue: [
			^ lat > 0
				  ifTrue: [ GeoViewMapProjectionSide outsideLatitudeLimitTop ]
				  ifFalse: [ GeoViewMapProjectionSide outsideLatitudeLimitBottom ] ].

	"Check hemisphere"
	(lat >= 0 and: [ self isNorthernHemisphere not ]) ifTrue: [
		^ GeoViewMapProjectionSide wrongUTMHemisphere ].
	(lat < 0 and: [ self isNorthernHemisphere ]) ifTrue: [ ^ GeoViewMapProjectionSide wrongUTMHemisphere ].

	"Check zone"
	coordZone := self class zoneNumberFor:
		             anAbsolutePosition longitudeInDegrees.
	coordZone = self zone ifFalse: [
			^ coordZone < self zone
				  ifTrue: [ GeoViewMapProjectionSide leftOfUTMZone ]
				  ifFalse: [ GeoViewMapProjectionSide rightOfUTMZone ] ].

	^ GeoViewMapProjectionSide insideUTMZone 
]

{ #category : #accessing }
GeoViewUTMProjection >> zone [

	^ zone
]

{ #category : #accessing }
GeoViewUTMProjection >> zone: anInteger [
	"Set the UTM zone (1-60)"

	(anInteger between: 1 and: 60) ifFalse: [ ^ self ].

	zone := anInteger
]

{ #category : #accessing }
GeoViewUTMProjection >> zoneLetter [
	"Return the UTM zone letter (C-X, excluding I and O)"

	"Simplified - returns N for north, S for south"

	^ self isNorthernHemisphere
		  ifTrue: [ 'N' ]
		  ifFalse: [ 'S' ]
]
