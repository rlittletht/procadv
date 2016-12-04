
// ================================================================================
//  S T O R Y  C O N T R O L S 
// 
// This implements the UI for the controls (choices) that the player will see
// ================================================================================
class StoryControls
{

  // ================================================================================
  //  S T O R Y  C O N T R O L 
  // 
  // Each story control represents a UI element for the player to interact with
  // (for now, this is just the choices for each game node)
  // 
  // Each story control has
  // 
  //   m_sText
  //        The text that will be presented to the user (the label for the button)
  //   m_sMenuCommand
  //        This is the internal ID that will be sent back to the controller if the
  //        user clicks on it
  //   m_x, m_dx, m_y, m_dy
  //        This is the bounding box for the UI element (left, width, top, height)
  // ================================================================================
  class StoryControl
  {
    String m_sText; // this is the text presented to the user
    String m_sMenuID;  // this won't be presented to the user, but its our way of telling the game engine what they selected
     
    // bounding box for the control
    float m_x;
    float m_y;
    float m_dx;
    float m_dy;
    
    // normal and highlight colors for the control
    color m_colorNormal = color(255);
    color m_colorHighlight = color(204);

    // this will be true when the mouse is over this control
    boolean m_fMouseOver;
    
    /* S T O R Y  C O N T R O L */
    /*----------------------------------------------------------------------------
    	%%Function: StoryControl
    	%%Qualified: StoryControls:StoryControl.StoryControl
     
      constructor for the StoryControl
    ----------------------------------------------------------------------------*/
    StoryControl(String sMenuCommand, String sText)
    {
      m_sText = sText;
      m_sMenuID = sMenuCommand;
    }
    
    /* M E N U  I  D */
    /*----------------------------------------------------------------------------
    	%%Function: MenuID
    	%%Qualified: StoryControls:StoryControl.MenuID
     
        return the MenuID for this control
    ----------------------------------------------------------------------------*/
    String MenuID()
    {
      return m_sMenuID;
    }
    
    /* S E T  B O U N D I N G  B O X */
    /*----------------------------------------------------------------------------
    	%%Function: SetBoundingBox
    	%%Qualified: StoryControls:StoryControl.SetBoundingBox
     
        set the bounding box for this control
    ----------------------------------------------------------------------------*/
    void SetBoundingBox(float x, float y, float dx, float dy)
    {
      m_x = x;
      m_y = y;
      m_dx = dx;
      m_dy = dy;
    }
    
    /* D R A W  C O N T R O L */
    /*----------------------------------------------------------------------------
    	%%Function: DrawControl
    	%%Qualified: StoryControls:StoryControl.DrawControl
     
        draw this control. this knows whether the controlis under the mouse
        cursor or not, and draws the control accordingly
    ----------------------------------------------------------------------------*/
    void DrawControl()
    {
      stroke(0, 0, 0);
      if (m_fMouseOver)
        fill(m_colorHighlight);
      else
        fill(m_colorNormal);
        
      rect(m_x, m_y, m_dx, m_dy);
      fill(0, 0, 0);
      text(m_sText, m_x + 3, m_y + 3, m_dx - 6, m_dy - 6);
    }
    
    /* I S  M O U S E  O V E R */
    /*----------------------------------------------------------------------------
    	%%Function: IsMouseOver
    	%%Qualified: StoryControls:StoryControl.IsMouseOver
     
        return whether or not the mouse is currently over this control
    ----------------------------------------------------------------------------*/
    boolean IsMouseOver()
    {
      return m_fMouseOver;
    }
    
    /* S E T  C H E C K  M O U S E  O V E R */
    /*----------------------------------------------------------------------------
    	%%Function: SetCheckMouseOver
    	%%Qualified: StoryControls:StoryControl.CheckMouseOver
     
        check to see if the given x, y mouse coordinate is currently over this
        control, and if so, set m_fMouseOver
    ----------------------------------------------------------------------------*/
    void SetCheckMouseOver(float xMouse, float yMouse)
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
  
  // the set of controls that we know about
  StoryControl[] m_controls;
  
  StoryControls()
  {
    ResetControls();
  }
  
  /* S E T  C H E C K  M O U S E  O V E R */
  /*----------------------------------------------------------------------------
  	%%Function: SetCheckMouseOver
  	%%Qualified: StoryControls.SetCheckMouseOver
   
    query all of our controls and set which controls the mouse is over
    (presumably just one)
  ----------------------------------------------------------------------------*/
  void SetCheckMouseOver(float xMouse, float yMouse)
  {
    for (int i = 0; i < m_controls.length; i++)
    {
      m_controls[i].SetCheckMouseOver(xMouse, yMouse);
    }
  }
  
  /* R E S E T  C O N T R O L S */
  /*----------------------------------------------------------------------------
  	%%Function: ResetControls
  	%%Qualified: StoryControls.ResetControls
   
    reset out controls (zero out our collection)
  ----------------------------------------------------------------------------*/
  void ResetControls()
  {
    m_controls = new StoryControl[0];
  }
  
  /* D Y  S P A C E  N E E D E D  F O R  C O N T R O L */
  /*----------------------------------------------------------------------------
  	%%Function: DySpaceNeededForControl
  	%%Qualified: StoryControls.DySpaceNeededForControl
   
    return how much vertical space (height) we need for our controls
   
    (this is calculated as the amount of space needed for the TextAscent
    and the TextDescent, plus 6 pixels for padding
  ----------------------------------------------------------------------------*/
  float DySpaceNeededForControl()
  {
    return textAscent() + textDescent() + 6;
  }
  
  /* A D D  C O N T R O L */
  /*----------------------------------------------------------------------------
  	%%Function: AddControl
  	%%Qualified: StoryControls.AddControl
   
    add the given choice (menuID as the identifier and sText for label of the
    control)
  ----------------------------------------------------------------------------*/
  void AddControl(String sMenuID, String sText)
  {
    m_controls = (StoryControl[])append(m_controls, new StoryControl(sMenuID, sText));
  }
  
  /* D Y  S P A C E  N E E D E D  F O R  C O N T R O L  C O U N T */
  /*----------------------------------------------------------------------------
  	%%Function: DySpaceNeededForControlCount
  	%%Qualified: StoryControls.DySpaceNeededForControlCount
   
    return the space needed for the number of controls given (this is really
    just math. all the controls are constant sized, but based on the count
    we might need padding between controls as well as before and after the
    controls)
  ----------------------------------------------------------------------------*/
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
  
  /* D Y  S P A C E  N E E D E D  F O R  C O N T R O L S */
  /*----------------------------------------------------------------------------
  	%%Function: DySpaceNeededForControls
  	%%Qualified: StoryControls.DySpaceNeededForControls
   
    return the space needed for the controls that we know about
  ----------------------------------------------------------------------------*/
  float DySpaceNeededForControls()
  {
    return DySpaceNeededForControlCount(m_controls.length);
  }
  
  /* S E T  C O N T R O L  L A Y O U T S */
  /*----------------------------------------------------------------------------
  	%%Function: SetControlLayouts
  	%%Qualified: StoryControls.SetControlLayouts
  	
  	layout the controls in the given rectangle.  this assumes that dy
  	was calculated by calling DySpaceNeededForControls()
  ----------------------------------------------------------------------------*/
  void SetControlLayouts(float x, float y, float dx, float dy)
  {
    y += 5; // start off with padding before
    for (int iControl = 0; iControl < m_controls.length; iControl++)
    {
      StoryControl control = m_controls[iControl];
      
      control.SetBoundingBox(x + 5, y, dx - 10, DySpaceNeededForControl());
      y += DySpaceNeededForControl() + 5;
      dy -= (DySpaceNeededForControl() + 5);
    }
  }

  /* D R A W  C O N T R O L S */
  /*----------------------------------------------------------------------------
  	%%Function: DrawControls
  	%%Qualified: StoryControls.DrawControls
   
    draw the actual controls we know about
  ----------------------------------------------------------------------------*/
  void DrawControls()
  {
    for (int iControl = 0; iControl < m_controls.length; iControl++)
    {
      StoryControl control = m_controls[iControl];
      
      control.DrawControl();
    }
  }
  
  /* M E N U  I D  F R O M  L A S T  M O U S E  O V E R */
  /*----------------------------------------------------------------------------
  	%%Function: MenuIDFromLastMouseOver
  	%%Qualified: StoryControls.MenuOptionFromLastMouseOver
   
    The last time UpdateForMouseOver() was called, we remembered which control
    the mouse was over. Now return the MenuID for that control (useful when,
    say, the user clicks...)
  ----------------------------------------------------------------------------*/
  String MenuIDFromLastMouseOver()
  {
    for (int iControl = 0; iControl < m_controls.length; iControl++)
    {
      StoryControl control = m_controls[iControl];
      
      if (control.IsMouseOver())
        return control.MenuID();
    }
    return null;
  }
  
  /* U P D A T E  F O R  M O U S E  O V E R */
  /*----------------------------------------------------------------------------
  	%%Function: UpdateForMouseOver
  	%%Qualified: StoryControls.UpdateForMouseOver
   
    given the x,y mouse coordinates, update all of our controls for whether or
    not the mouse is over them
  ----------------------------------------------------------------------------*/
  void UpdateForMouseOver(float xMouse, float yMouse)
  {
    SetCheckMouseOver(xMouse, yMouse);
  }
  
}