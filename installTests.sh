list="installTestsList"
packageWithDeps="brennangw ospm_hello 0.4"
packageWithoutDeps="brennangw ospm_echo 0.1"
setUpStartingMessage="Startup: Starting"
setUpCompleteMessage="Setup: Complete"
testOperationsStartingMessage="Test Operation(s): Starting"
testOperationsCompleteMessage="Test Operation(s): Starting"
evaluationsStartingMessage="Evaluation(s): Starting"
evaluationsCompleteMessage="Evaluation(s): Complete"
testTearDownStartingMessage="Test Teardown: Starting"
testTearDownCompleteMessage="Test Teardown: Complete"
testsPassed = 0
numberOfTests = 3

function testsComplete {
  echo "Tests Finshed"
  echo "$testsPassed of $numberOfTests passed."
}

function testStart {
  echo "Test $1: $2"
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
    source ospm.sh library $1
  fi
  currentTest="1"
  testStart $currentTest "Install w/no Dependencies"
  testComplete $currentTest

  currentTest="2"
  testStart $currentTest "Install w/Dependencies"
  testComplete $currentTest

  currentTest="3"
  testStart $currentTest "Install via list w/Dependencies"
  testComplete $currentTest


fi
