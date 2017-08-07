#!/bin/bash

# Define a bunch of functions and set a bunch of variables
TEST_DIR=$(readlink -f `dirname "${BASH_SOURCE[0]}"` | grep -o '.*/oshinko-s2i/test/e2e')
source $TEST_DIR/common

SCRIPT_DIR=$(readlink -f `dirname "${BASH_SOURCE[0]}"`)
source $SCRIPT_DIR/../builddc

RESOURCE_DIR=$TEST_DIR/resources
set_template $RESOURCE_DIR/oshinko-scala-spark-build-dc.yaml
set_git_uri https://github.com/pdmack/scala-sbt-s2i-test
set_worker_count $S2I_TEST_WORKERS
set_fixed_app_name scala-build
set_app_main_class org.apache.spark.examples.SparkPi

# Clear these
set_app_file
set_exit_flag

# Need a little preamble here to read the resources.yaml, create the scala template, and save
# it to the resources directory
set +e
oc create -f https://radanalytics.io/resources.yaml &> /dev/null
oc export template oshinko-scala-spark-build-dc > $RESOURCE_DIR/oshinko-scala-spark-build-dc.yaml
set -e

os::test::junit::declare_suite_start "$MY_SCRIPT"

echo "++ test_exit"
test_fixed_exit

echo "++ test_cluster_name"
test_cluster_name

echo "++ test_del_cluster"
test_del_cluster

echo "++ test_app_args"
test_app_args

echo "++ test_pod_info"
test_podinfo

echo "++ test_named_config"
test_named_config

echo "++ test_driver_config"
test_driver_config

echo "++ test_spark_options"
test_spark_options

#echo "++ test_no_app_name"
#test_no_app_name

echo "++ test_no_source_or_image"
test_no_source_or_image

echo "++ test_app_file"
test_app_file

echo "++ test_git_ref"
test_git_ref $GIT_URI c7e91ecf8aa4fc6c36e04744a8fdae513839baa3

os::test::junit::declare_suite_end
