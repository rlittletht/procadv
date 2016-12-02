

Story g_story;
Game g_game;

void Move(String sMenuChoice)
{
  println("moving for " + sMenuChoice);
  g_game.PrintAttrsCurrent("Before Move");
  // apply sMenuChoice from the UI to the game
  
  g_story.StoryWindow().AddToStory(g_game.GetActionTextForMenuChoice(sMenuChoice));
  
  g_game.ExecuteActionForMenuChoice(sMenuChoice);
  g_story.StoryWindow().AddToStory(g_game.GetEntryText());
  g_story.StoryWindow().AddToStory(g_game.GetBodyText());
  g_story.StoryWindow().AddToStory(g_game.GetPromptText());
  
  // now construct the controls
  g_story.StoryControls().ResetControls();
  
  String[] menuOptions = g_game.GetOptionsKeys();
  for (String s : menuOptions)
  {
    String sOptionText = g_game.GetOptionTextFromOptionKey(s);
    if (sOptionText != null)
      g_story.StoryControls().AddControl(s, sOptionText);  
  }
  g_game.PrintAttrsCurrent("After Move ");
}

void setup() //<>// //<>//
{
  AdventureTests();
  size(640,680); //<>// //<>//
//  frameRate(5);
  g_story = new Story(640, 680);
  g_game = new Game();
//  g_game.ReadGameNodes();
  g_game.ReadAdventureGame("c:\\temp\\adventure.csv");
  g_game.CheckGameNodes();
  Move(null);
  
  textSize(12);
  
  AdventureTests();
  //g_story.StoryWindow().AddToStory("this is a \ntest line 1");
  //g_story.StoryWindow().AddToStory("this is a test line 2");
  //g_story.StoryWindow().AddToStory("this is a test line 3");
  //g_story.StoryWindow().AddToStory("this is a length string that is going to have to break because it will be longer than the line and it will break HERE extra");
  
  //g_story.StoryControls().AddControl("test", "This is my test action");
  //g_story.StoryControls().AddControl("test", "This is my test action2");
}

void mouseClicked()
{
  // figure out what control is selected and execute it...
  String menuOption = g_story.StoryControls().MenuOptionFromLastMouseOver();
  
  if (menuOption != null)
    Move(menuOption);
}

void draw()
{
  background(204);
  g_story.Draw();
}