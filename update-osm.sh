# UPDATE all data on routable ways

cd ~/reliability

# get new street/rail data from the overpass API
wget -O ~/scripts/osrm-backend/osm-data/transit.osm --post-file=ways-query.txt https://overpass-api.de/api/interpreter

# import way data into postGIS
osm2pgsql --slim --hstore-all --prefix street -d transit ~/scripts/osrm-backend/osm-data/transit.osm

# process the data for OSRM-backend (but don't run it yet)
cd ~/scripts/osrm-backend
# process OSRM for the bike profile
build/osrm-extract -p profiles/transit-simple.lua osm-data/transit.osm
build/osrm-contract osm-data/transit.osrm

# this is not needed for routing
rm osm-data/transit.osm

# return to original folder
cd ~/reliability

# run this separately: a reminder
echo 'to run OSRM:
~/scripts/osrm-backend/build/osrm-routed ~/scripts/osrm-backend/osm-data/transit.osrm --max-matching-size=1000 --port=5000'
