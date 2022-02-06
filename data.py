import pandas as pd

# Import parcel data csv from King County GIS
parcel_data = pd.read_csv ('Data/KCParcels.csv')

# Update sitetype
# Create unique ID
# Remove major/minor
# Make 'nan' values to NULL