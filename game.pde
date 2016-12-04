import java.util.Map;  // needed to be able to access some of the lower level HashMap functionality

// ================================================================================
//  G A M E  N O D E  C H O I C E 
// ================================================================================
class GameNodeChoice
{
  IntDict reqs;  // dictionary mapping the attribute name to an integer for requirements for this choice to show up
  IntDict mods;  // dictionary mapping the attribute name ot an integer for modifications that will happen upon selecting this choice
  
  String sActionText; // the text that will show in response to taking this action
  String sNextNodeID; // the node that we go to if this action is taken
  String sMenuID; // the text that will be communicated back to us when they select a choice
  String sText; // the text that will show to the user in the UI
  
  /* G A M E  N O D E  C H O I C E */
  /*----------------------------------------------------------------------------
  	%%Function: GameNodeChoice
  	%%Qualified: GameNodeChoice.GameNodeChoice
  	
  ----------------------------------------------------------------------------*/
  GameNodeChoice(String sMenuTextIn, String sTextIn, IntDict reqsIn, IntDict modsIn, String sActionTextIn, String sNextNodeIDIn)
  {
    reqs = reqsIn;
    mods = modsIn;
    sActionText = sActionTextIn;
    sNextNodeID = sNextNodeIDIn;
    sMenuID = sMenuTextIn;
    sText = sTextIn;
  }
}

// ================================================================================
//  G A M E  N O D E 
// ================================================================================
class GameNode
{
  String sNodeID;
  String sEntryText;
  String sBodyText;
  String sPromptText;
  
  HashMap<String, GameNodeChoice> choices;  // map ChoiceMenuText to choice

  boolean fMarked; // for our mark and sweep error detection
  
  GameNode()
  {
    choices = new HashMap<String, GameNodeChoice>();
  }
}

// ================================================================================
//  G A M E 
// ================================================================================
class Game
{
  HashMap<String, GameNode> m_gameNodes;
  IntDict m_attrsCurrent;
  boolean m_fReenter; // this is true if they are just coming back to the same room again (allows us to not print the "enter" text for the room)
  
  String m_sCurrentNodeID;
  
  Game()
  {
    m_gameNodes = new HashMap<String, GameNode>();
    m_attrsCurrent = new IntDict();
    
    ResetGame();
  }

  void ResetGame()
  {
    m_sCurrentNodeID = "Enter";
    m_attrsCurrent.add("Roommate", 0);
    m_attrsCurrent.add("Happiness", 0);
    m_attrsCurrent.add("Popularity", 0);
    m_attrsCurrent.add("Friend", 0);
  }
  
  /* C R E A T E  C H O I C E */
  /*----------------------------------------------------------------------------
  	%%Function: CreateChoice
  	%%Qualified: Game.CreateChoice
   
    create a choice with the given parameters
   
      menuID - this is the internal ID that will be used to refer to this
               choice (the UI will use it to tell us which option they picked)
      choiceTest - this is the text the user will see describing the choice
      reqs - these are the attribute requirements that must be met for the
             choice to be presented to the user
      mods - these are the changes that will be applied to the attributes
             if this choice is taken
      actionText - this is the text that will be shown to the user if the
                   action is taken
      sNextNodeID - this is the node that will be the "current node" if
                    this action is taken
  ----------------------------------------------------------------------------*/
  GameNodeChoice CreateChoice(String menuID, String choiceText, IntDict reqs, IntDict mods, String actionText, String sNextNodeID)
  {
    return new GameNodeChoice(menuID, choiceText, reqs, mods, actionText, sNextNodeID);
  }
  
  /* A T T R S  C R E A T E */
  /*----------------------------------------------------------------------------
  	%%Function: AttrsCreate
  	%%Qualified: Game.AttrsCreate
  	
  ----------------------------------------------------------------------------*/
  IntDict AttrsCreate(String sAttr1, int nAttr1, String sAttr2, int nAttr2, String sAttr3, int nAttr3)
  {
    IntDict attrs = new IntDict();
    
    attrs.add(sAttr1, nAttr1);
    attrs.add(sAttr2, nAttr2);
    attrs.add(sAttr3, nAttr3);
    
    return attrs;
  }
  
  IntDict AttrsCreate4(String sAttr1, int nAttr1, String sAttr2, int nAttr2, String sAttr3, int nAttr3, String sAttr4, int nAttr4)
  {
    IntDict attrs = AttrsCreate(sAttr1, nAttr1, sAttr2, nAttr2, sAttr3, nAttr3);
    
    attrs.add(sAttr4, nAttr4);
    
    return attrs;
  }
  
  /* G A M E  N O D E  C R E A T E  F R O M  S T R E A M */
  /*----------------------------------------------------------------------------
  	%%Function: GameNodeCreateFromStream
  	%%Qualified: Game.GameNodeCreateFromStream
  	
  ----------------------------------------------------------------------------*/
  GameNode GameNodeCreateFromStream(int n)
  {
    GameNode gameNode = new GameNode();
    GameNodeChoice choice;
    
    switch (n)
    {
      case 0:
        gameNode.sNodeID = "Enter";
        gameNode.sEntryText = "(Enter) Entry text";
        gameNode.sBodyText = "(Enter) Body Text";
        gameNode.sPromptText = "(Enter) Prompt text";
        choice = CreateChoice("menu1", "Option1: Go to State1", AttrsCreate("Roommate", -999, "Happiness", -999, "Popularity", -999), AttrsCreate("Roommate", 0, "Happiness", 0, "Popularity", 0), "Option 1 Action", "state1");
        gameNode.choices.put(choice.sMenuID, choice);
        
        choice = CreateChoice("menu2", "Option2: Go to State2 More Happy", AttrsCreate("Roommate", -999, "Happiness", -999, "Popularity", -999), AttrsCreate("Roommate", 0, "Happiness", 50, "Popularity", 0), "Option 2 Action", "state2");
        gameNode.choices.put(choice.sMenuID, choice);
        
        choice = CreateChoice("menu3", "Option3: Repeat Enter Grumpy Roommate", AttrsCreate("Roommate", -999, "Happiness", -999, "Popularity", -999), AttrsCreate("Roommate", -50, "Happiness", 0, "Popularity", 0), "Option 3 Action", "Enter");
        gameNode.choices.put(choice.sMenuID, choice);
        break;
      case 1:
        gameNode.sNodeID = "state1";
        gameNode.sEntryText = "(state1) Entry text";
        gameNode.sBodyText = "(state1) Body Text";
        gameNode.sPromptText = "(state1) Prompt text";
        
        choice = CreateChoice("menu1", "Option1: Go to enter", AttrsCreate("Roommate", -999, "Happiness", -999, "Popularity", -999), AttrsCreate("Roommate", 0, "Happiness", 0, "Popularity", 0), "Option 1 Action", "Enter");
        gameNode.choices.put(choice.sMenuID, choice);
        
        choice = CreateChoice("menu2", "Option2: Go to State3 only happy roommate", AttrsCreate("Roommate", 25, "Happiness", -999, "Popularity", -999), AttrsCreate("Roommate", 0, "Happiness", 50, "Popularity", 0), "Option 2 Action", "state3");
        gameNode.choices.put(choice.sMenuID, choice);
        
        choice = CreateChoice("menu3", "Option3: Repeat Enter Grumpier Roommate", AttrsCreate("Roommate", -999, "Happiness", -999, "Popularity", -999), AttrsCreate("Roommate", -50, "Happiness", 0, "Popularity", 0), "Option 3 Action", "Enter");
        gameNode.choices.put(choice.sMenuID, choice);
        break;
      case 2:
        gameNode.sNodeID = "state2";
        gameNode.sEntryText = "(state2) Entry text";
        gameNode.sBodyText = "(state2) Body Text";
        gameNode.sPromptText = "(state2) Prompt text";
        
        choice = CreateChoice("menu1", "Option1: Go to state1", AttrsCreate("Roommate", -999, "Happiness", -999, "Popularity", -999), AttrsCreate("Roommate", 0, "Happiness", 0, "Popularity", 0), "Option 1 Action", "state1");
        gameNode.choices.put(choice.sMenuID, choice);
        break;
      case 3:
        gameNode.sNodeID = "state3";
        gameNode.sEntryText = "(state3) Entry text";
        gameNode.sBodyText = "(state3) Body Text";
        gameNode.sPromptText = "(state3) Prompt text";
        
        choice = CreateChoice("menu1", "Option1: Go to state1", AttrsCreate("Roommate", -999, "Happiness", -999, "Popularity", -999), AttrsCreate("Roommate", 0, "Happiness", 0, "Popularity", 0), "Option 1 Action", "state1");
        gameNode.choices.put(choice.sMenuID, choice);
        break;
    }
    return gameNode;
  }
    
  
  /* R E A D  G A M E  N O D E S */
  /*----------------------------------------------------------------------------
  	%%Function: ReadGameNodes
  	%%Qualified: Game.ReadGameNodes
  	
  ----------------------------------------------------------------------------*/
  void ReadGameNodes()
  {
    GameNode node;
    
    node = GameNodeCreateFromStream(0);
    m_gameNodes.put(node.sNodeID, node);
    node = GameNodeCreateFromStream(1);
    m_gameNodes.put(node.sNodeID, node);
    node = GameNodeCreateFromStream(2);
    m_gameNodes.put(node.sNodeID, node);
    node = GameNodeCreateFromStream(3);
    m_gameNodes.put(node.sNodeID, node);
  }
  
  /* G E T  A C T I O N  T E X T  F O R  M E N U  C H O I C E */
  /*----------------------------------------------------------------------------
  	%%Function: GetActionTextForMenuChoice
  	%%Qualified: Game.GetActionTextForMenuChoice
  	
  ----------------------------------------------------------------------------*/
  String GetActionTextForMenuChoice(String sMenuChoice)
  {
    if (sMenuChoice == null)
      return null;
  
    GameNode node = m_gameNodes.get(m_sCurrentNodeID);
    GameNodeChoice choice = node.choices.get(sMenuChoice);
    
    return choice.sActionText;
  }
  
  /* E X E C U T E  A C T I O N  F O R  M E N U  C H O I C E */
  /*----------------------------------------------------------------------------
  	%%Function: ExecuteActionForMenuChoice
  	%%Qualified: Game.ExecuteActionForMenuChoice
  	
  ----------------------------------------------------------------------------*/
  void ExecuteActionForMenuChoice(String sMenuChoice)
  {
    if (sMenuChoice == null)
    {
      m_sCurrentNodeID = "Enter";
      
      m_fReenter = false;
      return;
    }
    
    // apply all the mods to our current state
    GameNode node = m_gameNodes.get(m_sCurrentNodeID);
    GameNodeChoice choice = node.choices.get(sMenuChoice);
    
    for (String sKey : choice.mods.keyArray())
    {
      int n = m_attrsCurrent.get(sKey);
      int nMod = choice.mods.get(sKey);
      n += nMod;
      
      m_attrsCurrent.set(sKey, n);
    }
    
    // and set the new node
    m_sCurrentNodeID = choice.sNextNodeID;
  }
  
  String GetEntryText()
  {
    if (m_fReenter)
      return null;
      
    GameNode node = m_gameNodes.get(m_sCurrentNodeID);
    return node.sEntryText;
  }
  
  /* G E T  B O D Y  T E X T */
  /*----------------------------------------------------------------------------
  	%%Function: GetBodyText
  	%%Qualified: Game.GetBodyText
  	
  ----------------------------------------------------------------------------*/
  String GetBodyText()
  {
    GameNode node = m_gameNodes.get(m_sCurrentNodeID);
    return node.sBodyText;
  }
  
  /* G E T  P R O M P T  T E X T */
  /*----------------------------------------------------------------------------
  	%%Function: GetPromptText
  	%%Qualified: Game.GetPromptText
  	
  ----------------------------------------------------------------------------*/
  String GetPromptText()
  {
    GameNode node = m_gameNodes.get(m_sCurrentNodeID);
    return node.sPromptText;
  }
  
  /* G E T  O P T I O N S  K E Y S */
  /*----------------------------------------------------------------------------
  	%%Function: GetOptionsKeys
  	%%Qualified: Game.GetOptionsKeys
  	
  ----------------------------------------------------------------------------*/
  String[] GetOptionsKeys()
  {
    GameNode node = m_gameNodes.get(m_sCurrentNodeID);
    String[] rgs = new String[0];
    
    for (Map.Entry me : node.choices.entrySet())
    {
      rgs = append(rgs, (String)me.getKey());
    }
    return rgs;
    //return (String[])(node.choices.keySet().toArray());
  }
  
  /* G E T  O P T I O N  T E X T  F R O M  O P T I O N  K E Y */
  /*----------------------------------------------------------------------------
  	%%Function: GetOptionTextFromOptionKey
  	%%Qualified: Game.GetOptionTextFromOptionKey
  	
  ----------------------------------------------------------------------------*/
  String GetOptionTextFromOptionKey(String sMenuOption)
  {
    GameNode node = m_gameNodes.get(m_sCurrentNodeID);
    GameNodeChoice choice = node.choices.get(sMenuOption);
    
    // check to make sure that this option is valid (the reqs are met)
    
    for (String sKey : choice.reqs.keyArray())
    {
      int nReq = choice.reqs.get(sKey);
      int nCur = m_attrsCurrent.get(sKey);
      
      if (nCur < nReq)
      {
        println("FAILED REQ CHECK: " + sKey + "(" + String.valueOf(nReq) + " > " + String.valueOf(nCur) + ")");
        return null;
      }
    }
    
    return choice.sText;
  }
  
  /* P R I N T  A T T R S  C U R R E N T */
  /*----------------------------------------------------------------------------
  	%%Function: PrintAttrsCurrent
  	%%Qualified: Game.PrintAttrsCurrent
  	
  ----------------------------------------------------------------------------*/
  void PrintAttrsCurrent(String msg)
  {
    for (String sKey : m_attrsCurrent.keyArray())
    {
      print(msg + "|| " + sKey + ": " + String.valueOf(m_attrsCurrent.get(sKey)) + ", ");
    }
    println();
  }
 
  boolean FCheckGameNode(GameNode node)
  {
    for (Map.Entry me : node.choices.entrySet())
    {
      GameNodeChoice choice = (GameNodeChoice)me.getValue();
      
      // verify that the next item is valid
      if (!m_gameNodes.containsKey(choice.sNextNodeID))
      {
        println("NODE '" + node.sNodeID + "' Validation FAILED: Choice MenuID['" + choice.sMenuID + "'] has bad sNextNodeID: '" + choice.sNextNodeID + "'");
        return false;
      }
      else
      {
        GameNode nodeNext = m_gameNodes.get(choice.sNextNodeID);
        nodeNext.fMarked = true;
      }
    }
    return true;
  }
  
  void CheckGameNodes()
  {
    boolean fGameOK = true; // assume OK
    
    for (Map.Entry me : m_gameNodes.entrySet())
    {
      GameNode node = (GameNode)me.getValue();
      fGameOK = FCheckGameNode(node) && fGameOK;
    }

    m_gameNodes.get("Enter").fMarked = true;
    
    for (Map.Entry me : m_gameNodes.entrySet())
    {
      GameNode node = (GameNode)me.getValue();
      if (!node.fMarked)
      {
        println("NODE '" + node.sNodeID + "' UNREACHABLE");
      }
    }

    
    if (fGameOK)
      println("Game passed all validation tests");
    else
      println("Game FAILED to pass validation tests");
  }

  void ReadAdventureGame(String sFile)
  {
    AdventureReader reader = new AdventureReader();
    reader.ReadAdventureGame(sFile, this);
  }
  
}

  class AdventureReader
  {
    String SubstringFromQuotedString(String s, int ichFirst, int ichLast)
    {
      if (ichFirst == ichLast)
        return "";
//      println("String: " + s + "(" + String.valueOf(ichFirst) + ":" + String.valueOf(ichLast)+")");
      
      if (s.charAt(ichFirst) == '"' && s.charAt(ichLast - 1) == '"')
      {
        return s.substring(ichFirst + 1, ichLast - 1);
      }
      else
      {
        return s.substring(ichFirst, ichLast);
      }
    }
    
    String[] SplitCsvLine(String sLine)
    {
      int ichStart = 0;
      int ichCur = 0;
      String[] values = new String[0];
      boolean fQuoted = false;
      
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
      
      // got to the end, append the last string
      values = (String[])append(values, SubstringFromQuotedString(sLine, ichStart, ichCur));
      return values;
    }
    
    int m_icsvNodeID;
    int m_icsvEntryText;
    int m_icsvBodyText;
    int m_icsvPromptText;
    int m_icsvOptionStart;
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

    String GetGameValueFromValues(String[] values, int i)
    {
      if (i < values.length)
      {
        String value = values[i];
        
        return value;
      }
      return null;
    }
    
    int IChoiceColumnCalculate(int iChoice, int diChoiceColumn)
    {
      return m_icsvOptionStart + (12 * iChoice) + diChoiceColumn;
    }
    
    GameNode GameNodeCreateFromLine(String sLine)
    {
      String[] values = SplitCsvLine(sLine);
      
      GameNode node = new GameNode();
      
      node.sNodeID = GetGameValueFromValues(values, m_icsvNodeID);
      node.sEntryText = GetGameValueFromValues(values, m_icsvEntryText);
      node.sBodyText = GetGameValueFromValues(values, m_icsvBodyText);
      node.sPromptText = GetGameValueFromValues(values, m_icsvPromptText);
      
      // figure out how many choices we have to read.  There are 12 columns per choice (MenuID, Text, RoommateReq,Mod, FriendReq,Mod, PopularityReq,Mod,HappinessReq,Mod, ActionText, NextNodeID)
      // figure out how many columns we have after the last non choice column (m_icsvOptionsStart). 
      
      int cChoices = (values.length - m_icsvOptionStart) / 12;
      println("Node '" + node.sNodeID + ": reading " + String.valueOf(cChoices) + " choices");
      for (int iChoice = 0; iChoice < cChoices; iChoice++)
      {
        String choiceMenuID = GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvOptionMenuID));
        if (choiceMenuID != "")
        {
          String choiceText = GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvOptionText));
          int choiceRoommateMod = int(GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvModRoommate)));
          int choiceRoommateReq = int(GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvReqRoommate)));
          int choiceFriendReq = int(GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvReqFriend)));
          int choiceFriendMod = int(GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvModFriend)));
          int choiceHappinessReq = int(GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvReqHappiness)));
          int choiceHappinessMod = int(GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvModHappiness)));
          int choicePopularityReq = int(GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvReqPopularity)));
          int choicePopularityMod = int(GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvModPopularity)));
          String choiceActionText = GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvActionText));
          String choiceNextNodeID = GetGameValueFromValues(values, IChoiceColumnCalculate(iChoice, m_dicsvNextNodeID));
          
          IntDict reqs = g_game.AttrsCreate4("Roommate", choiceRoommateReq, "Happiness", choiceHappinessReq, "Friend", choiceFriendReq, "Popularity", choicePopularityReq);
          IntDict mods = g_game.AttrsCreate4("Roommate", choiceRoommateMod, "Happiness", choiceHappinessMod, "Friend", choiceFriendMod, "Popularity", choicePopularityMod);
          GameNodeChoice choice = g_game.CreateChoice(choiceMenuID, choiceText, reqs, mods, choiceActionText, choiceNextNodeID);
          node.choices.put(choice.sMenuID, choice);
        }
      }
      
      return node;
    }
    
    void ReadHeaderCsvLine(String sLine)
    {
      String[] headers = SplitCsvLine(sLine);

      for (int i = 0; i < headers.length; i++)
      {
        String csvHeader = headers[i];
        if (csvHeader.compareToIgnoreCase("NodeID") == 0) m_icsvNodeID = i;
        else if (csvHeader.compareToIgnoreCase("EntryText") == 0) m_icsvEntryText = i;
        else if (csvHeader.compareToIgnoreCase("BodyText") == 0) m_icsvBodyText = i;
        else if (csvHeader.compareToIgnoreCase("PromptText") == 0) { m_icsvPromptText = i; m_icsvOptionStart = i + 1; }
        else if (csvHeader.compareToIgnoreCase("OptionMenuText1") == 0) m_dicsvOptionMenuID = i - m_icsvOptionStart;
        else if (csvHeader.compareToIgnoreCase("OptionText1") == 0) m_dicsvOptionText = i - m_icsvOptionStart;
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
        else if (csvHeader.compareToIgnoreCase("OptionNodeLink1") == 0) m_dicsvNextNodeID = i - m_icsvOptionStart;
      }
      
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
        
        println("here1");
      }
    }
    
    void ReadAdventureGame(String sFile, Game game)
    {
      BufferedReader reader = createReader(sFile);
      String sLine;
      
      // read in the first line
      try
      {
        sLine = reader.readLine();
      } 
      catch (IOException e)
      {
        e.printStackTrace();
        return;
      }

      ReadHeaderCsvLine(sLine);
      
      
      // break it into an array of values (from the CSV)
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
          
        GameNode node = GameNodeCreateFromLine(sLine);
        game.m_gameNodes.put(node.sNodeID, node);
      }
      // keep reading until done...
    }
    
  }
  