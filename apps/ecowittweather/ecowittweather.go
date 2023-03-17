// Package ecowittweather provides details for the Ecowitt Weather applet.
package ecowittweather

import (
	_ "embed"

	"tidbyt.dev/community/apps/manifest"
)

//go:embed ecowitt_weather.star
var source []byte

// New creates a new instance of the Ecowitt Weather applet.
func New() manifest.Manifest {
	return manifest.Manifest{
		ID:          "ecowitt-weather",
		Name:        "Ecowitt Weather",
		Author:      "adelcambre",
		Summary:     "Ecowitt Weather Station",
		Desc:        "Display current time and weather data from your ecowitt weather station.",
		FileName:    "ecowitt_weather.star",
		PackageName: "ecowittweather",
		Source:  source,
	}
}
