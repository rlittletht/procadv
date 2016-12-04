class StoryWindow
{
  String[] m_story;
  float m_x;  // left edge
  float m_y;  // top edge
  float m_dx;  // width
  float m_dy;  // height
  // ================================================================================
  //  S U B S T R I N G  M E A S U R E 
  // ================================================================================
  class SubstringMeasure
  {
    int cch;  // how many characters measured from this point
    int dxp;  // width of the substring
  }
  
  // ================================================================================
  //  L I N E  B R E A K  I N F O 
  // ================================================================================
  class LineBreakInfo
  {
    SubstringMeasure[] substringMeasures;
    int cchLine; // number of characters that fit on this line (if less than the length of the string, the remainder will get pushed to the next line)
    int ichSegmentStart; // this is just a place for our callers to squirrel away some data about the segment that created this line break info
    float dyp; // the height of the line, in pixels
  }

  // ================================================================================
  //  S T R I N G  L I N E  I N F O 
  // ================================================================================
  class StringLineInfo
  {
    int cLines;  // number of displayed lines this string breaks into  
    float dyp;     // height of string in pixels (including all lines)

    LineBreakInfo[] lineBreaks;
  }
  
  StoryWindow(float x, float y, float dx, float dy)
  {
    m_x = x;
    m_y = y;
    m_dx = dx;
    m_dy = dy;
    m_story = new String[0];
  }
  
  StoryWindow()
  {
  } //<>// //<>//

  void ResetWindowDimensions(float x, float y, float dx, float dy)
  {
    // we don't cache line break/display results right now, so we don't have to worry about invalidating anything
    // here
    m_x = x;
    m_y = y;
    m_dx = dx;
    m_dy = dy;
  }
  /* A D D  T O  S T O R Y */
  /*----------------------------------------------------------------------------
    %%Function: AddToStory
    %%Qualified: StoryWindow.AddToStory
    
  ----------------------------------------------------------------------------*/
  void AddToStory(String str)
  {
    if (str == null)
      return;
      
    m_story = append(m_story, str.replaceAll("\\^","\n"));
  }
  
  /* F  I S  B R E A K  O P P O R T U N I T Y */
  /*----------------------------------------------------------------------------
  	%%Function: FIsBreakOpportunity
  	%%Qualified: StoryWindow.FIsBreakOpportunity
   
    return whether or not this character is a break opportunity (for the
    purposes of breaking a string across lines)
  ----------------------------------------------------------------------------*/
  boolean FIsBreakOpportunity(char ch)
  {
    if (ch == ' ' || ch == ',' || ch == '.' || ch == '\t' || ch == ';')
      return true;
      
    return false;
  }
  
  /* L I N E  B R E A K  I N F O  C A L C U L A T E  F O R  S T R I N G */
  /*----------------------------------------------------------------------------
  	%%Function: LineBreakInfoCalculateForString
  	%%Qualified: StoryWindow.LineBreakInfoCalculateForString
   
    return the linebreak info for the portion of this string that will fit
    on this line (that is dxpMaxWidth wide).
   
    LineBreakInfo.cchLine will tell you how much of the string fit in the line
    (NOTE: if the string starts with a newline character (\n), then the line
    length will be 0. It is the responsibility of that caller to not
    infinite loop when there is a leading newline.
  ----------------------------------------------------------------------------*/
  LineBreakInfo LineBreakInfoCalculateForString(String s, float dxpMaxWidth)
  {
    int cchSegment = s.length();
    int ichTest;
    LineBreakInfo lineBreakInfo = new LineBreakInfo();
    
    lineBreakInfo.dyp = textAscent() + textDescent();
    
    ichTest = s.indexOf('\n'); //<>//
    if (ichTest != -1)
      cchSegment = ichTest;

    while (cchSegment > 0)
    {
      // see how much of the substring will fit on the line
      float dxp = textWidth(s.substring(0, cchSegment - 1));
      if (dxp <= dxpMaxWidth)
      {
        // the whole substring fits
        lineBreakInfo.cchLine = cchSegment;
//        println("returing cch = " + String.valueOf(cchSegment) + ", substring = " + s.substring(0, cchSegment));
//        println("dxp " + String.valueOf(dxp) + " <= " + String.valueOf(dxpMaxWidth));
        return lineBreakInfo;
      }
    
      // find a break opportunity to break the line into
      ichTest = cchSegment - 2;
//      println("need a break opportunity. starting at " + String.valueOf(ichTest));
      while (ichTest > 0)  // we have to make progress by at least one character, break opportunity or not
      {
        if (FIsBreakOpportunity(s.charAt(ichTest)))
          break;
          
        ichTest--;
      }
      cchSegment = ichTest + 1;
    }

    lineBreakInfo.cchLine = 0;
    return lineBreakInfo;
  }

  /* S T R I N G  L I N E  I N F O  C A L C U L A T E  F O R  S T R I N G */
  /*----------------------------------------------------------------------------
  	%%Function: StringLineInfoCalculateForString
  	%%Qualified: StoryWindow.StringLineInfoCalculateForString
  	
    Given a string, figure out how many lines we are going to need to display it
    (and return line break information for each of those lines).
   
    Will also calculate the height required to draw the string.
  ----------------------------------------------------------------------------*/
  StringLineInfo StringLineInfoCalculateForString(String s, float dxpMaxWidth)
  {
    int ichSegmentStart = 0;
    int cchSegment = s.length();
    
    StringLineInfo lineInfo = new StringLineInfo();
    lineInfo.lineBreaks = new LineBreakInfo[0];
    lineInfo.cLines = 0;
    
    while (ichSegmentStart < cchSegment)
    {
      LineBreakInfo lineBreakInfo = LineBreakInfoCalculateForString(s.substring(ichSegmentStart, cchSegment), dxpMaxWidth);
      lineBreakInfo.ichSegmentStart = ichSegmentStart;
      lineInfo.lineBreaks = (LineBreakInfo[])append(lineInfo.lineBreaks, lineBreakInfo);
      ichSegmentStart += lineBreakInfo.cchLine;
      lineInfo.cLines++;
      lineInfo.dyp += lineBreakInfo.dyp;
      
      if (ichSegmentStart >= cchSegment)
        break;
        
      if (s.charAt(ichSegmentStart) == '\n')
        ichSegmentStart++;
      // println("lbi.cchLine: " + String.valueOf(lineBreakInfo.cchLine) + ", ichSegmentStart: " + String.valueOf(ichSegmentStart) + ", cchSegment: " + String.valueOf(cchSegment) + ", lineInfo.cLines: " + String.valueOf(lineInfo.cLines) + ", substring: " + s.substring(ichSegmentStart, cchSegment));
    }
    
    return lineInfo;
  }
  
  class DisplayLine
  {
    float x;
    float y;
    float dx;
    float dy;
    
    int iStoryLine;
    LineBreakInfo lineBreakInfo;
  }
  
  // need to figure out how much of the story will fit within the "story window"
  void DrawStory()
  {
//    println("================ TOP OF DRAWSTORY");
    fill(255);
    rect(m_x, m_y, m_dx, m_dy);
    fill(0);
    
    float dyMargin = 10;
    float dxMargin = 10;
    float dxText = m_dx - 20;
    float dyText = m_dy - 20;
    float yTextCheck; // for internal validation
    
    int iLine = m_story.length - 1;
    
    float yTextCur = m_y + dyText + dyMargin;
//    println("yTextCur: " + String.valueOf(yTextCur) + " ( " + String.valueOf(m_y) + " + " + String.valueOf(dyText) + " + " + String.valueOf(dyMargin) + ")");
    DisplayLine[] dls = new DisplayLine[0];
    
    while (iLine >= 0 && yTextCur >= m_y + dyMargin)
    {
      StringLineInfo lineInfo = StringLineInfoCalculateForString(m_story[iLine], dxText);
      
      int iLineBreak = 0;
       // move the current y line to the top of the string. NOTE that this might make yTextCur move BEYOND the bounds 
       // of our display region. We will clip and text that doesn't fit by checking yTextCur < m_dy + dyMargin (and 
       // incrementing yTextCur until we are back in the clipping region)
       
//      println("OUTER yTextCur: " + String.valueOf(yTextCur));
      yTextCheck = yTextCur;
      yTextCur -= lineInfo.dyp;
      
//      println("OUTER yTextCur -= " + String.valueOf(lineInfo.dyp));

      while (iLineBreak < lineInfo.cLines)
      {
//        println("INNER yTextCur: " + String.valueOf(yTextCur));
        yTextCur += lineInfo.lineBreaks[iLineBreak].dyp;
//        println("INNER yTextCur += " + String.valueOf(lineInfo.lineBreaks[iLineBreak].dyp));
        
        if (yTextCur >= m_y + dyMargin)
        {
          DisplayLine dl = new DisplayLine();
          
          dl.x = m_x + dxMargin;
          dl.y = yTextCur;
          dl.dx = dxText;
          dl.dy = lineInfo.dyp;
        
          dl.iStoryLine = iLine;
          dl.lineBreakInfo = lineInfo.lineBreaks[iLineBreak];
          dls = (DisplayLine[])append(dls, dl);
//          println("dl.x: " + String.valueOf(dl.x) + ",dl.y: " + String.valueOf(dl.y) + ",dl.dx: " + String.valueOf(dl.dx) + ",dl.dy: " + String.valueOf(dl.dy) + ",dl.iStoryLine: " + String.valueOf(dl.iStoryLine) + ",dl.lbi.ich: " + String.valueOf(dl.lineBreakInfo.ichSegmentStart));
        }
//        else
//        {
//          println("CLIPPING");
//        }
        iLineBreak++;
      }
      if (yTextCur != yTextCheck)
        println("FATAL INTERNAL ERROR! " + String.valueOf(yTextCur) + " != " + String.valueOf(yTextCheck));
        
      // now that we have consumed all the space reserved for us, let's go back to the top of our block
      yTextCur -= lineInfo.dyp;
      
      iLine--;
    }
    
//    println("Ending at yTextCUr: " + String.valueOf(yTextCur) + ", m_y + dyMargin = " + String.valueOf(m_y + dyMargin) + "iLine = " + String.valueOf(iLine));
    // at this point, we have a set of display lines we can display
    // we want the story to always be scrolled to the end of the story line, so start by measuring what lines will fit from the bottom up
    
    // loop through the display lines and draw them
    for (iLine = 0; iLine < dls.length; iLine++)
    {
      DisplayLine dl = dls[iLine];
//      println("text(" + m_story[dl.iStoryLine].substring(dl.lineBreakInfo.ichSegmentStart, dl.lineBreakInfo.ichSegmentStart + dl.lineBreakInfo.cchLine) + ", " + String.valueOf(dl.x) + ", " + String.valueOf(dl.y));
      text(m_story[dl.iStoryLine].substring(dl.lineBreakInfo.ichSegmentStart, dl.lineBreakInfo.ichSegmentStart + dl.lineBreakInfo.cchLine), dl.x, dl.y); 
    }
    
    // text(m_story[0], 20, 210, 600, 250);
//    print("foo");
  }
}