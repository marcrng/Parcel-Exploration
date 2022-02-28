# Parcel Exploration

## Description

---

This is the first part of what will eventually become a writeup of King County property prices and what factors influence these prices the most (hopefully). For now, we'll be focusing on visualizing our market with some interactive maps and graphs that will help us compare neighborhoods visually and getting into the statistics in part two.

This is my first project since taking a break after graduating from college to renovate (more like fix) an entire house from plumbing to electrical for a few months, so my process was a little messy.

Data to complete this project was sourced from:

- [King County GIS Center](https://kingcounty.gov/services/gis.aspx)
- [simplemaps](https://simplemaps.com/data/us-zips)

**Tools used: MySQL, Tableau**
## Plan

---

- Collect the data
- Clean the data
- Build some visualizations
- Create a data story in Tableau

## The Process

---

### Creating a smaller table
The initial dataset was huge, with 64 columns and 627,021 rows, so the first step was to either create another table and keeping the columns we need, or simply dropping the colums from the imported dataset. I went with the latter using `ALTER TABLE` and `DROP COLUMN`. 

### Splitting the table
The main table was manageable after dropping about half the rows, which were mostly columns that were split into several parts and then collated in another column. Columns like zip codes, levy codes, and site types could be placed in their own tables, as they had many-to-one relationships. This would let us do things like place data specific to each zip in its own table and keep things more organized. 

This was done using `CREATE TABLE` and assigning a primary key id to reference back to the main table.

### Cleaning the data
A lot of the site types (field that classifies a property as residential, commercial, etc.) were null, so assigning a site type from the 'description' field was necessary for many entries. This took the most time, as most entries were described with different terms, so labelling site type for multi-residential homes looked like this:

```sql
# Update the main table and set SITETYPE to 'R2' for all multi-residential parcels
update kcparcels
set SITETYPE = 'R2'
where PREUSE_DESC like '%Apartment%'
   or PREUSE_DESC like '%triplex%'
   or PREUSE_DESC like '%duplex%'
   or PREUSE_DESC like '%condo%'
   or PREUSE_DESC like '%4-plex%'
   or PREUSE_DESC like '%rooming house%'
    and SITETYPE is null;
```

### Creating the first visualizations in Tableau

![Initial version of zip-level map](Images/zip_values.png)

Above is the first quick visualization that plotted total property values for each zip code. During this step, I realized it would be better to create a different way to compare zip codes, since those that have a small amount of properties but a high value wouldn't be represented as such.

This required importing population data from the KSGIS database and joining it. This would have been better to do at the start of the project in SQL if I did better during the initial planning/preparing stage.  

![Second version of zip-level map](Images/zip_values_v2.png)

This was the result after dividing the total value of residential properties by the population in each zip, changing the colors to red-green diverging (for those with difficulty seeing color), and setting the color steps to 5 to accentuate the differences between regions.

~~Still deciding which way to compare each region would be best. So far I'm considering:~~
- ~~Zip total / Whole county total~~ 
- ~~Zip total / # of parcels in zip~~
- ~~Zip total / Population of zip~~

~~The first option made the most sense to me initially, but still doesn't address the fact that each area has a different amount of area/population/housing.~~

#### Final iteration of zip-level map
![Final version of zip-level map](Images/zip_values_final.png)

For the final iteration of the zip-level map, I went with dividing the total values of parcels in each zip by its number of parcels, then using Tableau's rank calculation. The result above shows us how each zip code competes with the others, given the average value for all parcels in the area.


### Creating a treemap
![First version of zip treemap](Images/zip_tree.png)

This treemap was meant to be a companion to the first map, allowing users to quickly select a city and its associated zip codes and view them within the map.

### Building a parcel-level map
![First version of parcel-level map](Images/parcel_map.png)

This map provides a data point for each parcel, which can be filtered by property type, price range, and city. The user can further filter in on the neighborhood they want to examine by using the lasso tool to isolate certain properties.

### Trial Dashboard
![Initial test dashboard](Images/trial_dashboard.png)

The current state of the dashboard, with part of Mercer Island isolated to demonstrate how the average value fields and average square footage fields filter along with the map. Future iterations will have more interactions between the map and separate charts that will display property details.

### Future Plans

- Building the storyboard that will have an overall aesthetic and theme
- Including some type of regression analysis to determine correlation between things like property value and age of population.

### Things to improve

Some things weren't possible with the data available publicly, since Zillow's public API is no longer available.

- Classify properties by square footage of the home itself, instead of the parcel 
- Compare homes based on # of bedrooms, bathrooms/renovations/features (pools, etc.)