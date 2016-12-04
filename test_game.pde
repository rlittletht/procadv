
void Test_AdventureReader_SplitCsvLine_SimpleTwoValueSplit()
{
  AdventureReader reader = new AdventureReader();
  
  String sLine = "this,that";
  String[] values = reader.SplitCsvLine(sLine);
  
  TestTrue(values[0].compareTo("this") == 0, "Test_AdventureReader_SplitCsvLine_SimpleTwoValueSplit", "first value doesn't match");
  TestTrue(values[1].compareTo("that") == 0, "Test_AdventureReader_SplitCsvLine_SimpleTwoValueSplit", "second value doesn't match");
}

void Test_AdventureReader_SplitCsvLine_SimpleOneValueSplit()
{
  AdventureReader reader = new AdventureReader();
  
  String sLine = "this";
  String[] values = reader.SplitCsvLine(sLine);
  
  TestTrue(values[0].compareTo("this") == 0, "Test_AdventureReader_SplitCsvLine_SimpleOneValueSplit", "first value doesn't match");
}

void Test_AdventureReader_SplitCsvLine_QuotedCommaOneValueSplit()
{
  AdventureReader reader = new AdventureReader();
  
  String sLine = "\"this,that\"";
  String[] values = reader.SplitCsvLine(sLine);
  
  TestTrue(values[0].compareTo("this,that") == 0, "Test_AdventureReader_SplitCsvLine_QuotedCommaOneValueSplit", "first value doesn't match");
}

void Test_AdventureReader_SplitCsvLine_LeadingEmpty()
{
  AdventureReader reader = new AdventureReader();
  
  String sLine = ",this,that";
  String[] values = reader.SplitCsvLine(sLine);
  
  TestTrue(values[0].compareTo("") == 0, "Test_AdventureReader_SplitCsvLine_QuotedCommaOneValueSplit", "first value doesn't match");
  TestTrue(values[1].compareTo("this") == 0, "Test_AdventureReader_SplitCsvLine_EmptyTrailingValueThreeValues", "second value doesn't match");
  TestTrue(values[2].compareTo("that") == 0, "Test_AdventureReader_SplitCsvLine_EmptyTrailingValueThreeValues", "third value doesn't match");
}

void Test_AdventureReader_SplitCsvLine_EmptyTrailingValueThreeValues()
{
  AdventureReader reader = new AdventureReader();
  
  String sLine = "this,that,";
  String[] values = reader.SplitCsvLine(sLine);
  
  TestTrue(values[0].compareTo("this") == 0, "Test_AdventureReader_SplitCsvLine_EmptyTrailingValueThreeValues", "first value doesn't match");
  TestTrue(values[1].compareTo("that") == 0, "Test_AdventureReader_SplitCsvLine_EmptyTrailingValueThreeValues", "second value doesn't match");
  TestTrue(values[2].compareTo("") == 0, "Test_AdventureReader_SplitCsvLine_EmptyTrailingValueThreeValues", "third value doesn't match");
}

void Test_AdventureReader_SplitCsvLine_QuotedEmptyTrailingValueThreeValues()
{
  AdventureReader reader = new AdventureReader();
  
  String sLine = "\"this\",\"that\",\"\"";
  String[] values = reader.SplitCsvLine(sLine);
  
  TestTrue(values[0].compareTo("this") == 0, "Test_AdventureReader_SplitCsvLine_QuotedEmptyTrailingValueThreeValues", "first value doesn't match");
  TestTrue(values[1].compareTo("that") == 0, "Test_AdventureReader_SplitCsvLine_QuotedEmptyTrailingValueThreeValues", "second value doesn't match");
  TestTrue(values[2].compareTo("") == 0, "Test_AdventureReader_SplitCsvLine_QuotedEmptyTrailingValueThreeValues", "third value doesn't match");
}
/*
        String csvHeader = headers[i];
        if (csvHeader.compareToIgnoreCase("NodeID") == 0) m_icsvNodeID = i;
        else if (csvHeader.compareToIgnoreCase("EntryText") == 0) m_icsvEntryText = i;
        else if (csvHeader.compareToIgnoreCase("BodyText") == 0) m_icsvBodyText = i;
        else if (csvHeader.compareToIgnoreCase("PromptText") == 0) { m_icsvPromptText = i; m_icsvOptionStart = i + 1; }
        else if (csvHeader.compareToIgnoreCase("OptionMenuID") == 0) m_dicsvOptionMenuID = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("OptionRoommateReq1") == 0) m_dicsvReqRoommate = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("OptionRoommateMod1") == 0) m_dicsvModRoommate = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("OptionFriendReq1") == 0) m_dicsvReqFriend = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("OptionFriendMod1") == 0) m_dicsvModFriend = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("OptionPopularityReq1") == 0) m_dicsvReqPopularity = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("OptionPopularityMod1") == 0) m_dicsvModPopularity = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("OptionHappinessMod1") == 0) m_dicsvModHappiness = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("OptionHappinessReq1") == 0) m_dicsvReqHappiness = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("EntryText") == 0) m_dicsvModHappiness = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("OptionActionText1") == 0) m_dicsvActionText = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("OptionNodeLink1") == 0) m_dicsvNextNodeID = i - m_icsvOptionStart;*/

void Test_AdventureReader_ReadHeaderCsvLine_NodeID()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID";
  
  reader.m_icsvNodeID = -1; // so we can see a difference
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvNodeID == 0, "Test_AdventureReader_ReadHeaderCsvLine_NodeID", "expected icsv not set");
}

void Test_AdventureReader_ReadHeaderCsvLine_EntryText()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,EntryText";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvEntryText == 1, "Test_AdventureReader_ReadHeaderCsvLine_EntryText", "expected icsv not set");
}

void Test_AdventureReader_ReadHeaderCsvLine_BodyText()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,BodyText";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvBodyText == 1, "Test_AdventureReader_ReadHeaderCsvLine_BodyText", "expected icsv not set");
}
void Test_AdventureReader_ReadHeaderCsvLine_PromptText()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvPromptText == 1, "Test_AdventureReader_ReadHeaderCsvLine_PromptText", "expected icsv not set");
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_PromptText", "expected icsv not set for option start");
}
void Test_AdventureReader_ReadHeaderCsvLine_OptionMenuID1()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1";
  
  reader.m_dicsvOptionMenuID = -1;
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionMenuID1", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvOptionMenuID == 0, "Test_AdventureReader_ReadHeaderCsvLine_OptionMenuID1", "expected dicsv not set");
}
void Test_AdventureReader_ReadHeaderCsvLine_OptionText1()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionText1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionText1", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvOptionText == 1, "Test_AdventureReader_ReadHeaderCsvLine_OptionText1", "expected dicsv not set");
}

void Test_AdventureReader_ReadHeaderCsvLine_OptionRoommateReq1()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionRoommateReq1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionRoommateReq1", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvReqRoommate == 1, "Test_AdventureReader_ReadHeaderCsvLine_OptionRoommateReq1", "expected dicsv not set");
}
void Test_AdventureReader_ReadHeaderCsvLine_OptionRoommateMod1()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionRoommateMod1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionRoommateMod1", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvModRoommate == 1, "Test_AdventureReader_ReadHeaderCsvLine_OptionRoommateMod1", "expected dicsv not set");
}
void Test_AdventureReader_ReadHeaderCsvLine_OptionFriendReq1()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionFriendReq1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionFriendReq1", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvReqFriend == 1, "Test_AdventureReader_ReadHeaderCsvLine_OptionFriendReq1", "expected dicsv not set");
}

void Test_AdventureReader_ReadHeaderCsvLine_OptionFriendMod1()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionFriendMod1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionFriendMod1", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvModFriend == 1, "Test_AdventureReader_ReadHeaderCsvLine_OptionFriendMod1", "expected dicsv not set");
}
void Test_AdventureReader_ReadHeaderCsvLine_OptionPopularityReq1()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionPopularityReq1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionPopularityReq1", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvReqPopularity == 1, "Test_AdventureReader_ReadHeaderCsvLine_OptionPopularityReq1", "expected dicsv not set");
}
void Test_AdventureReader_ReadHeaderCsvLine_OptionPopularityMod1()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionPopularityMod1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionPopularityMod1", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvModPopularity == 1, "Test_AdventureReader_ReadHeaderCsvLine_OptionPopularityMod1", "expected dicsv not set");
}
void Test_AdventureReader_ReadHeaderCsvLine_OptionHappinessReq1()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionHappinessReq1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionHappinessReq1", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvReqHappiness == 1, "Test_AdventureReader_ReadHeaderCsvLine_OptionHappinessReq1", "expected dicsv not set");
}
void Test_AdventureReader_ReadHeaderCsvLine_OptionHappinessMod1()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionHappinessMod1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionHappinessMod1", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvModHappiness == 1, "Test_AdventureReader_ReadHeaderCsvLine_OptionHappinessMod1", "expected dicsv not set");
}
void Test_AdventureReader_ReadHeaderCsvLine_OptionActionText1()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionActionText1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionActionText1", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvActionText == 1, "Test_AdventureReader_ReadHeaderCsvLine_OptionActionText1", "expected dicsv not set");
}
void Test_AdventureReader_ReadHeaderCsvLine_OptionNodeLink()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionNodeLink1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_ReadHeaderCsvLine_OptionNodeLink", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvNextNodeID == 1, "Test_AdventureReader_ReadHeaderCsvLine_OptionNodeLink", "expected dicsv not set");
}

void Test_AdventureReader_IChoiceColumnCalculate()
{
  AdventureReader reader = new AdventureReader();
  
  String sCsvHeader = "NodeID,PromptText,OptionMenuText1,OptionText1,OptionRoommateReq1,OptionRoommateMod1,OptionFriendReq1,OptionFriendMod1,OptionHappinessReq1,OptionHappinessMod1,OptionPopularityReq1,OptionPopularityMod1,OptionActionText1,OptionNodeLink1";
  
  reader.ReadHeaderCsvLine(sCsvHeader);
  
  TestTrue(reader.m_icsvOptionStart == 2, "Test_AdventureReader_IChoiceColumnCalculate", "expected icsv not set for option start");
  TestTrue(reader.m_dicsvNextNodeID == 11, "Test_AdventureReader_IChoiceColumnCalculate", "expected dicsv not set");
  
  
  TestTrue(reader.IcsvChoiceCalculate(0, reader.m_dicsvNextNodeID) == 11 + 2, "Test_AdventureReader_IChoiceColumnCalculate", "last column first group unexpected value");
  TestTrue(reader.IcsvChoiceCalculate(0, 0) == 0 + 2, "Test_AdventureReader_IChoiceColumnCalculate", "first column first group unexpected value");
  TestTrue(reader.IcsvChoiceCalculate(1, reader.m_dicsvNextNodeID) == 23 + 2, "Test_AdventureReader_IChoiceColumnCalculate", "last column second group unexpected value");
  TestTrue(reader.IcsvChoiceCalculate(1, 0) == 12 + 2, "Test_AdventureReader_IChoiceColumnCalculate", "last column second group unexpected value");
}
  
void GameTests()
{
  Test_AdventureReader_SplitCsvLine_SimpleTwoValueSplit();
  Test_AdventureReader_SplitCsvLine_SimpleOneValueSplit();
  Test_AdventureReader_SplitCsvLine_EmptyTrailingValueThreeValues();
  Test_AdventureReader_SplitCsvLine_LeadingEmpty();  
  Test_AdventureReader_SplitCsvLine_QuotedCommaOneValueSplit();
  Test_AdventureReader_SplitCsvLine_QuotedEmptyTrailingValueThreeValues();
 
  Test_AdventureReader_ReadHeaderCsvLine_NodeID();
  Test_AdventureReader_ReadHeaderCsvLine_EntryText();
  Test_AdventureReader_ReadHeaderCsvLine_BodyText();
  Test_AdventureReader_ReadHeaderCsvLine_PromptText();
  Test_AdventureReader_ReadHeaderCsvLine_OptionMenuID1();
  Test_AdventureReader_ReadHeaderCsvLine_OptionText1();
  Test_AdventureReader_ReadHeaderCsvLine_OptionRoommateReq1();
  Test_AdventureReader_ReadHeaderCsvLine_OptionRoommateMod1();
  Test_AdventureReader_ReadHeaderCsvLine_OptionFriendReq1();
  Test_AdventureReader_ReadHeaderCsvLine_OptionFriendMod1();
  Test_AdventureReader_ReadHeaderCsvLine_OptionPopularityReq1();
  Test_AdventureReader_ReadHeaderCsvLine_OptionPopularityMod1();
  Test_AdventureReader_ReadHeaderCsvLine_OptionHappinessReq1();
  Test_AdventureReader_ReadHeaderCsvLine_OptionHappinessMod1();
  Test_AdventureReader_ReadHeaderCsvLine_OptionNodeLink();
  Test_AdventureReader_ReadHeaderCsvLine_OptionActionText1();
  
  Test_AdventureReader_IChoiceColumnCalculate();
}