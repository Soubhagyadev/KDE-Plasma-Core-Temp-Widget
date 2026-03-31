# Core Temp Widget

This project provides a custom widget for KDE Plasma 6. It displays your CPU core temperatures on your taskbar. It relies on the generic sensors package to read your hardware data securely.

## Project Structure

* metadata.json : The required Plasma properties and description file.
* contents/ui/main.qml : The central user interface logic that displays your temperatures.
* contents/ui/configAppearance.qml : The visual layout of the custom settings page.
* contents/config/main.xml : The default configuration data mapping and backend values.
* contents/config/config.qml : The application settings registry linking the entire widget together.

## Setup Instructions

You can set up this widget graphically without typing terminal commands.

1. Select all files inside this folder and compress them into a standard zip archive.
2. Rename the file extension of your new archive from zip to plasmoid.
3. Double click the renamed file to launch the system graphical package installer.
4. Accept the prompt to complete the installation directly to your desktop environment.
5. Right click your taskbar and select Add Widgets.
6. Search for Core Temp and drag it into its final position.
