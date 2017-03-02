#!/bin/bash

SPARK_VERSION="2.0.1"

# Argument Parsing
while [[ $# -ge 1 ]]
do
key="$1"

case $key in
    -m|--name)
    PROJECT_NAME="$2"
    shift
    ;;
    -v|--spark-version)
    SPARK_VERSION="$2"
    shift
    ;;
    -s|--scala-version)
    SCALA_VERSION="$2"
    shift
    ;;
    -h|--help)
    echo "
    This is a program aimed to create a Scala/Spark directory structure.
    Arguments:
      -m|--name             : Name of the program
      -v|--spark-version    : Spark Version for dependencies
      -s|--scala-version    : Scala Version for project
      -h|--help             : Print this message
    "
    exit
    shift
    ;;
    *)
    # unknown option
    ;;
esac
shift # past argument or value
done

# Create Scala sbt program tree
echo "Creating main/ directories"
mkdir -p src/main/resources/
mkdir -p src/main/java/
mkdir -p src/main/scala/

echo "Creating test/ directories"
mkdir -p src/test/resources/
mkdir -p src/test/java/
mkdir -p src/test/scala/

echo "Creating {project,target} directories"
mkdir project/
mkdir target/

echo "Creating assembly.sbt"
echo "addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "0.14.3")" > project/assembly.sbt

echo "Creating build.sbt"
echo "name := \"$PROJECT_NAME\"

version := \"1.0\"

scalaVersion := \"2.12.1\"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % "$SPARK_VERSION" % "provided",
  "org.apache.spark" %% "spark-sql" % "$SPARK_VERSION" % "provided",
  "org.apache.spark" %% "spark-mllib" % "$SPARK_VERSION" % "provided",
  "org.apache.spark" %% "spark-graphx" % "$SPARK_VERSION" % "provided",
)

assemblyMergeStrategy in assembly := {
  case PathList("META-INF", xs @ _*) => MergeStrategy.discard
  case x => MergeStrategy.last
}
" > build.sbt

echo "Creating .gitignore file"
echo "### Scala ###
*.class
*.log

# sbt specific
.cache
.history
.lib/
dist/*
target/
lib_managed/
src_managed/
project/boot/
project/plugins/project/

# Scala-IDE specific
.ensime
.ensime_cache/
.scala_dependencies
.worksheet
" > .gitignore
