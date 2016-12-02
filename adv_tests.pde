
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

boolean vfRunningUnitTests = false;

void AdventureTests()
{
  vfRunningUnitTests = true;
  StoryWindowTests();
  StoryControlTests();
  GameTests();
  vfRunningUnitTests = false;
}