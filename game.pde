import java.util.Map;  // needed to be able to access some of the lower level HashMap functionality

// This module implements the actual game


// ================================================================================
//  G A M E  N O D E  C H O I C E 
// 
// Every game node has a set of choices that the user can take.
// 
// Each choice has:
//   reqs
//        a set of attributes that must be satisfied in order for the choice to 
//        be available to the player. (i.e. popularity must be at least 50, or
//        happiness must be at least 0.  if there is no minimum value, typically
//        that is set to be a minimum of -999 or some other very small value). 
//        if any req isn't met, then the choice won't be shown to the player
//   mods
//        a set of attributes that will be adjusted if the choice is taken
//        by the player. the value for each mod will be added to the current
//        attribute. (positive numbers increase the value, negative decrease, 
//        0 means no change)
//   sActionText
//        this is the text that is shown to the player if they take the choice
//   sNextNodeID
//        if the choice is taken, then this NodeID becomes the new current 
//        game node. It *can* be the same node as we started from.
//   sMenuID
//        this is purely internal -- it is used by the UI to tell us which
//        choice the player chose
//   sText
//        this is the text that will be shown in the UI for the choice (so the
//        player knows something about what the choice is.  e.g. "Sit down" or
//        "Turn light on"
// 
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
   
    constructor for the GameNodeChoice
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
// 
// Each game node represents a single "state" in the game. Game play progresses
// by moving from GameNode to GameNode. 
// 
// Each game node has:
// 
//   sNodeID
//        an identifier that is used as both the key in the games hashmap of nodes
//        as well as the way that choices identify which node to move to if the
//        choice is take
//   sEntryText
//        this is shown in the game window when the player enters this game node
//        (it will not be shown if they repeat the same node -- i.e. if they
//         go to node "foo" while they are already in node "foo")
//   sBodyText
//        this is shown in the game window when the user is in this node.
//   sPromptText
//        this is shown in the game window before asking the user to make a choice
// 
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
// 
// The game is just a set of possible nodes, the current game node, and the
// current set of attributes for the player. The player makes a choice from a set
// of choices that the current node has, the mods are applied to the current
// set of attributes, and the next node from the choice becomes the new current
// node
// ================================================================================
class Game
{
  // the hashmap of game nodes (NodeID => GameNode)
  HashMap<String, GameNode> m_gameNodes;

  // the current set of attributes. starts at all zeros.
  IntDict m_attrsCurrent;

  // this is true if they are just coming back to the same room again (allows us to not print the "enter" text for the room)
  boolean m_fReenter; 
  
  // the current node
  String m_sCurrentNodeID;
  
  /* G A M E */
  /*----------------------------------------------------------------------------
  	%%Function: Game
  	%%Qualified: Game.Game
   
    constructor for the game, called when the object is created. implicitly
    resets the game
  ----------------------------------------------------------------------------*/
  Game()
  {
    m_gameNodes = new HashMap<String, GameNode>();
    m_attrsCurrent = new IntDict();
    
    ResetGame();
  }

  /* R E S E T  G A M E */
  /*----------------------------------------------------------------------------
  	%%Function: ResetGame
  	%%Qualified: Game.ResetGame
   
    reset the current game - sets the current node back to "Enter" and resets
    the attributes to all zeros
  ----------------------------------------------------------------------------*/
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
   
    Apply the chosen menu choice to the game state and set the new current node
   
    This only takes care of game internal state -- it applies all the mods
    for the given choice to the game state and sets the new current node
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
  
  /* G E T  E N T R Y  T E X T */
  /*----------------------------------------------------------------------------
  	%%Function: GetEntryText
  	%%Qualified: Game.GetEntryText
   
    This will return the Entry Text (for the UI) for the current node
  ----------------------------------------------------------------------------*/
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
   
    This will return the Body Text (for the UI) for the current node
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
   
    This will return the Prompt Text (for the UI) for the current node
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
   
    The UI will call this to get the set of possible choices for the current
    node.  Not all of these nodes are going to be possible for the player
    to execute, so the UI will have to pay attention to the return value from
    GetOptionTextFromOptionKey to be sure they should show the option)
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
   
    The UI will iterate over all the possible option keys (returned from
    GetOptionsKeys) in order to know which choices to present to the player
    in the UI
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
   
    just dump the current player attributes to the console (for debugging)
  ----------------------------------------------------------------------------*/
  void PrintAttrsCurrent(String msg)
  {
    for (String sKey : m_attrsCurrent.keyArray())
    {
      print(msg + "|| " + sKey + ": " + String.valueOf(m_attrsCurrent.get(sKey)) + ", ");
    }
    println();
  }
 
  /* F  C H E C K  G A M E  N O D E */
  /*----------------------------------------------------------------------------
  	%%Function: FCheckGameNode
  	%%Qualified: Game.FCheckGameNode
   
    this checks the given game node for consistency (to make sure that it
    points at game node ID's that really exist)
  ----------------------------------------------------------------------------*/
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
  
  /* C H E C K  G A M E  N O D E S */
  /*----------------------------------------------------------------------------
  	%%Function: CheckGameNodes
  	%%Qualified: Game.CheckGameNodes
   
    Go through all the game nodes and make sure they are consistent. also, make
    sure that all the game nodes we create are all reachable by some choice.
  ----------------------------------------------------------------------------*/
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

  /* R E A D  A D V E N T U R E  G A M E */
  /*----------------------------------------------------------------------------
  	%%Function: ReadAdventureGame
  	%%Qualified: Game.ReadAdventureGame
   
    Read the given adventure game csv file into this game
  ----------------------------------------------------------------------------*/
  void ReadAdventureGame(String sFile)
  {
    AdventureReader reader = new AdventureReader();
    reader.ReadAdventureGame(sFile, this);
  }
  
}

  