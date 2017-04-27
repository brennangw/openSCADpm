list="installTestsList"
packageWithDeps="brennangw ospm_hello 0.4"
dirOfPackageWithDeps="brennangw-ospm_hello-0.4"
packageWithoutDeps="brennangw ospm_echo 0.1"
dirOfPackageWithoutDeps="brennangw-ospm_echo-0.1"
setUpStartingMessage="Startup: Starting"
setUpCompleteMessage="Setup: Complete"
testOperationsStartingMessage="Test Operation(s): Starting"
testOperationsCompleteMessage="Test Operation(s): Starting"
evaluationsStartingMessage="Evaluation(s): Starting"
evaluationsCompleteMessage="Evaluation(s): Complete"
testTearDownStartingMessage="Test Teardown: Starting"
testTearDownCompleteMessage="Test Teardown: Complete"

testsPassed=0
numberOfTests=3

function setUpComplete {
  echo "$setUpCompleteMessage"
}

function setUpStarting {
  echo "$setUpStartingMessage"
}

function testOperationsComplete {
  echo "$testOperationsCompleteMessage"
}

function testOperationsStarting {
  echo "$testOperationsStartingMessage"
}

function evaluationsStarting {
  echo "$evaluationsStartingMessage"
}

function evaluationsComplete {
  echo "$evaluationsCompleteMessage"
}

function testTearDownComplete {
  echo "$testTearDownCompleteMessage"
}

function testTearDownStarting {
  echo "$testTearDownStartingMessage"
}

function testsComplete {
  echo "Tests Finshed"
  echo "$testsPassed of $numberOfTests passed."
}

function testStart {
  echo "Test $1: $2"
}

function evaluationStarting {
  echo "Evaluation $1: Starting"
}

function evaluationComplete {
  echo "Evaluation $1: Complete"
  echo "$2 of $3 evaluations passed."
}

function testComplete {
  echo "Test $1: Complete"
}

function evaluationPassed {
  echo "Evaluation $1: Passed"
}
function evaluationFailed {
  echo "Evaluation $1: Failed"
  echo "Detail: $2"
  echo "Was: $3"
  echo "Expected: $4"
}

function createList {
  touch $list
  echo $packageWithDeps > $list
}

function deleteList {
  rm $list
}


echo -e "\nThis is the install tester.\n"
if [ "$1" == help ]; then
  echo -e "This runs a series of tests for installig packages with ospm.\n"
  echo -e "Optional arguments are as follows:"
  echo -e "1. the libaray location."
  echo -e "\nTests"
  echo -e "Test 1: Install w/no dependencies"
  echo -e "Test 2: Install w/dependencies"
  echo -e "Test 3: Install via list w/dependencies"
  return
else
  if [[ ! -z $1 ]]; then
    source ospm.sh library save $1
  else
    1=$(source ospm library get)
  fi

  libPath=$1
  slash=$(echo /)
  fullDirPathOfPackageWithoutDeps=$libPath$slash$dirOfPackageWithoutDeps


  currentTest="1"
  testStart $currentTest "Install w/no Dependencies"
  setUpStarting
  if [[ -d $fullDirPathOfPackageWithoutDeps ]]; then
    rm -rf $fullDirPathOfPackageWithoutDeps
  fi
  setUpComplete

  testOperationsStarting
  source ospm.sh install $packageWithoutDeps
  testOperationsComplete

  evaluationsStarting

  T1evaluationsPassed=0

  currentEval="A"
  evaluationStarting currentEval

  if [[ -d $fullDirPathOfPackageWithoutDeps ]]; then
    evaluationPassed "A"
    let "testsPassed = $testsPassed + 1"
    let "T1evaluationsPassed = $T1evaluationsPassed + 1"
  else
    evaluationFailed "A" "Looked for installed dir" "Not found" $dirOfPackageWithoutDeps
  fi

  evaluationComplete "A" $T1evaluationsPassed "1"

  evaluationsComplete

  testTearDownStarting
  if [[ -d $fullDirPathOfPackageWithoutDeps ]]; then
    rm -rf $fullDirPathOfPackageWithoutDeps
  fi
  testTearDownComplete

  testComplete $currentTest

  currentTest="2"
  testStart $currentTest "Install w/Dependencies"
  testComplete $currentTest

  currentTest="3"
  testStart $currentTest "Install via list w/Dependencies"
  testComplete $currentTest


fi
