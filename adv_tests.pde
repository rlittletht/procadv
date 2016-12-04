
/* T E S T  T R U E */
/*----------------------------------------------------------------------------
	%%Function: TestTrue
	%%Contact: rlittle
 
    just a generic TestTrue() that will output some useful information on
    failure (think Assert())
----------------------------------------------------------------------------*/
void TestTrue(boolean f, String sTestName, String sTestDescription)
{
  if (!f)
  {
    println(sTestName + ": FAILED (" + sTestDescription + ")");
  }
  else
  {
    print(".");
  }
}

// some code wants to be more quiet during unit tests (like not reporting 
// consistency checks).  vfRunningUnitTests will allow us to communicate
// the we are running unit tests.

boolean vfRunningUnitTests = false;

void AdventureTests()
{
  vfRunningUnitTests = true;
  StoryWindowTests();
  StoryControlTests();
  GameTests();
  vfRunningUnitTests = false;
}