# Urban Heat Island Effect Tracker

A heat index & surface temperature tracker that compares temperature changes over time between ZIP codes in urban areas. Currently semi-functional for Houston, TX.

## Data Sources

I pulled granules from NASA Earthdata's satellite data and mapped it to coordinates representing zip codes using QGIS. The processed data is stored as .csv files in the `data/` directory.

## Future Plans

Check out these issues and their associated sub-issues:
[![help wanted issues](https://img.shields.io/github/issues/ForkTheCity/heatindextracker/help%20wanted)](https://github.com/ForkTheCity/heatindextracker/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)

I plan to add support for urbanized areas in North America with a more automated process, more accurate readings, and maybe even implement an AI or API to generate a summary about what infrastructure or policies could be contributed to the rate of change in the urban heat island effect, quality of life, and then an overall summary for the most effective practices.

## Project Origin

This started as a project for ENGI 1331 at the University of Houston in Spring 2025.
