#include <SoftwareSerial.h>
#include <LunaController_MIDI.h>
#include <Adafruit_NeoPixel.h>


#define NEOPIXEL_PIN 7
#define NEOPIXEL_COUNT 144
#define PIXEL_DELAY_TIME 5

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NEOPIXEL_COUNT, NEOPIXEL_PIN, NEO_GRB + NEO_KHZ800);

SoftwareSerial midiSerial(2, 3);
LunaController_MIDI<SoftwareSerial> luna(midiSerial, 1);

uint8_t g_red = 0;
uint8_t g_green = 0;
uint8_t g_blue = 0;
uint8_t g_brightness = 0;

void setup()
{
  Serial.begin(9600);
  Serial.println(luna.setCallback(&handle));
	
	strip.begin();
  strip.show();
}

void loop()
{
  luna.poll();
}

void handle(lunachannel_t channel, lunachannelvalue_t value)
{
	Serial.print("Luna channel ");
	Serial.print(channel);
	Serial.print(" = ");
	Serial.println(value);

	switch(channel)
	{
		case 0:
			g_brightness = value;
			break;
		case 1:
			g_red = value;
			break;
		case 2:
			g_green = value;
			break;
		case 3:
			g_blue = value;
			break;
		default:
			return;
	}

	set_strip(g_red, g_green, g_blue, g_brightness);
}

void set_strip(uint8_t r, uint8_t g, uint8_t b, uint8_t brt)
{
  strip.setBrightness(brt);
  strip.show();

  for(uint16_t i = 0; i < strip.numPixels(); i++)
  {
    strip.setPixelColor(i, strip.Color(r, g, b));
    strip.show();
    delay(PIXEL_DELAY_TIME);
  }
}