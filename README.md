## How ```run_analysis.R``` works:

* Require ```pylr``` librareis.
* Load the features and activity labels.
* Load both test and train data
* Merge test and train data with correct type column for Activity.
* Extract just mean and standard deviation from data.
* Final merge of tydi data.
* Change Activity column to factor type for clarity.
* Make better column names for clarity.
* Obtain requested data and write it to file average_by_subject_and_activity.csv