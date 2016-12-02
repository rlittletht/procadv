// this is the main story container

class Story
{
  StoryWindow m_storyWindow;
  StoryControls m_storyControls;
  
  // set at creation time
  float m_dx;
  float m_dy;
  
  // default to room for 4 options (but will dynamically size via Layout)
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

  float DyStuffFromDyStory(float dyStory)
  {
    // the "stuff" region is 1/3 of the window
    return dyStory / 3;
  }

  float YStoryWindowFromDyStory(float dyStory)
  {
    // story window starts where stuff window ends
    return DyStuffFromDyStory(dyStory);
  }

  float DyStoryWindowFromYStoryControls(float dyStory, float dyControls)
  {
    // the story window dynamically sizes based on the size of the controls
    return YControlsFromDyStory(dyStory, dyControls) - YStoryWindowFromDyStory(dyStory);
  }
  
  float YControlsFromDyStory(float dyStory, float dyControls)
  {
    return dyStory - dyControls;
  }
  
  Story(float dx, float dy)
  {
    m_dx = dx;
    m_dy = dy;
  
    // reserve 1/3 of the space for the story line
    
    m_storyWindow = new StoryWindow(10, 200, 620, 260);
    m_storyControls = new StoryControls();
    
    m_dyControls = m_storyControls.DySpaceNeededForControlCount(4);
  }
  
  void CalcWindowDimensions()
  {
    // given the raw dimensions of our window (m_dx and m_dy), figure out how to apportion the windows on the screen.
    // this WILL shrink the story window if necessary
    float dyNewControls = m_storyControls.DySpaceNeededForControls();
    
    if (dyNewControls > m_dyControls)
      m_dyControls = dyNewControls;

    m_xStoryWindow = m_xControls = m_xStuffWindow = 0;
    m_dxStoryWindow = m_dxControls = m_dxStuffWindow = m_dx;
    m_yStuffWindow = 0;
    m_dyStuffWindow = DyStuffFromDyStory(m_dy);
    m_yStoryWindow = YStoryWindowFromDyStory(m_dy);
    m_yControls = YControlsFromDyStory(m_dy, m_dyControls);
    m_dyStoryWindow = DyStoryWindowFromYStoryControls(m_dy, m_dyControls);
  }
    
  StoryWindow StoryWindow()
  {
    return m_storyWindow;
  }
  
  StoryControls StoryControls()
  {
    return m_storyControls;
  }
  
  void Layout()
  {
    CalcWindowDimensions();
    m_storyControls.SetControlLayouts(m_xControls, m_yControls, m_dxControls, m_dyControls);
    m_storyWindow.ResetWindowDimensions(m_xStoryWindow + 5, m_yStoryWindow + 5, m_dxStoryWindow - 10, m_dyStoryWindow - 5);
  }
  
  void Draw()
  {
    Layout();
    m_storyControls.UpdateForMouseOver(mouseX, mouseY);
    m_storyWindow.DrawStory();
    m_storyControls.DrawControls();
  }
}