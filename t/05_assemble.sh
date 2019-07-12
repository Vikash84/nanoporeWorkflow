#!/usr/bin/env bats

# BATS https://github.com/sstephenson/bats

thisDir=$BATS_TEST_DIRNAME
scriptsDir=$(realpath "$thisDir/../scripts")
export NSLOTS=2 # slots given to us by travis

projectDir=$thisDir/vanilla.project/barcode12

@test "Usage statement" {
  run bash $scriptsDir/05_assemble.sh
  [ "$status" -eq 1 ] # usage exits with 1
  [ "$output" != "" ]
  [ ${output:0:6} == "Usage:" ] # First five characters of the usage statement is "Usage: "
}

@test "Files are present" {
  [ -d $projectDir ]
  [ -f "$projectDir/all.fastq.gz" ]
  [ -f "$projectDir/readlengths.txt.gz" ]
}

@test "Assembly with wtdbg2" {

  if [ ! -f "$projectDir/unpolished.fasta" ]; then
    run bash $scriptsDir/05_assemble.sh $projectDir
    [ "$status" -eq 0 ]
  fi

  hashsum=$(md5sum $projectDir/unpolished.fasta | cut -f 1 -d ' ')
  [ "$hashsum" == "d928e8159ab1591569e6c873662635e2" ]
}

