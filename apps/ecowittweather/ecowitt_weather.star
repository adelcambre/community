load("render.star", "render")
load("http.star", "http")
load("schema.star", "schema")
load("encoding/base64.star", "base64")
load("time.star", "time")

ECOWITT_PATH = "/get_livedata_info"

LIGHTNING_IMAGE_1 = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAADVJREFUGFdj
ZEAC/z8x/EfmM8I4GBJ8DIxYJRn5GMDiYAJdF1gCWSeyIhSd2CQwjIXpgDkSAJ8gFPicOq/TAAAA
AElFTkSuQmCC
""")

LIGHTNING_IMAGE_2 = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAADhJREFUGFdj
ZEAC/z8x/GfkY2CECcEZIAmQIE5JZAmwQhAB04VsBUgh3FiYBLLxWCVhxqNIorsWAHAvFQjtrG3P
AAAAAElFTkSuQmCC
""")

W_IMAGE = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAACpJREFUGFdj
ZMADGNHl/v///5+RkREsjiEJEoQpYAQxcJmMXyfJdsI0AADAWhQEvJ/ACgAAAABJRU5ErkJggg==
""")

S_IMAGE = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAACxJREFUGFdj
ZEAC/////8/IyMgIE4IzQBJwQagCsCRMBzoN14msCMNY6koCAEIoJAhhZ0rYAAAAAElFTkSuQmCC
""")

SW_IMAGE = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAADlJREFUGFdj
ZEAC/////4/MZ0TmwNgwRRiSIAlGRkZGMI1uLEgCJIYiCdOBYSc2CZAiiNlQo9AdBwCF6SP4vk56
IgAAAABJRU5ErkJggg==
""")

SE_IMAGE = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAADVJREFUGFdt
zLENADAIA8H8/kMbUTgyJHTwJ5CkEwPgFcc8jtih0QbjuMH971cJntjI4BsNCi4OJAS5FAezAAAA
AElFTkSuQmCC
""")

N_IMAGE = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAACtJREFUGFdj
ZEAC/////8/IyMgIE4IzQAJUloQZh07D7QRJwB0CdRReBwEAcgokCLdj1UkAAAAASUVORK5CYII=
""")

NW_IMAGE = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAADFJREFUGFdj
/P///39GRkZGBiwALIhLAVwHNgUoxiErALPRrYIpwCoJcwOIxjAW2SQAo0oj+FJAe2EAAAAASUVO
RK5CYII=
""")

NE_IMAGE = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAADFJREFUGFdj
ZMAB/v///58RmxxYAgTQJWESIHFGZA4yG0USXQIuCWZgsQJsLLK9yIoAQ0ckBBXMeCAAAAAASUVO
RK5CYII=
""")

E_IMAGE = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAACpJREFUGFdj
ZMADGGFy/////8/IyAjng8TBHGwSYEmQBC6T8eskaCcuYwGAaRQEz+1VqAAAAABJRU5ErkJggg==
""")

NONE_IMAGE = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAAB1JREFUGFdj
ZMADGCmT/P///390ExhBgDJjcekGALm2BAjYvumLAAAAAElFTkSuQmCC
""")

TEMP="0x02"
# "val": "63.0",
# "unit": "F"
HUMIDITY="0x07"
# "val": "50%"
FEELS_LIKE="3"
# "val": "63.0",
# "unit": "F"
DEW_POINT="0x03"
# "val": "44.1",
# "unit": "F"
WIND_CHILL="0x04"
# "val": "63.0",
# "unit": "F"
WIND_SPEED="0x0B"
# "val": "3.36 mph"
WIND_GUST="0x0C"
# "val": "4.03 mph"
WIND_MAX="0x19"
# "val": "20.36 mph"
SOLAR_RAD="0x15"
# "val": "477.11 W/m2"
UV_INDEX="0x17"
# "val": "4"
WIND_DIR="0x0A"
# "val": "90",
# "battery": "5"
RAIN_EVENT="0x0D"
RAIN_RATE="0x0E"
RAIN_DAY="0x10"
RAIN_WEEK="0x11"
RAIN_MONTH="0x12"
RAIN_YEAR="0x13"

def main(config):
  ip=config.str("ip_address")
  print("IP Address: %r" % ip)

  if not ip:
    fail("Did not get ip address")
    return

  timezone = config.get("timezone") or "America/Denver"
  now = time.now().in_location(timezone)


  ecowitt_url = "http://%s%s" % (ip, ECOWITT_PATH)
  rep = http.get(ecowitt_url)
  if rep.status_code != 200:
    fail("Ecowitt request failed with status %d", rep.status_code)

  json = rep.json()

  common = translate_common(json)

  wind_dir = common.get(WIND_DIR)
  wind_image = NONE_IMAGE
  if wind_dir != None and wind_dir != "---":
    wind_image=wind_direction(int(wind_dir))


  temp_str = common.get(TEMP)
  temp = "-"
  if temp_str != None and temp_str != "--.-":
    temp = int(float(temp_str))

  conditions_row = [
                        render.Text("%s G%s" % (wind_speed(common, WIND_SPEED),
                          wind_speed(common, WIND_GUST))),
                        render.Image(src=wind_image),
                      ]

  rain = rain_rate(json)

  if rain != None:
    print("Raining")
    conditions_row.append(render.Text(content = "%s" % str(rain),
                                      color = "#8080ff"))
  else:
    print("Not raining")

  if check_lightning(json):
    print("Recent Lightning")
    conditions_row.append(render.Image(src=LIGHTNING_IMAGE_2))
  else:
    print("No Recent Lightning")

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
                            color = color_temp(temp),
                            font = "6x13",
                        ),
                        # render.Text(
                        #   content = now.format("1/2"),
                        #   font = "6x13",
                        # )
                      ],
                  ),
                  # render.Row(
                  #     expanded = True,
                  #     main_align = "space_around",
                  #     children = [
                  #         render.Text(
                  #             content = str(temp),
                  #             color = color_temp(temp),
                  #         ),
                  #         render.Text(
                  #             content = common[HUMIDITY],
                  #             color = "#66f",
                  #         ),
                  #         render.Text(
                  #             content = "UV%s" % common[UV_INDEX],
                  #             color = "#ff0",
                  #         ),
                  #     ],
                  # ),
                  render.Row(
                      expanded = True,
                      main_align = "center",
                      children = conditions_row,
                  ),
              ],
          ),
      ),
  )


def wind_direction(heading):
  print("Wind direction: %i" % heading)
  if heading <= 360 and heading >= 337.5:
    print("North")
    return N_IMAGE
  elif heading >= 0 and heading <= 22.5:
    print("North")
    return N_IMAGE
  elif heading >= 22.5 and heading <= 67.5:
    print("North East")
    return NE_IMAGE
  elif heading >= 67.5 and heading <= 112.5:
    print("East")
    return E_IMAGE
  elif heading >= 112.5 and heading <= 157.5:
    print("South East")
    return SE_IMAGE
  elif heading >= 157.5 and heading <= 202.5:
    print("South")
    return S_IMAGE
  elif heading >= 202.5 and heading <= 247.5:
    print("South West")
    return SW_IMAGE
  elif heading >= 247.5 and heading <= 292.5:
    print("West")
    return W_IMAGE
  elif heading >= 292.5 and heading <= 337.5:
    print("North West")
    return NW_IMAGE

  print("None")
  return NONE_IMAGE

def translate_common(json, key="common_list"):
  common = json.get(key)
  if common == None:
    return {}

  out = {}
  for elem in common:
    out[elem["id"]] = elem["val"]

  return out

def wind_speed(input, key):
  speed_str = input.get(key)
  if speed_str == None or speed_str == "--.-":
    return "-"

  speed = speed_str.removesuffix("mph").strip()

  return int(float(speed))

def rain_rate(input):
  rain_info = translate_common(input, "rain")
  rain_str = rain_info.get(RAIN_RATE)
  if rain_str == None:
    return None

  rain = rain_str.removesuffix("in/Hr").strip()
  if rain == "0.00":
    return None

  return rain

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


def color_temp(temp):
  if temp == "-":
    return "#fff"

  t = int(float(temp))
  if t > 100:
    return "#fff"
  elif t >= 90 and t < 100:
    return "#f00"
  elif t >= 80 and t < 90:
    return "#ffa500"
  elif t >= 60 and t < 80:
    return "#ff0"
  elif t > 40 and t <= 60:
    return "#0f0"
  elif t > 20 and t <= 40:
    return "#8080ff"
  elif t <= 20:
    return "#fff"

def check_lightning(json):
  lightning=json.get("lightning")
  if lightning == None:
    return False
  lightning = lightning[0]
  ts = lightning.get("timestamp")
  if ts == None:
    return False
  if ts == "--/--/---- --:--:--":
    return False
  last_lightning = time.parse_time(x=ts, format="01/02/2006 15:04:05", location="America/Denver")
  print("Last lightning timestamp: %s" % last_lightning)
  print("Now: %s" % time.now())
  last_lightning_ago = time.now() - last_lightning
  print("Last lightning: %s" % last_lightning_ago)
  thirty_minutes = time.parse_duration("30m")
  return last_lightning_ago < thirty_minutes
