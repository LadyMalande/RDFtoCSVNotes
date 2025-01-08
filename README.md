# RDFtoCSVNotes
Notes and background examples for repository RDFtoCSV. The structure of this repository is following:
- **analysis** - the analysis table with real world data used in the thesis for analyzing types of available CSV data.
- **CSVOutputExperiments** - contains CSV created from RDF4J methods for multiple tables + metadata + original CSV. 
- **docs** - contains workspace.dsl for creating C4 diagrams of the system and JavaDocs of library RDFtoCSV and web service RDFtoCSVWAPI.
- **evaluation** - converted CSVs from RDF data used for evaluating some of the real world datasets that has been used also in the analysis part of the thesis
- **examples** - CSV examples from the real world data described by the number of entities or other feature in them
- **mandatory_metadata_experiment** - experiments converting CSVW back to RDF to see what subset of metadata is sufficient for creating nice RDF files.
- **performance_tests_RDF_data** - contains RDF used for running performance tests. 
- **pictures** - any pictures related to the thesis and other repositories
- **scripts** - scripts for CSVW metadata attribute *transformation*
- **test_scenarios_data** - contains 2 files that have been used in command line manual test scenarios for methods Streaming and BigFileSTreaming.



## Evaluation
The evaluation CSVs for comparison of output are available in the directory /evaluation.
The directory is split into subdirectories according to the data set evaluated.
