
void Test_DySpaceNeededForControlCount_NoControlsExpectNoSpace()
{
  StoryControls controls = new StoryControls();
  
  float dy = controls.DySpaceNeededForControlCount(0);
  
  TestTrue(dy == 0, "Test_DySpaceNeededForControlCount_NoControlsExpectNoSpace", "height needed does not match");
}

void Test_DySpaceNeededForControlCount_OneControlsExpectPaddingAboveBelowNoBetween()
{
  StoryControls controls = new StoryControls();
  
  float dy = controls.DySpaceNeededForControlCount(1);
  
  TestTrue(dy == SingleLineHeightForTest() + 6 + 10, "Test_DySpaceNeededForControlCount_OneControlsExpectPaddingAboveBelowNoBetween", "height needed does not match");
}

void Test_DySpaceNeededForControlCount_TwoControlsExpectPaddingAboveBelowNoBetween()
{
  StoryControls controls = new StoryControls();
  
  float dy = controls.DySpaceNeededForControlCount(2);
  
  TestTrue(dy == (SingleLineHeightForTest() + 6) * 2 + 10 + 5, "Test_DySpaceNeededForControlCount_TwoControlsExpectPaddingAboveBelowNoBetween", "height needed does not match");
}

void StoryControlTests()
{
  Test_DySpaceNeededForControlCount_NoControlsExpectNoSpace();
  Test_DySpaceNeededForControlCount_OneControlsExpectPaddingAboveBelowNoBetween();
  Test_DySpaceNeededForControlCount_TwoControlsExpectPaddingAboveBelowNoBetween();
}