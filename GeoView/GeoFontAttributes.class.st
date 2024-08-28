"
Font attributes for configure Text display
"
Class {
	#name : #GeoFontAttributes,
	#superclass : #Object,
	#category : #'GeoView-Deprecated'
}

{ #category : #'font-emphasis' }
GeoFontAttributes class >> fontEmphasisItalic [

	^#italic
]

{ #category : #'font-emphasis' }
GeoFontAttributes class >> fontEmphasisLight [

	^#light
]

{ #category : #'font-emphasis' }
GeoFontAttributes class >> fontEmphasisNormal [

	^#normal
]

{ #category : #'font-emphasis' }
GeoFontAttributes class >> fontEmphasisOblique [

	^#oblique
]

{ #category : #'font-weight' }
GeoFontAttributes class >> fontWeightBold [

	^#bold
]

{ #category : #'font-weight' }
GeoFontAttributes class >> fontWeightNormal [

	^#normal
]

{ #category : #'font-weight' }
GeoFontAttributes class >> fontWeightThin [

	^#thin
]

{ #category : #'font-emphasis' }
GeoFontAttributes class >> isDeprecated [ 

	"use SmockFont"
	^ true
]
