# Coospo Map Generation (CS600)
The [Coospo CS600](https://www.coospo.com/products/cs600-bike-computer) is a GPS bike computer which uses map files stored in on-board flash memory. The device comes pre-loaded with maps, which can also be downloaded from the [Coospo Map Download](https://www.coospo.com/pages/map-download) page. **These maps contain paved roads, but do not contain any off-road trails.**

The format of these maps is [Mapsforge Compact Binary .MAP](http://mapsforge.org/). These are generated using [Open Street Map](https://www.openstreetmap.org/) data. With a little effort, you can generate your own .map files containing trails!

![Coospo CS600 Trails](https://raw.githubusercontent.com/Se7enLC/coospo-map-generation/refs/heads/main/coospo_cs600_trails.jpg)

## Details about CS600 Maps
* Map files are available by region (in the US it's by state, for example).
* Filenames take the form of a 2-letter country code, 4 digit ID, and the date in YYYYMMDD format, with the extension .map. Example: `US260020250528.map`. The numbering system for the 4-digit ID is unknown, but can be worked out by downloading a region from the [Coospo Map Download](https://www.coospo.com/pages/map-download) page and looking at the filename.
* You can replace a map file with one that you generate of the same region.
* The map filename does not seem to be hard-coded to a state. But only certain filenames will load. `US520020250528.map` will load, for example. As will `US52MA20250528.map`. `USMA0020250528.map` will NOT load.
* Maps for the CS600 use Zoom level 12 for the 0.5mi scale and Zoom Level 14 for 0.2mi, 0.1mi, 300ft, and 150ft.
* The CS600 can display three different road styles and water, as well as road name labels.
* highway:primary, highway:motorway appear as a thick yellow line
* highway:secondary, highway:tertiary appear as a thin yellow line
* highway:residential, highway:service, highway:unclassified appear as a thin grey line
* other types (such as path, track, cycleway, footpath, bridleway) do not appear at all!
* If you include too many items at Zoom Level 12 (maximum zoom out), you will crash the device (reboot).

## US State Map Filenames
| US State | Map Filename |
| :-- | :-- |
| Alabama | US460020250528.map |
| Alaska | US020020250528.map |
| Arizona | US470020250528.map |
| Arkansas | US010020250528.map |
| California | US180020250528.map |
| Colorado | US210020250528.map |
| Connecticut | US200020250528.map |
| Delaware | US380020250528.map |
| Florida | US130020250528.map |
| Georgia | US510020250528.map |
| Hawaii | US420020250528.map |
| Idaho | US040020250528.map |
| Illinois | US480020250528.map |
| Indiana | US490020250528.map |
| Iowa | US030020250528.map |
| Kansas | US190020250528.map |
| Kentucky | US220020250528.map |
| Lousiana | US230020250528.map |
| Maine | US310020250528.map |
| Massachusetts | US260020250528.map |
| Maryland | US250020250528.map |
| Michigan | US300020250528.map |
| Minnesota | US320020250528.map |
| Mississippi | US290020250528.map |
| Missouri | US280020250528.map |
| Montana | US270020250528.map |
| Nebraska | US350020250528.map |
| Nevada | US360020250528.map |
| New Hampshire | US430020250528.map |
| New Jersey | US450020250528.map |
| New Mexico | US440020250528.map |
| New York | US370020250528.map |
| North Carolina | US060020250528.map |
| North Dakota | US050020250528.map |
| Ohio | US090020250528.map |
| Oklahoma | US100020250528.map |
| Oregon | US110020250528.map |
| Pennsylvania | US070020250528.map |
| Rhode Island | US240020250528.map |
| South Carolina | US340020250528.map |
| South Dakota | US330020250528.map |
| Tennessee | US390020250528.map |
| Texas | US080020250528.map |
| Utah | US500020250528.map |
| Vermont | US140020250528.map |
| Virginia | US120020250528.map |
| Washington State | US160020250528.map |
| Washington DC | US150020250528.map |
| West Virginia | US410020250528.map |
| Wisconsin | US400020250528.map |
| Wyoming | US170020250528.map |

## How to generate maps
Using two tools, [Osmosis](https://wiki.openstreetmap.org/wiki/Osmosis) and [Mapsforge Writer Plugin](http://mapsforge.org/), you can take an Open Street Map export, modify it, and save it as a Mapsforge .map file for use with the Coospo CS600.

## How to include trails
The CS600 hardware does not display Open Street Map types used for offroad trails (highway:path, highway:cycleway, highway:footway, highway:bridleway). In order to force it to display trails of those types, they must be converted to another type that is visible on the CS600. There are a few options for how to do this:
1. You can translate those types to highway:unclassified, which will appear the same as a residential street (thin grey). This is very straightforward, but has the disadvantage that you can no longer tell the difference between a paved residential street and a gravel or dirt trail.
2. You can shuffle all the road types. Move secondary roads (thin yellow) to be the same as primary roads (thick yellow). Move all other paved roads (thin grey) to be tertiary roads (thin yellow). This leaves thin grey open for all trails.

## highway_type.transform.xml
```xml
<?xml version="1.0"?>
<translations>
  <translation>
    <name>Convert Secondary to Primary</name>
    <description>Remap highway:secondary to highway:primary</description>
    <match type="way">
      <tag k="highway" v="secondary"/>
    </match>
    <output>
      <copy-unmatched/>
      <tag k="highway" v="primary"/>
    </output>
  </translation>
  <translation>
    <name>Convert Residential, Service, Unclassified to Tertiary</name>
    <description>Remap highway:residential, service, unclassified to highway:tertiary</description>
    <match type="way">
      <tag k="highway" v="residential|service|unclassified"/>
    </match>
    <output>
      <copy-unmatched/>
      <tag k="highway" v="tertiary"/>
    </output>
  </translation>
  <translation>
    <name>Convert Bike Paths to Unclassified</name>
    <description>Remap highway:path, track cycleway, footway, and bridleway to highway:unclassified</description>
    <match type="way">
      <tag k="highway" v="path|track|cycleway|footway|bridleway"/>
    </match>
    <output>
      <copy-unmatched/>
      <tag k="highway" v="unclassified"/>
    </output>
  </translation>
</translations>
```

## tag-mapping.xml
The `tag-mapping.xml` file provides a configuration Map Writer plugin to know which Zoom Levels to display each data type. The default `tag-mapping.xml` obtained from [Mapsforge Map Writer](https://github.com/mapsforge/mapsforge/blob/master/mapsforge-map-writer/src/main/config/tag-mapping.xml) will show too much detail at Zoom level 12, and cause the Coospo to crash when it renders. To fix this, you will need to modify the `tag-mapping.xml` file to make some of the road types not appear until Zoom level 14.
* Change the `zoom-appear` field to 14 for the following types: residential, tertiary, unclassified. Example:
```xml
   <ways>
        <osm-tag key="highway" value="bridleway" zoom-appear="13"/>
        <osm-tag key="highway" value="bus_guideway" zoom-appear="13"/>
        <osm-tag key="highway" value="byway" zoom-appear="13"/>
        <osm-tag key="highway" value="construction" zoom-appear="13"/>
        <osm-tag key="highway" value="cycleway" zoom-appear="13"/>
        <osm-tag key="highway" value="footway" zoom-appear="13"/>
        <osm-tag key="highway" value="living_street" zoom-appear="13"/>
        <osm-tag key="highway" value="motorway" zoom-appear="6"/>
        <osm-tag key="highway" value="motorway_link" zoom-appear="6"/>
        <osm-tag key="highway" value="path" zoom-appear="14"/>
        <osm-tag key="highway" value="pedestrian" zoom-appear="14"/>
        <osm-tag key="highway" value="primary" zoom-appear="8"/>
        <osm-tag key="highway" value="primary_link" zoom-appear="8"/>
        <osm-tag key="highway" value="raceway" zoom-appear="12"/>
        <osm-tag key="highway" value="residential" zoom-appear="14"/>
        <osm-tag key="highway" value="road" zoom-appear="12"/>
        <osm-tag key="highway" value="secondary" zoom-appear="9"/>
        <osm-tag key="highway" value="secondary_link" zoom-appear="9"/>
        <osm-tag key="highway" value="service" zoom-appear="14"/>
        <osm-tag key="highway" value="services" zoom-appear="14"/>
        <osm-tag key="highway" value="steps" zoom-appear="16"/>
        <osm-tag key="highway" value="tertiary" zoom-appear="14"/>
        <osm-tag key="highway" value="tertiary_link" zoom-appear="10"/>
        <osm-tag key="highway" value="track" zoom-appear="12"/>
        <osm-tag key="highway" value="trunk" zoom-appear="6"/>
        <osm-tag key="highway" value="trunk_link" zoom-appear="6"/>
        <osm-tag key="highway" value="unclassified" zoom-appear="14"/>
    </ways>
```
In some cases you may need to modify other sections of `tag-mapping.xml` as well. For example, some bike trails are also marked for Nordic skiing, and there's a section of `tag-mapping.xml` that sets zoom-appear for nortic trails separately from using the highway tag.

## File Size
It's also important to keep the file size down by removing data that the Coospo wasn't going to display anyway. This can be done by including only roads and water, filtering out the rest of the data that may be present.

## Installing Osmosis and Map Writer Plugin
As these are Java applications, they can be run on any system, provided a compatible version of Java is installed and your enviroment is set up properly. That being said, it's much easier to use a Docker image. I included the `Dockerfile` I used. Edit it to include your UID/GID.
* To build the docker: `docker build -t osmosis .`
* To run the docker:
  - macOS / Linux:
    `docker run --volume $(pwd):/data -it osmosis`
  - Windows (PowerShell):
    `docker run --volume ${PWD}:/data -it osmosis`

## Example Execution
The execution is broken up into 4 stages: Extraction of Ways, Extraction of Relations, Merging and Filtering, Writing the .MAP file. Only roads and water are included.
```bash
# MA downloaded from https://download.geofabrik.de/north-america/us.html
INPUT_FILENAME=massachusetts-251009.osm.pbf

# Matches CS600 map for MA
OUTPUT_FILENAME=US260020250528.map

# Zoom Level: BaseA,MinA,MaxA,BaseB,MinB,MaxB
ZOOM_LEVEL=12,12,13,14,14,20

TAG_CONF_FILE=tag-mapping.xml
TRANSFORM_FILE=highway_type.transform.xml
echo "=== Extracting Ways ==="
osmosis --read-pbf-fast file=${INPUT_FILENAME} workers=8 \
    --tf accept-ways highway=* waterway=* natural=water \
    --tf reject-relations \
    --used-node \
    --write-pbf file=intermediate_ways.osm.pbf

echo "=== Extracting Relations ==="
osmosis --read-pbf-fast file=${INPUT_FILENAME} workers=8\
    --tf accept-relations highway=* waterway=* natural=water \
    --used-node --used-way \
    --write-pbf file=intermediate_relations.osm.pbf

echo "=== Merging PBFs ==="
osmosis --read-pbf-fast file=intermediate_relations.osm.pbf workers=8 \
    --read-pbf-fast file=intermediate_ways.osm.pbf workers=8 \
    --tt file=${TRANSFORM_FILE} stats=transform_stats.txt \
    --merge \
    --write-pbf file=intermediate.osm.pbf

echo "=== Exporting Mapsforge File ==="
osmosis --read-pbf file=intermediate.osm.pbf \
    --mapfile-writer file=${OUTPUT_FILENAME} \
    way-clipping=true \
    polygon-clipping=true \
    zoom-interval-conf=${ZOOM_LEVEL} \
    tag-conf-file=${TAG_CONF_FILE}
```
