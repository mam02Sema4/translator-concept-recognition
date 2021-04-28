#!/bin/bash
#
# ONT = one of the ontologies used by the CRAFT corpus, e.g. chebi
#

ONT=$1

# extract the version from the MODEL_VERSIONS file - this is used as part of the file name for the serialized model file
export VERSION=$(grep "${ONT^^}.CRAFT" /home/dev/MODEL_VERSIONS | cut -f 2 -d "=")

# replace the VERSION placeholder in the properties template file to create the properties file used by train.sh
envsubst < /home/dev/scripts/properties/${ONT}.properties.template > /home/dev/scripts/properties/${ONT}.properties

# train the model - model will be written to /home/dev/crf-models/craft/[ONT]-ner-model.[VERSION].ser.gz
/home/dev/scripts/train.sh ${ONT}

# evaluate the model on the test set and write results (the standard error output stream) to file
/home/dev/scripts/test.sh ${ONT} 2> /home/dev/crf-performance/${ONT}.craft.out 

# generate the JSON snippet that contains the evaluation metrics
/home/dev/scripts/crf-performance-to-json.sh ${ONT} CRAFT /home/dev/crf-performance/${ONT}.craft.out > /home/dev/crf-performance/${ONT}.craft.json
