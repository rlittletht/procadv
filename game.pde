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

    // initialize the attributes that we track. For now, that's Roommate, Happiness, Popularity, Friend
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
  
  /* A T T R S  C R E A T E  3*/
  /*----------------------------------------------------------------------------
  	%%Function: AttrsCreate3
  	%%Qualified: Game.AttrsCreate3
  	
    create a dictionary of attributes (given in 3 pairs)
  ----------------------------------------------------------------------------*/
  IntDict AttrsCreate3(String sAttr1, int nAttr1, String sAttr2, int nAttr2, String sAttr3, int nAttr3)
  {
    IntDict attrs = new IntDict();
    
    attrs.add(sAttr1, nAttr1);
    attrs.add(sAttr2, nAttr2);
    attrs.add(sAttr3, nAttr3);
    
    return attrs;
  }
  
  /* A T T R S  C R E A T E  4 */
  /*----------------------------------------------------------------------------
  	%%Function: AttrsCreate4
  	%%Qualified: Game.AttrsCreate4
   
    create a dictionary of attributes (given in 4 pairs)
  ----------------------------------------------------------------------------*/
  IntDict AttrsCreate4(String sAttr1, int nAttr1, String sAttr2, int nAttr2, String sAttr3, int nAttr3, String sAttr4, int nAttr4)
  {
    IntDict attrs = AttrsCreate3(sAttr1, nAttr1, sAttr2, nAttr2, sAttr3, nAttr3);
    
    attrs.add(sAttr4, nAttr4);
    
    return attrs;
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

  