This R project (stockESP) contains the code used to create data and figures for stocks with a 2026 Management Track Assessment or Data Update.
The primary output of this project is a Quarto book that contains the data and figures for each stock. The book is compiled by the _quarto.yml file through typing 'quarto render' into the terminal in RStudio. 

Folders and files in this repository:
- `.github` folder: Contains GitHub actions
- `.quarto` folder: Contains files necessary to run the Quarto book
- `chapters` folder: Contains the Qmd files for each stock, which are used to create the Quarto book. Chapters are created in utils/create_chapters.R following the child document in utils/child_doc.qmd.
- `data` folder: Contains already-processed data.
  - `intermediate` folder: Contains commercial data for all stocks.
- `data-raw' folder: Contains raw data and scripts to process the raw data. 
  - `inputs` folder: Raw indicator data for bottom temperature, SST, CHL, salinity, and NAO and AMO indices
  - `outputs` folder: Contains output data by stock, created by running input data through each indicator script.
  - `scripts` folder: Contains scripts to process raw data for each indicator. Indicators are divided by shape file: either bottom trawl survey (BTS) or ecological production unit (EPU).
  - `shapefiles` folder: Contains the shapefiles for the bottom trawl survey and EPUs for subsetting raw indicator data.
  - `stratamap` folder: Contains images for the NEFSC bottom trawl survey by strata
- `docs` folder: Contains the compiled Quarto book, which is automatically updated when the book is rendered.
  - `chapters` folder: Contains the HTML compiled documents for each stock, created by rendering the Quarto book.
- `R` folder: Houses all functions used in this repository
- `utils` folder: Contains utility scripts, including the script to create chapters and the child document for each chapter.


#### Legal disclaimer

*This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.*
