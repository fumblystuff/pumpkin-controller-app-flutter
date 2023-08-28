# Pumpkin Controller (Flutter)

## Tasks

- [ ] Check for Web platform before sending command (not supported for UDP)
- [ ] 

## Introduction

The controller application for the [Glowing Pumpkin Xiao 5x5 BFF Server](https://github.com/johnwargo/glowing-pumpkin-xiao-bff-server). This is a full featured application written in Flutter that you can deploy to a mobile device (Android and iOS) or a web server. You can even run the application locally from Android Studio or Visual Studio Code (with the required Flutter SDK installed).

Use the application to:

* Start and stop the remote device displaying random colors
* Flash the remote device's LED matrix a random number of times white, like lightning flashes.
* Set a solid color
* Flash the LED matrix a solid color from 1 to 5 times.

Here's a screenshot of the application's home page:

![Home Page Image](images/home.png)

## Configuration

Before you can use the app to control a remote device, you must first configure the app with the IP Address of the remote device. To do this, tap the gear icon on the upper-right corner of the app's main screen (the previous image). When the settings page opens, enter the remote device's IP address in the input field as shown below, then tap the left arrow to return to the app's main screen.

![Settings Page](images/settings.png)

## Operation

Tap the **All Off** button to turn off the LED Matrix on the remote device.

Tap the **Random** button to instruct the remote device to display random colors for a random number of seconds before switching colors.

Tap the **Lightning** button to direct the remote device to flash the LEDs white a random number of times. At the conclusion, the remote device enables random mode.

To use colors, select a value from the dropdown list, then tap the appropriate color button for the color you want displayed on the remote device:

* Selecting **Solid (no flash)** sets all LEDs on the remote device to the selected color.
* Selecting any of the other options in the dropdown field flashes the selected color the number of times specified in the dropdown then enables random color mode on the device.

## Mobile App

I published the project here with full source code so developers familiar with Flutter development can deploy the application on their mobile phones. Reach out to let me know if you'd like me to publish the app to the App Stores (Apple and/or Google), and I'll try to make that happen.

