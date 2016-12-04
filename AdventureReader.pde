// This module reads an adventure Game from a CSV file (created from Excel or some other
// program)

class AdventureReader
{
  // all of these fields will keep track of which column maps to specific fields that
  // we care about reading

  // some of these columns are fixed (they are always at this index) and will be 
  // indexed by "icsv" values (index into a comma separated value)
  int m_icsvNodeID;
  int m_icsvEntryText;
  int m_icsvBodyText;
  int m_icsvPromptText;

  // there are 1 or more options per line, so we have to know what the column index
  // is for each option relative to a fixed point.  By convention, PromptText will always
  // be the column *preceeding* the first option, which means that the column index 
  // immediately following the prompt text will always be the first column for the first 
  // option

  // we will record the column index for the first option in icsvOptionStart
  int m_icsvOptionStart;

  // now, there are 12 possible columns that make up a single option. we will record
  // their relative position from icsvOptionStart (with "dicsv" -- delta index to a 
  // comma separated value)
  int m_dicsvOptionMenuID;
  int m_dicsvOptionText;
  int m_dicsvReqRoommate;
  int m_dicsvModRoommate;
  int m_dicsvReqFriend;
  int m_dicsvModFriend;
  int m_dicsvReqPopularity;
  int m_dicsvModPopularity;
  int m_dicsvReqHappiness;
  int m_dicsvModHappiness;
  int m_dicsvActionText;
  int m_dicsvNextNodeID;

  /* S U B S T R I N G  F R O M  Q U O T E D  S T R I N G */
  /*----------------------------------------------------------------------------
    %%Function: SubstringFromQuotedString
    %%Qualified: AdventureReader.SubstringFromQuotedString

    Extract a substring from the given string and the given bounds
    (this will remove any surrounding quotes, but only if they exactly
    start and end the string)
  ----------------------------------------------------------------------------*/
  String SubstringFromQuotedString(String s, int ichFirst, int ichLast)
  {
    if (ichFirst == ichLast)
      return "";

    if (s.charAt(ichFirst) == '"' && s.charAt(ichLast - 1) == '"')
    {
      return s.substring(ichFirst + 1, ichLast - 1);
    }
    else
    {
      return s.substring(ichFirst, ichLast);
    }
  }

  /* S P L I T  C S V  L I N E */
  /*----------------------------------------------------------------------------
    %%Function: SplitCsvLine
    %%Qualified: AdventureReader.SplitCsvLine

    split a string consisting of comma,separated,"values"

    returns an array of strings (with the bounding quotes removed, if they are
    present in the substring)
  ----------------------------------------------------------------------------*/
  String[] SplitCsvLine(String sLine)
  {
    int ichStart = 0;
    int ichCur = 0;
    String[] values = new String[0];
    boolean fQuoted = false;

    // while we haven't reached the end of the string, look for the beginning
    // of the next substring. when we find the beginning of the next substring,
    // then append that substring
    while (ichCur < sLine.length())
    {
      if (!fQuoted && sLine.charAt(ichCur) == ',')
      {
        values = (String[])append(values, SubstringFromQuotedString(sLine, ichStart, ichCur));

        ichStart = ichCur + 1;
      }
      if (sLine.charAt(ichCur) == '"')
      {
        fQuoted = !fQuoted;
      }
      ichCur++;
    }

    // got to the end of the string, which means there is one remaining substring
    // (which ends at the end of the string)
    values = (String[])append(values, SubstringFromQuotedString(sLine, ichStart, ichCur));
    return values;
  }

  /* G E T  G A M E  V A L U E  F R O M  V A L U E S */
  /*----------------------------------------------------------------------------
  	%%Function: GetGameValueFromValues
  	%%Qualified: AdventureReader.GetGameValueFromValues
   
    given an icsv for a value (like icsvNodeID, etc), return the value from
    the array of values that we got from the CSV.
   
    If the column isn't there (because it exceeds the length of our array of
    values), then return null
  ----------------------------------------------------------------------------*/
  String GetGameValueFromValues(String[] valuesCsv, int icsv)
  {
    if (icsv < valuesCsv.length)
    {
      String value = valuesCsv[icsv];
      
      return value;
    }
    return null;
  }
  
  /* I C S V  C H O I C E  C A L C U L A T E */
  /*----------------------------------------------------------------------------
  	%%Function: IcsvChoiceCalculate
  	%%Qualified: AdventureReader.IcsvChoiceCalculate
  	
  	given an iChoice (telling us what option we are looking at from the file,
  	like the first option or the second option), and given the dicsv for a
  	particular option column (like dicsvModRoommate), return the real index
  	into the array of values.
  ----------------------------------------------------------------------------*/
  int IcsvChoiceCalculate(int iChoice, int dicsvChoiceColumn)
  {
    return m_icsvOptionStart + (12 * iChoice) + dicsvChoiceColumn;
  }
  
  /* G A M E  N O D E  C R E A T E  F R O M  L I N E */
  /*----------------------------------------------------------------------------
  	%%Function: GameNodeCreateFromLine
  	%%Qualified: AdventureReader.GameNodeCreateFromLine
   
    take a given line from a CSV file and return a GameNode for it
    (taking care of reading in all of choices, etc.)
  ----------------------------------------------------------------------------*/
  GameNode GameNodeCreateFromLine(String sLineCsv)
  {
    // split the CSV line into an array of values
    String[] values = SplitCsvLine(sLineCsv);
    
    GameNode node = new GameNode();
    
    // fill in the easy stuff -- these are fixed columns in the array of values
    node.sNodeID = GetGameValueFromValues(values, m_icsvNodeID);
    node.sEntryText = GetGameValueFromValues(values, m_icsvEntryText);
    node.sBodyText = GetGameValueFromValues(values, m_icsvBodyText);
    node.sPromptText = GetGameValueFromValues(values, m_icsvPromptText);
    
    // figure out how many choices we have to read.  
    // There are 12 columns per choice (MenuID, Text, RoommateReq,Mod, FriendReq,Mod, PopularityReq,Mod,HappinessReq,Mod, ActionText, NextNodeID

    // figure out how many columns we have after the last non choice column (m_icsvOptionsStart). 
    
    int cChoices = (values.length - m_icsvOptionStart) / 12;

    // create a choice for each of the choices we expect to see
    for (int iChoice = 0; iChoice < cChoices; iChoice++)
    {
      // read in the MenuID for this choice.  If its empty, then this choice should be skipped and not read
      String choiceMenuID = GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvOptionMenuID));

      if (choiceMenuID != "")
      {
        // collect up the remaining 11 values for the choice
        String choiceText = GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvOptionText));
        int choiceRoommateMod = int(GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvModRoommate)));
        int choiceRoommateReq = int(GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvReqRoommate)));
        int choiceFriendReq = int(GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvReqFriend)));
        int choiceFriendMod = int(GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvModFriend)));
        int choiceHappinessReq = int(GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvReqHappiness)));
        int choiceHappinessMod = int(GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvModHappiness)));
        int choicePopularityReq = int(GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvReqPopularity)));
        int choicePopularityMod = int(GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvModPopularity)));
        String choiceActionText = GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvActionText));
        String choiceNextNodeID = GetGameValueFromValues(values, IcsvChoiceCalculate(iChoice, m_dicsvNextNodeID));
      
        // create the reqs and mods dictionaries (for requirements and modifications)  
        IntDict reqs = g_game.AttrsCreate4("Roommate", choiceRoommateReq, "Happiness", choiceHappinessReq, "Friend", choiceFriendReq, "Popularity", choicePopularityReq);
        IntDict mods = g_game.AttrsCreate4("Roommate", choiceRoommateMod, "Happiness", choiceHappinessMod, "Friend", choiceFriendMod, "Popularity", choicePopularityMod);

        // create the choice
        GameNodeChoice choice = g_game.CreateChoice(choiceMenuID, choiceText, reqs, mods, choiceActionText, choiceNextNodeID);

        // and add it to the game node we already created
        node.choices.put(choice.sMenuID, choice);
      }
    }
    
    return node;
  }
  

  /* R E A D  H E A D E R  C S V  L I N E */
  /*----------------------------------------------------------------------------
  	%%Function: ReadHeaderCsvLine
  	%%Qualified: AdventureReader.ReadHeaderCsvLine
   
    read the first line of the CSV file, which should be our header.
   
    this will tell us how to interpret the rest of the file (the column
    headings tell us which column is which)
  ----------------------------------------------------------------------------*/
  void ReadHeaderCsvLine(String sLine)
  {
    String[] headers = SplitCsvLine(sLine);

    for (int i = 0; i < headers.length; i++)
    {
      String csvHeader = headers[i];
      if (csvHeader.compareToIgnoreCase("NodeID") == 0)
        m_icsvNodeID = i;
      else if (csvHeader.compareToIgnoreCase("EntryText") == 0) 
        m_icsvEntryText = i;
      else if (csvHeader.compareToIgnoreCase("BodyText") == 0) 
        m_icsvBodyText = i;
      else if (csvHeader.compareToIgnoreCase("PromptText") == 0) 
      { 
        m_icsvPromptText = i; 
        m_icsvOptionStart = i + 1; 
      }
      else if (csvHeader.compareToIgnoreCase("OptionMenuText1") == 0) 
        m_dicsvOptionMenuID = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("OptionText1") == 0) 
        m_dicsvOptionText = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("OptionRoommateReq1") == 0)
        m_dicsvReqRoommate = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("OptionRoommateMod1") == 0)
        m_dicsvModRoommate = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("OptionFriendReq1") == 0) 
        m_dicsvReqFriend = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("OptionFriendMod1") == 0) 
        m_dicsvModFriend = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("OptionPopularityReq1") == 0) 
        m_dicsvReqPopularity = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("OptionPopularityMod1") == 0) 
        m_dicsvModPopularity = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("OptionHappinessMod1") == 0) 
        m_dicsvModHappiness = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("OptionHappinessReq1") == 0) 
        m_dicsvReqHappiness = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("EntryText") == 0) 
        m_dicsvModHappiness = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("OptionActionText1") == 0) 
        m_dicsvActionText = i - m_icsvOptionStart;
      else if (csvHeader.compareToIgnoreCase("OptionNodeLink1") == 0) 
        m_dicsvNextNodeID = i - m_icsvOptionStart;
    }
    
    // if we aren't running unit tests, then output some debug helper text to let
    // us know if we are missing any of the columns we expected to see.
    if (!vfRunningUnitTests)
    {
      if (m_icsvNodeID != 0)
        println("m_icsvNodeID is not at zero position!");
      if (m_icsvEntryText == 0)
        println("m_icsvEntryText header missing!");
      if (m_icsvBodyText == 0)
        println("m_icsvBodyText header missing!");
      if (m_icsvOptionStart == 0)
        println("m_icsvOptionStart header missing!"); 
      if (m_dicsvOptionMenuID != 0)
        println("m_dicsvOptionMenuID header is not at zero dicsv!");
      if (m_dicsvReqRoommate == 0)
        println("m_dicsvReqRoommate header missing!");
      if (m_dicsvModRoommate == 0)
        println("m_dicsvModRoommate header missing!");
      if (m_dicsvReqFriend == 0)
        println("m_dicsvReqFriend header missing!");
      if (m_dicsvModFriend == 0)
        println("m_dicsvModFriend header missing!");
      if (m_dicsvReqPopularity == 0)
        println("m_dicsvReqPopularity header missing!");
      if (m_dicsvModPopularity == 0)
        println("m_dicsvModPopularity header missing!");
      if (m_dicsvReqHappiness == 0)
        println("m_dicsvReqHappiness header missing!");
      if (m_dicsvModHappiness == 0)
        println("m_dicsvModHappiness header missing!");
      if (m_dicsvActionText == 0)
        println("m_dicsvActionText header missing!");
      if (m_dicsvNextNodeID == 0)
        println("m_dicsvNextNodeID header missing!");
    }
  }
  
  /* R E A D  A D V E N T U R E  G A M E */
  /*----------------------------------------------------------------------------
  	%%Function: ReadAdventureGame
  	%%Qualified: AdventureReader.ReadAdventureGame
   
    read the adventure game defined by the file at sFile (should be a CSV
    file describing the game).  The game will be read into the given game
  ----------------------------------------------------------------------------*/
  void ReadAdventureGame(String sFile, Game game)
  {
    BufferedReader reader = createReader(sFile);
    String sLine;
    
    // read in the first line, which will be the heading line for the CSV
    try
    {
      sLine = reader.readLine();
    } 
    catch (IOException e)
    {
      e.printStackTrace();
      return;
    }

    // interpret the CSV header line and remember our column definitions
    ReadHeaderCsvLine(sLine);
    
    
    // now, continue reading lines until we get to the end of the file (which
    // we will know we have reached because reader.readLine() will return null)    
    while (true)
    {
      try
      {
        sLine = reader.readLine();
      } 
      catch (IOException e)
      {
        e.printStackTrace();
        return;
      }
    
      if (sLine == null)
        return;
    
      // create a GameNode for the line    
      GameNode node = GameNodeCreateFromLine(sLine);
      
      // and add it to the game (game nodes are just hashmap entries that
      // map from the ID of the node to the node itself)
      game.m_gameNodes.put(node.sNodeID, node);
    }
  }
}