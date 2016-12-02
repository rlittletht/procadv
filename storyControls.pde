
class StoryControls
{
  class StoryControl
  {
    String m_sText; // this is the text presented to the user
    String m_sMenuCommand;  // this won't be presented to the user, but its our way of telling the game engine what they selected
     
    float m_x;
    float m_y;
    float m_dx;
    float m_dy;
    
    color m_colorNormal = color(255);
    color m_colorHighlight = color(204);
    boolean m_fMouseOver;
    
    StoryControl(String sMenuCommand, String sText)
    {
      m_sText = sText;
      m_sMenuCommand = sMenuCommand;
    }
    
    String MenuCommand()
    {
      return m_sMenuCommand;
    }
    
    void SetCoordinates(float x, float y, float dx, float dy)
    {
      m_x = x;
      m_y = y;
      m_dx = dx;
      m_dy = dy;
    }
    
    void DrawControl()
    {
      stroke(0, 0, 0);
      if (m_fMouseOver)
        fill(m_colorHighlight);
      else
        fill(m_colorNormal);
        
     // println("drawcontrol: rect(" + String.valueOf(m_x)+"," + String.valueOf(m_y) + "," + String.valueOf(m_dx) + "," + String.valueOf(m_dy) + ")");
      rect(m_x, m_y, m_dx, m_dy);
      fill(0, 0, 0);
      text(m_sText, m_x + 3, m_y + 3, m_dx - 6, m_dy - 6);
    }
    
    boolean CheckMouseOverCurrent()
    {
      return m_fMouseOver;
    }
    
    void CheckMouseOver(float xMouse, float yMouse)
    {
      if (xMouse >= m_x && xMouse <= m_x + m_dx
          && yMouse >= m_y && yMouse <= m_y + m_dy)
      {
        m_fMouseOver = true;
      }
      else
      {
        m_fMouseOver = false;
      }
    }
  }
  
  StoryControl[] m_controls;
  
  StoryControls()
  {
    ResetControls();
  }
  
  void CheckMouseOver(float xMouse, float yMouse)
  {
    for (int i = 0; i < m_controls.length; i++)
    {
      m_controls[i].CheckMouseOver(xMouse, yMouse);
    }
  }
  
  void ResetControls()
  {
    m_controls = new StoryControl[0];
  }
  
  float DySpaceNeededForControl()
  {
    return textAscent() + textDescent() + 6;
  }
  
  void AddControl(String sMenuCommand, String sText)
  {
    m_controls = (StoryControl[])append(m_controls, new StoryControl(sMenuCommand, sText));
  }
  
  float DySpaceNeededForControlCount(int cControls)
  {
    // each control will get enough space for one line of text and some margins and a gap of 5 pixels
    float dyControl = DySpaceNeededForControl();
    
    float dyNeeded = dyControl * cControls;
    
    if (cControls == 0)
      return dyNeeded; // no padding for zero controls
      
    // add to that padding above and below
    dyNeeded += (5 + 5);
    
    // and gap between each control
    if (cControls > 1)
      dyNeeded += ((cControls - 1) * 5);
      
      return dyNeeded;
  }
  
  float DySpaceNeededForControls()
  {
    return DySpaceNeededForControlCount(m_controls.length);
  }
  
  // layout the controls in the given rectangle.  this assumes that dy
  // was calculated by calling DySpaceNeededForControls()
  void SetControlLayouts(float x, float y, float dx, float dy)
  {
    y += 5; // start off with padding before
    for (int iControl = 0; iControl < m_controls.length; iControl++)
    {
      StoryControl control = m_controls[iControl];
      
      control.SetCoordinates(x + 5, y, dx - 10, DySpaceNeededForControl());
      y += DySpaceNeededForControl() + 5;
      dy -= (DySpaceNeededForControl() + 5);
    }
  }

  void DrawControls()
  {
    // println("drawcontrols: controlcount=" + String.valueOf(m_controls.length));
    for (int iControl = 0; iControl < m_controls.length; iControl++)
    {
      StoryControl control = m_controls[iControl];
      
      control.DrawControl();
    }
  }
  
  String MenuOptionFromLastMouseOver()
  {
    for (int iControl = 0; iControl < m_controls.length; iControl++)
    {
      StoryControl control = m_controls[iControl];
      
      if (control.CheckMouseOverCurrent())
        return control.MenuCommand();
    }
    return null;
  }
  
  void UpdateForMouseOver(float xMouse, float yMouse)
  {
    CheckMouseOver(xMouse, yMouse);
  }
  
}