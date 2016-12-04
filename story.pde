// this is the main story container

// ================================================================================
//  S T O R Y 
// 
// Manages the UI for the story, split into 3 equal sized regions:
//      Story Stuff (not defined yet) for any kind of visualizations we wanto to show
//                   like mood color/graphs/whatever)
//      StoryWindow (for text) and the
//      StoryControls (for the buttons)
// 
// A note on dimensions:
//  x  means a point on the X axis (horizontal) (0 at far left)
//  y  means a point on the Y axis (vertical) (0 at top)
//  dx means a distance in the X direction (delta x). usually a width
//  dy means a distance in the Y direction (delta y), usually a height
// ================================================================================
class Story
{
  StoryWindow m_storyWindow;
  StoryControls m_storyControls;
  
  // set at creation time
  float m_dx;   // width of the window
  float m_dy;   // height of the window
  
  // default to room for 4 options (but will dynamically size via Layout)
  // height of the controls area
  float m_dyControls;
  
  // calculated via CalcWindowDimensions
  float m_xStuffWindow;
  float m_dxStuffWindow;
  float m_yStuffWindow;
  float m_dyStuffWindow;
  
  float m_xStoryWindow;
  float m_dxStoryWindow;
  float m_yStoryWindow;
  float m_dyStoryWindow;
  
  float m_xControls;
  float m_dxControls;
  float m_yControls;

  /* D Y  S T U F F  F R O M  D Y  S T O R Y */
  /*----------------------------------------------------------------------------
  	%%Function: DyStuffFromDyStory
  	%%Qualified: Story.DyStuffFromDyStory
   
    this is the height reserved for the "stuff" (not defined and just blank
    for now)
  ----------------------------------------------------------------------------*/
  float DyStuffFromDyStory(float dyStory)
  {
    // the "stuff" region is 1/3 of the window
    return dyStory / 3;
  }

  /* Y  S T O R Y  W I N D O W  F R O M  D Y  S T O R Y */
  /*----------------------------------------------------------------------------
  	%%Function: YStoryWindowFromDyStory
  	%%Qualified: Story.YStoryWindowFromDyStory
   
    given the height of the entire story, what is the starting Y point for the
    StoryWindow
  ----------------------------------------------------------------------------*/
  float YStoryWindowFromDyStory(float dyStory)
  {
    // story window starts where stuff window ends
    return DyStuffFromDyStory(dyStory);
  }

  /* D Y  S T O R Y  W I N D O W  F R O M  Y  S T O R Y  C O N T R O L S */
  /*----------------------------------------------------------------------------
  	%%Function: DyStoryWindowFromYStoryControls
  	%%Qualified: Story.DyStoryWindowFromYStoryControls
   
    Given the height of the story and the height of the controls, return
    the height of the story window (the story window gets squeezed as the
    controls get bigger or smaller)
  ----------------------------------------------------------------------------*/
  float DyStoryWindowFromYStoryControls(float dyStory, float dyControls)
  {
    // the story window dynamically sizes based on the size of the controls
    return YControlsFromDyStory(dyStory, dyControls) - YStoryWindowFromDyStory(dyStory);
  }
  
  /* Y  C O N T R O L S  F R O M  D Y  S T O R Y */
  /*----------------------------------------------------------------------------
  	%%Function: YControlsFromDyStory
  	%%Qualified: Story.YControlsFromDyStory
   
    Given the height of the overall story and the height of the controls,
    return the starting Y position for the controls.
  ----------------------------------------------------------------------------*/
  float YControlsFromDyStory(float dyStory, float dyControls)
  {
    return dyStory - dyControls;
  }
  
  /* S T O R Y */
  /*----------------------------------------------------------------------------
  	%%Function: Story
  	%%Qualified: Story.Story
   
    The constructor for the story.  Starts off with the width and height of the
    overall story
  ----------------------------------------------------------------------------*/
  Story(float dx, float dy)
  {
    m_dx = dx;
    m_dy = dy;
  
    // reserve 1/3 of the space for the story line
    
    m_storyWindow = new StoryWindow(10, 200, 620, 260);
    m_storyControls = new StoryControls();
    
    m_dyControls = m_storyControls.DySpaceNeededForControlCount(4);
  }
  
  /* C A L C  W I N D O W  D I M E N S I O N S */
  /*----------------------------------------------------------------------------
  	%%Function: CalcWindowDimensions
  	%%Qualified: Story.CalcWindowDimensions
   
    This actually calculates the dimensions of the various regions of the overall
    story (it will query the storyControls for how much vertical space the
    controls need).
   
    This will only *grow* the StoryControls if necessary. it will never shrink
  ----------------------------------------------------------------------------*/
  void CalcWindowDimensions()
  {
    // given the raw dimensions of our window (m_dx and m_dy), figure out how to apportion the windows on the screen.
    // this WILL shrink the story window if necessary
    float dyNewControls = m_storyControls.DySpaceNeededForControls();
    
    if (dyNewControls > m_dyControls)
      m_dyControls = dyNewControls;

    // once we know the required height of the StoryControls, we can calculate
    // everything else based on that

    // the windows all start at the same X coordinate (though that could
    // someday be tweaked) and have the same width
    m_xStoryWindow = m_xControls = m_xStuffWindow = 0;
    m_dxStoryWindow = m_dxControls = m_dxStuffWindow = m_dx;

    // stuff window starts at the top
    m_yStuffWindow = 0;
    m_dyStuffWindow = DyStuffFromDyStory(m_dy);

    // story window starts at the same fixed location
    m_yStoryWindow = YStoryWindowFromDyStory(m_dy);

    // controls window starts based on the height needed by the controls
    m_yControls = YControlsFromDyStory(m_dy, m_dyControls);

    // story window height is depended on how much height the controls take up
    m_dyStoryWindow = DyStoryWindowFromYStoryControls(m_dy, m_dyControls);
  }
    
  /* S T O R Y  W I N D O W */
  /*----------------------------------------------------------------------------
  	%%Function: StoryWindow
  	%%Qualified: Story.StoryWindow
   
    Return the StoryWindow so caller can access it
  ----------------------------------------------------------------------------*/
  StoryWindow StoryWindow()
  {
    return m_storyWindow;
  }
  
  /* S T O R Y  C O N T R O L S */
  /*----------------------------------------------------------------------------
  	%%Function: StoryControls
  	%%Qualified: Story.StoryControls
   
    return the StoryControls so the caller can access it
  ----------------------------------------------------------------------------*/
  StoryControls StoryControls()
  {
    return m_storyControls;
  }
  
  /* L A Y O U T */
  /*----------------------------------------------------------------------------
  	%%Function: Layout
  	%%Qualified: Story.Layout
   
    actually layout the overall story UI
  ----------------------------------------------------------------------------*/
  void Layout()
  {
    CalcWindowDimensions();
    m_storyControls.SetControlLayouts(m_xControls, m_yControls, m_dxControls, m_dyControls);
    m_storyWindow.ResetWindowDimensions(m_xStoryWindow + 5, m_yStoryWindow + 5, m_dxStoryWindow - 10, m_dyStoryWindow - 5);
  }
  
  /* D R A W */
  /*----------------------------------------------------------------------------
  	%%Function: Draw
  	%%Qualified: Story.Draw
   
    Layout and draw the overall story UI
  ----------------------------------------------------------------------------*/
  void Draw()
  {
    Layout();
    m_storyControls.UpdateForMouseOver(mouseX, mouseY);
    m_storyWindow.DrawStory();
    m_storyControls.DrawControls();
  }
}