load("render.star", "render")
load("schema.star", "schema")
load("time.star", "time")
load("encoding/base64.star", "base64")

NONE_IMAGE = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAAB1JREFUGFdj
ZMADGCmT/P///390ExhBgDJjcekGALm2BAjYvumLAAAAAElFTkSuQmCC
""")

def main(config):
  print("Falling back to time only view, the other script failed")
  timezone = config.get("timezone") or "America/Denver"
  now = time.now().in_location(timezone)

  wind_image = NONE_IMAGE
  temp = "-"
  common = {}

  conditions_row = [
                        render.Text("- G-"),
                        render.Image(src=wind_image),
                      ]

  return render.Root(
      delay = 500,
      child = render.Box(
          padding = 0,
          child = render.Column(
              expanded = True,
              main_align = "space_around",
              cross_align = "center",
              children = [
                  render.Row(
                      expanded = True,
                      main_align = "space_around",
                      children = [
                        render.Text(
                          content = now.format("15:04"),
                          font = "6x13",
                        ),
                        render.Text(
                            content = "%s°" % str(temp),
                            color = "#fff",
                            font = "6x13",
                        ),
                      ],
                  ),
                  render.Row(
                      expanded = True,
                      main_align = "center",
                      children = conditions_row,
                  ),
              ],
          ),
      ),
  )

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Text(
                id = "ip_address",
                name = "IP Address",
                desc = "What is the IP Address of your ecowitt?",
                icon = "globe",
            ),
        ],
    )
