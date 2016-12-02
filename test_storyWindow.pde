float SingleLineHeightForTest()
{
  return textAscent() + textDescent();
}

// ================================================================================
//  L I N E  B R E A K  I N F O  T E S T S 
// ================================================================================

void Test_LineBreakInfoCalculateForString_LeadingNewline_OneBreakRecords()
{
  String sTest = "\ntesting";
  StoryWindow storyWindow = new StoryWindow();
  StoryWindow.LineBreakInfo lineBreakInfo = storyWindow.LineBreakInfoCalculateForString(sTest, 640);
  
  TestTrue(lineBreakInfo.cchLine == 0, "Test_LineBreakInfoCalculateForString_LeadingNewline_OneBreakRecords", "line length does not match");
  TestTrue(lineBreakInfo.dyp == SingleLineHeightForTest(), "Test_LineBreakInfoCalculateForString_LeadingNewline_OneBreakRecords", "line height does not match");
}


void Test_LineBreakInfoCalculateForString_ShortString_NoBreakRecords()
{
  String sTest = "testing";
  StoryWindow storyWindow = new StoryWindow();
  StoryWindow.LineBreakInfo lineBreakInfo = storyWindow.LineBreakInfoCalculateForString(sTest, 640);
  
  TestTrue(lineBreakInfo.cchLine == sTest.length(), "Test_LineBreakInfoCalculateForString_ShortString_NoBreakRecords", "line length does not match");
  TestTrue(lineBreakInfo.dyp == SingleLineHeightForTest(), "Test_LineBreakInfoCalculateForString_ShortString_NoBreakRecords", "line height does not match");
  
}

void Test_LineBreakInfoCalculateForString_ShortStringWithNewline_OneBreakRecord()
{
  String sTest = "test\ning";
  StoryWindow storyWindow = new StoryWindow();
  StoryWindow.LineBreakInfo lineBreakInfo = storyWindow.LineBreakInfoCalculateForString(sTest, 640);
  
  TestTrue(lineBreakInfo.cchLine == 4, "Test_LineBreakInfoCalculateForString_ShortStringWithNewline_OneBreakRecord", "line length does not match");
  TestTrue(lineBreakInfo.dyp == SingleLineHeightForTest(), "Test_LineBreakInfoCalculateForString_ShortStringWithNewline_OneBreakRecord", "line height does not match");
}

void Test_LineBreakInfoCalculateForString_LongString_SingleBreakRecordOneWordPushed()
{
  String sTest = "this is a length string that is going to have to break because it will be longer than the line and it will break HERE";
  StoryWindow storyWindow = new StoryWindow();
  StoryWindow.LineBreakInfo lineBreakInfo = storyWindow.LineBreakInfoCalculateForString(sTest, 640);
  
  TestTrue(lineBreakInfo.cchLine == 113, "Test_LineBreakInfoCalculateForString_LongString_SingleBreakRecordOneWordPushed", "line length does not match");
  TestTrue(lineBreakInfo.dyp == SingleLineHeightForTest(), "Test_LineBreakInfoCalculateForString_LongString_SingleBreakRecordOneWordPushed", "line height does not match");
}

void Test_LineBreakInfoCalculateForString_LongString_SingleBreakRecordTwoWordsPushed()
{
  String sTest = "this is a length string that is going to have to break because it will be longer than the line and it will break HERE extra";
  StoryWindow storyWindow = new StoryWindow();
  StoryWindow.LineBreakInfo lineBreakInfo = storyWindow.LineBreakInfoCalculateForString(sTest, 640);
  
  TestTrue(lineBreakInfo.cchLine == 113, "Test_LineBreakInfoCalculateForString_LongString_SingleBreakRecordTwoWordsPushed", "line length does not match");
  TestTrue(lineBreakInfo.dyp == SingleLineHeightForTest(), "Test_LineBreakInfoCalculateForString_LongString_SingleBreakRecordTwoWordsPushed", "line height does not match");
}

// ================================================================================
//  S T R I N G  L I N E  I N F O  T E S T S 
// ================================================================================

void Test_StringLineInfoCalculateForString_ShortStringSingleLine()
{
  String sTest = "testing";
  StoryWindow storyWindow = new StoryWindow();
  StoryWindow.StringLineInfo lineInfo = storyWindow.StringLineInfoCalculateForString(sTest, 640);
  
  TestTrue(lineInfo.cLines == 1, "Test_StringLineInfoCalculateForString_ShortStringSingleLine", "line count does not match");
  TestTrue(lineInfo.lineBreaks[0].cchLine == sTest.length(), "Test_StringLineInfoCalculateForString_ShortStringSingleLine", "line break info does not match");
  TestTrue(lineInfo.lineBreaks[0].ichSegmentStart == 0, "Test_StringLineInfoCalculateForString_ShortStringSingleLine", "segment start does not match");
  TestTrue(lineInfo.dyp == lineInfo.cLines * SingleLineHeightForTest(), "Test_StringLineInfoCalculateForString_ShortStringSingleLine", "line height does not match");
}

// test to make sure the newline breaks the lines AND make sure we skip the break character
void Test_StringLineInfoCalculateForString_ShortStringWithNewLineSingleLine()
{
  String sTest = "test\ning";
  StoryWindow storyWindow = new StoryWindow();
  StoryWindow.StringLineInfo lineInfo = storyWindow.StringLineInfoCalculateForString(sTest, 640);
  
  TestTrue(lineInfo.cLines == 2, "Test_StringLineInfoCalculateForString_ShortStringWithNewLineSingleLine", "line count does not match");
  TestTrue(lineInfo.lineBreaks[0].cchLine == 4, "Test_StringLineInfoCalculateForString_ShortStringWithNewLineSingleLine", "first line break info does not match");
  TestTrue(lineInfo.lineBreaks[0].ichSegmentStart == 0, "Test_StringLineInfoCalculateForString_ShortStringWithNewLineSingleLine", "segment start does not match");
  TestTrue(lineInfo.lineBreaks[1].cchLine == 3, "Test_StringLineInfoCalculateForString_ShortStringWithNewLineSingleLine", "second line break info does not match");
  TestTrue(lineInfo.lineBreaks[1].ichSegmentStart == 5, "Test_StringLineInfoCalculateForString_ShortStringWithNewLineSingleLine", "segment start does not match");
}

void Test_StringLineInfoCalculateForString_ShortStringWithLeadingNewLineTwoLines()
{
  String sTest = "\ntesting";
  StoryWindow storyWindow = new StoryWindow();
  StoryWindow.StringLineInfo lineInfo = storyWindow.StringLineInfoCalculateForString(sTest, 640);
  
  TestTrue(lineInfo.cLines == 2, "Test_StringLineInfoCalculateForString_ShortStringWithLeadingNewLineTwoLines", "line count does not match");
  TestTrue(lineInfo.lineBreaks[0].cchLine == 0, "Test_StringLineInfoCalculateForString_ShortStringWithLeadingNewLineTwoLines", "first line break info does not match");
  TestTrue(lineInfo.lineBreaks[0].ichSegmentStart == 0, "Test_StringLineInfoCalculateForString_ShortStringWithLeadingNewLineTwoLines", "segment start does not match");
  TestTrue(lineInfo.lineBreaks[1].cchLine == 7, "Test_StringLineInfoCalculateForString_ShortStringWithLeadingNewLineTwoLines", "second line break info does not match");
  TestTrue(lineInfo.lineBreaks[1].ichSegmentStart == 1, "Test_StringLineInfoCalculateForString_ShortStringWithLeadingNewLineTwoLines", "segment start does not match");
  
}

void Test_StringLineInfoCalculateForString_LongerStringTwoLines()
{
  String sTest = "this is a length string that is going to have to break because it will be longer than the line and it will break HERE extra";
  StoryWindow storyWindow = new StoryWindow();
  StoryWindow.StringLineInfo lineInfo = storyWindow.StringLineInfoCalculateForString(sTest, 640);
  
  TestTrue(lineInfo.cLines == 2, "Test_StringLineInfoCalculateForString_LongerStringTwoLines", "line count does not match");
  TestTrue(lineInfo.lineBreaks[0].cchLine == 113, "Test_StringLineInfoCalculateForString_LongerStringTwoLines", "first line break info does not match");
  TestTrue(lineInfo.lineBreaks[0].ichSegmentStart == 0, "Test_StringLineInfoCalculateForString_LongerStringTwoLines", "segment start does not match");
  TestTrue(lineInfo.lineBreaks[1].cchLine == 10, "Test_StringLineInfoCalculateForString_LongerStringTwoLines", "second line break info does not match");
  TestTrue(lineInfo.lineBreaks[1].ichSegmentStart == 113, "Test_StringLineInfoCalculateForString_LongerStringTwoLines", "segment start does not match");
  
}

void Test_StringLineInfoCalculateForString_LongerStringThreeLines()
{
  String sTest = "this is a length string that is going to have to break because it will be longer than the line and it will break this is a length string that is going to have to break because it will be longer than the line and it will break HERE extra";
  StoryWindow storyWindow = new StoryWindow();
  StoryWindow.StringLineInfo lineInfo = storyWindow.StringLineInfoCalculateForString(sTest, 640);
  
  TestTrue(lineInfo.cLines == 3, "Test_StringLineInfoCalculateForString_LongerStringThreeLines", "line count does not match");
  TestTrue(lineInfo.lineBreaks[0].cchLine == 113, "Test_StringLineInfoCalculateForString_LongerStringThreeLines", "first line break info does not match");
  TestTrue(lineInfo.lineBreaks[0].ichSegmentStart == 0, "Test_StringLineInfoCalculateForString_LongerStringThreeLines", "segment start does not match");
  TestTrue(lineInfo.lineBreaks[1].cchLine == 113, "Test_StringLineInfoCalculateForString_LongerStringThreeLines", "second line break info does not match");
  TestTrue(lineInfo.lineBreaks[1].ichSegmentStart == 113, "Test_StringLineInfoCalculateForString_LongerStringThreeLines", "segment start does not match");
  TestTrue(lineInfo.lineBreaks[2].cchLine == 10, "Test_StringLineInfoCalculateForString_LongerStringThreeLines", "third line break info does not match");
  TestTrue(lineInfo.lineBreaks[2].ichSegmentStart == 226, "Test_StringLineInfoCalculateForString_LongerStringThreeLines", "segment start does not match");
}


void StoryWindowTests()
{
  Test_LineBreakInfoCalculateForString_LeadingNewline_OneBreakRecords();
  Test_LineBreakInfoCalculateForString_ShortString_NoBreakRecords();
  Test_LineBreakInfoCalculateForString_ShortStringWithNewline_OneBreakRecord();
  Test_LineBreakInfoCalculateForString_LongString_SingleBreakRecordOneWordPushed();
  Test_LineBreakInfoCalculateForString_LongString_SingleBreakRecordTwoWordsPushed();
  Test_StringLineInfoCalculateForString_ShortStringSingleLine();
  Test_StringLineInfoCalculateForString_ShortStringWithNewLineSingleLine();
  Test_StringLineInfoCalculateForString_ShortStringWithLeadingNewLineTwoLines();
  Test_StringLineInfoCalculateForString_LongerStringTwoLines();
  Test_StringLineInfoCalculateForString_LongerStringThreeLines();
}