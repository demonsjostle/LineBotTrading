#include <trade/trade.mqh>
//+------------------------------------------------------------------+
//|   CMyBot                                                         |
//+------------------------------------------------------------------+


#property copyright "Copyright 2024"
#property link      "http://www.thaiquantrobot.com"
#property version   "1.00"


#define MAGICMA  20150309
//--- Inputs

            
input string Username = ""; // Trader Name
input int   TakeProfit = 0; // Take Profit (point)
input int   StopLoss = 0; // Stop Loss (point)
input bool   UseTelegram = true; // Use Send Alert Line
input bool Package1 = true; //Banance 100$
input bool Package2 = true; //Balance 500$
input bool Package3 = true; //Balance 1000$
input string ApiUrl = "https://kalive.knightarmyacademy.com/backend/api/send-message/";


string CheckActivePackages()
{
   // Variable to store the names of the active packages
   string activePackages = "";

   // Check each package and append its name if it's true
   if (Package1)
      activePackages += "Balance 100$,";
   if (Package2)
      activePackages += "Balance 500$,";
   if (Package3)
      activePackages += "Balance 1000$,";

   

   // Return the result
   return activePackages;
}

string activePackages = CheckActivePackages();


int OnInit()
  {
//----
   EventSetTimer(1);
//----
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Comment("");
   ObjectsDeleteAll(0);
   EventKillTimer();
   
//----
   return;
  }

void OnTimer()
{
  OnTick();
}

void OnTick()
  {

//----
   return;
  }
//+------------------------------------------------------------------+


void DrawPriceLine(string name, datetime x1, datetime x2, double y1, 
                        double y2, color lineColor, int size)
  {
   string label = name;
   ObjectDelete(0,label);
   ObjectCreate(0, label, OBJ_TREND, 0, x1, y1, x2, y2);
   ObjectSetInteger(0, label, OBJPROP_RAY, 0);
   ObjectSetInteger(0, label, OBJPROP_COLOR, lineColor);
   ObjectSetInteger(0, label, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, label, OBJPROP_WIDTH, size);
  }

void DrawLABEL(string name, string Name0, datetime X, double Y, color c)
{
   string label = name;
   ObjectDelete(0,label);
   if (ObjectFind(0,name)==-1)
   {
      ObjectCreate(0, name, OBJ_TEXT, 0, X, Y);
   }
   
         ObjectSetString(0,name,OBJPROP_TEXT, Name0);
         ObjectSetString(0,name,OBJPROP_FONT,"Arial"); 
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,8);
         ObjectSetInteger(0,name,OBJPROP_COLOR,c); 
      /*   ObjectSetInteger(0,name, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
         ObjectSetInteger(0,name, OBJPROP_BACK, false);
         ObjectSetInteger(0,name, OBJPROP_XDISTANCE, x);
         ObjectSetInteger(0,name, OBJPROP_YDISTANCE, y);  */
} 
 
  

bool RectangleCreate(const long            chart_ID=0,        // chart's ID
                     const string          name="Rectangle",  // rectangle name
                     const int             sub_window=0,      // subwindow index 
                     datetime              time1=0,           // first point time
                     double                price1=0,          // first point price
                     datetime              time2=0,           // second point time
                     double                price2=0,          // second point price
                     const color           clr=clrRed,        // rectangle color
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // style of rectangle lines
                     const int             width=1,           // width of rectangle lines
                     const bool            fill=false,        // filling rectangle with color
                     const bool            back=false,        // in the background
                     const bool            selection=true,    // highlight to move
                     const bool            hidden=true,       // hidden in the object list
                     const long            z_order=0)         // priority for mouse click
  {
//--- set anchor points' coordinates if they are not set
   ChangeRectangleEmptyPoints(time1,price1,time2,price2);
//--- reset the error value
   ResetLastError();
//--- create a rectangle by the given coordinates
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle! Error code = ",GetLastError());
      return(false);
     }
//--- set rectangle color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set the style of rectangle lines
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set width of the rectangle lines
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- enable (true) or disable (false) the mode of filling the rectangle
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,fill);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of highlighting the rectangle for moving
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move the rectangle anchor point                                  |
//+------------------------------------------------------------------+
bool RectanglePointChange(const long   chart_ID=0,       // chart's ID
                          const string name="Rectangle", // rectangle name
                          const int    point_index=0,    // anchor point index
                          datetime     time=0,           // anchor point time coordinate
                          double       price=0)          // anchor point price coordinate
  {
//--- if point position is not set, move it to the current bar having Bid price
   if(!time)
      time=TimeCurrent();
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- reset the error value
   ResetLastError();
//--- move the anchor point
   if(!ObjectMove(chart_ID,name,point_index,time,price))
     {
      Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete the rectangle                                             |
//+------------------------------------------------------------------+
bool RectangleDelete(const long   chart_ID=0,       // chart's ID
                     const string name="Rectangle") // rectangle name
  {
//--- reset the error value
   ResetLastError();
//--- delete rectangle
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete rectangle! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Check the values of rectangle's anchor points and set default    |
//| values for empty ones                                            |
//+------------------------------------------------------------------+
void ChangeRectangleEmptyPoints(datetime &time1,double &price1,
                                datetime &time2,double &price2)
  {
//--- if the first point's time is not set, it will be on the current bar
   if(!time1)
      time1=TimeCurrent();
//--- if the first point's price is not set, it will have Bid value
   if(!price1)
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- if the second point's time is not set, it is located 9 bars left from the second one
   if(!time2)
     {
      //--- array for receiving the open time of the last 10 bars
      datetime temp[10];
      CopyTime(Symbol(),Period(),time1,10,temp);
      //--- set the second point 9 bars left from the first one
      time2=temp[0];
     }
//--- if the second point's price is not set, move it 300 points lower than the first one
   if(!price2)
      price2=price1-300*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
  }
 
  
  //+------------------------------------------------------------------+
//| Set number of levels and their parameters                        |
//+------------------------------------------------------------------+

  
void button_sym_create(string sym, int x , int y, color c, color cf, string show)
{
ObjectCreate(0,"Button"+sym,OBJ_BUTTON,0,0,0);
ObjectSetInteger(0,"Button"+sym,OBJPROP_XDISTANCE,x);
ObjectSetInteger(0,"Button"+sym,OBJPROP_YDISTANCE,y);
ObjectSetInteger(0,"Button"+sym,OBJPROP_XSIZE,100);
ObjectSetInteger(0,"Button"+sym,OBJPROP_YSIZE,30);

ObjectSetString(0,"Button"+sym,OBJPROP_TEXT,show);
ObjectSetInteger(0,"Button"+sym,OBJPROP_CORNER, 0);
ObjectSetInteger(0,"Button"+sym,OBJPROP_COLOR, cf);
ObjectSetInteger(0,"Button"+sym,OBJPROP_BGCOLOR, c);
ObjectSetInteger(0,"Button"+sym,OBJPROP_BORDER_COLOR,c);
ObjectSetInteger(0,"Button"+sym,OBJPROP_BORDER_TYPE,BORDER_FLAT);
ObjectSetInteger(0,"Button"+sym,OBJPROP_HIDDEN,true);
ObjectSetInteger(0,"Button"+sym,OBJPROP_STATE,false);
ObjectSetInteger(0,"Button"+sym,OBJPROP_FONTSIZE,10);
}     

   
void make_label(string t,string l, int f, int x, int y, color c, int corner = CORNER_LEFT_UPPER)
{
   ObjectCreate(0,"l"+t, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0,"l"+t, OBJPROP_XDISTANCE, x*1.5);
   ObjectSetInteger(0,"l"+t, OBJPROP_YDISTANCE, y*1.1); 
   
   ObjectSetString(0,"l"+t,OBJPROP_TEXT, l);
   ObjectSetString(0,"l"+t,OBJPROP_FONT,"Arial"); 
   ObjectSetInteger(0,"l"+t,OBJPROP_FONTSIZE,f);
   ObjectSetInteger(0,"l"+t,OBJPROP_COLOR,c);  
   
} 

  
bool RectLabelCreate(const long             chart_ID=0,               // chart's ID
                     const string           name="RectLabel",         // label name
                     const int              sub_window=0,             // subwindow index
                     const int              x=5,                      // X coordinate
                     const int              y=20,                      // Y coordinate
                     const int              width=150,                 // width
                     const int              height=520,                // height
                     const color            back_clr=clrBlack,  // background color
                     const ENUM_BORDER_TYPE border=BORDER_FLAT,     // border type
                     const ENUM_BASE_CORNER corner=CORNER_RIGHT_UPPER, // chart corner for anchoring
                     const color            clr=clrYellow,               // flat border color (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // flat border style
                     const int              line_width=1,             // flat border width
                     const bool             back=false,               // in the background
                     const bool             selection=false,          // highlight to move
                     const bool             hidden=false,              // hidden in the object list
                     const long             z_order=0)                // priority for mouse click
  {
   if(ObjectFind(0,name) >= 0){ return(false);}
//--- reset the error value
   ResetLastError();
//--- create a rectangle label
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x*1.5);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y*1.1);
//--- set label size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width*1.5);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height*1.1);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border type
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set flat border color (in Flat mode)
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set flat border line style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set flat border width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }          
  
void button_sym_create(string sym, int x , int y, int size_x , int size_y, color c, color cf, string show)
{
ObjectCreate(0,"Button"+sym,OBJ_BUTTON,0,0,0);
ObjectSetInteger(0,"Button"+sym,OBJPROP_XDISTANCE,x*1.5);
ObjectSetInteger(0,"Button"+sym,OBJPROP_YDISTANCE,y*1.1);
ObjectSetInteger(0,"Button"+sym,OBJPROP_XSIZE,size_x*1.5);
ObjectSetInteger(0,"Button"+sym,OBJPROP_YSIZE,size_y*1.1);
ObjectSetInteger(0,"Button"+sym, OBJPROP_CORNER, 1);
ObjectSetString(0,"Button"+sym,OBJPROP_TEXT,show);
ObjectSetInteger(0,"Button"+sym,OBJPROP_COLOR, cf);
ObjectSetInteger(0,"Button"+sym,OBJPROP_BGCOLOR, c);
ObjectSetInteger(0,"Button"+sym,OBJPROP_BORDER_COLOR,clrNONE);
ObjectSetInteger(0,"Button"+sym,OBJPROP_HIDDEN,true);
ObjectSetInteger(0,"Button"+sym,OBJPROP_STATE,false);
ObjectSetInteger(0,"Button"+sym,OBJPROP_FONTSIZE,8);
ObjectSetString(0,"Button"+sym,OBJPROP_FONT,"Arial");
}  

void button_sym_create2(string sym, int x , int y, int size_x , int size_y, color c, color cf, string show)
{
ObjectCreate(0,"Button"+sym,OBJ_BUTTON,0,0,0);
ObjectSetInteger(0,"Button"+sym,OBJPROP_XDISTANCE,x*1.5);
ObjectSetInteger(0,"Button"+sym,OBJPROP_YDISTANCE,y*1.1);
ObjectSetInteger(0,"Button"+sym,OBJPROP_XSIZE,size_x*1.5);
ObjectSetInteger(0,"Button"+sym,OBJPROP_YSIZE,size_y*1.1);
ObjectSetInteger(0,"Button"+sym, OBJPROP_CORNER, 0);
ObjectSetString(0,"Button"+sym,OBJPROP_TEXT,show);
ObjectSetInteger(0,"Button"+sym,OBJPROP_COLOR, cf);
ObjectSetInteger(0,"Button"+sym,OBJPROP_BGCOLOR, c);
ObjectSetInteger(0,"Button"+sym,OBJPROP_BORDER_COLOR,clrBlack);
ObjectSetInteger(0,"Button"+sym,OBJPROP_HIDDEN,true);
ObjectSetInteger(0,"Button"+sym,OBJPROP_STATE,false);
ObjectSetInteger(0,"Button"+sym,OBJPROP_FONTSIZE,8);
ObjectSetString(0,"Button"+sym,OBJPROP_FONT,"Arial");
ObjectSetInteger(0,"Button"+sym,OBJPROP_BORDER_TYPE,BORDER_FLAT);

ObjectSetInteger(0,"Button"+sym,OBJPROP_STYLE,STYLE_SOLID);
//--- set flat border width
ObjectSetInteger(0,"Button"+sym,OBJPROP_WIDTH,1);
} 

    void OnChartEvent(const int id,         // Event ID
                  const long& lparam,   // Parameter of type long event
                  const double& dparam, // Parameter of type double event
                  const string& sparam  // Parameter of type string events
  )
  {
  }  
  
int TotalBuyStop(double iMN, string sOrderSymbol)
  {
   int total=OrdersTotal();
   int count=0;
   for(int cnt=0; cnt<=total; cnt++)
     {
      if(OrderGetTicket(cnt))
        {
         if(OrderGetInteger(ORDER_MAGIC)==iMN  && OrderGetString(ORDER_SYMBOL)==sOrderSymbol &&(OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP || OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT))
           {
            count++;
           }
        }
     }
   return(count);
  }
  
int TotalSellStop(double iMN, string sOrderSymbol)
  {
   int total=OrdersTotal();
   int count=0;
   for(int cnt=0; cnt<=total; cnt++)
     {
      if(OrderGetTicket(cnt))
        {
         if(OrderGetInteger(ORDER_MAGIC)==iMN  && OrderGetString(ORDER_SYMBOL)==sOrderSymbol &&(OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP || OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT))
           {
            count++;
           }
        }
     }
   return(count);
  }      
  
  int TotalBuy(double iMN, string sOrderSymbol,string cmm)
  {
   int total=PositionsTotal();
   int count=0;
   for(int cnt=0; cnt<=total; cnt++)
     {
      if(PositionGetTicket(cnt))
        {
         if(PositionGetInteger(POSITION_MAGIC)==iMN && PositionGetString(POSITION_COMMENT)==cmm  && PositionGetString(POSITION_SYMBOL)==sOrderSymbol &&(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY))
           {
            count++;
           }
        }
     }
   return(count);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TotalSell(double iMN, string sOrderSymbol,string cmm)
  {
   int total=PositionsTotal();
   int count=0;
   for(int cnt=0; cnt<=total; cnt++)
     {
      if(PositionGetTicket(cnt))
        {
         if(PositionGetInteger(POSITION_MAGIC)==iMN && PositionGetString(POSITION_COMMENT)==cmm && PositionGetString(POSITION_SYMBOL)==sOrderSymbol &&(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL))
           {
            count++;
           }
        }
     }
   return(count);
  }
  
  //+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
CDealInfo      m_deal;  
CTrade trade;


void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
  {
//---
   static int counter=0;   // counter of OnTradeTransaction() calls
   static uint lasttime=0; // time of the OnTradeTransaction() last call
//---
   uint time=GetTickCount();
//--- if the last transaction was performed more than 1 second ago,
   if(time-lasttime>1000)
     {
      counter=0; // then this is a new trade operation, an the counter can be reset
      if(IS_DEBUG_MODE)
         Print(" New trade operation");
     }
   lasttime=time;
   counter++;
   Print(counter,". ",__FUNCTION__);
//--- result of trade request execution
   ulong            lastOrderID   =trans.order;
   ENUM_ORDER_TYPE  lastOrderType =trans.order_type;
   ENUM_ORDER_STATE lastOrderState=trans.order_state;
//--- the name of the symbol, for which a transaction was performed
   string trans_symbol=trans.symbol;
   
   if (_Symbol!=trans.symbol){return;}
   
//--- type of transaction
   ENUM_TRADE_TRANSACTION_TYPE  trans_type=trans.type;
   
 
   switch(trans.type)
     {
      case  TRADE_TRANSACTION_POSITION:   // position modification
        {
         ulong pos_ID=trans.position;
         PrintFormat("MqlTradeTransaction: Position  #%d %s modified: SL=%.5f TP=%.5f",
                     pos_ID,trans_symbol,trans.price_sl,trans.price_tp);
        
        }
      break;
      case TRADE_TRANSACTION_REQUEST:     // sending a trade request
         PrintFormat("MqlTradeTransaction: TRADE_TRANSACTION_REQUEST");
         break;
      case TRADE_TRANSACTION_DEAL_ADD:    // adding a trade
        {
         ulong          lastDealID   =trans.deal;
         ENUM_DEAL_TYPE lastDealType =trans.deal_type;
         double        lastDealVolume=trans.volume;
         //--- Trade ID in an external system - a ticket assigned by an exchange
         string Exchange_ticket="";
         if(HistoryDealSelect(lastDealID))
            Exchange_ticket=HistoryDealGetString(lastDealID,DEAL_EXTERNAL_ID);
         if(Exchange_ticket!="")
            Exchange_ticket=StringFormat("(Exchange deal=%s)",Exchange_ticket);
 
                     
         if(HistoryDealSelect(trans.deal))
            m_deal.Ticket(trans.deal);
         else
           {
            Print(__FILE__," ",__FUNCTION__,", ERROR: HistoryDealSelect(",trans.deal,")");
            return;
           }
         //---
         long reason=-1;
         if(!m_deal.InfoInteger(DEAL_REASON,reason))
           {
            Print(__FILE__," ",__FUNCTION__,", ERROR: InfoInteger(DEAL_REASON,reason)");
            return;
           }
         if((ENUM_DEAL_REASON)reason==DEAL_REASON_SL && trans.deal_type == 0)
         {
              HistorySelectByPosition(0);
              
                string mes = "=== Close Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : SELL"
             +"\\nEntry Price : "+DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),_Digits)
             +"\\nTP : "+DoubleToString(trans.price_tp,_Digits)
             +"\\nSL : "+DoubleToString(trans.price_sl,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : Loss ("+StopLoss+")"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
         }
         else if((ENUM_DEAL_REASON)reason==DEAL_REASON_SL && trans.deal_type == 1)
         {
             HistorySelectByPosition(0);
             
                string mes = "=== Close Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : BUY"
             +"\\nEntry Price : "+DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),_Digits)
             +"\\nTP : "+DoubleToString(trans.price_tp,_Digits)
             +"\\nSL : "+DoubleToString(trans.price_sl,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : Loss ("+StopLoss+")"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
         }
         else
         {
            //Print(m_deal.Entry());
            
            if((ENUM_DEAL_REASON)reason==DEAL_REASON_TP && trans.deal_type == 0)
            {
              HistorySelectByPosition(0);
              
               string mes = "=== Close Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : SELL"
             +"\\nEntry Price : "+DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),_Digits)
             +"\\nTP : "+DoubleToString(trans.price_tp,_Digits)
             +"\\nSL : "+DoubleToString(trans.price_sl,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : Win ("+TakeProfit+")"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            } 
            else if((ENUM_DEAL_REASON)reason==DEAL_REASON_TP && trans.deal_type == 1)
            {
              HistorySelectByPosition(0);
              
               string mes = "=== Close Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : BUY"
             +"\\nEntry Price : "+DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),_Digits)
             +"\\nTP : "+DoubleToString(trans.price_tp,_Digits)
             +"\\nSL : "+DoubleToString(trans.price_sl,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : Win ("+TakeProfit+")"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
             
            } 
            else if(m_deal.Entry() == 0 && trans.deal_type == 0)
            {
            
             double profit = trans.price + _Point*TakeProfit;
             double stoploss = trans.price - _Point*StopLoss;
            
               if(TakeProfit == 0)
               {
                  profit = 0;
               }
               
               if(StopLoss == 0)
               {
                  stoploss = 0;
               }
            
               trade.PositionModify(m_deal.Order(),stoploss,profit);
               
           string mes = "=== Open Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : BUY"
             +"\\nEntry Price : "+DoubleToString(trans.price,_Digits)
             +"\\nTP : "+DoubleToString(profit,_Digits)
             +"\\nSL : "+DoubleToString(stoploss,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : None"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            } 
            else if(m_deal.Entry() == 0 && trans.deal_type == 1)
            {
             double profit = trans.price - _Point*TakeProfit;
             double stoploss = trans.price + _Point*StopLoss;
            
               if(TakeProfit == 0)
               {
                  profit = 0;
               }
               
               if(StopLoss == 0)
               {
                  stoploss = 0;
               }
              
               trade.PositionModify(m_deal.Order(),stoploss,profit);
               
              string mes = "=== Open Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : SELL"
             +"\\nEntry Price : "+DoubleToString(trans.price,_Digits)
             +"\\nTP : "+DoubleToString(profit,_Digits)
             +"\\nSL : "+DoubleToString(stoploss,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : None"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            } 
            else if(trans.deal_type == 1 && m_deal.Profit() >= 0)
            {
              HistorySelectByPosition(0);
              
               string mes = "=== Fast Close Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : BUY"
             +"\\nEntry Price : "+DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),_Digits)
             +"\\nTP : "+DoubleToString(trans.price_tp,_Digits)
             +"\\nSL : "+DoubleToString(trans.price_sl,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : Win ("+DoubleToString(MathAbs(trans.price-PositionGetDouble(POSITION_PRICE_OPEN))/_Point,2)+")"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            }
            else if(trans.deal_type == 1 && m_deal.Profit() < 0)
            {
              HistorySelectByPosition(0);
              
               string mes = "=== Fast Close Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : BUY"
             +"\\nEntry Price : "+DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),_Digits)
             +"\\nTP : "+DoubleToString(trans.price_tp,_Digits)
             +"\\nSL : "+DoubleToString(trans.price_sl,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : Loss ("+DoubleToString(MathAbs(trans.price-PositionGetDouble(POSITION_PRICE_OPEN))/_Point,2)+")"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            }
            else if(trans.deal_type == 0 && m_deal.Profit() >= 0)
            {
             HistorySelectByPosition(0);
             
                 string mes = "=== Fast Close Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : SELL"
             +"\\nEntry Price : "+DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),_Digits)
             +"\\nTP : "+DoubleToString(trans.price_tp,_Digits)
             +"\\nSL : "+DoubleToString(trans.price_sl,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : Win ("+DoubleToString(MathAbs(trans.price-trans.price_trigger)/_Point,2)+")"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            }
             else if(trans.deal_type == 0 && m_deal.Profit() < 0)
            {
             HistorySelectByPosition(0);
             
                 string mes = "=== Fast Close Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : SELL"
             +"\\nEntry Price : "+DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),_Digits)
             +"\\nTP : "+DoubleToString(trans.price_tp,_Digits)
             +"\\nSL : "+DoubleToString(trans.price_sl,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : Loss ("+DoubleToString(MathAbs(trans.price-PositionGetDouble(POSITION_PRICE_OPEN))/_Point,2)+")"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            }
             
         }          
        }
      break;
      case TRADE_TRANSACTION_HISTORY_ADD: // adding an order to the history
        {
         //--- order ID in an external system - a ticket assigned by an Exchange
         string Exchange_ticket="";
         if(lastOrderState==ORDER_STATE_FILLED)
           {
            if(HistoryOrderSelect(lastOrderID))
               Exchange_ticket=HistoryOrderGetString(lastOrderID,ORDER_EXTERNAL_ID);
            if(Exchange_ticket!="")
               Exchange_ticket=StringFormat("(Exchange ticket=%s)",Exchange_ticket);
           }
    //     PrintFormat("MqlTradeTransaction: %s order #%d %s %s %s   %s",EnumToString(trans_type),
        //             lastOrderID,EnumToString(lastOrderType),trans_symbol,EnumToString(lastOrderState),Exchange_ticket);
          /*  if(UseClose && lastOrderType == 0)
            {
                  string mes = "=== Close Order === "
             +"\\n\\nSymbol : "+trans_symbol
             +"\\n\\nLot Size :"+DoubleToString(trans.volume,2)
             +"\\n\\nPrice : "+DoubleToString(trans.price,_Digits)
             +"\\n\\n=========================="
             +"\\n\\nTrader : "+Username
             +"\\n\\n==========================";
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            }*/
        }
      break;
      default: // other transactions  
        {
         if(trans.order_state == 1)
         {
           if(lastOrderType == ORDER_TYPE_BUY_LIMIT)
            {
             double profit = trans.price + _Point*TakeProfit;
             double stoploss = trans.price - _Point*StopLoss;
            
               if(TakeProfit == 0)
               {
                  profit = 0;
               }
               
               if(StopLoss == 0)
               {
                  stoploss = 0;
               }
            
             trade.OrderModify(trans.order,trans.price,stoploss,profit,0,0);
               
           string mes = "=== Pending Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : BUY LIMIT"
             +"\\nPending Price : "+DoubleToString(trans.price,_Digits)
             +"\\nTP : "+DoubleToString(profit,_Digits)
             +"\\nSL : "+DoubleToString(stoploss,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : None"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
            // Print(Exchange_ticket);
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            } 
            else if(lastOrderType == ORDER_TYPE_BUY_STOP)
            {
             double profit = trans.price + _Point*TakeProfit;
             double stoploss = trans.price - _Point*StopLoss;
            
               if(TakeProfit == 0)
               {
                  profit = 0;
               }
               
               if(StopLoss == 0)
               {
                  stoploss = 0;
               }
            
               trade.OrderModify(trans.order,trans.price,stoploss,profit,0,0);
               
           string mes = "=== Pending Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : BUY STOP"
             +"\\nPending Price : "+DoubleToString(trans.price,_Digits)
             +"\\nTP : "+DoubleToString(profit,_Digits)
             +"\\nSL : "+DoubleToString(stoploss,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : None"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
            // Print(mes);
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            } 
            else if(lastOrderType == ORDER_TYPE_SELL_LIMIT)
            {
             double profit = trans.price - _Point*TakeProfit;
             double stoploss = trans.price + _Point*StopLoss;
            
               if(TakeProfit == 0)
               {
                  profit = 0;
               }
               
               if(StopLoss == 0)
               {
                  stoploss = 0;
               }
            
              trade.OrderModify(trans.order,trans.price,stoploss,profit,0,0);
               
           string mes = "=== Pending Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : SELL LIMIT"
             +"\\nPending Price : "+DoubleToString(trans.price,_Digits)
             +"\\nTP : "+DoubleToString(profit,_Digits)
             +"\\nSL : "+DoubleToString(stoploss,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : None"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
            // Print(mes);
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            } 
            else if(lastOrderType == ORDER_TYPE_SELL_STOP)
            {
             double profit = trans.price - _Point*TakeProfit;
             double stoploss = trans.price + _Point*StopLoss;
            
               if(TakeProfit == 0)
               {
                  profit = 0;
               }
               
               if(StopLoss == 0)
               {
                  stoploss = 0;
               }
            
              trade.OrderModify(trans.order,trans.price,stoploss,profit,0,0);
               
           string mes = "=== Pending Order === "
             +"\\nSymbol : "+trans_symbol
             +"\\nPosition : SELL STOP"
             +"\\nPending Price : "+DoubleToString(trans.price,_Digits)
             +"\\nTP : "+DoubleToString(profit,_Digits)
             +"\\nSL : "+DoubleToString(stoploss,_Digits)
             +"\\n\\nDate : "+TimeToString(TimeCurrent(),TIME_DATE)
             +"\\nTime : "+TimeToString(TimeCurrent(),TIME_MINUTES)
             +"\\nWin/Loss : None"
             +"\\n====================="
             +"\\nTrader : "+Username;
             
            // Print(mes);
             
             if(UseTelegram){MessagingAPI(mes, activePackages);}
            } 
        //  Print(trans.type + "//" + lastOrderType);
         //--- order ID in an external system - a ticket assigned by Exchange
         string Exchange_ticket="";
         if(lastOrderState==ORDER_STATE_PLACED)
           {
            if(OrderSelect(lastOrderID))
               Exchange_ticket=OrderGetString(ORDER_EXTERNAL_ID);
            if(Exchange_ticket!="")
               Exchange_ticket=StringFormat("Exchange ticket=%s",Exchange_ticket);
           }
         PrintFormat("MqlTradeTransaction: %s order #%d %s %s   %s",EnumToString(trans_type),
                    lastOrderID,EnumToString(lastOrderType),EnumToString(lastOrderState),Exchange_ticket);
        }
       }
      break;
     }
//--- order ticket    
   ulong orderID_result=result.order;
   string retcode_result=GetRetcodeID(result.retcode);
   if(orderID_result!=0)
   {
         PrintFormat("MqlTradeResult: order #%d retcode=%s ",orderID_result,retcode_result);
   }  
//---   
  }
//+------------------------------------------------------------------+
//| convert numeric response codes to string mnemonics               |
//+------------------------------------------------------------------+
string GetRetcodeID(int retcode)
  {
   switch(retcode)
     {
      case 10004: return("TRADE_RETCODE_REQUOTE");             break;
      case 10006: return("TRADE_RETCODE_REJECT");              break;
      case 10007: return("TRADE_RETCODE_CANCEL");              break;
      case 10008: return("TRADE_RETCODE_PLACED");              break;
      case 10009: return("TRADE_RETCODE_DONE");                break;
      case 10010: return("TRADE_RETCODE_DONE_PARTIAL");        break;
      case 10011: return("TRADE_RETCODE_ERROR");               break;
      case 10012: return("TRADE_RETCODE_TIMEOUT");             break;
      case 10013: return("TRADE_RETCODE_INVALID");             break;
      case 10014: return("TRADE_RETCODE_INVALID_VOLUME");      break;
      case 10015: return("TRADE_RETCODE_INVALID_PRICE");       break;
      case 10016: return("TRADE_RETCODE_INVALID_STOPS");       break;
      case 10017: return("TRADE_RETCODE_TRADE_DISABLED");      break;
      case 10018: return("TRADE_RETCODE_MARKET_CLOSED");       break;
      case 10019: return("TRADE_RETCODE_NO_MONEY");            break;
      case 10020: return("TRADE_RETCODE_PRICE_CHANGED");       break;
      case 10021: return("TRADE_RETCODE_PRICE_OFF");           break;
      case 10022: return("TRADE_RETCODE_INVALID_EXPIRATION");  break;
      case 10023: return("TRADE_RETCODE_ORDER_CHANGED");       break;
      case 10024: return("TRADE_RETCODE_TOO_MANY_REQUESTS");   break;
      case 10025: return("TRADE_RETCODE_NO_CHANGES");          break;
      case 10026: return("TRADE_RETCODE_SERVER_DISABLES_AT");  break;
      case 10027: return("TRADE_RETCODE_CLIENT_DISABLES_AT");  break;
      case 10028: return("TRADE_RETCODE_LOCKED");              break;
      case 10029: return("TRADE_RETCODE_FROZEN");              break;
      case 10030: return("TRADE_RETCODE_INVALID_FILL");        break;
      case 10031: return("TRADE_RETCODE_CONNECTION");          break;
      case 10032: return("TRADE_RETCODE_ONLY_REAL");           break;
      case 10033: return("TRADE_RETCODE_LIMIT_ORDERS");        break;
      case 10034: return("TRADE_RETCODE_LIMIT_VOLUME");        break;
      case 10035: return("TRADE_RETCODE_INVALID_ORDER");       break;
      case 10036: return("TRADE_RETCODE_POSITION_CLOSED");     break;
      default:
         return("TRADE_RETCODE_UNKNOWN="+IntegerToString(retcode));
         break;
     }
//---
  }






// Function to send message via LINE Messaging API
void MessagingAPI(string message, string package)
  {
   string headers;
   char post[], result[];

   // Construct headers 
   headers = "Content-Type: application/json\r\n";

   // Prepare the JSON body
   string jsonBody = "{\"message\":\"" + message + "\",\"package\":\"" + package + "\"}";
   ArrayResize(post, StringToCharArray(jsonBody, post, 0, WHOLE_ARRAY, CP_UTF8) - 1);

   // Perform the WebRequest
   int res = WebRequest("POST", ApiUrl, headers, 10000, post, result, headers);

   // Check if the request was successful
   if (res != 200) 
   {
      Print("Failed to send message. Status code: ", res, ", error: ", GetLastError());
      return;
   }

   // Print the server response if successful
   Print("Message sent successfully. Server response: ", CharArrayToString(result));
  }
