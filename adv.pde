/*
  Adv.pde - 
  
  the main processing driver for the adventure game.  References two ready-built libraries
  of code -- Story and Game.
  
  Story manages the UI of the processing game
  Game manages the game reading, state management, and turn management
*/
  
Story g_story;
Game g_game;

/* M O V E */
/*----------------------------------------------------------------------------
	%%Function: Move
	%%Contact: rlittle
 
    top level move action. This is what is called when the user clicks on a
    UI element that has a move associated with it.  The story control will
    manage the UI and tell us what they clicked on.
 
    note that all of these updates happen during the move command, which
    updates the game state and the story window.  these updates will all get
    reflected when the window is updated on the next draw() call.
----------------------------------------------------------------------------*/
void Move(String sMenuChoice)
{
  println("moving for " + sMenuChoice);

  // print out some debug information to the console (what our current set of
  // attributes are) before executing the move

  g_game.PrintAttrsCurrent("Before Move");

  String sActionText = g_game.GetActionTextForMenuChoice(sMenuChoice);

  g_game.ExecuteActionForMenuChoice(sMenuChoice);
  
  // now update the story window with everything that has happened

  // first, add the text for the action that they chose

  g_story.StoryWindow().AddToStory("\n"); // add some space before our action text
  g_story.StoryWindow().AddToStory(sActionText);

  // now add the text for the new state they just transitioned into
  g_story.StoryWindow().AddToStory("\n"); // add some space before entry text
  g_story.StoryWindow().AddToStory(g_game.GetEntryText());

  // and add the body text for the new state
  g_story.StoryWindow().AddToStory("\n"); // add some space before body text
  g_story.StoryWindow().AddToStory(g_game.GetBodyText());

  // and now add the prompt for the new state
  g_story.StoryWindow().AddToStory("\n"); // add some space before prompt
  g_story.StoryWindow().AddToStory(g_game.GetPromptText());
  
  // update the story window with the new controls so the user know what the 
  // choices are

  // reset the controls (i.e. delete all the old ones)
  g_story.StoryControls().ResetControls();
  
  // and now get all the options the user has (skipping the null ones -- the
  // ones that are null are presumably not available because the user
  // doesn't qualify to see them, like too low a popularity, etc.
  String[] menuOptions = g_game.GetOptionsKeys();
  for (String s : menuOptions)
  {
    String sOptionText = g_game.GetOptionTextFromOptionKey(s);
    if (sOptionText != null)
      g_story.StoryControls().AddControl(s, sOptionText);  
  }

  // debug output
  g_game.PrintAttrsCurrent("After Move ");
}

/* S E T U P */
/*----------------------------------------------------------------------------
	%%Function: setup
	%%Contact: rlittle
 
    Setup the game and story window.  this all happens before the first
    draw() is invoked, so nothing happens on the screen until this
    completes.
----------------------------------------------------------------------------*/
void setup()
{
  // run the unit tests
  AdventureTests();

  // resize the main window (be sure to tell the story later what that size is)
  size(640,680);

//  frameRate(5);   // this is where you could change the frame rate (5 frames per second, in this case)

  // create the story window. tell the story how big its window is.  be honest.
  g_story = new Story(640, 680); 
  g_story.StoryWindow().AddToStory("Game shell version 0.1\n");

  // create the main game.
  g_game = new Game();

  // load the adventure game
  g_game.ReadAdventureGame("c:\\temp\\adventure.csv");
  g_game.CheckGameNodes();

  // move to the starting state (null denotes this)
  Move(null);
  
  textSize(12);
}

/* M O U S E  C L I C K E D */
/*----------------------------------------------------------------------------
	%%Function: mouseClicked
	%%Contact: rlittle
 
    this is executed on every mouse click.  ask the story control what got
    clicked on (if anything) and execute a move if we get something back.
----------------------------------------------------------------------------*/
void mouseClicked()
{
  // figure out what control is selected and execute it...
  String menuOption = g_story.StoryControls().MenuOptionFromLastMouseOver();
  
  if (menuOption != null)
    Move(menuOption);
}

/* D R A W */
/*----------------------------------------------------------------------------
	%%Function: draw
	%%Contact: rlittle
 
    this is called on every update (frameRate() during setup will specify
    how many times per second this is called)
 
    FUTURE: this redraws the whole window...even if only the story area
    changed...maybe only clear the parts that need to be updated? or not...
----------------------------------------------------------------------------*/
void draw()
{
  // clear the backgroun to gray (rgb = (204,204,204))
  background(204);

  // tell the story to draw itself
  g_story.Draw();
}