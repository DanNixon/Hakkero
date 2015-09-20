#include <EEPROM.h>
#include <SoftwareSerial.h>
#include <LunaController_MIDI.h>
#include <Adafruit_NeoPixel.h>
#include <UniversalInputManager.h>
#include <ArduinoButton.h>

#define DEBUG_BAUD 9600

#define BRIGHTNESS  0
#define RED         1
#define GREEN       2
#define BLUE        3

#define NEOPIXEL_PIN      7
#define NEOPIXEL_COUNT    144
#define PIXEL_DELAY_TIME  5

Adafruit_NeoPixel strip = Adafruit_NeoPixel(NEOPIXEL_COUNT, NEOPIXEL_PIN, NEO_GRB + NEO_KHZ800);

SoftwareSerial midiSerial(2, 3);
LunaController_MIDI<SoftwareSerial> luna(midiSerial, 1);

UniversalInputManager switchManager;

#define MODE_PRESET 			0b00000000
#define MODE_WHEEL 				0b00000001
#define MODE_LUNA_RGB 		0b00000010
#define MODE_LUNA_RGB_SEG 0b00000011

uint8_t g_mode = MODE_PRESET;

#define PRESET_EEPROM_ADDR 0

#define NUM_PRESETS 8
uint8_t g_presets[NUM_PRESETS][4] =
  {
    {100, 255, 0,   0, },
    {100, 0,   255, 0, },
    {100, 0,   0,   255},

    {100, 255, 255, 0, },
    {100, 0,   255, 255},
    {100, 255, 0,   255},

    {100, 255, 255, 255},
    {200, 255, 255, 255}
  };

uint8_t g_lunaSettings[4];

void update_mode(inputtype_t type = UIT_BUTTON, IInputDevice * device = NULL);

void setup()
{
#ifdef DEBUG_BAUD
  Serial.begin(DEBUG_BAUD);
#endif
  uint8_t result;
  
  result = luna.setCallback(&luna_handler);
#ifdef DEBUG_BAUD
  Serial.println(result);
#endif
	
	result = switchManager.addDevice(new ArduinoButton(0, 4));
#ifdef DEBUG_BAUD
  Serial.println(result);
#endif

	result = switchManager.addDevice(new ArduinoButton(1, 5));
#ifdef DEBUG_BAUD
  Serial.println(result);
#endif
	
  memset(g_lunaSettings, 4, 0);
  
	strip.begin();
  strip.show();
  
  // Set initial state
  switchManager.poll();
  update_mode();
  
  switchManager.setCallback(update_mode);
}

void loop()
{
  switchManager.poll();
  
  if((g_mode == MODE_LUNA_RGB) || (g_mode == MODE_LUNA_RGB_SEG))
    luna.poll();
	
	if(g_mode == MODE_WHEEL)
	{
		// This is the Adafruit rainbow demo from their library
    // See: https://github.com/adafruit/Adafruit_NeoPixel
    uint16_t i, j;
    for(j=0; j<256; j++)
    {
      // Allow breaking out of this long loop
      switchManager.poll();
      if(g_mode != MODE_WHEEL)
        break;
      
      for(i=0; i<strip.numPixels(); i++)
        strip.setPixelColor(i, wheel((i+j) & 255));
      strip.show();
      delay(25);
    }
	}
}

void luna_handler(lunachannel_t channel, lunachannelvalue_t value)
{
#ifdef DEBUG_BAUD
	Serial.print("Luna channel ");
	Serial.print(channel);
	Serial.print(" = ");
	Serial.println(value);
#endif

	if(channel <= BLUE)
    g_lunaSettings[channel] = value;
  else
    return;

	set_strip(g_lunaSettings[RED], g_lunaSettings[GREEN], g_lunaSettings[BLUE], g_lunaSettings[BRIGHTNESS]);
}

void update_mode(inputtype_t type, IInputDevice * device)
{
  uint8_t modeSw1 = ((IButton *) switchManager.getDevice(0))->isActive();
  uint8_t modeSw2 = ((IButton *) switchManager.getDevice(1))->isActive();
  g_mode = (modeSw2 << 1) + modeSw1;

#ifdef DEBUG_BAUD
  Serial.print("Mode: ");
  Serial.println(g_mode);
#endif

	switch(g_mode)
  {
    case MODE_PRESET:
    {
      uint8_t preset = get_preset();
#ifdef DEBUG_BAUD
      Serial.print("Preset: ");
      Serial.println(preset);
#endif
      uint8_t *preset_data = g_presets[preset];
      set_strip(preset_data[RED], preset_data[GREEN], preset_data[BLUE], preset_data[BRIGHTNESS]);
      break;
    }
    case MODE_LUNA_RGB:
      set_strip(g_lunaSettings[RED], g_lunaSettings[GREEN], g_lunaSettings[BLUE], g_lunaSettings[BRIGHTNESS]);
      break;
    case MODE_LUNA_RGB_SEG:
      set_strip(0, 0, 0, 0);
      break;
  }
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

uint8_t get_preset()
{
  uint8_t preset = EEPROM.read(PRESET_EEPROM_ADDR);
  preset++;
  if(preset >= NUM_PRESETS)
    preset = 0;
  EEPROM.write(PRESET_EEPROM_ADDR, preset);
  return preset;
}

uint32_t wheel(byte wheel_pos)
{
  if(wheel_pos < 85)
  {
    return strip.Color(wheel_pos * 3, 255 - wheel_pos * 3, 0);
  }
  else if(wheel_pos < 170)
  {
    wheel_pos -= 85;
    return strip.Color(255 - wheel_pos * 3, 0, wheel_pos * 3);
  }
  else
  {
    wheel_pos -= 170;
    return strip.Color(0, wheel_pos * 3, 255 - wheel_pos * 3);
  }
}